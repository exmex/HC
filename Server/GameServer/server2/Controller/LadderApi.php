<?php
/**
 * @Author:      jaylu
 * @Date:        2015-01-26 
 * @Description: Description
 * @email:       jay@xxxx.com
 */
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/ArenaModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/NotifyModule.php");
/**
 * 竞技场功能入口
 * @param WorldSvc  $svc     [description]
 * @param Up_Ladder $pPacket [description]
 */
function LadderApi(WorldSvc $svc, Up_Ladder $pPacket){
    $userId = $GLOBALS ['USER_ID'];
    Logger::getLogger()->debug("OnLadder Process userId = '{$userId}'");
    $reply = new Down_LadderReply();
    $userLevel = PlayerCacheModule::getPlayerLevel($userId);
    $isPVPOpen = PlayerModule::checkFuncOpen($userLevel, "PVP");
    $replayRank=$pPacket->getQueryRankboard();
    if (!$isPVPOpen && !isset($replayRank)) {
        Logger::getLogger()->error("OnLadder level not enough:" . $userLevel);
        return $reply;
    }
    // 打开挑战功能
    $openPanel = $pPacket->getOpenPanel();
    if (isset($openPanel)) {
        $openPanelReply = OpenPanel($userId, $openPanel);
        $reply->setOpenPanel($openPanelReply);
    }
    // apply_opponent
    $applyOppo = $pPacket->getApplyOpponent();
    if (isset($applyOppo)) {
        $applyOppoReply = ApplyOppo($userId, $applyOppo);
        $reply->setApplyOppo($applyOppoReply);
    }
    // 开始战斗返回数据
    $startBt = $pPacket->getStartBattle();
    if (isset($startBt)) {
        $startReply = StartBattle($userId, $startBt);
        $reply->setStartBattle($startReply);
    }
    // 结束战斗返回数据
    $endBt = $pPacket->getEndBattle();
    if (isset($endBt)) {
        $endReply = EndBattle($userId, $endBt);
        $reply->setEndBattle($endReply);
    }
    // 设置英雄等级id(tid)
    $setLineup = $pPacket->getSetLineup();
    if (isset($setLineup)) {
        $setLineupReply = SetLineup($userId, $setLineup);
        $reply->setSetLineup($setLineupReply);
    }
    // query_records
    $queryRecord = $pPacket->getQueryRecords();
    if (isset($queryRecord)) {
        $queryRecordReply = QueryRecord($userId, $queryRecord);
        $reply->setQueryRecords($queryRecordReply);
    }
    // query_replay
    $queryReplay = $pPacket->getQueryReplay();
    if (isset($queryReplay)) {
        $queryReplayReply = QueryReplay($userId, $queryReplay);
        $reply->setQueryReplay($queryReplayReply);
    }
    // 查排名 
    $queryRankBoard = $pPacket->getQueryRankboard();
    if (isset($queryRankBoard)) {
        $queryRankReply = QueryRankBoard($userId, $queryRankBoard);
        $reply->setQueryRankborad($queryRankReply);
    }
    // 查oppo数据
    $queryOppo = $pPacket->getQueryOppo();
    if (isset($queryOppo)) {
        $queryOppoReply = QueryOppo($userId, $queryOppo);
        $reply->setQueryOppo($queryOppoReply);
    }
    // 清除战斗cd
    $clearCd = $pPacket->getClearBattleCd();
    if (isset($clearCd)) {
        $clearReply = ClearBattleCd($userId, $clearCd);
        $reply->setClearBattleCd($clearReply);
    }
    // 买战斗机会
    $buyBtChance = $pPacket->getBuyBattleChance();
    if (isset($buyBtChance)) {
        $buyBtReply = BuyBtChance($userId, $buyBtChance);
        $reply->setBuyBattleChance($buyBtReply);
    }

    return $reply;
}
/**
 * 初始界面数据
 * @param [type]       $userId  [description]
 * @param Up_OpenPanel $pPacket [description]
 */
