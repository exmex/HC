<?php

require_once($GLOBALS['GAME_ROOT'] . "Classes/DataModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/MailModule.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerActivity.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerMail.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerVip.php");

/**
 * User: jay
 * Date: 14-7-25
 * 
 */
class DailyActivityModule
{

    /**
     * 判断是否需要发放充值活动的奖励
     *
     * 活动改为即时发放
     */
    public static function payActivityInstance($userId)
    {
        $payActivity = DataModule::lookupDataTable(DAILY_ACTIVITY_LUA_KEY, "pay");
        $today = date("Ymd");
        if (!isset($payActivity['rule']) || !isset($payActivity['rule'][$today])) {
            return; //当前没有开启的日充值活动
        }

        $todayBeginTime = strtotime($today);
        $mailArr = $payActivity['mail'];

        $maxClaimed = 0; //今日已经领取过的最大累计金额定义
        $claimedArr = array();

        //todo:当前可奖励的礼包 今天是否已经领取过
        $tbPlayerVip = new SysPlayerVip();
        $tbPlayerVip->setUserId($userId);
        if ($tbPlayerVip->loaded()) {
            if ($tbPlayerVip->getActivityDay() == $today) {
                if (strlen($tbPlayerVip->getActivityDesc()) > 0) {
                    $getDescArr_ = explode(";", $tbPlayerVip->getActivityDesc());
                    foreach ($getDescArr_ as $rM_) {
                        $claimedArr[$rM_] = $rM_;
                    }

                    $maxClaimed = max($getDescArr_);
                }
            } else {
                $tbPlayerVip->setActivityDesc("");
            }
        }

        //获取还可以领取的活动
        $ruleArr = array();
        ksort($payActivity['rule']);
        foreach ($payActivity['rule'] as $day_ => $defineDayArr_) {
            ksort($defineDayArr_);
            foreach ($defineDayArr_ as $defineArr_) {
                if ($defineArr_['limit']['pay money'] <= $maxClaimed) {
                    continue;
                }

                $newItemArr_ = $defineArr_['reward'];
                if (isset($ruleArr[$day_]) && count($ruleArr[$day_]) > 0) {
                    $addArr_ = end($ruleArr[$day_]);
                    foreach ($addArr_ as $tt => $vvv) {
                        if (isset($newItemArr_[$tt])) {
                            if (is_array($vvv)) {
                                foreach ($vvv as $mm => $cc) {
                                    if (isset($newItemArr_[$tt][$mm])) {
                                        $newItemArr_[$tt][$mm] += $cc;
                                    } else {
                                        $newItemArr_[$tt][$mm] = $cc;
                                    }
                                }
                            } else {
                                $newItemArr_[$tt] += $vvv;
                            }
                        } else {
                            $newItemArr_[$tt] = $vvv;
                        }
                    }
                }

                //物品进行叠加获得
                $ruleArr[$day_][$defineArr_['limit']['pay money']] = $newItemArr_;
            }
        }

        if (empty($ruleArr)) {
            Logger::getLogger()->debug("payActivityInstance all rule claimed, userId:{$userId}, l:" . __LINE__);
            return;
        }

        if (!isset($ruleArr[$today]) || empty($ruleArr[$today])) {
            Logger::getLogger()->debug("payActivityInstance all rule claimed, userId:{$userId}, l:" . __LINE__);
            return;
        }

        /*print_r($ruleArr);
        exit;*/


        $sql = "select P.receiver_id, sum(P.pay_money) as total from pay_info as P where P.receiver_id = '{$userId}' and P.order_state = 1 and P.pay_time >='{$todayBeginTime}' ";
        /*print_r($sql);
        exit;*/
        $rs = MySQL::getInstance()->RunQuery($sql);
        $payArr = $userIdTempArr = $ar = MySQL::getInstance()->FetchArray($rs);
        if (empty($payArr) || count($payArr) <= 0) {
            return;
        }

        if (!isset($payArr['total']) || empty($payArr['total'])) {
            return;
        }

        $userRewardsArr = array();
        //分析并合并奖励数值

        $giveArr_ = array();
        $giveRuleKey = 0;
        foreach ($ruleArr[$today] as $mo_ => $g_) {
            if ($payArr['total'] < $mo_) {
                break;
            }
            $giveRuleKey = $mo_;
            $giveArr_ = $g_;
        }

        if (empty($giveArr_)) {
            Logger::getLogger()->debug("payActivityInstance nu rule can claim, userId:{$userId}, l:" . __LINE__);
            return;
        }

        if (isset($claimedArr[$giveRuleKey])) {
            Logger::getLogger()->debug("payActivityInstance curr rule claimed, userId:{$userId}, l:" . __LINE__);
            return;
        }

        $userRewardsArr['money'] = 0;
        if (isset($giveArr_['money']) && $giveArr_['money'] > 0) {
            $userRewardsArr['money'] = $giveArr_['money'];
        }

        $userRewardsArr['gem'] = 0;
        if (isset($giveArr_['gem']) && $giveArr_['gem'] > 0) {
            $userRewardsArr['gem'] = $giveArr_['gem'];
        }

        $userRewardsArr['items'] = "";
        if (isset($giveArr_['items']) && is_array($giveArr_['items']) && count($giveArr_['items']) > 0) {
            $itemStr = "";

            if (isset($userRewardsArr['items'])) {
                $itArr_ = explode(";", $userRewardsArr['items']);
                foreach ($itArr_ as $iteStr_) {
                    if (strlen($iteStr_) > 1) {
                        $gItemArr_ = explode(":", $iteStr_);
                        if (isset($giveArr_['items'][$gItemArr_[0]])) {
                            $giveArr_['items'][$gItemArr_[0]] += $gItemArr_[1];
                        } else {
                            $giveArr_['items'][$gItemArr_[0]] = $gItemArr_[1];
                        }
                    }
                }
            }

            foreach ($giveArr_['items'] as $key => $vv) {
                $itemStr .= "{$key}:{$vv};";
            }
            $userRewardsArr['items'] = $itemStr;
        }

        $mailStr = "Dear Leader,

Here are your rewards for purchasing gems.";

        MailModule::sendPlainMail($userId,
            "Ember",
            "Purchasing Rewards",
            $mailStr,
            $userRewardsArr['money'],
            $userRewardsArr['gem'],
            "",
            $userRewardsArr['items']
        );

        /*$now = time();
        $mail = new SysPlayerMail();
        $mail->setUserId($userId);
        $expireTime = $now + 3600 * 24 * 15;
        $mail->setMailTime($now);
        $mail->setExpireTime($expireTime);
        if (isset($userRewardsArr['money']) && $userRewardsArr['money'] > 0) {
            $mail->setMoney($userRewardsArr['money']);
        }

        if (isset($userRewardsArr['gem']) && $userRewardsArr['gem'] > 0) {
            $mail->setDiamonds($userRewardsArr['gem']);
        }

        if (isset($userRewardsArr['items'])) {
            $mail->setItems($userRewardsArr['items']);
        }

        $mail->setTemplate(2);
        $mail->setStatus(0);
        $mail->inOrUp();*/

        $claimedArr[$giveRuleKey] = $giveRuleKey;
        $tbPlayerVip->setActivityDay($today);
        $tbPlayerVip->setActivityDesc(implode(";", $claimedArr));
        $tbPlayerVip->save();

    }

