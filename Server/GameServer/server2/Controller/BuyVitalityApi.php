<?php
/**
 * @Author:      jaylu
 * @Date:        2015-01-21 
 * @Description: Description
 * @email:       jay@xxxx.com
 */
require_once($GLOBALS['GAME_ROOT'] . "Classes/VitalityModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/DataModule.php");;
require_once($GLOBALS['GAME_ROOT'] . "Classes/VipModule.php");

define('BUY_VITALITY_ADD', 120);
define('BUY_BREAD_VITALITY_ADD', 10);
/**
 * 购买体力
 * @param [type] $userId [description]
 */
function BuyVitalityApi($userId,Up_BuyVitality $pPacket){
	
	
    Logger::getLogger()->debug("OnBuyVitality process");
    
    if($pPacket->getType()==2)
    {
    	Logger::getLogger()->debug("OnBuyVitality bread process");
    	$buyBread=buyBread($userId);
    	return $buyBread;
    }
    $syncVitalityReply = new Down_SyncVitalityReply();
    $vitalityReply = new Down_Vitality();
    //VIP 1.检查购买权限（可购买次数）
    $canBuyTimes = VipModule::getVIPModuleLimitByUserId($userId, _VIP_MODULE_TYPE::BUY_VIT_MAX);

    $curGem = PlayerModule::getPlayerTable($userId)->getGem();
    $objVitality = VitalityModule::getVitalityTable($userId);
    $breadVitality = BreadModule::getVitalityTable($userId);

    //更新当天购买次数
    if (SQLUtil::isTimeNeedReset($objVitality->getLastBuyTime())) {
        $objVitality->setTodayBuy(0);
    }

    $costGem = DataModule::lookupDataTable(GRADIENT_PRICE_LUA_KEY, "Vitality", array($objVitality->getTodayBuy() + 1 => $objVitality->getTodayBuy() + 1));

    //购买次数达到上限、gem不足 购买失败
    if (($objVitality->getTodayBuy() >= $canBuyTimes) || ($costGem > $curGem)) {
        $curVitality = $objVitality->getCurVitality();
        $vitalityReply->setCurrent($curVitality);
        $vitalityReply->setLastchange($objVitality->getLastChangeTime());
        $vitalityReply->setTodaybuy($objVitality->getTodayBuy());
        $vitalityReply->setLastbuy($objVitality->getLastBuyTime());
        $syncVitalityReply->setVitality($vitalityReply);
        //面包体力传值
        $vitalityReply->setCurrent($breadVitality->getCurVitality());
        $vitalityReply->setLastchange($breadVitality->getLastChangeTime());
        $vitalityReply->setTodaybuy($breadVitality->getTodayBuy());
        $vitalityReply->setLastbuy($breadVitality->getLastBuyTime());
        $syncVitalityReply->setShadowRunes($vitalityReply);
        
        
        Logger::getLogger()->error("OnBuyVitality times full! BuyTimes {$objVitality->getTodayBuy()} canBuyTimes:{$canBuyTimes}  CostGem {$costGem} CurGem {$curGem}");
        return $syncVitalityReply;
    }

    PlayerModule::modifyGem($userId, -$costGem, "OnBuyVitality");

    //2.更新购买次数以及购买时间
    $objVitality->setLastBuyTime(time());
    $objVitality->setLastChangeTime(time());
    $objVitality->setTodayBuy($objVitality->getTodayBuy() + 1);

    //3.更新体力
    VitalityModule::modifyVitality($userId, BUY_VITALITY_ADD,"OnBuyVitality: CostGem {$costGem} CurGem {$curGem}");
    $objVitality->save();
    $curVitality = $objVitality->getCurVitality();
    $vitalityReply->setCurrent($curVitality);
    $vitalityReply->setLastchange($objVitality->getLastChangeTime());
    $vitalityReply->setTodaybuy($objVitality->getTodayBuy());
    $vitalityReply->setLastbuy($objVitality->getLastBuyTime());
    $syncVitalityReply->setVitality($vitalityReply);
    
    //面包体力传值
    $vitalityReply->setCurrent($breadVitality->getCurVitality());
    $vitalityReply->setLastchange($breadVitality->getLastChangeTime());
    $vitalityReply->setTodaybuy($breadVitality->getTodayBuy());
    $vitalityReply->setLastbuy($breadVitality->getLastBuyTime());
    $syncVitalityReply->setShadowRunes($vitalityReply);

    return $syncVitalityReply;
}

