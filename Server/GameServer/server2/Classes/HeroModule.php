<?php

require_once($GLOBALS['GAME_ROOT'] . "Classes/ItemModule.php");
require_once($GLOBALS['GAME_ROOT'] . "Classes/DataModule.php");;
require_once($GLOBALS['GAME_ROOT'] . "Classes/SkillModule.php");
require_once($GLOBALS['GAME_ROOT'] . "DbModule/SysPlayerHero.php");

define("HERO_INIT_EQUIP_LIST", "0-0|0-0|0-0|0-0|0-0|0-0");

class HeroModule{
    private static $HeroTableCached = array();
    private static $attrib_names = array(
        "STR",
        "INT",
        "AGI",
        "HP",
        "MP",
        "AD",
        "AP",
        "ARM",
        "MR",
        "CRIT",
        "MCRIT",
        "HPS",
        "MPS",
        "HIT",
        "DODG",
        "ARMP",
        "MRI",
        "LFS",
        "CDR",
        "HEAL",
        "HPR",
        "MPR",
        "HAST",
        "MSPD",
        "PDM",
        "TDM",
        "PIMU",
        "MIMU"
    );

    private static $attrib_trans = array(
        "STR" => array("HP" => 18, "ARM" => 0.15),
        "INT" => array("AP" => 2.4, "MR" => 0.1),
        "AGI" => array("AD" => 0.4, "CRIT" => 0.4, "ARM" => 0.08));

    private static $attrib_gs = array(
        "STR" => 0,
        "INT" => 0,
        "AGI" => 0,
        "HP" => 4,
        "MP" => 0,
        "AD" => 60,
        "AP" => 30,
        "ARM" => 200,
        "MR" => 200,
        "CRIT" => 125,
        "MCRIT" => 125,
        "HPS" => 6,
        "MPS" => 15,
        "DODG" => 100,
        "HIT" => 100,
        "ARMP" => 200,
        "MRI" => 200,
        "LFS" => 60,
        "CDR" => 125,
        "HEAL" => 160
    );

    private static $monster_attribs = array(
        "HP",
        "AD",
        "AP",
        "ARM",
        "MR",
        "CRIT",
        "MCRIT"
    );

    public static function addPlayerHero($userId, $tid, $reason = ""){
        $heroUnitLua = DataModule::lookupDataTable(HERO_UNIT_LUA_KEY, null, array($tid));
        $initStar = isset($heroUnitLua['Initial Stars']) ? $heroUnitLua['Initial Stars'] : 1;
        
        $sysHero = new SysPlayerHero();
        $sysHero->setUserId($userId);
        $sysHero->setTid($tid);
        if ($sysHero->LoadedExistFields()) {
            // 已存在此英雄 则给灵魂石
            $soulNum = DataModule::lookupDataTable(HERO_STAR_LUA_KEY, "Convert Fragments", array($initStar));
            $needChipTid = DataModule::lookupDataTable(FRAGMENT_LUA_KEY, "Fragment ID", array($tid));
            $addItemArr = array($needChipTid => $soulNum);
            ItemModule::addItem($userId, $addItemArr, $reason);
            return $addItemArr;
        }
        $sysHero->setLevel(1);
        $sysHero->setExp(0);
        $initRank = isset($heroUnitLua["Initial Rank"]) ? $heroUnitLua["Initial Rank"] : 1;
        $sysHero->setRank($initRank);
        $sysHero->setStars($initStar);
        $sysHero->setState(Down_HeroStatus::idle);
        $skillGroup = DataModule::getInstance()->lookupDataTable(SKILL_GROUP_LUA_KEY, null, array($tid));
        if (isset($skillGroup)) {
            $sysHero->setSkill1Level(intval($skillGroup[1]["Init Level"]));
            $sysHero->setSkill2Level(intval($skillGroup[2]["Init Level"]));
            $sysHero->setSkill3Level(intval($skillGroup[3]["Init Level"]));
            $sysHero->setSkill4Level(intval($skillGroup[4]["Init Level"]));
        }

        $sysHero->setHeroEquip(HERO_INIT_EQUIP_LIST);
        $sysHero->setGs(self::getHeroGs($userId, $tid, $sysHero));
        $sysHero->inOrUp();
        LogClient::getInstance()->logAddHero($userId, $reason, $tid, $initRank, $initStar);
        self::$HeroTableCached[$userId] = array();
        self::$HeroTableCached[$userId][$sysHero->getTid()] = $sysHero;
        return true;
    }

