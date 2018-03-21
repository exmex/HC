<?php
/**
 * @Author:      jaylu
 * @Date:        2015-01-15 
 * @Description: Description
 * @email:       jay@xxxx.com
 */
require_once($GLOBALS["GAME_ROOT"] . "Classes/DataModule.php");
require_once($GLOBALS["GAME_ROOT"] . "Classes/TaskModule.php");
require_once($GLOBALS["GAME_ROOT"] . "Classes/StageModule.php");

/**
 * 触发任务功能
 * @param [type] $userId [description]
 * @param [type] $task   [description]
 */
function triggerTaskApi($userId, $task){
    $taskId = MathUtil::bits($task, 0, 16);
    $chain = MathUtil::bits($task, 16, 16);
    $canTrigger = triggerTask($userId, $chain, $taskId);
    if ($canTrigger == false) {
        return Down_Result::fail;
    }
    $objtask = new SysPlayerTask();
    $objtask->setUserId($userId);
    $objtask->setTaskLine($chain);
    $result = $objtask->LoadedExistFields();
    if($result) {//任务完成
        if (($objtask->getTaskStatus() == Down_Usertask_Status::finished) && ($objtask->getTaskId() == ($taskId - 1))){
            //上一任务必须完成才能触发当前任务 并且可以触发
            $objtask->setTaskId($objtask->getTaskId() + 1);
            $objtask->setTaskStatus(Down_Usertask_Status::working);
            $objtask->setClaimRewardTime(0);
            $objtask->setTaskTarget(0);
            $objtask->setLastResetTime(0);
            $objtask->save();
            return Down_Result::success;
        }else if($objtask->getTaskId() == $taskId) {//已经完成的任务
            Logger::getLogger()->error("OnSkillLevelUp skill has triggered over!");
            return Down_Result::fail;
        }
    }else {//任务没有做
        TaskModule::initTaskLine($userId, $chain, $taskId);
        return Down_Result::success;
    }
    return Down_Result::fail;
}

function triggerTask($userId, $chain, $task){
    $triggerList = DataModule::getInstance()->getDataSetting(TRIGGERS_LUA_KEY);
    $task = DataModule::lookupDataTable(TASK_LUA_KEY, $task, array($chain));
    if (empty($task)) {
        return false;
    }
    $triggers = $task["Trigger ID"];
    foreach ($triggers as $id) {
        if(intval($id) > 0) {
            $row = $triggerList[$id];
            $type = $row["Trigger Type"];
            $condition = $row["Trigger Condition"];
            if($type == "CompleteStage") {
                if (StageModule::getStageStar($userId, $condition) <= 0) {
                    Logger::getLogger()->error("OnSkillLevelUp CompleteStage does not meet the conditions!");
                    return false;
                }
            }else if ($type == "PlayerLevel") {
                if (PlayerCacheModule::getPlayerLevel($userId) < $condition) {
                    Logger::getLogger()->error("OnSkillLevelUp Hero level does not meet the conditions!");
                    return false;
                }
            }
        }
    }
    return true;
}