function OpenPanel($userId, Up_OpenPanel $pPacket){
    Logger::getLogger()->debug("OnOpenPanel Process  init data");
    $openPanelReply = new Down_OpenPanel();
    $tbArena = ArenaModule::getArenaTable($userId);
    $openPanelReply->setRank($tbArena->getRank());

    if (SQLUtil::isTimeNeedReset($tbArena->getLastFightTime())) {
        $openPanelReply->setLeftCount(MAX_ARENA_FIGHT_COUNT);
    } else {
        $openPanelReply->setLeftCount(MAX_ARENA_FIGHT_COUNT - $tbArena->getFightCount());
    }
    $openPanelReply->setLastBtTime($tbArena->getLastFightTime());

    if (SQLUtil::isTimeNeedReset($tbArena->getLastBuyTime())) {
        $openPanelReply->setBuyTimes(0);
    } else {
        $openPanelReply->setBuyTimes($tbArena->getBuyCount());
    }

    $heroTidList = explode("|", $tbArena->getLineup());
    foreach ($heroTidList as $heroTid) {
        $openPanelReply->appendLineup($heroTid);
    }

    $tbHeroList = HeroModule::getAllHeroTable($userId, $heroTidList);
    $totalGs = 0;
    /** 给所有出战英雄加上power 值 */
    foreach ($tbHeroList as $tbHero) {
        if (in_array($tbHero->getTid(), $heroTidList)) {
            $totalGs += $tbHero->getGs(); // power value
        }
    }
    if ($tbArena->getAllGs() != $totalGs) {
        $tbArena->setAllGs($totalGs);
        $tbArena->save();
    }
    $openPanelReply->setGs($totalGs);

    $allOppo = ArenaModule::getUserAllOppoInfo($userId);
    foreach ($allOppo as $oppo) {
        $openPanelReply->appendOppos($oppo);
    }
    ArenaModule::updateRewardListToMail($userId);

    return $openPanelReply;
}


function ApplyOppo($userId, Up_ApplyOpponent $applyOppo){
    Logger::getLogger()->debug("OnApplyOppo Process");

    $applyOppoReply = new Down_ApplyOpponent();
    $allOppo = ArenaModule::getUserAllOppoInfo($userId);
    foreach ($allOppo as $oppo) {
        $applyOppoReply->appendOppos($oppo);
    }
    return $applyOppoReply;
}

/**
 * 开始战斗
 * @param [type]         $userId  [description]
 * @param Up_StartBattle $startBt [description]
 */
function StartBattle($userId, Up_StartBattle $startBt){
    Logger::getLogger()->debug("OnStartBattle Process");
    $startBtReply = new Down_StartBattle();
    $startBtReply->setResult(Down_Result::fail);
    $startBtReply->setRseed(0);
    $startBtReply->setIsRobot(0);
    $myHeroList = $startBt->getAttackLineup();
    if (count($myHeroList) <= 0) {
        Logger::getLogger()->error("OnLadder StartBattle lineup is empty!");
        return $startBtReply;
    }

    $myTbArena = ArenaModule::getArenaTable($userId);
    if (!SQLUtil::isTimeNeedReset($myTbArena->getLastFightTime())) {
        if ((time() - $myTbArena->getLastFightTime()) < ARENA_FIGHT_INTERVAL) {
            Logger::getLogger()->error("OnLadder StartBattle in CD!");
            return $startBtReply;
        }

        if ($myTbArena->getFightCount() >= MAX_ARENA_FIGHT_COUNT) {
            Logger::getLogger()->error("OnLadder StartBattle fight count full!");
            return $startBtReply;
        }
    }
    $oppoUserId = $startBt->getOppoUserId();
    $oppoTbArena = ArenaModule::getArenaTable($oppoUserId);
    if ($myTbArena->getServerId() != $oppoTbArena->getServerId()) {
        Logger::getLogger()->error("OnLadder StartBattle server not match!");
        return $startBtReply;
    }
    $heroIdStr = "";
    $pvpRecord = ArenaModule::createPvpRecord($userId, $myHeroList, $oppoUserId, $heroIdStr);
    $tbBattle = StageModule::getBattleTable($userId);
    $tbBattle->setEnterStageTime(time());
    $tbBattle->setStageId(-1);
    $tbBattle->setSrand($pvpRecord->getRseed());
    $tbBattle->setLoot("");
    $tbBattle->setPvpBuffer($heroIdStr);
    $tbBattle->save();
    //把数据写到缓存中
    $key = ARENA_USER_BUFFER_KEY . $userId;
    ArenaModule::setArenaPvpRecord($key, $pvpRecord);
    $startBtReply->setRseed($pvpRecord->getRseed());
    /** @var Down_Hero $myHero */
    foreach ($pvpRecord->getSelfHeroes() as $myHero) {
        $startBtReply->appendSelfHeroes($myHero);
    }

    foreach ($pvpRecord->getOppoHeroes() as $oppoHero) {
        $startBtReply->appendHeroes($oppoHero);
    }
    $startBtReply->setIsRobot($oppoTbArena->getIsRobot());
    $startBtReply->setResult(Down_Result::success);
    return $startBtReply;
}

