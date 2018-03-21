<?php

require_once($GLOBALS['GAME_ROOT'] . "CMemcache.php");

define('CONFIG_LUA_PATH', $GLOBALS ['GAME_ROOT'] . "Config/");

define('PARAM_LUA_KEY', 'PARAM_LUA_KEY');
define('ROBOT_LUA_KEY', 'ROBOT_LUA_KEY');
define('STAGE_LUA_KEY', 'STAGE_LUA_KEY');
define('STAGE_GROUP_LUA_KEY', 'STAGE_GROUP_LUA_KEY');
define('BATTLE_LUA_KEY', 'BATTLE_LUA_KEY');
define('WORLD_LOOT_LUA_KEY', 'WORLD_LOOT_LUA_KEY');
define('HERO_UNIT_LUA_KEY', 'HERO_UNIT_LUA_KEY');
define('HERO_RANK_LUA_KEY', 'HERO_RANK_LUA_KEY');
define('PLAYER_LEVEL_LUA_KEY', 'PLAYER_LEVEL_LUA_KEY');
define('HERO_LEVEL_LUA_KEY', 'HERO_LEVEL_LUA_KEY');
define('HERO_EQUIP_LUA_KEY', 'HERO_EQUIP_LUA_KEY');
define('HERO_STAR_LUA_KEY', 'HERO_STAR_LUA_KEY');
define('ITEM_LUA_KEY', 'ITEM_LUA_KEY');
define('FRAGMENT_LUA_KEY', 'FRAGMENT_LUA_KEY');
define('ENHANCE_LUA_KEY', 'ENHANCE_LUA_KEY');
define('VIP_LUA_KEY', 'VIP_LUA_KEY');
define('GRADIENT_PRICE_LUA_KEY', 'GRADIENT_PRICE_LUA_KEY');
define('AVATAR_LUA_KEY', 'AVATAR_LUA_KEY');
define('ITEM_GROUPS_LUA_KEY', 'ITEM_GROUPS_LUA_KEY');
define('SHOP_LUA_KEY', 'SHOP_LUA_KEY');
define('SKILL_INFO_LUA_KEY', 'SKILL_INFO_LUA_KEY');
define('SKILL_GROUP_LUA_KEY', 'SKILL_GROUP_LUA_KEY');
define('SKILL_LEVEL_PRICE_LUA_KEY', 'SKILL_LEVEL_PRICE_LUA_KEY');
define('BUFF_LUA_KEY', 'BUFF_LUA_KEY');
define('TAVERN_TYPE_KEY', 'TAVERN_TYPE_KEY');
define('EQUIP_CRAFT_KEY', 'EQUIP_CRAFT_KEY');
define('TRIGGERS_LUA_KEY', 'TRIGGERS_LUA_KEY');
define('TASK_LUA_KEY', 'TASK_LUA_KEY');
define('DAILY_LOGIN_REWARD_KEY', 'DAILY_LOGIN_REWARD_KEY');
define('TODO_LIST_LUA_KEY', 'TODO_LIST_LUA_KEY');
define('TODO_TRIGGERS_LUA_KEY', 'TODO_TRIGGERS_LUA_KEY');

