<?php

require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerDailyLogin.php");

class DailyLoginModule
{
    public static function getDailyLoginTable($userId)
    {
        $SysPlayerDailyLogin = new SysPlayerDailyLogin();
        $SysPlayerDailyLogin->setUserId($userId);
        if (!$SysPlayerDailyLogin->loaded())
        {
            $SysPlayerDailyLogin->setTodayClaimStatus(Down_DailyLogin_DailyloginStatus::nothing);
            $SysPlayerDailyLogin->setCurMonthClaimTimes(0);
            $SysPlayerDailyLogin->setLastClaimTime(0);
            $SysPlayerDailyLogin->inOrUp();
        }
        return $SysPlayerDailyLogin;
    }

    public static function getDailyLoginDownInfo($userId)
    {
        $SysPlayerDailyLogin = self::getDailyLoginTable($userId);
        $lastTime = $SysPlayerDailyLogin->getLastClaimTime();
        $lastYear = intval(date("Y", $lastTime));
        $lastMonth = intval(date("m", $lastTime));
        $currentTime = SQLUtil::gameNow();
        $year = intval(date("Y", $currentTime));
        $month = intval(date("m", $currentTime));
        if ($lastYear != $year || $lastMonth != $month)
        { //已经跨月了
            $SysPlayerDailyLogin->setCurMonthClaimTimes(0);
            $SysPlayerDailyLogin->setTodayClaimStatus(Down_DailyLogin_DailyloginStatus::nothing);
            $SysPlayerDailyLogin->save();
        }
        $downDailyLoginInfo = new Down_DailyLogin();
        $downDailyLoginInfo->setStatus($SysPlayerDailyLogin->getTodayClaimStatus());
        $downDailyLoginInfo->setFrequency($SysPlayerDailyLogin->getCurMonthClaimTimes());
        $downDailyLoginInfo->setLastLoginDate($SysPlayerDailyLogin->getLastClaimTime());
        return $downDailyLoginInfo;
    }
}