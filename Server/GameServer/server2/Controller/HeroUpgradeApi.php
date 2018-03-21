<?php
/**
 * author jay
 *
 * date  2015-01-12
 */
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/MathUtil.php");

/**
 * 英雄进阶
 * @param WorldSvc       $svc     [description]
 * @param Up_HeroUpgrade $pPacket [description]
 */
function heroUpgradeApi(WorldSvc $svc, Up_HeroUpgrade $pPacket){
    $userId = $GLOBALS ['USER_ID'];
    $heroTid = $pPacket->getHeroId();
    Logger::getLogger()->debug("OnHeroUpgrade Process user id:{$userId}, heroTid:{$heroTid}");
    $retArr = heroUpgradeProcess($userId, $heroTid);
    $retReply = new Down_HeroUpgradeReply();
    if (isset($retArr)) {
        $retReply->setResult(Down_Result::success);
        $heroInfoArr = HeroModule::getAllHeroDownInfo($userId, array($heroTid));
        foreach ($heroInfoArr as $heroInfo) {
            $retReply->setHero($heroInfo);
            break;
        }
        foreach ($retArr as $itemId=>$count) {
            $arg_arr = array(11, $count, 10, $itemId);
            $retReply->appendItems(MathUtil::makeBits($arg_arr));
        }
    } else {
        $retReply->setResult(Down_Result::fail);
    }
    return $retReply;
}
/**
 * 英雄进阶逻辑
 * @param  [type] $userId  [description]
 * @param  [type] $heroTid [description]
 * @return [type]          [description]
 */
function heroUpgradeProcess($userId, $heroTid){
    $heroList = HeroModule::getAllHeroTable($userId, array($heroTid));
    if (empty($heroList[$heroTid])) {
        Logger::getLogger()->error("heroUpgradeProcess not found hero heroTid = {$heroTid}");
        return null;
    }

    $hero = $heroList[$heroTid];
    if ($hero->getRank() >= ParamModule::GetHeroMaxRank()) {
        Logger::getLogger()->error("heroUpgradeProcess hero rank is max = {$hero->getRank()}");
        return null;
    }
    $equipArr = HeroModule::getHeroEquipArr($hero);
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

    $hero->setRank($hero->getRank() + 1);
    $hero->setHeroEquip(HERO_INIT_EQUIP_LIST);
    $hero->setGs(HeroModule::getHeroGs($userId, $heroTid, $hero));
    $hero->save();

    //行为日志
    LogAction::getInstance()->log('DISCIPLE_ENHENCE', array(
    		'heroId'		=> $heroTid,
    		'quality'		=> $hero->getRank() - 1,
    		'qualityAfter'	=> $hero->getRank(),
    		'level'			=> $hero->getLevel()
   		)
    );
    
    return $retArr;
}
