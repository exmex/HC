<?php
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");

function SuspendReportApi($userId, $gameTime)
{
    //$gameTime 用户本次在线时长
    $SysPlayerInfo = PlayerModule::getPlayerTable($userId);
    $SysPlayerInfo->setTotalOnlineTime($SysPlayerInfo->getTotalOnlineTime() + $gameTime);
    $SysPlayerInfo->save();

}