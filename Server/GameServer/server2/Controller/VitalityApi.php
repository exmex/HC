<?php
/**
 * @Author:      jaylu
 * @Date:        2015-01-24 
 * @Description: Description
 * @email:       jay@xxxx.com
 */
require_once($GLOBALS['GAME_ROOT'] . "Classes/VitalityModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/BreadModule.php");
/**
 * 同步体力值
 * @param [type] $userId [description]
 */
function VitalityApi($userId){
    $syncVitalityReply = new Down_SyncVitalityReply();
    $vitalityReply = new Down_Vitality();
    $tbVitality = VitalityModule::getVitalityTable($userId);
    $vitalityReply->setCurrent($tbVitality->getCurVitality());
    $vitalityReply->setLastchange($tbVitality->getLastChangeTime());
    $vitalityReply->setTodaybuy($tbVitality->getTodayBuy());
    $vitalityReply->setLastbuy($tbVitality->getLastBuyTime());
    $syncVitalityReply->setVitality($vitalityReply);
    //增加面包体力数据
   
    $tbbread = BreadModule::getVitalityTable($userId);
    $vitalityReply->setCurrent($tbbread->getCurVitality());
    $vitalityReply->setLastchange($tbbread->getLastChangeTime());
    $vitalityReply->setTodaybuy($tbbread->getTodayBuy());
    $vitalityReply->setLastbuy($tbbread->getLastBuyTime());
    $syncVitalityReply->setShadowRunes($vitalityReply);
    return $syncVitalityReply;
}