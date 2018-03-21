<?php
require_once($GLOBALS['GAME_ROOT'] . "CMemcache.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");

define('MEMCACHE_KEY_PLAYER_CACHE', 'mc_player_');
define('MEMCACHE_EXPIRE_TIME', 86400);

class PlayerCacheModule
{
    private static $UserInfoCached = array();
    private static $LevelCached = array();
    private static $NameCached = array();
    private static $ServerIdCached = array();
    private static $LastLoginTimeCached = array();
    private static $RegTimeCached = array();
    private static $GuildIdCached = array();
    private static $GuildNameCached = array();
    private static $GuildPostCached = array();
    private static $UserSummaryCached = array();
    private static $SettingsCached = array();

    private static function setData($userID, $key, $val)
    {
        $key = MEMCACHE_KEY_PLAYER_CACHE . $userID . "_" . $key;
        CMemcache::getInstance()->setData($key, $val, MEMCACHE_EXPIRE_TIME); //默认24个小时过期
    }

    private static function getData($userID, $key, $default = null)
    {
        $key = MEMCACHE_KEY_PLAYER_CACHE . $userID . "_" . $key;
        $val = CMemcache::getInstance()->getData($key);
        if (empty($val) && isset($default)) {
            $val = $default;
        }
        return $val;
    }

    public static function reset($userId)
    {
        //需要在登录时重置的数据在这里初始化
        self::setLastRefreshChatID($userId, Down_ChatChannel::world_channel, 0);
        self::setLastRefreshChatID($userId, Down_ChatChannel::guild_channel, 0);
    }

    public static function setUserInfo($uin, SysUser $sysUser, $setMem = true)
    {
        self::$UserInfoCached [$uin] = $sysUser;

        if ($setMem) {
            self::setData($uin, "user_info", $sysUser);
        }
    }

    public static function getUserInfo($uin, $updateMem = 0)
    {
        if (isset (self::$UserInfoCached [$uin])) {
            return self::$UserInfoCached [$uin];
        }

        $hasMem = true;
        if ($updateMem == 1) {
            $tbUser = null;
        } else {
            $tbUser = self::getData($uin, "user_info");
        }
        if (empty($tbUser)) {
            // get session key
            $tbUser = new SysUser();
            $tbUser->setUin($uin);
            if (!$tbUser->loaded()) {
                return null;
            }
            $hasMem = false;
        }

        self::setUserInfo($uin, $tbUser, !$hasMem);
        return $tbUser;
    }
    
    public static function getUinById($userId)
    {
    	$tbUserServer = new SysUserServer();
    	$tbUserServer->setUserId($userId);
    	$tbUserServer->loaded(array('uin'));
    	return $tbUserServer->getUin();
    }


    public static function getUserInfoData($centerID, $updateMem = 0)
    {
    
    		// get session key
    		$tbUser = new SysUser();
            $where = "`game_center_id` = '{$centerID}'";
            if (!$tbUser->loaded("*",$where))
            {
                 return null;
            }
    		$hasMem = false;
    
    
    	self::setUserInfo($tbUser->getUin(), $tbUser, !$hasMem);
    	return $tbUser;
    }
    public static function getUserServerInfoData($uin, $updateMem = 0,$serverId)
    {
    	// get session key
    	$TbUserServer = new SysUserServer();
    	$TbUserServer->setUin($uin);
        $where = "`uin` = '{$uin}' and `server_id` = '{$serverId}'";
        if (!$TbUserServer->loaded("*",$where))
        {
            return null;
    	}
    	$hasMem = false;
//     	self::setUserInfo($tbUser->uin, $tbUser, !$hasMem);
    	return $TbUserServer;
    }
    
    public static function setServerID($userId, $serverId, $setMem = true)
    {
        self::$ServerIdCached [$userId] = $serverId;

        if ($setMem) {
            self::setData($userId, "server_id", $serverId);
        }
    }

    public static function getServerID($userId)
    {
        if (isset (self::$ServerIdCached [$userId])) {
            return self::$ServerIdCached [$userId];
        }

        $hasMem = true;
        $serverId = self::getData($userId, "server_id");
        if (empty($serverId)) {
            $tbPlayer = PlayerModule::getPlayerTable($userId);
            $serverId = $tbPlayer->getServerId();
            $hasMem = false;
        }

        self::setServerID($userId, $serverId, !$hasMem);
        return $serverId;
    }

