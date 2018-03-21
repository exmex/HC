<?php

require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/RankingList.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/NotifyModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/GuildModule.php");

function QuerRankListApi(WorldSvc $svc, Up_QueryRanklist $pPacket){
    $userId = $GLOBALS ['USER_ID'];
    Logger::getLogger()->debug("OnQuerRankList Process userId = '{$userId}'");

    $type = $pPacket->getRankType();
    if ($type==1) {
        $openPanelReply = OpenGuildApi($userId,$type);
    }
    if ($type==6) {
    	$openPanelReply = OpenRankApi($userId, $type);
    }
    if ($type==7) {
    	$openPanelReply = OpenTeamRankApi($userId, $type);
    }
    if ($type==8) {
    	$openPanelReply = OpenStarsRankApi($userId, $type);
   
    }
    return $openPanelReply;
}
//公会
function OpenGuildApi($userId,$type){
	Logger::getLogger()->debug("OnOpenGuild Process");
	$rankItem = new Down_QueryRanklistReply();
	$summaryList = RankingList::getGuildTopRank50Summary($userId);
	
	/** @Down_UserSummary $summary */
	
	foreach ($summaryList['rankArr'] as $key=>$summary) {
		$rankData = new Down_RanklistItem();
		$rankData->setGuildSummary($summary);
		$rankData->setParam1($summaryList['guildArr'][$key]);
		$rankItem->appendRanklistItem($rankData);
	}
		$getGuildRank= RankingList::getGuildRank($userId);
   	    $SummaryObj=GuildModule::getDown_GuildSummary($getGuildRank['guildId']);
   	    $getGuildRankPlayer=RankingList::getGuildRankPlayer($getGuildRank['guildId']);
   	    
        $rankDataSelf= new Down_RanklistItem();
     	$SummaryUser=PlayerModule::getUserSummaryObj($userId);
        $rankDataSelf->setUserSummary($SummaryUser);
		$rankDataSelf->setParam1($getGuildRankPlayer['Vitality']);
        $rankItem->setRankType($type);
        $rankItem->setSelfRanking($getGuildRankPlayer['rank']);
        $getGuildRankPlayer['rank']==-1 ? $SummaryGuild = $summary : $SummaryGuild=$SummaryObj;
        $rankDataSelf->setGuildSummary($SummaryGuild);
        $rankItem->setSelfPrevPos($getGuildRankPlayer['last_rank']);
        
        $rankItem->setSelfItem($rankDataSelf);
        return $rankItem;
}
//全部战斗力排行
function OpenRankApi($userId,$type){
	Logger::getLogger()->debug("OpenRankApi Process");
	$rankItem = new Down_QueryRanklistReply();
	$summaryList = RankingList::getRankTopRank50Summary($userId);
	
  /** @Down_UserSummary $summary */
        foreach ($summaryList['rankArr'] as $key=>$summary)
         {
                $rankData = new Down_RanklistItem();
                $rankData->setUserSummary($summary);
                $rankData->setParam1($summaryList['FightingArr'][$key]);
                $rankItem->appendRanklistItem($rankData);
        }
        
        $SummaryObj=PlayerModule::getUserSummaryObj($userId,1);
        $rankDataSelf= new Down_RanklistItem();
		$rankDataSelf->setUserSummary($SummaryObj);
        $rankItem->setRankType($type);
        $getHeroRank= RankingList::getHeroRank($userId);
        $rankItem->setSelfRanking($getHeroRank['rank']);
        $rankItem->setSelfPrevPos($getHeroRank['last_rank']);
        $rankDataSelf->setParam1($getHeroRank['gs']);
        $rankItem->setSelfItem($rankDataSelf);
        return $rankItem;

}

//最强5人战力排行
function OpenTeamRankApi($userId,$type)
{
	Logger::getLogger()->debug("OpenTeamRankApi Process");
	$rankItem = new Down_QueryRanklistReply();
	$summaryList = RankingList::getTeamRankTopRank50Summary($userId);

	/** @Down_UserSummary $summary */
	foreach ($summaryList['rankArr'] as $key=>$summary) {
		$rankData = new Down_RanklistItem();
		$rankData->setUserSummary($summary);
		$rankData->setParam1($summaryList['RankLimitArr'][$key]);
		$rankItem->appendRanklistItem($rankData);
	}
        $SummaryObj=PlayerModule::getUserSummaryObj($userId,1);
        $rankDataSelf= new Down_RanklistItem();
		$rankDataSelf->setUserSummary($SummaryObj);
        $rankItem->setRankType($type);
        $getHeroLimitRank= RankingList::getHeroLimitRank($userId);
        $rankItem->setSelfRanking($getHeroLimitRank['rank']);
        $rankItem->setSelfPrevPos($getHeroLimitRank['last_rank']);
        $rankDataSelf->setParam1($getHeroLimitRank['gs']);
        $rankItem->setSelfItem($rankDataSelf);
        return $rankItem;
	

}

//英雄星星数
function OpenStarsRankApi($userId,$type)
{
	Logger::getLogger()->debug("OpenStarsRankApi Process");
	$rankItem = new Down_QueryRanklistReply();
	$summaryList = RankingList::getStarsRankTopRank50Summary($userId);

	/** @Down_UserSummary $summary */
	foreach ($summaryList['rankArr'] as $key=>$summary) {
		$rankData = new Down_RanklistItem();
		$rankData->setUserSummary($summary);
		$rankData->setParam1($summaryList['RankStarsArr'][$key]);
		$rankItem->appendRanklistItem($rankData);
	}
     $SummaryObj=PlayerModule::getUserSummaryObj($userId,1);
        $rankDataSelf= new Down_RanklistItem();
		$rankDataSelf->setUserSummary($SummaryObj);
        $rankItem->setRankType($type);
        $getHeroStarsRank= RankingList::getHeroStarsRank($userId);
        $rankItem->setSelfRanking($getHeroStarsRank['rank']);
        $rankItem->setSelfPrevPos($getHeroStarsRank['last_rank']);
        $rankDataSelf->setParam1($getHeroStarsRank['stars']);
        $rankItem->setSelfItem($rankDataSelf);
        return $rankItem;

}


