<?php

require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerSkill.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/VipModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/ParamModule.php");

class SkillModule
{
    public static function getMaxSkillPoint($userId)
    {
        return VipModule::getVIPModuleLimitByUserId($userId, _VIP_MODULE_TYPE::MAX_SKILL_POINTS);
    }

    public static function getSkillTable($userId)
    {
        $MAX_SKILL_POINT = self::getMaxSkillPoint($userId);

        $nowTime = time();
        $tbSkill = new SysPlayerSkill();

        $tbSkill->setUserId($userId);
        if ($tbSkill->loaded()) {
            $currentPoint = $tbSkill->getPoint();
            if ($currentPoint < $MAX_SKILL_POINT) {
                $addSkillPointInterval = ParamModule::GetSkillLevelUpChanceCd();
                $nowPoint = floor(($nowTime - $tbSkill->getLastAddTime()) / $addSkillPointInterval) + $currentPoint;
                if ($nowPoint != $currentPoint) {
                    $tbSkill->setPoint(min($MAX_SKILL_POINT, $nowPoint));
                    $tbSkill->setLastAddTime($tbSkill->getLastAddTime() + ($nowPoint - $currentPoint) * $addSkillPointInterval);
                    $tbSkill->save();
                }
            } else {
                $tbSkill->setLastAddTime($nowTime);
                $tbSkill->save();
            }
        } else {
            $tbSkill->setPoint($MAX_SKILL_POINT);
            $tbSkill->setLastAddTime($nowTime);
            $tbSkill->setBuyTimes(0);
            $tbSkill->setLastBuyTime(0);
            $tbSkill->inOrUp();

        }
        return $tbSkill;
    }

    public static function getSkillDownInfo($userId)
    {
        $tbSkill = self::getSkillTable($userId);
        $downSkillInfo = new Down_Skilllevelup();
        $downSkillInfo->setSkillLevelupChance($tbSkill->getPoint());
        $downSkillInfo->setSkillLevelupCd($tbSkill->getLastAddTime());
        $downSkillInfo->setResetTimes($tbSkill->getBuyTimes());
        $downSkillInfo->setLastResetDate($tbSkill->getLastBuyTime());
        return $downSkillInfo;
    }

    public static function getHeroSkillInfoList(SysPlayerHero $tbHero, $isBot)
    {
        $retArr = array();

        $skillGroup = DataModule::getInstance()->lookupDataTable(SKILL_GROUP_LUA_KEY, null, array($tbHero->getTid()));
        if (empty($skillGroup)) {
            return $retArr;
        }

        $rank = $tbHero->getRank();
        if ($isBot) {
            $rank = floor(($tbHero->getLevel() + 9) / 10);
        }

        for ($i = 1; $i <= 4; $i++) {
            if (empty($skillGroup[$i])) {
                continue;
            }
            $groupInfo = $skillGroup[$i];
            if ($rank >= intval($groupInfo["Unlock"])) {
                $skillLv = 0;
                if ($isBot) {
                    $skillLv = $tbHero->getLevel();
                } else {
                    $getLevelFunc = "getSkill{$i}Level";
                    $skillLv = $tbHero->$getLevelFunc();
                }
                $retArr[] = self::getSkillLuaInfo($groupInfo, $skillLv);
            }
        }

        return $retArr;
    }

    public static function getSkillLuaInfo($group, $skillLv)
    {
        $retArr = array();

        $retArr["Group"] = $group;
        $skillLuaInfo = DataModule::getInstance()->lookupDataTable(SKILL_INFO_LUA_KEY, null, array($group["Skill Group ID"], 0));
        $buffLuaInfo = DataModule::getInstance()->lookupDataTable(BUFF_LUA_KEY, null, array($skillLuaInfo["Buff ID"]));

        for ($i = 1; $i <= 2; $i++) {
            if (isset($group["Growth " . $i . " Field"])) {
                $field = $group["Growth " . $i . " Field"];
                $growth = ($skillLv - 1) * $group["Growth " . $i . " Value"];
                if (isset($skillLuaInfo[$field])) {
                    $skillLuaInfo[$field] += $growth;
                } elseif (isset($buffLuaInfo[$field])) {
                    $buffLuaInfo[$field] += $growth;
                }
            }

        }

        $retArr["Skill"] = $skillLuaInfo;
        $retArr["Buff"] = $buffLuaInfo;

        return $retArr;
    }
}