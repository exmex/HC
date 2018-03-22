<?php

/**
 *
 * get pb up message 
 *
 */

function getPbUpCommands($str)
{
    $matches = array();
    if (!preg_match('/Up_((?:(?!UpMsg).)+)[ ]+\{/', $str, $matches) || count($matches) < 2) {
        return "unknown";
    }
    return $matches[1];
}

function isAccessable()
{
	$serverStatus = json_decode(SERVER_STATUS,true);
	if ( defined('SERVER_STATUS') && in_array($GLOBALS['SERVERID'],$serverStatus))
	{
		require_once($GLOBALS['GAME_ROOT'] . 'ConnGray/grayUsers.php');
		if ( in_array($GLOBALS['USER_PUID'], $GrayUsers) )
		{
			return true;
		}
		return false;
	}
	else
	{
		return true;
	}
}

function OnProtoBuff(WorldSvc $svc, XPACKET_SendProtoBuff $pPacket, Down_DownMsg &$retPacket)
{
    $startTime = microtime(TRUE);
    // 第一步:解密
    $realMsg = MessageProcessor::DecodeMessage($pPacket->data);
    if($realMsg==6)
    {
    	return 6;
    }

 	Logger::getLogger()->debug("OnProtoBuff Process Start! UIN = " . $pPacket->data . " KEY = ---------------------------------------");
    Logger::getLogger()->debug("OnProtoBuff Process Start! UIN = " . $GLOBALS['USER_IN'] . " KEY = " . strval($GLOBALS['USER_KEY']));

    if (empty($realMsg)) {
        Logger::getLogger()->error("DecodeMessage error!" . strval($GLOBALS['USER_KEY']));
      return 1;
    }
    
    if ( !isAccessable() )
    {
    	Logger::getLogger()->error("Not A Gray User!" . strval($GLOBALS['USER_PUID']));
    	return 4;
    } 

    // 第二步:反序列化
    $newObj = new Up_UpMsg();
    try {
        $newObj->parseFromString($realMsg);
    } catch (Exception $error) {
        Logger::getLogger()->error("parse message error!" . strval($GLOBALS['USER_KEY']));
        return 2;
    }

    ob_start();
    $newObj->dump(true, 5);
    $debugLogStr_ = ob_get_contents();
    Logger::getLogger()->debug("[" . getmypid() . "] OnProtoBuff Get Up_UpMsg Data:\r\n" . $debugLogStr_);

    $debugLogStr_ = null;
    ob_end_clean();

    // 获取角色UserId
    // optional uint32 _user_id = 2;
    $GLOBALS ['USER_ID'] = $newObj->getUserId();

    //=======================================华丽的分割线================================================//
    // 第三步:填充数据
    // required uint32 _repeat = 1;
    $isRepeat = $newObj->getRepeat();
    $newObj->setRepeat(0);
    $buffKey = md5(serialize($newObj));
    $buffProtocol = null;
    if ($isRepeat > 0) {
        // 重发情况下,从缓存拿上次处理内容
        $buffProtocol = MessageProcessor::getBuffMessage($buffKey);
    }

    // server_time
    $nowTime = time();
    $retPacket->setSvrTime($nowTime);

    $clientVersion = "";
    $platId = 0;

 //    optional sdk_login _sdk_login = 38;   // sdk登陆消息
    $sdkLogin = $newObj->getSdkLogin();
    if (isset($sdkLogin)) {
        $clientVersion = $sdkLogin->getSessionKey();
        require_once($GLOBALS['GAME_ROOT'] . "Controller/SdkLoginApi.php");
        $sdkReply = SdkSessionApi($clientVersion);
        if(!$sdkReply)
        {
        	return 2;
        }
        
        $platId = $sdkLogin->getPlatId();
    }

    // optional login _login = 3;
    $login = $newObj->getLogin();
    if (isset($login)) {
        $loginReply = null;
        if (isset($buffProtocol)) {
            $loginReply = $buffProtocol->getLoginReply();
        }
        if (empty($loginReply)) {
            require_once($GLOBALS['GAME_ROOT'] . "Controller/LoginApi.php");
            $loginReply = LoginApi($svc, $login);
        }
        if (isset($loginReply)) {
        	if ( is_numeric($loginReply) )
        	{
                Logger::getLogger()->debug("getLoginReplyPacket test return data is_numeric" );
        		return $loginReply;
        	}
            Logger::getLogger()->debug("getLoginReplyPacket test return data not is_numeric".json_encode($loginReply));
            $retPacket->setLoginReply($loginReply);
        }
        $clientVersion = "";
    }
    $userId = $GLOBALS ['USER_ID']; // login消息会更新USER_ID
    $uin = $GLOBALS['USER_IN'];

    // optional enter_stage _enter_stage = 5; // 副本开始战斗
    $enterStage = $newObj->getEnterStage();
    if (isset($enterStage)) {
        $enterReply = null;
        if (isset($buffProtocol)) {
            $enterReply = $buffProtocol->getEnterStageReply();
        }
        if (empty($enterReply)) {
            require_once($GLOBALS['GAME_ROOT'] . "Controller/EnterStageApi.php");
            $enterReply = EnterStageApi($svc, $enterStage);
        }
        if (isset($enterReply)) {
            $retPacket->setEnterStageReply($enterReply);
        }
        $clientVersion = "";
    }

    // optional exit_stage _exit_stage = 6;  // 副本结束战斗
    $exitStage = $newObj->getExitStage();
    if (isset($exitStage)) {
        $exitReply = null;
        if (isset($buffProtocol)) {
            $exitReply = $buffProtocol->getExitStageReply();
        }
        if (empty($exitReply)) {
            require_once($GLOBALS['GAME_ROOT'] . "Controller/ExitStageApi.php");
            $exitReply = ExitStageApi($svc, $exitStage);
        }
        if (isset($exitReply)) {
            $retPacket->setExitStageReply($exitReply);
        }
        $clientVersion = "";
    }

    // optional gm_cmd _gm_cmd = 7; // GM 指令
    $gmCmd = $newObj->getGmCmd();
    if (isset($gmCmd)) {
    	if ( defined('ENABLE_GM_CMD') && ENABLE_GM_CMD )
    	{
    		require_once($GLOBALS['GAME_ROOT'] . "Controller/GmCmdApi.php");
    		//GmCmdApi($gmCmd);
    	}
    }

    // optional hero_upgrade _hero_upgrade = 8; // 需要进阶的英雄
    $heroUpgrade = $newObj->getHeroUpgrade();
    if (isset($heroUpgrade)) {
        $heroUpgradeReply = null;
        if (isset($buffProtocol)) {
            $heroUpgradeReply = $buffProtocol->getHeroUpgradeReply();
        }
        if (empty($heroUpgradeReply)) {
            require_once($GLOBALS['GAME_ROOT'] . "Controller/HeroUpgradeApi.php");
            $heroUpgradeReply = HeroUpgradeApi($svc, $heroUpgrade);
        }
        if (isset($heroUpgradeReply)) {
            $retPacket->setHeroUpgradeReply($heroUpgradeReply);
        }
    }

    // 9  需要合成的装备
    $equipSynthesis = $newObj->getEquipSynthesis();
    if (isset($equipSynthesis)) {
        $equipSynthesisReply = null;
        if (isset($buffProtocol)) {
            $equipSynthesisReply = $buffProtocol->getEquipSynthesisReply();
        }
        if (empty($equipSynthesisReply)) {
            require_once($GLOBALS["GAME_ROOT"] . "Controller/EquipSynthesisApi.php");
            $equipSynthesisReply = EquipSynthesisApi($equipSynthesis);
        }
        if (isset($equipSynthesisReply)) {
            $retPacket->setEquipSynthesisReply($equipSynthesisReply);
        }
    }

    // optional wear_equip = 10;   // 英雄穿装备
    $wearEquip = $newObj->getWearEquip();
    if (isset($wearEquip)) {
        $wearEquipReply = null;
        if (isset($buffProtocol)) {
            $wearEquipReply = $buffProtocol->getWearEquipReply();
        }
        if (empty($wearEquipReply)) {
            require_once($GLOBALS['GAME_ROOT'] . "Controller/WearEquipApi.php");
            $wearEquipReply = WearEquipApi($svc, $wearEquip);
        }
        if (isset($wearEquipReply)) {
            $retPacket->setWearEquipReply($wearEquipReply);
        }
    }

    // 11 吃经验丹
    $consumeItem = $newObj->getConsumeItem();
    if (isset($consumeItem)) {
        $consumeItemReply = null;
        if (isset($buffProtocol)) {
            $consumeItemReply = $buffProtocol->getConsumeItemReply();
        }
        if (empty($consumeItemReply)) {
            require_once($GLOBALS["GAME_ROOT"] . "Controller/ConsumeItemApi.php");
            $consumeItemReply = ConsumeItemApi($consumeItem);
        }
        if (isset($consumeItemReply)) {
            $retPacket->setConsumeItemReply($consumeItemReply);
        }
    }

    // optional shop_refresh _shop_refresh = 12; // 刷新商店
    $shopRefresh = $newObj->getShopRefresh();
    if (isset($shopRefresh)) {
        $shopRefreshReply = null;
        if (isset($buffProtocol)) {
            $shopRefreshReply = $buffProtocol->getShopRefreshReply();
        }
        if (empty($shopRefreshReply)) {
            require_once($GLOBALS['GAME_ROOT'] . "Controller/ShopApi.php");
            $shopRefreshReply = ShopRefreshApi($svc, $shopRefresh);
        }
        if (isset($shopRefreshReply)) {
            $retPacket->setShopRefreshReply($shopRefreshReply);
        }
    }

    // optional shop_consume _shop_consume = 13; // 购买物品
    $shopConsume = $newObj->getShopConsume();
    if (isset($shopConsume)) {
        $shopConsumeReply = null;
        if (isset($buffProtocol)) {
            $shopConsumeReply = $buffProtocol->getShopConsumeReply();
        }
        if (empty($shopConsumeReply)) {
            require_once($GLOBALS['GAME_ROOT'] . "Controller/ShopApi.php");
            $shopConsumeReply = ShopConsumeApi($svc, $shopConsume);
        }
        if (isset($shopConsumeReply)) {
            $retPacket->setShopConsumeReply($shopConsumeReply);
        }
    }

    // optional skill_levelup = 14;   // 技能升级
    $skillLevelUp = $newObj->getSkillLevelup();
    if (isset($skillLevelUp)) {
        $skillLevelUpReply = null;
        if (isset($buffProtocol)) {
            $skillLevelUpReply = $buffProtocol->getSkillLevelupReply();
        }
        if (empty($skillLevelUpReply)) {
            require_once($GLOBALS["GAME_ROOT"] . "Controller/SkillLevelUpApi.php");
            $skillLevelUpReply = SkillLevelUpApi($userId, $skillLevelUp->getHeroid(), $skillLevelUp->getOrder());
        }
        if (isset($skillLevelUpReply)) {
            $retPacket->setSkillLevelupReply($skillLevelUpReply);
        }
    }

    // optional sell_item _sell_item = 15; // 出售物品
    $sellItem = $newObj->getSellItem();
    if (isset($sellItem)) {
        $sellItemReply = null;
        if (isset($buffProtocol)) {
            $sellItemReply = $buffProtocol->getSellItemReply();
        }
        if (empty($sellItemReply)) {
            require_once($GLOBALS['GAME_ROOT'] . "Controller/ShopApi.php");
            $sellItemReply = SellItemApi($svc, $sellItem);
        }
        if (isset($sellItemReply)) {
            $retPacket->setSellItemReply($sellItemReply);
        }
    }

    // 16  碎片合成
    $fragmentCompose = $newObj->getFragmentCompose();
    if (isset($fragmentCompose)) {
        $fragmentComposeReply = null;
        if (isset($buffProtocol)) {
            $fragmentComposeReply = $buffProtocol->getFragmentComposeReply();
        }
        if (empty($fragmentComposeReply)) {
            require_once($GLOBALS["GAME_ROOT"] . "Controller/FragmentComposeApi.php");
            $fragmentComposeReply = FragmentComposeApi($fragmentCompose);
        }
        if (isset($fragmentComposeReply)) {
            $retPacket->setFragmentComposeReply($fragmentComposeReply);
        }
    }

    // optional hero_equip_upgrade _hero_equip_upgrade = 17;   // 英雄身上的装备进阶
    $equipUpgrade = $newObj->getHeroEquipUpgrade();
    if (isset($equipUpgrade)) {
        $equipUpgradeReply = null;
        if (isset($buffProtocol)) {
            $equipUpgradeReply = $buffProtocol->getHeroEquipUpgradeReply();
        }
        if (empty($equipUpgradeReply)) {
            require_once($GLOBALS['GAME_ROOT'] . "Controller/HeroEquipUpgradeApi.php");
            $equipUpgradeReply = HeroEquipUpgradeApi($svc, $equipUpgrade);
        }
        if (isset($equipUpgradeReply)) {
            $retPacket->setHeroEquipUpgradeReply($equipUpgradeReply);
        }
    }

    // trigger_task = 18;   // 触发任务
    $triggerTask = $newObj->getTriggerTask();
    if (isset($triggerTask)) {
        $triggerTaskReply = null;
        if (isset($buffProtocol)) {
            $triggerTaskReply = $buffProtocol->getTriggerTaskReply();
        }
        if (empty($triggerTaskReply)) {
            require_once($GLOBALS["GAME_ROOT"] . "Controller/TriggerTaskApi.php");
            $triggerTaskReply = new Down_TriggerTaskReply();
            foreach ($triggerTask->getTask() as $taskId) {
                $triggerTaskReply->appendResult(TriggerTaskApi($userId, $taskId));
            }
        }
        if (isset($triggerTaskReply)) {
            $retPacket->setTriggerTaskReply($triggerTaskReply);
        }
    }

    // require_rewards = 19;   // 请求任务奖励
    $requireRewards = $newObj->getRequireRewards();
    if (isset($requireRewards)) {
        $requireRewardReply = null;
        if (isset($buffProtocol)) {
            $requireRewardReply = $buffProtocol->getRequireRewardsReply();
        }
        if (empty($requireRewardReply)) {
            require_once($GLOBALS["GAME_ROOT"] . "Controller/RequireTaskRewardsApi.php");
            $requireRewardReply = RequireTaskRewardsApi($userId, $requireRewards->getLine(), $requireRewards->getId());
        }
        if (isset($requireRewardReply)) {
            $retPacket->setRequireRewardsReply($requireRewardReply);
        }
    }

    // job_rewards = 21;   // 每日活动奖励
    $jobRewards = $newObj->getJobRewards();
    if (isset($jobRewards)) {
        $jobRewardsReply = null;
        if (isset($buffProtocol)) {
            $jobRewardsReply = $buffProtocol->getJobRewardsReply();
        }
        if (empty($jobRewardsReply)) {
            require_once($GLOBALS["GAME_ROOT"] . "Controller/JobRewardsApi.php");
            $jobRewardsReply = JobRewardsApi($userId, $jobRewards->getJob());
        }
        if (isset($jobRewardsReply)) {
            $retPacket->setJobRewardsReply($jobRewardsReply);
        }
    }

    // optional reset_elite _reset_elite = 22;   // 精英关卡重置
    $resetElite = $newObj->getResetElite();
    if (isset($resetElite)) {
        $resetEliteReply = null;
        if (isset($buffProtocol)) {
            $resetEliteReply = $buffProtocol->getResetEliteReply();
        }
        if (empty($resetEliteReply)) {
            require_once($GLOBALS['GAME_ROOT'] . "Controller/ResetEliteApi.php");
            $resetEliteReply = ResetEliteApi($svc, $resetElite);
        }
        if (isset($resetEliteReply)) {
            $retPacket->setResetEliteReply($resetEliteReply);
        }
    }

    // optional sweep_stage _sweep_stage = 23;   // 关卡扫荡
    $sweepStage = $newObj->getSweepStage();
    if (isset($sweepStage)) {
        $sweepStageReply = null;
        if (isset($buffProtocol)) {
            $sweepStageReply = $buffProtocol->getSweepStageReply();
        }
        if (empty($sweepStageReply)) {
            require_once($GLOBALS['GAME_ROOT'] . "Controller/SweepStageApi.php");
            $sweepStageReply = SweepStageApi($svc, $sweepStage);
        }
        if (isset($sweepStageReply)) {
            $retPacket->setSweepStageReply($sweepStageReply);
        }
    }

    // optional buy_vitality _buy_vitality = 24;   // 购买体力
    $buyVitality = $newObj->getBuyVitality();
    if (isset($buyVitality)) {
        $syncVitalityReply = null;
        if (isset($buffProtocol)) {
            $syncVitalityReply = $buffProtocol->getSyncVitalityReply();
        }
        if (empty($syncVitalityReply)) {
            require_once($GLOBALS["GAME_ROOT"] . "Controller/BuyVitalityApi.php");
            $syncVitalityReply = BuyVitalityApi($userId,$buyVitality);
        }
        if (isset($syncVitalityReply)) {
            $retPacket->setSyncVitalityReply($syncVitalityReply);
        }
    }

    // optional buy_skill_stren_point = 25;// 重置技能强化点数
    $buySkillPoint = $newObj->getBuySkillStrenPoint();
    if (isset($buySkillPoint)) {
        $syncSkillSrenReply = null;
        if (isset($buffProtocol)) {
            $syncSkillSrenReply = $buffProtocol->getSyncSkillStrenReply();
        }
        if (empty($syncSkillSrenReply)) {
            require_once($GLOBALS["GAME_ROOT"] . "Controller/BuySkillStrenPointApi.php");
            $syncSkillSrenReply = BuySkillStrenPointApi($userId);
        }
        if (isset($syncSkillSrenReply)) {
            $retPacket->setSyncSkillStrenReply($syncSkillSrenReply);
        }
    }

    // 26 tavern
    $tavern = $newObj->getTavernDraw();
    if (isset($tavern)) {
        $tavernDrawReply = null;
        if (isset($buffProtocol)) {
            $tavernDrawReply = $buffProtocol->getTavernDrawReply();
        }
        if (empty($tavernDrawReply)) {
            require_once($GLOBALS["GAME_ROOT"] . "Controller/TavernDrawApi.php");
            $tavernDrawReply = TavernDrawApi($tavern);
        }
        if (isset($tavernDrawReply)) {
            $retPacket->setTavernDrawReply($tavernDrawReply);
        }
    }

    // optional query_data _query_data = 27;   // 查询玩家数据
    $queryData = $newObj->getQueryData();
    if (isset($queryData)) {
        $queryDataReply = null;
        if (isset($buffProtocol)) {
            $queryDataReply = $buffProtocol->getQueryDataReply();
        }
        if (empty($queryDataReply)) {
            require_once($GLOBALS["GAME_ROOT"] . "Controller/QueryDataApi.php");
            $queryDataReply = QueryDataApi($svc, $queryData);
        }
        if (isset($queryDataReply)) {
            $retPacket->setQueryDataReply($queryDataReply);
        }
    }

    // optional hero_evolve _hero_evolve = 28;   // 英雄进化
    $heroEvolve = $newObj->getHeroEvolve();
    if (isset($heroEvolve)) {
        $heroEvolveReply = null;
        if (isset($buffProtocol)) {
            $heroEvolveReply = $buffProtocol->getHeroEvolveReply();
        }
        if (empty($heroEvolveReply)) {
            require_once($GLOBALS['GAME_ROOT'] . "Controller/HeroEvolveApi.php");
            $heroEvolveReply = HeroEvolveApi($svc, $heroEvolve);
        }
        if (isset($heroEvolveReply)) {
            $retPacket->setHeroEvolveReply($heroEvolveReply);
        }
    }

    // optional enter_act_stage _enter_act_stage = 29;   // 进入活动关卡
    $actStage = $newObj->getEnterActStage();
    if (isset($actStage)) {
        $actStageReply = null;
        if (isset($buffProtocol)) {
            $actStageReply = $buffProtocol->getEnterStageReply();
        }
        if (empty($actStageReply)) {
            require_once($GLOBALS['GAME_ROOT'] . "Controller/EnterActStageApi.php");
            $actStageReply = EnterActStageApi($svc, $actStage);
        }
        if (isset($actStageReply)) {
            $retPacket->setEnterStageReply($actStageReply);
        }
        $clientVersion = "";
    }

    // optional sync_vitality = 30;   // 同步体力值
    $syncVitality = $newObj->getSyncVitality();
    if (isset($syncVitality)) {
        $syncVitalityReply = null;
        if (isset($buffProtocol)) {
            $syncVitalityReply = $buffProtocol->getSyncVitalityReply();
        }
        if (empty($syncVitalityReply)) {
            require_once($GLOBALS["GAME_ROOT"] . "Controller/VitalityApi.php");
            $syncVitalityReply = VitalityApi($userId);
        }
        if (isset($syncVitalityReply)) {
            $retPacket->setSyncVitalityReply($syncVitalityReply);
        }
    }

    // 31 客户端关闭日志
    $suspendReport = $newObj->getSuspendReport();
    if (isset($suspendReport))
    {
        require_once($GLOBALS["GAME_ROOT"] . "Controller/SuspendReportApi.php");
       SuspendReportApi($userId, $suspendReport->getGametime());
    }

    // optional tutorial _tutorial = 32;   // 新手引导
    $tutorial = $newObj->getTutorial();
    if (isset($tutorial)) {
        $tutorialReply = null;
        if (isset($buffProtocol)) {
            $tutorialReply = $buffProtocol->getTutorialReply();
        }
        if (empty($tutorialReply)) {
            require_once($GLOBALS['GAME_ROOT'] . "Controller/TutorialApi.php");
            $tutorialReply = TutorialApi($svc, $tutorial);
        }
        if (isset($tutorialReply)) {
            $retPacket->setTutorialReply($tutorialReply);
        }
    }

    // optional ladder _ladder = 33;   // pvp天梯
    $ladder = $newObj->getLadder();
    if (isset($ladder)) {
        $ladderReply = null;
        if (isset($buffProtocol)) {
            $ladderReply = $buffProtocol->getLadderReply();
        }
        if (empty($ladderReply)) {
            require_once($GLOBALS['GAME_ROOT'] . "Controller/LadderApi.php");
            $ladderReply = LadderApi($svc, $ladder);
        }
        if (isset($ladderReply)) {
            $retPacket->setLadderReply($ladderReply);
        }
    }

    // optional _set_name = 34;   // 设置玩家名字
    $setName = $newObj->getSetName();
    if (isset($setName)) {
        $setNameReply = null;
        if (isset($buffProtocol)) {
            $setNameReply = $buffProtocol->getSetNameReply();
        }
        if (empty($setNameReply)) {
            require_once($GLOBALS["GAME_ROOT"] . "Controller/SetNameApi.php");
            $setNameReply = SetNameApi($userId, $setName->getName());
        }
        if (isset($setNameReply)) {
            $retPacket->setSetNameReply($setNameReply);
        }
    }

    // optional _midas = 35;   // 点金手
    $useMidas = $newObj->getMidas();
    if (isset($useMidas)) {
        $midas_acquire = null;
        if (isset($buffProtocol)) {
            $midas_acquire = $buffProtocol->getMidasReply();
        }
        if (empty($midas_acquire)) {
            require_once($GLOBALS["GAME_ROOT"] . "Controller/MidasApi.php");
            $midas_acquire = MidasApi($userId, $useMidas->getTimes());
        }
        if (isset($midas_acquire)) {
            $retPacket->setMidasReply($midas_acquire);
        }
    }

    // optional open_shop = 36;   // 花钱打开神秘商店
    $openShop = $newObj->getOpenShop();
    if (isset($openShop)) {
        $openShop_reply = null;
        if (isset($buffProtocol)) {
            $openShop_reply = $buffProtocol->getOpenShopReply();
        }
        if (empty($openShop_reply)) {
            require_once($GLOBALS["GAME_ROOT"] . "Controller/ShopApi.php");
            $openShop_reply = OpenShopApi($userId, $openShop);
        }
        if (isset($openShop_reply)) {
            $retPacket->setOpenShopReply($openShop_reply);
        }
    }

    // optional set_avatar = 39;   // 设置头像
    $setAvatar = $newObj->getSetAvatar();
    if (isset($setAvatar)) {
        $setAvatarReply = null;
        if (isset($buffProtocol)) {
            $setAvatarReply = $buffProtocol->getSetAvatarReply();
        }
        if (empty($setAvatarReply)) {
            require_once($GLOBALS["GAME_ROOT"] . "Controller/SetAvatarApi.php");
            $setAvatarReply = SetAvatarApi($userId, $setAvatar->getAvatar());
        }
        if (isset($setAvatarReply)) {
            $retPacket->setSetAvatarReply($setAvatarReply);
        }
    }

    // optional ask_daily_login = 40;   // 每日签到
    $askDailyLogin = $newObj->getAskDailyLogin();
    if (isset($askDailyLogin)) {
        $askDailyLoginReply = null;
        if (isset($buffProtocol)) {
            $askDailyLoginReply = $buffProtocol->getAskDailyLoginReply();
        }
        if (empty($askDailyLoginReply)) {
            require_once($GLOBALS["GAME_ROOT"] . "Controller/DailyLoginApi.php");
            $askDailyLoginReply = DailyLoginApi($userId, $askDailyLogin->getStatus());
        }
        if (isset($askDailyLoginReply)) {
            $retPacket->setAskDailyLoginReply($askDailyLoginReply);
        }
    }

    // optional tbc = 41;   // 燃烧的远征
    $tbc = $newObj->getTbc();
    if (isset($tbc)) {
        $tbcReply = null;
        if (isset($buffProtocol)) {
            $tbcReply = $buffProtocol->getTbcReply();
        }
        if (empty($tbcReply)) {
            require_once($GLOBALS["GAME_ROOT"] . "Controller/TbcApi.php");
            $tbcReply = TbcApi($userId, $tbc);
        }
        if (isset($tbcReply)) {
            $retPacket->setTbcReply($tbcReply);
        }
    }

    // optional get_maillist = 42;   // 获取所有邮件
    $getMailList = $newObj->getGetMaillist();
    if (isset($getMailList)) {
        $getMailListReply = null;
        if (isset($buffProtocol)) {
            $getMailListReply = $buffProtocol->getGetMaillistReply();
        }
        if (empty($getMailListReply)) {
            require_once($GLOBALS["GAME_ROOT"] . "Controller/MailApi.php");
            $getMailListReply = GetMaillistApi($userId);
        }
        if (isset($getMailListReply)) {
            $retPacket->setGetMaillistReply($getMailListReply);
        }
    }

    // optional read_mail = 43;   // 阅读邮件
    $readMail = $newObj->getReadMail();
    if (isset($readMail)) {
        $readMailReply = null;
        if (isset($buffProtocol)) {
            $readMailReply = $buffProtocol->getReadMailReply();
        }
        if (empty($readMailReply)) {
            require_once($GLOBALS["GAME_ROOT"] . "Controller/MailApi.php");
            $readMailReply = ReadMailApi($userId, $readMail);
        }
        if (isset($readMailReply)) {
            $retPacket->setReadMailReply($readMailReply);
        }
    }

    // optional chat = 47;   // 聊天
    $chat = $newObj->getChat();
    if (isset($chat)) {
        $chatReply = null;
        if (isset($buffProtocol)) {
            $chatReply = $buffProtocol->getChatReply();
        }
        if (empty($chatReply)) {
            require_once($GLOBALS["GAME_ROOT"] . "Controller/ChatApi.php");
            $chatReply = ChatApi($userId, $chat);
        }
        if (isset($chatReply)) {
            $retPacket->setChatReply($chatReply);
        }
    }

    //49 guild
    $guild = $newObj->getGuild();
    if (isset($guild)) {
        $guildReply = null;
        if (isset($buffProtocol)) {
            $guildReply = $buffProtocol->getGuildReply();
        }
        if (empty($guildReply)) {
            require_once($GLOBALS["GAME_ROOT"] . "Controller/GuildApi.php");
            $guildReply = GuildApi($guild);
        }
        if (isset($guildReply)) {
            $retPacket->setGuildReply($guildReply);
        }
    }

    // 50 魂匣
    $magicSoul = $newObj->getAskMagicsoul();
    if (isset($magicSoul)) {
        $askMagicSoulReply = null;
        if (isset($buffProtocol)) {
            $askMagicSoulReply = $buffProtocol->getAskMagicsoulReply();
        }
        if (empty($askMagicSoulReply)) {
            require_once($GLOBALS["GAME_ROOT"] . "Controller/AskMagicsoulApi.php");
            $askMagicSoulReply = AskMagicsoulApi($magicSoul);
        }
        if (isset($askMagicSoulReply)) {
            $retPacket->setAskMagicsoulReply($askMagicSoulReply);
        }
    }

    //52 Excavate
    $excavate = $newObj->getExcavate();
    if (isset($excavate)) {
        $excavateReply = null;
        if (isset($buffProtocol)) {
            $excavateReply = $buffProtocol->getExcavateReply();
        }
        if (empty($excavateReply)) {
            require_once($GLOBALS["GAME_ROOT"] . "Controller/ExcavateApi.php");
            $excavateReply = ExcavateApi($excavate);
        }
        if (isset($excavateReply)) {
            $retPacket->setExcavateReply($excavateReply);
        }
    }

    // optional uint32 _change_server = 53; // 选服:0-get;1-change
    $changeServer = $newObj->getChangeServer();
    if (isset($changeServer)) {
        $changeServerReply = null;
        if (isset($buffProtocol)) {
            $changeServerReply = $buffProtocol->getChangeServerReply();
        }
        if (empty($changeServerReply)) {
            require_once($GLOBALS["GAME_ROOT"] . "Controller/ChangeServerApi.php");
            $changeServerReply = ChangeServerApi($svc, $changeServer);
        }
        if (isset($changeServerReply)) {
            $retPacket->setChangeServerReply($changeServerReply);
        }
        $clientVersion = "";
    }

    // optional system_setting     _system_setting     = 54;   // 系统设置
    $settings = $newObj->getSystemSetting();
    if (isset($settings)) {
        $settingsReply = null;
        if (isset($buffProtocol)) {
            $settingsReply = $buffProtocol->getSystemSettingReply();
        }
        if (empty($settingsReply)) {
            require_once($GLOBALS["GAME_ROOT"] . "Controller/UserSettingsApi.php");
            $settingsReply = UserSettingsApi($uin, $settings);
        }
        if (isset($settingsReply)) {
            $retPacket->setSystemSettingReply($settingsReply);
        }
    }

    //optional sync_skill_stren _sync_skill_stren = 61;   // 主动查询技能点
    $syncSkillSren = $newObj->getSyncSkillStren();
    if (isset($syncSkillSren)) {
        $syncSkillSrenReply = null;
        if (isset($buffProtocol)) {
            $syncSkillSrenReply = $buffProtocol->getSyncSkillStrenReply();
        }
        if (empty($syncSkillSrenReply)) {
            require_once($GLOBALS["GAME_ROOT"] . "Controller/SynSkillStrenApi.php");
            $syncSkillSrenReply = SynSkillStrenApi($userId);
        }
        if (isset($syncSkillSrenReply)) {
            $retPacket->setSyncSkillStrenReply($syncSkillSrenReply);
        }
    }
    
    
    
    //65 guild_log 公会日志
    $RequestGuildLog = $newObj->getRequestGuildLog();
    if (isset($RequestGuildLog)) {
    	$RequestGuildLogReply = null;
    	if (isset($buffProtocol)) {
    		$RequestGuildLogReply = $buffProtocol->getRequestGuildLogReply();
    	}
    	if (empty($RequestGuildLogReply)) {
    		require_once($GLOBALS["GAME_ROOT"] . "Controller/GuildApi.php");
    		$RequestGuildLogReply = GuildLogApi($RequestGuildLog); 
    	}
    	if (isset($RequestGuildLogReply)) {
    		$retPacket->setRequestGuildLogReply($RequestGuildLogReply);
    	}
    }
    
    
    //facebook 关注
    $facebookFollow = $newObj->getFbAttention();
    if (isset($facebookFollow)) {
    	$facebookFollowReply = null;
    	if (isset($buffProtocol)) {
    		$facebookFollowReply = $buffProtocol->getFbAttentionReply();
    	}
    	if (empty($facebookFollowReply)) {
    		require_once($GLOBALS["GAME_ROOT"] . "Controller/FacebookFollowApi.php");
    		$facebookFollowReply = FacebookFollowApi($userId);;
    	}
    	if (isset($facebookFollowReply)) {
    		$retPacket->setFbAttentionReply($facebookFollowReply);
    	}
    }
    
    // optional query_ranklist     _query_ranklist = 62;   // 查询排行榜
    $query_ranklist = $newObj->getQueryRanklist();
    if (isset($query_ranklist)) {
    	$QueryRanklistReply = null;
    	if (isset($buffProtocol)) {
    		$QueryRanklistReply = $buffProtocol->getQueryRanklistReply();
    	}
    	if (empty($QueryRanklistReply)) {
    		require_once($GLOBALS['GAME_ROOT'] . "Controller/QuerRankListApi.php");
    		$QueryRanklistReply = QuerRankListApi($svc, $query_ranklist);
    	}
    	if (isset($QueryRanklistReply)) {
    		$retPacket->setQueryRanklistReply($QueryRanklistReply);
    	}
    }
//     // optional dot_info     _dot_info = 301;   // 打点
    $DotInfo = $newObj->getDotInfo();
    if (isset($DotInfo)) {
    	$DotInfoReply = null;
    	if (empty($DotInfoReply)) {
    		require_once($GLOBALS['GAME_ROOT'] . "Controller/DotInfoApi.php");
    		$DotInfoReply = DotInfoApi($svc,$DotInfo);
    	}
    }
    //开启活动
    $openActivity = $newObj->getActivityInfo();
    if (isset($openActivity)) {
    	$openActivityReply = null;
    	if (isset($buffProtocol)) {
    		$openActivityReply = $buffProtocol->getActivityInfoReply();
    	}
    	if (empty($openActivityReply)) {
    		require_once($GLOBALS["GAME_ROOT"] . "Controller/OpenActivityApi.php");
    		$openActivityReply =OpenActivityApi($userId);;
    	}
    	if (isset($openActivityReply)) {    		
    		$retPacket->setActivityInfoReply($openActivityReply);
    	}
    }
    
    //大乐透
    $LottoActivity = $newObj->getActivityLottoInfo();
    if (isset($LottoActivity)) {
    	$LottoActivityReply = null;
    	if (isset($buffProtocol)) {
    		$LottoActivityReply = $buffProtocol->getActivityLottoInfoReply();
    	}
    	if (empty($LottoActivityReply)) {
    		require_once($GLOBALS["GAME_ROOT"] . "Controller/LottoActivityApi.php");
    		$LottoActivityReply = LottoActivityApi($userId);;
    	}
    	if (isset($LottoActivityReply)) {    		
    		$retPacket->setActivityLottoInfoReply($LottoActivityReply);
    	}
    }
    
    //end
    $LottoActivityReward = $newObj->getActivityLottoReward();
    if (isset($LottoActivityReward)) {
    	$LottoActivityRewardReply = null;
    	if (isset($buffProtocol)) {
    		$LottoActivityRewardReply = $buffProtocol->getActivityLottoRewardReply();
    	}
    	if (empty($LottoActivityRewardReply)) {
    		require_once($GLOBALS["GAME_ROOT"] . "Controller/LottoActivityApi.php");
    		$LottoActivityRewardReply = endLottoActivityApi($userId);;
    	}
    	if (isset($LottoActivityRewardReply)) {
    		$retPacket->setActivityLottoRewardReply($LottoActivityRewardReply);
    	}
    }
     
    //充值返利协议
    $ActivityRechargeRebate = $newObj->getRechargeRebate();
    if (isset($ActivityRechargeRebate)) {
    	$ActivityRechargeRebateReply = null;
    	if (isset($buffProtocol)) {
    		$ActivityRechargeRebateReply = $buffProtocol->getRechargeRebateReply();
    	}
    	if (empty($ActivityRechargeRebateReply)) {
    		require_once($GLOBALS["GAME_ROOT"] . "Controller/RechargeRebateApi.php");
    		$ActivityRechargeRebateReply = RechargeRebateApi($ActivityRechargeRebate,$userId);;
    	}
    	if (isset($ActivityRechargeRebateReply)) {
    		$retPacket->setRechargeRebateReply($ActivityRechargeRebateReply);
    	}
    }
    //     continue_pay_reply  302 每日充值
    $ContinuePay = $newObj->getContinuePay();
    if (isset($ContinuePay)) {
    	$ContinuePayReply = null;
    	if (isset($buffProtocol)) {
    		$ContinuePayReply = $buffProtocol->getContinuePayReply();
    	}
    	if (empty($ContinuePayReply)) {
    		require_once($GLOBALS['GAME_ROOT'] . "Controller/ContinuPayApi.php");
    		$QueryRanklistReply = ContinuPayApi($userId);
    	}
    	if (isset($QueryRanklistReply)) {
    		$retPacket->setContinuePayReply($QueryRanklistReply);
    	}
    }
    
    //圣诞天天乐
    $ActivityHappyEveryDay = $newObj->getEveryDayHappy();
    if (isset($ActivityHappyEveryDay)) {
    	$ActivityHappyEveryDayReply = null;
    	if (isset($buffProtocol)) {
    		$ActivityHappyEveryDayReply = $buffProtocol->getEveryDayHappyReply();
    	}
    	if (empty($ActivityHappyEveryDayReply)) {
    		require_once($GLOBALS["GAME_ROOT"] . "Controller/HappyEveryDayApi.php");
    		$ActivityHappyEveryDayReply = HappyEveryDayApi($ActivityHappyEveryDay,$userId);
    	}
    	if (isset($ActivityHappyEveryDayReply)) {
    		$retPacket->setEveryDayHappyReply($ActivityHappyEveryDayReply);
    	}
    }


   //    ChristmasGift   圣诞活动大礼包

   $ChristmasGift =$newObj->getActivityBigpackageInfo();
   if(isset($ChristmasGift)){
        $ChristmasGiftReply=null;
        if(isset($buffProtocol)){
            $ChristmasGiftReply=$buffProtocol->getActivityBigpackageInfoReply();
        }
        if(empty($ChristmasGiftReply)){
            require_once($GLOBALS['GAME_ROOT'].'Controller/ChristmasGiftApi.php');
            $QueryReply=ChristmasApi($userId);
        }
        if(isset($QueryReply)){
            $retPacket->setActivityBigpackageInfoReply($QueryReply);
        }
   }

   // activity_bigpackage_reward_info   圣诞抽奖
   $reward_info=$newObj->getActivityBigpackageRewardInfo();
 
   if(isset($reward_info)){
        $reward_info_reply=null;
        if(isset($buffProtocol)){
            $reward_info_reply=$buffProtocol->getActivityBigpackageRewardReply();
        }
        if(empty($reward_info_reply)){

            require_once($GLOBALS['GAME_ROOT'].'Controller/ChristmasGiftApi.php');
        $QueryRewardInfo=ChristmasRewardInfoApi($svc,$reward_info,$userId);
        }
        if(isset($QueryRewardInfo)){
            $retPacket->setActivityBigpackageRewardReply($QueryRewardInfo);
        }
   }

   //  activity_bigpackage_reset 圣诞活动重置
   $activity_reset=$newObj->getActivityBigpackageReset();
   if(isset($activity_reset)){
        $activity_reset_reply=null;
        if(isset($buffProtocol)){
            $activity_reset_reply=$buffProtocol->getActivityBigpackageResetReply();
        }
        if(empty($activity_reset_reply)){
            require_once($GLOBALS['GAME_ROOT'].'Controller/ChristmasGiftApi.php');
    //            Logger::getLogger()->debug(" -------------------------99999999999999999999999");
                $QueryActivityReset=ChristmasActivityResetApi($userId);
        }
        if(isset($QueryActivityReset)){
            $retPacket->setActivityBigpackageResetReply($QueryActivityReset);
        }
   }

    //=======================================华丽的分割线================================================//
    //所有协议在次之前处理
    require_once($GLOBALS['GAME_ROOT'] . "Classes/NotifyModule.php");
    $notify = NotifyModule::getAllNotifyDownInfo($userId);
    if (isset($notify)) {
        $retPacket->setNotifyMsg($notify);
    }

    /*
    ob_start();
    $retPacket->dump(true, 5);
    $debugLogStr_ = ob_get_contents();
    Logger::getLogger()->debug("OnProtoBuff Return Down_DownMsg Data:\r\n" . $debugLogStr_);
    $debugLogStr_ = null;
    ob_end_clean();
*/

    // 第四步:缓存最后一次协议返回, 用于repeat
    $diffTime = microtime(TRUE) - $startTime;
    if (isset($buffProtocol)) {
        Logger::getLogger()->debug("{$diffTime} : OnProtoBuff Repeat Process End! UIN = " . $GLOBALS['USER_IN']);
    } else {
        MessageProcessor::setBuffMessage($buffKey, $retPacket);
        Logger::getLogger()->debug("{$diffTime} : OnProtoBuff Process End! UIN = " . $GLOBALS['USER_IN']);
    }

    $retCode = 0;
    if ($clientVersion != "") {
        $isNeed = MessageProcessor::getNeedUpdateVersion($platId, $clientVersion);
        if ($isNeed) {
            $retCode = 3;
        }
    }
    // $diffTime = microtime(TRUE) - $startTime;
    // Logger::getLogger()->info("[". getmypid() . "] OnProtoBuff $pbcommand cost {$diffTime}");

    return $retCode;
}
