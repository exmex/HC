<?php
require_once($GLOBALS['GAME_ROOT'] . "Classes/DataModule.php");;
require_once($GLOBALS['GAME_ROOT'] . "Classes/DailyLoginModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/VipModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/ItemModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/HeroModule.php");

function DailyLoginApi($userId, Up_AskDailyLogin_Status $status)
{
    Logger::getLogger()->debug("DailyLoginApi:Start replay");

    $userDailyLoginInfo = DailyLoginModule::getDailyLoginTable($userId);
    $todayStatus = $userDailyLoginInfo->getTodayClaimStatus();
    $lastTime = $userDailyLoginInfo->getLastClaimTime();

    $replyInfo = new Down_AskDailyLoginReply();
    $replyInfo->setResult(Down_Result::fail);

    if ($todayStatus == Down_DailyLogin_DailyloginStatus::all && !SQLUtil::isTimeNeedReset($lastTime))
    {
    //今日已经领取
        Logger::getLogger()->debug("OnDailyLogin:Return[0]");
        return $replyInfo;
    }
    //本月已领次数
    $curMonthTimes = $userDailyLoginInfo->getCurMonthClaimTimes();
    $last_year = intval(date("Y", $lastTime));
    $last_month = intval(date("m", $lastTime));
    $curTime = SQLUtil::gameNow();
    $year = intval(date("Y", $curTime));
    $month = intval(date("m", $curTime));
    if ($last_year != $year || $last_month != $month)
    { //已经跨月了
        $curMonthTimes = 0;
    }
    if ($status != Up_AskDailyLogin_Status::vip)
    {
        $days = $curMonthTimes + 1;
    }
    else
    {
        $days = $curMonthTimes;
    }
    $dailyLoginRewards = DataModule::getInstance()->getDataSetting(DAILY_LOGIN_REWARD_KEY);
    $rewards = $dailyLoginRewards[$year][$month][$days];
    if (isset($rewards))
    {
        if ($rewards["Year"] != $year || $rewards["Month"] != $month || $rewards["Days"] != $days)
        { //Just verify.
            Logger::getLogger()->debug("OnDailyLogin:Return[1]");
            return $replyInfo;
        }
        $rewardType = $rewards["Reward Type"];
        if (isset($rewardType)) {
            $vip = VipModule::getVipLevel($userId);
            $vipDoubleLevel = $rewards["Double Reward VIP Level"];
            $rate = 1;
            if ($status == Up_AskDailyLogin_Status::common)
            { //普通
                $rate = 1;
            }
            else
            { //VIP签到
                if ($vipDoubleLevel > 0)
                {
                    if ($vip < $vipDoubleLevel) //VIP等级不符合
                    {
                        Logger::getLogger()->debug("OnDailyLogin:Return[2]");
                        return $replyInfo;
                    }
                    if ($status == Up_AskDailyLogin_Status::all)
                    {
                        $rate = 2;
                    }
                }

            }
            $rewardId = $rewards["Reward ID"];
            $amount = intval($rewards["Reward Amount"]) * $rate;
            if ($rewards["Reward Type"] == "Diamond")
            {
                PlayerModule::modifyGem($userId, $amount, "DailyLogin-" . $year . "-" . $month . "-" . $days);
                $replyInfo->setDiamond($amount);
            }
            if ($rewards["Reward Type"] == "Item")
            {
                ItemModule::addItem($userId, array($rewardId => $amount), "DailyLogin-" . $year . "-" . $month . "-" . $days);
                $arg_arr = array(11, $amount, 10, $rewardId);
                $replyInfo->appendItems(MathUtil::makeBits($arg_arr));
            }
            if ($rewards["Reward Type"] == "Hero")
            {
                for ($i = 0; $i < $amount; $i++)
                {
                    $ret = HeroModule::addPlayerHero($userId, $rewardId, "DailyLogin-" . $year . "-" . $month . "-" . $days);
                    if (is_array($ret))
                    {
                        foreach ($ret as $itemId => $count)
                        {
                            $arg_arr = array(11, $count, 10, $itemId);
                            $replyInfo->appendItems(MathUtil::makeBits($arg_arr));
                        }
                    }
                    else
                    {
                        $heroDownArr = HeroModule::getAllHeroDownInfo($userId, array($rewardId));
                        foreach ($heroDownArr as $heroDownMsg)
                        {
                            $replyInfo->appendHero($heroDownMsg);
                        }
                    }
                }
            }
            $replyInfo->setResult(Down_Result::success);
            if ($rate > 1 || $status == Up_AskDailyLogin_Status::vip || ($status == Up_AskDailyLogin_Status::common && $vipDoubleLevel == 0))
                $userDailyLoginInfo->setTodayClaimStatus(Down_DailyLogin_DailyloginStatus::all);
            else
                $userDailyLoginInfo->setTodayClaimStatus(Down_DailyLogin_DailyloginStatus::part);

            $userDailyLoginInfo->setCurMonthClaimTimes($days);
            $userDailyLoginInfo->setLastClaimTime(time());
            $userDailyLoginInfo->save();
        }
    }
    Logger::getLogger()->debug("OnDailyLogin:Return");
    return $replyInfo;
}
 