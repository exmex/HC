<?php

require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysExcavateHistory.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysExcavateInfo.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysExcavateTeam.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysExcavateRecord.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerExcavate.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerHireHero.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerBread.php");

define("EXCAVATE_USER_BUFFER_KEY", 'EXCAVATE_BUFFER_USER_');
define("EXCAVATE_RECORD_KEY", 'EXCAVATE_RECORD_ID_');


class ExcavateModule
{
	
	
	/** 宝藏开发所需要的最低等级 */
	const EXCAVATE_OPEN_LEVEL = 42;

    /** 每日领取面包上限 */
    const EXCAVATE_BREAD = 20;
	
	/** 搜索到敌人的超时 */
	const EXCAVATE_SEARCH_OVER_TIME = 610;
	/** 战斗的超时 */
	const EXCAVATE_BATTLE_OVER_TIME = 120;
	/*战斗消耗体力*/
	const EXCAVATE_BATTLE_OVER_BREAD = 2;
    /** Update Offset */
    const EXCAVATE_UPDATE_OFFSET = 90;
	
    function GetSysPlayerExcavate($userId)
    {
        $SysPlayerExcavateArray = SysPlayerExcavate::loadedTable(null, " user_id = '{$userId}'");
        if (sizeof($SysPlayerExcavateArray) > 0)
        {
            $PlayerExcavate = $SysPlayerExcavateArray[0];
            return $PlayerExcavate;
        }
    }

    function AppendPlayerExcavateID($userId, $excavateId)
    {
        $PlayerExcavate = self::GetSysPlayerExcavate($userId);
        $result = self::AppendExcavateID ($PlayerExcavate, $excavateId);
        if ($result)
            $PlayerExcavate->save();
        return $result;
    }

    function AppendExcavateID($PlayerExcavate, $excavateId)
    {
        if (!empty($PlayerExcavate))
        {
            $ExcavateIdStr = $PlayerExcavate->getExcavateId();
            if ($ExcavateIdStr != '')
                $ExcavateIdStr .= ':';

            $ExcavateIdStr .= $excavateId;
            $PlayerExcavate->setExcavateId($ExcavateIdStr);
            return true;
        }
        return false;
    }

    function GetPlayerExcavateIDArray($userId)
    {
        $idArray = array();
        $PlayerExcavate = self::GetSysPlayerExcavate($userId);
        if (!empty($PlayerExcavate))
        {
            $ExcavateIdStr = $PlayerExcavate->getExcavateId();
            $idArray = self::DecodeExcavate($ExcavateIdStr);
        }
        return $idArray;
    }

    function RemovePlayerExcavateID($userId, $excavateId)
    {
        $PlayerExcavate = self::GetSysPlayerExcavate($userId);
        if (!empty($PlayerExcavate))
        {
            $ExcavateIdStr = $PlayerExcavate->getExcavateId();
            $idArray = self::DecodeExcavate($ExcavateIdStr);

            $PlayerExcavate->setExcavateId('');
            foreach($idArray as $id)
            {
                if ($id != $excavateId)
                {
                    self::AppendExcavateID($PlayerExcavate, $id);
                }
            }
            $PlayerExcavate->save();
            return true;
        }
        return false;
    }

    function DecodeExcavate($excavate_str)
    {
        $val_array = array();
        $_str = $excavate_str;
        if (strlen($_str) > 0)
        {
            do
            {
                $point = strpos($_str,':');
                $slice = '';
                if (strlen($point) == 0)
                {
                    $point = strlen($_str);
                }
                $slice = substr($_str,0,$point);
                $_str = substr($_str, $point + 1);
                
                $val_array[] = $slice;
            }
            while(strlen($_str) > 0);
        }
        return $val_array;
    }

    function SetExcavateUpdateTime()
    {
        CMemcache::getInstance()->setData('EXCAVATE_UPDATE_TIME', time());
    }

    function GetExcavateUpdateTime()
    {
        return CMemcache::getInstance()->getData('EXCAVATE_UPDATE_TIME');
    }

	/**
     * 寻找宝藏
     *
     * @param $userId
     * @param $searchExcavate
     * @return Down_ExcavateReply
     */
    public static function SearchExcavate($userId, $searchExcavate)
    {
    	$excavateReplyInfo = new Down_ExcavateReply();
    	$downSearchExcavateInfo = new Down_SearchExcavateReply();
        $downSearchExcavateInfo->setResult(Down_SearchExcavateReply_SearchResult::failed);

        $playerExcavate = self::GetSysPlayerExcavate($userId);
        $curMoney = PlayerModule::getPlayerTable($userId)->getMoney();
        $cost = DataModule::lookupDataTable(GRADIENT_PRICE_LUA_KEY, "Excavate Search", $playerExcavate->getSearchTimes());
        if ($curMoney >= $cost)
        {
            PlayerModule::modifyMoney($userId, -$cost, "[SearchExcavate]");

            $excavateIDArray = self::GetPlayerExcavateIDArray($userId);
            $idStr = implode(",", $excavateIDArray);
            $myCombatPower = self::getMyPower($userId);
            $occupy = Down_Excavate_State::occupy;

            if (time() - self::GetExcavateUpdateTime() > self::EXCAVATE_UPDATE_OFFSET)
            {
                $normal_state_str = implode(",", array(Down_Excavate_State::occupy, Down_Excavate_State::protect, Down_Excavate_State::dead));
                $now_time = time();
                $sql = "UPDATE `excavate_info` SET  `state` = '{$occupy}' WHERE `state` NOT IN ('{$normal_state_str}') AND `state_end_ts` < '{$now_time}'";
                MySQL::getInstance()->RunQuery($sql);
                self::SetExcavateUpdateTime();
            }

            //TODO : this is for test!!!
            //$sql = "SELECT `id` FROM `excavate_info` where `team_gs` < '{$myCombatPower}' * 1.1 AND `team_gs` > '{$myCombatPower}' * 0.8 AND `id` not in ('{$idStr}') AND `state` = '{$occupy}' ORDER BY abs(`team_gs` - '{$myCombatPower}') limit 1";
            $sql = "SELECT `id` FROM `excavate_info` where `id` not in ('{$idStr}') ORDER BY abs(`team_gs` - '{$myCombatPower}') limit 1";
            
            $excavateId = SQLUtil::sqlExecuteScalar($sql);

            $thisExcavateInfo = SysExcavateInfo::loadedTable(null, " id = '{$excavateId}'");
            if (sizeof($thisExcavateInfo) > 0)
            {
                $thisExcavateInfo = $thisExcavateInfo[0];
                $playerExcavate->setSearchedId($excavateId);

                $ExcavateInfoArray = self::CreateDown_ExcavateArray(" id = '{$excavateId}'");
                foreach ($ExcavateInfoArray as $ExcavateInfo)
                {   //Down_Excavate
                    $ExcavateInfo->setOwner(Down_Excavate_Owner::others);
                    $downSearchExcavateInfo->setExcavate($ExcavateInfo);
                    $downSearchExcavateInfo->setResult(Down_SearchExcavateReply_SearchResult::success);

                    $team_data = array();
                    $excavateTeamArray = $ExcavateInfo->getTeam();
                    foreach ($excavateTeamArray as $excavateTeam)
                    {//Down_ExcavateTeam
                        $user_team = array();
                        $team_hero = array();
                        $team_hero_base = $excavateTeam->getHeroBases();
                        foreach ($team_hero_base as $hero_summary)
                        {//Down_HeroSummary
                            $hero_summary_array = array(10000,0,0);
                            $team_hero[$hero_summary->getTid()] = $hero_summary_array;
                        }
                        $user_team[$excavateTeam->getPlayer()->getUserId()] = $team_hero;
                        $team_data[$excavateTeam->getTeamId()] = $user_team;
                    }
                    $playerExcavate->setHeroDynas(json_encode($team_data));
                }
                $playerExcavate->save();
            }
            else
            {
                //TODO : robot!!
            }
        }
        else
        {
            $downSearchExcavateInfo->setResult(Down_SearchExcavateReply_SearchResult::lack_money);
        }
        $excavateReplyInfo->setSearchExcavateReply($downSearchExcavateInfo);

    	return $excavateReplyInfo;
    }

    function getMyPower($userId, $count = 20)
    {
        $sql = "SELECT gs from player_hero where user_id = '{$userId}' order by gs desc limit {$count}";
        $gsTop = SQLUtil::sqlExecuteArray($sql);
        $sumTop = 0;
        foreach ($gsTop as $gs) {
            $sumTop += $gs[0];
        }
        $combatPower = $sumTop * 0.95 / $count * 5;
        return $combatPower;
    }