    public static function setPlayerLevel($userId, $level, $setMem = true)
    {
        self::$LevelCached [$userId] = $level;

        if ($setMem) {
            self::setData($userId, "level", $level);
        }
    }

    public static function getPlayerLevel($userId)
    {
        if (isset (self::$LevelCached [$userId])) {
            return self::$LevelCached [$userId];
        }

        $hasMem = true;
        $level = self::getData($userId, "level");
        if (empty($level)) {
            $tbPlayer = PlayerModule::getPlayerTable($userId);
            $level = $tbPlayer->getLevel();
            $hasMem = false;
        }

        self::setPlayerLevel($userId, $level, !$hasMem);
        return $level;
    }

    public static function setPlayerName($userId, $name, $setMem = true)
    {
        self::$NameCached [$userId] = $name;

        if ($setMem) {
            self::setData($userId, "name", $name);
        }
    }

    public static function getPlayerName($userId)
    {
        if (isset (self::$NameCached [$userId])) {
            return self::$NameCached [$userId];
        }

        $hasMem = true;
        $name = self::getData($userId, "name");
        if (empty($name)) {
            $tbPlayer = PlayerModule::getPlayerTable($userId);
            $name = $tbPlayer->getNickname();
            $hasMem = false;
        }

        self::setPlayerName($userId, $name, !$hasMem);
        return $name;
    }

    public static function setLastLoginTime($userId, $time, $setMem = true)
    {
        self::$LastLoginTimeCached [$userId] = $time;

        if ($setMem) {
            self::setData($userId, "LastLoginTime", $time);
        }
    }

    public static function getLastLoginTime($userId)
    {
        if (isset (self::$LastLoginTimeCached [$userId])) {
            return self::$LastLoginTimeCached [$userId];
        }

        $hasMem = true;
        $time = self::getData($userId, "LastLoginTime");
        if (empty($time)) {
            require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysUserServer.php");
            $tbServer = new SysUserServer();
            $tbServer->setUserId($userId);
            if ($tbServer->loaded(array("last_login_time"))) {
                $time = $tbServer->getLastLoginTime();
            } else {
                $time = 0;
            }
            $hasMem = false;
        }

        self::setLastLoginTime($userId, $time, !$hasMem);
        return $time;
    }

    public static function setRegTime($userId, $time, $setMem = true)
    {
        self::$RegTimeCached [$userId] = $time;

        if ($setMem) {
            self::setData($userId, "RegTime", $time);
        }
    }

    public static function getRegTime($userId)
    {
        if (isset (self::$RegTimeCached [$userId])) {
            return self::$RegTimeCached [$userId];
        }

        $hasMem = true;
        $time = self::getData($userId, "RegTime");
        if (empty($time)) {
            require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysUserServer.php");
            $tbServer = new SysUserServer();
            $tbServer->setUserId($userId);
            if ($tbServer->loaded(array("reg_time"))) {
                $time = $tbServer->getRegTime();
            } else {
                $time = 0;
            }
            $hasMem = false;
        }

        self::setRegTime($userId, $time, !$hasMem);
        return $time;
    }

    /**
     * 删除用户的公会信息缓存
     *
     * @param $userId
     */
    public static function deleteGuildCache($userId)
    {
        $keyArr = array("guild_id", "guild_post", "guild_name");

        $mem = CMemcache::getInstance();
        foreach ($keyArr as $key_) {
            $key = MEMCACHE_KEY_PLAYER_CACHE . $userId . "_" . $key_;
            $mem->deleteData($key);
        }
    }

    public static function setGuildId($userId, $id, $setMem = true)
    {
        self::$GuildIdCached [$userId] = $id;

        if ($setMem) {
            self::setData($userId, "guild_id", $id);
        }
    }

