<?php

require_once($GLOBALS['GAME_ROOT'] . "Classes/StageModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/DailyActivityModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/DataModule.php");;

define('LOOT_MEM_EXPIRE_TIME', 86400);

class LootModule
{
    private static $LootCached = array();
    private static $StillLootArr = array(
        101, 102, 103, 104, 105, 106, 107, 108, 109,
        110, 111, 113, 114, 115, 116, 117, 118, 119,
        120, 121, 122, 123, 170, 171, 172, 173);
    private static $GlobalItemLootDefine = array(
        390 => 33
    );

    /**
     * @param $userId
     * @param $stageId
     * @param bool $update
     * @param bool $isFirstDown
     * @param int $targetWave 初始化第几波
     * @return array
     */
    public static function getLootInfo($userId, $stageId, $update = false, $isFirstDown = false, $targetWave = 3)
    {
        $lootArr = array();
        $stageType = StageModule::getStageType($stageId);
        $stageLootArr = array();
        $battleTable = DataModule::lookupDataTable(BATTLE_LUA_KEY, null, array($stageId));

        // get boss position
        if (empty($battleTable[$targetWave]["Boss Position"])) {
            return $lootArr;
        }
        $bossPos = $battleTable[$targetWave]["Boss Position"];

        // get boss loot
        $stageTable = DataModule::getInstance()->getDataSetting(STAGE_LUA_KEY);
        if (empty($stageTable)) {
            return $lootArr;
        }
        $oneStage = $stageTable[$stageId];

        $lootRecord = self::getUserLootRecord($userId, $stageId);
        if (empty($lootRecord)) {
            $lootRecord = array();
        }

        //每日活动影响几率
        $actInfo = DailyActivityModule::lootActivity();
        $multiple = $actInfo[0];
        $excludeArr = $actInfo[1];
        $includeArr = $actInfo[2];

        $needInit = false;
        $lootItemArr = array();
        for ($i = 1; $i <= 7; $i++) {
            $lootId = intval($oneStage["UI reward{$i}"]);
            if ($lootId <= 0) {
                continue;
            }

            $itemRule = DataModule::lookupDataTable(ITEM_LUA_KEY, null, array($lootId));
            $fragId = intval($itemRule["Frag ID"]);
            $realLootItem = $lootId;
            $stageLootArr[$lootId] = 1;
            if ($fragId > 0 && $stageType != RAID_STAGE) {
                $realLootItem = $fragId;
                $stageLootArr[$fragId] = 1;
            }

            $lootPro = 100;
            if ($stageType != ACT_STAGE) {
                $tableLootPro = 34;
                
                /**暂时取消,hgs@20141025
                if (isset($oneStage["UI reward{$i} Pro"])) {
                    $tableLootPro = intval($oneStage["UI reward{$i} Pro"]);
                }
                */

                if (in_array($lootId, self::$StillLootArr)) {
                    // item that in still array, always real pro
                    $lootPro = $tableLootPro;
                } else {
                    if (isset($lootRecord[$lootId])) {
                        // not first down, unreal pro
                        $lootTimes = $lootRecord[$lootId];
                        $lootPro = $tableLootPro * $lootTimes;
                    } else {
                        // first down, min 80%
                        $lootPro = max(80, $tableLootPro);
                        $lootRecord[$lootId] = 1;
                        $needInit = true;
                    }
                }

                if ($stageType == RAID_STAGE) {
                    $lootPro = $tableLootPro;
                    $needInit = false;
                }
            }

            $itemCategory = $itemRule["Category"];
            if (count($includeArr) > 0) {
                if (empty($includeArr[$itemCategory]) || !in_array($lootId, $includeArr[$itemCategory])) {
                    $multiple = 0;
                }
            } elseif (isset($excludeArr[$itemCategory])) {
                $multiple = 0;
            }

            if ($multiple > 1) {
                $lootPro *= $multiple;
            }

            $randValue = mt_rand(1, 100);
            if ($lootPro < $randValue) {
                continue;
            }

            $lootNum = 1;
            if ($stageType == ACT_STAGE) {
                $minNum = 2;
                if (isset($oneStage["UI reward{$i} Min Amount"])) {
                    $minNum = intval($oneStage["UI reward{$i} Min Amount"]);
                }
                $maxNum = 4;
                if (isset($oneStage["UI reward{$i} Max Amount"])) {
                    $maxNum = intval($oneStage["UI reward{$i} Max Amount"]);
                }

                $lootNum = mt_rand($minNum, $maxNum);
                if ($multiple > 1) {
                    $lootNum *= intval($multiple);
                }

                $otherLootNum = floor($lootNum / 2);
                $lootNum -= $otherLootNum;
                $waveLootArr = array();
                $waveLootArr[1] = floor($otherLootNum / 2);
                $waveLootArr[2] = $otherLootNum - $waveLootArr[1];
                for ($waveIndex = 1; $waveIndex <= 2; $waveIndex++) {
                    $thisWaveLootNum = $waveLootArr[$waveIndex];
                    if ($thisWaveLootNum > 0) {
                        $waveInfo = $battleTable[$waveIndex];
                        $allMonster = array();
                        for ($monsterIndex = 1; $monsterIndex <= 5; $monsterIndex++) {
                            $monsterId = intval($waveInfo["Monster {$monsterIndex} ID"]);
                            if ($monsterId > 0) {
                                $allMonster[$monsterIndex] = $monsterId;
                            }
                        }
                        for ($lootIndex = 0; $lootIndex < $thisWaveLootNum; $lootIndex++) {
                            $monPos = array_rand($allMonster, 1);
                            $lootArr[] = array($waveIndex, $monPos, $realLootItem, $lootId);
                        }
                    }
                }
            }


            for ($lootIndex = 0; $lootIndex < $lootNum; $lootIndex++) {
                $lootArr[] = array($targetWave, $bossPos, $realLootItem, $lootId); //$targetWave, $bossPos, $realLootItem, $lootId   3 0 0  101  $lootNum=1
                
            }

            if (empty($lootItemArr[$lootId])) {
                $lootItemArr[$lootId] = 0;
            }
            $lootItemArr[$lootId]++;
        }
        
        if ($needInit) {
            self::setUserLootRecord($userId, $stageId, $lootRecord);
        }
        if ($update) {
            self::updateUserLootRecord($userId, $stageId, $lootItemArr);
        }

        // get first down loot
        if ($isFirstDown) {
            for ($waveIndex = 1; $waveIndex <= 3; $waveIndex++) {
                $waveInfo = $battleTable[$waveIndex];
                for ($monsIndex = 1; $monsIndex <= 5; $monsIndex++) {
                    $fd_item = intval($waveInfo["FD Bonus {$monsIndex}"]);
                    if ($fd_item > 0) {
                        $stageLootArr[$fd_item] = 1;
                        if (empty($lootItemArr[$fd_item])) {
                            $lootArr[] = array($waveIndex, $monsIndex, $fd_item, 0);
                        }
                    }
                }
            }
        }

        if ($stageType != ACT_STAGE) {
            // get world loot
            $beginIndex = 1;
            $endIndex = 3;
            if ($stageType == RAID_STAGE) {
                $beginIndex = $endIndex = $targetWave;
            }

            for ($waveIndex = $beginIndex; $waveIndex <= $endIndex; $waveIndex++) {
                $waveInfo = $battleTable[$waveIndex];
                for ($monsIndex = 1; $monsIndex <= 5; $monsIndex++) {
                    $monsterLevel = intval($waveInfo["Level {$monsIndex}"]);
                    if ($monsterLevel <= 0) {
                        continue;
                    }

                    $worldLoot = self::getMonsterWorldLootInfo($monsterLevel);
                    if (isset($worldLoot) && empty($stageLootArr[$worldLoot])) { //5%的概率出现 已经存在于数组中则不会在去添加
                        $lootArr[] = array($waveIndex, $monsIndex, $worldLoot, 0);
                    }
                }
            }

            // get global item loot
            $globalLootItemArr = array();
            $globalLootInfo = self::getGlobalLootItemInfo($userId); //1/3出扫荡
            foreach ($globalLootInfo as $globalId) {
                $lootArr[] = array($targetWave, $bossPos, $globalId, 0);

                if (empty($globalLootItemArr[$globalId])) {
                    $globalLootItemArr[$globalId] = 0;
                }

                $globalLootItemArr[$globalId]++;
            }
            if ($update) {
                self::updateUserGlobalLoot($userId, $globalLootItemArr);
            }
        }

        return $lootArr;
    }

