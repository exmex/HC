<?php
/**
 * @Author:      jaylu
 * @Date:        2015-01-15 
 * @Description: Description
 * @email:       jay@xxxx.com
 */
require_once($GLOBALS["GAME_ROOT"] . "Classes/DataModule.php");
require_once($GLOBALS["GAME_ROOT"] . "Classes/StageModule.php");
require_once($GLOBALS["GAME_ROOT"] . "Classes/PlayerModule.php");
require_once($GLOBALS["GAME_ROOT"] . "Classes/HeroModule.php");

function requireTaskRewardsApi($userId, $taskLine, $taskId){
    Logger::getLogger()->debug("OnRequireTaskRewards stage progress:" . $taskLine . " " . $taskId);
    $ret = new Down_RequireRewardsReply();
    $objtask = TaskModule::getTaskLineData($userId, $taskLine);
    if (empty($objtask)) {
        Logger::getLogger()->error("OnRequireTaskRewards no have this quest!");
        $ret->setResult(Down_Result::fail);
        return $ret;
    }
    if ($objtask->getTaskId() != $taskId) {
        Logger::getLogger()->error("OnRequireTaskRewards task id not match!");
        $ret->setResult(Down_Result::fail);
        return $ret;
    }
    if ($objtask->getTaskStatus() == Down_Usertask_Status::finished) {
        Logger::getLogger()->error("OnRequireTaskRewards task is finished!");
        $ret->setResult(Down_Result::success);
        return $ret;
    } 
    //奖励
    if (isTaskCompleted($userId, $objtask)) {
        if (!rewardTask($userId, $objtask->getTaskLine(), $objtask->getTaskId())) {
            $ret->setResult(Down_Result::fail);
            return $ret;
        }
        $objtask->setClaimRewardTime(time());
        $objtask->setTaskStatus(Down_Usertask_Status::finished);
        $objtask->save();
        $ret->setResult(Down_Result::success);
        return $ret;
    }else {
        Logger::getLogger()->error("User Id :{$userId}  OnRequireTaskRewards: ConsumeModule::doConsume() failed");
        $ret->setResult(Down_Result::fail);
        return $ret;
    }
}

/**
 * 任务奖励
 * @param  [type] $userId   [description]
 * @param  [type] $taskLine [description]
 * @param  [type] $taskId   [description]
 * @return [type]           [description]
 */
function rewardTask($userId, $taskLine, $taskId){
    $taskSetting = DataModule::getInstance()->lookupDataTable(TASK_LUA_KEY, $taskId, array($taskLine));
    if (empty($taskSetting)) {
        Logger::getLogger()->error("TASK_LUA_KEY{$taskLine}:{$taskId} Empty!");
        return false;
    }
    $rewardAmount = $taskSetting["Task Reward Amount"];
    $rewardId = $taskSetting["Task Reward ID"];
    $reason = "OnRequireTaskRewards Task Line: '{$taskLine}' Task ID '{$taskId}'";
    switch ($taskSetting["Task Reward Type"]) {
        case "Coin":
            PlayerModule::modifyMoney($userId, $rewardAmount, $reason);
            break;
        case "Diamond":
            PlayerModule::modifyGem($userId, $rewardAmount, $reason);
            break;
        case "Vitality":
            VitalityModule::modifyVitality($userId, $rewardAmount, $reason);
            break;
        case "Item":
            ItemModule::addItem($userId, array($rewardId => $rewardAmount), $reason);
            break;
        default:
            break;
    }
    return true;
}

/**
 * 任务完成否
 * @param  [type]     $userId  [description]
 * @param  TaskModule $objtask [description]
 * @return boolean             [description]
 */
function isTaskCompleted($userId, TaskModule $objtask){
    $task = array(
        "chain" => $objtask->getTaskLine(),
        "id" => $objtask->getTaskId(),
        "count" => $objtask->getTaskTarget(),
        "status" => $objtask->getTaskStatus()
    );
    $progress = getProgress($userId, $task);
    $taskTarget = DataModule::getInstance()->lookupDataTable(TASK_LUA_KEY, "Task Target", array($objtask->getTaskLine(), $objtask->getTaskId()));
    return $progress >= $taskTarget;
}

function getProgress($userId, $data){
    $chain = $data["chain"];
    $id = $data["id"];
    $count = isset($data["count"]) ? $data["count"] : 0;
    $row = DataModule::getInstance()->lookupDataTable(TASK_LUA_KEY, $id, array($chain));
    $type = $row["Task Progress Type"];
    $pid = $row["Task Progress ID"];
    $target = $row["Task Target"];
    $info = array(
        "pid" => $pid,
        "type" => $type,
        "count" => $count,
        "target" => $target
    );
    return getCount($userId, $info);
}

function getCount($userId, $info){
    if(!is_array($info)){
        return false;
    }
    $pid = $info["pid"];
    $type = $info["type"];
    $target = $info["target"];
    $count = isset($info["count"]) ? $info["count"] : 0;
    $limit = isset($info["limit"]) ? $info["limit"] : "login";
    if ($type == "CompleteStage") {
        foreach ($pid as $stageId) {
            if ($stageId != 0 and 0 < StageModule::getStageStar($userId, $stageId)) {
                return $target;
            }
        }
    }else if ($type == "ItemQuantity") {
        foreach ($pid as $valueId) {
            if ($valueId != 0) {
                $playerItem = ItemModule::getPlayerItem($userId, $valueId);
                if (isset($playerItem)) {
                    return $playerItem->getCount();
                }
                return 0;
            }
        }
    }else if ($type == "PlayerLevel") {
        return PlayerCacheModule::getPlayerLevel($userId); 
    }else if ($type == "HeroLevel") {
        foreach ($pid as $valueId) {
            if ($valueId != 0) {
                $heroData = HeroModule::getAllHeroTable($userId, array($valueId));
                if (isset($heroData) and isset($heroData[$valueId])) {
                    $hero = $heroData[$valueId];
                    return $hero->getLevel();
                } else {
                    return 0;
                }
            }
        }
    }else if ($type == "HeroRank") {
        foreach ($pid as $valueId) {
            if ($valueId != 0) {
                $heroData = HeroModule::getAllHeroTable($userId, array($valueId));
                if (isset($heroData) and isset($heroData[$valueId])) {
                    $hero = $heroData[$valueId];
                    return $hero->getRank();
                } else {
                    return 0;
                }
            }
        }
    }else if ($type == "MultiHeroRank") {
        foreach ($pid as $valueId) {
            if ($valueId != 0) {
                $index = 0;
                $allHeroTable = HeroModule::getAllHeroTable($userId);
                foreach ($allHeroTable as $tbHero) {
                    if ($valueId <= $tbHero->getRank()) {
                        $index++;
                    }
                }
                return $index;
            }
        }
    }else if ($type == "MultiHeroLevel") {
        foreach ($pid as $valueId) {
            if ($valueId != 0) {
                $index = 0;
                $allHeroTable = HeroModule::getAllHeroTable($userId);
                foreach ($allHeroTable as $tbHero) {
                    if ($valueId <= $tbHero->getLevel()) {
                        $index++;
                    }
                }
                return $index;
            }
        }
    }else if ($type == "KillMonster") {
//    return ed . player:getTaskCount(chain, id)
    }else if ($type == "FarmStage") {
        //return ed . player:getTaskCount(chain, id)
    }
    return $count;
}