    public static function getAllHeroTable($userId, $heroTidArr = null){
        if (empty(self::$HeroTableCached[$userId])) {
            self::$HeroTableCached[$userId] = array();
        }
        $where = "`user_id` = '{$userId}'";
        if (isset($heroTidArr)) {
            //去掉前端传过来的heroid在数据库中的
            foreach ($heroTidArr as $i => $value) {
                if (isset(self::$HeroTableCached[$userId][$value])) {
                    unset($heroTidArr[$i]);
                }
            }
            if (count($heroTidArr) <= 0) {
                return self::$HeroTableCached[$userId];
            }
            $heroTidArr = array_values($heroTidArr);
            if (count($heroTidArr) == 1) {
                $heroTid = $heroTidArr[0];
                $where .= " and `tid` = '{$heroTid}'";
            } else {
                $heroTidStr = implode(',', $heroTidArr);
                $where .= " and `tid` in ({$heroTidStr})";
            }
        } else {
            if (count(self::$HeroTableCached[$userId]) > 0) {
                return self::$HeroTableCached[$userId];
            }
        }
        $heroTb = SysPlayerHero::loadedTable(null, $where);
        //没有英雄时初始化英雄
        if (count($heroTb) <= 0) { 
            if (empty($heroTidArr)) { 
                self::addPlayerHero($userId, 1, "INIT PLAYER"); 
            }
            return self::$HeroTableCached[$userId];
        }
        
        foreach ($heroTb as $hero) {
            self::$HeroTableCached[$userId][$hero->getTid()] = $hero;
        }
        return self::$HeroTableCached[$userId];
    }

    /**
     * 返回英雄数据
     * @param  [type] $userId    [description]
     * @param  [type] $heroIdArr [description]
     * @return [type]            [description]
     */
    public static function getAllHeroDownInfo($userId, $heroIdArr = null){
        $allHeroInfo = self::getAllHeroTable($userId, $heroIdArr);
        $downHeroArr = array();
        /** @var TbPlayerHero $tbHero */
        foreach ($allHeroInfo as $hero) {
            if (isset($heroIdArr) && !in_array($hero->getTid(), $heroIdArr)) {
                continue;
            }
            $downHero = new Down_Hero();
            $downHero->setTid($hero->getTid());
            $downHero->setRank($hero->getRank());
            $downHero->setLevel($hero->getLevel());
            $downHero->setStars($hero->getStars());
            $downHero->setExp($hero->getExp());
            $downHero->setGs($hero->getGs());
            $downHero->setState($hero->getState());
            $downHero->appendSkillLevels($hero->getSkill1Level());
            $downHero->appendSkillLevels($hero->getSkill2Level());
            $downHero->appendSkillLevels($hero->getSkill3Level());
            $downHero->appendSkillLevels($hero->getSkill4Level());
            $equipArr = self::getHeroEquipArr($hero);
            for($i = 1; $i <= 6; $i++){
                $downEquip = new Down_HeroEquip();
                $downEquip->setIndex($i);
                $downEquip->setItemId($equipArr[$i][0]);
                $downEquip->setExp($equipArr[$i][1]);
                $downHero->appendItems($downEquip);
            }
            $downHeroArr[] = $downHero;
        }
        return $downHeroArr;
    }

    public static function getHeroEquipArr(SysPlayerHero $sysHero){
        $retArr = array();
        $equipArr = explode("|", $sysHero->getHeroEquip());
        for($i = 1; $i <= 6; $i++){
            $retArr[$i] = array(0, 0);
            if (isset($equipArr[$i - 1])) {
                $oneEquipInfo = explode("-", $equipArr[$i - 1]);
                if (count($oneEquipInfo) >= 2) {
                    $retArr[$i][0] = intval($oneEquipInfo[0]);
                    $retArr[$i][1] = intval($oneEquipInfo[1]);
                }
            }
        }
        return $retArr;
    }

    public static function getHeroEquipStr($equipArr){
        $retStr = HERO_INIT_EQUIP_LIST;
        if (count($equipArr) == 6) {
            $equipStrArr = array();
            foreach ($equipArr as $oneEquipArr) {
                if (is_array($oneEquipArr) && count($oneEquipArr) >= 2) {
                    $equipStrArr[] = implode("-", $oneEquipArr);
                } else {
                    $equipStrArr[] = "0-0";
                }
            }
            $retStr = implode("|", $equipStrArr);
        }
        return $retStr;
    }