    function CheckExcavateTime($userId)
    {
        $excavateIDArray = self::GetPlayerExcavateIDArray($userId);
        $idStr = implode(",", $excavateIDArray);
        $myExcavateInfoArray = SysExcavateInfo::loadedTable(null, "`id` in ('{$idStr}')");
        foreach ($myExcavateInfoArray as $myExcavateInfo)
        {
            $type = $myExcavateInfo->getTypeId();
            $ResourcesInfo = DataModule::lookupDataTable(EXCAVATE_TREASURE_LUA_KEY, $type);
            if ((time() - $myExcavateInfo->getCreateTime()) / 3600 > $ResourcesInfo["Hours"])
            {
                self::ChangeExcavateState($myExcavateInfo, Down_Excavate_State::dead);
            }
        }
    }
	/**
     * 查询当前玩家宝藏相关数据
     *
     * @param $userId
     * @return Down_QueryExcavateDataReply
     */
    public static function QueryExcavateData($userId)
    {
    	$excavateReplyInfo = new Down_ExcavateReply();
    	self::InitPlayerExcavate($userId);
        self::CheckExcavateTime($userId);

    	$where = " user_id = '{$userId}'";
        $SysPlayerExcavateArray = SysPlayerExcavate::loadedTable(null, $where);
        if (sizeof($SysPlayerExcavateArray) > 0) {
            $PlayerExcavate = $SysPlayerExcavateArray[0];

    		$downQueryExcavateInfo = new Down_QueryExcavateDataReply();

            $ExcavateInfoArray = self::CreateDown_ExcavateArray($where);
	        foreach ($ExcavateInfoArray as $ExcavateInfo)
	        {
	        	$downQueryExcavateInfo->appendExcavate($ExcavateInfo);
	        }
            $searchedId = $PlayerExcavate->getSearchedId();
            $ExcavateInfoArray = self::CreateDown_ExcavateArray(" id = '{$searchedId}'");
            foreach ($ExcavateInfoArray as $ExcavateInfo)
            {
                $ExcavateInfo->setOwner(Down_Excavate_Owner::others);
                $downQueryExcavateInfo->appendExcavate($ExcavateInfo);
            }

			$downQueryExcavateInfo->setSearchedId($searchedId);
			$downQueryExcavateInfo->setSearchTimes($PlayerExcavate->getSearchTimes());
			$downQueryExcavateInfo->setLastSearchTs($PlayerExcavate->getLastSearchTs());
			$downQueryExcavateInfo->setAttackingId($PlayerExcavate->getAttackingId());

        	$myHeroDynas = self::CreateDown_HeroDynaArray($PlayerExcavate->getHeroDynas());
        	foreach ($myHeroDynas as $heroId => $heros_dynas)
        	{
	            $ExcavateSelfHero = new Down_ExcavateSelfHero();
	            $ExcavateSelfHero->setHeroId($heroId);
	            $ExcavateSelfHero->setDyna($heros_dynas);
	            $downQueryExcavateInfo->appendBatHeroes($ExcavateSelfHero);
        	}

			$ExcavateCfg = new Down_ExcavateCfg();
			$ExcavateCfg->setAttackTimeout(self::EXCAVATE_BATTLE_OVER_TIME);
			$downQueryExcavateInfo->setCfg($ExcavateCfg);

			$myHireHero = self::getMyHireHero($userId, $PlayerExcavate->getLastResetTime());
			if (isset($myHireHero))
			{
				$HireheroId = $myHireHero->getHireHeroTid();

				$hireData = new Down_HireData();
	            $hireData->setName(PlayerCacheModule::getPlayerName($myHireHero->getHireUserId()));
	            $hireData->setUid($myHireHero->getHireUserId());

	            $hireHero = new Down_HireHero();
	            $heros = HeroModule::getAllHeroDownInfo($myHireHero->getHireUserId(), array($HireheroId));

	            if (count($heros) > 0) {
	                $hireHero->setBase($heros[0]);
	                foreach ($myHeroDynas as $heroId => $heros_dynas)
		        	{
			            if ($heroId == $HireheroId)
			            {
			            	$hireHero->setDyna($heros_dynas);
			            }
		        	}
	                $hireData->setHero($hireHero);
	            }
	            $downQueryExcavateInfo->setHire($hireData);
	        }

        	$excavateReplyInfo->setQueryExcavateDataReply($downQueryExcavateInfo);
        }

    	return $excavateReplyInfo;
    }
    /**
     * @param $userId
     */
    function InitPlayerExcavate($userId)
    {
    	$where = " user_id = '{$userId}'";
        $SysPlayerExcavateArray = SysPlayerExcavate::loadedTable(null, $where);
        if (sizeof($SysPlayerExcavateArray) == 0)
        {
        	$PlayerExcavate = new SysPlayerExcavate();
        	$PlayerExcavate->setUserId($userId);
        	$PlayerExcavate->setExcavateId('');
        	$PlayerExcavate->setSearchTimes(0);
            $PlayerExcavate->setLastSearchTs(time());
            $PlayerExcavate->inOrUp();
        }
    }


    /**
     * @param $userId
     * @param $lestTime
     * @return SysPlayerHireHero
     */
    function getMyHireHero($userId, $lestTime)
    {
        $SysPlayerHireHeroArr = SysPlayerHireHero::loadedTable(null, " user_id = '{$userId}' and hire_from = '3' and hire_time > '{$lestTime}'");
        if (count($SysPlayerHireHeroArr) > 0) {
            return $SysPlayerHireHeroArr[0];
        }
    }
    /**
     * create Down_Excavate
     * @param $userId
     * @return Down_Excavate
     */
    function CreateDown_ExcavateArray($where)
    {
        $Down_ExcavateArray = array();

        //$where = " user_id = '{$userId}'";
        $SysExcavateInfoArray = SysExcavateInfo::loadedTable(null, $where);

        foreach ($SysExcavateInfoArray as $SysExcavateInfo)
        {
            $ExcavateInfo = new Down_Excavate();
            $ExcavateInfo->setOwner($SysExcavateInfo->getOwner());
            $excavateId = $SysExcavateInfo->getId();
            $ExcavateInfo->setId($excavateId);
            $ExcavateInfo->setTypeId($SysExcavateInfo->getTypeId());
            $robbed=$SysExcavateInfo->getRobbed();
            $SysExcavateTeamArray = SysExcavateTeam::loadedTable(null, "excavate_id = '{$excavateId}'");
            $TeamArray = self::CreateDown_ExcavateTeamArray($SysExcavateTeamArray);
            foreach ($TeamArray as $Team)
            {
                $Team->setRobbed($robbed);
                $ExcavateInfo->appendTeam($Team);
            }
            $ExcavateInfo->setState($SysExcavateInfo->getState());
            $ExcavateInfo->setStateEndTs($SysExcavateInfo->getStateEndTs());
            $ExcavateInfo->setCreateTime($SysExcavateInfo->getCreateTime());

            $Down_ExcavateArray[$SysExcavateInfo->getId()] = $ExcavateInfo;
        }

        return $Down_ExcavateArray;
    }
    /**
     * create Down_ExcavateTeam
     * @param $SysExcavateTeamArray
     * @return Down_ExcavateTeam
     */
    function CreateDown_ExcavateTeamArray($SysExcavateTeamArray)
    {
    	$Down_ExcavateTeamArray = array();
    	if (sizeof($SysExcavateTeamArray) > 0)
    	{
	    	foreach ($SysExcavateTeamArray as $SysExcavateTeam)
	        {
	        	$ExcavateTeamInfo = new Down_ExcavateTeam();
	        	$ExcavateTeamInfo->setTeamId($SysExcavateTeam->getTeamId());
	        	$UserSummary = PlayerModule::getUserSummaryObj($SysExcavateTeam->getUserId());
	        	$ExcavateTeamInfo->setPlayer($UserSummary);
	        	$myHeroBases = json_decode($SysExcavateTeam->getHeroBases(), true);
	        	$heroArr = HeroModule::getAllHeroDownInfo($SysExcavateTeam->getUserId(), $myHeroBases);
	        	foreach ($heroArr as $hero)
	        	{
	        		$HeroSummary = new Down_HeroSummary();
	        		$HeroSummary->setTid($hero->getTid());
	        		$HeroSummary->setRank($hero->getRank());
	        		$HeroSummary->setLevel($hero->getLevel());
	        		$HeroSummary->setStars($hero->getStars());
	        		$HeroSummary->setGs($hero->getGs());
	        		$HeroSummary->setState($hero->getState());
	        		$ExcavateTeamInfo->appendHeroBases($HeroSummary);
	        	}
	        	$myHeroDynas = self::CreateDown_HeroDynaArray($SysExcavateTeam->getHeroDynas());
	        	foreach ($myHeroDynas as $heroId => $heros_dynas)
	        	{
		            $ExcavateTeamInfo->appendHeroDynas($heros_dynas);
	        	}
	        	$ExcavateTeamInfo->setResGot($SysExcavateTeam->getResGot());
	        	$ExcavateTeamInfo->setSvrId($SysExcavateTeam->getServerId());
	        	$ExcavateTeamInfo->setDisplaySvrId($SysExcavateTeam->getDisplayServerId());
	        	$ExcavateTeamInfo->setSvrName($SysExcavateTeam->getServerName());
	        	$ExcavateTeamInfo->setTeamGs($SysExcavateTeam->getTeamGs());

                //TODO : use Team Gs to calculat mining speed!
	        	//$ExcavateTeamInfo->setSpeed($SysExcavateTeam->getSpeed());

	        	$Down_ExcavateTeamArray[$ExcavateTeamInfo->getTeamId()] = $ExcavateTeamInfo;
	        }
	    }
        return $Down_ExcavateTeamArray;
    }
    /**
     * create Down_HeroDyna
     * @param $json_code
     * @return Down_HeroDyna
     */
    function CreateDown_HeroDynaArray($json_code)
    {
    	$Down_HeroDynaArray = array();
    	$myHeroDynas = json_decode($json_code, true);
    	foreach ($myHeroDynas as $heroId => $heros_dynas)
    	{
        	$dyna = new Down_HeroDyna();
            if (isset($heros_dynas))
            {
                $dyna->setHpPerc(intval($heros_dynas[0]));
                $dyna->setMpPerc(intval($heros_dynas[1]));
                $dyna->setCustomData(intval($heros_dynas[2]));
            }
            else
            {
                $dyna->setHpPerc(10000);
                $dyna->setMpPerc(0);
                $dyna->setCustomData(0);
            }
    		$Down_HeroDynaArray[$heroId] = $dyna;
    	}
        return $Down_HeroDynaArray;
    }

