<?php

require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerActStage.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerEliteStage.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerNormalStage.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerBattle.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/LootModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/MathUtil.php");


define("MAX_MINE_STAGE_ID", -18);
define("MAX_CRUSADE_STAGE_ID", -3);
define("MAX_NORMAL_STAGE_ID", 10000);
define("MAX_ELITE_STAGE_ID", 20000);
define("MAX_ACT_STAGE_ID", 30000);
define("MAX_MINE2_STAGE_ID", 39999);
define("MAX_RAID_STAGE_ID", 49999);

define("CRUSADE_STAGE", -3);
define("GUIDE_STAGE", -2);
define("ARENA_STAGE", -1);
define("NORMAL_STAGE", 1);
define("ELITE_STAGE", 2);
define("ACT_STAGE", 3);
define("MINE_STAGE", 4);
define("RAID_STAGE", 5);

class StageModule
{
    private static $NormalTableCached = array();
    private static $EliteTableCached = array();
    private static $ActTableCached = array();

    public static function getNormalStageTable($userId)
    {
        if (isset(self::$NormalTableCached[$userId])) {
            return self::$NormalTableCached[$userId];
        }

        $tbNormal = new SysPlayerNormalStage();
        $tbNormal->setUserId($userId);
        if ($tbNormal->loaded()) {

        } else {
            $tbNormal->setMaxStageId(0);
            $tbNormal->setStageStars("");
            $tbNormal->inOrUp();
        }

        self::$NormalTableCached[$userId] = $tbNormal;

        return $tbNormal;
    }

    public static function getEliteStageTable($userId)
    {
        if (isset(self::$EliteTableCached[$userId])) {
            return self::$EliteTableCached[$userId];
        }

        $tbElite = new SysPlayerEliteStage();

        $tbElite->setUserId($userId);
        if ($tbElite->loaded()) {
            if (SQLUtil::isTimeNeedReset($tbElite->getLastResetTime())) {
                $tbElite->setDailyRecord("");
                $tbElite->setLastResetTime(time());
                $tbElite->save();
            }
        } else {
            $tbElite->setMaxStageId(0);
            $tbElite->setStageStars("");
            $tbElite->setLastResetTime(time());
            $tbElite->setDailyRecord("");
            $tbElite->inOrUp();
        }
        self::$EliteTableCached[$userId] = $tbElite;

        return $tbElite;
    }

    public static function getActStageTable($userId)
    {
        if (isset(self::$ActTableCached[$userId])) {
            return self::$ActTableCached[$userId];
        }

        $tbAct = new SysPlayerActStage();
        $tbAct->setUserId($userId);
        if ($tbAct->loaded()) {
            if (SQLUtil::isTimeNeedReset($tbAct->getLastResetTime())) {
                $tbAct->setDailyRecord("");
                $tbAct->setLastResetTime(time());
                $tbAct->save();
            }
        } else {
            $tbAct->setLastResetTime(time());
            $tbAct->setDailyRecord("");
            $tbAct->inOrUp();
        }
        self::$ActTableCached[$userId] = $tbAct;

        return $tbAct;
    }

    public static function getBattleTable($userId)
    {
        $tbBattle = new SysPlayerBattle();
        $tbBattle->setUserId($userId);
        if ($tbBattle->loaded()) {

        } else {
            $tbBattle->setEnterStageTime(0);
            $tbBattle->setStageGroup(0);
            $tbBattle->setStageId(0);
            $tbBattle->setSrand(0);
            $tbBattle->setLoot("");
            $tbBattle->setPvpBuffer("");
            $tbBattle->inOrUp();
        }

        return $tbBattle;
    }

    public static function clearBattleStageInfo(SysPlayerBattle $tbBattle)
    {
        $tbBattle->setEnterStageTime(0);
        $tbBattle->setStageGroup(0);
        $tbBattle->setStageId(0);
        $tbBattle->setSrand(0);
        $tbBattle->setLoot("");
        $tbBattle->setPvpBuffer("");
        $tbBattle->save();

        return $tbBattle;
    }

