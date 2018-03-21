<?php
$GLOBALS ['GAME_ROOT']="../../server2/";

function main($argc,$argv)
{
	if($argc < 2){
		echo "user_id is null";
		return;
	}
	
	$user_id=$argv[1];
	fixHeroSoldier($user_id);
	fixEquipment($user_id);
}

function fixHeroSoldier($userId)
{
	require_once($GLOBALS ['GAME_ROOT'] . "db/TbPlayerHeros.php");
	require_once($GLOBALS ['GAME_ROOT'] . "hero/PlayerTechsManager.php");
	require_once($GLOBALS ['GAME_ROOT'] . "battle/rule/BattleRuleHelper.php");
	
	$heroList = TbPlayerHeros::loadTable(null,array("user_id"=>$userId));
	if(empty($heroList)){
		echo "empty hero list\n";
		return;
	}
	
	foreach($heroList as $tbHero){		
		$heroRule = BattleRuleHelper::getInstance()->getHeroRule($tbHero->getHeroId());
		if(empty($heroRule)){
			echo "Failed to find hero rule ".$tbHero->getHeroId()."\n";
			continue;
		}
		
					
		$baseSoldier = intval($heroRule['soldierNum']);		
		if(empty($baseSoldier)){
			$baseSoldier = 260;
		}
		
		$solderAdd = (intval($baseSoldier/10)+10) * ($tbHero->getLevel()-1);
		$solderNum = $baseSoldier + $solderAdd;
		$solderNum += PlayerTechsManager::getTechEffect($userId,TECH_TYPE::WARHORN); //甲胄科技			
		$solderNum += PlayerTechsManager::getTechEffect($userId,TECH_TYPE::ENSIGN); //军旗科技			
		
		$tbHero->setSoldierLimit($solderNum);
		$tbHero->setSoldierNum($solderNum);
		$tbHero->save();		
	}	
}

function fixEquipment($userId)
{
	require_once ($GLOBALS['GAME_ROOT'] . "db/TbPlayerEquipments.php");
	require_once ($GLOBALS['GAME_ROOT'] . "rule/GameRuleManager.php");
	require_once ($GLOBALS['GAME_ROOT'] . "hero/PlayerEquipmentManager.php");
	require_once ($GLOBALS['GAME_ROOT'] . "protocol/game_idl.php");

	$equList = TbPlayerEquipments::loadTable(null,array("user_id"=>$userId));
	if(empty($equList)){
		echo "empty tech list\n";
		return;
	}
	
	foreach($equList as $tbEqu){
		$itemId = $tbEqu->getItemId();
		$itemRule = GameRuleManager::getInstance()->getItemRule($itemId);
		if(empty($itemRule)){
			echo "fixEquipment error {$itemId} rule not found";
			continue;
		}
		
		$tbEqu->setType(PlayerEquipmentManager::getEquipmentType($itemRule->subtype()));
		$tbEqu->setColor(PlayerEquipmentManager::getEquipmentColor($itemRule->getEquipmentColor()));
		$tbEqu->setGrow($itemRule->getEquipmentGrow());
		$tbEqu->setAttribute($itemRule->getEquipmentAttribute()+$itemRule->getEquipmentGrow()*($tbEqu->getLevel()-1));
		$tbEqu->save();
	}
	
}


$ac = 2;
$av = array(null, 9030);
main($ac,$av);