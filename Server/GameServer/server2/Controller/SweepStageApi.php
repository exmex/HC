<?php
/**
 * @Author:      jaylu
 * @Date:        2015-01-15 
 * @Description: Description
 * @email:       jay@xxxx.com
 */
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/VipModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/TaskModule.php");
define("EXP_EXCHANGE_ITEM_ID", "169");

/**
 * 关卡扫荡
 * @param  WorldSvc      $svc     [description]
 * @param  Up_SweepStage $pPacket [description]
 * @return [type]                 [description]
 */
function sweepStageApi(WorldSvc $svc, Up_SweepStage $pPacket){
    $userId = $GLOBALS ['USER_ID'];
    $stageId = $pPacket->getStageId();
    $type = $pPacket->getType();
    $times = $pPacket->getTimes();
    Logger::getLogger()->debug("OnSweepStage Process userId={$userId},stageId={$stageId},type={$type},times={$times}");
    $result = sweepStageProcess($userId, $stageId, $type, $times);
    return $result;
}

function sweepStageProcess($userId, $stageId, $type, $times){
    if ($times <= 0) {
        Logger::getLogger()->error("sweepStageProcess time invalid! " . $times);
        return null;
    }
    if ($times == 1) {
        $vipState = VipModule::getVIPModuleLimitByUserId($userId, _VIP_MODULE_TYPE::RAID_ONE_FUNCTION);
        if (empty($vipState)) {
            Logger::getLogger()->error("sweepStageProcess one vip module limit wrong!");
            return null;
        }
    }
    if ($times > 1) {
        $vipState = VipModule::getVIPModuleLimitByUserId($userId, _VIP_MODULE_TYPE::RAID_TEN_FUNCTION);
        if (empty($vipState)) {
            Logger::getLogger()->error("sweepStageProcess ten vip module limit wrong!");
            return null;
        }
    }
    if ($type == Up_SweepStage_Rtype::sweep_with_rmb) {
        $vipState = VipModule::getVIPModuleLimitByUserId($userId, _VIP_MODULE_TYPE::RAID_WITH_DIAMOND);
        if (empty($vipState)) {
            Logger::getLogger()->error("sweepStageProcess diamond vip module limit wrong!");
            return null;
        }
    }
    $stageType = StageModule::getStageType($stageId);
    if (($stageType != NORMAL_STAGE) && ($stageType != ELITE_STAGE)) {
        Logger::getLogger()->error("sweepStageProcess stage not normal or elite type!");
        return null;
    }
    $stageTable = DataModule::getInstance()->getDataSetting(STAGE_LUA_KEY);
    if (empty($stageTable[$stageId])) {
        Logger::getLogger()->error("sweepStageProcess stage id not defined!");
        return null;
    }
    $oneStage = $stageTable[$stageId];
    $stageType = StageModule::getStageType($stageId);
    if ($stageType == NORMAL_STAGE) { // normal
        $objStage = StageModule::getNormalStageTable($userId);
        $stageSeq = $stageId - 1;
    } else {
        $objStage = StageModule::getEliteStageTable($userId); // elite
        $stageSeq = $stageId - MAX_NORMAL_STAGE_ID - 1;
    }
    if ($objStage->getMaxStageId() < $stageId) {
        Logger::getLogger()->error("sweepStageProcess require stage not pass" . $objStage->getMaxStageId());
        return null;
    }
    $starArr = explode("|", $objStage->getStageStars());
    if (empty($starArr[$stageSeq]) || (intval($starArr[$stageSeq]) != 3)) {
        Logger::getLogger()->error("sweepStageProcess require star low!");
        return null;
    }

    if ($stageType == ELITE_STAGE) {
        $dailyLimit = intval($oneStage["Daily Limit"]);
        if ($dailyLimit > 0) {
            $dailyTimesArr = StageModule::getEliteStageDailyRecord($userId, $stageId);
            $afterTimes = $dailyTimesArr[0] + $times;
            if ($afterTimes > $dailyLimit) {
                Logger::getLogger()->error("sweepStageProcess today enter time full! " . $dailyTimesArr[0]);
                return null;
            }
        }
    }

    $costVit = intval($oneStage["Vitality Cost"]) * $times;
    $tbVit = VitalityModule::getVitalityTable($userId);
    if ($tbVit->getCurVitality() < $costVit) {
        Logger::getLogger()->error("sweepStageProcess player vit low " . $tbVit->getCurVitality());
        return null;
    }

    $reason = "SweepStage:" . $stageId;
    if ($type == Up_SweepStage_Rtype::sweep_with_ticket) {
        $ticketId = ParamModule::GetSweepCoinId();
        $costTicketNum = $times;
        $subRet = ItemModule::subItem($userId, array($ticketId => $costTicketNum), $reason);
        if (!$subRet) {
            return null;
        }
    } else {
        $tbPlayer = PlayerModule::getPlayerTable($userId);
        $sweepUnit = ParamModule::GetPaySweepPrice();
        $gemCost = $sweepUnit * $times;
        if ($tbPlayer->getGem() < $gemCost) {
            Logger::getLogger()->error("sweepStageProcess gem not enough:" . $tbPlayer->getGem());
            return null;
        }

        PlayerModule::modifyGem($userId, -$gemCost, $reason);
    }

    VitalityModule::modifyVitality($userId, -$costVit, $reason);
    // 经验值
    $plyExpReward = intval($oneStage["Exp Reward"]);
    PlayerModule::modifyPlyExp($userId, $plyExpReward * $times, $reason);
    // 金币
    $moneyReward = intval($oneStage["Money Reward"]);
    PlayerModule::modifyMoney($userId, $moneyReward * $times, $reason);

    $reply = new Down_SweepStageReply();
    $itemIdArr = array();
    for ($index = 0; $index < $times; $index++) {
        $oneLootArr = array();
        $lootArr = LootModule::getLootInfo($userId, $stageId, true);
        foreach ($lootArr as $loot) {
            if (empty($oneLootArr [intval($loot[2])])) {
                $oneLootArr [intval($loot[2])] = 0;
            }
            $oneLootArr [intval($loot[2])] += 1;

            if (empty($itemIdArr [intval($loot[2])])) {
                $itemIdArr [intval($loot[2])] = 0;
            }
            $itemIdArr [intval($loot[2])] += 1;
        }
        $sweepLoot = new Down_Sweeploot();
        $sweepLoot->setExp($plyExpReward);
        $sweepLoot->setMoney($moneyReward);
        foreach ($oneLootArr as $itemId => $itemCount) {
            $arg_arr = array(11, intval($itemCount), 10, $itemId);
            $sweepLoot->appendItems(MathUtil::makeBits($arg_arr));
        }
        $reply->appendLoot($sweepLoot);
    }
    // 关卡扫荡 loop
    for ($i = 1; $i <= 3; $i++) {
        $raidBonusType = strval($oneStage["Raid Bonus Type {$i}"]);
        $raidBonusId = intval($oneStage["Raid Bonus ID {$i}"]);
        $raidBonusAmount = intval($oneStage["Raid Bonus Amount {$i}"]) * $times;
        if (($raidBonusType == "Item") && ($raidBonusAmount > 0)) {
            if (empty($itemIdArr [$raidBonusId])) {
                $itemIdArr [$raidBonusId] = 0;
            }
            $itemIdArr [$raidBonusId] += $raidBonusAmount;
            $arg_arr = array(11, intval($raidBonusAmount), 10, $raidBonusId);
            $reply->appendItems(MathUtil::makeBits($arg_arr));
        }
    }
    ItemModule::addItem($userId, $itemIdArr, $reason);
    // stage complete
    switch ($stageType) {
        case NORMAL_STAGE:
            TaskModule::updateDailyTaskProgress($userId, DAILY_TASK_FARM_PVE_STAGE, $times);
            TaskModule::triggerFarmStageTask($userId, $stageId, $times);
            break;
        case ELITE_STAGE:
            StageModule::updateEliteStageProgress($userId, $stageId, 3, $times);
            TaskModule::updateDailyTaskProgress($userId, DAILY_TASK_FARM_ELITE_PVE_STAGE, $times);
            TaskModule::updateDailyTaskProgress($userId, DAILY_TASK_FARM_PVE_STAGE, $times);
            TaskModule::triggerFarmStageTask($userId, $stageId, $times);
            break;
        default:
            break;
    }

    for ($index = 1; $index <= 2; $index++) {
        $shopIdKey = "Merchant {$index} ID";
        $shopProKey = "Merchant {$index} Prob";
        $shopPro = floor(doubleval($oneStage[$shopProKey]) * 1000) * $times;
        $rankValue = mt_rand(1, 1000);
        if ($shopPro >= $rankValue) {
            $shopTid = intval($oneStage[$shopIdKey]);
            $shopDownInfo = ShopModule::unlockShop($userId, $stageId, $shopTid);
            if (isset($shopDownInfo)) {
                if ($shopTid == 6) {
                    $reply->setSshop($shopDownInfo);
                } else {
                    $reply->setShop($shopDownInfo);
                }
            }
        }
    }
    return $reply;
}