	/**
     * 查询宝藏相关历史信息
     *
     * @param $userId
     * @return Down_QueryExcavateHistoryReply
     */
    public static function QueryExcavateHistory($userId)
    {
    	$excavateReplyInfo = new Down_ExcavateReply();
    	$downQueryExcavateHistoryInfo = new Down_QueryExcavateHistoryReply();

		$where = " user_id = '{$userId}'";
        $SysExcavateHistoryArray = SysExcavateHistory::loadedTable(null, $where);
        foreach ($SysExcavateHistoryArray as $SysExcavateHistory) {
        	$HistoryInfo = new Down_ExcavateHistory();
        	$HistoryInfo->setId($SysExcavateHistory->getId());
        	$HistoryInfo->setExcavateId($SysExcavateHistory->getExcavateId());
        	$HistoryInfo->setResult($SysExcavateHistory->getDefResult());
        	$HistoryInfo->setEnemyName($SysExcavateHistory->getEnemyName());
        	$HistoryInfo->setEnemySvrid($SysExcavateHistory->getEnemySvrid());
        	$HistoryInfo->setEnemySvrname($SysExcavateHistory->getEnemySvrname());
        	$HistoryInfo->setTime($SysExcavateHistory->getTime());
        	$HistoryInfo->setVatility($SysExcavateHistory->getBread());
        	//$reward = '3,40:1,50:5,200'; >>> 'type,count:type,count:type,count';
        	$reward = $SysExcavateHistory->getReward();
            $reward_info_array = self::DecodeExcavate($reward);
            foreach ($reward_info_array as $reward_info)
            {
                $type = substr($reward_info,0,strpos($reward_info,','));
                $val = substr($reward_info,strpos($reward_info,',') + 1);

                $ExcavateReward = new Down_ExcavateReward();
                $ExcavateReward->setType($type);
                $ExcavateReward->setParam1($val);

                $HistoryInfo->appendReward($ExcavateReward);
            }
            $downQueryExcavateHistoryInfo->appendExcavateHistory($HistoryInfo);
        }
        $playerBread = SysPlayerBread::loadedTable(null, " user_id = '{$userId}'");
        if (sizeof($playerBread) > 0)
        {
            $downQueryExcavateHistoryInfo->setDrawDefVitality($playerBread[0]->getTodayReceive());
        }

        $excavateReplyInfo->setQueryExcavateHistoryReply($downQueryExcavateHistoryInfo);

    	return $excavateReplyInfo;
    }
	/**
     * 查询宝藏战报
     *
     * @param $userId
     * @param $queryExcavateBattle
     * @return Down_QueryExcavateBattleReply
     */
    public static function QueryExcavateBattle($userId, $queryExcavateBattle)
    {
    	$excavateReplyInfo = new Down_ExcavateReply();
    	$downQueryExcavateBattleInfo = new Down_QueryExcavateBattleReply();
        $historyId = $queryExcavateBattle->getId();
        $excavateRecordArray = SysExcavateRecord::loadedTable(null, " history_id = '{$historyId}'");

        $SysExcavateHistoryArray = SysExcavateHistory::loadedTable(null, "id = '{$historyId}'");
        if (sizeof($SysExcavateHistoryArray) > 0)
        {
            $excavateHistory = $SysExcavateHistoryArray[0];
            foreach ($excavateRecordArray as $excavateRecord)
            {
                $key = EXCAVATE_RECORD_KEY . $excavateRecord->getId();
                $excavateBattleRecord = self::getExcavateRecord($key);

                $downExcavateBattle = new Down_ExcavateBattle();
                $selfData = self::CreateDown_ExcavateBattleTeam($excavateRecord->getUserId(), $downExcavateBattle->getSelfHeroes(), $downExcavateBattle->getSelfDynas());
                $downExcavateBattle->setSelfTeam($selfData);
                $oppoData = self::CreateDown_ExcavateBattleTeam($excavateRecord->getOppoId(), $downExcavateBattle->getOppoHeroes(), $downExcavateBattle->getOppoDynas());
                $downExcavateBattle->setOppoTeam($oppoData);
                $downExcavateBattle->setResult($excavateRecord->getBtResult());
                $downExcavateBattle->setRecordId($excavateRecord->getId());
                $downExcavateBattle->setRecordSvrid($excavateHistory->getEnemySvrid());
                $downQueryExcavateBattleInfo->appendBattles($downExcavateBattle);
            }
        }
        $excavateReplyInfo->setQueryExcavateBattleReply($downQueryExcavateBattleInfo);

    	return $excavateReplyInfo;
    }
    function CreateDown_ExcavateBattleTeam($userId, $heroArr, $heroDynas)
    {
        $downExcavateBattleTeam = new Down_ExcavateBattleTeam();
        //---------------------------------------------------
        $UserSummary = PlayerModule::getUserSummaryObj($userId);
        $downExcavateBattleTeam->setPlayer($UserSummary);
        //---------------------------------------------------
        $heroBases = array();
        foreach ($heroArr as $hero)
        {
            $HeroSummary = new Down_HeroSummary();
            $HeroSummary->setTid($hero->getTid());
            $HeroSummary->setRank($hero->getRank());
            $HeroSummary->setLevel($hero->getLevel());
            $HeroSummary->setStars($hero->getStars());
            $HeroSummary->setGs($hero->getGs());
            $HeroSummary->setState($hero->getState());
            $heroBases[] = $HeroSummary;
        }
        foreach ($heroBases as $heros)
        {
            $downExcavateBattleHero = new Down_ExcavateBattleHero();
            $downExcavateBattleHero->setBase($heros);
            $downExcavateBattleHero->setDyna($heroDynas[$heros->getTid()]);

            $downExcavateBattleTeam->appendHero($downExcavateBattleHero);
        }
        return $downExcavateBattleTeam;
    }

