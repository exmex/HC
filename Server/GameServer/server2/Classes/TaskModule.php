<?php
/**
 * @Author:      jaylu
 * @Date:        2015-01-15 
 * @Description: Description
 * @email:       jay@xxxx.com
 */
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerTask.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/MathUtil.php");
//require_once($GLOBALS['GAME_ROOT'] . "Classes/DataModule.php");;

define("DAILY_TASK_FARM_PVE_STAGE", "FarmPVEStage");                         //完成任意副本
define("DAILY_TASK_FARM_ELITE_PVE_STAGE", "FarmElitePVEStage");             //完成任意精英副本
define("DAILY_TASK_FARM_CHAPTER_102", "FarmChapter102");                   //完成时光之穴
define("DAILY_TASK_FARM_CHAPTER_103", "FarmChapter103");                  //完成试炼场
define("DAILY_TASK_PVP_BATTLE", "PVPBattle");                            //在竞技场中完成挑战
define("DAILY_TASK_COMPLETE_CRUSADE_STAGE", "CompleteCrusadeStage");    //在燃烧的远征中战胜
define("DAILY_TASK_SKILL_UPGRADE_SUCCESS", "SkillUpgradeSuccess");     //升级任意技能*
define("DAILY_TASK_ENHANCE_LEVEL_UP", "EnhanceLevelUp");              //将任意装备附魔并升级
define("DAILY_TASK_MIDAS_USE", "MidasUse");                          //使用点金手
define("DAILY_TASK_TAVERN_GROUP_USE", "TavernGroupUse");            //召唤任意宝箱
define("DAILY_TASK_SEND_MERCENARY", "SendMercenary");              //在公会的佣兵营地派出英雄
define("DAILY_TASK_ENTER_RAID", "EnterRaid");                     //完成团队副本

class TaskModule{
    private static $TaskTableCached = array();

    public static function initTaskTable($userId,$allTaskTb)
    {
        $batch = new SQLBatch();
        $batch->init(SysPlayerTask::insertSqlHeader(array('user_id', 'task_line', 'task_id', 'task_status', 'task_target', 'claim_reward_time')));
        $isAdded = true;
        foreach ($allTaskTb as $task) {
            /**@var TbPlayerTask $task**/
            if($task->getTaskLine() == 40){
                $isAdded = false;
                break;
            }
        }
        if($isAdded){
            // init task
            $tbTask = new SysPlayerTask();
            $tbTask->setUserId($userId);
            $tbTask->setTaskLine(40);
            $tbTask->setTaskId(1);
            $tbTask->setTaskStatus(Down_Usertask_Status::working);
            $tbTask->setTaskTarget(0);
            $tbTask->setClaimRewardTime(0);

            $batch->add($tbTask);
            $allTaskTb[] = $tbTask;
        }


        // 日常任务初始化
        $DailyjobSettings = DataModule::getInstance()->getDataSetting(TODO_LIST_LUA_KEY);
        $isAdded = false;
        if (isset($DailyjobSettings)) {
            foreach ($DailyjobSettings as $dailyJob) {
                $isBreak = false;
                foreach ($allTaskTb as $task) {
                    /**@var TbPlayerTask $task**/
                    if($task->getTaskLine() == 0 && $task->getTaskId() == $dailyJob["Task ID"]){
                        $isBreak = true;
                        break;
                    }
                }
                //暂时屏蔽团队副本任务
                if($isBreak || $dailyJob["Task ID"] == 33 || $dailyJob["Task ID"] ==34){
                    continue;
                }
                $tbTask = new SysPlayerTask();
                $tbTask->setUserId($userId);
                $tbTask->setTaskLine(0);
                $tbTask->setTaskId($dailyJob["Task ID"]);
                $tbTask->setTaskStatus(Down_Usertask_Status::working);
                $tbTask->setTaskTarget(0);
                $tbTask->setClaimRewardTime(0);
                $batch->add($tbTask);
                $allTaskTb[] = $tbTask;
                $isAdded = true;
            }
        }
        if($isAdded){
            $batch->end();
            $batch->save();
        }
        return $allTaskTb;

    }
    /**
     * 初始化任务$lineId
     * @param  [type] $userId [description]
     * @param  [type] $lineId [description]
     * @param  [type] $taskId [description]
     * @return [type]         [description]
     */
    public static function initTaskLine($userId, $lineId, $taskId){
        $objtask = new SysPlayerTask();
        $objtask->setUserId($userId);
        $objtask->setTaskLine($lineId);
        $objtask->setTaskId($taskId);
        $objtask->setTaskStatus(Down_Usertask_Status::working);
        $objtask->setTaskTarget(0);
        $objtask->setClaimRewardTime(0);
        $objtask->inOrUp();
    }

    /**
     * 任务数据
     * @param  [type] $userId [description]
     * @return [type]         [description]
     */
    public static function getAllTaskData($userId){
        if (count(self::$TaskTableCached) > 0) {
            $allTaskTb = self::$TaskTableCached;
        }else{
            $searchKey = "`user_id` = '{$userId}'";
            $allTaskTb = SysPlayerTask::loadedTable(null, $searchKey);
        }
        self::$TaskTableCached = self::initTaskTable($userId,$allTaskTb);
        return self::$TaskTableCached;
    }

    public static function getTaskLineData($userId, $taskLine){
        if (count(self::$TaskTableCached) > 0) {
            foreach (self::$TaskTableCached as $tbTask) {
                if ($tbTask->getTaskLine() == $taskLine) {
                    return $tbTask;
                }
            }
        }
        $objtask = new SysPlayerTask();
        $objtask->setUserId($userId);
        $objtask->setTaskLine($taskLine);
        if ($objtask->LoadedExistFields()) {
            self::$TaskTableCached[] = $objtask;
            return $objtask;
        }
        return null;
    }