define('PVP_ENEMY_LUA_KEY', 'PVP_ENEMY_LUA_KEY');
define('PVP_BEST_RANK_REWARD_LUA_KEY', 'PVP_BEST_RANK_REWARD_LUA_KEY');
define('PVP_RANK_REWARD_LUA_KEY', 'PVP_RANK_REWARD_LUA_KEY');
define('GUILD_WORSHIP_LUA_KEY', 'GUILD_WORSHIP_LUA_KEY');
define('GUILD_HIRE_PRICE_LUA_KEY', 'GUILD_HIRE_PRICE_LUA_KEY');
define('GUILD_INSTANCE_LUA_KEY', 'GUILD_INSTANCE_LUA_KEY');//add
define('CRUSADE_REWARD_LUA_KEY', 'CRUSADE_REWARD_LUA_KEY');
define('TAVERN_BOX_TYPE_LUA_KEY', 'TAVERN_BOX_TYPE_LUA_KEY');
define('RECHARGE_LUA_KEY', 'RECHARGE_LUA_KEY');
//define('RECHARGE_ALPHA_LUA_KEY', 'RECHARGE_ALPHA_LUA_KEY');
define('RECHARGE_PRODUCTION_LUA_KEY', 'RECHARGE_PRODUCTION_LUA_KEY');
define('PLAYER_MIDAS_LUA_KEY', 'PLAYER_MIDAS_LUA_KEY');
define('DAILY_ACTIVITY_LUA_KEY', 'DAILY_ACTIVITY_LUA_KEY');
define('GUILD_RAID_LUA_KEY', 'GUILD_RAID_LUA_KEY');
define('ACTIVITY_CONFIG_LUA_KEY', 'ACTIVITY_CONFIG_LUA_KEY');
define('ACTIVITY_INFO_CONFIG_LUA_KEY', 'ACTIVITY_INFO_CONFIG_LUA_KEY');
define('ACTIVITY_CHRISTMAS_REWARDS_INFO', 'ACTIVITY_CHRISTMAS_REWARDS_INFO');
define('EXCAVATE_TREASURE_LUA_KEY', 'EXCAVATE_TREASURE_LUA_KEY');



class DataModule
{
    static $instance;

    static $cachedFiles;

    static $filePathList;

    function DataModule()
    {
        self::$cachedFiles = array();

        self::$filePathList = array(
            PARAM_LUA_KEY => "parameterTable",
            ROBOT_LUA_KEY => "Robot",
            STAGE_LUA_KEY => "Stage",
            STAGE_GROUP_LUA_KEY => "ActStageGroup",
            BATTLE_LUA_KEY => "Battle",
            WORLD_LOOT_LUA_KEY => "WorldLoot",
            HERO_UNIT_LUA_KEY => "Unit",
            HERO_RANK_LUA_KEY => "UnitRank",
            PLAYER_LEVEL_LUA_KEY => "PlayerLevel",
            HERO_LEVEL_LUA_KEY => "Levels",
            HERO_EQUIP_LUA_KEY => "hero_equip",
            HERO_STAR_LUA_KEY => "HeroStars",
            ITEM_LUA_KEY => "equip",
            FRAGMENT_LUA_KEY => "fragment",
            ENHANCE_LUA_KEY => "enhancement",
            VIP_LUA_KEY => "VIP",
            GRADIENT_PRICE_LUA_KEY => "GradientPrice",
            ITEM_GROUPS_LUA_KEY => "ItemGroups",
            SHOP_LUA_KEY => "Shop",
            AVATAR_LUA_KEY => "Avatar",
            SKILL_INFO_LUA_KEY => "Skill",
            SKILL_GROUP_LUA_KEY => "SkillGroup",
            SKILL_LEVEL_PRICE_LUA_KEY => "SkillLevels",
            BUFF_LUA_KEY => "Buff",
            TAVERN_TYPE_KEY => "TavernType",
            EQUIP_CRAFT_KEY => "equipcraft",
            TRIGGERS_LUA_KEY => "Triggers",
            TASK_LUA_KEY => "Task",
            DAILY_LOGIN_REWARD_KEY => "DailyLoginReward",
            TODO_LIST_LUA_KEY => "Todolist",
            TODO_TRIGGERS_LUA_KEY => "TodoTriggers",
            PVP_ENEMY_LUA_KEY => "PVPEmeny",
            PVP_BEST_RANK_REWARD_LUA_KEY => "PVPBestRankReward",
            PVP_RANK_REWARD_LUA_KEY => "PVPRankReward",
            GUILD_WORSHIP_LUA_KEY => "GuildWorship",
            GUILD_HIRE_PRICE_LUA_KEY => "GuildHirePrice",
            GUILD_INSTANCE_LUA_KEY => "GuildInstance",
            CRUSADE_REWARD_LUA_KEY => "CrusadeRewards",
            TAVERN_BOX_TYPE_LUA_KEY => "TavernBoxType",
            RECHARGE_LUA_KEY => "Recharge",
           // RECHARGE_ALPHA_LUA_KEY => "RechargeAlpha",
            RECHARGE_PRODUCTION_LUA_KEY => "RechargeProduction",
            PLAYER_MIDAS_LUA_KEY => "Midas",
            DAILY_ACTIVITY_LUA_KEY => "DailyActivity",
            GUILD_RAID_LUA_KEY => "Raid",
        	ACTIVITY_CONFIG_LUA_KEY => "ActivityConfig",
        	ACTIVITY_INFO_CONFIG_LUA_KEY => "ActivityInfoConfig",
        	ACTIVITY_CHRISTMAS_REWARDS_INFO=>"ChristmasRewards",
        	EXCAVATE_TREASURE_LUA_KEY=>"ExcavateTreasure",
        );
    }