/**
 * 结束战斗返回数据
 * @param [type]       $userId    [description]
 * @param Up_EndBattle $endBattle [description]
 */
function EndBattle($userId, Up_EndBattle $endBattle){
    Logger::getLogger()->debug("OnEndBattle Process  end battle  ");
    $endBtReply = new Down_EndBattle();
    $endBtReply->setResult(Down_Result::fail);
    $endBtReply->setBestRank(10000);
    $endBtReply->setBestRankReward(0);
    $endBtReply->setCurRank(10000);
    $tbBattle = StageModule::getBattleTable($userId);
    if ($tbBattle->getStageId() != -1) {
        Logger::getLogger()->error("OnLadder EndBattle stage not arena type!");
        return $endBtReply;
    }
    $key = ARENA_USER_BUFFER_KEY . $userId;
    $pvpRecord = ArenaModule::getArenaPvpRecord($key);
    if (empty($pvpRecord)) {
        $pvpStr = $tbBattle->getPvpBuffer();
        $pvpArr = explode("|", $pvpStr);
        if (count($pvpArr) != 2) {
            Logger::getLogger()->error("OnLadder EndBattle pvpInfo null!");
            return $endBtReply;
        }
        $myHeroList = explode("-", $pvpArr[0]);
        $oppoUserId = $pvpArr[1];
        $temp = "";
        $pvpRecord = ArenaModule::createPvpRecord($userId, $myHeroList, $oppoUserId, $temp);
        $pvpRecord->setRseed($tbBattle->getSrand());
    }
    $myArena = ArenaModule::getArenaTable($userId);
    $lastBestRank = $myArena->getBestRank();
    if ($lastBestRank <= 0) {
        $lastBestRank = $myArena->getRank();
    }
    $curRank = $myArena->getRank();
    $endBtReply->setCurRank($curRank);
    $endBtReply->setBestRank($lastBestRank);
    $endBtReply->setBestRankReward(0);
    $isChange = false;
    $myWinCount = $myArena->getWinCount();
    if ($endBattle->getResult() == Up_BattleResult::victory) {
        $isChange = ArenaModule::updateArenaRankAtomic($userId, $pvpRecord->getOppoUserid());
        // 增加英雄经验
        $reason = "Ladder EndBattle";
        $heroTidArr = array();
        foreach ($pvpRecord->getSelfHeroes() as $heroObj) {
            $heroTidArr[] = $heroObj->getTid();
        }
        $playerLv = PlayerCacheModule::getPlayerLevel($userId);
        $heroExpReward = floor(DataModule::lookupDataTable(PLAYER_LEVEL_LUA_KEY, "Arena Hero Exp", array($playerLv)));
        HeroModule::modifyHeroExp($userId, $heroTidArr, $heroExpReward, $reason);
        $myWinCount = $myArena->getWinCount() + 1;
    }
    // 更新战斗数据(次数,时间)
    $fightCount = $myArena->getFightCount() + 1;
    if (SQLUtil::isTimeNeedReset($myArena->getLastFightTime())) {
        $fightCount = 1;
    }
    $updateSql = "update `player_arena` set `fight_count` = '{$fightCount}', `last_fight_time` = UNIX_TIMESTAMP(), ";
    $updateSql .= "`win_count` = '{$myWinCount}' where `user_id` = '{$userId}'";
    MySQL::getInstance()->RunQuery($updateSql);
    $upRank = 0;
    if ($isChange) {
        $myArena->loaded();
        $endBtReply->setCurRank($myArena->getRank());
        $bestReward = 0;
        $paramContent = "";
        if ($lastBestRank > $myArena->getBestRank()) {
            $bestReward = ArenaModule::getBestRankReward($lastBestRank, $myArena->getBestRank());
            $endBtReply->setBestRankReward($bestReward);
            $upRank = $lastBestRank - $myArena->getBestRank();
            $paramContent = "1:1:{$lastBestRank};2:1:{$upRank}";
        }
        $upRank = $curRank - $myArena->getRank();
        // 发邮件
        if ($bestReward > 0) {
            MailModule::sendFormatMail($userId, 7, $paramContent, 0, $bestReward, "1:0;2:0", ARENA_MAIL_LIFE_TIME);
        }
    }
    // record
    if($myArena->getRank() != 1){
        ArenaModule::addArenaRecord($pvpRecord, $endBattle->getResult(), $upRank);
    }
    // 清除玩家战斗
    StageModule::clearBattleStageInfo($tbBattle);
    // 触发每日任务
    TaskModule::updateDailyTaskProgress($userId, DAILY_TASK_PVP_BATTLE);
    NotifyModule::addNotify($pvpRecord->getOppoUserid(), NOTIFY_TYPE_LADDER);
    // return
    $endBtReply->setResult(Down_Result::success);
    return $endBtReply;
}

