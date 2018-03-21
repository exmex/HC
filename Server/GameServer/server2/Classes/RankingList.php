<?php

require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerArena.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysArenaRecord.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/MailModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/ShopModule.php");
//why add 
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerArenaFixed.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysGuildInfo.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerFightingStrengthRank.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerFightingStrengthRankLimit.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerStarsRank.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysGuildVitalityRank.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/GuildModule.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerGuild.php");
class RankingList
{
   
    public static function getGuildTopRank50Summary($userId)
    {
        $rankArr = array();
        $serverId = PlayerCacheModule::getServerId($userId);
        $sqlKey = "server_id = '{$serverId}' order by rank limit 50";

        $SysGuildList = SysGuildVitalityRank::loadedTable(array('guild_id', 'rank','vitality0','vitality3'), $sqlKey);

        $guildArr = array();
        /** @var SysPlayerArena $tbArena */
       
       foreach ($SysGuildList as $SysGuild) {
            $guildArr[$SysGuild->getRank()] = $SysGuild->getVitality3()-$SysGuild->getVitality0();
            $rankArr[$SysGuild->getRank()] = GuildModule::getDown_GuildSummary($SysGuild->getGuildId());
            
            $guildArr[$SysGuild->getRank()]=='' ? $liveness =0 : $liveness =$guildArr[$SysGuild->getRank()];
            if($rankArr[$SysGuild->getRank()]!='')
            {
               $rankArr[$SysGuild->getRank()]->setLiveness($liveness);
            }else {
            	continue;
            }


        }
        //$summaryArr = PlayerModule::
		//getUserSummaryArr($userArr);
        /*$userListStr = implode(",", $userArr);
        $sqlKey = "user_id in ($userListStr)";
        $tbPlayerList = TbPlayer::loadedTable(array('user_id', 'nickname', 'level', 'avatar'), $sqlKey);

        $tbSortArr = array();*/
        /** @var TbPlayer $tbPlayer */
        /*foreach ($tbPlayerList as $tbPlayer) {
            $tbSortArr[$tbPlayer->getUserId()] = $tbPlayer;
        }
        foreach ($userArr as $rank => $userId) {
            $rankArr[$rank] = $summaryArr[$userId];
        }*/

        ksort($rankArr);
        $keyArr['guildArr']=$guildArr;
        $keyArr['rankArr']=$rankArr;
        return $keyArr;
    }
    
    public static function getRankTopRank50Summary($userId)
    {
    	$rankArr = array();
    	$serverId = PlayerCacheModule::getServerId($userId);
    	$sqlKey = "server_id = '{$serverId}' order by rank limit 50";
    
    	$tbFightingList = SysPlayerFightingStrengthRank::loadedTable(array('user_id','gs','rank','is_robot'), $sqlKey);
   
    	$FightingArr = array();
    	/** @var TbPlayerArena $tbArena */
    	foreach ($tbFightingList as $tbRank) {
    	    $FightingArr[$tbRank->getRank()] = $tbRank->getGs();
    		$rankArr[$tbRank->getRank()] =  PlayerModule::getUserSummaryObj($tbRank->getUserId(),$tbRank->getIsRobot());
    	}
    
    	//$summaryArr = PlayerModule::getUserSummaryArr($userArr);
    	/*$userListStr = implode(",", $userArr);
    	 $sqlKey = "user_id in ($userListStr)";
    	$tbPlayerList = TbPlayer::loadedTable(array('user_id', 'nickname', 'level', 'avatar'), $sqlKey);
    
    	$tbSortArr = array();*/
    	/** @var TbPlayer $tbPlayer */
    	/*foreach ($tbPlayerList as $tbPlayer) {
    	 $tbSortArr[$tbPlayer->getUserId()] = $tbPlayer;
    	}
    	foreach ($userArr as $rank => $userId) {
    	$rankArr[$rank] = $summaryArr[$userId];
    	}*/
    	$keyArr=array();
    	ksort($rankArr);
    	$keyArr['FightingArr']=$FightingArr;
    	$keyArr['rankArr']=$rankArr;
    	return $keyArr;
    }
    
