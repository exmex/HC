<?php
/**
 * 远征
 */
require_once($GLOBALS['GAME_ROOT'] . "Classes/TbcModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/TaskModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/TavernBoxModule.php");
function TbcApi($userId, Up_Tbc $pPacket)
{
    Logger::getLogger()->debug("TbcApi Process");
    $reply = new Down_TbcReply();
    //optional tbc_open_panel _open_panel     = 1
    $openPanel = $pPacket->getOpenPanel();
    if (isset($openPanel)) {
        $openPanelReply = TbcOpenPanelApi($userId);
        if (isset($openPanelReply)) {
            $reply->setOpenPanel($openPanelReply);
        }
    }

    //optional tbc_query_oppo _query_oppo     = 2
    $queryOppo = $pPacket->getQueryOppo();
    if (isset($queryOppo)) {
        $queryOppoReply = TbcQueryOppoApi($userId, $queryOppo);
        if (isset($queryOppoReply)) {
            $reply->setQueryOppo($queryOppoReply);
        }
    }

    //optional tbc_start_battle _start_bat    = 3
    $startBat = $pPacket->getStartBat();
    if (isset($startBat)) {
        $startBatReply = TbcStartBattleApi($userId, $startBat);
        if (isset($startBatReply)) {
            $reply->setStartBat($startBatReply);
        }
    }

    //optional tbc_end_battle _end_bat        = 4
    $endBat = $pPacket->getEndBat();
    if (isset($endBat)) {
        $endBatReply = TbcEndBattleApi($userId, $endBat);
        if (isset($endBatReply)) {
            $reply->setEndBat($endBatReply);
        }
    }

    //optional tbc_reset _reset               = 5
    $reset = $pPacket->getReset();
    if (isset($reset)) {
        $resetReply = TbcResetApi($userId, $reset);
        if (isset($resetReply)) {
            $reply->setReset($resetReply);
        }
    }

    //optional tbc_draw_reward _draw_reward   = 6
    $reward = $pPacket->getDrawReward();
    if (isset($reward)) {
        $rewardReply = TbcDrawRewardApi($userId, $reward);
        if (isset($rewardReply)) {
            $reply->setDrawReward($rewardReply);
        }
    }

    Logger::getLogger()->debug("OnTbcReply!");
    return $reply;
}



function TbcOpenPanelApi($userId)
{
    Logger::getLogger()->debug("OnTbcOpenPanel Process");

    $reply = new Down_TbcOpenPanel();
    $tbc = TbcModule::getTbcInfo($userId);
    $reply->setInfo($tbc);
    return $reply;
}

function TbcStartBattleApi($userId, Up_TbcStartBattle $startBt)
{
    Logger::getLogger()->debug("OnTbcStartBattle Process");

    $reply = new Down_TbcStartBattle();
    $reply->setResult(Down_Result::fail);
    $reply->setRseed(0);

    $tbcSys = TbcModule::getPlayerTbcTable($userId);
    if (!isset($tbcSys)) {
        return $reply;
    }

    $myHeroList = $startBt->getHeroids();
    //效验Hero是否还活着
    $myHerosDyna = json_decode($tbcSys->getSelfHeros(), true);
    foreach ($myHeroList as $heroId) {
        if ($myHerosDyna[$heroId]) {
            if ($myHerosDyna[$heroId][0] <= 0) {
                Logger::getLogger()->debug("OnTbcStartBattle err" . __LINE__);
                return $reply;
            }
        } else {
            //初始化新heroDyna数据
            $myHerosDyna[$heroId] = array();
            $myHerosDyna[$heroId][0] = 10000;
            $myHerosDyna[$heroId][1] = 0;
            $myHerosDyna[$heroId][2] = 0;
        }
    }
    //处理雇佣英雄
    if ($startBt->getUseHire() == 1) {
        $hire = TbcModule::getMyHireHero($userId, $tbcSys->getLastResetTime());
        if (isset($hire)) {
            $heroId = $hire->getHireHeroTid();
            if ($myHerosDyna[$heroId]) {
                if ($myHerosDyna[$heroId][0] <= 0) {
                    Logger::getLogger()->debug("OnTbcStartBattle err" . __LINE__);
                    return $reply;
                }
            } else {
                //初始化新heroDyna数据
                $myHerosDyna[$heroId] = array();
                $myHerosDyna[$heroId][0] = 10000;
                $myHerosDyna[$heroId][1] = 0;
                $myHerosDyna[$heroId][2] = 0;
            }
            $tbcSys->setHireHeros($heroId);
        } else
            $tbcSys->setHireHeros("");
    } else {
        $tbcSys->setHireHeros("");
    }
    $tbcSys->setSelfHeros(json_encode($myHerosDyna));

    //设置随机数
    $SeedRand = mt_rand(1, 999);
    $tbcSys->setRandSeed($SeedRand);
    $tbcSys->save();
    $reply->setRseed($SeedRand);
    $reply->setResult(Down_Result::success);

    return $reply;
}
function TbcQueryOppoApi($userId, Up_TbcQueryOppo $query)
{
	$stageId = $query->getStageId();
	Logger::getLogger()->debug("OnTbcQueryOppo Process:" .$userId."|||". $stageId);
	$reply = TbcModule::getOppo($userId, $stageId);
	return $reply;
}