/**
 * @param $userId
 * @param Up_SetLineup $lineup
 * @return Down_SetLineup
 */
function SetLineup($userId, Up_SetLineup $lineup)
{
    Logger::getLogger()->debug("SetLineup Process");

    $setLineupReply = new Down_SetLineup();
    $setLineupReply->setResult(Down_Result::fail);

    $heroTidArr = $lineup->getLineup();

    $heroTbList = HeroModule::getAllHeroTable($userId, $heroTidArr);
    $validHeros = array();
    $allGs = 0;
    /** @var TbPlayerHero $tbHero */
    foreach ($heroTbList as $tbHero) {
        if (in_array($tbHero->getTid(), $heroTidArr)) {
            $validHeros[] = $tbHero->getTid();
            $allGs += $tbHero->getGs();
        }
    }

    $setLineupReply->setGs($allGs);

    if (count($validHeros) <= 0) {
        return $setLineupReply;
    }
    //维持客户端传过来的阵容位置
    $newLineupArr = array();
    foreach( $heroTidArr as $heroTid )
    {
    	if ( in_array($heroTid, $validHeros) )
    	{
    		$setLineupReply->appendLineup($heroTid);
    		$newLineupArr[] = $heroTid;
    	}
    }

    $newLineup = implode("|", $newLineupArr);
    $updateSql = "UPDATE `player_arena` SET `lineup` = '{$newLineup}', `all_gs` = '{$allGs}' WHERE `user_id` = '{$userId}'";
    MySQL::getInstance()->RunQuery($updateSql);

    $setLineupReply->setResult(Down_Result::success);
    return $setLineupReply;
}

