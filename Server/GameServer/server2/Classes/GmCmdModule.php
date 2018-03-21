<?php

class GmCmdModule
{
	private static $reason = 'GmCmd';
	
	public static function modifyMoney($userId, $type, $amount)
	{
		switch ( $type )
		{
			case PRICE_TYPE::gold :
				if ( $amount == 0 )
				{
					$tbPlayer = PlayerModule::getPlayerTable($userId);
					$amount = 0 - $tbPlayer->getMoney();
				}
				PlayerModule::modifyMoney($userId, $amount, self::$reason);
				break;
			case PRICE_TYPE::diamond :
				if ( $amount == 0 )
				{
					$tbPlayer = PlayerModule::getPlayerTable($userId);
					$amount = 0 - $tbPlayer->getGem();
				}
				PlayerModule::modifyGem($userId, $amount, self::$reason);
				break;
			case PRICE_TYPE::crusadepoint :
				if ( $amount == 0 )
				{
					$tbPlayer = PlayerModule::getPlayerTable($userId);
					$amount = 0 - $tbPlayer->getCrusadePoint();
				}
				PlayerModule::modifyCrusadePoint($userId, $amount, self::$reason);
				break;
			case PRICE_TYPE::arenapoint :
				if ( $amount == 0 )
				{
					$tbPlayer = PlayerModule::getPlayerTable($userId);
					$amount = 0 - $tbPlayer->getArenaPoint();
				}
				PlayerModule::modifyArenaPoint($userId, $amount, self::$reason);
				break;
			case PRICE_TYPE::guildpoint :
				if ( $amount == 0 )
				{
					$tbPlayer = PlayerModule::getPlayerTable($userId);
					$amount = 0 - $tbPlayer->getGuildPoint();
				}
				PlayerModule::modifyGuildPoint($userId, $amount, self::$reason);
				break;
		}
	}
	
	public static function modifyVitality($userId, $amount)
	{
		VitalityModule::modifyVitality($userId, $amount, self::$reason);
	}
	
	public static function modifyExp($userId, $amount)
	{
		PlayerModule::modifyPlyExp($userId, $amount, self::$reason);
	}
	
	public static function modifyLevel($userId, $amount)
	{
		$tbPlayer = PlayerModule::getPlayerTable($userId);
    	$curLv = $tbPlayer->getLevel();
    	$maxLv = ParamModule::GetTeamLevelMax();
    	if ($curLv >= $maxLv) {
    		return;
    	}
    	
    	$newLv = min($curLv + $amount, $maxLv);
    	$tbPlayer->setLevel($newLv);
    	$tbPlayer->save();
    	
    	PlayerCacheModule::setPlayerLevel($userId, $newLv);
	}
	
	public static function addItems($userId, $items)
	{
		$itemArr = array();
		foreach( $items as $add_item )
		{
			$itemId = MathUtil::bits($add_item, 0, 10);
			$itemNum = MathUtil::bits($add_item, 10, 11);
		
			$itemArr[$itemId] = $itemNum;
		}
		ItemModule::addItem($userId, $itemArr, self::$reason);
	}
	
	public static function modifyHeros($userId, $heros)
	{
		foreach ( $heros as $add_hero )
		{
			$tbHero = new SysPlayerHero();
			$tbHero->setUserId($userId);
			$tbHero->setTid($add_hero->getTid() );
			$tbHero->setRank($add_hero->getRank());
			$tbHero->setLevel($add_hero->getLevel());
			$tbHero->setStars($add_hero->getStars());
			$tbHero->setExp($add_hero->getExp());
			$tbHero->setGs($add_hero->getGs());
			$tbHero->setState($add_hero->getState());
			$skillLevels = $add_hero->getSkillLevels();
			$tbHero->setSkill1Level($skillLevels[0]);
			$tbHero->setSkill2Level($skillLevels[1]);
			$tbHero->setSkill3Level($skillLevels[2]);
			$tbHero->setSkill4Level($skillLevels[3]);
			if ( !$tbHero->LoadedExistFields() )
			{
				$tbHero->setHeroEquip(HERO_INIT_EQUIP_LIST);
			}
		
			$tbHero->inOrUp();
		}
	}
	
	public static function addAllHeros($userId)
	{
		for ( $i = 1; $i <= 54; ++$i )
		{
			HeroModule::addPlayerHero($userId, $i, self::$reason);
		}
	}
	
	public static function unlockStages($userId, $maxStage)
	{
		$tbNormal = StageModule::getNormalStageTable($userId);
		$curMax = $tbNormal->getMaxStageId();
		
		//268个普通关卡
		$max = min($maxStage, 268);
		for ( $i = $curMax + 1; $i <= $max; ++$i )
		{
			StageModule::updateNormalStageProgress($userId, $i, 3);
		}
	}
	/*
	//add 
	public static function unlockElitesStages($userId, $maxStage)
	{
		$tbElite = StageModule::getEliteStageTable($userId);
		$curMax = $tbElite->getMaxStageId();
	
		//268个普通关卡
		$max = min($maxStage, 268);
		for ( $i = $curMax + 1; $i <= $max; ++$i )
		{
			StageModule::updateEliteStageProgress($userId, $i, 3);
		}
	}
	*/
	public static function resetUser($userId)
	{
		clearPlayerInfo::clearByUserId($userId);
	}
	
	public static function openShop($userId, $shopId)
	{
		$tbVip = VipModule::getVipTable($userId);
		if ( $tbVip->getVip() < 11 )
		{
			$tbVip->setVip(11);
			$tbVip->inOrUp();
		}
		
		ShopModule::openShop($userId, $shopId);
	}
	
	public static function setRechargeSum($userId, $sum)
	{
		$tbVip = VipModule::getVipTable($userId);
		$add = $sum - $tbVip->getRecharge();
		if ( $add <= 0 )
		{
			return;
		}
		VipModule::updateVIP($userId, array('VIP Exp' => $add));
	}
	
	public static function resetSweep($userId)
	{
		$tbElite = StageModule::getEliteStageTable($userId);
		for ( $id = MAX_NORMAL_STAGE_ID + 1; $id <= $tbElite->getMaxStageId(); ++$id )
		{
			StageModule::resetEliteDailyTimes($userId, $id);
		}
	}
}