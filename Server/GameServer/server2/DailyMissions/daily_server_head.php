<?php
error_reporting(E_ERROR);
function CHECK_DAILY_TASK_SERVER_TABLE($task, $serverId)
{
    require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysDailyTaskServer.php");


    $tbTask = new SysDailyTaskServer ();
    $tbTask->setTask($task);
    $tbTask->setServerId($serverId);
    if ($tbTask->LoadedExistFields()) {
        return $tbTask->getId();
    }

    $tbTask->setLock(0);
    $tbTask->setLastRunTime(0);
    $tbTask->inOrUp();

    return $tbTask->getId();
}

function SET_DAILY_TASK_SERVER_ROW_LOCK($task, $serverId = 0)
{
    $id = CHECK_DAILY_TASK_SERVER_TABLE($task, $serverId);

    $sql = "update daily_task_server set `lock` = 1 where `id` = '{$id}' and `lock` = 0";
    MySQL::getInstance()->RunQuery($sql);

    $ret = MySQL::getInstance()->GetAffectRows();
    if ($ret > 0) {
        return true;
    }

    return false;
}

function RELEASE_DAILY_TASK_SERVER_ROW_LOCK($task, $serverId = 0)
{
    $id = CHECK_DAILY_TASK_SERVER_TABLE($task, $serverId);

    $nowTime = time();
    $sql = "update daily_task_server set `lock` = 0, `last_run_time` = $nowTime where `id` = '{$id}'";
    MySQL::getInstance()->RunQuery($sql);
}
