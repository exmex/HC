<?php
/**
 * Author: jay
 * Date: 2015-01-10
 * 
 */
require_once($GLOBALS['GAME_ROOT'] . "Classes/MathUtil.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/ItemModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/NotifyModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/DataModule.php");;
require_once($GLOBALS['GAME_ROOT'] . "Classes/HeroModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/MailTemplateModule.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerMail.php");
require_once($GLOBALS['GAME_ROOT'] . "LocalString.php");

class MailModule{
    const MailExpire = 2592000;
    /**
     * 用户服务id
     * @return [int] 
     */
    private static function getServerId(){
        if (!empty($_SERVER['FASTCGI_PLAYER_SERVER'])) {
            $serverId = intval($_SERVER['FASTCGI_PLAYER_SERVER']);
        } else {
            $serverId = 0;
        }
        return $serverId;
    }

    /**
     * 用户邮件
     * @param  [int] $userId [用户id]
     * @return [array]         
     */
    public static function getMailList($userId){
        $curTime = time();
        $serverId=self::getServerId();
        $regTime = PlayerCacheModule::getRegTime($userId);
       
        $where = "((`user_id` = '{$userId}' or `user_id` = 0) and `expire_time` >= '{$curTime}') and (server_id = 0 or server_id = '{$serverId}') and `mail_time` >= '{$regTime}'";
        $allMailInfo = SysPlayerMail::loadedTable(null, $where);
        $allMail = array();
        $sysMails = array();
        foreach ($allMailInfo as $Mail) {
            if ($Mail->getSid() > 0) {
                $sysMails[] = $Mail->getSid();
            }
        }
        foreach ($allMailInfo as $Mail) {
            if (in_array($Mail->getId(), $sysMails)) { //是已读系统邮件
                continue;
            }
            if ($Mail->getStatus() == Down_SysMail_Status::delete) {
                continue;
            }
            $userMail = self::getSysMailDownInfo($Mail);
            $allMail[] = $userMail;
        }
        return $allMail;
    }

    /**
     * 已读邮件的数量
     * @param  [int] $userId [description]
     * @return [int]         [description]
     */
    public static function checkNewMail($userId){
        $curTime = time();
        $serverId=self::getServerId();
        $regTime = PlayerCacheModule::getRegTime($userId);
        $where = "((`user_id` = '{$userId}' or `user_id` = 0) and `expire_time` >= '{$curTime}') and (server_id = 0 or server_id = '{$serverId}') and `mail_time` >= '{$regTime}'";
        $allMailInfo = SysPlayerMail::loadedTable(array("id", "sid", "user_id", "status"), $where);
        $sysMails = array();
        foreach ($allMailInfo as $userMail) {
            if ($userMail->getSid() > 0) {
                $sysMails[] = $userMail->getSid();
            }
        }
        $count = 0;
        //是已读系统邮件，跳过
        foreach ($allMailInfo as $userMail) {
            if (in_array($userMail->getId(), $sysMails)) { 
                continue;
            }
            if ($userMail->getStatus() == 0) {
                $count++;
            }
        }
        return $count;
    }