function TbcEndBattleApi($userId, Up_TbcEndBattle $endBattle)
{
    Logger::getLogger()->debug("OnEndBattle Process");

    $reply = new Down_TbcEndBattle();
    $reply->setResult(Down_Result::fail);

    $tbcSys = TbcModule::getPlayerTbcTable($userId);
    if (!isset($tbcSys)) {
        return $reply;
    }

    $curStage = $tbcSys->getCurStage();
    $selfHeros = $endBattle->getSelfHeroes();
    $oppoHeros = $endBattle->getOppoHeroes();
    $endBattle->getOprations();
    $endBattle->getResult();
    //模拟战斗计算
    //效验结果数据

    //效验Hero是否还活着
    $selfHerosDyna = json_decode($tbcSys->getSelfHeros(), true);
    foreach ($selfHeros as $hero) {
        if ($selfHerosDyna[$hero->getHeroid()]) {
            $selfHerosDyna[$hero->getHeroid()][0] = $hero->getHpPerc();
            $selfHerosDyna[$hero->getHeroid()][1] = $hero->getMpPerc();
            $selfHerosDyna[$hero->getHeroid()][2] = $hero->getCustomData();
        }
    }
    $tbcSys->setSelfHeros(json_encode($selfHerosDyna));

    $allOppos = json_decode($tbcSys->getOppoHeros(), true);
    foreach ($oppoHeros as $hero) {
        if ($allOppos[$curStage - 1][1][$hero->getHeroid()]) {
            $allOppos[$curStage - 1][1][$hero->getHeroid()][0] = $hero->getHpPerc();
            $allOppos[$curStage - 1][1][$hero->getHeroid()][1] = $hero->getMpPerc();
            $allOppos[$curStage - 1][1][$hero->getHeroid()][2] = $hero->getCustomData();
        }
    }
    $tbcSys->setOppoHeros(json_encode($allOppos));

    $tbcStages = TbcModule::getStagesFromString($tbcSys->getStages());
    $tbcStage = $tbcStages[$curStage - 1];
    if ($endBattle->getResult() == Up_BattleResult::victory) { //胜利才更新关卡进度
        $tbcStage->setStatus(Down_TbcStage_Status::passed);
        $tbcSys->setStages(json_encode($tbcStages));

        if ($curStage == 15) {
            $curStage = 0;
        } else {
            $curStage++;
        }
        $tbcSys->setCurStage($curStage);
        $reply->setResult(Down_Result::success);

        TaskModule::updateDailyTaskProgress($userId, DAILY_TASK_COMPLETE_CRUSADE_STAGE);
    }
    $tbcSys->save();
    return $reply;
}


