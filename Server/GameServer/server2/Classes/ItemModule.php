<?php

require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerItems.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/MathUtil.php");

define("MAX_ITEM_NUM", 999);

class ItemModule
{
    public static function getAllItemsDownInfo($userId)
    {
        $searchKey = "`user_id` = '{$userId}' and `count` > 0";
        $allItemTb = SysPlayerItems::loadedTable(null, $searchKey);
        $allItemTb = self::checkItemList($userId, $allItemTb);
        $allItem = array();
        /** @var SysPlayerItems $tbItem */
        foreach ($allItemTb as $tbItem) {
            $arg_arr = array(11, $tbItem->getCount(), 10, $tbItem->getItemId());
            $item = intval(MathUtil::makeBits($arg_arr));
            $allItem[] = $item;
        }

        return $allItem;
    }

    public static function checkItemList($userId, $allItemTb)
    {
        $newItemsList = array();
        /** @var SysPlayerItems $tbItem */
        foreach ($allItemTb as $sysItem) {
            if (isset($newItemsList[$sysItem->getItemId()])) {
                /** @var SysPlayerItems $setItem */
                $setItem = $newItemsList[$sysItem->getItemId()];
                if ($setItem && ($setItem->getItemId() == $sysItem->getItemId())) {
                    $newCount = min(MAX_ITEM_NUM, ($setItem->getCount() + $sysItem->getCount()));
                    $setItem->setCount($newCount);
                    $setItem->save();
                }
                $sysItem->delete();
            } else {
                $newItemsList[$sysItem->getItemId()] = $sysItem;
            }
        }

        return $newItemsList;
    }

    public static function getPlayerItem($userId, $itemId)
    {
        $tbItem = new SysPlayerItems();

        $tbItem->setUserId($userId);
        $tbItem->setItemId($itemId);
        $tbItem->LoadedExistFields();
        return $tbItem;
    }

    public static function addItem($userId, $itemArr, $reason = "")
    {
        if (count($itemArr) <= 0) {
            return;
        }

        foreach ($itemArr as $itemId => $count) {
            if ($count <= 0) {
                unset($itemArr[$itemId]);
            }
        }

        $searchItemKey = "`user_id` = '{$userId}'";
        $itemIdArr = array_keys($itemArr);
        if (count($itemIdArr) == 1) {
            $itemId = $itemIdArr[0];
            $searchItemKey .= " and `item_id` = '{$itemId}'";
        } else {
            $itemIdStr = implode(",", $itemIdArr);
            $searchItemKey .= " and `item_id` in ({$itemIdStr})";
        }

        $itemTables = SysPlayerItems::loadedTable(null, $searchItemKey);
        /** @var SysPlayerItems $sysItem */
        foreach ($itemTables as $sysItem) {
            $after = $sysItem->getCount() + intval($itemArr[$sysItem->getItemId()]);
            $after = min(MAX_ITEM_NUM, $after);
            LogClient::getInstance()->logAddItem($userId, $reason, $sysItem->getItemId(), $sysItem->getCount(), $after);

            $sysItem->setCount($after);
            $sysItem->save();
            unset($itemArr[$sysItem->getItemId()]);
        }

        $batch = new SQLBatch();
        $batch->init(SysPlayerItems::insertSqlHeader(array('user_id', 'item_id', 'count')));

        foreach ($itemArr as $itemId => $count) {
            $count = min(MAX_ITEM_NUM, $count);
            LogClient::getInstance()->logAddItem($userId, $reason, $itemId, 0, $count);

            $sysItem = new SysPlayerItems();

            $sysItem->setUserId($userId);
            $sysItem->setItemId($itemId);
            $sysItem->setCount($count);

            $batch->add($sysItem);
        }

        $batch->end();
        $batch->save();
    }

    public static function subItem($userId, $itemArr, $reason = "")
    {
        if (count($itemArr) <= 0) {
            return false;
        }

        foreach ($itemArr as $itemId => $count) {
            if ($count <= 0) {
                unset($itemArr[$itemId]);
            }
        }

        $searchItemKey = "`user_id` = '{$userId}'";
        $itemIdArr = array_keys($itemArr);
        if (count($itemIdArr) == 1) {
            $itemId = $itemIdArr[0];
            $searchItemKey .= " and `item_id` = '{$itemId}'";
        } else {
            $itemIdStr = implode(",", $itemIdArr);
            $searchItemKey .= " and `item_id` in ({$itemIdStr})";
        }

        $itemTb = SysPlayerItems::loadedTable(null, $searchItemKey);
        if (count($itemIdArr) != count($itemTb)) {
            Logger::getLogger()->error("subItem param item not all found!");
            return false;
        }

        /** @var SysPlayerItems $sysItem */
        foreach ($itemTb as $sysItem) {
            $subCount = intval($itemArr[$sysItem->getItemId()]);
            if ($sysItem->getCount() < $subCount) {
                Logger::getLogger()->error("subItem item num not enough!item:{$sysItem->getItemId()}, have:{$sysItem->getCount()}, need:{$subCount}");
                return false;
            }
            $after = $sysItem->getCount() - $subCount;
            LogClient::getInstance()->logDelItem($userId, $reason, $sysItem->getItemId(), $sysItem->getCount(), $after);

            $sysItem->setCount($after);
        }

        foreach ($itemTb as $sysItem) {
            $sysItem->save();
        }

        return true;
    }