    public static function getMonsterWorldLootInfo($level)
    {
        $lootPro = 5;
        $randPro = mt_rand(1, 100);
        if ($lootPro < $randPro) {
            return null;
        }

        $lootTable = DataModule::lookupDataTable(WORLD_LOOT_LUA_KEY, null, array($level));
        if (empty($lootTable) || count($lootTable) <= 0) {
            return null;
        }

        $allRandValue = array_sum($lootTable);
        $randPro = mt_rand(1, $allRandValue);
        $lootItemId = null;
        foreach ($lootTable as $itemId => $randValue) {
            if ($randPro <= $randValue) {
                $lootItemId = $itemId;
                break;
            }
            $randPro -= $randValue;
        }
        return $lootItemId;
    }

    public static function getGlobalLootItemInfo($userId)
    {
        $retLoot = array();
        $globalNeedInit = false;
        $globalLootRecord = self::getUserGlobalLoot($userId);
        if (empty($globalLootRecord)) {
            $globalLootRecord = array();
        }
        foreach (self::$GlobalItemLootDefine as $globalId => $globalPro) {
            $lootPro = $globalPro;
            if (isset($globalLootRecord[$globalId])) {
                $lootTimes = $globalLootRecord[$globalId];
                $lootPro = $globalPro;
                $lootPro *= $lootTimes;
            } else {
                $globalLootRecord[$globalId] = 1;
                $globalNeedInit = true;
            }
            $randValue = mt_rand(1, 100);
            if ($lootPro < $randValue) {
                continue;
            }
            $retLoot[] = $globalId;
        }
        if ($globalNeedInit) {
            self::setUserGlobalLoot($userId, $globalLootRecord);
        }
        return $retLoot;
    }