    /**
     * 读邮件
     * @param  [type] $userId [description]
     * @param  [type] $id     [description]
     * @return [type]         [description]
     */
    public static function readMail($userId, $id){
        $where = "`id` = '{$id}'";
        $userMails = SysPlayerMail::loadedTable(null, $where);
        if (sizeof($userMails) > 0) {
            $curTime = time();
            $userMails = $userMails[0];
            // 如果是系统邮件,先判断自己是否已经读过
            if ($userMails->getUserId() == 0) {
                $readedMail = new SysPlayerMail();
                $readedMail->setUserId($userId);
                $readedMail->setSid($id);
                if ($readedMail->loadFromExistFields()) {
                    return Down_Result::fail;
                }
            } else {
                // 判断是否为自己的邮件
                if ($userMails->getUserId() != $userId) {
                    return Down_Result::fail;
                }
                // 判断邮件状态是否为未读
                if ($userMails->getStatus() != Down_SysMail_Status::unread) {
                    return Down_Result::fail;
                }
            }
            $mail = self::getSysMailDownInfo($userMails);
            $reward = false;
           if ($mail->getExpireTime() > $curTime) {
                if ($mail->getMoney() > 0) {
                    $reward = true;
                    PlayerModule::modifyMoney($userId, $mail->getMoney(), "MailID=" . $id);
                }
                if ($mail->getDiamonds() > 0) {
                    $reward = true;
                    PlayerModule::modifyGem($userId, $mail->getDiamonds(), "MailID=" . $id);
                }
                if ($mail->getPointsCount() > 0) {
                    $reward = true;
                    $it = $mail->getPointsIterator();
                    while ($it->valid()) {
                        $type = $it->current()->getType();
                        $val = $it->current()->getValue();
                        if ($val > 0) {
                            if ($type == Down_UserPoint_UserPointType::arenapoint) {
                                PlayerModule::modifyArenaPoint($userId, $val, "MailID=" . $id);
                            }
                            if ($type == Down_UserPoint_UserPointType::crusadepoint) {
                                PlayerModule::modifyCrusadePoint($userId, $val, "MailID=" . $id);
                            }
                            if ($type == Down_UserPoint_UserPointType::guildpoint) {
                                PlayerModule::modifyGuildPoint($userId, $val, "MailID=" . $id);
                            }
                        }
                        $it->next();
                    }
                }
                if ($mail->getItemsCount() > 0) {
                    $reward = true;
                    $it = $mail->getItemsIterator();
                    while ($it->valid()) {
                        $itemId = MathUtil::bits($it->current(), 0, 10);
                        $amount = MathUtil::bits($it->current(), 10, 11);
                        if (ItemModule::getItemType($itemId) == "hero") {
                            HeroModule::addPlayerHero($userId, $itemId, "readMail");
                        } else {
                            ItemModule::addItem($userId, array($itemId => $amount), "MailID=" . $id);
                        }
                        $it->next();
                    }
                }

                if ($reward) {
                    //$tbMail->setExpireTime(0);
                    $userMails->setStatus(Down_SysMail_Status::delete);
                } else {
                    $userMails->setStatus(Down_SysMail_Status::read);
                }

                if ($userMails->getUserId() == 0) { //系统邮件
                    $userMails->setUserId($userId);
                    $userMails->setSid($id);
                    $userMails->setIdNull();
                    $userMails->setContent($userMails->getContent());
                    $userMails->setExpireTime($userMails->getExpireTime());
                    $userMails->setMailTime($userMails->getMailTime());
                    $userMails->inOrUp();
                } else {
                    $userMails->Save();
                }
                return Down_Result::success;
            }
        }
        return Down_Result::fail;
    }

    /**
     * 修改用户记分点
     * @param [int] $userId [description]
     * @param [int] $val    [description]
     * @param [int] $id     [description]
     */
    private static function setUserPoint($mail,$userId,$val,$id){
        $object = $mail->getPointsIterator();
        while ($object->valid()) {
            $type = $object->current()->getType();
            $val = $object->current()->getValue();
            if ($val > 0) {
                if ($type == Down_UserPoint_UserPointType::arenapoint) {
                    PlayerModule::modifyArenaPoint($userId, $val, "MailID=" . $id);
                }
                if ($type == Down_UserPoint_UserPointType::crusadepoint) {
                    PlayerModule::modifyCrusadePoint($userId, $val, "MailID=" . $id);
                }
                if ($type == Down_UserPoint_UserPointType::guildpoint) {
                    PlayerModule::modifyGuildPoint($userId, $val, "MailID=" . $id);
                }
            }
            $object->next();
        }
        return $reward = true;
    }