    public static function getStageType($stageId)
    {
//        define("MAX_MINE_STAGE_ID", -18);
//        define("MAX_CRUSADE_STAGE_ID", -3);
//        define("MAX_NORMAL_STAGE_ID", 10000);
//        define("MAX_ELITE_STAGE_ID", 20000);
//        define("MAX_ACT_STAGE_ID", 30000);
//        define("CRUSADE_STAGE", -3);
//        define("GUIDE_STAGE", -2);
//        define("ARENA_STAGE", -1);
//        define("NORMAL_STAGE", 1);
//        define("ELITE_STAGE", 2);
//        define("ACT_STAGE", 3);
//        define("MINE_STAGE", 4);

        if ($stageId <= MAX_MINE_STAGE_ID) {
            $stageType = MINE_STAGE;
        } elseif ($stageId <= MAX_CRUSADE_STAGE_ID) {
            $stageType = CRUSADE_STAGE;
        } elseif ($stageId <= GUIDE_STAGE) {
            $stageType = GUIDE_STAGE;
        } elseif ($stageId <= ARENA_STAGE) {
            $stageType = ARENA_STAGE;
        } elseif ($stageId < MAX_NORMAL_STAGE_ID) {
            $stageType = NORMAL_STAGE;
        } elseif ($stageId < MAX_ELITE_STAGE_ID) {
            $stageType = ELITE_STAGE;
        } elseif ($stageId < MAX_ACT_STAGE_ID) {
            $stageType = ACT_STAGE;
        } elseif ($stageId < MAX_MINE2_STAGE_ID) {
            $stageType = MINE_STAGE;
        }elseif ($stageId < MAX_RAID_STAGE_ID) {
            $stageType = RAID_STAGE;
        } else {
            $stageType = MINE_STAGE;
        }

        return $stageType;
    }

    public static function getUserStageDownInfo($userId)
    {
        $userStage = new Down_Userstage();

        // set normal stage info
        $tbNormal = self::getNormalStageTable($userId);
        $normalStars = self::getStageStarsInfo($tbNormal->getStageStars());
        foreach ($normalStars as $star) {
            $userStage->appendNormalStageStars($star);
        }

        // set elite stage info
        $tbElite = self::getEliteStageTable($userId);
        $eliteStars = self::getStageStarsInfo($tbElite->getStageStars());
        foreach ($eliteStars as $star) {
            $userStage->appendEliteStageStars($star);
        }

        $eliteRecord = self::getEliteDailyRecordInfo($tbElite->getDailyRecord());
        foreach ($eliteRecord as $record) {
            $userStage->appendEliteDailyRecord($record);
        }

        $userStage->setEliteResetTime($tbElite->getLastResetTime());

        // set sweep info
        $userStage->setSweep(self::getSweepInfo($userId));

        // set act stage info
        $tbAct = self::getActStageTable($userId);
        $actRecord = self::getActDailyRecordInfo($tbAct->getDailyRecord());
        foreach ($actRecord as $record) {
            $userStage->appendActDailyRecord($record);
        }

        $userStage->setActResetTime($tbAct->getLastResetTime());

        return $userStage;
    }

    public static function getStageStarsInfo($starStr)
    {
        $retArr = array();
        if ($starStr == "") {
            return $retArr;
        }

        $strBlock = 16;
        $starArr = explode("|", $starStr);
        $starLen = count($starArr);
        $intCount = ceil($starLen / $strBlock);

        for ($i = 0; $i < $intCount; $i++) {
            $arg_arr = array();
            $start = intval($i * $strBlock);
            $end = min($starLen, ($start + 16));
            for ($j = $start; $j < $end; $j++) {
                array_unshift($arg_arr, $starArr[$j]);
                array_unshift($arg_arr, 2);
            }

            $starInt = intval(MathUtil::makeBits($arg_arr));
            $retArr[] = $starInt;
        }

        return $retArr;
    }