function TbcDrawRewardApi($userId, Up_TbcDrawReward $pPacket)
{
    $reply = new Down_TbcDrawReward();
    $reply->setResult(Down_Result::fail);
    $stageId = $pPacket->getStageId();
    $reply->setStageId($stageId);
    $tbcSys = TbcModule::getPlayerTbcTable($userId);
    if (!isset($tbcSys)) {
        return $reply;
    }

    $reset = $tbcSys->getResetTimes() > 1 ? 0 : 1;
    if ($tbcSys->getCurStage() > 0) {
        if ($stageId != $tbcSys->getCurStage() - 1) {
            return $reply;
        }
    } else if ($stageId != 15) {
        return $reply;
    }

    $tbcStages = TbcModule::getStagesFromString($tbcSys->getStages());
    $tbcStage = $tbcStages[$stageId - 1];
    if($tbcStage->getStatus() != Down_TbcStage_Status::passed)
    {
        return $reply;
    }
    $it = $tbcStage->getRewardsIterator();
    while ($it->valid()) {
        if ($it->current()->getType() == Down_TbcReward_Type::chestbox) {
            $boxId = $it->current()->getParam1();
            //TODO:在这里进行开箱子的逻辑
            $item = TavernBoxModule::openChestBox($boxId, $reset);
            $id = intval($item["id"]);
            $amout = intval($item["amout"]);
            if ($item["type"] == "item") {
                if ($amout > 0) {
                    $reward = new Down_TbcReward();
                    $reward->setType(Down_TbcReward_Type::item);
                    $reward->setParam1($id);
                    $reward->setParam2($amout);
                    $item_arr[$id] = $amout;
                    $reply->appendRewards($reward);
                    ItemModule::addItem($userId, array($id => $amout), "TbcStage:" . $stageId);
                }
            }
            if ($item["type"] == "hero") {
                $ret = HeroModule::addPlayerHero($userId, $id, "TbcStage:" . $stageId);
                if (is_array($ret)) {
                    foreach ($ret as $itemId => $count) {
                        $reward = new Down_TbcReward();
                        $reward->setType(Down_TbcReward_Type::item);
                        $reward->setParam1($itemId);
                        $reward->setParam2($count);
                        $item_arr[$itemId] = $count;
                        $reply->appendRewards($reward);
                    }
                } else {
                    $heroDownArr = HeroModule::getAllHeroDownInfo($userId, array($id));
                    foreach ($heroDownArr as $heroDownMsg) {
                        $reward = new Down_TbcReward();
                        $reward->setType(Down_TbcReward_Type::item);
                        $reward->setParam1($id);
                        $reward->setParam2(1);
                        $item_arr[$id] = 1;
                        $reply->appendRewards($reward);
                        $reply->appendHeroes($heroDownMsg);
                    }
                }
            }

        } else if ($it->current()->getType() == Down_TbcReward_Type::crusadepoint) {
            if ($it->current()->getParam1() > 0) {
                PlayerModule::modifyCrusadePoint($userId, $it->current()->getParam1(), "TbcStage:" . $stageId);
                $reply->appendRewards($it->current());
            }
        } else if ($it->current()->getType() == Down_TbcReward_Type::gold) {
            if ($it->current()->getParam1() > 0) {
                PlayerModule::modifyMoney($userId, $it->current()->getParam1(), "TbcStage:" . $stageId);
                $reply->appendRewards($it->current());
            }
        }
        $it->next();
    }
    $tbcStages[$stageId - 1]->setStatus(Down_TbcStage_Status::rewarded);
    $tbcSys->setStages(json_encode($tbcStages));
    $tbcSys->save();
    $reply->setResult(Down_Result::success);

    //TODO:
    //$reply->appendHeroes();
    return $reply;
}
function TbcResetApi($userId, Up_TbcReset $pPacket)
{
	$reply = new Down_TbcReset();
	$tbc = TbcModule::getTbcInfo($userId, true);
	$reply->setResult(Down_Result::success);
	$reply->setInfo($tbc);
	return $reply;
}
