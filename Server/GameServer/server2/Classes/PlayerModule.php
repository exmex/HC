<?php

require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysUser.php");
//why add
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysUserServer.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayer.php");

require_once($GLOBALS['GAME_ROOT'] . "Classes/ChatModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/DataModule.php");;
require_once($GLOBALS['GAME_ROOT'] . "Classes/DailyLoginModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/DailyActivityModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/HeroModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/GuildModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/ItemModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/SkillModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/StageModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/ShopModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/MonthCardModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/TutorialModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/TaskModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/TavernModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/VitalityModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/VipModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/ParamModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerCacheModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/MailModule.php");
define('PLAYER_DEFAULT_NAME', "NickName");
define('PLAYER_CHANGE_NAME_PRICE', 100);

class PlayerModule
{
    private static $playerTableCached = array();

    public static function getPlayerTable($userId, $serverId = 0)
    {
        if (isset(self::$playerTableCached[$userId])) {
            return self::$playerTableCached[$userId];
        }

        // update player record
        $sysPlayer = new SysPlayer();
        $sysPlayer->setUserId($userId);
        if ($sysPlayer->loaded()) {

        } else {
            if ($serverId <= 0) {
                Logger::getLogger()->error("getPlayerTable server id invalid:" . $serverId);
                return null;
            }
            $sysPlayer->setServerId($serverId);
            $sysPlayer->setNickname(PLAYER_DEFAULT_NAME);
            $sysPlayer->setLastSetNameTime(0);
            $sysPlayer->setAvatar(1);
            $sysPlayer->setLevel(1);
            $sysPlayer->setExp(1);
            $sysPlayer->setMoney(0);
            $sysPlayer->setGem(0);
            $sysPlayer->setArenaPoint(0);
            $sysPlayer->setCrusadePoint(0);
            $sysPlayer->setGuildPoint(0);
            $sysPlayer->setLastMidasTime(0);
            $sysPlayer->setTodayMidasTimes(0);
            $sysPlayer->setFacebookFollow(0); //add
            $sysPlayer->inOrUp();
        }

        self::$playerTableCached[$userId] = $sysPlayer;
        return $sysPlayer;
    }
//add why
    public static function getPlayerInfo($userId)
    {
    	// update player record
    	$sysPlayer = new SysPlayer();
    	$sysPlayer->setUserId($userId);
    	if($sysPlayer->loaded())
    	{
	    	$PlayerInfo['status']=1;
	    	$PlayerInfo['UserId']=$sysPlayer->getUserId();
	    	$PlayerInfo['ServerId']=$sysPlayer->getServerId();
	    	$PlayerInfo['Nickname']=$sysPlayer->getNickname();
	    	$PlayerInfo['LastSetNameTime']=$sysPlayer->getLastSetNameTime();
	    	$PlayerInfo['Level']=$sysPlayer->getLevel();
	    	$PlayerInfo['exp']=$sysPlayer->getExp();
	    	$PlayerInfo['Money']=$sysPlayer->getMoney();
	    	$PlayerInfo['Gem']=$sysPlayer->getGem();
	    	$PlayerInfo['Tutorialstep']=$sysPlayer->getTutorialstep();
	    	$PlayerInfo['ArenaPoint']=$sysPlayer->getArenaPoint();
	    	$PlayerInfo['CrusadePoint']=$sysPlayer->getCrusadePoint();
	    	$PlayerInfo['GuildPoint']=$sysPlayer->getGuildPoint();
    	}else 
    	{
    		$PlayerInfo['status']=0;
    	}
    	
    	return $PlayerInfo;
    }
    
    
    public static function getUserInfo($value,$serverid,$type)
    {
         if($type=='nickname')
        {
                $SysPlayer = new SysPlayer();
                $where = "`nickname` = '".$value."' and server_id=".$serverid;
                 $SysPlayer->loaded(array("user_id"), $where);
                return $SysPlayer->getUserId();

        }

        if($type=='puid')
        {
                $SysUser = new SysUser();
                $where = "`game_center_id` = '".$value."'";
                 $SysUser->loaded(array("uin"), $where);
                $uin = $SysUser->getUin();
                $SysUserServer = new SysUserServer();
                $where = "`uin` = '".$uin."' and server_id=".$serverid;
                 $SysUserServer->loaded(array("user_id"), $where);
                return $SysUserServer->getUserId();

        }
    }
    