    /**
     * 修改英雄的经验值
     * @param  [type] $userId [description]
     * @param  [type] $tidArr [description]
     * @param  [type] $exp    [description]
     * @param  string $reason [description]
     * @return [type]         [description]
     */
    public static function modifyHeroExp($userId, $tidArr, $exp, $reason = ""){
        if ($exp <= 0) {
            return;
        }
        $where = "`user_id` = '{$userId}'";
        $heroArr = array_values($tidArr);
        if (count($heroArr) == 1) {
            $heroId = $heroArr[0];
            $where .= " and `tid` = '{$heroId}'";
        } else {
            $heroIdStr = implode(',', $heroArr);
            $where .= " and `tid` in ({$heroIdStr})";
        }

        $heroTables = SysPlayerHero::loadedTable(null, $where);
        $oneAddExp = floor($exp / max(1, count($heroTables)));
        foreach ($heroTables as $hero) {
            self::modifyOneHeroExp($hero, $oneAddExp, $reason);
        }
    }

    /**
     * 修改单个英雄的经验
     * @param  SysPlayerHero $hero   [description]
     * @param  [type]        $exp    [description]
     * @param  string        $reason [description]
     * @return [type]                [description]
     */
    public static function modifyOneHeroExp(SysPlayerHero $hero, $exp, $reason = ""){
        if (empty($hero)) {
            return false;
        }
        $playerLv = PlayerCacheModule::getPlayerLevel($hero->getUserId());
        $maxHeroLv = floor(DataModule::lookupDataTable(PLAYER_LEVEL_LUA_KEY, "Max Hero Level", array($playerLv)));
        $beforeExp = $hero->getExp();
        $after = $exp + $hero->getExp();
        LogClient::getInstance()->logHeroExpChanged($hero->getUserId(), $reason, $hero->getTid(), $hero->getExp(), $after);
        $curLv = $hero->getLevel();
        $beforeLv = $curLv;
        while (true) {
            $levelUpExp = floor(DataModule::lookupDataTable(HERO_LEVEL_LUA_KEY, "Exp", array($curLv)));
            if ($levelUpExp == 0) {
                break;
            }
            if ($after >= $levelUpExp) {
                if ($curLv < $maxHeroLv) {
                    $after -= $levelUpExp;
                    $curLv++;
                } else {
                    $after = $levelUpExp;
                    break;
                }
            } else {
                break;
            }
        }
        if ($curLv >= $maxHeroLv) {
            $curLv = $maxHeroLv;
            $levelUpExp = floor(DataModule::lookupDataTable(HERO_LEVEL_LUA_KEY, "Exp", array($maxHeroLv)));
            if ($after >= $levelUpExp) {
                $after = $levelUpExp;
            }
        }
        $hero->setLevel($curLv);
        $hero->setExp($after);
        if ($beforeLv != $curLv) {
            $hero->setGs(self::getHeroGs($hero->getUserId(), $hero->getTid(), $hero));
        }
        $hero->save();
        if ($curLv == $beforeLv && $beforeExp == $after) {
            return false;
        }
        return true;
    }

