<?php
require_once($GLOBALS['GAME_ROOT'] . "Classes/ExcavateModule.php");

function ExcavateApi(Up_Excavate $postPacketInfo)
{
    $retReplyInfo = null;
    $userId = $GLOBALS['USER_ID'];

    // 寻找宝藏
    $searchExcavate = $postPacketInfo->getSearchExcavate();
    if (isset($searchExcavate))
    {
        $retReplyInfo = ExcavateModule::SearchExcavate($userId, $searchExcavate);
    }

    // 查询当前玩家宝藏相关数据
    $queryExcavateData = $postPacketInfo->getQueryExcavateData();
    if (isset($queryExcavateData))
    {
        $retReplyInfo = ExcavateModule::QueryExcavateData($userId);
    }

    // 查询宝藏相关历史信息
    $queryExcavateHistory = $postPacketInfo->getQueryExcavateHistory();
    if (isset($queryExcavateHistory))
    {
        $retReplyInfo = ExcavateModule::QueryExcavateHistory($userId);
    }

    // 查询宝藏战报
    $queryExcavateBattle = $postPacketInfo->getQueryExcavateBattle();
    if (isset($queryExcavateBattle))
    {
        $retReplyInfo = ExcavateModule::QueryExcavateBattle($userId, $queryExcavateBattle);
    }

    // 更新矿点防守队伍信息
    $setExcavateTeam = $postPacketInfo->getSetExcavateTeam();
    if (isset($setExcavateTeam))
    {
        $retReplyInfo = ExcavateModule::SetExcavateTeam($userId, $setExcavateTeam);
    }

    // start_battle
    $startBattle = $postPacketInfo->getExcavateStartBattle();
    if (isset($startBattle))
    {
        $retReplyInfo = ExcavateModule::StartBattle($userId, $startBattle);
    }

    // end_battle
    $endBattle = $postPacketInfo->getExcavateEndBattle();
    if (isset($endBattle))
    {
        $retReplyInfo = ExcavateModule::EndBattle($userId, $endBattle);
    }

    // 查询协防数据
    $queryExcavateDef = $postPacketInfo->getQueryExcavateDef();
    if (isset($queryExcavateDef))
    {
        $retReplyInfo = ExcavateModule::QueryExcavateDef($userId, $queryExcavateDef);
    }

    // 清除当前战斗
    $clearExcavateBattle = $postPacketInfo->getClearExcavateBattle();
    if (isset($clearExcavateBattle))
    {
        $retReplyInfo = ExcavateModule::ClearExcavateBattle($userId);
    }

    //取防守成功奖励
    $drawExcavateDefRwd = $postPacketInfo->getDrawExcavateDefRwd();
    if (isset($drawExcavateDefRwd))
    {
        $retReplyInfo = ExcavateModule::DrawExcavateDefRwd($userId, $drawExcavateDefRwd);
    }

    //查询防守记录战斗录像
    $queryReplay = $postPacketInfo->getQueryReplay();
    if (isset($queryReplay))
    {
        $retReplyInfo = ExcavateModule::QueryReplay($userId, $queryReplay);
    }

    //复仇
    $revengeExcavate = $postPacketInfo->getRevengeExcavate();
    if (isset($revengeExcavate))
    {
        $retReplyInfo = ExcavateModule::RevengeExcavate($userId, $revengeExcavate);
    }

    //获取矿资源
    $drawExcavRes = $postPacketInfo->getDrawExcavRes();
    if (isset($drawExcavRes))
    {
        $retReplyInfo = ExcavateModule::DrawExcavRes($userId, $drawExcavRes);
    }

    //撤回守矿英雄
    $withdrawExcavateHero = $postPacketInfo->getWithdrawExcavateHero();
    if (isset($withdrawExcavateHero))
    {
        $retReplyInfo = ExcavateModule::WithdrawExcavateHero($userId, $withdrawExcavateHero);
    }


    return $retReplyInfo;
}