	/**
     * 更新矿点防守队伍信息
     *
     * @param $userId
     * @param $setExcavateTeam
     * @return Down_SetExcavateTeamReply
     */
    public static function SetExcavateTeam($userId, $setExcavateTeam)
    {
    	$excavateReplyInfo = new Down_ExcavateReply();
        $downSetExcavateTeamInfo = new Down_SetExcavateTeamReply();
    	$excavateId = $setExcavateTeam->getExcavateId();
    	$teamArray = $setExcavateTeam->getTid();
    	$excavateType = $setExcavateTeam->getExcavateType();

        $myExcavateId = null;

    	if (!isset($excavateId))
    	{
    		$myExcavateId = self::CreateSysExcavateInfoData($userId, $teamArray, $excavateType);
    	}
    	else
    	{
            $ExcavateInfo = SysExcavateInfo::loadedTable(null, " id = '{$excavateId}'");
            if (sizeof($ExcavateInfo) > 0)
            {
                $ExcavateInfo = $ExcavateInfo[0];
                if ($ExcavateInfo->getUserId() == $userId)
                {
                    $teamid = $ExcavateInfo->getTeamId();
                    $ExcavateTeam = SysExcavateTeam::loadedTable(null, " team_id = '{$teamid}'");
                    if (sizeof($ExcavateTeam) > 0)
                    {
                        $ExcavateTeam = $ExcavateTeam[0];
                        $old_teamGs = $ExcavateTeam->getTeamGs();
                        $now_res_got = $ExcavateTeam->getResGot();

                        $new_res_got = self::CalculateResources($ExcavateInfo->getTypeId(), $old_teamGs, time() - $ExcavateTeam->getReplaceTime());
                        $ExcavateTeam->setResGot($now_res_got + $new_res_got);

                        $oldTeamArray = json_decode($ExcavateTeam->getHeroBases(), true);
                        self::ChangeHeroStatus($userId, $oldTeamArray, Down_HeroStatus::idle);
                        $ExcavateTeam->setHeroBases(json_encode($teamArray));
                        $dyna = array();
                        foreach ($teamArray as $hero)
                        {
                            $dyna[] = array(10000,0,0);
                        }
                        $ExcavateTeam->setHeroDynas(json_encode($dyna));
                        self::ChangeHeroStatus($userId, $teamArray, Down_HeroStatus::mining);
                        $teamGs = self::GetTeamGS($userId, $teamArray);
                        $ExcavateTeam->setTeamGs($teamGs);
                        $ExcavateTeam->setReplaceTime(time());
                        $ExcavateTeam->save();

                        $ExcavateInfo->setTeamGs($teamGs);
                        $ExcavateInfo->save();
                        $myExcavateId = $excavateId;
                    }
                }
                else
                {
                    $ExcavateTeam = SysExcavateTeam::loadedTable(null, " user_id = '{$userId}' AND excavate_id = '{$excavateId}'");
                    if (sizeof($ExcavateTeam) > 0)
                    {
                        $ExcavateTeam = $ExcavateTeam[0];

                        $old_teamGs = $ExcavateTeam->getTeamGs();
                        $now_res_got = $ExcavateTeam->getResGot();
                        
                        $new_res_got = self::CalculateResources($ExcavateInfo->getTypeId(), $old_teamGs, time() - $ExcavateTeam->getReplaceTime());
                        $ExcavateTeam->setResGot($now_res_got + $new_res_got);

                        $oldTeamArray = json_decode($ExcavateTeam->getHeroBases(), true);
                        self::ChangeHeroStatus($userId, $oldTeamArray, Down_HeroStatus::idle);
                        $ExcavateTeam->setHeroBases(json_encode($teamArray));
                        $dyna = array();
                        foreach ($teamArray as $hero)
                        {
                            $dyna[] = array(10000,0,0);
                        }
                        $ExcavateTeam->setHeroDynas(json_encode($dyna));
                        self::ChangeHeroStatus($userId, $teamArray, Down_HeroStatus::mining);
                        $teamGs = self::GetTeamGS($userId, $teamArray);
                        $ExcavateTeam->setTeamGs($teamGs);
                        $ExcavateTeam->setReplaceTime(time());
                        $ExcavateTeam->save();
                        $myExcavateId = $excavateId;
                    }
                    else
                    {
                        $help1 = $ExcavateInfo->getIdHelp1();
                        $help2 = $ExcavateInfo->getIdHelp2();
                        if ($help1 == 0 || $help2 == 0)
                        {
                            self::ChangeHeroStatus($userId, $teamArray, Down_HeroStatus::mining);
                            $ExcavateTeam = new SysExcavateTeam();
                            $ExcavateTeam->setUserId($userId);
                            $ExcavateTeam->setHeroBases(json_encode($teamArray));
                            $dyna = array();
                            foreach ($teamArray as $hero)
                            {
                                $dyna[] = array(10000,0,0);
                            }
                            $ExcavateTeam->setHeroDynas(json_encode($dyna));
                            $ExcavateTeam->setTeamGs($teamGs);
                            $ExcavateTeam->setResGot(0);
                            $ExcavateTeam->setCreateTime(time());
                            $ExcavateTeam->setReplaceTime(time());
                            $ExcavateTeam->setExcavateId($excavateId);
                            $ExcavateTeam->inOrUp();
                            $help_id = $ExcavateTeam->getTeamId();
                            if ($help1 == 0)
                                $ExcavateInfo->setIdHelp1($help_id);
                            else
                                $ExcavateInfo->setIdHelp2($help_id);
                            $ExcavateInfo->save();

                            $myExcavateId = $excavateId;
                        }
                    }
                }
            }
    	}
        if ($myExcavateId != null)
        {
            $downSetExcavateTeamInfo->setResult(Down_SetExcavateTeamReply_Result::success);
            $thisExcavateInfo = SysExcavateInfo::loadedTable(null, " id = '{$myExcavateId}'");
            if (sizeof($thisExcavateInfo) > 0)
            {
                $thisExcavateInfo = $thisExcavateInfo[0];
            }
            $ExcavateInfoArray = self::CreateDown_ExcavateArray(" id = '{$myExcavateId}'"/*$thisExcavateInfo->getUserId()*/);
            foreach ($ExcavateInfoArray as $ExcavateInfo)
            {
                // if ($ExcavateInfo->getId() == $myExcavateId)
                // {
                    $downSetExcavateTeamInfo->setMine($ExcavateInfo);
                // }
            }
        }
        else
        {
            $downSetExcavateTeamInfo->setResult(Down_SetExcavateTeamReply_Result::failed);
        }
        $excavateReplyInfo->setSetExcavateTeamReply($downSetExcavateTeamInfo);

    	return $excavateReplyInfo;
    }

    /**
     * create SysExcavateInfo data
     * @param $userId
     * @param $owner
     * @param $teamArray
     * @param $excavateType
     * @return result
     */
    function CreateSysExcavateInfoData($userId, $teamArray, $excavateType)
    {//always is new team
        $PlayerVip = new SysPlayerVip();
        $PlayerVip->setUserId($userId);
        if($PlayerVip->loaded())
        {
            $playerVip = $PlayerVip->getVip();
        }
        $VIPBounsArray = DataModule::lookupDataTable(VIP_LUA_KEY, $playerVip);
        $VIPAmount = $VIPBounsArray["Excavate Treasure Amount"];

        $excavateIdArray = self::GetPlayerExcavateIDArray($userId);
        if (sizeof($excavateIdArray) < $VIPAmount)
        {
            $teamGs = self::GetTeamGS($userId, $teamArray);
            self::ChangeHeroStatus($userId, $teamArray, Down_HeroStatus::mining);
            $excavateTeam = new SysExcavateTeam();
            $excavateTeam->setUserId($userId);
            $excavateTeam->setHeroBases(json_encode($teamArray));
            $dyna = array();
            foreach ($teamArray as $hero)
            {
                $dyna[] = array(10000,0,0);
            }
            $excavateTeam->setHeroDynas(json_encode($dyna));
            $excavateTeam->setTeamGs($teamGs);
            $excavateTeam->setResGot(0);
            $excavateTeam->setCreateTime(time());
            $excavateTeam->setReplaceTime(time());
            $excavateTeam->inOrUp();

            $excavateInfo = new SysExcavateInfo();
            $excavateInfo->setOwner(Down_Excavate_Owner::mine);
            $excavateInfo->setUserId($userId);
            $excavateInfo->setTypeId($excavateType);
            $excavateInfo->setCreateTime(time());
            $serverId = PlayerCacheModule::getServerId($userId);
            $excavateInfo->setServerId($serverId);
            $excavateInfo->setTeamId($excavateTeam->getTeamId());
            $excavateInfo->setTeamGs($teamGs);
            $excavateInfo->inOrUp();

            $excavateTeam->setExcavateId($excavateInfo->getId());
            $excavateTeam->save();

            self::ChangeExcavateState($excavateInfo, Down_Excavate_State::occupy);
            self::AppendPlayerExcavateID($userId, $excavateInfo->getId());

            return $excavateInfo->getId();
        }
        return null;
    }
    /**
     * Get Hero GS from array
     * @param $userId
     * @param $teamArray
     * @return tramGS
     */
    function GetTeamGS($userId, $teamArray)
    {
        $gs_sum = 0;
        $teamStr = implode(",", $teamArray);
        $sql = "SELECT `gs` FROM `player_hero` WHERE `user_id` = '{$userId}' AND `tid` in ({$teamStr})";
        $qr = MySQL::getInstance()->RunQuery($sql);
        $gs_array = MySQL::getInstance()->FetchArray($qr);
        if (!empty ($gs_array))
        {
            foreach ($gs_array as $gs)
                $gs_sum += $gs;
        }
        return $gs_sum;
    }

