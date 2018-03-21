<?php

require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");

function EnterActStageApi(WorldSvc $svc, Up_EnterActStage $pPacket)
{
    $userId = $GLOBALS ['USER_ID'];
    $stageGroup = $pPacket->getStageGroup();
    $stageId = $pPacket->getStage();
    Logger::getLogger()->debug("EnterActStageApi Process userId={$userId},stageGroup={$stageGroup},stageId={$stageId}");

    $stageType = StageModule::getStageType($stageId);
    if ($stageType != ACT_STAGE) {
        Logger::getLogger()->error("EnterActStageApi stage not act type!");
        return null;
    }
	$DataModule = DataModule::getInstance();
    $stageTb = $DataModule->getDataSetting(STAGE_LUA_KEY);
    if (empty($stageTb[$stageId])) {
        Logger::getLogger()->error("EnterActStageApi stage id not defined!");
        return null;
    }
    $oneStage = $stageTb[$stageId];
    $tbGroup = intval($oneStage["Stage Group"]);
    if ($tbGroup != $stageGroup) {
        Logger::getLogger()->error("EnterActStageApi stage group id not match!");
        return null;
    }

    $groupTable = $DataModule->lookupDataTable(STAGE_GROUP_LUA_KEY, null, array($stageGroup));
    $gameTime = SQLUtil::gameNow();
    $curDayOfWeek = date("l", $gameTime);
    if (!$groupTable[$curDayOfWeek]) {
        if (DailyActivityModule::hasOpenExerciseActivity($gameTime) == false) {
            Logger::getLogger()->error("EnterActStageApi group not open today:" . $curDayOfWeek . ",day key=" . date('Ymd', $gameTime));
            return null;
        }
    }

    $dailyInfoArr = StageModule::getActStageDailyRecord($userId, $stageGroup);
    //["CD"] = 10min, default
    $nowTime = time();
    $cd = intval($groupTable["CD"]);
    if ($cd > 0) {
        if (($nowTime - $dailyInfoArr[1]) < $cd) {
            Logger::getLogger()->error("EnterActStageApi cd not pass!" . $dailyInfoArr[1]);
            return null;
        }
    }

    //["DailyLimit"] = 2,
    $dailyLimit = intval($groupTable["DailyLimit"]);
    if ($dailyLimit > 0) {
        if ($dailyInfoArr[0] >= $dailyLimit) {
            Logger::getLogger()->error("EnterActStageApi today enter time full! " . $dailyInfoArr[0]);
            return null;
        }
    }

    //["Unlock Level"] = 1,
    $plyLevel = PlayerCacheModule::getPlayerLevel($userId);
    $unlockLv = intval($oneStage["Unlock Level"]);
    if ($plyLevel < $unlockLv) {
        Logger::getLogger()->error("EnterStageApi player level low " . $plyLevel);
        return null;
    }

    //["Vit Return"] = 5,
    $returnVit = intval($oneStage["Vit Return"]);
    //["Vitality Cost"] = 6,
    $costVit = intval($oneStage["Vitality Cost"]);

    $sysVit = VitalityModule::getVitalityTable($userId);
    if ($sysVit->getCurVitality() < $costVit) {
        Logger::getLogger()->error("EnterStageApi player vit low " . $sysVit->getCurVitality());
        return null;
    }

    $enterCost = max(0, ($costVit - $returnVit));
    $reason = "EnterStageApi:" . $stageId;
    VitalityModule::modifyVitality($userId, -$enterCost, $reason);

    $lootArr = array();
    $sysBattle = StageModule::getBattleTable($userId);
    if ($sysBattle->getStageId() == $stageId) {
        $lootInfo = explode("|", $sysBattle->getLoot());
        foreach ($lootInfo as $loot) {
            $lootDetail = explode("-", $loot);
            if (count($lootDetail) >= 4) {
                $lootArr[] = $lootDetail;
            }
        }
    } else {
        $lootArr = LootModule::getLootInfo($userId, $stageId);

        $sysBattle->setStageGroup($stageGroup);
        $sysBattle->setEnterStageTime(time());
        $sysBattle->setStageId($stageId);
        $sysBattle->setSrand(mt_rand(1, 999));

        if (count($lootArr) > 0) {
            $LootStrArr = array();
            foreach ($lootArr as $lootInfo) {
                $LootStrArr[] = implode("-", $lootInfo);
            }

            $sysBattle->setLoot(implode("|", $LootStrArr));
        } else {
            $sysBattle->setLoot("");
        }
        $sysBattle->save();
    }

    $reply = new Down_EnterStageReply();
    $reply->setRseed($sysBattle->getSrand());

    foreach ($lootArr as $oneLoot) {
        $arg_arr = array(3, intval($oneLoot[0]), 3, intval($oneLoot[1]), 10, intval($oneLoot[2]));
        $reply->appendLoots(MathUtil::makeBits($arg_arr));
    }

    return $reply;
}