    /**
     * 修改用户道具数
     * @param [type] $userId [description]
     * @param [type] $itemId [description]
     * @param [type] $id     [description]
     */
    private static function setUserItems($mail,$userId,$itemId,$id){
        $object = $mail->getItemsIterator();
        while ($object->valid()) {
            $itemId = MathUtil::bits($object->current(), 0, 10);
            $amount = MathUtil::bits($object->current(), 10, 11);
            if (ItemModule::getItemType($itemId) == "hero") {
                HeroModule::addPlayerHero($userId, $itemId, "readMail");
            } else {
                ItemModule::addItem($userId, array($itemId => $amount), "MailID=" . $id);
            }
            $object->next();
        }
        return $reward = true;
    }
    /**
     * 发送明文邮件
     *
     * @param $userId int 
     * @param $from string 
     * @param $title string 
     * @param $content string 
     * @param $money int 
     * @param $diamonds int 
     * @param $points string 
     * @param $expireTime int 
     * @return
     */
    public static function sendPlainMail($userId, $from, $title, $content, $money, $diamonds, $points, $items, $expireTime = 0){
        $curTime = time();
        $mail = new SysPlayerMail();
        $mail->setUserId($userId);
        $mail->setType(0);

        $mail->setFrom($from);
        $mail->setTitle($title);
        $mail->setContent($content);

        $mail->setMailTime($curTime);
        if ($expireTime > 0) {
            $mail->setExpireTime($curTime + $expireTime);
        } else {
            $mail->setExpireTime($curTime + self::MailExpire);
        }
        $mail->setMoney($money);
        $mail->setDiamonds($diamonds);
        $mail->setPoints($points);
        $mail->setItems($items);

        $mail->setStatus(0);
        $mail->inOrUp();
    }

    /**
     * 发送格式化邮件
     *
     * @param $userId int 用户ID
     * @param $cfgId int 格式ID
     * @param $param string 内容
     * @param $money int 金币
     * @param $diamonds int 宝石
     * @param $points string 点数
     * @param $expireTime int 过期时间 用秒数表示的过期时间
     * @return
     */
    public static function sendFormatMail($userId, $cfgId, $param, $money, $diamonds, $points, $expireTime = 0){
        $curTime = time();
        $mail = new SysPlayerMail();
        $mail->setUserId($userId);
        $mail->setType(1);
        $mail->setMailCfgId($cfgId);
        $mail->setMailParams($param);

        $mail->setMailTime($curTime);
        if ($expireTime > 0) {
            $mail->setExpireTime($curTime + $expireTime);
        } else {
            $mail->setExpireTime($curTime + self::MailExpire);
        }

        $mail->setMoney($money);
        $mail->setDiamonds($diamonds);
        $mail->setPoints($points);
        $mail->setStatus(0);
        $mail->inOrUp();
        //NotifyManager::addNotify($userId, NOTIFY_TYPE_MAIL);
    }
    
    /**
     * 后台发送邮件 
     * @param $userId int 
     * @param $title int 
     * @param $sender string 
     * @param $content int 
     * @param $expireTime int 
     * @param $gem string 钻石
     *  @param $money string 金币
     *  @param $items string 道具
     * @param $expireTime int 过期时间 用秒数表示的过期时间
     * @return
     */

    public static function GmSetMail($userId,$title,$sender,$content,$expireTime,$gem,$money,$items,$ServerId){
        $curTime = time();
        $mail = new SysPlayerMail();
        $mail->setUserId($userId);
        $mail->setType(0);
        $mail->setMoney($money);
        $mail->setDiamonds($gem);
        $mail->setStatus(0);
        $mail->setFrom($sender);
        $mail->setMailCfgId(8);
        $mail->setMailTime($curTime);
        $mail->setTitle($title);
        $mail->setContent($content);
        $mail->setItems($items);
        $mail->setServerId($ServerId);
        if ($expireTime > 0) {
            $mail->setExpireTime($expireTime);
        } else {
            $mail->setExpireTime($curTime + self::MailExpire);
        }
        return $mail->inOrUp();
        
    }