    /**
     * 判断是否需要发放充值活动的奖励
     *
     * 活动后一天发放
     */
    public static function payActivity($timeZoneId)
    {
        return; //20140829活动改为即时发放,此方法屏蔽
        $payActivity = DataModule::lookupDataTable(DAILY_ACTIVITY_LUA_KEY, "pay");
        $today = date("Ymd");
        if (isset($payActivity['rewards day']) && $payActivity['rewards day'] != $today) {
            return; //todo:测试
        }

        $mailArr = $payActivity['mail'];
        $beginTime = strtotime($payActivity['begin day']);
        $endTime = strtotime($payActivity['end day']) + 24 * 3600;

        $minMoney = 9999999;
        $ruleArr = array();
        ksort($payActivity['rule']);
        foreach ($payActivity['rule'] as $day_ => $defineDayArr_) {
            ksort($defineDayArr_);
            foreach ($defineDayArr_ as $defineArr_) {
                if ($defineArr_['limit']['pay money'] < $minMoney) {
                    $minMoney = $defineArr_['limit']['pay money'];
                }

                $newItemArr_ = $defineArr_['reward'];
                if (isset($ruleArr[$day_]) && count($ruleArr[$day_]) > 0) {
                    $addArr_ = end($ruleArr[$day_]);
                    foreach ($addArr_ as $tt => $vvv) {
                        if (isset($newItemArr_[$tt])) {
                            if (is_array($vvv)) {
                                foreach ($vvv as $mm => $cc) {
                                    if (isset($newItemArr_[$tt][$mm])) {
                                        $newItemArr_[$tt][$mm] += $cc;
                                    } else {
                                        $newItemArr_[$tt][$mm] = $cc;
                                    }
                                }
                            } else {
                                $newItemArr_[$tt] += $vvv;
                            }
                        } else {
                            $newItemArr_[$tt] = $vvv;
                        }
                    }
                }
                //物品进行叠加获得
                $ruleArr[$day_][$defineArr_['limit']['pay money']] = $newItemArr_;
            }
        }

        /*print_r($ruleArr);
        exit;*/

        $beginUserId = 0;
        $sql = "";
        $userIdTempArr = array();
        $userIdArr = array();
        $lastUserId_ = 0;
        $now = time();
        $give_ = array();

        while (true) {
            //DATE_FORMAT(DATE_ADD(20140325, INTERVAL 0 DAY), '%Y%m%d')
            $sql = "select P.receiver_id, DATE_FORMAT(DATE_ADD({$payActivity['begin day']}, INTERVAL floor((P.pay_time-$beginTime)/(24 * 3600)) DAY), '%Y%m%d') as dayIndex, sum(P.pay_money) as total from user as U, user_server as S, pay_info as P where U.uin = S.uin and S.user_id = P.receiver_id and P.receiver_id > '{$beginUserId}' and U.user_zone_id = '{$timeZoneId}' and P.order_state = 1 and P.pay_time >='{$beginTime}' and P.pay_time <'{$endTime}' group by P.receiver_id asc,dayIndex asc having total >= '{$minMoney}' limit 500 ";
            /*print_r($sql);
            exit;*/
            $rs = MySQL::getInstance()->RunQuery($sql);
            $userIdArr = $userIdTempArr = MySQL::getInstance()->FetchAllRows($rs);
            if (empty($userIdTempArr) || count($userIdTempArr) <= 0) {
                break;
            }

            if (count($userIdTempArr) == 500) { //全取满的情况下,清理掉最后一个用户的数据,防止处理不全
                $lastRowArr_ = end($userIdTempArr);
                $lastUserId_ = $lastRowArr_['receiver_id'];
                foreach ($userIdTempArr as $kkk_ => $row_) {
                    if ($row_['receiver_id'] == $lastUserId_) {
                        unset($userIdArr[$kkk_]);
                    }
                }

                if (count($userIdArr) == 0) {
                    $userIdArr = $userIdTempArr;
                }
            }

            $userRewardsArr = array();
            if (count($userIdArr) > 0) {

                //分析并合并奖励数值
                foreach ($userIdArr as $r_) {
                    $beginUserId = $r_['receiver_id'];

                    if (!isset($ruleArr[$r_['dayIndex']])) { //当天日期没有充值活动
                        continue;
                    }

                    $give_ = array();
                    foreach ($ruleArr[$r_['dayIndex']] as $mo_ => $give_) {
                        if ($r_['total'] < $mo_) {
                            break;
                        }
                    }

                    if (isset($give_['money']) && $give_['money'] > 0) {
                        if (isset($userRewardsArr[$r_['receiver_id']]) && isset($userRewardsArr[$r_['receiver_id']]['money'])) {
                            $userRewardsArr[$r_['receiver_id']]['money'] += $give_['money'];
                        } else {
                            $userRewardsArr[$r_['receiver_id']]['money'] = $give_['money'];
                        }
                    }

                    if (isset($give_['gem']) && $give_['gem'] > 0) {
                        if (isset($userRewardsArr[$r_['receiver_id']]) && isset($userRewardsArr[$r_['receiver_id']]['gem'])) {
                            $userRewardsArr[$r_['receiver_id']]['gem'] += $give_['gem'];
                        } else {
                            $userRewardsArr[$r_['receiver_id']]['gem'] = $give_['gem'];
                        }
                    }

                    if (isset($give_['items']) && is_array($give_['items']) && count($give_['items']) > 0) {
                        $itemStr = "";

                        if (isset($userRewardsArr[$r_['receiver_id']]) && isset($userRewardsArr[$r_['receiver_id']]['items'])) {
                            $itArr_ = explode(";", $userRewardsArr[$r_['receiver_id']]['items']);
                            foreach ($itArr_ as $iteStr_) {
                                if (strlen($iteStr_) > 1) {
                                    $gItemArr_ = explode(":", $iteStr_);
                                    if (isset($give_['items'][$gItemArr_[0]])) {
                                        $give_['items'][$gItemArr_[0]] += $gItemArr_[1];
                                    } else {
                                        $give_['items'][$gItemArr_[0]] = $gItemArr_[1];
                                    }
                                }
                            }
                        }

                        foreach ($give_['items'] as $key => $vv) {
                            $itemStr .= "{$key}:{$vv};";
                        }
                        $userRewardsArr[$r_['receiver_id']]['items'] = $itemStr;
                    }
                }


                $batch = new SQLBatch();
                $insertArr = array('user_id', 'mail_time', 'expire_time', 'money', 'diamonds', 'items', 'status', 'template');
                $batch->init(SysPlayerMail::insertSqlHeader($insertArr));

                foreach ($userRewardsArr as $userId_ => $gg_) {
                    $mail = new SysPlayerMail();
                    $mail->setUserId($userId_);
                    $expireTime = $now + 3600 * 24 * 15;
                    $mail->setMailTime($now);
                    $mail->setExpireTime($expireTime);
                    if (isset($gg_['money']) && $gg_['money'] > 0) {
                        $mail->setMoney($gg_['money']);
                    }

                    if (isset($gg_['gem']) && $gg_['gem'] > 0) {
                        $mail->setDiamonds($gg_['gem']);
                    }

                    if (isset($gg_['items'])) {
                        $mail->setItems($gg_['items']);
                    }

                    $mail->setTemplate(2);
                    $mail->setStatus(0);
                    $batch->add($mail);
                }

                $batch->end();
                $batch->save();
            }
        }
    }

