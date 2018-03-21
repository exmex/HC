<?php
/**
 * @Author:      jaylu
 * @Date:        2015-01-20 
 * @Description: Description
 * @email:       jay@xxxx.com
 */
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");

/**
 * 英雄进化功能
 * @param WorldSvc      $svc     [description]
 * @param Up_HeroEvolve $pPacket [description]
 */
function heroEvolveApi(WorldSvc $svc, Up_HeroEvolve $pPacket){
    $userId = $GLOBALS ['USER_ID'];
    Logger::getLogger()->debug("OnHeroEvolve Process user id:" . $userId . " heroTid:" . $pPacket->getHeroid());
    $ret = heroEvolveProcess($userId, $pPacket);
    $retReply = new Down_HeroEvolveReply();
    if ($ret) {
        $retReply->setResult(Down_Result::success);
        $heroInfoArr = HeroModule::getAllHeroDownInfo($userId, array($pPacket->getHeroid()));
        foreach ($heroInfoArr as $heroInfo) {
            $retReply->setHero($heroInfo);
            break;
        }
    } else {
        $retReply->setResult(Down_Result::fail);
    }
    return $retReply;
}

function heroEvolveProcess($userId, Up_HeroEvolve $pPacket){
    $heroTid = $pPacket->getHeroid();
    $needChipTid = DataModule::lookupDataTable(FRAGMENT_LUA_KEY, "Fragment ID", array($heroTid));
    $maxStar = ParamModule::GetHeroMaxStar();
    $isSummon = false;
    $heroList = HeroModule::getAllHeroTable($userId, array($heroTid));
    $reason = "OnHeroEvolve:" . $heroTid;
    if (empty($heroList[$heroTid])) {
        $isSummon = true;
        $initStar = DataModule::lookupDataTable(HERO_UNIT_LUA_KEY, "Initial Stars", array($heroTid));
        if ($initStar > $maxStar) {
            Logger::getLogger()->error("heroEvolveProcess hero init star over band:heroTid = {$heroTid},init star = {$initStar}");
            return false;
        }
        $costMoney = DataModule::lookupDataTable(HERO_STAR_LUA_KEY, "Summon Price", array($initStar));
        $needChipAmount = DataModule::lookupDataTable(HERO_STAR_LUA_KEY, "Summon Fragments", array($initStar));
        $reason = "OnHeroSummon:" . $heroTid;
    } else {
        /** @var TbPlayerHero $oneHero */
        $oneHero = $heroList[$heroTid];
        $nextStar = $oneHero->getStars() + 1;
        if ($nextStar > $maxStar) {
            Logger::getLogger()->error("heroEvolveProcess hero cur star is max:heroTid = {$heroTid}");
            return false;
        }
        $costMoney = DataModule::lookupDataTable(HERO_STAR_LUA_KEY, "Upgrade Price", array($nextStar));
        $needChipAmount = DataModule::lookupDataTable(HERO_STAR_LUA_KEY, "Upgrade Fragments", array($nextStar));
    }
    $tbPlayer = PlayerModule::getPlayerTable($userId);
    if ($tbPlayer->getMoney() < $costMoney) {
        Logger::getLogger()->error("heroEvolveProcess money not enough" . $tbPlayer->getMoney());
        return false;
    }
    $subRet = ItemModule::subItem($userId, array($needChipTid => $needChipAmount), $reason);
    if (!$subRet) {
        return false;
    }
    PlayerModule::modifyMoney($userId, -$costMoney, $reason);
    if ($isSummon) {
        HeroModule::addPlayerHero($userId, $heroTid, $reason);
    } else {
        $oneHero = $heroList[$heroTid];
        $oneHero->setStars($oneHero->getStars() + 1);
        $oneHero->setGs(HeroModule::getHeroGs($userId, $heroTid, $oneHero));
        $oneHero->save();
        LogAction::getInstance()->log('DISCIPLE_PROMOTE', array(
        		'heroId'		=> $heroTid,
        		'stage'			=> $oneHero->getStars() - 1,
        		'stageAfter'	=> $oneHero->getStars(),
        		'gs'			=> $oneHero->getGs()
        	)
        );
    }

    return true;
}