	/**
     * start_battle
     *
     * @param $userId
     * @param $startBattle
     * @return Down_ExcavateStartBattleReply
     */
    public static function StartBattle($userId, $startBattle)
    {
    	Logger::getLogger()->debug("ExcavateStartBattle Process");
    	
    	$reply = new Down_ExcavateStartBattleReply();
    	$reply->setResult(Down_Result::fail);
    	$reply->setRseed(0);
    	
    	$StartBattleSys = self::getPlayerExcavateTable($userId);
    	if (!isset($StartBattleSys)) {
    		return $reply;
    	}
    	//是否为搜索到的宝藏
    	if($startBattle->getExcavateId() != $StartBattleSys->getSearchedId())
    	{
    		return $reply;
    	}
    	//验证是否过期
    	$SysExcavateInfo = new SysExcavateInfo();
    	$SysExcavateInfo->setId($StartBattleSys->getSearchedId());
    	if($SysExcavateInfo->loaded())
    	{
    		if(time()>$SysExcavateInfo->getStateEndTs())
    		{
    			return $reply;
    		}
    		if($SysExcavateInfo->getState()==1)
    		{
    			self::ChangeExcavateState($SysExcavateInfo,2); //更改状态  增加结束时间
    		}
    	}
    	else
    	{
    		return $reply;
    	}
    	
    	

    	
    	$myHeroList = $startBattle->getHeroids();
    	//效验Hero是否还活着
    	$myHerosDyna = json_decode($StartBattleSys->getSelfHeros(), true);
    	foreach ($myHeroList as $heroId) {
    		if ($myHerosDyna[$heroId]) {
    			if ($myHerosDyna[$heroId][0] <= 0) {
    				Logger::getLogger()->debug("ExcavateStartBattle err" . __LINE__);
    				return $reply;
    			}
    		} else {
    			//初始化新heroDyna数据
    			$myHerosDyna[$heroId] = array();
    			$myHerosDyna[$heroId][0] = 10000;
    			$myHerosDyna[$heroId][1] = 0;
    			$myHerosDyna[$heroId][2] = 0;
    		}
    	}
    	//处理雇佣英雄
    	if ($startBattle->getUseHire() == 1) {
    		$hire = self::getMyHireHero($userId, $StartBattleSys->getLastResetTime());
    		if (isset($hire)) {
    			$heroId = $hire->getHireHeroTid();
    			if ($myHerosDyna[$heroId]) {
    				if ($myHerosDyna[$heroId][0] <= 0) {
    					Logger::getLogger()->debug("ExcavateStartBattle err" . __LINE__);
    					return $reply;
    				}
    			} else {
    				//初始化新heroDyna数据
    				$myHerosDyna[$heroId] = array();
    				$myHerosDyna[$heroId][0] = 10000;
    				$myHerosDyna[$heroId][1] = 0;
    				$myHerosDyna[$heroId][2] = 0;
    			}
    			$StartBattleSys->setHireHeros($heroId);
    		} else
    			$StartBattleSys->setHireHeros("");
    	} else {
    		$StartBattleSys->setHireHeros("");
    	}
    	$StartBattleSys->setSelfHeros(json_encode($myHerosDyna));
    	
    	//设置随机数
    	$SeedRand = mt_rand(1, 999);
    	$StartBattleSys->setRandSeed($SeedRand);
    	$StartBattleSys->setTeamId($startBattle->getTeamId());
    	$StartBattleSys->save();
    	
    	$oppo = json_decode($StartBattleSys->getHeroDynas(), true);
    	$oppos = $oppo[$startBattle->getTeamId()];
    	$heros = HeroModule::getAllHeroDownInfo($oppos[0], array_keys($oppos[1]));
    	foreach ($heros as $hero) {
    		$reply->appendHeroBases($hero);
    		$dyna = new Down_HeroDyna();
    		$dyna->setHpPerc($oppos[1][$hero->getTid()][0]);
    		$dyna->setMpPerc($oppos[1][$hero->getTid()][1]);
    		$dyna->setCustomData($oppos[1][$hero->getTid()][2]);
    		$reply->appendHeroDynas($dyna);
    	}
    	$reply->setRseed($SeedRand);
    	$reply->setResult(Down_Result::success);
    	
    	
    	/*录像写入*/
    	$heroIdStr="";
    	$excavateTeam = new SysExcavateTeam();
    	$excavateTeam->setTeamId($startBattle->getTeamId());
    	if($excavateTeam->loaded())
    	{
    		
    		
    		
    		$lineup= $excavateTeam->getHeroBases();
    		$pvpRecord = self::createExcavateRecord($userId, $myHeroList, $oppos[0],$lineup,$oppos[1],$myHerosDyna);
    	}
    	
    	
//     	$tbBattle = StageModule::getBattleTable($userId);
//     	$tbBattle->setEnterStageTime(time());
//     	$tbBattle->setStageId(-1);
//     	$tbBattle->setSrand($pvpRecord->getRseed());
//     	$tbBattle->setLoot("");
//     	$tbBattle->setPvpBuffer($heroIdStr);
//     	$tbBattle->save();
    	$key = EXCAVATE_USER_BUFFER_KEY . $userId;
    	self::setExcavateRecord($key, $pvpRecord);
    	
    	return $reply;
    }

    /**
     * player_excavate
     *
     * @param $userId
     */
    public static function getPlayerExcavateTable($userId)
    {
    	$searchKey = "`user_id` = {$userId}";
    	$ExcavateTbs = SysPlayerExcavate::loadedTable(null, $searchKey);
    	if (count($ExcavateTbs) > 0) {
    		return $ExcavateTbs[0];
    	}
    	return null;
    }
  