    /**
     * 返回当前时段的掉落倍数和排除队列
     */
    public static function lootActivity()
    {
        $lootActivity = DataModule::lookupDataTable(DAILY_ACTIVITY_LUA_KEY, "loot");
        $curGameTime = SQLUtil::gameNow();
        $curDay = date("Ymd", $curGameTime);
        $curHour = date("H", $curGameTime);

        $actDay = $lootActivity["day"];
        $actHour = $lootActivity["hour"];

        $multiple = 1;
        $exclude = array();
        $include = array();
        if (isset($actDay[$curDay]) && (count($actHour) <= 0 || isset($actHour[$curHour]))) {
            $multiple = intval($lootActivity["multiple"]);
            $exclude = $lootActivity["exclude"];
            $include = $lootActivity["include"];
        }

        return array($multiple, $exclude, $include);
    }

    /**
     * 登录活动
     */
    public static function loginActivity()
    {
        $curGameTime = SQLUtil::gameNow();
        $curDay = date("Ymd", $curGameTime);
        $loginActivity = DataModule::lookupDataTable(DAILY_ACTIVITY_LUA_KEY, "login");
        if (isset($loginActivity[$curDay])) {
            $mailContent = $loginActivity[$curDay];

            $money = 0;
            $items = array();
            foreach ($mailContent as $v) {
                switch ($v['type']) {
                    case 'money':
                        $money += intval($v['nums']);
                        break;
                    case 'item':
                        $items[] = $v['id'] . ":" . $v['nums'];
                        break;
                }
            }
            if (($money <= 0) && empty($items)) {
                return false;
            }

            return array(
                "money" => $money,
                "items" => implode(";", $items)
            );
        }
        return false;
    }

