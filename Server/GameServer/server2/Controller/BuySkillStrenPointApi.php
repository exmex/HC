<?php
/**
 * @Author:      jaylu
 * @Date:        2015-01-21 
 * @Description: Description
 * @email:       jay@xxxx.com
 */
require_once($GLOBALS['GAME_ROOT'] . "Classes/SkillModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/ConsumeModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/VipModule.php");
define('BUY_SKILL_POINT_COUNT', 10);
/**
 * 重置技能强化点
 * @param [type] $userId [description]
 */
function BuySkillStrenPointApi($userId){
    Logger::getLogger()->debug("OnBuySkillStrenPoint process");
    $syncSkillStrenReply = new Down_SyncSkillStrenReply();
    $skillLevelUp = new Down_Skilllevelup();
    //vip限制,是否能购买
    $muduleState = VipModule::getVIPModuleLimitByUserId($userId, _VIP_MODULE_TYPE::SKILL_UPGRADE_CD_RESET);
    if (empty($muduleState)) {
        Logger::getLogger()->error("OnBuySkillStrenPoint no enough vip level");
        return null;
    }
    $objSkill = SkillModule::getSkillTable($userId);
    if (SQLUtil::isTimeNeedReset($objSkill->getLastBuyTime())) {
        $objSkill->setBuyTimes(0);
    }

    $todayResetTimes = $objSkill->getBuyTimes();
    $resetTimesKey = min($todayResetTimes + 1, 30);
    //如果已经用完了购买次数 、gem不够
    if (!ConsumeModule::doConsume($userId, CONSUME_TYPE_SKILL_UPGRADE_RESET, $resetTimesKey)) {
        $skillLevelUp->setSkillLevelupChance($objSkill->getPoint());
        $skillLevelUp->setLastResetDate($objSkill->getLastBuyTime());
        $skillLevelUp->setResetTimes($objSkill->getBuyTimes());
        $skillLevelUp->setSkillLevelupCd($objSkill->getLastAddTime());
        $syncSkillStrenReply->setSkillLevelUp($skillLevelUp);
        $objSkill->save();
        Logger::getLogger()->error("OnBuySkillStrenPoint no enough Times or gem" );
        return $syncSkillStrenReply;
    }

    $nowTime = time();
    //PlayerModule::modifyGem($userId, -$costGem);
    $objSkill->setBuyTimes($objSkill->getBuyTimes() + 1);
    $objSkill->setPoint($objSkill->getPoint() + BUY_SKILL_POINT_COUNT);
    $objSkill->setLastAddTime($nowTime);
    $objSkill->setLastBuyTime($nowTime);
    $objSkill->save();
    $skillLevelUp->setSkillLevelupChance($objSkill->getPoint());
    $skillLevelUp->setLastResetDate($objSkill->getLastBuyTime());
    $skillLevelUp->setResetTimes($objSkill->getBuyTimes());
    $skillLevelUp->setSkillLevelupCd($objSkill->getLastAddTime());
    $syncSkillStrenReply->setSkillLevelUp($skillLevelUp);
    return $syncSkillStrenReply;
}