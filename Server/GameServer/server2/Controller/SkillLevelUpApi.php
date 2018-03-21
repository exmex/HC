<?php
require_once($GLOBALS["GAME_ROOT"] . "Classes/SkillModule.php");
require_once($GLOBALS["GAME_ROOT"] . "Classes/DataModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/TaskModule.php");

function SkillLevelUpApi($userId, $heroId, $order)
{
    $skillLevelUpReply = new Down_SkillLevelupReply();
    $skillLevelUpReply->setResult(Down_Result::fail);
    $skillLevelUpReply->setGs(0);

    $heroArr = HeroModule::getAllHeroTable($userId, array($heroId));
    /** @var SysPlayerHero $hero */
    $hero = $heroArr[$heroId];

    if (empty($hero)) {
        return $skillLevelUpReply;
    }
	$DataModule=DataModule::getInstance();
    $sysSkill = SkillModule::getSkillTable($userId);
    $rank = $hero->getRank();
    $skillGroup = $DataModule->getDataSetting(SKILL_GROUP_LUA_KEY);
    $heroSkillGroup = $skillGroup[$heroId];
    $tbPlayer = PlayerModule::getPlayerTable($userId);

    /** @var array $skillPrice */
    $skillPrice = $DataModule->getDataSetting(SKILL_LEVEL_PRICE_LUA_KEY);
    foreach($order as $orderid){
        $slot = MathUtil::bits($orderid, 0, 4);
        $amount = MathUtil::bits($orderid, 4, 11);
        if (($slot < 1) || ($slot > 4)) {
            return $skillLevelUpReply;
        }
        //技能点不足
        if ($sysSkill->getPoint() < $amount) {
            Logger::getLogger()->error("SkillLevelUpApi not enough skill point!");
            return $skillLevelUpReply;
        }

        $getLevelFunc = "getSkill{$slot}Level";
        $skillLv = $hero->$getLevelFunc();
        //技能等级超出上限
        if ($hero->getLevel() < ($skillLv + $amount)) {
            Logger::getLogger()->error("SkillLevelUpApi Not exceed hero level!");
            return $skillLevelUpReply;
        }

        $unlockRank = $heroSkillGroup[$slot]["Unlock"];
        if ($rank < $unlockRank) {
            Logger::getLogger()->error("SkillLevelUpApi this skill not unlock!");
            return $skillLevelUpReply;
        }

        for($index= 0; $index <$amount; $index++){
            $price = $skillPrice[$skillLv+$index]["Price"];
            if ($tbPlayer->getMoney() < $price) {
                Logger::getLogger()->error("SkillLevelUpApi not enough money!");
                return $skillLevelUpReply;
            }
            PlayerModule::modifyMoney($userId, -$price, "SkillLevelUpApi:{$heroId}-{$slot}");
            TaskModule::updateDailyTaskProgress($userId, DAILY_TASK_SKILL_UPGRADE_SUCCESS);
        }
        $sysSkill->setPoint($sysSkill->getPoint() - $amount);
        $setLevelFunc = "setSkill{$slot}Level";
        $hero->$setLevelFunc($skillLv + $amount);
        $heroGs = HeroModule::getHeroGs($userId, $heroId, $hero);
        $hero->setGs($heroGs);
    }

    $hero->save();
    $sysSkill->save();
    $skillLevelUpReply->setResult(Down_Result::success);
    $skillLevelUpReply->setGs($hero->getGs());
    return $skillLevelUpReply;

}