    public static function GmSetMail($userId,$title,$sender,$content,$expireTime,$gem,$money,$items,$ServerId,$type)
    {
     if($type == 'mail')
     {
     	$UserServer = new SysUserServer();
     	$UserServer->setUserId($userId);
     	$UserServer->loaded();
     	$ServerId=$UserServer->getServerId();
     }
     if($type == 'allmail')	
     {
     	$userId=0;
     }
      if($type == 'allservermail')	
      {
      	$ServerId = 0;
      	$userId=0;
      }
    	if($title =='' || $content=='')
    	{
    		return null;
    	}
    	
    	if($gem=='' && $money=='' && $items=='')
    	{
    		return null;
    	}
    	
    	return MailModule::GmSetMail($userId,$title,$sender,$content,$expireTime,$gem,$money,$items,$ServerId);

    }
    //add why 改变等级
    public static function modifyPlyLevel($userId, $level, $reason = "")
    {
    	if ($level <= 0) {
    		return 0;
    	}
    	$SysPlayer = self::getPlayerTable($userId);
    	$maxLv = ParamModule::GetTeamLevelMax();
    	if ($level >= $maxLv) {
    		return 0;
    	}
    	Logger::getLogger()->debug("--------".$maxLv."===".$level."==|".$SysPlayer);
    	$SysPlayer->setLevel($level);
    	$SysPlayer->save();
    	PlayerCacheModule::setPlayerLevel($userId, $level);
    	return 1;
    }
    
    public static function modifyPlyArenaPoint($userId, $ArenaPoint, $reason = "")
    {
    	$SysPlayer = self::getPlayerTable($userId);
    
    	$after = max(0, ($SysPlayer->getArenaPoint() + $ArenaPoint));
  
    
    	if ($ArenaPoint != 0) {
    		$SysPlayer->setArenaPoint($after);
    		$SysPlayer->save();
    	}
    
    	return $after;
    }
    
    public static function modifyPlyCrusadePoint($userId, $CrusadePoint, $reason = "")
    {
    	$SysPlayer = self::getPlayerTable($userId);
    
    	$after = max(0, ($SysPlayer->getCrusadePoint() + $CrusadePoint));
    	if ($CrusadePoint != 0) {
    		$SysPlayer->setCrusadePoint($after);
    		$SysPlayer->save();
    	}
    
    	return $after;
    }
    
    public static function modifyPlyGuildPoint($userId, $GuildPoint, $reason = "")
    {
    	$SysPlayer = self::getPlayerTable($userId);
    
    	$after = max(0, ($SysPlayer->getGuildPoint() + $GuildPoint));
    	if ($GuildPoint != 0) {
    		$SysPlayer->setGuildPoint($after);
    		$SysPlayer->save();
    	}
    
    	return $after;
    }
    
    
    public static function PlayrtNum($server_id)
    {
    		$UserServer = new SysUserServer();
    		$where = "`server_id` = '".$server_id."'";
    		$userNum=$UserServer->loadedCount("count(*) as userNum", $where);
    		return $userNum;
    }
    