	/**
     * end_battle
     *
     * @param $userId
     * @param $endBattle
     * @return Down_ExcavateEndBattleReply
     */
    public static function EndBattle($userId, $endBattle)
    {
    	
    	Logger::getLogger()->debug("ExcavateEndBattle Process");
    	
    	$reply = new Down_ExcavateEndBattleReply();
    	$reply->setResult(Down_Result::fail);
    	
    	$EndBattleSys = self::getPlayerExcavateTable($userId);
    	if (!isset($EndBattleSys)) {
    		Logger::getLogger()->error("Excavate not exist player_excavate data");
    		return $reply;
    	}
    	// bread vitality
    	$SysBread = BreadModule::getVitalityTable($userId);
    	$returnVit=self::EXCAVATE_BATTLE_OVER_BREAD;
    	if($SysBread->getCurVitality()<$returnVit)
    	{
    		Logger::getLogger()->error("Excavate braed ".$SysBread->getCurVitality());
    		return $reply;
    	}
    	//扣除体力
    	$reason = "ExcavateExitBattle:".Up_BattleResult::victory;
    	BreadModule::modifyVitality($userId, -$returnVit, $reason);
    	
   
    
    	
    	$curTeamId = $EndBattleSys->getTeamId();
    	$selfHeros = $endBattle->getSelfHeroes();
    	$oppoHeros = $endBattle->getOppoHeroes();
    	$endBattle->getOprations();
    	$endBattle->getResult();

    	$key = ARENA_USER_BUFFER_KEY . $userId;
    	$pvpRecord = self::getExcavateRecord($key);
    	
    	//模拟战斗计算
    	//效验结果数据
    	
    	//效验Hero是否还活着
    	$selfHerosDyna = json_decode($EndBattleSys->getSelfHeros(), true);
    	foreach ($selfHeros as $hero) {
    		if ($selfHerosDyna[$hero->getHeroid()]) {
    			$selfHerosDyna[$hero->getHeroid()][0] = $hero->getHpPerc();
    			$selfHerosDyna[$hero->getHeroid()][1] = $hero->getMpPerc();
    			$selfHerosDyna[$hero->getHeroid()][2] = $hero->getCustomData();
    		}
    	}
    	$EndBattleSys->setSelfHeros(json_encode($selfHerosDyna));
    	
    	$allOppos = json_decode($EndBattleSys->getHeroDynas(), true);
    	foreach ($oppoHeros as $hero) {
    		if ($allOppos[$curTeamId][1][$hero->getHeroid()]) {
    			$allOppos[$curTeamId][1][$hero->getHeroid()][0] = $hero->getHpPerc();
    			$allOppos[$curTeamId][1][$hero->getHeroid()][1] = $hero->getMpPerc();
    			$allOppos[$curTeamId][1][$hero->getHeroid()][2] = $hero->getCustomData();
    		}
    	}
    	$EndBattleSys->setHeroDynas(json_encode($allOppos));
    	$excavate_id = $EndBattleSys->getSearchedId();
    	//记录历史数据
    	$excavateTeam = new SysExcavateTeam();
    	$excavateTeam->setTeamId($curTeamId);
    	if($excavateTeam->loaded())
    	{
    		$oppoId=$excavateTeam->getUserId();
    		
    		$excavateType = "";
    		$excavateInfo = new SysExcavateInfo();
    		$excavateInfo->setId($excavate_id);
    		if($excavateInfo->loaded())
    		{
    			$excavateType = $excavateInfo->getTypeId();
    		}
    		
    		$historyRecord=self::excavateHistory($userId,$oppoId,$excavate_id,$excavateType);
    	}
    	
    	if ($endBattle->getResult() == Up_BattleResult::victory) { //胜利
    		$reply->setResult(Down_Result::success);
    		//处理胜利后的操作 
    		foreach ($allOppos as $oppos)
    		{
    			foreach ($oppos[1] as $val)
    			{
    				$hp+=$val[0];
    			}
    		}
    		$historyRecord->setDefResult(1);
    		$rewardInfo = json_decode($EndBattleSys->getRewardWinning(), true);
    		/*To reward*/
    		if($hp==0) 
    		{
    			$DataModule = DataModule::getInstance();
    			$rewardLua= $DataModule->getDataSetting(EXCAVATE_TREASURE_LUA_KEY);
    			
    			foreach ($rewardInfo as $k=>$reward)
    			{
    				$rewardHistoryInfo="";
	  				foreach ($reward as $key=>$team_reward){
	  					$battleReward = new Down_ExcavateReward();
	    				$reward_type=self::GetExcavateRewardTypeById($key);
	    				$battleReward->setType($reward_type);
	    				$battleReward->setTeamId($EndBattleSys->getTeamId());
	    				if($reward_type==Down_ExcavateReward_Type::gold) //金币
	    				{
	    					PlayerModule::modifyMoney($userId, $team_reward, "Excavate_gold:" . $EndBattleSys->getTeamId());
	    					$rewardHistoryInfo .=$reward_type.",".$team_reward.":";
	    					$battleReward->setParam1($team_reward);
	    					
	    				}
	    				else if($reward_type==Down_ExcavateReward_Type::iron) //铁
	    				{
	    					PlayerModule::modifyIron($userId, $team_reward, "Excavate_iron:" . $EndBattleSys->getTeamId());
	    					$battleReward->setParam1($team_reward);
	    					$rewardHistoryInfo .=$reward_type.",".$team_reward.":";
	    				}
	    				else if($reward_type==Down_ExcavateReward_Type::item)//道具
	    				{
	    					ItemModule::addItem($userId, array($team_reward['id'] => $team_reward['amount']), "Excavate_item:" . $EndBattleSys->getTeamId());
	    					$battleReward->setParam1($team_reward['amount']);
	    					$battleReward->setParam2($team_reward['id']);
	    					$rewardHistoryInfo .=$reward_type.",".$team_reward['amount'].":";
	    				}
	    				else if($reward_type==Down_ExcavateReward_Type::wood) //木材
	    				{
	    					PlayerModule::modifyWood($userId, $team_reward, "Excavate_wood:" . $EndBattleSys->getTeamId());
	    					$battleReward->setParam1($team_reward);
	    					$rewardHistoryInfo .=$reward_type.",".$team_reward.":";
	    					
	    				}
	    				$reply->appendReward($battleReward);
	  				}
	  				substr($rewardHistoryInfo, 0, -1);
	    			self::writeHistoryReward($k,$excavate_id,$rewardHistoryInfo);
    			}
    			$EndBattleSys->setTeamId(0);
    			$EndBattleSys->setSelfHeros(json_encode(array()));
    			$EndBattleSys->setHeroDynas(json_encode(array()));
    			$EndBattleSys->setHireHeros(json_encode(array()));
    			$reply->setMineBattleResult("success");
    		}
    		else
    		{
    			foreach ($rewardInfo as $k=>$reward)
    			{
	    			foreach ($reward as $key=>$team_reward){
	    				$battleReward = new Down_ExcavateReward();
	    				
	    				$reward_type=self::GetExcavateRewardTypeById($key);
	    				
	    				$battleReward->setType($reward_type);
	    				$battleReward->setTeamId($EndBattleSys->getTeamId());
	    				if($reward_type==Down_ExcavateReward_Type::gold) //金币
	    				{
	    					$battleReward->setParam1($team_reward);
	    				}
	    				else if($reward_type==Down_ExcavateReward_Type::iron) //铁
	    				{
	    					$battleReward->setParam1($team_reward);
	    				}
	    				else if($reward_type==Down_ExcavateReward_Type::item)//道具
	    				{
	    					$battleReward->setParam1($team_reward['amount']);
	    					$battleReward->setParam2($team_reward['id']);
	    				}
	    				else if($reward_type==Down_ExcavateReward_Type::wood) //木材
	    				{
	    					$battleReward->setParam1($team_reward);
	    				}
	    				$reply->appendReward($battleReward);
	    			}
    			}
    		}
    		//TaskModule::updateDailyTaskProgress($userId, DAILY_TASK_COMPLETE_CRUSADE_STAGE);//每日任务
    	}
    	$historyRecord->setBread($historyRecord->getBread()+1);
    	$EndBattleSys->save();
    	// record
    	self::addExcavateRecord($pvpRecord, $endBattle->getResult(), $historyRecord->getId());
    	
    	return $reply;
    }
    /*
     * 更新历史记录
     * 
     * */
    
    public static function writeHistoryReward($userid,$excavate_id,$rewardHistoryInfo)
    {
    	$Syshistory = new SysExcavateHistory();
    	$Syshistory->setUserId($userid);
    	$Syshistory->setExcavateId($excavate_id);
    	if($Syshistory->loaded())
    	{
    		$Syshistory->setReward($rewardHistoryInfo);
    		$Syshistory->save();
    	}
    }
    
    /*
     * 历史记录写入
     * @param $userId 攻击方userid
     * @param $oppoID 防守人id
     * @param $excavateId 宝藏id
     * */
    