    public static function getEliteDailyRecordInfo($recordStr)
    {
        $retArr = array();

        $recordArr = explode("|", $recordStr);
        foreach ($recordArr as $record) {
            $oneRecordArr = explode("-", $record);
            if (count($oneRecordArr) == 3) {
                $arg_arr = array();
                $arg_arr[] = 10;
                $arg_arr[] = $oneRecordArr[0]; // id
                $arg_arr[] = 4;
                $arg_arr[] = $oneRecordArr[1]; // daily access times
                $arg_arr[] = 4;
                $arg_arr[] = $oneRecordArr[2]; // reset

                $recordInt = intval(MathUtil::makeBits($arg_arr));
                $retArr[] = $recordInt;
            }
        }

        return $retArr;
    }

    public static function getActDailyRecordInfo($recordStr)
    {
        $retArr = array();

        $recordArr = explode("|", $recordStr);
        foreach ($recordArr as $record) {
            $oneRecordArr = explode("-", $record);
            if (count($oneRecordArr) == 3) {
                $downActRecord = new Down_ActDailyRecord();
                $downActRecord->setId(intval($oneRecordArr[0]));
                $downActRecord->setFrequency(intval($oneRecordArr[1]));
                $downActRecord->setLastChange(intval($oneRecordArr[2]));

                $retArr[] = $downActRecord;
            }
        }

        return $retArr;
    }

    public static function getSweepInfo($userId)
    {
        $sweepInfo = new Down_Sweep();
        $sweepInfo->setLastResetTime(0);
        $sweepInfo->setTodayFreeSweepTimes(0);

        return $sweepInfo;
    }

    public static function updateNormalStageProgress($userId, $stageId, $star)
    {
        $tbNormal = self::getNormalStageTable($userId);
        $tbNormal->setMaxStageId(max($stageId, $tbNormal->getMaxStageId()));
        if ($tbNormal->getStageStars() == "") {
            $tbNormal->setStageStars($star);
        } else {
            $starArr = explode("|", $tbNormal->getStageStars());
            if (count($starArr) >= $stageId) {
                $starArr[$stageId - 1] = min(3, max($starArr[$stageId - 1], $star));
            } else {
                $starArr[] = min(3, $star);
            }
            $tbNormal->setStageStars(implode("|", $starArr));
        }

        $tbNormal->save();
    }

    public static function updateEliteStageProgress($userId, $stageId, $star, $times = 1)
    {
        $tbElite = self::getEliteStageTable($userId);
        $tbElite->setMaxStageId(max($stageId, $tbElite->getMaxStageId()));

        $stageId -= MAX_NORMAL_STAGE_ID;
        if ($tbElite->getStageStars() == "") {
            $tbElite->setStageStars(min(3, $star));
        } else {
            $starArr = explode("|", $tbElite->getStageStars());
            if (count($starArr) >= $stageId) {
                $starArr[$stageId - 1] = min(3, max($starArr[$stageId - 1], $star));
            } else {
                $starArr[] = min(3, $star);
            }
            $tbElite->setStageStars(implode("|", $starArr));
        }
        $newRecord = $tbElite->getDailyRecord();
        if ($newRecord == "") {
            $newRecord = "{$stageId}-{$times}-0";
        } else {
            $recordArr = explode("|", $newRecord);
            $isFound = false;
            foreach ($recordArr as $key => $record) {
                $oneRecordArr = explode("-", $record);
                if ((count($oneRecordArr) == 3) && (intval($oneRecordArr[0]) == intval($stageId))) {
                    $oneRecordArr[1] = intval($oneRecordArr[1]) + $times;
                    $recordArr[$key] = implode("-", $oneRecordArr);
                    $isFound = true;
                    break;
                }
            }

            if ($isFound) {
                $newRecord = implode("|", $recordArr);
            } else {
                $newRecord .= "|{$stageId}-{$times}-0";
            }
        }
        $tbElite->setDailyRecord($newRecord);
        $tbElite->save();
    }