    /**
     * [英雄的武力]
     * @param  [type]            $userId  [description]
     * @param  [type]            $heroTid [description]
     * @param  SysPlayerHero     $hero    [description]
     * @param  boolean           $isBot   [description]
     * @return [type]                     [description]
     */
    public static function getHeroGs($userId, $heroTid, SysPlayerHero $hero = null, $isBot = false){
        if (empty($hero)) {
            $heroList = self::getAllHeroTable($userId, array($heroTid));
            if (empty($heroList[$heroTid])) {
                return 0;
            }
            $hero = $heroList[$heroTid];
        }
        $level = $hero->getLevel();
        $rank = $hero->getRank();
        $star = $hero->getStars();
        $ratio = 0;
        $estimate_rank = $isBot;
        if ($estimate_rank) {
            $rank = floor(($level + 9) / 10);
            $ratio = ($level - 1) % 10 / 10;
        }
        
        $unitInfo = DataModule::lookupDataTable(HERO_UNIT_LUA_KEY, null, array($heroTid));
        $rankInfo = DataModule::lookupDataTable(HERO_RANK_LUA_KEY, null, array($heroTid, $rank));
        $nextRankInfo = DataModule::lookupDataTable(HERO_RANK_LUA_KEY, null, array($heroTid, ($rank + 1)));
        if (empty($nextRankInfo)) {
            $nextRankInfo = $rankInfo;
        }
        $attribs = array();
        $orig = array();
        foreach (self::$attrib_names as $attrName){
            $growth = 0;
            $key = "+" . $attrName . $star;
            if (isset($unitInfo[$key])) {
                $growth = $unitInfo[$key];
            }
            $value = 0;
            if (isset($unitInfo[$attrName])) {
                $value = $unitInfo[$attrName];
            }
            $value += $growth * $level;
            $field = $attrName;
            if ($estimate_rank) {
                $field = "E." . $attrName;
            }
            $rankValue = 0;
            if (isset($rankInfo[$field])) {
                $rankValue = $rankInfo[$field];
            }

            $nextValue = 0;
            if (isset($nextRankInfo[$field])) {
                $nextValue = $nextRankInfo[$field];
            }

            $value += $rankValue * (1 - $ratio) + $nextValue * $ratio;
            $attribs[$attrName] = $value;
            $orig[$attrName] = $value;
        }
        $attribs["PDM"] = 1;
        $attribs["TDM"] = 1;
        if (($star > 1) && $unitInfo["Unit Type"] == "Monster") {
            foreach (self::$monster_attribs as $monsterAttrName) {
                $value = $attribs[$monsterAttrName];
                $value *= (0.875 + 0.125 * $star);
                $attribs[$monsterAttrName] = $value;
                $orig[$monsterAttrName] = $value;
            }
        }
        $DataModule = DataModule::getInstance();
        $equipDataSettings = $DataModule->getDataSetting(ITEM_LUA_KEY);
        $equipList = self::getHeroEquipArr($hero);
        foreach ($equipList as $equip) {
            if ($equip[0] > 0) {
                $equipLv = ItemModule::getEquipCurLv($equip[0], $equip[1]);
                foreach (self::$attrib_names as $attrName) {
                    $equipData = $equipDataSettings[$equip[0]];
                    if (isset($equipData)) {
                        $value = 0;
                        if (isset($equipData[$attrName])) {
                            $value = $equipData[$attrName];
                        }
                        if (isset($equipData["+" . $attrName])) {
                            $value += $equipData["+" . $attrName] * $equipLv;
                        }
                        $attribs[$attrName] += $value;
                    }
                }
            }
        }
        $skillList = SkillModule::getHeroSkillInfoList($hero, $isBot);
        foreach ($skillList as $skillGroupInfo) {
            $skillInfo = $skillGroupInfo["Skill"];
            if (($skillInfo["Active Type"] == "passive") || ($skillInfo["Active Type"] == "aura")) {
                $aName = $skillInfo["Passive Attr"];
                $aCount = $skillInfo["Basic Num"];
                $attribs[$aName] += $aCount;
            }
        }
        foreach (self::$attrib_trans as $attr1 => $group) {
            $value1 = $attribs[$attr1];
            $value2 = $orig[$attr1];
            foreach ($group as $attr2 => $ratio) {
                $attribs[$attr2] += $value1 * $ratio;
                $orig[$attr2] += $value2 * $ratio;
            }
        }
        if (isset($unitInfo["Main Attrib"])) {
            $main = $unitInfo["Main Attrib"];
            $attribs["AD"] += $attribs[$main];
            $orig["AD"] += $orig[$main];
        }
        $gs = 0;
        foreach (self::$attrib_gs as $attrib => $value) {
            $gs += $attribs[$attrib] * $value;
        }

        $gs = floor($gs / 100);
        foreach ($skillList as $skillGroupInfo) {
            $groupInfo = $skillGroupInfo["Group"];
            $slot = intval($groupInfo["Slot"]);
            $skillLv = $hero->getLevel();
            if (!$isBot) {
                $skillLvFunc = "getSkill{$slot}Level";
                $skillLv = $hero->$skillLvFunc();
            }
            $addGs = intval($skillLv * intval($groupInfo["Levelup GS"]));
            $gs += $addGs;
        }
        return $gs;
    }

    /**
     * [从灵魂石ID获取对应的武将tid]
     * @param  [type] $soulId [description]
     * @return [type]         [description]
     */
    public static function getHeroTidFromSoulId($soulId){
        $heroTid = 0;
        $DataModule= DataModule::getInstance();
        $allItemTable = $DataModule->getDataSetting(FRAGMENT_LUA_KEY);
        foreach ($allItemTable as $defineArr) {
            if ($defineArr['Fragment ID'] == $soulId) {
                $heroTid = $defineArr['Item ID'];
            }
        }
        return $heroTid;
    }


    /**
     * [根据武将tid获取对应所需的灵魂石ID]
     * @param  [type] $heroTid [description]
     * @return [type]          [description]
     */
    public static function getSoulIdFromHeroTid($heroTid){
        $soulId = DataModule::lookupDataTable(FRAGMENT_LUA_KEY, "Fragment ID", array($heroTid));
        return $soulId;
    }

}