    public static function getTeamRankTopRank50Summary($userId)
    {
    	$rankArr = array();
    	$serverId = PlayerCacheModule::getServerId($userId);
    	$sqlKey = "server_id = '{$serverId}' order by rank limit 50";
    
    	$tbFightingList = SysPlayerFightingStrengthRankLimit::loadedTable(array('user_id','gs','rank','is_robot'), $sqlKey);
    
    	$RankLimitArr = array();
    	/** @var TbPlayerArena $tbArena */
    	foreach ($tbFightingList as $tbRank) {
    		$RankLimitArr[$tbRank->getRank()] = $tbRank->getGs();
    		$rankArr[$tbRank->getRank()] =  PlayerModule::getUserSummaryObj($tbRank->getUserId(),$tbRank->getIsRobot());
    	}
    
    	//$summaryArr = PlayerModule::getUserSummaryArr($userArr);
    	/*$userListStr = implode(",", $userArr);
    	 $sqlKey = "user_id in ($userListStr)";
    	$tbPlayerList = TbPlayer::loadedTable(array('user_id', 'nickname', 'level', 'avatar'), $sqlKey);
    
    	$tbSortArr = array();*/
    	/** @var TbPlayer $tbPlayer */
    	/*foreach ($tbPlayerList as $tbPlayer) {
    	 $tbSortArr[$tbPlayer->getUserId()] = $tbPlayer;
    	}
    	foreach ($userArr as $rank => $userId) {
    	$rankArr[$rank] = $summaryArr[$userId];
    	}*/
    
    	$keyArr=array();
    	ksort($rankArr);
    	$keyArr['RankLimitArr']=$RankLimitArr;
    	$keyArr['rankArr']=$rankArr;
    	return $keyArr;
    }
    
    
    public static function getStarsRankTopRank50Summary($userId)
    {
    	$rankArr = array();
    	$serverId = PlayerCacheModule::getServerId($userId);
    	$sqlKey = "server_id = '{$serverId}' order by rank limit 50";
    
    	$tbFightingList = SysPlayerStarsRank::loadedTable(array('user_id','stars', 'rank','is_robot'), $sqlKey);
    
    	$RankStarsArr = array();
    	/** @var TbPlayerArena $tbArena */
    	foreach ($tbFightingList as $tbRank) {
    		$RankStarsArr[$tbRank->getRank()] = $tbRank->getStars();
    		$rankArr[$tbRank->getRank()] =  PlayerModule::getUserSummaryObj($tbRank->getUserId(),$tbRank->getIsRobot());
    	}
    
    	//$summaryArr = PlayerModule::getUserSummaryArr($userArr);
    	/*$userListStr = implode(",", $userArr);
    	 $sqlKey = "user_id in ($userListStr)";
    	$tbPlayerList = TbPlayer::loadedTable(array('user_id', 'nickname', 'level', 'avatar'), $sqlKey);
    
    	$tbSortArr = array();*/
    	/** @var TbPlayer $tbPlayer */
    	/*foreach ($tbPlayerList as $tbPlayer) {
    	 $tbSortArr[$tbPlayer->getUserId()] = $tbPlayer;
    	}
    	foreach ($userArr as $rank => $userId) {
    	$rankArr[$rank] = $summaryArr[$userId];
    	}*/
    
    	$keyArr=array();
    	ksort($rankArr);
    	$keyArr['RankStarsArr']=$RankStarsArr;
    	$keyArr['rankArr']=$rankArr;
    	return $keyArr;
    }
    //全部战力
    public static function getHeroRank($userId)
    {
    	  $keyArr=array();
        $TbPlayerFightingStrengthRank = new SysPlayerFightingStrengthRank();
        $TbPlayerFightingStrengthRank->setUserId($userId);
        if($TbPlayerFightingStrengthRank->loaded())
        {   
                $keyArr['rank']=$TbPlayerFightingStrengthRank->getRank();
                $keyArr['last_rank']=$TbPlayerFightingStrengthRank->getLastRank();
                $keyArr['gs']= $TbPlayerFightingStrengthRank->getGs();
        } 
        else  
        { 
                $keyArr['rank']=-1;
                $keyArr['last_rank']=0;
                $keyArr['gs']=0;
        } 
        return $keyArr;
    	
    }
    
    public static function getHeroLimitRank($userId)
    {
    	$keyArr=array();
    	$TbPlayerFightingStrengthRankLimit = new SysPlayerFightingStrengthRankLimit();
    	$TbPlayerFightingStrengthRankLimit->setUserId($userId);
    	if($TbPlayerFightingStrengthRankLimit->loaded())
    	{
    		$keyArr['rank']=$TbPlayerFightingStrengthRankLimit->getRank();
    		$keyArr['last_rank']=$TbPlayerFightingStrengthRankLimit->getLastRank();
    		$keyArr['gs']= $TbPlayerFightingStrengthRankLimit->getGs();
    	}
    	else
    	{
    		$keyArr['rank']=-1;
    		$keyArr['last_rank']=0;
    		$keyArr['gs']=0;
    	}
    	return $keyArr;
    	 
    }
    
    public static function getHeroStarsRank($userId)
    {
    	$keyArr=array();
    	$TbPlayerStarsRank = new SysPlayerStarsRank();
    	$TbPlayerStarsRank->setUserId($userId);
    	if($TbPlayerStarsRank->loaded())
    	{
    		$keyArr['rank']=$TbPlayerStarsRank->getRank();
    		$keyArr['last_rank']=$TbPlayerStarsRank->getLastRank();
    		$keyArr['stars']=$TbPlayerStarsRank->getStars();
    	}
    	else
    	{
    		$keyArr['rank']=-1;
    		$keyArr['last_rank']=0;
    		$keyArr['stars']=0;
    	}
    	return $keyArr;
    	 
    }
    
    
    public static function getGuildRank($userId)
    {
    	$keyArr=array();
    	$TbPlayerGuild = new SysPlayerGuild();
    	$TbPlayerGuild->setUserId($userId);
    	if($TbPlayerGuild->loaded())
    	{
    		$keyArr['guildId']=$TbPlayerGuild->getGuildId();
    	}
    	else
    	{
    		$keyArr['guildId']=0;
    	}
    	return $keyArr;
    
    }
    
    public static function getGuildRankPlayer($guildId)
    {
    	$keyArr=array();
    	$TbGuildVitalityRank = new SysGuildVitalityRank();
    	$TbGuildVitalityRank->setGuildId($guildId);
    	if($TbGuildVitalityRank->loaded())
    	{
    		$keyArr['rank']=$TbGuildVitalityRank->getRank();
    		$keyArr['last_rank']=$TbGuildVitalityRank->getLastRank();
    		$keyArr['Vitality'] = $TbGuildVitalityRank->getVitality3() - $TbGuildVitalityRank->getVitality0();
    	}
    	else 
    	{

    		$keyArr['rank']=-1;
    		$keyArr['last_rank']=0;
    		$keyArr['Vitality'] =0;
    	}
    	return $keyArr;
    
    }
    
    
        
}