    public static function getSysMailDownInfo(SysPlayerMail $Mail){
        if ($Mail->getTemplate() > 0) {
            MailTemplateModule::parseTemplate($Mail->getTemplate(), $Mail->getUserId());
            $Mail->setFrom(MailTemplateModule::getFrom());
            $Mail->setTitle(MailTemplateModule::getTitle());
            $Mail->setContent(MailTemplateModule::getContent());
        }

        $oneMail = new Down_SysMail();
        $oneMail->setId($Mail->getId());
        $oneMail->setStatus($Mail->getStatus());
        $oneMail->setMailTime($Mail->getMailTime());
        $oneMail->setExpireTime($Mail->getExpireTime());
        $oneMail->setMoney($Mail->getMoney());
        $oneMail->setDiamonds($Mail->getDiamonds());
        $mail_conent = new Down_MailContent();
        if ($Mail->getType() == 0) {
            $plainMail = new Down_PlainMail();
            $plainMail->setTitle(stripslashes(LocalString::getString($Mail->getTitle())));
            $plainMail->setFrom(stripslashes(LocalString::getString($Mail->getFrom())));
            $plainMail->setContent(stripslashes(LocalString::getString($Mail->getContent())));
            $mail_conent->setPlainMail($plainMail);
        }
        if ($Mail->getType() == 1) {

            self::mailResponse($mail_conent,$Mail);
        }
        $oneMail->setContent($mail_conent);
        $mailItems = $Mail->getItems();
        if (!empty($mailItems)) {
            self::setHerroItems($mailItems,$Mail,$oneMail);
        }

        $mailPoints = $Mail->getPoints();
        if (!empty($mailPoints)) {
            $points = SQLUtil::getArrayFromString($mailPoints);
            $keys = array_keys($points);
            foreach ($keys as $key) {
                $userPoint = new Down_UserPoint();
                $userPoint->setType(intval($key));
                $userPoint->setValue(intval($points[$key][0]));
                $oneMail->appendPoints($userPoint);
            }
        }
        return $oneMail;
    }

    /**
     * [mailResponse description]
     * @return [type] [description]
     */
    private static function mailResponse($mail_conent,$Mail){
        $formatMail = new Down_FormatMail();
        $formatMail->setMailCfgId($Mail->getMailCfgId());
        $mailParams = $Mail->getMailParams();
        if (!empty($mailParams)) {
            $params = SQLUtil::getArrayFromString($mailParams);
            $keys = array_keys($params);
            foreach ($keys as $key) {
                $param = new Down_MailParam();
                $param->setIdx(intval($key));
                $param->setType(intval($params[$key][0]));
                $param->setValue($params[$key][1]);
                $formatMail->appendParams($param);
            }
        }
        $mail_conent->setFormatMail($formatMail);
    }
    /**
     * 修改武将信息
     * @param [object] $mailItems [description]
     * @param [object] $Mail      [description]
     */
    private static function setHerroItems($mailItems,$Mail,$oneMail){
        $items = SQLUtil::getArrayFromString($mailItems);
        $keys = array_keys($items);
        foreach ($keys as $key) {
            $id = intval($key);
            $count = intval($items[$key][0]);
            //武将被招募的情况
            if (ItemModule::getItemType($id) == "hero") {
                $allHero = HeroModule::getAllHeroTable($Mail->getUserId());
                if (isset($allHero[$id])) { //此武将已经被招募转化为对应的灵魂石
                    $heroDefineArr = DataModule::lookupDataTable(HERO_UNIT_LUA_KEY, $id);
                    if (!empty($heroDefineArr)) {
                        //获取武将初始星级
                        $initStar = isset($heroDefineArr['Initial Stars']) ? $heroDefineArr['Initial Stars'] : 1;
                        $count = $soulNum = DataModule::lookupDataTable(HERO_STAR_LUA_KEY, "Convert Fragments", array($initStar));
                        //获取对应的灵魂石ID
                        $id = $needChipTid = DataModule::lookupDataTable(FRAGMENT_LUA_KEY, "Fragment ID", array($id));
                    }
                }
            }
            $arg_arr = array(11, $count, 10, $id);
            $oneMail->appendItems(MathUtil::makeBits($arg_arr));
        }

    }
    /**
     * 删除七天前的邮件
     * @return [type] [description]
     */
    public static function clearOverdueMail(){
        $sql = "delete from player_mail where `expire_time` < (UNIX_TIMESTAMP() - 604800)";
        MySQL::getInstance()->RunQuery($sql);
    }
}

