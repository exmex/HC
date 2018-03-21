<?php

function Check_Daily_Task_Can_Refresh($task, $server = 0)
{
    require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysDailyTaskDetail.php");

    $isNew = false;
    $tbTask = new SysDailyTaskDetail ();
    $tbTask->setTask($task);
    $tbTask->setServerId($server);
    if (!$tbTask->LoadedExistFields()) {
        $isNew = true;
        $tbTask->setTask($task);
        $tbTask->setServerId($server);
        $tbTask->setLastRefreshTime(0);
    }

    $lastDay = date("Y-m-d", $tbTask->getLastRefreshTime());
    $nowDay = date("Y-m-d");
    if ($nowDay === $lastDay) {
        return false;
    }

    $tbTask->setLastRefreshTime(time());

    if ($isNew) {
        $tbTask->inOrUp();
    } else {
        $tbTask->save();
    }

    return true;
}
