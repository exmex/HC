<?php

require_once($GLOBALS['GAME_ROOT'] . "Classes/DataModule.php");;

//  ["sync_vitality_gap"] = 360,
//	["default_normal_sweep_times"] = 10,
//	["default_elite_sweep_times"] = 3,
//	["pay_sweep_unit_price"] = 1,
//	["skill_level_up_chance_cd"] = 300,
//	["hero_max_star"] = 5,
//	["tavern_bronze_chance"] = 5,
//	["tavern_silver_chance"] = 1,
//	["tavern_gold_chance"] = 1,
//	["tavern_bronze_cd"] = 600,
//	["tavern_silver_cd"] = 86400,
//	["tavern_gold_cd"] = 172800,
//	["universal_fragment_id"] = 335,
//	["team_level_max"] = 80,
//	["sweep_coin_id"] = 390,
//	["stren_health_ratio"] = 19,
//	["join_excavate_hero_level_limit"] = 35,

class ParamModule
{
    public static function GetSyncVitalityGap()
    {
        $value = DataModule::lookupDataTable(PARAM_LUA_KEY, "sync_vitality_gap");
        return intval($value);
    }

    public static function GetDefaultNormalSweepTimes()
    {
        $value = DataModule::lookupDataTable(PARAM_LUA_KEY, "default_normal_sweep_times");
        return intval($value);
    }

    public static function GetDefaultEliteSweepTimes()
    {
        $value = DataModule::lookupDataTable(PARAM_LUA_KEY, "default_elite_sweep_times");
        return intval($value);
    }

    public static function GetPaySweepPrice()
    {
        $value = DataModule::lookupDataTable(PARAM_LUA_KEY, "pay_sweep_unit_price");
        return intval($value);
    }

    public static function GetSkillLevelUpChanceCd()
    {
        $value = DataModule::lookupDataTable(PARAM_LUA_KEY, "skill_level_up_chance_cd");
        return intval($value);
    }

    public static function GetHeroMaxStar()
    {
        $value = DataModule::lookupDataTable(PARAM_LUA_KEY, "hero_max_star");
        return intval($value);
    }

    public static function GetHeroMaxRank()
    {
        $value = DataModule::lookupDataTable(PARAM_LUA_KEY, "hero_max_rank");
        return intval($value);
    }

    public static function GetTavernBronzeChance()
    {
        $value = DataModule::lookupDataTable(PARAM_LUA_KEY, "tavern_bronze_chance");
        return intval($value);
    }

    public static function GetTavernSilverChance()
    {
        $value = DataModule::lookupDataTable(PARAM_LUA_KEY, "tavern_silver_chance");
        return intval($value);
    }

    public static function GetTavernGoldChance()
    {
        $value = DataModule::lookupDataTable(PARAM_LUA_KEY, "tavern_gold_chance");
        return intval($value);
    }

    public static function GetTavernMagicChance()
    {
        $value = DataModule::lookupDataTable(PARAM_LUA_KEY, "tavern_magic_chance");
        return intval($value);
    }

    public static function GetTavernBronzeCd()
    {
        $value = DataModule::lookupDataTable(PARAM_LUA_KEY, "tavern_bronze_cd");
        return intval($value);
    }

    public static function GetTavernSilverCd()
    {
        $value = DataModule::lookupDataTable(PARAM_LUA_KEY, "tavern_silver_cd");
        return intval($value);
    }

    public static function GetTavernGoldCd()
    {
        $value = DataModule::lookupDataTable(PARAM_LUA_KEY, "tavern_gold_cd");
        return intval($value);
    }

    public static function GetTavernMagicCd()
    {
        $value = DataModule::lookupDataTable(PARAM_LUA_KEY, "tavern_magic_cd");
        return intval($value);
    }

    public static function GetTavernMagicMonthSoulId()
    {
        $value = DataModule::lookupDataTable(PARAM_LUA_KEY, "tavern_magic_month_soul_id");
        return intval($value);
    }

    public static function GetUniversalFragmentId()
    {
        $value = DataModule::lookupDataTable(PARAM_LUA_KEY, "universal_fragment_id");
        return intval($value);
    }

    public static function GetTeamLevelMax()
    {
        $value = DataModule::lookupDataTable(PARAM_LUA_KEY, "team_level_max");
        return intval($value);
    }

    public static function GetSweepCoinId()
    {
        $value = DataModule::lookupDataTable(PARAM_LUA_KEY, "sweep_coin_id");
        return intval($value);
    }

    public static function GetStrenHealthRatio()
    {
        $value = DataModule::lookupDataTable(PARAM_LUA_KEY, "stren_health_ratio");
        return intval($value);
    }

    public static function GetJoinExcavateHeroLevelLimit()
    {
        $value = DataModule::lookupDataTable(PARAM_LUA_KEY, "join_excavate_hero_level_limit");
        return intval($value);
    }

}
