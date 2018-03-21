<?php

require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerMonthCard.php");

class MonthCardModule
{
    const MONTH_CARD_TIME = 2592000; //月卡时间为30天 30*24*60*60

    private static function getMonthCardDownInfo(SysPlayerMonthCard $sysMonthCard)
    {
        $downMonthCard = new Down_Monthcard();
        $downMonthCard->setId($sysMonthCard->getTransactionType());
        $downMonthCard->setExpireTime($sysMonthCard->getEndTime());
        return $downMonthCard;
    }

    public static function getAllMonthCardDownInfo($userId)
    {
        $nowTimestamp = time();
        $tbAllMonthCard = SysPlayerMonthCard::loadedTable(null, "`user_id`='{$userId}' and end_time >= '{$nowTimestamp}' ");

        $allMonthCardInfo = array();
        foreach ($tbAllMonthCard as $monthCard) {
            $allMonthCardInfo[] = self::getMonthCardDownInfo($monthCard);
        }
        return $allMonthCardInfo;
    }

    public static function getMonthCardByIdArr($userId, $idArr)
    {
        $nowTimestamp = time();

        $monthCardArr = array();
        $idLen = count($idArr);
        if ($idLen < 1) {
            return $monthCardArr;
        } elseif ($idLen == 1) {
            $newTb = new SysPlayerMonthCard();
            $newTb->setUserId($userId);
            $newTb->setTransactionType($idArr[0]);
            if ($newTb->LoadedExistFields()) {
                if($newTb->getEndTime() >= $nowTimestamp){
                    $monthCardArr[] = self::getMonthCardDownInfo($newTb);
                }
            }
        } else {
            $idStr = implode(",", $idArr);
            $searchKey = "user_id = '{$userId}' and end_time >= '{$nowTimestamp}' and `transaction_type` in ({$idStr})";
            $tbAllMonthCard = SysPlayerMonthCard::loadedTable(null, $searchKey);
            foreach ($tbAllMonthCard as $monthCard) {
                $monthCardArr[] = self::getMonthCardDownInfo($monthCard);
            }
        }

        return $monthCardArr;
    }

    /**
     * 更新月卡的数据
     *
     * @param $userId
     * @param $transactionType
     */
    public static function updateMonthCard($userId, $transactionType)
    {
        $tbPlayerMonthCard = new SysPlayerMonthCard();
        $tbPlayerMonthCard->setUserId($userId);
        $tbPlayerMonthCard->setTransactionType($transactionType);
        $now = time();
        if ($tbPlayerMonthCard->LoadedExistFields()) {
            $tbPlayerMonthCard->setUpdateTime($now);
            if($tbPlayerMonthCard->getEndTime() < $now){
                $tbPlayerMonthCard->setEndTime($now + self::MONTH_CARD_TIME);
            }else{
                $tbPlayerMonthCard->setEndTime($tbPlayerMonthCard->getEndTime() + self::MONTH_CARD_TIME);
            }
            $tbPlayerMonthCard->setUpdateNum($tbPlayerMonthCard->getUpdateNum() + 1);
            $tbPlayerMonthCard->save();
        } else {
            $tbPlayerMonthCard->setStartTime($now);
            $tbPlayerMonthCard->setUpdateTime($now);
            $tbPlayerMonthCard->setEndTime($now + self::MONTH_CARD_TIME);
            $tbPlayerMonthCard->setUpdateNum(1);
            $tbPlayerMonthCard->inOrUp();
        }
    }

}
 