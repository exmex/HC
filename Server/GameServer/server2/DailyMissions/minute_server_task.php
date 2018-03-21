<?php
if ($argc != 2) {
    die ("Specify the server, please! minute_server_task.php");
}

$this_file_path = realpath(dirname(__FILE__) . "/../") . '/';
require_once($this_file_path . "config.php");
require_once($GLOBALS ['GAME_ROOT'] . 'CMySQL.php');

require_once($GLOBALS['GAME_ROOT'] . "DailyMissions/daily_task_detail.php");
require_once($GLOBALS['GAME_ROOT'] . "DailyMissions/daily_server_head.php");

// 初始化服务器配置.conf
$serverId = strval($argv[1]);
$_SERVER['FASTCGI_PLAYER_SERVER'] = $serverId;

define ("TASKID", "MINUTE_SERVER_START_TASK");

function CheckMinuteServerTask($serverTag)
{
    $GLOBALS ['USER_ID'] = "1";

    require_once($GLOBALS['GAME_ROOT'] . "Classes/ArenaModule.php");
    $nowHour = date("H");
    if (intval($nowHour) == 2) { // 每天凌晨2点重排一次竞技场
        /*if (Check_Daily_Task_Can_Refresh("updateArenaRankByServer", $serverTag)) {
             ArenaModule::updateArenaRankByServer($serverTag);
        }*/
    }
    
    if (intval($nowHour) == 21) { // 每天晚上9点记录每日竞技场
    	if (Check_Daily_Task_Can_Refresh("ArenaRankFixedByServer", $serverTag)) {
    	 ArenaModule::getArenaSetArenaFixed($serverTag);
    	}
    }
    if (intval($nowHour) == 4) { // 每天凌晨4点更新总战力排行榜  全员总战力排行榜 每天执行一次
    	if (Check_Daily_Task_Can_Refresh("fightingStrengthRank", $serverTag)) {
    		ArenaModule::fightingStrengthRank($serverTag);
    	}
    }
    
    if (intval($nowHour) == 4) { // 每天凌晨4点更新总战力排行榜  //全员星星数排行榜 每天执行一次
    	if (Check_Daily_Task_Can_Refresh("ArenaRankstarsrank", $serverTag)) {
    		ArenaModule::starsRank($serverTag);
    	}
    }
    
    if (intval($nowHour) == 4) { // 每天凌晨4点更新总战力排行榜 //全员前5名战斗力总和排行榜
    	if (Check_Daily_Task_Can_Refresh("ArenaRankStrengthLimit", $serverTag)) {
    		ArenaModule::fightingStrengthRankLimit($serverTag);
    	}
    }
    if (intval($nowHour) == 4) { // 每天凌晨4点更新总战力排行榜     //公会排行榜 
    	if (Check_Daily_Task_Can_Refresh("ArenaRankGuildVitalityRank", $serverTag)) {
    		ArenaModule::guildVitalityRank($serverTag);
    	}
    }
    
    if (intval($nowHour) == 12) { // 圣诞活动
    	if (Check_Daily_Task_Can_Refresh("ArenaPackageReward", $serverTag)) {
    		ArenaModule::PackageReward($serverTag);
    	}
    }
    
    // 其他分钟轮询服务器任务
}

function main($serverTag)
{
    //锁定行
    if (!SET_DAILY_TASK_SERVER_ROW_LOCK(TASKID, $serverTag)) {
 		 return false;
    }

    try {
        CheckMinuteServerTask($serverTag);
    } catch (Exception $e) {
    }

    //释放行锁定
    RELEASE_DAILY_TASK_SERVER_ROW_LOCK(TASKID, $serverTag);

    return true;
}

main($serverId);
