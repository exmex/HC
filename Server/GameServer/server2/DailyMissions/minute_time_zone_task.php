<?php
if ($argc != 2) {
    die ("Specify the server, please! minute_time_zone_task.php");
}

$this_file_path = realpath(dirname(__FILE__) . "/../") . '/';
require_once($this_file_path . "config.php");
require_once($GLOBALS ['GAME_ROOT'] . 'CMySQL.php');

require_once($GLOBALS['GAME_ROOT'] . "DailyMissions/daily_task_detail.php");
require_once($GLOBALS['GAME_ROOT'] . "DailyMissions/daily_server_head.php");

define ("TASKID", "TIME_ZONE_TASK");

// 读取数据库等配置
$_SERVER ['FASTCGI_PLAYER_SERVER'] = "9999";

$timeZoneId = strval($argv[1]);

function CheckTimeZoneTask($timeZoneId)
{
    require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysTimeZoneList.php");
    $tbTime = new SysTimeZoneList();
    $tbTime->setId($timeZoneId);
    if (!$tbTime->loaded()) {
        return;
    }

    $timeZone = $tbTime->getTimeZone();
    date_default_timezone_set($timeZone);

    // 竞技场删除冗余战斗记录
    require_once($GLOBALS['GAME_ROOT'] . "Classes/ArenaModule.php");
    $nowHour = date("H");
    if (intval($nowHour) == 21) { // 每天21点派发竞技场奖励
        if (Check_Daily_Task_Can_Refresh("updateDailyRankReward", $timeZoneId)) {
            ArenaModule::updateDailyRankReward($timeZoneId);
        }
    }

    require_once($GLOBALS['GAME_ROOT'] . "Classes/NewServerActivity.php");
    if (intval($nowHour) == 12) { // 12点派发七日大礼包奖励
        if (Check_Daily_Task_Can_Refresh("days7Activity", $timeZoneId)) {
            NewServerActivity::days7Activity($timeZoneId);
        }
    }
/**
    if (intval($nowHour) == 0) { // 0点冲级送钱送经验统计符合条件用户
        if (Check_Daily_Task_Can_Refresh("levelActivityGetUser", $timeZoneId)) {
            NewServerActivity::levelActivityGetUser($timeZoneId);
        }
    }

    if (intval($nowHour) == 18) { // 18点冲级送钱送经验发送奖励
        if (Check_Daily_Task_Can_Refresh("levelActivityGiveReward", $timeZoneId)) {
            NewServerActivity::levelActivityGiveReward($timeZoneId);
        }
    }
*/
    /*require_once($GLOBALS['GAME_ROOT'] . "Classes/DailyActivityManager.php");
    if (intval($nowHour) == 13) { // 13点派发充值活动奖励
        if (Check_Daily_Task_Can_Refresh("payActivity", $timeZoneId)) {
            DailyActivityModule::payActivity($timeZoneId);
        }
    }*/

}

function main($timeZoneId)
{
    //锁定行
    if (!SET_DAILY_TASK_SERVER_ROW_LOCK(TASKID, $timeZoneId)) {
       return false;
    }

    try {
        CheckTimeZoneTask($timeZoneId);
    } catch (Exception $e) {
    }

    //释放行锁定
    RELEASE_DAILY_TASK_SERVER_ROW_LOCK(TASKID, $timeZoneId);

    return true;
}

main($timeZoneId);
