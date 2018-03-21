<?php
/**
 * @Author:      jaylu
 * @Date:        2015-01-20 
 * @Description: Description
 * @email:       jay@xxxx.com
 */
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerVitality.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/ParamModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/GuildModule.php");

class VitalityModule{
    private static $VitTableCached = array();
    public static function getVitalityTable($userId){
        if (isset(self::$VitTableCached[$userId])) {
            return self::$VitTableCached[$userId];
        }
        $nowTime = time();
        // 更新玩家体力
        $objPlyVitality = new SysPlayerVitality();
        $objPlyVitality->setUserId($userId);
        if ($objPlyVitality->loaded()) {
            $maxVit = self::getMaxVitality($userId);
            $addVitInterval = ParamModule::GetSyncVitalityGap();
            $changeTime = floor($nowTime / $addVitInterval) * $addVitInterval;
            if ($objPlyVitality->getCurVitality() < $maxVit) {
                $nowVit = floor(($nowTime - $objPlyVitality->getLastChangeTime()) / $addVitInterval) + $objPlyVitality->getCurVitality();
                if ($nowVit != $objPlyVitality->getCurVitality()) {
                    $objPlyVitality->setCurVitality(min($maxVit, $nowVit));
                    $objPlyVitality->setLastChangeTime($changeTime);
                    $objPlyVitality->save();
                }
            } else {
                if ($changeTime != $objPlyVitality->getLastChangeTime()) {
                    $objPlyVitality->setLastChangeTime($changeTime);
                    $objPlyVitality->save();
                }
            }
        } else {
            $objPlyVitality->setCurVitality(60);
            $objPlyVitality->setLastChangeTime($nowTime);
            $objPlyVitality->setTodayBuy(0);
            $objPlyVitality->setLastBuyTime($nowTime);
            $objPlyVitality->inOrUp();
        }
        self::$VitTableCached[$userId] = $objPlyVitality;
        return $objPlyVitality;
    }
    /**
     * 返回体力数据
     * @param  [type] $userId [description]
     * @return [type]         [description]
     */
    public static function getVitalityDownInfo($userId){
        $plyVitality = new Down_Vitality();
        $tbPlyVitality = self::getVitalityTable($userId);
        $plyVitality->setCurrent($tbPlyVitality->getCurVitality());
        $plyVitality->setLastchange($tbPlyVitality->getLastChangeTime());
        $plyVitality->setTodaybuy($tbPlyVitality->getTodayBuy());
        $plyVitality->setLastbuy($tbPlyVitality->getLastBuyTime());
        return $plyVitality;
    }
    /**
     * 最大体力值
     * @param  [type] $userId [description]
     * @return [type]         [description]
     */
    public static function getMaxVitality($userId){
        $level = PlayerCacheModule::getPlayerLevel($userId);
        $maxVitality = floor(DataModule::lookupDataTable(PLAYER_LEVEL_LUA_KEY, "Max Vitality", array($level)));
        #增加vip特权 体力上限
        $vipLevel= VipModule::getVipLevel($userId);
        $vitalityAdd = intval(DataModule::lookupDataTable(VIP_LUA_KEY, "User Vitality Max", array($vipLevel)));
        return $maxVitality+$vitalityAdd;
    }

    /**
     * 修改体力
     * @param  [type]  $userId  [description]
     * @param  [type]  $vit     [description]
     * @param  string  $reason  [description]
     * @param  boolean $timeAdd [description]
     * @return [type]           [description]
     */
    public static function modifyVitality($userId, $vit, $reason = "", $timeAdd = false){
        $tbVit = VitalityModule::getVitalityTable($userId);
        $after = max(0, ($tbVit->getCurVitality() + $vit));
        if ($timeAdd) {
            $maxVit = self::getMaxVitality($userId);
            $after = min($maxVit, $after);
        }
        LogClient::getInstance()->logVitChanged($userId, $reason, $tbVit->getCurVitality(), $after);
        if ($vit < 0) {
            GuildModule::addVitality($userId, abs($vit));
        }
        if ($vit != 0) {
            $tbVit->setCurVitality($after);
            $tbVit->save();
        }
        return $after;
    }
}