    //end
    public static function getUserDownInfo($userId, $serverId = 0)
    {
        // get player info
        $SysPlayer = self::getPlayerTable($userId, $serverId);
        if (empty($SysPlayer)) {
            return null;
        }

        $userInfo = new Down_User();
        $userInfo->setUserid($userId);

        $nameCard = new Down_NameCard();
        $nameCard->setName($SysPlayer->getNickname());
        $nameCard->setLastSetNameTime($SysPlayer->getLastSetNameTime());
        $nameCard->setAvatar($SysPlayer->getAvatar());
        $userInfo->setNameCard($nameCard);

        $userInfo->setLevel($SysPlayer->getLevel());
        $userInfo->setExp($SysPlayer->getExp());
       $userInfo->setFacebookFollow($SysPlayer->getFacebookFollow());
      
        
        // get user every resource
        $userInfo->setMoney($SysPlayer->getMoney());
        $userInfo->setRmb($SysPlayer->getGem());

        $arenaPoint = new Down_UserPoint();
        $arenaPoint->setType(Down_UserPoint_UserPointType::arenapoint);
        $arenaPoint->setValue($SysPlayer->getArenaPoint());
        $userInfo->appendPoints($arenaPoint);

        $crusadePoint = new Down_UserPoint();
        $crusadePoint->setType(Down_UserPoint_UserPointType::crusadepoint);
        $crusadePoint->setValue($SysPlayer->getCrusadePoint());
        $userInfo->appendPoints($crusadePoint);

        $guildPoint = new Down_UserPoint();
        $guildPoint->setType(Down_UserPoint_UserPointType::guildpoint);
        $guildPoint->setValue($SysPlayer->getGuildPoint());
        $userInfo->appendPoints($guildPoint);

        // get midas info
        $userMidas = new Down_Usermidas();
        $userMidas->setLastChange($SysPlayer->getLastMidasTime());
        if (SQLUtil::isTimeNeedReset($SysPlayer->getLastMidasTime())) {
            //清空点金次数
            $SysPlayer->setTodayMidasTimes(0);
        }
        $userMidas->setTodayTimes($SysPlayer->getTodayMidasTimes());
        $userInfo->setUsermidas($userMidas);

        // get vitality info
        $plyVitality = VitalityModule::getVitalityDownInfo($userId);
        $userInfo->setVitality($plyVitality);

        // get heros info
        $heroInfoArr = HeroModule::getAllHeroDownInfo($userId);
        foreach ($heroInfoArr as $heroInfo) {
            $userInfo->appendHeroes($heroInfo);
        }

        // get items info
        $itemInfoArr = ItemModule::getAllItemsDownInfo($userId);
        foreach ($itemInfoArr as $itemInfo) {
            $userInfo->appendItems($itemInfo);
        }

        // get skill info
        $skillInfo = SkillModule::getSkillDownInfo($userId);
        $userInfo->setSkillLevelUp($skillInfo);

        // get stage info
        $userStageInfo = StageModule::getUserStageDownInfo($userId);
        $userInfo->setUserstage($userStageInfo);

        // get shop info
        $userShopArr = ShopModule::getAllShopDownInfo($userId);
        foreach ($userShopArr as $shopInfo) {
            $userInfo->appendShop($shopInfo);
        }

        // get tutorial info
        $userTutorialArr = TutorialModule::getTutorialDownInfo($userId);
        foreach ($userTutorialArr as $tutorial) {
            $userInfo->appendTutorial($tutorial);
        }

        // get task info
        $userTaskArr = TaskModule::getAllTaskDownInfo($userId);
        foreach ($userTaskArr as $task) {
            $userInfo->appendTask($task);
        }

        // get finish job
        $userFinishTaskArr = TaskModule::getAllFinishTaskDownInfo($userId);
        foreach ($userFinishTaskArr as $finTask) {
            $userInfo->appendTaskFinished($finTask);
        }

        // get daily job info
        $userJobArr = TaskModule::getAllJobDownInfo($userId);
        foreach ($userJobArr as $job) {
            $userInfo->appendDailyjob($job);
        }

        // get tavern info
        $userTavernArr = TavernModule::getAllTavernDownInfo($userId);
        foreach ($userTavernArr as $tavern) {
            $userInfo->appendTavernRecord($tavern);
        }

        // get daily login info
        $userDailyLoginInfo = DailyLoginModule::getDailyLoginDownInfo($userId);
        $userInfo->setDailyLogin($userDailyLoginInfo);

        // get vip info
        $userInfo->setRechargeSum(VipModule::getRechargeSum($userId));
        $userRechargeLimitArr = VipModule::getRechargeLimitDownArr($userId);
        foreach ($userRechargeLimitArr as $limitInfo) {
            $userInfo->appendRechargeLimit($limitInfo);
        }

        // get month card info
        $userMonthCardArr = MonthCardModule::getAllMonthCardDownInfo($userId);
        foreach ($userMonthCardArr as $monthCard) {
            $userInfo->appendMonthCard($monthCard);
        }

        // get user guild info
        $userGuild = GuildModule::getUserGuildDownInfo($userId);
        $userInfo->setUserGuild($userGuild);
        PlayerCacheModule::setGuildId($userId, $userGuild->getId());
        PlayerCacheModule::setGuildPost($userId, $userGuild->getJob());

        // get chat info
        $userChatInfo = ChatModule::getChatDownInfo($userId);
        $userInfo->setChat($userChatInfo);

        // get star shop info
        $userSShop = ShopModule::getStarShopDownInfo($userId);
        if (isset($userSShop)) {
            $userInfo->setSshop($userSShop);
        }
 
        
        return $userInfo;
    }

