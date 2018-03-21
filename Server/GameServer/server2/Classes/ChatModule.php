<?php
require_once($GLOBALS['GAME_ROOT'] . "CMemcache.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerChat.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerCacheModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/ConsumeModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/NotifyModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/ArenaModule.php");
define('DAY_CHAT_COUNT', 10);
define('WORLD_CHAT_PRICE', 5);


define('MEMCACHE_KEY_CHAT', 'mc_chat_');
define('MEMCACHE_KEY_WORLD_CHAT_ID', 'mc_chat_world_id');
define('MEMCACHE_KEY_GUILD_CHAT_ID', 'mc_chat_guild_id_');
define('MEMCACHE_KEY_PERSONAL_CHAT_ID', 'mc_chat_personal_id_');
define('MEMCACHE_KEY_CHAT_REFRESG_TIME', 'mc_chat_refresh_');

class ChatModule
{
	public static function getChatTable($userId)
    {
        $sysChat = new SysPlayerChat();
        $sysChat->setUserId($userId);
        if ($sysChat->loaded()) {
            if (SQLUtil::isTimeNeedReset($sysChat->getLastResetTime())) { //次数跨天重置
                $sysChat->setLastResetTime(time());
                $sysChat->setWorldChatTimes(DAY_CHAT_COUNT);
                $sysChat->save();
            }
        } else {
            $sysChat->setLastResetTime(time());
            $sysChat->setWorldChatTimes(DAY_CHAT_COUNT);
            $sysChat->inOrUp();
        }

        return $sysChat;
    }

    public static function getChatDownInfo($userId)
    {
        $sysChat = self::getChatTable($userId);
        $downChatInfo = new Down_Chat();
        $downChatInfo->setWorldChatTimes($sysChat->getWorldChatTimes());
        $downChatInfo->setLastResetWorldChatTime($sysChat->getLastResetTime());

        return $downChatInfo;
    }

    
    public static function getMemCacheMaxID($key)
    {
        $id = CMemcache::getInstance()->getData($key);
        if (!empty($id)) {
            CMemcache::getInstance()->increment($key, 1);
            return $id;
        }
        $id = 1;
        CMemcache::getInstance()->setData($key, 2);
        return $id;
    }

    public static function chat($userId, $targetId, $channel, $type, $content, $accesory)
    {
        $curTime = time();

        $guildID = PlayerCacheModule::getGuildId($userId);
        $chat_content = new Down_ChatContent();

        $speakerSummary = PlayerModule::getUserSummaryObj($userId);
        $chat_content->setSpeakerUid($userId);
        $chat_content->setSpeakerSummary($speakerSummary);

        if ($targetId) {
            $targetSummary = PlayerModule::getUserSummaryObj($targetId);
            $chat_content->setTargetUid($targetId);
            $chat_content->setTargetSummary($targetSummary);
        }

        $chat_content->setSpeakerPost(PlayerCacheModule::getGuildPost($userId)); //职位
        $chat_content->setSpeakTime($curTime);
        $chat_content->setContentType($type);
        $chat_content->setContent($content);

        $acc = array();
        if (isset($accesory)) {
            $acc[] = $accesory->getType();
            if ($accesory->getType() == Up_ChatAcc_ChatAccT::binary) {
                $acc[] = $accesory->getBinary();
            } else {
                $acc[] = $accesory->getRecordId();
            }
        }

        if ($channel == Down_ChatChannel::world_channel) { //世界聊天
            $chat_content->setChatId(self::getMaxWorldChatID($userId));
            $sysChat = self::getChatTable($userId);
            if ($sysChat->getWorldChatTimes() <= 0) { //没有免费次数了
                ConsumeModule::buy($userId, PRICE_TYPE::diamond, WORLD_CHAT_PRICE, array("world_chat" => WORLD_CHAT_PRICE));
            } else {
                $sysChat->setWorldChatTimes($sysChat->getWorldChatTimes() - 1);
                $sysChat->save();
            }
        } else if ($channel == Down_ChatChannel::guild_channel) {  //公会聊天
            $chat_content->setChatId(self::getMaxGuildChatID($userId, $guildID));
            NotifyModule::addGuildChatNotify($guildID);
        }
        else if ($channel == Down_ChatChannel::personal_channel){   //私聊 
            $chat_content->setChatId(self::getMaxPersonalChatID($userId, $targetId));
        }
        Logger::getLogger()->debug("chat : channel = " . $channel . ",guild = " . $guildID . ",max_id = " . $chat_content->getChatId());

        $lastRefreshChatID = PlayerCacheModule::getLastRefreshChatID($userId, $channel);
        if ($chat_content->getChatId() < $lastRefreshChatID) {
            PlayerCacheModule::setLastRefreshChatID($userId, $channel, $chat_content->getChatId());
        }
        if ($channel == Down_ChatChannel::personal_channel)
        {
            self::pushChatContent($userId, $guildID, $channel, $chat_content, $acc, $userId);
            self::pushChatContent($userId, $guildID, $channel, $chat_content, $acc, $targetId);
        }
        else
        {
            self::pushChatContent($userId, $guildID, $channel, $chat_content, $acc);
        }
        
        return true;
    }

