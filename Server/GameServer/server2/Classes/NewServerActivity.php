<?php

require_once($GLOBALS['GAME_ROOT'] . "Classes/ServerModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/NotifyModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/MailTemplateModule.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerVip.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerMail.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerLevelActivity.php");
class NewServerActivity
{

    private static $firstPayReward = array(
       	135 => 30, //bingnv*1
        368 => 5, //机动车牌*1
        290 => 3, //经验药膏*5
        390 => 10, //扫荡卷
    	371 => 3,  //齿轮
    		
    );
//经验药膏*5 //经验药水*3, //虚空尘埃*2
    private static $days7Reward = array(
       	    1=>array(126 =>2,169 => 3,368 => 2),
    		2=>array(126 =>2,169 => 3,368 => 2),
    		3=>array(126 =>2,169 => 3,368 => 2),
    		4=>array(126 =>2,169 => 3,368 => 2),
    		5=>array(126 =>2,169 => 3,368 => 2),
    		6=>array(126 =>2,169 => 3,368 => 2),
    		7=>array(126 =>2,169 => 3,368 => 2),
    );
       
    	


    private static $level30Reward = array(
        372 => 5, //黄金电能核心*5
        169 => 5, //经验药水*5
    );

    /**
     * 登陆后检查开服活动邮件
     *
     * @param $userId
     */
    public static function newServerMailCheck($userId, $serverId)
    {
        //开服
        $tbServerList = ServerModule::getServerInfoByServerId($serverId);
        $beginTime = strtotime(date("Y-m-d 00:00:00", $tbServerList->getServerStartDate()));
        $endTime = $beginTime + 7 * 24 * 3600 - 1;
        $now = time();
        if ($now > $beginTime && $now < $endTime) {
            $mail = new SysPlayerMail();
            $mail->setUserId($userId);
            $mail->setTemplate(1);
            if (!$mail->LoadedExistFields()) {
                MailTemplateModule::insertNewTemplateMail(1, $userId);
            }
        }
    }

    /**
     * 用户的首充活动
     *
     * 开服前四天，玩家单笔充值5元以上（不含月卡），可以获得首冲礼包奖励：【冰女灵魂石*30(可直接召唤冰女)】、【机动车牌*1】、【经验药膏*5】。充值成功后自动通过系统邮件发放
     *
     * @param $userId
     * @param array $package 充值的礼包配置数组
     */
    public static function firstPay($userId, $package)
    {
        $tbPlayer = PlayerModule::getPlayerTable($userId);
        $serverId = $tbPlayer->getServerId();

        //开服
        $tbServerList = ServerModule::getServerInfoByServerId($serverId);

        $beginTime = strtotime(date("Y-m-d 00:00:00", $tbServerList->getServerStartDate()));
       
        $endTime = $beginTime + 7000 * 24 * 3600;
        //$endTime = strtotime(date("Y-m-d 00:00:00", $tbServerList->getServerStartDate() + 4 * 24 * 3600));
        $time = time();

        // if ($package['Type'] != "MonthlyCard" && $package['Cost'] > 0 && $time < $endTime) {
        if ($package['Cost'] > 0 && $time < $endTime) {
            $beginMonth = date("M", $tbServerList->getServerStartDate());
            $beginDate = date("jS", $tbServerList->getServerStartDate());
            $endMonth = date("M", $endTime - 1);
            $endDate = date("jS", $endTime - 1);
            $mail = new SysPlayerMail();
            $mail->setUserId($userId);
            $mail->setType(0);
            $curTime = time();
            $expireTime = $curTime + 3600 * 24 * 365;
            $mail->setMailTime($curTime);
            $mail->setExpireTime($expireTime);
            $mail->setTitle("Receive massive rewards after first payment");
            $mail->setFrom("System");
            $mail->setContent(" ");
            $itemStr = "";
            foreach (self::$firstPayReward as $key => $vv) {
                $itemStr .= "{$key}:{$vv};";
            }
            $mail->setItems($itemStr);
            $mail->setStatus(0);
            $mail->inOrUp();
//            NotifyModule::addNotify($userId, NOTIFY_TYPE_MAIL);

            return true;
        }

        return false;
    }