    /////////////////////////////////////
    //配置表相关功能接口
    //
    //检查相应等级功能是否开放
    public static function checkFuncOpen($level, $func, $chapter = 0)
    {
        $config = DataModule::getInstance()->getDataSetting(PLAYER_LEVEL_LUA_KEY);

        FOR ($i = 1; $i <= $level; $i++) {
            $unlockArr = $config[$i]["Unlock"];
            foreach ($unlockArr as $function) {
                if ($function === $func) {
                    if ($func == "Chapter") {
                        if ($config[$i]["Chapter"] >= $chapter) {
                            return true;
                        }
                    } else {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    public static function modifyMoney($userId, $money, $reason = "")
    {
        $SysPlayer = self::getPlayerTable($userId);

        $after = max(0, ($SysPlayer->getMoney() + $money));

        LogClient::getInstance()->logMoneyChanged($userId, $reason, $SysPlayer->getMoney(), $after);

        if ($money != 0) {
            $SysPlayer->setMoney($after);
            $SysPlayer->save();
        }

        return $after;
    }

    public static function modifyGem($userId, $gem, $reason = "")
    {
        $tbPlayer = self::getPlayerTable($userId);

        $curGem = intval($tbPlayer->getGem());
        $regGem = intval($tbPlayer->getRechargeGem());
        $after = max(0, ($curGem + $gem));
        $deplete=0;
        if($gem <0)
        {
        	//是消耗钻石
        	if($after < $regGem)
        	{
        		$deplete = $regGem-$after;
        		
        	}
        }
        //行为日志
        LogAction::getInstance()->log('GOLD_COST', array(
        		'money'		=> $gem,
        		'wpnum'		=> 1,
        		'price'		=> $gem,
        		'wpid'		=> 0,
        		'regGem'	=>$deplete,
        		'wptype'	=> $reason
       		 )
        );
        LogClient::getInstance()->logGemChanged($userId, $reason, $tbPlayer->getGem(), $after);

        if ($gem != 0) {
        	$tbPlayer->setRechargeGem($regGem-$deplete);
            $tbPlayer->setGem($after);
            $tbPlayer->save();
        }

        return $after;
    }
    
    
    public static function modifyRechargeGem($userId, $gem, $reason = "")  //只是用于充值增加
    {
    	$tbPlayer = self::getPlayerTable($userId);
    	$regGem = intval($tbPlayer->getRechargeGem());
    	$after = max(0, ($regGem + $gem));
    	if ($gem != 0) {
    		$tbPlayer->setRechargeGem($after);
    		$tbPlayer->save();
    	}
    
    	return $after;
    }
    

    public static function modifyArenaPoint($userId, $point, $reason = "")
    {
        $tbPlayer = self::getPlayerTable($userId);

        $after = max(0, ($tbPlayer->getArenaPoint() + $point));

        LogClient::getInstance()->logArenaPointChanged($userId, $reason, $tbPlayer->getArenaPoint(), $after);

        if ($point != 0) {
            $tbPlayer->setArenaPoint($after);
            $tbPlayer->save();
        }

        return $after;
    }

    public static function modifyCrusadePoint($userId, $point, $reason = "")
    {
        $tbPlayer = self::getPlayerTable($userId);

        $after = max(0, ($tbPlayer->getCrusadePoint() + $point));

        LogClient::getInstance()->logCrusadePointChanged($userId, $reason, $tbPlayer->getCrusadePoint(), $after);

        if ($point != 0) {
            $tbPlayer->setCrusadePoint($after);
            $tbPlayer->save();
        }

        return $after;
    }

    public static function modifyGuildPoint($userId, $point, $reason = "")
    {
        $tbPlayer = self::getPlayerTable($userId);

        $after = max(0, ($tbPlayer->getGuildPoint() + $point));

        LogClient::getInstance()->logGuildPointChanged($userId, $reason, $tbPlayer->getGuildPoint(), $after);

        if ($point != 0) {
            $tbPlayer->setGuildPoint($after);
            $tbPlayer->save();
        }

        return $after;
    }

    public static function modifyPlyExp($userId, $exp, $reason = "")
    {
        if ($exp <= 0) {
            return 0;
        }
        $tbPlayer = self::getPlayerTable($userId);
        $curLv = $tbPlayer->getLevel();
        $maxLv = ParamModule::GetTeamLevelMax();
        if ($curLv >= $maxLv) {
            return 0;
        }

        $after = max(0, ($tbPlayer->getExp() + $exp));
        LogClient::getInstance()->logPlyExpChanged($userId, $reason, $tbPlayer->getExp(), $after);

        while (true) {
            $levelUpExp = floor(DataModule::lookupDataTable(PLAYER_LEVEL_LUA_KEY, "Exp", array($curLv)));
            if ($levelUpExp == 0) {
                break;
            }

            if ($after >= $levelUpExp) {
                $after -= $levelUpExp;
                $addVit = floor(DataModule::lookupDataTable(PLAYER_LEVEL_LUA_KEY, "Vitality Reward", array($curLv)));
                VitalityModule::modifyVitality($userId, $addVit, "Player_Level_Up:" . $curLv);
                $curLv++;

                if ($curLv >= $maxLv) {
                    $after = 0;
                    break;
                }
            } else {
                break;
            }
        }

        $tbPlayer->setLevel($curLv);
        $tbPlayer->setExp($after);
        $tbPlayer->save();

        PlayerCacheModule::setPlayerLevel($userId, $curLv);
        return $after;
    }

    /*增加木材 和 铁矿*/
    public static function modifyWood($userId, $wood, $reason = "")
    {
    	$SysPlayer = self::getPlayerTable($userId);
    
    	$after = max(0, ($SysPlayer->getWood() + $wood));
    	if ($wood != 0) {
    		$SysPlayer->getWood($after);
    		$SysPlayer->save();
    	}
    	return $after;
    }
    
    public static function modifyIron($userId, $iron, $reason = "")
    {
    	$SysPlayer = self::getPlayerTable($userId);
    
    	$after = max(0, ($SysPlayer->getIron() + $iron));
    	if ($iron != 0) {
    		$SysPlayer->getIron($after);
    		$SysPlayer->save();
    	}
    	return $after;
    }
    
    
    public static function getUserSummaryObj($userId, $isRobot = 0)
    {
        $userSummary = PlayerCacheModule::getUserSummary($userId);
        if ($userSummary) {
            return $userSummary;
        }

        $newUserSummary = new Down_UserSummary();

        if ($isRobot > 0) {
            $sql = "SELECT `nickname`, `avatar`, `level` FROM `player` WHERE `user_id` = '{$userId}'";
        } else {
            $sql = "SELECT a.nickname, a.avatar, a.level, b.vip ";
            $sql .= "FROM player a, player_vip b ";
            $sql .= "WHERE a.user_id = b.user_id AND a.user_id = {$userId}";
        }

        $qr = MySQL::getInstance()->RunQuery($sql);
        if (!empty ($qr)) {
            $ar = MySQL::getInstance()->FetchAllRows($qr);
            if (!empty ($ar) && count($ar) > 0) {
                $row = $ar[0];
                $newUserSummary->setUserId($userId);
                $newUserSummary->setName($row [0]);
                $newUserSummary->setAvatar($row [1]);
                $newUserSummary->setLevel($row [2]);
                if ($isRobot > 0) {
                    $newUserSummary->setVip(0);
                    $newUserSummary->setGuildName("");
                } else {
                    $newUserSummary->setVip($row [3]);
                    $guildName = PlayerCacheModule::getGuildName($userId);
                    $newUserSummary->setGuildName($guildName);
                }
            }
        }
        PlayerCacheModule::setUserSummary($userId, $userSummary);

        return $newUserSummary;
    }

    /** 只能用于非机器人,否则会查不出记录 */
    public static function getUserSummaryArr($userList)
    {
        $retArr = array();
        $userIdStr = implode(",", $userList);

        $sql = "SELECT a.user_id, a.nickname, a.avatar, a.level, b.vip ";
        $sql .= "FROM player a, player_vip b ";
        $sql .= "WHERE a.user_id = b.user_id AND a.user_id in ({$userIdStr})";

        $qr = MySQL::getInstance()->RunQuery($sql);
        if (!empty ($qr)) {
            $ar = MySQL::getInstance()->FetchAllRows($qr);
            if (!empty ($ar) && count($ar) > 0) {
                $row = $ar[0];
                $newUserSummary = new Down_UserSummary();
                $newUserSummary->setUserId($row [0]);
                $newUserSummary->setName($row [1]);
                $newUserSummary->setAvatar($row [2]);
                $newUserSummary->setLevel($row [3]);
                $newUserSummary->setVip($row [4]);
                $guildName = PlayerCacheModule::getGuildName($row [0]);
                $newUserSummary->setGuildName($guildName);
                $retArr[$row [0]] = $newUserSummary;
            }
        }

        return $retArr;

    }

}