function QueryRecord($userId, Up_QueryRecords $query)
{
    Logger::getLogger()->debug("QueryRecord Process");

    $allRecord = array();
    $allReplayId = array();

    NotifyModule::clearNotify($userId, NOTIFY_TYPE_LADDER);

    // my attack
    $sqlKey = "`user_id` = '{$userId}'";
    $recordList = SysArenaRecord::loadedTable(null, $sqlKey);
    /** @var TbArenaRecord $record */
    foreach ($recordList as $record) {
        $ladderRecord = ArenaModule::getDownLadderRecord($userId, $record);
        $allRecord[$ladderRecord->getBtTime()] = $ladderRecord;
        $allReplayId[] = ARENA_RECORD_KEY . $record->getId();
    }

    // my defense
    $sqlKey = "`oppo_id` = '{$userId}'";
    $recordList = SysArenaRecord::loadedTable(null, $sqlKey);
    /** @var TbArenaRecord $record */
    foreach ($recordList as $record) {
        $ladderRecord = ArenaModule::getDownLadderRecord($userId, $record);
        $allRecord[$ladderRecord->getBtTime()] = $ladderRecord;
        $allReplayId[] = ARENA_RECORD_KEY . $record->getId();
    }

    // clear mem not found record
    $pvpRecordArr = ArenaModule::getArenaPvpRecordArr($allReplayId);
    /** @var Down_LadderRecord $ladderRecord */
    foreach ($allRecord as $ladderRecord) {
        $recordKey = ARENA_RECORD_KEY . $ladderRecord->getReplayId();
        if (empty($pvpRecordArr[$recordKey])) {
            $ladderRecord->setReplayId(0);
        }
    }

    krsort($allRecord);

    $queryReply = new Down_QueryRecords();
    foreach ($allRecord as $record) {
        $queryReply->appendRecords($record);
    }

    return $queryReply;
}

function QueryReplay($userId, Up_QueryReplay $query)
{
    Logger::getLogger()->debug("QueryReplay Process");
    $pvpRecord = ArenaModule::getArenaPvpRecordByID($query->getRecordIndex());
    if (empty($pvpRecord)) {
        Logger::getLogger()->error("QueryReplay not found record info = " . $query->getRecordIndex());
        return null;
    }

    $queryReply = new Down_QueryReplay();
    $queryReply->setRecord($pvpRecord);

    return $queryReply;
}

function QueryRankBoard($userId, Up_QueryRankboard $query)
{
    Logger::getLogger()->debug("QueryRankBoard Process");
//增加判断是否实时和每日
    if($query->getType()==0)
    {
    	$queryRank = new Down_QueryRankboard();
    	
    	$summaryList = ArenaModule::getFixedTopRank50UserSummary($userId);
    	/** @Down_UserSummary $summary */
    	foreach ($summaryList as $summary) {
    		$rankData = new Down_RankboardData();
    		$rankUserId = $summary->getUserId();
    		$rankData->setUserId($rankUserId);
    		$rankData->setSummary($summary);
    		$queryRank->appendRankList($rankData);
    	}
    	
    	$SummaryObj=PlayerModule::getUserSummaryObj($userId,0);
    	$boardData = new Down_RankboardData();
    	$boardData->setUserId($userId);
    	$boardData->setSummary($SummaryObj);
    	$queryRank->setSelfRank($boardData);
    	$tbArena = ArenaModule::getArenaRankInfo($userId);
    	$tbArena=='' ? 	$tbArenaRank=-1 : $tbArenaRank=$tbArena->getRank();
    	$queryRank->setPos($tbArenaRank);
    	
    	
    }else
    {
    	$queryRank = new Down_QueryRankboard();
    	
    	$summaryList = ArenaModule::getTopRank50UserSummary($userId);
    	/** @Down_UserSummary $summary */
    	foreach ($summaryList as $summary) {
    		$rankData = new Down_RankboardData();
    		$rankUserId = $summary->getUserId();
    		$rankData->setUserId($rankUserId);
    		$rankData->setSummary($summary);
    		$queryRank->appendRankList($rankData);
    	}
    	//why add 增加单独显示实时竞技排行榜时候的个人信息
    	$SummaryObj=PlayerModule::getUserSummaryObj($userId,0);
    	$boardData = new Down_RankboardData();
    	$boardData->setUserId($userId);
    	$boardData->setSummary($SummaryObj);
    	$queryRank->setSelfRank($boardData);
    	$tbArena = ArenaModule::getArenaRankInfo($userId);
    	
    	$tbArena=='' ? 	$tbArenaRank=-1 : $tbArenaRank=$tbArena->getRank();
    	$queryRank->setPos($tbArenaRank);
    } 
    
    return $queryRank;
}