    public static function getEliteStageDailyRecord($userId, $stageId)
    {
        $retInfo = array(0, 0);
        $tbStage = self::getEliteStageTable($userId); // elite
        $stageSeq = $stageId - MAX_NORMAL_STAGE_ID;
        $recordArr = explode("|", $tbStage->getDailyRecord());
        foreach ($recordArr as $oneRecord) {
            $oneRecordArr = explode("-", $oneRecord);
            if ((count($oneRecordArr) == 3) && (intval($oneRecordArr[0]) == intval($stageSeq))) {
                $retInfo[0] = intval($oneRecordArr[1]);
                $retInfo[1] = intval($oneRecordArr[2]);
                break;
            }
        }

        return $retInfo;
    }

    public static function resetEliteDailyTimes($userId, $stageId)
    {
        $tbElite = self::getEliteStageTable($userId); // elite
        $stageSeq = $stageId - MAX_NORMAL_STAGE_ID;
        $recordArr = explode("|", $tbElite->getDailyRecord());
        foreach ($recordArr as $key => $record) {
            $oneRecordArr = explode("-", $record);
            if ((count($oneRecordArr) == 3) && (intval($oneRecordArr[0]) == intval($stageSeq))) {
                $oneRecordArr[1] = 0;
                $oneRecordArr[2] = intval($oneRecordArr[2]) + 1;
                $recordArr[$key] = implode("-", $oneRecordArr);
                break;
            }
        }

        $newRecord = implode("|", $recordArr);
        $tbElite->setDailyRecord($newRecord);
        $tbElite->save();
    }

    public static function getActStageDailyRecord($userId, $stageGroupId)
    {
        $retInfo = array(0, 0);
        $tbStage = self::getActStageTable($userId); // elite
        $recordArr = explode("|", $tbStage->getDailyRecord());
        foreach ($recordArr as $oneRecord) {
            $oneRecordArr = explode("-", $oneRecord);
            if ((count($oneRecordArr) == 3) && (intval($oneRecordArr[0]) == intval($stageGroupId))) {
                $retInfo[0] = intval($oneRecordArr[1]);
                $retInfo[1] = intval($oneRecordArr[2]);
                break;
            }
        }

        return $retInfo;
    }

    public static function updateActStageProgress($userId, $stageGroup, $times = 1)
    {
        $tbActStage = self::getActStageTable($userId);

        $nowTime = time();
        $newRecord = $tbActStage->getDailyRecord();
        if ($newRecord == "") {
            $newRecord = "{$stageGroup}-{$times}-{$nowTime}";
        } else {
            $recordArr = explode("|", $newRecord);
            $isFound = false;
            foreach ($recordArr as $key => $record) {
                $oneRecordArr = explode("-", $record);
                if ((count($oneRecordArr) == 3) && (intval($oneRecordArr[0]) == intval($stageGroup))) {
                    $oneRecordArr[1] = intval($oneRecordArr[1]) + $times;
                    $oneRecordArr[2] = $nowTime;
                    $recordArr[$key] = implode("-", $oneRecordArr);
                    $isFound = true;
                    break;
                }
            }

            if ($isFound) {
                $newRecord = implode("|", $recordArr);
            } else {
                $newRecord .= "|{$stageGroup}-{$times}-{$nowTime}";
            }
        }
        $tbActStage->setDailyRecord($newRecord);
        $tbActStage->save();
    }

    public static function getStageStar($userId, $stageId)
    {
        if ($stageId < MAX_NORMAL_STAGE_ID) { // normal
            $tbStage = StageModule::getNormalStageTable($userId);
            $stageSeq = $stageId - 1;
        } else {
            $tbStage = StageModule::getEliteStageTable($userId); // elite
            $stageSeq = $stageId - MAX_NORMAL_STAGE_ID - 1;
        }
        $starArr = explode("|", $tbStage->getStageStars());
        if (isset($starArr[$stageSeq])) {
            return intval($starArr[$stageSeq]);
        }

        return 0;
    }

}