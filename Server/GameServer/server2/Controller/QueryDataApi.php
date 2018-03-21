<?php
/**
 * @Author:      jaylu
 * @Date:        2015-01-21 
 * @Description: Description
 * @email:       jay@xxxx.com
 */
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/MathUtil.php");
/**
 * 查询玩家数据
 * @param WorldSvc     $svc     [description]
 * @param Up_QueryData $pPacket [description]
 */
function QueryDataApi(WorldSvc $svc, Up_QueryData $pPacket){
    $userId = $GLOBALS ['USER_ID'];
    Logger::getLogger()->debug("OnQueryData Process user id:{$userId}");
    $retReply = new Down_QueryDataReply();
    foreach ($pPacket->getType() as $queryType) {
        switch ($queryType) {
            case Up_QueryData_QueryType::rmb:
                $tbPlayer = PlayerModule::getPlayerTable($userId);
                $retReply->setRmb($tbPlayer->getGem());
                break;
            case Up_QueryData_QueryType::recharge:
                $retReply->setChargeSum(VipModule::getRechargeSum($userId));
                $rechargeLimitArr = VipModule::getRechargeLimitDownArr($userId);
                foreach ($rechargeLimitArr as $limitInfo) {
                    $retReply->appendRechargeLimit($limitInfo);
                }
                break;
            case Up_QueryData_QueryType::hero:
                $heroList = $pPacket->getQueryHeroes();
                $downHeroList = HeroModule::getAllHeroDownInfo($userId, $heroList);
                foreach ($downHeroList as $downHero) {
                    $retReply->appendHeroes($downHero);
                }
                break;
                //月卡
            case Up_QueryData_QueryType::monthcard:
                $cardIdArr = $pPacket->getMonthCardId();
                $monthCardArr = MonthCardModule::getMonthCardByIdArr($userId, $cardIdArr);
                foreach ($monthCardArr as $monthCard) {
                    $retReply->appendMonthCard($monthCard);
                }
                break;

            default:
                break;
        }
    }

    return $retReply;
}

function heroUpgradeProcess($userId, $heroTid){
    $heroList = HeroModule::getAllHeroTable($userId, array($heroTid));
    if (empty($heroList[$heroTid])) {
        Logger::getLogger()->error("heroUpgradeProcess not found hero heroTid = {$heroTid}");
        return null;
    }
    $objHero = $heroList[$heroTid];
    if ($objHero->getRank() >= ParamModule::GetHeroMaxRank()) {
        Logger::getLogger()->error("heroUpgradeProcess hero rank is max = {$objHero->getRank()}");
        return null;
    }
    $equipArr = HeroModule::getHeroEquipArr($objHero);
    $returnExp = 0;
    foreach ($equipArr as $oneEquip) {
        if ($oneEquip[0] <= 0) {
            Logger::getLogger()->error("heroUpgradeProcess hero equip not full!");
            return null;
        }
        $returnExp += ItemModule::getEquipReturnExp($oneEquip[0], $oneEquip[1]);
    }
    $reason = "HeroUpgrade:" . $heroTid;
    $retArr = ItemModule::getReturnExpItemArr($returnExp);
    ItemModule::addItem($userId, $retArr, $reason);
    $objHero->setRank($objHero->getRank() + 1);
    $objHero->setHeroEquip(HERO_INIT_EQUIP_LIST);
    $objHero->setGs(HeroModule::getHeroGs($userId, $heroTid, $objHero));
    $objHero->save();
    return $retArr;
}