    /**
     * 七日大礼包
     *
     * 开服后从第二天开始，连续7天,到第七天的23:59，对团队等级大于10（包括10级）的玩家，每天中午12:00左右发放有奖奖励：【钻石*50】、【经验药水*5】、【秘银齿轮组*5】
     *
     */
    public static function days7Activity($timeZoneId)
    {
        //获取所有在此范围的服务器
        $serverArr = array();

        $serverTimeArr = array();

        $time = time();
        $serverList = ServerModule::getServerListTable();
        /** @var TbServerList $tbServer */
        foreach ($serverList as $tbServer) {
            $beginTime = strtotime(date("Y-m-d 00:00:00", $tbServer->getServerStartDate() + 24 * 3600));
            $endTime = $beginTime + 7 * 24 * 3600;
            $during_time = $time-$beginTime;
            $nums = ceil($during_time/(24*3600));
            if ($time < $beginTime || $time > $endTime) {
                continue;
            }

            $serverId_ = $tbServer->getServerId();
            $serverTimeArr[$serverId_]['beginMonth'] = date("M", $tbServer->getServerStartDate());
            $serverTimeArr[$serverId_]['beginDate'] = date("jS", $tbServer->getServerStartDate());
            $serverTimeArr[$serverId_]['endMonth'] = date("M", $endTime - 1);
            $serverTimeArr[$serverId_]['endDate'] = date("jS", $endTime - 1);

            $serverArr[] = $serverId_;
        }


        foreach ($serverArr as $serverId) {
            $beginMonth = $serverTimeArr[$serverId]['beginMonth'];
            $beginDate = $serverTimeArr[$serverId]['beginDate'];
            $endMonth = $serverTimeArr[$serverId]['endMonth'];
            $endDate = $serverTimeArr[$serverId]['endDate'];

            $beginUserId = 0;

            while (true) {
                $sql = "select P.user_id from user as U, user_server as S, player as P where U.uin = S.uin and S.user_id = P.user_id and U.user_zone_id = '{$timeZoneId}' and P.server_id = '{$serverId}' and U.is_robot = 0 and P.user_id > '{$beginUserId}' and P.level >= 10 group by P.user_id asc limit 200 ";
                $rs = MySQL::getInstance()->RunQuery($sql);
                $num_ = 0;

                $batch = new SQLBatch();
                $insertArr = array('user_id', 'type', 'mail_time', 'expire_time', 'title', 'from', 'content', 'diamonds', 'items', 'status');
                $batch->init(SysPlayerMail::insertSqlHeader($insertArr));

                while ($row = MySQL::getInstance()->FetchAssoc($rs)) {

                    $mail = new SysPlayerMail();
                    $mail->setUserId($row['user_id']);
                    $mail->setType(0);
                    $expireTime = $time + 3600 * 24 * 365;
                    $mail->setMailTime($time);
                    $mail->setExpireTime($expireTime);
                    $mail->setTitle("Welcome Week Package");
                    $mail->setFrom("System");
                    $mail->setContent("Soul stones will be given as gifts at the new server in the first seven days.");
                    $mail->setDiamonds(50);
                    $itemStr = "";
                    foreach (self::$days7Reward[$nums] as $key => $vv) {
                        $itemStr .= "{$key}:{$vv};";
                    }
                    $mail->setItems($itemStr);
                    $mail->setStatus(0);

                    $batch->add($mail);

//                    NotifyModule::addNotify($row['user_id'], NOTIFY_TYPE_MAIL);

                    $beginUserId = $row['user_id'];
                    $num_++;
                }

                if ($num_ == 0) {
                    break;
                }

                $batch->end();
                $batch->save();
            }

            $beginUserId = 0;
        }

    }
    /*
     * 
     * 好评活动
     * 
     * 符合条件显示
     * 
     *  @param $time
     * */
    public static function PraiseActivities()
    {
    	
    	$beginTime = strtotime("2014-12-03 00:00:00");
    	
    	$endTime = $beginTime + 5 * 24 * 3600;
    	
    	$time = time();
    	
    	if($time<$endTime && $time>$beginTime)
    	{
    		return "https://play.google.com/store/apps/details?id=com.aasd.asds.dafdf.zxcv";
    	}
    	return "";
    	
    }
    /**
     * 冲级送钱送经验
     *
     * 获取符合奖励条件的用户
     *
     * @param $timeZoneId
     */
    public static function levelActivityGetUser($timeZoneId)
    {
        //获取所有在此范围的服务器
        $serverArr = array();

        $time = time();
        $serverList = ServerModule::getServerListTable();
        /** @var TbServerList $tbServer */
        foreach ($serverList as $tbServer) {
            //第三天12:00才允许结算
            //$beginTime = strtotime(date("Y-m-d 00:00:00", $tbServer->getServerStartDate() + 5 * 24 * 3600));
            $beginTime = strtotime(date("Y-m-d 00:00:00", $tbServer->getServerStartDate()));
            $beginTime = $beginTime + 4 * 24 * 3600;
            $endTime = $beginTime + 24 * 3600;
            if ($time < $beginTime || $time > $endTime) {
                continue;
            }

            $serverId_ = $tbServer->getServerId();
            $serverArr[] = $serverId_;
        }

        foreach ($serverArr as $serverId) {
            $beginUserId = 0;

            while (true) {
                $sql = "select P.user_id from user as U, user_server as S, player as P where U.uin = S.uin and S.user_id = P.user_id and U.user_zone_id = '{$timeZoneId}' and P.server_id = '{$serverId}' and U.is_robot = 0 and P.user_id > '{$beginUserId}' and P.level >= 30 group by P.user_id asc limit 500 ";
                $rs = MySQL::getInstance()->RunQuery($sql);
                $num_ = 0;

                $batch = new SQLBatch();
                $insertArr = array('user_id', 'server_id', 'zone_id', 'state');
                $batch->init(SysPlayerLevelActivity::insertSqlHeader($insertArr));

                while ($row = MySQL::getInstance()->FetchAssoc($rs)) {

                    $mail = new SysPlayerLevelActivity();
                    $mail->setUserId($row['user_id']);
                    $mail->setServerId($serverId);
                    $mail->setZoneId($timeZoneId);
                    $mail->setState(0);

                    $batch->add($mail);

                    $beginUserId = $row['user_id'];
                    $num_++;
                }

                if ($num_ == 0) {
                    break;
                }

                $batch->end();
                $batch->save();
            }

            $beginUserId = 0;
        }

    }