    static function &getInstance()
    {
        if (!isset (self::$instance)) {
            self::$instance = new DataModule();
        }

        return self::$instance;
    }

    public static function clearCache()
    {
        $mem = CMemcache::getInstance();
        $instance = self::getInstance();

        foreach (self::$filePathList as $key => $name) {
            $mem->deleteData($key);
        }
    }

    public static function updateCache()
    {
        $mem = CMemcache::getInstance();
        $instance = self::getInstance();

        foreach (self::$filePathList as $key => $name) {
            $mem->deleteData($key);
            $instance->loadData($key);
        }
    }

    private function getTableData($tableName)
    {
        $lua = new Lua();
        $lua->eval(<<<CODE
            function T(text, ...)
                return string.format(text, ...)
            end
            function getTable(respath, tablename)
                package.path = respath;
                require("LocalStringToServer");
                return require(tablename);
            end
CODE
        );
            $LuaPath = CONFIG_LUA_PATH . "/?.lua;";
            $gameTable = $lua->getTable($LuaPath, $tableName);

        return $gameTable;
    }

    /**
     * 从缓存中读取xml文件，缓存中文件不存在时从磁盘读取并存入memcache备用
     */
    private function loadData($key)
    {
        if (isset (self::$cachedFiles [$key])) {
            return self::$cachedFiles [$key];
        }

        $ret = CMemcache::getInstance()->getData($key);
        if (empty ($ret)) {
            if (isset (self::$filePathList[$key])) {
                $ret = $this->getTableData(self::$filePathList[$key]);

                if (empty($ret)) {
                    Logger::getLogger()->error("Failed to load lua {$key}");
                    return null;
                }

                CMemcache::getInstance()->setData($key, $ret);
            } else {
                Logger::getLogger()->error("No define lua {$key}");
                return null;
            }
        }

        self::$cachedFiles [$key] = $ret;

        return $ret;
    }

    //做一层封装
    public function getDataSetting($key)
    {
        return $this->loadData($key);
    }


    /**
     * @param $tableName 表名
     * @param $destElement 查询的目标元素
     * @param $ElementArr  查询路径元素
     */
    public static function lookupDataTable($tableName, $destElement, $ElementArr = null)
    {
        $tableData = self::getInstance()->getDataSetting($tableName);
        if (empty($tableData)) {
            return null;
        }

        if (isset($ElementArr)) {
            foreach ($ElementArr as $element) {
                if (isset($tableData[$element])) {
                    $tableData = $tableData[$element];
                } else {
                    return null;
                }
            }
        }
        if (isset($destElement)) {
            if (isset($tableData[$destElement])) {
                return $tableData[$destElement];
            } else {
                return null;
            }
        }
        return $tableData;
    }

}