    public static function getLootKey($userId, $stage)
    {
        return "LOOT_RECORD_{$userId}_{$stage}";
    }

    public static function setUserLootRecord($userId, $stageId, $newRecord)
    {
        $memKey = self::getLootKey($userId, $stageId);

        CMemcache::getInstance()->setData($memKey, $newRecord, LOOT_MEM_EXPIRE_TIME);
        self::$LootCached [$memKey] = $newRecord;
    }

    public static function getUserLootRecord($userId, $stageId)
    {
        $memKey = self::getLootKey($userId, $stageId);

        if (isset(self::$LootCached [$memKey])) {
            return self::$LootCached [$memKey];
        }

        $memRecord = CMemcache::getInstance()->getData($memKey);
        if ($memRecord) {
            self::$LootCached [$memKey] = $memRecord;
        }

        return $memRecord;
    }

    public static function updateUserLootRecord($userId, $stageId, $itemIds)
    {
        $memRecord = self::getUserLootRecord($userId, $stageId);
        $newRecord = array();
        if ($memRecord) {
            foreach ($memRecord as $key => $value) {
                $memRecord[$key] = $value + 1;
            }
            $newRecord = $memRecord;
        }

        foreach ($itemIds as $itemId => $itemCount) {
            $newRecord[$itemId] = 0;
        }
        self::setUserLootRecord($userId, $stageId, $newRecord);
    }

    public static function getGlobalLootKey($userId)
    {
        return "GLOBAL_LOOT_RECORD_{$userId}";
    }

    public static function setUserGlobalLoot($userId, $newRecord)
    {
        $memKey = self::getGlobalLootKey($userId);

        CMemcache::getInstance()->setData($memKey, $newRecord, LOOT_MEM_EXPIRE_TIME);
        self::$LootCached [$memKey] = $newRecord;
    }

    public static function getUserGlobalLoot($userId)
    {
        $memKey = self::getGlobalLootKey($userId);

        if (isset(self::$LootCached [$memKey])) {
            return self::$LootCached [$memKey];
        }

        $memRecord = CMemcache::getInstance()->getData($memKey);
        if ($memRecord) {
            self::$LootCached [$memKey] = $memRecord;
        }

        return $memRecord;
    }

    public static function updateUserGlobalLoot($userId, $itemIds)
    {
        $memRecord = self::getUserGlobalLoot($userId);
        $newRecord = array();
        if ($memRecord) {
            foreach ($memRecord as $key => $value) {
                $memRecord[$key] = $value + 1;
            }
            $newRecord = $memRecord;
        }

        foreach ($itemIds as $itemId => $itemCount) {
            if (in_array($itemId, array_keys(self::$GlobalItemLootDefine))) {
                $newRecord[$itemId] = 0;
            }
        }
        self::setUserGlobalLoot($userId, $newRecord);
    }
}