    /**
     * 冲级送钱送经验
     *
     * 为符合奖励条件的用户发送奖励
     * 在规定的开服时间内，从开服算起三天，第三天的12:00，到达30级。则在第四天的18:00左右为玩家发送邮件奖励：【钻石*200】、【黄金电能核心*5】、【经验药水*5】。
     *
     * @param $timeZoneId
     */
    public static function levelActivityGiveReward($timeZoneId)
    {
        //获取所有在此范围的服务器
        $serverArr = array();

        $serverTimeArr = array();

        $time = time();
        $serverList = ServerModule::getServerListTable();
        /** @var TbServerList $tbServer */
        foreach ($serverList as $tbServer) {
            $beginTime = strtotime(date("Y-m-d 00:00:00", $tbServer->getServerStartDate()));
            $endTime = $beginTime + 4 * 24 * 3600;

            //第四天才允许发放奖励
            $giveBeginTime = $endTime;
            $giveEndTime = $endTime + 24 * 3600;
            if ($time < $giveBeginTime || $time > $giveEndTime) {
                continue;
            }

            $serverId_ = $tbServer->getServerId();
            $serverTimeArr[$serverId_]['beginMonth'] = date("M", $tbServer->getServerStartDate());
            $serverTimeArr[$serverId_]['beginDate'] = date("jS", $tbServer->getServerStartDate());
            $serverTimeArr[$serverId_]['endMonth'] = date("M", $endTime - 1);
            $serverTimeArr[$serverId_]['endDate'] = date("jS", $endTime - 1);

            $serverArr[] = $serverId_;
        }

        foreach ($serverArr as $serverId) {
            $beginUserId = 0;

            $beginMonth = $serverTimeArr[$serverId]['beginMonth'];
            $beginDate = $serverTimeArr[$serverId]['beginDate'];
            $endMonth = $serverTimeArr[$serverId]['endMonth'];
            $endDate = $serverTimeArr[$serverId]['endDate'];

            while (true) {
                $sql = "select user_id from player_level_activity where zone_id = '{$timeZoneId}' and server_id = '{$serverId}' and state = 0 and user_id > '{$beginUserId}' order by user_id asc limit 200 ";
                $rs = MySQL::getInstance()->RunQuery($sql);
                $num_ = 0;

                $batch = new SQLBatch();
                $insertArr = array('user_id', 'type', 'mail_time', 'expire_time', 'title', 'from', 'content', 'diamonds', 'items', 'status');
                $batch->init(SysPlayerMail::insertSqlHeader($insertArr));

                while ($row = MySQL::getInstance()->FetchAssoc($rs)) {

                    $mail = new SysPlayerMail();
                    $mail->setUserId($row['user_id']);
                    $mail->setType(0);
                    $expireTime = $time + 3600 * 24 * 365;
                    $mail->setMailTime($time);
                    $mail->setExpireTime($expireTime);
                    $mail->setTitle("Level Rewards");
                    $mail->setFrom("admin");
                    $mail->setContent("Reach Team Level 30 by the end of {$endMonth} {$endDate}, and we'll send you Gems x200, Power of Gold x5, EXP Potion x5 in your game mail!");
                    $mail->setDiamonds(200);
                    $itemStr = "";
                    foreach (self::$level30Reward as $key => $vv) {
                        $itemStr .= "{$key}:{$vv};";
                    }
                    $mail->setItems($itemStr);
                    $mail->setStatus(0);

                    $batch->add($mail);

//                    NotifyModule::addNotify($row['user_id'], NOTIFY_TYPE_MAIL);

                    $beginUserId = $row['user_id'];
                    $num_++;
                }

                if ($num_ == 0) {
                    break;
                }

                $batch->end();
                $batch->save();
                $sql = "update player_level_activity set state = 1  where zone_id = '{$timeZoneId}' and server_id = '{$serverId}' and state = 0 and user_id <= '{$beginUserId}' ";
                $rs = MySQL::getInstance()->RunQuery($sql);
            }
        }
    }

}
 