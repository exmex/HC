<?php

require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");

function EnterStageApi(WorldSvc $svc, Up_EnterStage $pPacket)
{
    $userId = $GLOBALS ['USER_ID'];
    $stageId = $pPacket->getStageId();
    Logger::getLogger()->debug("EnterStageApi Process userId = " . $userId . " stageId = " . $stageId);

    $stageType = StageModule::getStageType($stageId); //NORMAL_STAGE
    if (($stageType != NORMAL_STAGE) && ($stageType != ELITE_STAGE)) {
        Logger::getLogger()->error("EnterStageApi stage not normal.");
        return null;
    }

    $DataModule = DataModule::getInstance();
    $stageTb = $DataModule->getDataSetting(STAGE_LUA_KEY);
    if (empty($stageTb[$stageId])) {
        Logger::getLogger()->error("EnterStageApi stage id not defined.");
        return null;
    }
    $oneStage = $stageTb[$stageId];

    //["Require Stage"] = 1,
    $reqStage = intval($oneStage["Require Stage"]);
    $regStageType = StageModule::getStageType($reqStage);
    if ($regStageType == NORMAL_STAGE) { // normal
        $SysStage = StageModule::getNormalStageTable($userId);
        $reqSeq = $reqStage - 1;
    } else { // elite
        $SysStage = StageModule::getEliteStageTable($userId);
        $reqSeq = $reqStage - MAX_NORMAL_STAGE_ID - 1;
    }
    if ($reqStage > 0) {
        if ($SysStage->getMaxStageId() < $reqStage) {
            Logger::getLogger()->error("EnterStageApi require stage not pass" . $SysStage->getMaxStageId());
            return null;
        }

        //["Require Stars"] = 1,
        $starArr = explode("|", $SysStage->getStageStars());
        $reqStar = intval($oneStage["Require Stars"]);
        if (empty($starArr[$reqSeq]) || (intval($starArr[$reqSeq]) < $reqStar)) {
            Logger::getLogger()->error("EnterStageApi require star low");
            return null;
        }
    }

    $isFirstDown = false;
    if ($SysStage->getMaxStageId() < $stageId) {
        $isFirstDown = true;
    }

    //["Daily Limit"] = 0,
    $dailyLimit = intval($oneStage["Daily Limit"]);
    if ($dailyLimit > 0) {
        $dailyTimesArr = StageModule::getEliteStageDailyRecord($userId, $stageId);
        if ($dailyTimesArr[0] >= $dailyLimit) {
            Logger::getLogger()->error("EnterStageApi today enter time full! " . $dailyTimesArr[0]);
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

    $SysVit = VitalityModule::getVitalityTable($userId);
    if ($SysVit->getCurVitality() < $costVit) {
        Logger::getLogger()->error("EnterStageApi player vit low " . $SysVit->getCurVitality());
        return null;
    }

    $enterCost = max(0, ($costVit - $returnVit));
    $reason = "EnterStageApi:" . $stageId;
    VitalityModule::modifyVitality($userId, -$enterCost, $reason);

    $lootArr = array();
    $SysBattle = StageModule::getBattleTable($userId);
    if ($SysBattle->getStageId() == $stageId) {
        $lootInfo = explode("|", $SysBattle->getLoot());
        foreach ($lootInfo as $loot) {
            $lootDetail = explode("-", $loot);
            if (count($lootDetail) >= 4) {
                $lootArr[] = $lootDetail;
            }
        }
    } else {
        $lootArr = LootModule::getLootInfo($userId, $stageId, false, $isFirstDown);

        $SysBattle->setEnterStageTime(time());
        $SysBattle->setStageId($stageId);
        $SysBattle->setSrand(mt_rand(1, 999));

        if (count($lootArr) > 0) {
            $LootStrArr = array();
            foreach ($lootArr as $lootInfo) {
                $LootStrArr[] = implode("-", $lootInfo);
            }

            $SysBattle->setLoot(implode("|", $LootStrArr));
        } else {
            $SysBattle->setLoot("");
        }
        $SysBattle->save();
    }

    $reply = new Down_EnterStageReply();
    $reply->setRseed($SysBattle->getSrand());

    foreach ($lootArr as $oneLoot) {
        $arg_arr = array(3, intval($oneLoot[0]), 3, intval($oneLoot[1]), 10, intval($oneLoot[2]));
        $reply->appendLoots(MathUtil::makeBits($arg_arr));
    }

    return $reply;
}