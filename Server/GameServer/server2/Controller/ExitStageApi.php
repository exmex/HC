<?php

require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/TaskModule.php");

function ExitStageApi(WorldSvc $svc, Up_ExitStage $pPacket)
{
    $userId = $GLOBALS ['USER_ID'];
    Logger::getLogger()->debug("ExitStageApi Process userId=" . $userId);

    $SysBattle = StageModule::getBattleTable($userId);

    $stageId = $SysBattle->getStageId();
    $shopArr = array();
    $ret = exitStageProcess($userId, $SysBattle, $pPacket, $shopArr);
    $retReply = new Down_ExitStageReply();
    $retReply->setResult(Down_ExitStageReply_ExitStageResult::known);

    if ($ret) {
        StageModule::clearBattleStageInfo($SysBattle);
        // update shop
        foreach ($shopArr as $shopTid) {
            $shopDownInfo = ShopModule::unlockShop($userId, $stageId, $shopTid);
            if (isset($shopDownInfo)) {
                if ($shopTid == 6) {
                    $retReply->setSshop($shopDownInfo);
                } else {
                    $retReply->setShop($shopDownInfo);
                }
            }
        }
        TaskModule::triggerFarmStageTask($userId, $stageId);
    }
    return $retReply;
}


function exitStageProcess($userId, SysPlayerBattle $SysBattle, Up_ExitStage $packet, &$shopArr)
{
    $stageGroup = $SysBattle->getStageGroup();
    $stageId = $SysBattle->getStageId();
    Logger::getLogger()->debug("ExitStageApi Process stage_id=" . $stageId);
    if ($stageId == 0) {
        Logger::getLogger()->error("ExitStageApi enter stage is null");
        return false;
    }

    if ($packet->getResult() != Up_BattleResult::victory) {
        return false;
    }

    $DataModule = DataModule::getInstance();
    $stageTable =$DataModule->getDataSetting(STAGE_LUA_KEY);
    
    if (empty($stageTable[$stageId])) {
        Logger::getLogger()->error("ExitStageApi stage id not defined!");
        return false;
    }
    $oneStage = $stageTable[$stageId];

    // vit
    $returnVit = intval($oneStage["Vit Return"]);
    $SysVit = VitalityModule::getVitalityTable($userId);
    if ($SysVit->getCurVitality() < $returnVit) {
        Logger::getLogger()->error("ExitStageApi player vit low " . $SysVit->getCurVitality());
        return false;
    }
    $reason = "ExitStage:" . $stageId;
    VitalityModule::modifyVitality($userId, -$returnVit, $reason);

    // exp
    $plyExpReward = intval($oneStage["Exp Reward"]);
    PlayerModule::modifyPlyExp($userId, $plyExpReward, $reason);

    // hero exp
    $heroExpReward = intval($oneStage["Heroexp Reward"]);
    HeroModule::modifyHeroExp($userId, $packet->getHeroes(), $heroExpReward, $reason);

    // money
    $moneyReward = intval($oneStage["Money Reward"]);
    PlayerModule::modifyMoney($userId, $moneyReward, $reason);

    // loot
    $itemIdArr = array();
    $lootIdArr = array();
    $globalLootIdArr = array();
    $lootInfo = explode("|", $SysBattle->getLoot());
    foreach ($lootInfo as $loot) {
        $lootDetail = explode("-", $loot);
        if (count($lootDetail) >= 4) {
            $realLootItem = intval($lootDetail[2]);
            if (empty($itemIdArr [$realLootItem])) {
                $itemIdArr [$realLootItem] = 0;
            }
            $itemIdArr [$realLootItem] += 1;

            // 0 is world loot, other is boss loot(not frag)
            $randLootItem = intval($lootDetail[3]);
            if ($randLootItem > 0) {
                if (empty($lootIdArr [$randLootItem])) {
                    $lootIdArr [$randLootItem] = 0;
                }
                $lootIdArr [$randLootItem] += 1;
            } else {
                $globalLootItem = intval($lootDetail[2]);
                if (empty($globalLootIdArr [$globalLootItem])) {
                    $globalLootIdArr [$globalLootItem] = 0;
                }
                $globalLootIdArr [$globalLootItem] += 1;
            }
        }
    }
    ItemModule::addItem($userId, $itemIdArr, $reason);

    $stageType = StageModule::getStageType($stageId);
    // update loot memcache
    if ($stageType != ACT_STAGE) {
        LootModule::updateUserLootRecord($userId, $stageId, $lootIdArr);
        LootModule::updateUserGlobalLoot($userId, $globalLootIdArr);
    }

    // stage complete
    switch ($stageType) {
        case NORMAL_STAGE:
            StageModule::updateNormalStageProgress($userId, $stageId, $packet->getStars());
            TaskModule::updateDailyTaskProgress($userId, DAILY_TASK_FARM_PVE_STAGE);
            break;

        case ELITE_STAGE:
            StageModule::updateEliteStageProgress($userId, $stageId, $packet->getStars());
            TaskModule::updateDailyTaskProgress($userId, DAILY_TASK_FARM_ELITE_PVE_STAGE);
            TaskModule::updateDailyTaskProgress($userId, DAILY_TASK_FARM_PVE_STAGE);
            break;

        case ACT_STAGE:
            StageModule::updateActStageProgress($userId, $stageGroup);
            if (intval($stageGroup) <= 20002) {
                TaskModule::updateDailyTaskProgress($userId, DAILY_TASK_FARM_CHAPTER_102);
            } else {
                TaskModule::updateDailyTaskProgress($userId, DAILY_TASK_FARM_CHAPTER_103);
            }
            break;

        default:
            break;
    }

    for ($i = 1; $i <= 2; $i++) {
        $ShopIdKey = "Merchant {$i} ID";
        $ShopProKey = "Merchant {$i} Prob";

        $ShopPro = floor(doubleval($oneStage[$ShopProKey]) * 1000);
        $RankVal = mt_rand(1, 1000);
        if ($ShopPro >= $RankVal) {
            $shopArr[] = intval($oneStage[$ShopIdKey]);
        }
    }

    Logger::getLogger()->debug("ExitStageApi Process end!");
    return true;
}