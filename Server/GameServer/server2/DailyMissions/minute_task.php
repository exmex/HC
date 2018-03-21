<?php
if ($argc != 2) {
    die ("Specify the server, please! minute_task.php");
}

$this_file_path = realpath(dirname(__FILE__) . "/../") . '/';
require_once($this_file_path . "config.php");
require_once($GLOBALS ['GAME_ROOT'] . 'CMySQL.php');

require_once($GLOBALS['GAME_ROOT'] . "DailyMissions/daily_task_detail.php");
require_once($GLOBALS['GAME_ROOT'] . "DailyMissions/daily_server_head.php");

// 读取数据库等配置
$_SERVER ['FASTCGI_PLAYER_SERVER'] = "9999";

define ("TASKID", "MINUTE_TASK");

function CheckMinuteTask()
{
    // 竞技场删除冗余战斗记录
    require_once($GLOBALS['GAME_ROOT'] . "Classes/ArenaModule.php");
    $nowHour = date("H");
    if (intval($nowHour) == 4) { // 每天凌晨4点清理一次arena_info
        if (Check_Daily_Task_Can_Refresh("clearOverdueArenaInfo")) {
            ArenaModule::clearOverdueArenaInfo();
        }
    }

    if (intval($nowHour) == 5) { // 每天凌晨5点清理一次player_mail
        require_once($GLOBALS['GAME_ROOT'] . "Classes/MailModule.php");
        if (Check_Daily_Task_Can_Refresh("clearOverdueMail")) {
            MailModule::clearOverdueMail();
        }
    }

    if (intval($nowHour) == 10) { // 每天10点补充一次神秘魂匣的数据
        require_once($GLOBALS['GAME_ROOT'] . "Classes/TavernModule.php");
        if (Check_Daily_Task_Can_Refresh("MagicDaySoul")) {
            TavernModule::autoInitMagicDaySoul();
        }
    }

    //团队本的自动物品分配
    require_once($GLOBALS['GAME_ROOT'] . "Classes/GuildModule.php");
    if(GuildModule::getCanDistributeTime(false) == 0){
        GuildModule::autoDistributeDrop();
    }

}

function main()
{
    //锁定行
    if (!SET_DAILY_TASK_SERVER_ROW_LOCK(TASKID, "")) {
     //  return false;
    }

    try {
        CheckMinuteTask();
    } catch (Exception $e) {
    }

    //释放行锁定
    RELEASE_DAILY_TASK_SERVER_ROW_LOCK(TASKID, "");

    return true;
}

main();