function buyBread($userId)
{
	$syncVitalityReply = new Down_SyncVitalityReply();
	$vitalityReply = new Down_Vitality();
	//VIP 1.检查购买权限（可购买次数）
	$canBuyTimes = 12;//VipModule::getVIPModuleLimitByUserId($userId, _VIP_MODULE_TYPE::BUY_VIT_MAX);
	
	$curGem = PlayerModule::getPlayerTable($userId)->getGem();
	$objVitality = VitalityModule::getVitalityTable($userId);
	$breadVitality = BreadModule::getVitalityTable($userId);
	
	//更新当天购买次数
	if (SQLUtil::isTimeNeedReset($breadVitality->getLastBuyTime())) {
		$breadVitality->setTodayBuy(0);
	}
	
	$costGem = DataModule::lookupDataTable(GRADIENT_PRICE_LUA_KEY, "Excavate Vitality", array($breadVitality->getTodayBuy() + 1 => $breadVitality->getTodayBuy() + 1));
	
	//购买次数达到上限、gem不足 购买失败
	if (($breadVitality->getTodayBuy() >= $canBuyTimes) || ($costGem > $curGem)) {
		$curVitality = $objVitality->getCurVitality();
		$vitalityReply->setCurrent($curVitality);
		$vitalityReply->setLastchange($objVitality->getLastChangeTime());
		$vitalityReply->setTodaybuy($objVitality->getTodayBuy());
		$vitalityReply->setLastbuy($objVitality->getLastBuyTime());
		$syncVitalityReply->setVitality($vitalityReply);
		//面包体力传值
		$vitalityReply->setCurrent($breadVitality->getCurVitality());
		$vitalityReply->setLastchange($breadVitality->getLastChangeTime());
		$vitalityReply->setTodaybuy($breadVitality->getTodayBuy());
		$vitalityReply->setLastbuy($breadVitality->getLastBuyTime());
		$syncVitalityReply->setShadowRunes($vitalityReply);
		
		Logger::getLogger()->error("OnBuyBraeadVitality times full! BuyTimes {$breadVitality->getTodayBuy()} canBuyTimes:{$canBuyTimes}  CostGem {$costGem} CurGem {$curGem}");
		return $syncVitalityReply;
	}
	
	PlayerModule::modifyGem($userId, -$costGem, "OnBuyVitality");
	
	//2.更新购买次数以及购买时间
	$breadVitality->setLastBuyTime(time());
	$breadVitality->setLastChangeTime(time());
	$breadVitality->setTodayBuy($objVitality->getTodayBuy() + 1);
	
	//3.更新体力
	BreadModule::modifyVitality($userId, BUY_BREAD_VITALITY_ADD,"OnBuyVitality: CostGem {$costGem} CurGem {$curGem}");
	$objVitality->save();
	$curVitality = $objVitality->getCurVitality();
	$vitalityReply->setCurrent($curVitality);
	$vitalityReply->setLastchange($objVitality->getLastChangeTime());
	$vitalityReply->setTodaybuy($objVitality->getTodayBuy());
	$vitalityReply->setLastbuy($objVitality->getLastBuyTime());
	$syncVitalityReply->setVitality($vitalityReply);
	
	//面包体力传值
	$vitalityReply->setCurrent($breadVitality->getCurVitality());
	$vitalityReply->setLastchange($breadVitality->getLastChangeTime());
	$vitalityReply->setTodaybuy($breadVitality->getTodayBuy());
	$vitalityReply->setLastbuy($breadVitality->getLastBuyTime());
	$syncVitalityReply->setShadowRunes($vitalityReply);
	
	return $syncVitalityReply;
	
}