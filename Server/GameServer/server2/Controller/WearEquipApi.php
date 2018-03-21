<?php

require_once($GLOBALS['GAME_ROOT'] . "Classes/HeroModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/ItemModule.php");

function WearEquipApi(WorldSvc $svc, Up_WearEquip $pPacket)
{
    $userId = $GLOBALS ['USER_ID'];
    Logger::getLogger()->debug("WearEquipApi Process user id:" . $userId . " heroTid:" . $pPacket->getHeroid() . " pos:" . $pPacket->getItemPos());


    $heroTid=$pPacket->getHeroId();
  	$equipIndex=  $pPacket->getItemPos();
  	
    if ($equipIndex < 1 || $equipIndex > 6) {
    	Logger::getLogger()->error("WearEquipApi index is over band:" . $equipIndex);
    	return 0;
    }
    
    $heroList = HeroModule::getAllHeroTable($userId, array($heroTid));
    if (empty($heroList[$heroTid])) {
    	Logger::getLogger()->error("WearEquipApi not found hero by tid:" . $heroTid);
    	return 0;
    }
    
    /** @var SysPlayerHero $oneHero */
    $oneHero = $heroList[$heroTid];
    $equipArr = HeroModule::getHeroEquipArr($oneHero);
    if ($equipArr[$equipIndex][0] != 0) {
    	Logger::getLogger()->error("WearEquipApi equip index has exist:" . $equipIndex);
    	return 0;
    }
    
    $indexKey = "Equip{$equipIndex} ID";
    $needEquipTid = DataModule::lookupDataTable(HERO_EQUIP_LUA_KEY, $indexKey, array($heroTid, $oneHero->getRank()));
    
    $lvRequire = DataModule::lookupDataTable(ITEM_LUA_KEY, "Level Requirement", array($needEquipTid));
    if ($lvRequire > $oneHero->getLevel()) {
    	Logger::getLogger()->error("WearEquipApi hero lv is low:" . $oneHero->getLevel());
    	return 0;
    }
    
    $subRet = ItemModule::subItem($userId, array($needEquipTid => 1), "wearHeroEquip:" . $heroTid . "-pos:" . $equipIndex);
    if (!$subRet) {
    	return 0;
    }
    
    $equipArr[$equipIndex][0] = $needEquipTid;
    $equipArr[$equipIndex][1] = 0;
    $equipStr = HeroModule::getHeroEquipStr($equipArr);
    $oneHero->setHeroEquip($equipStr);
    $oneHero->setGs(HeroModule::getHeroGs($userId, $heroTid, $oneHero));
    $oneHero->save();
    
   $ret =  $oneHero->getGs();
    
    $retReply = new Down_WearEquipReply();
    if ($ret > 0) {
        $retReply->setResult(Down_Result::success);
        $retReply->setGs($ret);
    } else {
        $retReply->setResult(Down_Result::fail);
        $retReply->setGs(0);
    }
    return $retReply;
}