    public static function getDailyJobTable($userId, $taskId){
        if (count(self::$TaskTableCached) > 0) {
            foreach (self::$TaskTableCached as $tbTask) {
                if ($tbTask->getTaskLine() == 0 && $tbTask->getTaskId() == $taskId) {
                    return $tbTask;
                }
            }
        }
        $objtask = new SysPlayerTask();
        $objtask->setUserId($userId);
        $objtask->setTaskLine(0);
        $objtask->setTaskId($taskId);
        if ($objtask->LoadedExistFields()) {
            self::$TaskTableCached[] = $objtask;
            return $objtask;
        }
        return null;
    }
    /**
     * 返回所有任务数据
     * @param  [type] $userId [description]
     * @return [type]         [description]
     */
    public static function getAllTaskDownInfo($userId){
        $allTb = self::getAllTaskData($userId);
        $allTaskDown = array();
        foreach ($allTb as $tbTask) {
            if (($tbTask->getTaskLine() > 0) && ($tbTask->getTaskId() > 0)) {
                $downTask = new Down_Usertask();
                $downTask->setLine($tbTask->getTaskLine());
                $downTask->setId($tbTask->getTaskId());
                $downTask->setStatus($tbTask->getTaskStatus());
                $downTask->setTaskTarget($tbTask->getTaskTarget());
                $allTaskDown[] = $downTask;
            }
        }
        return $allTaskDown;
    }

    /**
     * 返回完成任务数据
     * @param  [type] $userId [description]
     * @return [type]         [description]
     */
    public static function getAllFinishTaskDownInfo($userId){
        $allData = self::getAllTaskData($userId);
        $allFinTaskDown = array();
        /** @var TbPlayerTask $tbTask */
        foreach ($allData as $onetask) {
            if (($onetask->getTaskLine() > 0) && ($onetask->getTaskId() <= 0)) {
                $allFinTaskDown[] = $onetask->getTaskLine();
            }
        }
        return $allFinTaskDown;
    }

    /**
     * 返回全部任务数据
     * @param  [type] $userId [description]
     * @return [type]         [description]
     */
    public static function getAllJobDownInfo($userId){
        $allData = self::getAllTaskData($userId);
        $allJobRes = array();
        foreach ($allData as $onetask) {
            if ($onetask->getTaskLine() <= 0) {
                $resJob = new Down_Dailyjob();
                $resJob->setId($onetask->getTaskId());
                $resJob->setLastRewardsTime($onetask->getClaimRewardTime());
                if ($onetask->getLastResetTime()!= 0 && SQLUtil::isTimeNeedReset($onetask->getLastResetTime())) {
                    $onetask->setTaskTarget(0);
                }
                $resJob->setTaskTarget($onetask->getTaskTarget());
                $allJobRes[] = $resJob;
            }
        }
        return $allJobRes;
    }

    public static function triggerFarmStageTask($userId, $stageId, $times = 1){
        $taskSetting = DataModule::getInstance()->getDataSetting(TASK_LUA_KEY);
        foreach ($taskSetting as $taskLines) {
            foreach ($taskLines as $task) {
                //查找任务类型
                if ($task["Task Progress Type"] === "FarmStage") {
                    //查找当前stageid 相关任务
                    foreach ($task["Task Progress ID"] as $tID) {
                        if (($tID != 0) && ($tID == $stageId)) {
                            //当前stage 有相关任务
                            $onetask = self::getTaskLineData($userId, $task["Task Line"]);
                            if (isset($onetask) && ($onetask->getTaskId() == $task["Task ID"])) {
                                if ($onetask->getTaskStatus() == Down_Usertask_Status::working) {
                                    $onetask->setTaskTarget($onetask->getTaskTarget() + $times);
                                    $onetask->save();
                                }
                                Logger::getLogger()->debug("Exit TriggerFarmStageTask");
                            }
                            return;
                        }
                    }
                }
            }
        }
    }
    /**
     * 更新每日任务数据
     * @param  [type]  $userId    [description]
     * @param  [type]  $eventType [description]
     * @param  integer $times     [description]
     * @param  integer $targetId  [description]
     * @return [type]             [description]
     */
    public static function updateDailyTaskProgress($userId, $eventType, $times = 1, $targetId = 0){
        //$targetId = 0;
        if ($eventType === "FarmChapter102") {
            $eventType = "FarmChapter";
            $targetId = 102;
        } elseif ($eventType === "FarmChapter103") {
            $eventType = "FarmChapter";
            $targetId = 103;
        }
        $taskSetting = DataModule::getInstance()->getDataSetting(TODO_LIST_LUA_KEY);
        foreach ($taskSetting as $task) {
            //查找任务类型
            if (($task["Task Progress Type"] === $eventType) && ($task["Task Progress ID"] == $targetId)) {
                /** @var TbPlayerTask $tbTask */
                $onetask = self::getDailyJobTable($userId, $task["Task ID"]);
                if (isset($onetask)) {
                    if (SQLUtil::isTimeNeedReset($onetask->getLastResetTime())) {
                        $onetask->setTaskTarget($times);
                        $onetask->setLastResetTime(time());
                        $onetask->save();
                    } else {
                        //当前任务没有完成才更新数据库
                        if ($onetask->getTaskTarget() <= $task["Task Target"]) {
                            $onetask->setTaskTarget($onetask->getTaskTarget() + $times);
                            $onetask->save();
                        }
                    }
                }
                return;
            }
        }
    }


}