    public static function excavateHistory($userId,$oppoId,$excavateId,$excavateType)
    {
    	$Syshistory = new SysExcavateHistory();
    	$Syshistory->setUserId($oppoId);
    	$Syshistory->setExcavateId($excavateId);
    	$enemy_name=PlayerCacheModule::getPlayerName($userId);
    	$serverId = intval($GLOBALS['SERVERID']);
    	if($Syshistory->loaded())
    	{
    		$Syshistory->setTime(time());
    	}else{
    		$Syshistory->setUserId($oppoId);
    		$Syshistory->setExcavateId($excavateType);
    		$Syshistory->setEnemyName($enemy_name);
    		$Syshistory->setEnemySvrid($serverId);
    		$Syshistory->setEnemySvrname("");//
    		$Syshistory->setDefResult(0);
    		$Syshistory->setTime(time());
    		$Syshistory->setBread(0);
    		$Syshistory->setReward("");
    		$Syshistory->setExcavateInfoId($excavateId);
    		$Syshistory->inOrUp();
    	}
    	
    	return $Syshistory;
    }
	/**
     * 查询协防数据
     *
     * @param $userId
     * @param $queryExcavateDef
     * @return Down_QueryExcavateDefReply
     */
    public static function QueryExcavateDef($userId, $queryExcavateDef)
    {
        $excavateReplyInfo = new Down_ExcavateReply();
        $downQueryExcavateDefInfo = new Down_QueryExcavateDefReply();

        $excavateId = $queryExcavateDef->getMineId();
        $excavateUserId = $queryExcavateDef->getApplierUid();

        $ExcavateInfoArray = self::CreateDown_ExcavateArray(" id = '{$excavateId}'"/*$excavateUserId*/);
        foreach ($ExcavateInfoArray as $ExcavateInfo)
        {
            if ($ExcavateInfo->getId() == $excavateId)
            {
                $downQueryExcavateDefInfo->setExcavate($ExcavateInfo);
            }
        }
        $excavateReplyInfo->setQueryExcavateDefReply($downQueryExcavateDefInfo);

    	return $excavateReplyInfo;
    }
	/**
     * 清除当前战斗
     *
     * @param $userId
     * @param $clearExcavateBattle
     * @return Down_ClearExcavateBattleReply
     */
    public static function ClearExcavateBattle($userId)
    {
    	$excavateReplyInfo = new Down_ExcavateReply();
    	$downClearExcavateBattleInfo = new Down_ClearExcavateBattleReply();
        $PlayerExcavate = self::GetSysPlayerExcavate($userId);
        if (!empty($PlayerExcavate))
        {
            $PlayerExcavate->setAttackingId(0);
            $PlayerExcavate->setHeroDynas(null);
        }
        $excavateReplyInfo->setClearExcavateBattleReply($downClearExcavateBattleInfo);

    	return $excavateReplyInfo;
    }
	/**
     * 取防守成功奖励
     *
     * @param $userId
     * @param $drawExcavateDefRwd
     * @return Down_DrawExcavateDefRwdReply
     */
    public static function DrawExcavateDefRwd($userId, $drawExcavateDefRwd)
    {
    	$excavateReplyInfo = new Down_ExcavateReply();
    	$downDrawExcavateDefRwdInfo = new Down_DrawExcavateDefRwdReply();
        $downDrawExcavateDefRwdInfo->setResult(Down_Result::fail);

        $playerBread = SysPlayerBread::loadedTable(null, " user_id = '{$userId}'");
        if (sizeof($playerBread) > 0)
            $playerBread = $playerBread[0]->getTodayReceive();
        else
            $playerBread = 0;

        $historyId = $drawExcavateDefRwd->getId();
        if ($historyId == 'all')
            $where = " user_id = '{$userId}'";
        else
            $where = " id = '{$historyId}'";

        $total = 0;
        $SysExcavateHistoryArray = SysExcavateHistory::loadedTable(null, $where);
        foreach ($SysExcavateHistoryArray as $SysExcavateHistory)
        {
            $bread = $SysExcavateHistory->getBread();
            if ($total + $bread + $playerBread <= self::EXCAVATE_BREAD)
            {
                $total += $bread;
                $SysExcavateHistory->setBread(0);
                $SysExcavateHistory->save();
            }
            else
                break;
        }
        if ($total > 0)
        {
            $downDrawExcavateDefRwdInfo->setResult(Down_Result::success);
            $reason = "DrawExcavateDefRwd history : ".$historyId;
            BreadModule::modifyVitality($userId, $total, $reason);
        }
        $downDrawExcavateDefRwdInfo->setDrawVitality($total);
        $excavateReplyInfo->setDrawExcavateDefRwdReply($downDrawExcavateDefRwdInfo);

    	return $excavateReplyInfo;
    }
	/**
     * 查询防守记录战斗录像
     *
     * @param $userId
     * @param $queryReplay
     * @return 
     */
    public static function QueryReplay($userId, $query)
    {
    	
	    Logger::getLogger()->debug("QueryReplay Process");
	    $pvpRecord = self::getExcavateRecordByID($query->getRecordIndex());
	    if (empty($pvpRecord)) {
	        Logger::getLogger()->error("QueryReplay not found record info = " . $query->getRecordIndex());
	        return null;
	    }
	
	    $queryReply = new Down_QueryReplay();
	    $queryReply->setRecord($pvpRecord);
	
	    return $queryReply;
    }
	/**
     * 复仇
     *
     * @param $userId
     * @param $revengeExcavate
     * @return Down_RevengeExcavateReply
     */
    public static function RevengeExcavate($userId, $revengeExcavate)
    {
    	$excavateReplyInfo = new Down_ExcavateReply();
    	$downRevengeExcavateInfo = new Down_RevengeExcavateReply();

        $svrId = $revengeExcavate->getEnemySvrid();
        $enemyUid = $revengeExcavate->getEnemyUid();

        $ExcavateTeamArray = SysExcavateTeam::loadedTable(null, " user_id = '{$enemyUid}' AND server_id = '{$svrId}'");
        if (sizeof($ExcavateTeamArray) > 0)
        {
            $enemyExcavateId = $ExcavateTeamArray[0]->getExcavateId();
            $ExcavateInfoArray = self::CreateDown_ExcavateArray(" id = '{$enemyExcavateId}'"/*$enemyUid*/);
            foreach ($ExcavateInfoArray as $ExcavateInfo)
            {
                // if ($ExcavateInfo->getId() == $enemyExcavateId)
                // {
                    $downRevengeExcavateInfo->setExcavate($ExcavateInfo);
                // }
            }
        }
        $excavateReplyInfo->setRevengeExcavateReply($downRevengeExcavateInfo);

    	return $excavateReplyInfo;
    }
	/**
     * 获取矿资源
     *
     * @param $userId
     * @param $drawExcavRes
     * @return Down_DrawExcavResReply
     */
    public static function DrawExcavRes($userId, $drawExcavRes)
    {
    	$excavateReplyInfo = new Down_ExcavateReply();
    	$downDrawExcavResInfo = new Down_DrawExcavResReply();
        $excavateId = $drawExcavRes->getMineId();

        $excavateTeam = SysExcavateTeam::loadedTable(null, " user_id = '{$userId}' AND excavate_id = '{$excavateId}'");
        if (sizeof($excavateTeam) > 0)
        {
            $excavateTeam = $excavateTeam[0];
            $excavateInfo = SysExcavateInfo::loadedTable(null, " id = '{$excavateId}'");
            if (sizeof($excavateInfo) > 0)
            {
                $excavateInfo = $excavateInfo[0];

                $erxcavateType = $excavateInfo->getTypeId();
                $ResourcesInfo = DataModule::lookupDataTable(EXCAVATE_TREASURE_LUA_KEY, $erxcavateType);
                $robbed = $excavateInfo->getRobbed();

                $def_diamond = max(($ResourcesInfo["Hours"] * 5) - ($robbed * 20), $ResourcesInfo["Diamond Min"]);
                $downDrawExcavResInfo->setDiamond($def_diamond);
                PlayerModule::modifyGem($userId, $def_diamond, "[Excavate_def_Reward]");

                $teamGs = $excavateTeam->getTeamGs();
                $now_res_got = $excavateTeam->getResGot();
                $new_res_got = self::CalculateResources($erxcavateType, $teamGs, time() - $excavateTeam->getReplaceTime());
                $now_res_got += $new_res_got;

                $rewardType = self::SendExcavateRewardToPlayer($userId, $erxcavateType, $now_res_got);
                $downExcavateRewardInfo = new Down_ExcavateReward();
                $downExcavateRewardInfo->setType($rewardType);
                $downExcavateRewardInfo->setTeamId($excavateTeam->getTeamId());

                $downDrawExcavResInfo->appendReward($downExcavateRewardInfo);
                //----------------------------------------------
                self::RemoveTeamFromExcavate($userId, $excavateInfo, $excavateTeam);
            }
        }
        $excavateReplyInfo->setDrawExcavResReply($downDrawExcavResInfo);

    	return $excavateReplyInfo;
    }

    function SendExcavateRewardToPlayer($userId, $erxcavateType, $amount)
    {
        $ResourcesInfo = DataModule::lookupDataTable(EXCAVATE_TREASURE_LUA_KEY, $erxcavateType);
        $rewardType = self::GetExcavateRewardTypeById($erxcavateType);
        switch($rewardType)
        {
            case 1:
                PlayerModule::modifyMoney($userId, $amount, "[ExcavateReward]");
                break;
            case 2:
                break;
            case 3:
                $addItemArr = array($ResourcesInfo["Produce ID"] => $amount);
                ItemModule::addItem($userId, $addItemArr, "[ExcavateReward]");
                break;
            case 4:
                PlayerModule::modifyWood($userId, $amount, "[ExcavateReward]");
                break;
            case 5:
                PlayerModule::modifyIron($userId, $amount, "[ExcavateReward]");
                break;
            case 6:
                break;
            default:
                break;
        }
        return $rewardType;
    }

    function GetExcavateRewardTypeById($erxcavateType)
    {
        $rewardType = 0;
        switch($erxcavateType)
        {
            case 4:
            case 5:
            case 6:
                $rewardType = 1;
                break;
            case 7:
            case 8:
            case 9:
                $rewardType = 3;
                break;
            case 10:
            case 11:
            case 12:
                $rewardType = 4;
                break;
            case 13:
            case 14:
            case 15:
                $rewardType = 5;
                break;
            case 16:
            case 17:
            case 18:
                $rewardType = 6;
                break;
            default:
                $rewardType = 0;
                break;
        }
        return $rewardType;
    }

    function CalculateResources($erxcavateType, $gs, $time)
    {
        $ResourcesInfo = DataModule::lookupDataTable(EXCAVATE_TREASURE_LUA_KEY, $erxcavateType);
        $coefficient = $ResourcesInfo["Produce Speed GS Ratio Per Minute 1"];
        return $gs * $coefficient * $time;
    }

	/**
     * 撤回守矿英雄
     *
     * @param $userId
     * @param $withdrawExcavateHero
     * @return Down_WithdrawExcavateHeroReply
     */
    public static function WithdrawExcavateHero($userId, $withdrawExcavateHero)
    {
    	$excavateReplyInfo = new Down_ExcavateReply();
    	$downWithdrawExcavateHeroInfo = new Down_WithdrawExcavateHeroReply();
        $downWithdrawExcavateHeroInfo->setResult(Down_Result::fail);
        $heroId = $withdrawExcavateHero->getHeroId();
        $ExcavateTeamArray = SysExcavateTeam::loadedTable(null, " user_id = '{$userId}'");
        foreach ($ExcavateTeamArray as $excavateTeam)
        {
            $find = false;
            $hero_array = array();
            $myHeroBases = json_decode($excavateTeam->getHeroBases(), true);
            foreach ($myHeroBases as $id)
            {
                if ($heroId == $id)
                {
                    $find = true;
                    self::ChangeHeroStatus($userId, array($heroId), Down_HeroStatus::idle);
                }
                else
                {
                    $hero_array[] = $id;
                }
            }
            if ($find && sizeof($hero_array) > 0)
            {
                $teamGs = self::GetTeamGS($userId, $hero_array);

                $old_teamGs = $excavateTeam->getTeamGs();
                $now_res_got = $excavateTeam->getResGot();

                $excavateTeam->setHeroBases(json_encode($hero_array));
                $dyna = array();
                foreach ($hero_array as $hero)
                {
                    $dyna[] = array(10000,0,0);
                }
                $excavateTeam->setHeroDynas(json_encode($dyna));
                $excavateTeam->setTeamGs($teamGs);
                $excavateTeam->save();

                $excavateId = $excavateTeam->getExcavateId();

                $thisExcavateInfo = SysExcavateInfo::loadedTable(null, " id = '{$excavateId}'");
                if (sizeof($thisExcavateInfo) > 0)
                {
                    $thisExcavateInfo = $thisExcavateInfo[0];
                    if ($thisExcavateInfo->getUserId() == $userId)
                    {
                        $new_res_got = self::CalculateResources($thisExcavateInfo->getTypeId(), $old_teamGs, time() - $excavateTeam->getReplaceTime());
                        $excavateTeam->setResGot($now_res_got + $new_res_got);
                        $excavateTeam->save();

                        $thisExcavateInfo->setTeamGs($teamGs);
                        $thisExcavateInfo->save();
                    }
                }
                $downWithdrawExcavateHeroInfo->setResult(Down_Result::success);
            }
        }
        $excavateReplyInfo->setWithdrawExcavateHeroReply($downWithdrawExcavateHeroInfo);

    	return $excavateReplyInfo;
    }