    /**
     * 开放试炼活动
     * @param $time 时间戳, 没有参数，则默认使用gameNow时间
     * @return true:在活动时间,false:不在时间内
     */
    public static function hasOpenExerciseActivity($time = null)
    {
        $time = empty($time) ? SQLUtil::gameNow() : $time;

        $activities = DataModule::lookupDataTable(DAILY_ACTIVITY_LUA_KEY, "open_all_exercise");
        $dayKey = date("Ymd", $time);

        if (!empty($activities) && isset($activities[$dayKey]) && $activities[$dayKey] == 1) {
            return true;
        }
        return false;
    }


    /**
     * 登录奖励活动
     * @param $userId
     */
    public static function checkLoginActivity($userId)
    {
        $userLv = PlayerCacheModule::getPlayerLevel($userId);
        if ($userLv < 10) {
            return;
        }
        $loginActivity = DailyActivityModule::loginActivity();
        if (!$loginActivity) {
            return;
        }

        $activityInfo = new SysPlayerActivity();
        $activityInfo->setUserId($userId);
        $hasInit = $activityInfo->loaded();
        $lastLoginTime = 0;
        if ($hasInit) {
            $lastLoginTime = $activityInfo->getLastLoginRewardTime();
        }

        $newDay = SQLUtil::isTimeNeedReset($lastLoginTime);
        if ($newDay) {
            Logger::getLogger()->debug("checkLoginActivity, a new day, last_time={$lastLoginTime}");

            $money = 0;
            if (isset($loginActivity['money'])) {
                $money = intval($loginActivity['money']);
            }
            $diamond = 0;
            if (isset($loginActivity['diamonds'])) {
                $diamond = intval($loginActivity['diamonds']);
            }
            $items = "";
            if (isset($loginActivity['items'])) {
                $items = strval($loginActivity['items']);
            }

            $mailStr = "Dear Leader,

Here are your Soul Stones of Shallows Keeper for today's login.";

            MailModule::sendPlainMail($userId,
                "Ember",
                "Login Rewards",
                $mailStr,
                $money,
                $diamond,
                "",
                $items,
                SQLUtil::getDiffNextGameReset()
            );

            $activityInfo->setLastLoginRewardTime(time());
            if ($hasInit) {
                $activityInfo->save();
            } else {
                $activityInfo->inOrUp();
            }
        }
    }