function QueryOppo($userId, Up_QueryOppoInfo $query)
{
    $oppoId = $query->getOppoUserId();
    Logger::getLogger()->debug("QueryOppo Process:" . $oppoId);

    $queryOppo = new Down_QueryOppoInfo();
    $ladderOppoInfo = ArenaModule::getDownLadderOppoInfo($oppoId);
    $queryOppo->setUser($ladderOppoInfo);

    return $queryOppo;
}

function ClearBattleCd($userId, Up_ClearBattleCd $clearCd)
{
    Logger::getLogger()->debug("ClearBattleCd Process");

    $clearCd = new Down_ClearBattleCd();
    $clearCd->setResult(Down_Result::fail);

    $nowTime = time();
    $tbArena = ArenaModule::getArenaTable($userId);
    if (SQLUtil::isTimeNeedReset($tbArena->getLastFightTime()) ||
        (($nowTime - $tbArena->getLastFightTime()) >= ARENA_FIGHT_INTERVAL)
    ) {
        Logger::getLogger()->error("ClearBattleCd no need to clear");
        return $clearCd;
    }

    $vipOpen = VipModule::getVIPModuleLimitByUserId($userId, _VIP_MODULE_TYPE::PVP_CD_RESET);
    if (!$vipOpen) {
        Logger::getLogger()->error("ClearBattleCd VIP level low");
        return $clearCd;
    }

    $tbPlayer = PlayerModule::getPlayerTable($userId);
    if ($tbPlayer->getGem() < ARENA_CLEAR_CD_COST) {
        Logger::getLogger()->error("ClearBattleCd gem not enough");
        return $clearCd;
    }

    PlayerModule::modifyGem($userId, -ARENA_CLEAR_CD_COST, "ClearArenaCd");

    $lastFightTime = $nowTime - ARENA_FIGHT_INTERVAL;
    $updateSql = "UPDATE `player_arena` SET `last_fight_time` = '{$lastFightTime}' WHERE `user_id` = '{$userId}'";
    MySQL::getInstance()->RunQuery($updateSql);

    $clearCd->setResult(Down_Result::success);
    return $clearCd;
}

function BuyBtChance($userId, Up_BuyBattleChance $buyChance)
{
    Logger::getLogger()->debug("OnBuyBtChange Process");

    $buyBtReply = new Down_BuyBattleChance();
    $buyBtReply->setResult(Down_Result::fail);

    $tbArena = ArenaModule::getArenaTable($userId);
    if (SQLUtil::isTimeNeedReset($tbArena->getLastFightTime()) ||
        ($tbArena->getFightCount() < MAX_ARENA_FIGHT_COUNT)
    ) {
        Logger::getLogger()->error("OnBuyBtChange no need to buy");
        return $buyBtReply;
    }

    $vipChance = VipModule::getVIPModuleLimitByUserId($userId, _VIP_MODULE_TYPE::PVP_BUY);
    $needResetBuyTime = SQLUtil::isTimeNeedReset($tbArena->getLastBuyTime());
    if (!$needResetBuyTime &&
        ($tbArena->getBuyCount() >= $vipChance)
    ) {
        Logger::getLogger()->error("OnBuyBtChange VIP low chance to buy");
        return $buyBtReply;
    }

    $buyCount = $tbArena->getBuyCount() + 1;
    if ($needResetBuyTime) {
        $buyCount = 1;
    }
    $cost = intval(DataModule::lookupDataTable(GRADIENT_PRICE_LUA_KEY, "PVP Buy", array($buyCount)));
    $tbPlayer = PlayerModule::getPlayerTable($userId);
    if ($tbPlayer->getGem() < $cost) {
        Logger::getLogger()->error("OnBuyBtChange gem not enough");
        return $buyBtReply;
    }

    PlayerModule::modifyGem($userId, -$cost, "BuyArenaFightChange");

    $updateSql = "UPDATE `player_arena` SET `fight_count` = 0, `buy_count` = '{$buyCount}', `last_buy_time` = UNIX_TIMESTAMP() WHERE `user_id` = '{$userId}'";
    MySQL::getInstance()->RunQuery($updateSql);

    $buyBtReply->setResult(Down_Result::success);
    $buyBtReply->setBuyTimes($buyCount);

    return $buyBtReply;
}