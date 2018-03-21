<?php
/**
 * @Author:      jaylu
 * @Date:        2015-01-15 
 * @Description: Description
 * @email:       jay@xxxx.com
 */
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/VipModule.php");

/**
 * 精英关卡重置
 * @param WorldSvc      $svc     [description]
 * @param Up_ResetElite $pPacket [description]
 */
function resetEliteApi(WorldSvc $svc, Up_ResetElite $pPacket){
    $userId = $GLOBALS ['USER_ID'];
    $stageId = $pPacket->getStageId();
    $payType = $pPacket->getType();
    Logger::getLogger()->debug("***************resetElite userId = {$userId} stageId = {$stageId} pay = {$payType}");
    $result = resetEliteProcess($userId, $stageId, $payType);
    $resp = new Down_ResetEliteReply();
    if ($result) {
        $resp->setResult(Down_Result::success);
    } else {
        $resp->setResult(Down_Result::fail);
    }
    return $resp;
}

function resetEliteProcess($userId, $stageId, $payType){
    if ($payType == Up_ResetElite_Rtype::daily_free) {
        StageModule::getEliteStageTable($userId);
        return true;
    }
    $stageType = StageModule::getStageType($stageId);
    if ($stageType != ELITE_STAGE) {
        Logger::getLogger()->error("OnResetElite stage id is not elite!" . $stageId);
        return false;
    }
    $stageData = DataModule::getInstance()->getDataSetting(STAGE_LUA_KEY);
    if (empty($stageData[$stageId])) {
        Logger::getLogger()->error("OnResetElite stage id not defined!");
        return false;
    }
    $oneStage = $stageData[$stageId];
    //["Daily Limit"] = 0,
    $dailyLimit = intval($oneStage["Daily Limit"]);
    if ($dailyLimit <= 0) {
        Logger::getLogger()->error("OnResetElite stage not need reset! " . $dailyLimit);
        return false;
    }
    $dailyTimesArr = StageModule::getEliteStageDailyRecord($userId, $stageId);
    if ($dailyTimesArr[0] < $dailyLimit) {
        Logger::getLogger()->error("OnResetElite today enter time not full! " . $dailyTimesArr[0]);
        return false;
    }
    //vip限制每日可以reset的次数
    $resetLimit = VipModule::getVIPModuleLimitByUserId($userId, _VIP_MODULE_TYPE::ELITE_RESET);
    if ($dailyTimesArr[1] >= $resetLimit) {
        Logger::getLogger()->error("OnResetElite today reach vip limit, now {$dailyTimesArr[1]}");
        return false;
    }
    $resetTimes = $dailyTimesArr[1] + 1;
    $cost = intval(DataModule::lookupDataTable(GRADIENT_PRICE_LUA_KEY, "Elite Reset", array($resetTimes)));
    $playerData = PlayerModule::getPlayerTable($userId);
    if ($playerData->getGem() < $cost) {
        Logger::getLogger()->error("OnResetElite gem not enough! " . $playerData->getGem());
        return false;
    }
    $reason = "OnResetElite:{$stageId}-{$resetTimes}";
    PlayerModule::modifyGem($userId, -$cost, $reason);
    StageModule::resetEliteDailyTimes($userId, $stageId);
    return true;
}