    public static function getItemType($itemId)
    {
        $itemType = "";
        if ($itemId < 100) {
            $itemType = "hero";
        } elseif ($itemId < 600) {
            $itemType = "equip";
        }
        return $itemType;
    }

    public static function getEquipMaxExp($itemId)
    {
        $quality = DataModule::lookupDataTable(ITEM_LUA_KEY, "Quality", array($itemId));
        $maxLevel = DataModule::lookupDataTable(ENHANCE_LUA_KEY, "Max Level", array($quality));
        if ($maxLevel == 0) {
            return 0;
        }

        $maxExp = 0;
        for ($i = 1; $i <= $maxLevel; $i++) {
            $expLvKey = "Price {$i}";
            $maxExp += floor(DataModule::lookupDataTable(ENHANCE_LUA_KEY, $expLvKey, array($quality)));
        }

        return $maxExp;
    }

    public static function getEquipCurLv($itemId, $curExp, $quality = 0)
    {
        if ($quality == 0) {
            $quality = DataModule::lookupDataTable(ITEM_LUA_KEY, "Quality", array($itemId));
        }

        $enhanceSettings = DataModule::getInstance()->getDataSetting(ENHANCE_LUA_KEY);
        $enhanceTable = $enhanceSettings[$quality];
        $maxLevel = $enhanceTable["Max Level"];
        if ($maxLevel == 0) {
            return 0;
        }

        $curLv = 0;
        $remainExp = $curExp;
        for ($i = 1; $i <= $maxLevel; $i++) {
            $expLvKey = "Price {$i}";
            $levelExp = floor($enhanceTable[$expLvKey]);
            if ($remainExp < $levelExp) {
                return $curLv;
            }
            $remainExp -= $levelExp;
            $curLv = $i;
        }

        return $curLv;
    }

    public static function getEquipReturnExp($itemId, $curExp)
    {
        $quality = DataModule::lookupDataTable(ITEM_LUA_KEY, "Quality", array($itemId));
        $maxLevel = DataModule::lookupDataTable(ENHANCE_LUA_KEY, "Max Level", array($quality));
        if (($maxLevel == 0) || ($curExp == 0)) {
            return 0;
        }

        $retExp = 0;
        $remainExp = $curExp;
        for ($i = 1; $i <= $maxLevel; $i++) {
            $expLvKey = "Price {$i}";
            $levelExp = floor(DataModule::lookupDataTable(ENHANCE_LUA_KEY, $expLvKey, array($quality)));
            if ($remainExp < $levelExp) {
                return $retExp;
            }
            $remainExp -= $levelExp;

            $retExpKey = "Return {$i}";
            $equipRetExp = floor(DataModule::lookupDataTable(ENHANCE_LUA_KEY, $retExpKey, array($quality)));
            $retExp += $equipRetExp;
        }

        return $retExp;
    }

    public static function getReturnExpItemArr($retExp)
    {
        $retItemArr = array();
        if ($retExp <= 0) {
            return $retItemArr;
        }

        $allEnhanceItem = array();
        $itemTable = DataModule::getInstance()->getDataSetting(ITEM_LUA_KEY);
        foreach ($itemTable as $itemInfo) {
            if (intval($itemInfo["Enhance Exp"]) > 0) {
                $allEnhanceItem[intval($itemInfo["Enhance Exp"])] = $itemInfo["Item_ID"];
            }
        }

        krsort($allEnhanceItem);
        foreach ($allEnhanceItem as $count => $itemID) {
            if ($retExp >= $count) {
                $retItemArr[$itemID] = floor($retExp / $count);
                $retExp -= $count * $retItemArr[$itemID];
            }
        }

        return $retItemArr;
    }

    /**
     * 检查所消耗的物品是否满足
     *
     * @param $userId
     * @param $itemArr
     * @return bool
     */
    public static function checkAllItemsExist($userId, $itemArr)
    {
        $searchKey = "`user_id` = '{$userId}'";
        $allItemTb = SysPlayerItems::loadedTable(null, $searchKey);
        /** @var SysPlayerItems $sysItem */
        foreach ($allItemTb as $sysItem) {
            if (array_key_exists($sysItem->getItemId(), $itemArr)) {
                if ($sysItem->getCount() < $itemArr[$sysItem->getItemId()])
                    return false;
            }
        }
        return true;
    }

}