    public static function getMaxGuildChatID($userId, $guildId)
    {
    	return self::getMemCacheMaxID(MEMCACHE_KEY_GUILD_CHAT_ID . PlayerCacheModule::getServerID($userId) . $guildId);
    }
    
    public static function getMaxWorldChatID($userId)
    {
    	return self::getMemCacheMaxID(MEMCACHE_KEY_WORLD_CHAT_ID . PlayerCacheModule::getServerID($userId));
    }
    
    public static function getMaxPersonalChatID($userId, $targetId)
    {
        return self::getMemCacheMaxID(MEMCACHE_KEY_PERSONAL_CHAT_ID . PlayerCacheModule::getServerID($userId) . $targetId);
    }
    
    public static function refresh($userId, $channel)
    {
        $guildID = PlayerCacheModule::getGuildId($userId);
        $lastRefreshChatID = PlayerCacheModule::getLastRefreshChatID($userId, $channel);
        $key = MEMCACHE_KEY_CHAT . PlayerCacheModule::getServerID($userId) . "_" . $channel;
        if ($channel == Down_ChatChannel::guild_channel) {
            $key .= $guildID;
        }
        if ($channel == Down_ChatChannel::personal_channel) {
            $key .= $userId;
        }
        $chats = CMemcache::getInstance()->getData($key);
        $reply = array();
        $count = 0;
        $max_id = 0;
        if (!empty($chats)) {
            krsort($chats);
            foreach ($chats as $id => $chat) {
                if ($chat[0]->getChatId() <= $lastRefreshChatID) {
                    continue;
                }
                array_push($reply, $chat[0]);
                if ($max_id < $chat[0]->getChatId()) {
                    $max_id = $chat[0]->getChatId();
                }
                $count++;
                if ($count >= 10) {
                    break;
                }
            }
        }
        Logger::getLogger()->debug("refresh : channel = " . $channel . ",guild = " . $guildID . ",max_id = " . $max_id);
        if ($count > 0 && $max_id > $lastRefreshChatID) {
            PlayerCacheModule::setLastRefreshChatID($userId, $channel, $max_id);
        }
        $reply = array_reverse($reply);
        return $reply;
    }


    public static function pushChatContent($userId, $guildID, $channel, Down_ChatContent $content, $accesory, $targetId = null)
    {
        $key = MEMCACHE_KEY_CHAT . PlayerCacheModule::getServerID($userId) . "_" . $channel;
        if ($channel == Down_ChatChannel::guild_channel) {
            $key .= $guildID;
        }
        if ($channel == Down_ChatChannel::personal_channel) {
            $key .= $targetId;
        }
        $chats = CMemcache::getInstance()->getData($key);
        if (empty($chats) || ($content->getChatId() < count($chats))) {
            $chats = array();
        }
        $chats[$content->getChatId()] = array($content, $accesory);
        return CMemcache::getInstance()->setData($key, $chats);
    }

    public static function fetch($userId, $channel, $chatID)
    {
        $reply = new Down_ChatFetch();
        $reply->setChannel($channel);
        $reply->setChatId($chatID);


        $guildID = PlayerCacheModule::getGuildId($userId);
        $key = MEMCACHE_KEY_CHAT . PlayerCacheModule::getServerID($userId) . "_" . $channel;
        if ($channel == Down_ChatChannel::guild_channel) {
            $key .= $guildID;
        }
        $chats = CMemcache::getInstance()->getData($key);
        if (!empty($chats)) {
            $chat = $chats[$chatID];
            $acc = new Down_ChatAcc();
            $acc->setType($chat[1][0]);
            if ($chat[1][0] == Down_ChatAcc_ChatAccT::binary) {
                $acc->setBinary($chat[1][1]);
            } else {
                $pvp = ArenaModule::getArenaPvpRecordByID($chat[1][1]);
                $acc->setReplay($pvp);
            }
            $reply->setAccessory($acc);
        }
        return $reply;
    }

}