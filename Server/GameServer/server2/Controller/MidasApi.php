<?php
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/ConsumeModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/TaskModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/VipModule.php");

/**
 *使用点金手
 */
/** @var Down_MidasReply $reply */
function MidasApi($userId,$times)
{
    $reply = new Down_MidasReply();
    $sysPlayer = PlayerModule::getPlayerTable($userId);
    if (empty($sysPlayer)) {
        Logger::getLogger()->error("MidasApi: No find player!");
        return $reply;
    }

    $playerLevel = $sysPlayer->getLevel();
    $isOpen = PlayerModule::checkFuncOpen($playerLevel, "Midas");
    if (!$isOpen) {
        Logger::getLogger()->error("MidasApi: Function not enough!");
        return $reply;
    }

    $canMidasTimes = VipModule::getVIPModuleLimitByUserId($userId, _VIP_MODULE_TYPE::MIDAS);
    $DataModule = DataModule::getInstance();
    $plt = $DataModule->getDataSetting(PLAYER_LEVEL_LUA_KEY);
    $mt = $DataModule->getDataSetting(PLAYER_MIDAS_LUA_KEY);

    for($index = 0;$index < $times;$index++){
        $midasAcquire = useMidas($userId,$sysPlayer,$canMidasTimes,$plt,$mt);
       if (isset($midasAcquire)){
           $reply->appendAcquire($midasAcquire);
       }
    }
    $sysPlayer->save();
    return $reply;
}
/** @var sysPlayer $sysPlayer */
function useMidas($userId,$sysPlayer,$canMidasTimes,$plt,$mt)
{
    Logger::getLogger()->debug("MidasApi process");
    $midas_reply = new Down_MidasAcquire();

    //1、检查当天点金次数
    if (SQLUtil::isTimeNeedReset($sysPlayer->getLastMidasTime())) {
        //清空点金次数
        $sysPlayer->setTodayMidasTimes(0);
    }
    $userTimes = $sysPlayer->getTodayMidasTimes();
    //调用vip相关功能接口 （获取vip 特权点金次数）
    if ($userTimes >= $canMidasTimes) {
        Logger::getLogger()->error("MidasApi: VIP not enough!");
        //次数不足
        return null;
    }

    //2、检查功能是否开放   PlayerModule::checkFuncOpen($playerLevel, "Midas");
    //3、扣除当前点金gem

    if (!ConsumeModule::doConsume($userId, CONSUME_TYPE_MIDAS, $sysPlayer->getTodayMidasTimes() + 1)) {
        Logger::getLogger()->error("User Id :{$userId}  MidasApi: ConsumeModule::doConsume() failed ");
        return null;
    }

    $midasseting = $mt[$userTimes + 1];
    $yd = 0;
    $midasType = 1;
    $randNumber = mt_rand(1, 100);
    if ($randNumber <= $midasseting["Prob 1"] * 100) {
        $yd = $midasseting["Yield 1"];
        $midasType = 1;
    } else if ($randNumber <= ($midasseting["Prob 2"] + $midasseting["Prob 1"]) * 100) {
        $yd = $midasseting["Yield 2"];
        $midasType = 2;
    } else if ($randNumber <= ($midasseting["Prob 3"] + $midasseting["Prob 2"] + $midasseting["Prob 1"]) * 100) {
        $yd = $midasseting["Yield 3"];
        $midasType = 3;
    } else if ($randNumber <= ($midasseting["Prob 4"] + $midasseting["Prob 3"] + $midasseting["Prob 2"] + $midasseting["Prob 1"]) * 100) {
        $yd = $midasseting["Yield 4"];
        $midasType = 4;
    }
    $money = $plt[$sysPlayer->getLevel()]["Midas Money"] * $yd;

    $addCoin =floor($money);
    //4、增加金币
    PlayerModule::modifyMoney($userId, $addCoin, "Use Midas");
    $sysPlayer->setTodayMidasTimes($userTimes + 1);
    $sysPlayer->setLastMidasTime(time());

    $midas_reply->setMoney($addCoin);
    $midas_reply->setType($midasType);
    TaskModule::updateDailyTaskProgress($userId, DAILY_TASK_MIDAS_USE);
    return $midas_reply;
}