    public static function getGuildId($userId)
    {
        if (isset (self::$GuildIdCached [$userId])) {
            return self::$GuildIdCached [$userId];
        }

        $hasMem = true;
        $guildId = self::getData($userId, "guild_id");
        if (empty($guildId)) {
            $tbPlyGuild = GuildModule::getTbPlayerGuild($userId);
            if ($tbPlyGuild->getGuildId() > 0) {
                $guildId = $tbPlyGuild->getGuildId();
            } else {
                $guildId = 0;
            }
            $hasMem = false;
        }

        self::setGuildId($userId, $guildId, !$hasMem);
        return $guildId;
    }

    public static function setGuildPost($userId, $post, $setMem = true)
    {
        self::$GuildPostCached [$userId] = $post;

        if ($setMem) {
            self::setData($userId, "guild_post", $post);
        }
    }

    public static function getGuildPost($userId)
    {
        if (isset (self::$GuildPostCached [$userId])) {
            return self::$GuildPostCached [$userId];
        }

        $hasMem = true;
        $guildPost = self::getData($userId, "guild_post");
        if (empty($guildPost)) {
            $tbPlyGuild = GuildModule::getTbPlayerGuild($userId);
            if ($tbPlyGuild->getGuildId() > 0) {
                $guildPost = $tbPlyGuild->getGuildPosition();
            } else {
                $guildPost = 0;
            }
            $hasMem = false;
        }

        self::setGuildPost($userId, $guildPost, !$hasMem);
        return $guildPost;
    }

    public static function setGuildName($userId, $name, $setMem = true)
    {
        self::$GuildNameCached [$userId] = $name;

        if ($setMem) {
            self::setData($userId, "guild_name", $name);
        }
    }

    public static function getGuildName($userId)
    {
        if (isset (self::$GuildNameCached [$userId])) {
            return self::$GuildNameCached [$userId];
        }

        $hasMem = true;
        $guildName = self::getData($userId, "guild_name");
        if (empty($guildName)) {
            $guildName = "";
            $guildId = self::getGuildId($userId);
            if ($guildId > 0) {
                $tbGuild = GuildModule::getTbGuildInfo($guildId);
                if ($tbGuild->getGuildName()) {
                    $guildName = $tbGuild->getGuildName();
                }
            }
            $hasMem = false;
        }

        self::setGuildName($userId, $guildName, !$hasMem);
        return $guildName;
    }
	public static function getGuildPosition($userId)
	{
		$SysPlayerGuildInfo = new SysPlayerGuild();
		$SysPlayerGuildInfo->setUserId($userId);
		$PositionContent = null;
		if ($SysPlayerGuildInfo->loaded())
		{
			$Position=$SysPlayerGuildInfo->getGuildPosition();
			if($Position==1)
			{
				$PositionContent='会长';
			}
			elseif($Position==2)
			{
				$PositionContent='普通成员';
			}
			elseif($Position==3)
			{
				$PositionContent='长老';
			}
		}
		return $PositionContent;
	}
    public static function setLastRefreshChatID($userID, $channel, $val)
    {
        self::setData($userID, "chat_id_" . $channel, $val);
    }

    public static function getLastRefreshChatID($userID, $channel)
    {
        return self::getData($userID, "chat_id_" . $channel, 0);
    }

    public static function setUserSummary($userId, $summary)
    {
        self::$UserSummaryCached [$userId] = $summary;
        self::setData($userId, "summary", $summary);
    }

    public static function getUserSummary($userId)
    {
        if (isset (self::$UserSummaryCached [$userId])) {
            return self::$UserSummaryCached [$userId];
        }

        $summary = self::getData($userId, "summary");
        return $summary;
    }

    public static function setSettings($uin, $settings, $setMem = true)
        {
            self::$SettingsCached [$uin] = $settings;

            if ($setMem) {
                self::setData($uin, "UserSettings", $settings);
            }
        }

        public static function getSettings($uin)
        {
            if (isset (self::$SettingsCached [$uin])) {
                return self::$SettingsCached [$uin];
            }

            $hasMem = true;
            $settings = self::getData($uin, "UserSettings");
            if (empty($time)) {
                require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysUserSettings.php");
                $sysSettings = new SysUserSettings();

                $sysSettings->setUin($uin);
                if ($sysSettings->loaded(array("settings"))) {
                    $settings = $sysSettings->getSettings();
                } else {
                    $settings = "";
                }
                $hasMem = false;
            }

            self::setSettings($uin, $settings, !$hasMem);
            return $settings;
        }

}
 
