<?php
/**
 * author jay
 * Date  2015-01-13
 * 
 */
require_once($GLOBALS["GAME_ROOT"] . "Classes/DataModule.php");
require_once($GLOBALS["GAME_ROOT"] . "Classes/VipModule.php");
require_once($GLOBALS["GAME_ROOT"] . "Classes/PlayerModule.php");
require_once($GLOBALS["GAME_ROOT"] . "Classes/TaskModule.php");

/**
 * 每日活动奖励
 * @param [type] $userId [description]
 * @param [type] $jobId  [description]
 */
function JobRewardsApi($userId, $jobId){
    Logger::getLogger()->debug("OnJobRewards Process jobId=" . $jobId);
    $jobRewardsReply = new Down_JobRewardsReply();
    $jobRewardsReply->setResult(Down_Result::fail);
    $todoTask = TaskModule::getDailyJobTable($userId, $jobId);
    //检查是否有该日常任务
    if (empty($todoTask)) {
        Logger::getLogger()->error("OnJobRewards not receive this job!");
        return $jobRewardsReply;
    }
    //检查今日是否已经领取过奖励
    if ($todoTask->getClaimRewardTime() != 0 && !SQLUtil::isTimeNeedReset($todoTask->getClaimRewardTime())) {
        Logger::getLogger()->error("OnJobRewards today has claimed!");
        return $jobRewardsReply;
    }
    if ($todoTask->getLastResetTime() != 0 && SQLUtil::isTimeNeedReset($todoTask->getLastResetTime())) {
        Logger::getLogger()->error("OnJobRewards need reset this quest!");
        return $jobRewardsReply;
    }
    //获取配置表
    $todoListSettings = DataModule::getInstance()->getDataSetting(TODO_LIST_LUA_KEY);
    if (empty($todoListSettings) || empty($todoListSettings[$jobId])){
        Logger::getLogger()->error("OnJobRewards job rule is null!");
        return $jobRewardsReply;
    }
    //检查任务是否完成
    $dailyJobSetting = $todoListSettings[$jobId];
    if (!checkFinish($userId, $dailyJobSetting, $todoTask)) {
        Logger::getLogger()->error("OnJobRewards not finish job!");
        return $jobRewardsReply;
    }
    //执行奖励  更新奖励领取时间
    $todoTask->setClaimRewardTime(time());
    $todoTask->setTaskTarget(0);
    doTaskReward($userId, $jobId, $dailyJobSetting, $jobRewardsReply);
    $todoTask->save();
    $jobRewardsReply->setResult(Down_Result::success);
    return $jobRewardsReply;
}

/**
 * 做任务得奖励
 * @param  [type] $userId           [description]
 * @param  [type] $jobId            [description]
 * @param  [type] $dailyJobSetting  [description]
 * @param  [type] &$jobRewardsReply [description]
 * @return [type]                   [description]
 */
function doTaskReward($userId, $jobId, $dailyJobSetting, &$jobRewardsReply){
    for ($index = 1; $index <= 2; $index++) {
        $rewardType = $dailyJobSetting["Task Reward {$index} Type"];
        $rewardAmount = $dailyJobSetting["Task Reward {$index} Amount"];
        if (empty($rewardAmount)) {
            $rewardAmount = 0;
        }
        $reason = "Daily Task Reward:{$jobId}";
        $rewardId = $dailyJobSetting["Task Reward {$index} ID"];
        if (isset($rewardType) && $rewardAmount > 0) {
            $dailyjobReward = new Down_DailyjobReward();
            $dailyjobReward->setAmount($rewardAmount);
            $dailyjobReward->setType($rewardType);
            $dailyjobReward->setId($rewardId);
            switch ($rewardType) {
                case "Coin":
                    PlayerModule::modifyMoney($userId, $rewardAmount, $reason);
                    break;
                case "Vitality":
                    VitalityModule::modifyVitality($userId, $rewardAmount, $reason);
                    break;
                case "Diamond":
                    PlayerModule::modifyGem($userId, $rewardAmount, $reason);
                    break;
                case "Item":
                    ItemModule::addItem($userId, array($rewardId => $rewardAmount), $reason);
                    break;
                case "PlayerEXP":
                    PlayerModule::modifyPlyExp($userId, $rewardAmount, $reason);
                    break;
                case "GuildCoin":
                    PlayerModule::modifyGuildPoint($userId,$rewardAmount,$reason);
                    break;
            }
            /* @var Down_JobRewardsReply $jobRewardsReply */
            $jobRewardsReply->appendActivityReward($dailyjobReward);
        }
    }
}

function checkFinish($userId, $dailyJobSetting, TBPlayerTask $todoTask){
    $taskType = $dailyJobSetting["Task Progress Type"];
    $taskTarget = $dailyJobSetting["Task Target"];
    if ($taskType === "Login") {
        return true;
    } elseif ($taskType === "MonthlyCardPeriod") {
        if (count(MonthCardModule::getAllMonthCardDownInfo($userId)) > 0) {
            return true;
        }
    } else {
        if ($todoTask->getTaskTarget() >= $taskTarget) {
            return true;
        }
    }
    return false;
}

function checkdbTrigger($userId, $dailyJobSetting){
    $triggerList = $dailyJobSetting["Trigger ID"];
    $todoTriggerList = DataModule::getInstance()->getDataSetting(TODO_TRIGGERS_LUA_KEY);
    foreach ($triggerList as $triggerId) {
        if ($triggerId != 0) {
            $triggerType = $todoTriggerList[$triggerId]["Trigger Type"];
            $triggerCondition = $todoTriggerList[$triggerId]["Trigger Condition"];
            switch ($triggerType) {
                case "VIPLevel":
                    if ($triggerCondition > VipModule::getVipLevel($userId)) {
                        return false;
                    }
                    break;
                case "VIPLevelLessThan":
                  if ($triggerCondition <= VipModule::getVipLevel($userId)){
                      return false;
                  }
                  break;
                case "DailyTimeAfter":
                    if ($triggerCondition > SQLUtil::getTodaySecond()) {
                        return false;
                    }
                    break;
                case "DailyTimeBefore":
                    if (SQLUtil::getTodaySecond() > $triggerCondition) {
                        return false;
                    }
                    break;
                case "PlayerLevel":
                    if ($triggerCondition > PlayerCacheModule::getPlayerLevel($userId)) {
                        return false;
                    }
                    break;
                case "VIPLevelEqual":
                    if (VipModule::getVipLevel($userId) != $triggerCondition) {
                        return false;
                    }
                    break;
            }
        }
    }
    return true;
}