    function ChangeExcavateState($excavateInfo, $state)
    {
        $time = time();
        $ResourcesInfo = DataModule::lookupDataTable(EXCAVATE_TREASURE_LUA_KEY, $excavateInfo->getTypeId());
        $excavateInfo->setState($state);
        switch($state)
        {
            case Down_Excavate_State::searched:
            case Down_Excavate_State::battle:
                $time += 600;
                break;
            case Down_Excavate_State::shield:
                switch($ResourcesInfo["Hours"])
                {
                    case 1:
                        $time += 1800;
                        break;
                    case 3:
                        $time += 3600;
                        break;
                    case 10:
                        $time += 5400;
                        break;
                }
                break;
            case Down_Excavate_State::occupy:
            case Down_Excavate_State::protect:
            case Down_Excavate_State::dead:
            default:
                $time = $excavateInfo->getCreateTime() + ($ResourcesInfo["Hours"] * 3600);
                break;
        }
        $excavateInfo->setStateEndTs($time);
        $excavateInfo->save();
    }

    function ChangeHeroStatus($userId, $hero_array, $status)
    {
        $heroList = HeroModule::getAllHeroTable($userId, $hero_array);
        //更新武将的状态
        foreach ($heroList as $SysHero)
        {
            $SysHero->setState($status);
            $SysHero->save();
        }
    }

    function RemoveTeamFromExcavate($userId, $excavateInfo, $excavateTeam)
    {
        $help1 = $excavateInfo->getIdHelp1();
        $help2 = $excavateInfo->getIdHelp2();
        $myTeamId = $excavateInfo->getTeamId();
        $teamId = $excavateTeam->getTeamId();
        if ($myTeamId == $teamId)
        {
            $excavateInfo->setTeamId(0);
            $excavateInfo->save();
        }
        if ($help1 == $teamId)
        {
            $excavateInfo->setIdHelp1(0);
            $excavateInfo->save();
        }
        if ($help2 == $teamId)
        {
            $excavateInfo->setIdHelp2(0);
            $excavateInfo->save();
        }
        $myHeroBases = json_decode($excavateTeam->getHeroBases(), true);
        self::ChangeHeroStatus($userId, $myHeroBases, Down_HeroStatus::idle);
        $excavateTeam->delete();
        self::RemovePlayerExcavateID($userId, $excavateInfo->getId());

        $help1 = $excavateInfo->getIdHelp1();
        $help2 = $excavateInfo->getIdHelp2();
        $myTeamId = $excavateInfo->getTeamId();

        if ($help1 == 0 && $help2 == 0 && $myTeamId == 0)
        {
            $excavateInfo->delete();
        }
    }
    /**
     * 创建战斗记录
     * @param $userId
     * @param $myHeroIdList
     * @param $oppoUserId
     * @param $heroIdStr
     * **/
	public static function createExcavateRecord($userId, $myHeroIdList, $oppoUserId,$lineup,$oppoDyna,$myHeroDyna){
        $pvpRecord = new Down_PvpRecord();
        $pvpRecord->setCheckid(0);
        $pvpRecord->setUserid($userId);
        $pvpRecord->setOppoUserid($oppoUserId);
        $randSeed = mt_rand(1, 999);
        $pvpRecord->setRseed($randSeed);
        $myTbArena = ArenaModule::getArenaTable($userId);
        $pvpRecord->setSelfRobot($myTbArena->getIsRobot());
        $myHeroList = HeroModule::getAllHeroDownInfo($userId, $myHeroIdList);
        foreach ($myHeroList as $downHero) {
            $pvpRecord->appendSelfHeroes($downHero);
        }
        foreach ($myHeroDyna as $selfDyna)
        {
        	$selfheroDyna = new Down_HeroDyna();
        	$selfheroDyna->setHpPerc($selfDyna[0]);
        	$selfheroDyna->setMpPerc($selfDyna[1]);
        	$selfheroDyna->setCustomData($selfDyna[2]);
        	$pvpRecord->appendSelfDynas($selfheroDyna);
        }

        $oppoTbArena = ArenaModule::getArenaTable($oppoUserId);
        $pvpRecord->setOppoRobot($oppoTbArena->getIsRobot());
//         $heroList = explode("|", $oppoTbArena->getLineup());
        $oppoHeroList = HeroModule::getAllHeroDownInfo($oppoUserId, $lineup);
        foreach ($oppoHeroList as $downHero) {
            $pvpRecord->appendOppoHeroes($downHero);
        }
        foreach ($oppoDyna as $dyna)
        {
        	$heroDyna = new Down_HeroDyna();
        	$heroDyna->setHpPerc($dyna[0]);
        	$heroDyna->setMpPerc($dyna[1]);
        	$heroDyna->setCustomData($dyna[2]);
        	$pvpRecord->appendOppoDynas($heroDyna);
        }
        
        return $pvpRecord;
    }
    
    /**
     * 战斗信息 存储memcache
     * @param $key
     * @param $pvpRecord
     * **/
    public static function setExcavateRecord($key, Down_PvpRecord $pvpRecord){
    	$memStr = $pvpRecord->serializeToString();
    	CMemcache::getInstance()->setData($key, $memStr, MEMCACHE_EXPIRE_TIME * 2);
    }
    /**
     * 战斗信息 读取memcache
     * @param $key
     *
     * **/
    public static function getExcavateRecord($key){
    	$memStr = CMemcache::getInstance()->getData($key);
    	if ($memStr) {
    		$pvpRecord = new Down_PvpRecord();
    		$pvpRecord->parseFromString($memStr);
    		return $pvpRecord;
    	} else {
    		return null;
    	}
    }
    /**
     * 
     * 存储录像信息
     * @param $pvpRecord
     * @param $Result
     * @param $historyId
     * **/
     public static function addExcavateRecord(Down_PvpRecord $pvpRecord, $result, $historyId)
     {
     		$tbPly1 = PlayerModule::getPlayerTable($pvpRecord->getUserid());
     		$tbPly2 = PlayerModule::getPlayerTable($pvpRecord->getOppoUserid());
     		$newRecord = new SysExcavateRecord();
     		$newRecord->setUserId($tbPly1->getUserId());
     		$newRecord->setUserName($tbPly1->getNickname());
     		$newRecord->setUserAvatar($tbPly1->getAvatar());
     		$newRecord->setUserLevel($tbPly1->getLevel());
     		$newRecord->setUserRobot($pvpRecord->getSelfRobot());
     		$newRecord->setOppoId($tbPly2->getUserId());
     		$newRecord->setOppoName($tbPly2->getNickname());
     		$newRecord->setOppoAvatar($tbPly2->getAvatar());
     		$newRecord->setOppoLevel($tbPly2->getLevel());
     		$newRecord->setOppoRobot($pvpRecord->getOppoRobot());
     		$newRecord->setBtResult($result);
     		$newRecord->setBtTime(time());
     		$newRecord->setHistoryId($historyId);
     		$newRecord->inOrUp();
     		$pvpRecord->setCheckid($newRecord->getId());
     		$key = EXCAVATE_RECORD_KEY . $newRecord->getId();
     		self::setExcavateRecord($key, $pvpRecord);
     
     }
     /*
      * 读取单条录像
      * 
      * @param $id 录像id
      * */
     public static function getExcavateRecordByID($id){
     	$excavateRecord = new SysExcavateRecord();
     	$excavateRecord->setId($id);
     	if (!$excavateRecord->loaded()) {
     		return null;
     	}
     	$key = EXCAVATE_RECORD_KEY . $id;
     	$pvpRecord = self::getExcavateRecord($key);
     	if (empty($pvpRecord)) {
     		return null;
     	}
     	$pvpRecord->setUserName($excavateRecord->getUserName());
     	$pvpRecord->setLevel($excavateRecord->getUserLevel());
     	$pvpRecord->setAvatar($excavateRecord->getUserAvatar());
     	$pvpRecord->setVip(0);
     	$pvpRecord->setOppoName($excavateRecord->getOppoName());
     	$pvpRecord->setOppoLevel($excavateRecord->getOppoLevel());
     	$pvpRecord->setOppoAvatar($excavateRecord->getOppoAvatar());
     	$pvpRecord->setOppoVip(0);
     	$pvpRecord->setResult($excavateRecord->getBtResult());
     	return $pvpRecord;
     }
   
}