    /**
     * 商店打折活动
     */
    public static function checkSaleActivity()
    {
        $time = empty($time) ? SQLUtil::gameNow() : $time;

        $activities = DataModule::lookupDataTable(DAILY_ACTIVITY_LUA_KEY, "shop_sale");
        $dayKey = date("Ymd", $time);

        $hour = date("H", $time);

        if (!empty($activities) && isset($activities[$dayKey])) {
            $area = explode('-', $activities[$dayKey]);
            if ($hour >= intval($area[0]) and $hour < intval($area[1])) {
                return true;
            }
        }
        return false;
    }

    /**
     * 首充赠送gems活动
     *
     * @param $userId
     */
    public static function firstPayActivity($userId, $package)
    {
        $payActivity = DataModule::lookupDataTable(DAILY_ACTIVITY_LUA_KEY, "first_pay");
        $today = date("Ymd");
        if (!isset($payActivity[$today])) {
            return; //当前没有开启的日充值活动
        }

        $tbPlayerVip = new SysPlayerVip();
        $tbPlayerVip->setUserId($userId);
        if ($tbPlayerVip->loaded() && $tbPlayerVip->getRecharge() > $package['VIP Exp']) {
            return;
        }

        //发送奖励
        $mailStr = "Dear Leader,

Here are the bonus gems in your first time purchase.

Best Regards
";

        MailModule::sendPlainMail($userId,
            "Ember",
            "First Time Purchase Bonus",
            $mailStr,
            0,
            $package['VIP Exp'],
            "",
            ""
        );

    }

    
}
 