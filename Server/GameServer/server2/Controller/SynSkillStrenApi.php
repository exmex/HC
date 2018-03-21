<?php

require_once($GLOBALS['GAME_ROOT'] . "Classes/SkillModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/PlayerModule.php");
/**
 * 主动查询技能点
 * @param [type] $userId [description]
 */
function SynSkillStrenApi($userId){
    Logger::getLogger()->debug("OnSynSkillStren process");
    $syncSkillStrenReply = new Down_SyncSkillStrenReply();
    $skillLevelUp = new Down_Skilllevelup();
    $userSkill = SkillModule::getSkillTable($userId);
    $skillLevelUp->setSkillLevelupChance($userSkill->getPoint());
    $skillLevelUp->setLastResetDate($userSkill->getLastBuyTime());
    $skillLevelUp->setResetTimes($userSkill->getBuyTimes());
    $skillLevelUp->setSkillLevelupCd($userSkill->getLastAddTime());
    $syncSkillStrenReply->setSkillLevelUp($skillLevelUp);
    return $syncSkillStrenReply;
}