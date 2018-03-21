<?php
/**
 * Auto generated from down.proto at 2015-05-15 04:12:18
 *
 * down package
 */

/**
 * result enum
 */
final class Down_Result
{
    const success = 0;
    const fail = 1;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'success' => self::success,
            'fail' => self::fail,
        );
    }
}

/**
 * battle_result enum
 */
final class Down_BattleResult
{
    const victory = 0;
    const defeat = 1;
    const canceled = 2;
    const timeout = 3;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'victory' => self::victory,
            'defeat' => self::defeat,
            'canceled' => self::canceled,
            'timeout' => self::timeout,
        );
    }
}

/**
 * money_type enum
 */
final class Down_MoneyType
{
    const gold = 1;
    const diamond = 2;
    const tbc_point = 3;
    const ladder_point = 4;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'gold' => self::gold,
            'diamond' => self::diamond,
            'tbc_point' => self::tbc_point,
            'ladder_point' => self::ladder_point,
        );
    }
}

/**
 * hero_status enum
 */
final class Down_HeroStatus
{
    const idle = 0;
    const hire = 1;
    const mining = 2;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'idle' => self::idle,
            'hire' => self::hire,
            'mining' => self::mining,
        );
    }
}

/**
 * server_opt_result enum
 */
final class Down_ServerOptResult
{
    const get_ok = 0;
    const change_ok = 1;
    const fail = 2;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'get_ok' => self::get_ok,
            'change_ok' => self::change_ok,
            'fail' => self::fail,
        );
    }
}

/**
 * hire_result enum
 */
final class Down_HireResult
{
    const success = 0;
    const fail = 1;
    const stage_invalid = 2;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'success' => self::success,
            'fail' => self::fail,
            'stage_invalid' => self::stage_invalid,
        );
    }
}

/**
 * hire_from enum
 */
final class Down_HireFrom
{
    const guild = 0;
    const tbc = 1;
    const stage = 2;
    const excav = 3;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'guild' => self::guild,
            'tbc' => self::tbc,
            'stage' => self::stage,
            'excav' => self::excav,
        );
    }
}

/**
 * guild_join_t enum
 */
final class Down_GuildJoinT
{
    const no_verify = 1;
    const verify = 2;
    const closed = 3;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'no_verify' => self::no_verify,
            'verify' => self::verify,
            'closed' => self::closed,
        );
    }
}

/**
 * guild_job_t enum
 */
final class Down_GuildJobT
{
    const chairman = 1;
    const member = 2;
    const elder = 3;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'chairman' => self::chairman,
            'member' => self::member,
            'elder' => self::elder,
        );
    }
}

/**
 * chat_channel enum
 */
final class Down_ChatChannel
{
    const world_channel = 1;
    const guild_channel = 2;
    const personal_channel = 3;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'world_channel' => self::world_channel,
            'guild_channel' => self::guild_channel,
            'personal_channel' => self::personal_channel,
        );
    }
}

/**
 * hire_data message
 */
class Down_HireData extends \ProtobufMessage
{
    /* Field index constants */
    const _UID = 1;
    const _NAME = 2;
    const _HERO = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_UID => array(
            'name' => '_uid',
            'required' => true,
            'type' => 5,
        ),
        self::_NAME => array(
            'name' => '_name',
            'required' => true,
            'type' => 7,
        ),
        self::_HERO => array(
            'name' => '_hero',
            'required' => true,
            'type' => 'Down_HireHero'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_UID] = null;
        $this->values[self::_NAME] = null;
        $this->values[self::_HERO] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_uid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setUid($value)
    {
        return $this->set(self::_UID, $value);
    }

    /**
     * Returns value of '_uid' property
     *
     * @return int
     */
    public function getUid()
    {
        return $this->get(self::_UID);
    }

    /**
     * Sets value of '_name' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setName($value)
    {
        return $this->set(self::_NAME, $value);
    }

    /**
     * Returns value of '_name' property
     *
     * @return string
     */
    public function getName()
    {
        return $this->get(self::_NAME);
    }

    /**
     * Sets value of '_hero' property
     *
     * @param Down_HireHero $value Property value
     *
     * @return null
     */
    public function setHero(Down_HireHero $value)
    {
        return $this->set(self::_HERO, $value);
    }

    /**
     * Returns value of '_hero' property
     *
     * @return Down_HireHero
     */
    public function getHero()
    {
        return $this->get(self::_HERO);
    }
}

/**
 * hire_hero message
 */
class Down_HireHero extends \ProtobufMessage
{
    /* Field index constants */
    const _BASE = 1;
    const _DYNA = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_BASE => array(
            'name' => '_base',
            'required' => true,
            'type' => 'Down_Hero'
        ),
        self::_DYNA => array(
            'name' => '_dyna',
            'required' => true,
            'type' => 'Down_HeroDyna'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_BASE] = null;
        $this->values[self::_DYNA] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_base' property
     *
     * @param Down_Hero $value Property value
     *
     * @return null
     */
    public function setBase(Down_Hero $value)
    {
        return $this->set(self::_BASE, $value);
    }

    /**
     * Returns value of '_base' property
     *
     * @return Down_Hero
     */
    public function getBase()
    {
        return $this->get(self::_BASE);
    }

    /**
     * Sets value of '_dyna' property
     *
     * @param Down_HeroDyna $value Property value
     *
     * @return null
     */
    public function setDyna(Down_HeroDyna $value)
    {
        return $this->set(self::_DYNA, $value);
    }

    /**
     * Returns value of '_dyna' property
     *
     * @return Down_HeroDyna
     */
    public function getDyna()
    {
        return $this->get(self::_DYNA);
    }
}

/**
 * down_msg message
 */
class Down_DownMsg extends \ProtobufMessage
{
    /* Field index constants */
    const _LOGIN_REPLY = 1;
    const _RESET = 2;
    const _ENTER_STAGE_REPLY = 3;
    const _EXIT_STAGE_REPLY = 4;
    const _HERO_UPGRADE_REPLY = 5;
    const _EQUIP_SYNTHESIS_REPLY = 6;
    const _WEAR_EQUIP_REPLY = 7;
    const _CONSUME_ITEM_REPLY = 8;
    const _SHOP_REFRESH_REPLY = 9;
    const _SHOP_CONSUME_REPLY = 10;
    const _SKILL_LEVELUP_REPLY = 11;
    const _SELL_ITEM_REPLY = 12;
    const _FRAGMENT_COMPOSE_REPLY = 13;
    const _HERO_EQUIP_UPGRADE_REPLY = 14;
    const _TRIGGER_TASK_REPLY = 15;
    const _REQUIRE_REWARDS_REPLY = 16;
    const _TRIGGER_JOB_REPLY = 17;
    const _JOB_REWARDS_REPLY = 18;
    const _RESET_ELITE_REPLY = 19;
    const _SWEEP_STAGE_REPLY = 20;
    const _TAVERN_DRAW_REPLY = 21;
    const _SYNC_SKILL_STREN_REPLY = 22;
    const _QUERY_DATA_REPLY = 23;
    const _HERO_EVOLVE_REPLY = 24;
    const _SYNC_VITALITY_REPLY = 25;
    const _USER_CHECK = 26;
    const _TUTORIAL_REPLY = 27;
    const _ERROR_INFO = 28;
    const _LADDER_REPLY = 29;
    const _SET_NAME_REPLY = 30;
    const _MIDAS_REPLY = 31;
    const _OPEN_SHOP_REPLY = 32;
    const _CHARGE_REPLY = 33;
    const _SDK_LOGIN_REPLY = 34;
    const _SET_AVATAR_REPLY = 35;
    const _NOTIFY_MSG = 36;
    const _ASK_DAILY_LOGIN_REPLY = 37;
    const _TBC_REPLY = 38;
    const _GET_MAILLIST_REPLY = 39;
    const _READ_MAIL_REPLY = 40;
    const _SVR_TIME = 41;
    const _GET_VIP_GIFT_REPLY = 42;
    const _CHAT_REPLY = 43;
    const _CDKEY_GIFT_REPLY = 44;
    const _GUILD_REPLY = 45;
    const _ASK_MAGICSOUL_REPLY = 46;
    const _ASK_ACTIVITY_INFO_REPLY = 47;
    const _EXCAVATE_REPLY = 48;
    const _SYSTEM_SETTING_REPLY = 49;
    const _QUERY_SPLIT_DATA_REPLY = 50;
    const _QUERY_SPLIT_RETURN_REPLY = 51;
    const _SPLIT_HERO_REPLY = 52;
    const _WORLDCUP_REPLY = 53;
    const _BATTLE_CHECK_FAIL = 54;
    const _QUERY_REPLAY = 55;
    const _SUPER_LINK = 56;
    const _QUERY_RANKLIST_REPLY = 57;
    const _REQUEST_GUILD_LOG_REPLY = 65;
    const _CHANGE_SERVER_REPLY = 58;
    const _ACTIVITY_INFO_REPLY = 59;
    const _ACTIVITY_LOTTO_INFO_REPLY = 60;
    const _ACTIVITY_LOTTO_REWARD_REPLY = 61;
    const _ACTIVITY_BIGPACKAGE_INFO_REPLY = 62;
    const _ACTIVITY_BIGPACKAGE_REWARD_REPLY = 63;
    const _ACTIVITY_BIGPACKAGE_RESET_REPLY = 64;
    const _FB_ATTENTION_REPLY = 300;
    const _CONTINUE_PAY_REPLY = 302;
    const _RECHARGE_REBATE_REPLY = 303;
    const _EVERY_DAY_HAPPY_REPLY = 304;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_LOGIN_REPLY => array(
            'name' => '_login_reply',
            'required' => false,
            'type' => 'Down_LoginReply'
        ),
        self::_RESET => array(
            'name' => '_reset',
            'required' => false,
            'type' => 'Down_Reset'
        ),
        self::_ENTER_STAGE_REPLY => array(
            'name' => '_enter_stage_reply',
            'required' => false,
            'type' => 'Down_EnterStageReply'
        ),
        self::_EXIT_STAGE_REPLY => array(
            'name' => '_exit_stage_reply',
            'required' => false,
            'type' => 'Down_ExitStageReply'
        ),
        self::_HERO_UPGRADE_REPLY => array(
            'name' => '_hero_upgrade_reply',
            'required' => false,
            'type' => 'Down_HeroUpgradeReply'
        ),
        self::_EQUIP_SYNTHESIS_REPLY => array(
            'name' => '_equip_synthesis_reply',
            'required' => false,
            'type' => 'Down_EquipSynthesisReply'
        ),
        self::_WEAR_EQUIP_REPLY => array(
            'name' => '_wear_equip_reply',
            'required' => false,
            'type' => 'Down_WearEquipReply'
        ),
        self::_CONSUME_ITEM_REPLY => array(
            'name' => '_consume_item_reply',
            'required' => false,
            'type' => 'Down_ConsumeItemReply'
        ),
        self::_SHOP_REFRESH_REPLY => array(
            'name' => '_shop_refresh_reply',
            'required' => false,
            'type' => 'Down_UserShop'
        ),
        self::_SHOP_CONSUME_REPLY => array(
            'name' => '_shop_consume_reply',
            'required' => false,
            'type' => 'Down_ShopConsumeReply'
        ),
        self::_SKILL_LEVELUP_REPLY => array(
            'name' => '_skill_levelup_reply',
            'required' => false,
            'type' => 'Down_SkillLevelupReply'
        ),
        self::_SELL_ITEM_REPLY => array(
            'name' => '_sell_item_reply',
            'required' => false,
            'type' => 'Down_SellItemReply'
        ),
        self::_FRAGMENT_COMPOSE_REPLY => array(
            'name' => '_fragment_compose_reply',
            'required' => false,
            'type' => 'Down_FragmentComposeReply'
        ),
        self::_HERO_EQUIP_UPGRADE_REPLY => array(
            'name' => '_hero_equip_upgrade_reply',
            'required' => false,
            'type' => 'Down_HeroEquipUpgradeReply'
        ),
        self::_TRIGGER_TASK_REPLY => array(
            'name' => '_trigger_task_reply',
            'required' => false,
            'type' => 'Down_TriggerTaskReply'
        ),
        self::_REQUIRE_REWARDS_REPLY => array(
            'name' => '_require_rewards_reply',
            'required' => false,
            'type' => 'Down_RequireRewardsReply'
        ),
        self::_TRIGGER_JOB_REPLY => array(
            'name' => '_trigger_job_reply',
            'required' => false,
            'type' => 'Down_TriggerJobReply'
        ),
        self::_JOB_REWARDS_REPLY => array(
            'name' => '_job_rewards_reply',
            'required' => false,
            'type' => 'Down_JobRewardsReply'
        ),
        self::_RESET_ELITE_REPLY => array(
            'name' => '_reset_elite_reply',
            'required' => false,
            'type' => 'Down_ResetEliteReply'
        ),
        self::_SWEEP_STAGE_REPLY => array(
            'name' => '_sweep_stage_reply',
            'required' => false,
            'type' => 'Down_SweepStageReply'
        ),
        self::_TAVERN_DRAW_REPLY => array(
            'name' => '_tavern_draw_reply',
            'required' => false,
            'type' => 'Down_TavernDrawReply'
        ),
        self::_SYNC_SKILL_STREN_REPLY => array(
            'name' => '_sync_skill_stren_reply',
            'required' => false,
            'type' => 'Down_SyncSkillStrenReply'
        ),
        self::_QUERY_DATA_REPLY => array(
            'name' => '_query_data_reply',
            'required' => false,
            'type' => 'Down_QueryDataReply'
        ),
        self::_HERO_EVOLVE_REPLY => array(
            'name' => '_hero_evolve_reply',
            'required' => false,
            'type' => 'Down_HeroEvolveReply'
        ),
        self::_SYNC_VITALITY_REPLY => array(
            'name' => '_sync_vitality_reply',
            'required' => false,
            'type' => 'Down_SyncVitalityReply'
        ),
        self::_USER_CHECK => array(
            'name' => '_user_check',
            'required' => false,
            'type' => 'Down_UserCheck'
        ),
        self::_TUTORIAL_REPLY => array(
            'name' => '_tutorial_reply',
            'required' => false,
            'type' => 'Down_TutorialReply'
        ),
        self::_ERROR_INFO => array(
            'name' => '_error_info',
            'required' => false,
            'type' => 'Down_ErrorInfo'
        ),
        self::_LADDER_REPLY => array(
            'name' => '_ladder_reply',
            'required' => false,
            'type' => 'Down_LadderReply'
        ),
        self::_SET_NAME_REPLY => array(
            'name' => '_set_name_reply',
            'required' => false,
            'type' => 'Down_SetNameReply'
        ),
        self::_MIDAS_REPLY => array(
            'name' => '_midas_reply',
            'required' => false,
            'type' => 'Down_MidasReply'
        ),
        self::_OPEN_SHOP_REPLY => array(
            'name' => '_open_shop_reply',
            'required' => false,
            'type' => 'Down_OpenShopReply'
        ),
        self::_CHARGE_REPLY => array(
            'name' => '_charge_reply',
            'required' => false,
            'type' => 'Down_ChargeReply'
        ),
        self::_SDK_LOGIN_REPLY => array(
            'name' => '_sdk_login_reply',
            'required' => false,
            'type' => 'Down_SdkLoginReply'
        ),
        self::_SET_AVATAR_REPLY => array(
            'name' => '_set_avatar_reply',
            'required' => false,
            'type' => 'Down_SetAvatarReply'
        ),
        self::_NOTIFY_MSG => array(
            'name' => '_notify_msg',
            'required' => false,
            'type' => 'Down_NotifyMsg'
        ),
        self::_ASK_DAILY_LOGIN_REPLY => array(
            'name' => '_ask_daily_login_reply',
            'required' => false,
            'type' => 'Down_AskDailyLoginReply'
        ),
        self::_TBC_REPLY => array(
            'name' => '_tbc_reply',
            'required' => false,
            'type' => 'Down_TbcReply'
        ),
        self::_GET_MAILLIST_REPLY => array(
            'name' => '_get_maillist_reply',
            'required' => false,
            'type' => 'Down_GetMaillistReply'
        ),
        self::_READ_MAIL_REPLY => array(
            'name' => '_read_mail_reply',
            'required' => false,
            'type' => 'Down_ReadMailReply'
        ),
        self::_SVR_TIME => array(
            'name' => '_svr_time',
            'required' => false,
            'type' => 5,
        ),
        self::_GET_VIP_GIFT_REPLY => array(
            'name' => '_get_vip_gift_reply',
            'required' => false,
            'type' => 'Down_GetVipGiftReply'
        ),
        self::_CHAT_REPLY => array(
            'name' => '_chat_reply',
            'required' => false,
            'type' => 'Down_ChatReply'
        ),
        self::_CDKEY_GIFT_REPLY => array(
            'name' => '_cdkey_gift_reply',
            'required' => false,
            'type' => 'Down_CdkeyGiftReply'
        ),
        self::_GUILD_REPLY => array(
            'name' => '_guild_reply',
            'required' => false,
            'type' => 'Down_GuildReply'
        ),
        self::_ASK_MAGICSOUL_REPLY => array(
            'name' => '_ask_magicsoul_reply',
            'required' => false,
            'type' => 'Down_AskMagicsoulReply'
        ),
        self::_ASK_ACTIVITY_INFO_REPLY => array(
            'name' => '_ask_activity_info_reply',
            'required' => false,
            'type' => 'Down_ActivityInfos'
        ),
        self::_EXCAVATE_REPLY => array(
            'name' => '_excavate_reply',
            'required' => false,
            'type' => 'Down_ExcavateReply'
        ),
        self::_SYSTEM_SETTING_REPLY => array(
            'name' => '_system_setting_reply',
            'required' => false,
            'type' => 'Down_SystemSettingReply'
        ),
        self::_QUERY_SPLIT_DATA_REPLY => array(
            'name' => '_query_split_data_reply',
            'required' => false,
            'type' => 'Down_QuerySplitDataReply'
        ),
        self::_QUERY_SPLIT_RETURN_REPLY => array(
            'name' => '_query_split_return_reply',
            'required' => false,
            'type' => 'Down_QuerySplitReturnReply'
        ),
        self::_SPLIT_HERO_REPLY => array(
            'name' => '_split_hero_reply',
            'required' => false,
            'type' => 'Down_SplitHeroReply'
        ),
        self::_WORLDCUP_REPLY => array(
            'name' => '_worldcup_reply',
            'required' => false,
            'type' => 'Down_WorldcupReply'
        ),
        self::_BATTLE_CHECK_FAIL => array(
            'name' => '_battle_check_fail',
            'required' => false,
            'type' => 'Down_BattleCheckFail'
        ),
        self::_QUERY_REPLAY => array(
            'name' => '_query_replay',
            'required' => false,
            'type' => 'Down_QueryReplay'
        ),
        self::_SUPER_LINK => array(
            'name' => '_super_link',
            'required' => false,
            'type' => 'Down_SuperLink'
        ),
        self::_QUERY_RANKLIST_REPLY => array(
            'name' => '_query_ranklist_reply',
            'required' => false,
            'type' => 'Down_QueryRanklistReply'
        ),
        self::_REQUEST_GUILD_LOG_REPLY => array(
            'name' => '_request_guild_log_reply',
            'required' => false,
            'type' => 'Down_RequestGuildLogReply'
        ),
        self::_CHANGE_SERVER_REPLY => array(
            'name' => '_change_server_reply',
            'required' => false,
            'type' => 'Down_ChangeServerReply'
        ),
        self::_ACTIVITY_INFO_REPLY => array(
            'name' => '_activity_info_reply',
            'required' => false,
            'type' => 'Down_ActivityInfoReply'
        ),
        self::_ACTIVITY_LOTTO_INFO_REPLY => array(
            'name' => '_activity_lotto_info_reply',
            'required' => false,
            'type' => 'Down_ActivityLottoInfoReply'
        ),
        self::_ACTIVITY_LOTTO_REWARD_REPLY => array(
            'name' => '_activity_lotto_reward_reply',
            'required' => false,
            'type' => 'Down_ActivityLottoRewardReply'
        ),
        self::_ACTIVITY_BIGPACKAGE_INFO_REPLY => array(
            'name' => '_activity_bigpackage_info_reply',
            'required' => false,
            'type' => 'Down_ActivityBigpackageInfoReply'
        ),
        self::_ACTIVITY_BIGPACKAGE_REWARD_REPLY => array(
            'name' => '_activity_bigpackage_reward_reply',
            'required' => false,
            'type' => 'Down_ActivityBigpackageRewardReply'
        ),
        self::_ACTIVITY_BIGPACKAGE_RESET_REPLY => array(
            'name' => '_activity_bigpackage_reset_reply',
            'required' => false,
            'type' => 'Down_ActivityBigpackageResetReply'
        ),
        self::_FB_ATTENTION_REPLY => array(
            'name' => '_fb_attention_reply',
            'required' => false,
            'type' => 'Down_FbAttentionReply'
        ),
        self::_CONTINUE_PAY_REPLY => array(
            'name' => '_continue_pay_reply',
            'required' => false,
            'type' => 'Down_ContinuePayReply'
        ),
        self::_RECHARGE_REBATE_REPLY => array(
            'name' => '_recharge_rebate_reply',
            'required' => false,
            'type' => 'Down_RechargeRebateReply'
        ),
        self::_EVERY_DAY_HAPPY_REPLY => array(
            'name' => '_every_day_happy_reply',
            'required' => false,
            'type' => 'Down_EveryDayHappyReply'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_LOGIN_REPLY] = null;
        $this->values[self::_RESET] = null;
        $this->values[self::_ENTER_STAGE_REPLY] = null;
        $this->values[self::_EXIT_STAGE_REPLY] = null;
        $this->values[self::_HERO_UPGRADE_REPLY] = null;
        $this->values[self::_EQUIP_SYNTHESIS_REPLY] = null;
        $this->values[self::_WEAR_EQUIP_REPLY] = null;
        $this->values[self::_CONSUME_ITEM_REPLY] = null;
        $this->values[self::_SHOP_REFRESH_REPLY] = null;
        $this->values[self::_SHOP_CONSUME_REPLY] = null;
        $this->values[self::_SKILL_LEVELUP_REPLY] = null;
        $this->values[self::_SELL_ITEM_REPLY] = null;
        $this->values[self::_FRAGMENT_COMPOSE_REPLY] = null;
        $this->values[self::_HERO_EQUIP_UPGRADE_REPLY] = null;
        $this->values[self::_TRIGGER_TASK_REPLY] = null;
        $this->values[self::_REQUIRE_REWARDS_REPLY] = null;
        $this->values[self::_TRIGGER_JOB_REPLY] = null;
        $this->values[self::_JOB_REWARDS_REPLY] = null;
        $this->values[self::_RESET_ELITE_REPLY] = null;
        $this->values[self::_SWEEP_STAGE_REPLY] = null;
        $this->values[self::_TAVERN_DRAW_REPLY] = null;
        $this->values[self::_SYNC_SKILL_STREN_REPLY] = null;
        $this->values[self::_QUERY_DATA_REPLY] = null;
        $this->values[self::_HERO_EVOLVE_REPLY] = null;
        $this->values[self::_SYNC_VITALITY_REPLY] = null;
        $this->values[self::_USER_CHECK] = null;
        $this->values[self::_TUTORIAL_REPLY] = null;
        $this->values[self::_ERROR_INFO] = null;
        $this->values[self::_LADDER_REPLY] = null;
        $this->values[self::_SET_NAME_REPLY] = null;
        $this->values[self::_MIDAS_REPLY] = null;
        $this->values[self::_OPEN_SHOP_REPLY] = null;
        $this->values[self::_CHARGE_REPLY] = null;
        $this->values[self::_SDK_LOGIN_REPLY] = null;
        $this->values[self::_SET_AVATAR_REPLY] = null;
        $this->values[self::_NOTIFY_MSG] = null;
        $this->values[self::_ASK_DAILY_LOGIN_REPLY] = null;
        $this->values[self::_TBC_REPLY] = null;
        $this->values[self::_GET_MAILLIST_REPLY] = null;
        $this->values[self::_READ_MAIL_REPLY] = null;
        $this->values[self::_SVR_TIME] = null;
        $this->values[self::_GET_VIP_GIFT_REPLY] = null;
        $this->values[self::_CHAT_REPLY] = null;
        $this->values[self::_CDKEY_GIFT_REPLY] = null;
        $this->values[self::_GUILD_REPLY] = null;
        $this->values[self::_ASK_MAGICSOUL_REPLY] = null;
        $this->values[self::_ASK_ACTIVITY_INFO_REPLY] = null;
        $this->values[self::_EXCAVATE_REPLY] = null;
        $this->values[self::_SYSTEM_SETTING_REPLY] = null;
        $this->values[self::_QUERY_SPLIT_DATA_REPLY] = null;
        $this->values[self::_QUERY_SPLIT_RETURN_REPLY] = null;
        $this->values[self::_SPLIT_HERO_REPLY] = null;
        $this->values[self::_WORLDCUP_REPLY] = null;
        $this->values[self::_BATTLE_CHECK_FAIL] = null;
        $this->values[self::_QUERY_REPLAY] = null;
        $this->values[self::_SUPER_LINK] = null;
        $this->values[self::_QUERY_RANKLIST_REPLY] = null;
        $this->values[self::_REQUEST_GUILD_LOG_REPLY] = null;
        $this->values[self::_CHANGE_SERVER_REPLY] = null;
        $this->values[self::_ACTIVITY_INFO_REPLY] = null;
        $this->values[self::_ACTIVITY_LOTTO_INFO_REPLY] = null;
        $this->values[self::_ACTIVITY_LOTTO_REWARD_REPLY] = null;
        $this->values[self::_ACTIVITY_BIGPACKAGE_INFO_REPLY] = null;
        $this->values[self::_ACTIVITY_BIGPACKAGE_REWARD_REPLY] = null;
        $this->values[self::_ACTIVITY_BIGPACKAGE_RESET_REPLY] = null;
        $this->values[self::_FB_ATTENTION_REPLY] = null;
        $this->values[self::_CONTINUE_PAY_REPLY] = null;
        $this->values[self::_RECHARGE_REBATE_REPLY] = null;
        $this->values[self::_EVERY_DAY_HAPPY_REPLY] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_login_reply' property
     *
     * @param Down_LoginReply $value Property value
     *
     * @return null
     */
    public function setLoginReply(Down_LoginReply $value)
    {
        return $this->set(self::_LOGIN_REPLY, $value);
    }

    /**
     * Returns value of '_login_reply' property
     *
     * @return Down_LoginReply
     */
    public function getLoginReply()
    {
        return $this->get(self::_LOGIN_REPLY);
    }

    /**
     * Sets value of '_reset' property
     *
     * @param Down_Reset $value Property value
     *
     * @return null
     */
    public function setReset(Down_Reset $value)
    {
        return $this->set(self::_RESET, $value);
    }

    /**
     * Returns value of '_reset' property
     *
     * @return Down_Reset
     */
    public function getReset()
    {
        return $this->get(self::_RESET);
    }

    /**
     * Sets value of '_enter_stage_reply' property
     *
     * @param Down_EnterStageReply $value Property value
     *
     * @return null
     */
    public function setEnterStageReply(Down_EnterStageReply $value)
    {
        return $this->set(self::_ENTER_STAGE_REPLY, $value);
    }

    /**
     * Returns value of '_enter_stage_reply' property
     *
     * @return Down_EnterStageReply
     */
    public function getEnterStageReply()
    {
        return $this->get(self::_ENTER_STAGE_REPLY);
    }

    /**
     * Sets value of '_exit_stage_reply' property
     *
     * @param Down_ExitStageReply $value Property value
     *
     * @return null
     */
    public function setExitStageReply(Down_ExitStageReply $value)
    {
        return $this->set(self::_EXIT_STAGE_REPLY, $value);
    }

    /**
     * Returns value of '_exit_stage_reply' property
     *
     * @return Down_ExitStageReply
     */
    public function getExitStageReply()
    {
        return $this->get(self::_EXIT_STAGE_REPLY);
    }

    /**
     * Sets value of '_hero_upgrade_reply' property
     *
     * @param Down_HeroUpgradeReply $value Property value
     *
     * @return null
     */
    public function setHeroUpgradeReply(Down_HeroUpgradeReply $value)
    {
        return $this->set(self::_HERO_UPGRADE_REPLY, $value);
    }

    /**
     * Returns value of '_hero_upgrade_reply' property
     *
     * @return Down_HeroUpgradeReply
     */
    public function getHeroUpgradeReply()
    {
        return $this->get(self::_HERO_UPGRADE_REPLY);
    }

    /**
     * Sets value of '_equip_synthesis_reply' property
     *
     * @param Down_EquipSynthesisReply $value Property value
     *
     * @return null
     */
    public function setEquipSynthesisReply(Down_EquipSynthesisReply $value)
    {
        return $this->set(self::_EQUIP_SYNTHESIS_REPLY, $value);
    }

    /**
     * Returns value of '_equip_synthesis_reply' property
     *
     * @return Down_EquipSynthesisReply
     */
    public function getEquipSynthesisReply()
    {
        return $this->get(self::_EQUIP_SYNTHESIS_REPLY);
    }

    /**
     * Sets value of '_wear_equip_reply' property
     *
     * @param Down_WearEquipReply $value Property value
     *
     * @return null
     */
    public function setWearEquipReply(Down_WearEquipReply $value)
    {
        return $this->set(self::_WEAR_EQUIP_REPLY, $value);
    }

    /**
     * Returns value of '_wear_equip_reply' property
     *
     * @return Down_WearEquipReply
     */
    public function getWearEquipReply()
    {
        return $this->get(self::_WEAR_EQUIP_REPLY);
    }

    /**
     * Sets value of '_consume_item_reply' property
     *
     * @param Down_ConsumeItemReply $value Property value
     *
     * @return null
     */
    public function setConsumeItemReply(Down_ConsumeItemReply $value)
    {
        return $this->set(self::_CONSUME_ITEM_REPLY, $value);
    }

    /**
     * Returns value of '_consume_item_reply' property
     *
     * @return Down_ConsumeItemReply
     */
    public function getConsumeItemReply()
    {
        return $this->get(self::_CONSUME_ITEM_REPLY);
    }

    /**
     * Sets value of '_shop_refresh_reply' property
     *
     * @param Down_UserShop $value Property value
     *
     * @return null
     */
    public function setShopRefreshReply(Down_UserShop $value)
    {
        return $this->set(self::_SHOP_REFRESH_REPLY, $value);
    }

    /**
     * Returns value of '_shop_refresh_reply' property
     *
     * @return Down_UserShop
     */
    public function getShopRefreshReply()
    {
        return $this->get(self::_SHOP_REFRESH_REPLY);
    }

    /**
     * Sets value of '_shop_consume_reply' property
     *
     * @param Down_ShopConsumeReply $value Property value
     *
     * @return null
     */
    public function setShopConsumeReply(Down_ShopConsumeReply $value)
    {
        return $this->set(self::_SHOP_CONSUME_REPLY, $value);
    }

    /**
     * Returns value of '_shop_consume_reply' property
     *
     * @return Down_ShopConsumeReply
     */
    public function getShopConsumeReply()
    {
        return $this->get(self::_SHOP_CONSUME_REPLY);
    }

    /**
     * Sets value of '_skill_levelup_reply' property
     *
     * @param Down_SkillLevelupReply $value Property value
     *
     * @return null
     */
    public function setSkillLevelupReply(Down_SkillLevelupReply $value)
    {
        return $this->set(self::_SKILL_LEVELUP_REPLY, $value);
    }

    /**
     * Returns value of '_skill_levelup_reply' property
     *
     * @return Down_SkillLevelupReply
     */
    public function getSkillLevelupReply()
    {
        return $this->get(self::_SKILL_LEVELUP_REPLY);
    }

    /**
     * Sets value of '_sell_item_reply' property
     *
     * @param Down_SellItemReply $value Property value
     *
     * @return null
     */
    public function setSellItemReply(Down_SellItemReply $value)
    {
        return $this->set(self::_SELL_ITEM_REPLY, $value);
    }

    /**
     * Returns value of '_sell_item_reply' property
     *
     * @return Down_SellItemReply
     */
    public function getSellItemReply()
    {
        return $this->get(self::_SELL_ITEM_REPLY);
    }

    /**
     * Sets value of '_fragment_compose_reply' property
     *
     * @param Down_FragmentComposeReply $value Property value
     *
     * @return null
     */
    public function setFragmentComposeReply(Down_FragmentComposeReply $value)
    {
        return $this->set(self::_FRAGMENT_COMPOSE_REPLY, $value);
    }

    /**
     * Returns value of '_fragment_compose_reply' property
     *
     * @return Down_FragmentComposeReply
     */
    public function getFragmentComposeReply()
    {
        return $this->get(self::_FRAGMENT_COMPOSE_REPLY);
    }

    /**
     * Sets value of '_hero_equip_upgrade_reply' property
     *
     * @param Down_HeroEquipUpgradeReply $value Property value
     *
     * @return null
     */
    public function setHeroEquipUpgradeReply(Down_HeroEquipUpgradeReply $value)
    {
        return $this->set(self::_HERO_EQUIP_UPGRADE_REPLY, $value);
    }

    /**
     * Returns value of '_hero_equip_upgrade_reply' property
     *
     * @return Down_HeroEquipUpgradeReply
     */
    public function getHeroEquipUpgradeReply()
    {
        return $this->get(self::_HERO_EQUIP_UPGRADE_REPLY);
    }

    /**
     * Sets value of '_trigger_task_reply' property
     *
     * @param Down_TriggerTaskReply $value Property value
     *
     * @return null
     */
    public function setTriggerTaskReply(Down_TriggerTaskReply $value)
    {
        return $this->set(self::_TRIGGER_TASK_REPLY, $value);
    }

    /**
     * Returns value of '_trigger_task_reply' property
     *
     * @return Down_TriggerTaskReply
     */
    public function getTriggerTaskReply()
    {
        return $this->get(self::_TRIGGER_TASK_REPLY);
    }

    /**
     * Sets value of '_require_rewards_reply' property
     *
     * @param Down_RequireRewardsReply $value Property value
     *
     * @return null
     */
    public function setRequireRewardsReply(Down_RequireRewardsReply $value)
    {
        return $this->set(self::_REQUIRE_REWARDS_REPLY, $value);
    }

    /**
     * Returns value of '_require_rewards_reply' property
     *
     * @return Down_RequireRewardsReply
     */
    public function getRequireRewardsReply()
    {
        return $this->get(self::_REQUIRE_REWARDS_REPLY);
    }

    /**
     * Sets value of '_trigger_job_reply' property
     *
     * @param Down_TriggerJobReply $value Property value
     *
     * @return null
     */
    public function setTriggerJobReply(Down_TriggerJobReply $value)
    {
        return $this->set(self::_TRIGGER_JOB_REPLY, $value);
    }

    /**
     * Returns value of '_trigger_job_reply' property
     *
     * @return Down_TriggerJobReply
     */
    public function getTriggerJobReply()
    {
        return $this->get(self::_TRIGGER_JOB_REPLY);
    }

    /**
     * Sets value of '_job_rewards_reply' property
     *
     * @param Down_JobRewardsReply $value Property value
     *
     * @return null
     */
    public function setJobRewardsReply(Down_JobRewardsReply $value)
    {
        return $this->set(self::_JOB_REWARDS_REPLY, $value);
    }

    /**
     * Returns value of '_job_rewards_reply' property
     *
     * @return Down_JobRewardsReply
     */
    public function getJobRewardsReply()
    {
        return $this->get(self::_JOB_REWARDS_REPLY);
    }

    /**
     * Sets value of '_reset_elite_reply' property
     *
     * @param Down_ResetEliteReply $value Property value
     *
     * @return null
     */
    public function setResetEliteReply(Down_ResetEliteReply $value)
    {
        return $this->set(self::_RESET_ELITE_REPLY, $value);
    }

    /**
     * Returns value of '_reset_elite_reply' property
     *
     * @return Down_ResetEliteReply
     */
    public function getResetEliteReply()
    {
        return $this->get(self::_RESET_ELITE_REPLY);
    }

    /**
     * Sets value of '_sweep_stage_reply' property
     *
     * @param Down_SweepStageReply $value Property value
     *
     * @return null
     */
    public function setSweepStageReply(Down_SweepStageReply $value)
    {
        return $this->set(self::_SWEEP_STAGE_REPLY, $value);
    }

    /**
     * Returns value of '_sweep_stage_reply' property
     *
     * @return Down_SweepStageReply
     */
    public function getSweepStageReply()
    {
        return $this->get(self::_SWEEP_STAGE_REPLY);
    }

    /**
     * Sets value of '_tavern_draw_reply' property
     *
     * @param Down_TavernDrawReply $value Property value
     *
     * @return null
     */
    public function setTavernDrawReply(Down_TavernDrawReply $value)
    {
        return $this->set(self::_TAVERN_DRAW_REPLY, $value);
    }

    /**
     * Returns value of '_tavern_draw_reply' property
     *
     * @return Down_TavernDrawReply
     */
    public function getTavernDrawReply()
    {
        return $this->get(self::_TAVERN_DRAW_REPLY);
    }

    /**
     * Sets value of '_sync_skill_stren_reply' property
     *
     * @param Down_SyncSkillStrenReply $value Property value
     *
     * @return null
     */
    public function setSyncSkillStrenReply(Down_SyncSkillStrenReply $value)
    {
        return $this->set(self::_SYNC_SKILL_STREN_REPLY, $value);
    }

    /**
     * Returns value of '_sync_skill_stren_reply' property
     *
     * @return Down_SyncSkillStrenReply
     */
    public function getSyncSkillStrenReply()
    {
        return $this->get(self::_SYNC_SKILL_STREN_REPLY);
    }

    /**
     * Sets value of '_query_data_reply' property
     *
     * @param Down_QueryDataReply $value Property value
     *
     * @return null
     */
    public function setQueryDataReply(Down_QueryDataReply $value)
    {
        return $this->set(self::_QUERY_DATA_REPLY, $value);
    }

    /**
     * Returns value of '_query_data_reply' property
     *
     * @return Down_QueryDataReply
     */
    public function getQueryDataReply()
    {
        return $this->get(self::_QUERY_DATA_REPLY);
    }

    /**
     * Sets value of '_hero_evolve_reply' property
     *
     * @param Down_HeroEvolveReply $value Property value
     *
     * @return null
     */
    public function setHeroEvolveReply(Down_HeroEvolveReply $value)
    {
        return $this->set(self::_HERO_EVOLVE_REPLY, $value);
    }

    /**
     * Returns value of '_hero_evolve_reply' property
     *
     * @return Down_HeroEvolveReply
     */
    public function getHeroEvolveReply()
    {
        return $this->get(self::_HERO_EVOLVE_REPLY);
    }

    /**
     * Sets value of '_sync_vitality_reply' property
     *
     * @param Down_SyncVitalityReply $value Property value
     *
     * @return null
     */
    public function setSyncVitalityReply(Down_SyncVitalityReply $value)
    {
        return $this->set(self::_SYNC_VITALITY_REPLY, $value);
    }

    /**
     * Returns value of '_sync_vitality_reply' property
     *
     * @return Down_SyncVitalityReply
     */
    public function getSyncVitalityReply()
    {
        return $this->get(self::_SYNC_VITALITY_REPLY);
    }

    /**
     * Sets value of '_user_check' property
     *
     * @param Down_UserCheck $value Property value
     *
     * @return null
     */
    public function setUserCheck(Down_UserCheck $value)
    {
        return $this->set(self::_USER_CHECK, $value);
    }

    /**
     * Returns value of '_user_check' property
     *
     * @return Down_UserCheck
     */
    public function getUserCheck()
    {
        return $this->get(self::_USER_CHECK);
    }

    /**
     * Sets value of '_tutorial_reply' property
     *
     * @param Down_TutorialReply $value Property value
     *
     * @return null
     */
    public function setTutorialReply(Down_TutorialReply $value)
    {
        return $this->set(self::_TUTORIAL_REPLY, $value);
    }

    /**
     * Returns value of '_tutorial_reply' property
     *
     * @return Down_TutorialReply
     */
    public function getTutorialReply()
    {
        return $this->get(self::_TUTORIAL_REPLY);
    }

    /**
     * Sets value of '_error_info' property
     *
     * @param Down_ErrorInfo $value Property value
     *
     * @return null
     */
    public function setErrorInfo(Down_ErrorInfo $value)
    {
        return $this->set(self::_ERROR_INFO, $value);
    }

    /**
     * Returns value of '_error_info' property
     *
     * @return Down_ErrorInfo
     */
    public function getErrorInfo()
    {
        return $this->get(self::_ERROR_INFO);
    }

    /**
     * Sets value of '_ladder_reply' property
     *
     * @param Down_LadderReply $value Property value
     *
     * @return null
     */
    public function setLadderReply(Down_LadderReply $value)
    {
        return $this->set(self::_LADDER_REPLY, $value);
    }

    /**
     * Returns value of '_ladder_reply' property
     *
     * @return Down_LadderReply
     */
    public function getLadderReply()
    {
        return $this->get(self::_LADDER_REPLY);
    }

    /**
     * Sets value of '_set_name_reply' property
     *
     * @param Down_SetNameReply $value Property value
     *
     * @return null
     */
    public function setSetNameReply(Down_SetNameReply $value)
    {
        return $this->set(self::_SET_NAME_REPLY, $value);
    }

    /**
     * Returns value of '_set_name_reply' property
     *
     * @return Down_SetNameReply
     */
    public function getSetNameReply()
    {
        return $this->get(self::_SET_NAME_REPLY);
    }

    /**
     * Sets value of '_midas_reply' property
     *
     * @param Down_MidasReply $value Property value
     *
     * @return null
     */
    public function setMidasReply(Down_MidasReply $value)
    {
        return $this->set(self::_MIDAS_REPLY, $value);
    }

    /**
     * Returns value of '_midas_reply' property
     *
     * @return Down_MidasReply
     */
    public function getMidasReply()
    {
        return $this->get(self::_MIDAS_REPLY);
    }

    /**
     * Sets value of '_open_shop_reply' property
     *
     * @param Down_OpenShopReply $value Property value
     *
     * @return null
     */
    public function setOpenShopReply(Down_OpenShopReply $value)
    {
        return $this->set(self::_OPEN_SHOP_REPLY, $value);
    }

    /**
     * Returns value of '_open_shop_reply' property
     *
     * @return Down_OpenShopReply
     */
    public function getOpenShopReply()
    {
        return $this->get(self::_OPEN_SHOP_REPLY);
    }

    /**
     * Sets value of '_charge_reply' property
     *
     * @param Down_ChargeReply $value Property value
     *
     * @return null
     */
    public function setChargeReply(Down_ChargeReply $value)
    {
        return $this->set(self::_CHARGE_REPLY, $value);
    }

    /**
     * Returns value of '_charge_reply' property
     *
     * @return Down_ChargeReply
     */
    public function getChargeReply()
    {
        return $this->get(self::_CHARGE_REPLY);
    }

    /**
     * Sets value of '_sdk_login_reply' property
     *
     * @param Down_SdkLoginReply $value Property value
     *
     * @return null
     */
    public function setSdkLoginReply(Down_SdkLoginReply $value)
    {
        return $this->set(self::_SDK_LOGIN_REPLY, $value);
    }

    /**
     * Returns value of '_sdk_login_reply' property
     *
     * @return Down_SdkLoginReply
     */
    public function getSdkLoginReply()
    {
        return $this->get(self::_SDK_LOGIN_REPLY);
    }

    /**
     * Sets value of '_set_avatar_reply' property
     *
     * @param Down_SetAvatarReply $value Property value
     *
     * @return null
     */
    public function setSetAvatarReply(Down_SetAvatarReply $value)
    {
        return $this->set(self::_SET_AVATAR_REPLY, $value);
    }

    /**
     * Returns value of '_set_avatar_reply' property
     *
     * @return Down_SetAvatarReply
     */
    public function getSetAvatarReply()
    {
        return $this->get(self::_SET_AVATAR_REPLY);
    }

    /**
     * Sets value of '_notify_msg' property
     *
     * @param Down_NotifyMsg $value Property value
     *
     * @return null
     */
    public function setNotifyMsg(Down_NotifyMsg $value)
    {
        return $this->set(self::_NOTIFY_MSG, $value);
    }

    /**
     * Returns value of '_notify_msg' property
     *
     * @return Down_NotifyMsg
     */
    public function getNotifyMsg()
    {
        return $this->get(self::_NOTIFY_MSG);
    }

    /**
     * Sets value of '_ask_daily_login_reply' property
     *
     * @param Down_AskDailyLoginReply $value Property value
     *
     * @return null
     */
    public function setAskDailyLoginReply(Down_AskDailyLoginReply $value)
    {
        return $this->set(self::_ASK_DAILY_LOGIN_REPLY, $value);
    }

    /**
     * Returns value of '_ask_daily_login_reply' property
     *
     * @return Down_AskDailyLoginReply
     */
    public function getAskDailyLoginReply()
    {
        return $this->get(self::_ASK_DAILY_LOGIN_REPLY);
    }

    /**
     * Sets value of '_tbc_reply' property
     *
     * @param Down_TbcReply $value Property value
     *
     * @return null
     */
    public function setTbcReply(Down_TbcReply $value)
    {
        return $this->set(self::_TBC_REPLY, $value);
    }

    /**
     * Returns value of '_tbc_reply' property
     *
     * @return Down_TbcReply
     */
    public function getTbcReply()
    {
        return $this->get(self::_TBC_REPLY);
    }

    /**
     * Sets value of '_get_maillist_reply' property
     *
     * @param Down_GetMaillistReply $value Property value
     *
     * @return null
     */
    public function setGetMaillistReply(Down_GetMaillistReply $value)
    {
        return $this->set(self::_GET_MAILLIST_REPLY, $value);
    }

    /**
     * Returns value of '_get_maillist_reply' property
     *
     * @return Down_GetMaillistReply
     */
    public function getGetMaillistReply()
    {
        return $this->get(self::_GET_MAILLIST_REPLY);
    }

    /**
     * Sets value of '_read_mail_reply' property
     *
     * @param Down_ReadMailReply $value Property value
     *
     * @return null
     */
    public function setReadMailReply(Down_ReadMailReply $value)
    {
        return $this->set(self::_READ_MAIL_REPLY, $value);
    }

    /**
     * Returns value of '_read_mail_reply' property
     *
     * @return Down_ReadMailReply
     */
    public function getReadMailReply()
    {
        return $this->get(self::_READ_MAIL_REPLY);
    }

    /**
     * Sets value of '_svr_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSvrTime($value)
    {
        return $this->set(self::_SVR_TIME, $value);
    }

    /**
     * Returns value of '_svr_time' property
     *
     * @return int
     */
    public function getSvrTime()
    {
        return $this->get(self::_SVR_TIME);
    }

    /**
     * Sets value of '_get_vip_gift_reply' property
     *
     * @param Down_GetVipGiftReply $value Property value
     *
     * @return null
     */
    public function setGetVipGiftReply(Down_GetVipGiftReply $value)
    {
        return $this->set(self::_GET_VIP_GIFT_REPLY, $value);
    }

    /**
     * Returns value of '_get_vip_gift_reply' property
     *
     * @return Down_GetVipGiftReply
     */
    public function getGetVipGiftReply()
    {
        return $this->get(self::_GET_VIP_GIFT_REPLY);
    }

    /**
     * Sets value of '_chat_reply' property
     *
     * @param Down_ChatReply $value Property value
     *
     * @return null
     */
    public function setChatReply(Down_ChatReply $value)
    {
        return $this->set(self::_CHAT_REPLY, $value);
    }

    /**
     * Returns value of '_chat_reply' property
     *
     * @return Down_ChatReply
     */
    public function getChatReply()
    {
        return $this->get(self::_CHAT_REPLY);
    }

    /**
     * Sets value of '_cdkey_gift_reply' property
     *
     * @param Down_CdkeyGiftReply $value Property value
     *
     * @return null
     */
    public function setCdkeyGiftReply(Down_CdkeyGiftReply $value)
    {
        return $this->set(self::_CDKEY_GIFT_REPLY, $value);
    }

    /**
     * Returns value of '_cdkey_gift_reply' property
     *
     * @return Down_CdkeyGiftReply
     */
    public function getCdkeyGiftReply()
    {
        return $this->get(self::_CDKEY_GIFT_REPLY);
    }

    /**
     * Sets value of '_guild_reply' property
     *
     * @param Down_GuildReply $value Property value
     *
     * @return null
     */
    public function setGuildReply(Down_GuildReply $value)
    {
        return $this->set(self::_GUILD_REPLY, $value);
    }

    /**
     * Returns value of '_guild_reply' property
     *
     * @return Down_GuildReply
     */
    public function getGuildReply()
    {
        return $this->get(self::_GUILD_REPLY);
    }

    /**
     * Sets value of '_ask_magicsoul_reply' property
     *
     * @param Down_AskMagicsoulReply $value Property value
     *
     * @return null
     */
    public function setAskMagicsoulReply(Down_AskMagicsoulReply $value)
    {
        return $this->set(self::_ASK_MAGICSOUL_REPLY, $value);
    }

    /**
     * Returns value of '_ask_magicsoul_reply' property
     *
     * @return Down_AskMagicsoulReply
     */
    public function getAskMagicsoulReply()
    {
        return $this->get(self::_ASK_MAGICSOUL_REPLY);
    }

    /**
     * Sets value of '_ask_activity_info_reply' property
     *
     * @param Down_ActivityInfos $value Property value
     *
     * @return null
     */
    public function setAskActivityInfoReply(Down_ActivityInfos $value)
    {
        return $this->set(self::_ASK_ACTIVITY_INFO_REPLY, $value);
    }

    /**
     * Returns value of '_ask_activity_info_reply' property
     *
     * @return Down_ActivityInfos
     */
    public function getAskActivityInfoReply()
    {
        return $this->get(self::_ASK_ACTIVITY_INFO_REPLY);
    }

    /**
     * Sets value of '_excavate_reply' property
     *
     * @param Down_ExcavateReply $value Property value
     *
     * @return null
     */
    public function setExcavateReply(Down_ExcavateReply $value)
    {
        return $this->set(self::_EXCAVATE_REPLY, $value);
    }

    /**
     * Returns value of '_excavate_reply' property
     *
     * @return Down_ExcavateReply
     */
    public function getExcavateReply()
    {
        return $this->get(self::_EXCAVATE_REPLY);
    }

    /**
     * Sets value of '_system_setting_reply' property
     *
     * @param Down_SystemSettingReply $value Property value
     *
     * @return null
     */
    public function setSystemSettingReply(Down_SystemSettingReply $value)
    {
        return $this->set(self::_SYSTEM_SETTING_REPLY, $value);
    }

    /**
     * Returns value of '_system_setting_reply' property
     *
     * @return Down_SystemSettingReply
     */
    public function getSystemSettingReply()
    {
        return $this->get(self::_SYSTEM_SETTING_REPLY);
    }

    /**
     * Sets value of '_query_split_data_reply' property
     *
     * @param Down_QuerySplitDataReply $value Property value
     *
     * @return null
     */
    public function setQuerySplitDataReply(Down_QuerySplitDataReply $value)
    {
        return $this->set(self::_QUERY_SPLIT_DATA_REPLY, $value);
    }

    /**
     * Returns value of '_query_split_data_reply' property
     *
     * @return Down_QuerySplitDataReply
     */
    public function getQuerySplitDataReply()
    {
        return $this->get(self::_QUERY_SPLIT_DATA_REPLY);
    }

    /**
     * Sets value of '_query_split_return_reply' property
     *
     * @param Down_QuerySplitReturnReply $value Property value
     *
     * @return null
     */
    public function setQuerySplitReturnReply(Down_QuerySplitReturnReply $value)
    {
        return $this->set(self::_QUERY_SPLIT_RETURN_REPLY, $value);
    }

    /**
     * Returns value of '_query_split_return_reply' property
     *
     * @return Down_QuerySplitReturnReply
     */
    public function getQuerySplitReturnReply()
    {
        return $this->get(self::_QUERY_SPLIT_RETURN_REPLY);
    }

    /**
     * Sets value of '_split_hero_reply' property
     *
     * @param Down_SplitHeroReply $value Property value
     *
     * @return null
     */
    public function setSplitHeroReply(Down_SplitHeroReply $value)
    {
        return $this->set(self::_SPLIT_HERO_REPLY, $value);
    }

    /**
     * Returns value of '_split_hero_reply' property
     *
     * @return Down_SplitHeroReply
     */
    public function getSplitHeroReply()
    {
        return $this->get(self::_SPLIT_HERO_REPLY);
    }

    /**
     * Sets value of '_worldcup_reply' property
     *
     * @param Down_WorldcupReply $value Property value
     *
     * @return null
     */
    public function setWorldcupReply(Down_WorldcupReply $value)
    {
        return $this->set(self::_WORLDCUP_REPLY, $value);
    }

    /**
     * Returns value of '_worldcup_reply' property
     *
     * @return Down_WorldcupReply
     */
    public function getWorldcupReply()
    {
        return $this->get(self::_WORLDCUP_REPLY);
    }

    /**
     * Sets value of '_battle_check_fail' property
     *
     * @param Down_BattleCheckFail $value Property value
     *
     * @return null
     */
    public function setBattleCheckFail(Down_BattleCheckFail $value)
    {
        return $this->set(self::_BATTLE_CHECK_FAIL, $value);
    }

    /**
     * Returns value of '_battle_check_fail' property
     *
     * @return Down_BattleCheckFail
     */
    public function getBattleCheckFail()
    {
        return $this->get(self::_BATTLE_CHECK_FAIL);
    }

    /**
     * Sets value of '_query_replay' property
     *
     * @param Down_QueryReplay $value Property value
     *
     * @return null
     */
    public function setQueryReplay(Down_QueryReplay $value)
    {
        return $this->set(self::_QUERY_REPLAY, $value);
    }

    /**
     * Returns value of '_query_replay' property
     *
     * @return Down_QueryReplay
     */
    public function getQueryReplay()
    {
        return $this->get(self::_QUERY_REPLAY);
    }

    /**
     * Sets value of '_super_link' property
     *
     * @param Down_SuperLink $value Property value
     *
     * @return null
     */
    public function setSuperLink(Down_SuperLink $value)
    {
        return $this->set(self::_SUPER_LINK, $value);
    }

    /**
     * Returns value of '_super_link' property
     *
     * @return Down_SuperLink
     */
    public function getSuperLink()
    {
        return $this->get(self::_SUPER_LINK);
    }

    /**
     * Sets value of '_query_ranklist_reply' property
     *
     * @param Down_QueryRanklistReply $value Property value
     *
     * @return null
     */
    public function setQueryRanklistReply(Down_QueryRanklistReply $value)
    {
        return $this->set(self::_QUERY_RANKLIST_REPLY, $value);
    }

    /**
     * Returns value of '_query_ranklist_reply' property
     *
     * @return Down_QueryRanklistReply
     */
    public function getQueryRanklistReply()
    {
        return $this->get(self::_QUERY_RANKLIST_REPLY);
    }

    /**
     * Sets value of '_request_guild_log_reply' property
     *
     * @param Down_RequestGuildLogReply $value Property value
     *
     * @return null
     */
    public function setRequestGuildLogReply(Down_RequestGuildLogReply $value)
    {
        return $this->set(self::_REQUEST_GUILD_LOG_REPLY, $value);
    }

    /**
     * Returns value of '_request_guild_log_reply' property
     *
     * @return Down_RequestGuildLogReply
     */
    public function getRequestGuildLogReply()
    {
        return $this->get(self::_REQUEST_GUILD_LOG_REPLY);
    }

    /**
     * Sets value of '_change_server_reply' property
     *
     * @param Down_ChangeServerReply $value Property value
     *
     * @return null
     */
    public function setChangeServerReply(Down_ChangeServerReply $value)
    {
        return $this->set(self::_CHANGE_SERVER_REPLY, $value);
    }

    /**
     * Returns value of '_change_server_reply' property
     *
     * @return Down_ChangeServerReply
     */
    public function getChangeServerReply()
    {
        return $this->get(self::_CHANGE_SERVER_REPLY);
    }

    /**
     * Sets value of '_activity_info_reply' property
     *
     * @param Down_ActivityInfoReply $value Property value
     *
     * @return null
     */
    public function setActivityInfoReply(Down_ActivityInfoReply $value)
    {
        return $this->set(self::_ACTIVITY_INFO_REPLY, $value);
    }

    /**
     * Returns value of '_activity_info_reply' property
     *
     * @return Down_ActivityInfoReply
     */
    public function getActivityInfoReply()
    {
        return $this->get(self::_ACTIVITY_INFO_REPLY);
    }

    /**
     * Sets value of '_activity_lotto_info_reply' property
     *
     * @param Down_ActivityLottoInfoReply $value Property value
     *
     * @return null
     */
    public function setActivityLottoInfoReply(Down_ActivityLottoInfoReply $value)
    {
        return $this->set(self::_ACTIVITY_LOTTO_INFO_REPLY, $value);
    }

    /**
     * Returns value of '_activity_lotto_info_reply' property
     *
     * @return Down_ActivityLottoInfoReply
     */
    public function getActivityLottoInfoReply()
    {
        return $this->get(self::_ACTIVITY_LOTTO_INFO_REPLY);
    }

    /**
     * Sets value of '_activity_lotto_reward_reply' property
     *
     * @param Down_ActivityLottoRewardReply $value Property value
     *
     * @return null
     */
    public function setActivityLottoRewardReply(Down_ActivityLottoRewardReply $value)
    {
        return $this->set(self::_ACTIVITY_LOTTO_REWARD_REPLY, $value);
    }

    /**
     * Returns value of '_activity_lotto_reward_reply' property
     *
     * @return Down_ActivityLottoRewardReply
     */
    public function getActivityLottoRewardReply()
    {
        return $this->get(self::_ACTIVITY_LOTTO_REWARD_REPLY);
    }

    /**
     * Sets value of '_activity_bigpackage_info_reply' property
     *
     * @param Down_ActivityBigpackageInfoReply $value Property value
     *
     * @return null
     */
    public function setActivityBigpackageInfoReply(Down_ActivityBigpackageInfoReply $value)
    {
        return $this->set(self::_ACTIVITY_BIGPACKAGE_INFO_REPLY, $value);
    }

    /**
     * Returns value of '_activity_bigpackage_info_reply' property
     *
     * @return Down_ActivityBigpackageInfoReply
     */
    public function getActivityBigpackageInfoReply()
    {
        return $this->get(self::_ACTIVITY_BIGPACKAGE_INFO_REPLY);
    }

    /**
     * Sets value of '_activity_bigpackage_reward_reply' property
     *
     * @param Down_ActivityBigpackageRewardReply $value Property value
     *
     * @return null
     */
    public function setActivityBigpackageRewardReply(Down_ActivityBigpackageRewardReply $value)
    {
        return $this->set(self::_ACTIVITY_BIGPACKAGE_REWARD_REPLY, $value);
    }

    /**
     * Returns value of '_activity_bigpackage_reward_reply' property
     *
     * @return Down_ActivityBigpackageRewardReply
     */
    public function getActivityBigpackageRewardReply()
    {
        return $this->get(self::_ACTIVITY_BIGPACKAGE_REWARD_REPLY);
    }

    /**
     * Sets value of '_activity_bigpackage_reset_reply' property
     *
     * @param Down_ActivityBigpackageResetReply $value Property value
     *
     * @return null
     */
    public function setActivityBigpackageResetReply(Down_ActivityBigpackageResetReply $value)
    {
        return $this->set(self::_ACTIVITY_BIGPACKAGE_RESET_REPLY, $value);
    }

    /**
     * Returns value of '_activity_bigpackage_reset_reply' property
     *
     * @return Down_ActivityBigpackageResetReply
     */
    public function getActivityBigpackageResetReply()
    {
        return $this->get(self::_ACTIVITY_BIGPACKAGE_RESET_REPLY);
    }

    /**
     * Sets value of '_fb_attention_reply' property
     *
     * @param Down_FbAttentionReply $value Property value
     *
     * @return null
     */
    public function setFbAttentionReply(Down_FbAttentionReply $value)
    {
        return $this->set(self::_FB_ATTENTION_REPLY, $value);
    }

    /**
     * Returns value of '_fb_attention_reply' property
     *
     * @return Down_FbAttentionReply
     */
    public function getFbAttentionReply()
    {
        return $this->get(self::_FB_ATTENTION_REPLY);
    }

    /**
     * Sets value of '_continue_pay_reply' property
     *
     * @param Down_ContinuePayReply $value Property value
     *
     * @return null
     */
    public function setContinuePayReply(Down_ContinuePayReply $value)
    {
        return $this->set(self::_CONTINUE_PAY_REPLY, $value);
    }

    /**
     * Returns value of '_continue_pay_reply' property
     *
     * @return Down_ContinuePayReply
     */
    public function getContinuePayReply()
    {
        return $this->get(self::_CONTINUE_PAY_REPLY);
    }

    /**
     * Sets value of '_recharge_rebate_reply' property
     *
     * @param Down_RechargeRebateReply $value Property value
     *
     * @return null
     */
    public function setRechargeRebateReply(Down_RechargeRebateReply $value)
    {
        return $this->set(self::_RECHARGE_REBATE_REPLY, $value);
    }

    /**
     * Returns value of '_recharge_rebate_reply' property
     *
     * @return Down_RechargeRebateReply
     */
    public function getRechargeRebateReply()
    {
        return $this->get(self::_RECHARGE_REBATE_REPLY);
    }

    /**
     * Sets value of '_every_day_happy_reply' property
     *
     * @param Down_EveryDayHappyReply $value Property value
     *
     * @return null
     */
    public function setEveryDayHappyReply(Down_EveryDayHappyReply $value)
    {
        return $this->set(self::_EVERY_DAY_HAPPY_REPLY, $value);
    }

    /**
     * Returns value of '_every_day_happy_reply' property
     *
     * @return Down_EveryDayHappyReply
     */
    public function getEveryDayHappyReply()
    {
        return $this->get(self::_EVERY_DAY_HAPPY_REPLY);
    }
}

/**
 * system_setting_reply message
 */
class Down_SystemSettingReply extends \ProtobufMessage
{
    /* Field index constants */
    const _REQUEST = 1;
    const _CHANGE = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_REQUEST => array(
            'name' => '_request',
            'required' => false,
            'type' => 'Down_SystemSettingRequest'
        ),
        self::_CHANGE => array(
            'name' => '_change',
            'required' => false,
            'type' => 'Down_SystemSettingChange'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_REQUEST] = null;
        $this->values[self::_CHANGE] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_request' property
     *
     * @param Down_SystemSettingRequest $value Property value
     *
     * @return null
     */
    public function setRequest(Down_SystemSettingRequest $value)
    {
        return $this->set(self::_REQUEST, $value);
    }

    /**
     * Returns value of '_request' property
     *
     * @return Down_SystemSettingRequest
     */
    public function getRequest()
    {
        return $this->get(self::_REQUEST);
    }

    /**
     * Sets value of '_change' property
     *
     * @param Down_SystemSettingChange $value Property value
     *
     * @return null
     */
    public function setChange(Down_SystemSettingChange $value)
    {
        return $this->set(self::_CHANGE, $value);
    }

    /**
     * Returns value of '_change' property
     *
     * @return Down_SystemSettingChange
     */
    public function getChange()
    {
        return $this->get(self::_CHANGE);
    }
}

/**
 * system_setting_change message
 */
class Down_SystemSettingChange extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }
}

/**
 * system_setting_request message
 */
class Down_SystemSettingRequest extends \ProtobufMessage
{
    /* Field index constants */
    const _SYSTEM_SETTING_ITEM = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_SYSTEM_SETTING_ITEM => array(
            'name' => '_system_setting_item',
            'repeated' => true,
            'type' => 'Down_SystemSettingItem'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_SYSTEM_SETTING_ITEM] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_system_setting_item' list
     *
     * @param Down_SystemSettingItem $value Value to append
     *
     * @return null
     */
    public function appendSystemSettingItem(Down_SystemSettingItem $value)
    {
        return $this->append(self::_SYSTEM_SETTING_ITEM, $value);
    }

    /**
     * Clears '_system_setting_item' list
     *
     * @return null
     */
    public function clearSystemSettingItem()
    {
        return $this->clear(self::_SYSTEM_SETTING_ITEM);
    }

    /**
     * Returns '_system_setting_item' list
     *
     * @return Down_SystemSettingItem[]
     */
    public function getSystemSettingItem()
    {
        return $this->get(self::_SYSTEM_SETTING_ITEM);
    }

    /**
     * Returns '_system_setting_item' iterator
     *
     * @return ArrayIterator
     */
    public function getSystemSettingItemIterator()
    {
        return new \ArrayIterator($this->get(self::_SYSTEM_SETTING_ITEM));
    }

    /**
     * Returns element from '_system_setting_item' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_SystemSettingItem
     */
    public function getSystemSettingItemAt($offset)
    {
        return $this->get(self::_SYSTEM_SETTING_ITEM, $offset);
    }

    /**
     * Returns count of '_system_setting_item' list
     *
     * @return int
     */
    public function getSystemSettingItemCount()
    {
        return $this->count(self::_SYSTEM_SETTING_ITEM);
    }
}

/**
 * setting_status enum embedded in system_setting_item message
 */
final class Down_SystemSettingItem_SettingStatus
{
    const on = 1;
    const off = 2;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'on' => self::on,
            'off' => self::off,
        );
    }
}

/**
 * system_setting_item message
 */
class Down_SystemSettingItem extends \ProtobufMessage
{
    /* Field index constants */
    const KEY = 1;
    const VALUE = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::KEY => array(
            'name' => 'key',
            'required' => true,
            'type' => 7,
        ),
        self::VALUE => array(
            'name' => 'value',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::KEY] = null;
        $this->values[self::VALUE] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of 'key' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setKey($value)
    {
        return $this->set(self::KEY, $value);
    }

    /**
     * Returns value of 'key' property
     *
     * @return string
     */
    public function getKey()
    {
        return $this->get(self::KEY);
    }

    /**
     * Sets value of 'value' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setValue($value)
    {
        return $this->set(self::VALUE, $value);
    }

    /**
     * Returns value of 'value' property
     *
     * @return int
     */
    public function getValue()
    {
        return $this->get(self::VALUE);
    }
}

/**
 * global_config message
 */
class Down_GlobalConfig extends \ProtobufMessage
{
    /* Field index constants */
    const _HERO_SPLIT_ENDING = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_HERO_SPLIT_ENDING => array(
            'name' => '_hero_split_ending',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_HERO_SPLIT_ENDING] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_hero_split_ending' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setHeroSplitEnding($value)
    {
        return $this->set(self::_HERO_SPLIT_ENDING, $value);
    }

    /**
     * Returns value of '_hero_split_ending' property
     *
     * @return int
     */
    public function getHeroSplitEnding()
    {
        return $this->get(self::_HERO_SPLIT_ENDING);
    }
}

/**
 * login_reply message
 */
class Down_LoginReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _USER = 2;
    const _TIME_ZONE = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_USER => array(
            'name' => '_user',
            'required' => false,
            'type' => 'Down_User'
        ),
        self::_TIME_ZONE => array(
            'name' => '_time_zone',
            'required' => true,
            'type' => 7,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_USER] = null;
        $this->values[self::_TIME_ZONE] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_user' property
     *
     * @param Down_User $value Property value
     *
     * @return null
     */
    public function setUser(Down_User $value)
    {
        return $this->set(self::_USER, $value);
    }

    /**
     * Returns value of '_user' property
     *
     * @return Down_User
     */
    public function getUser()
    {
        return $this->get(self::_USER);
    }

    /**
     * Sets value of '_time_zone' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setTimeZone($value)
    {
        return $this->set(self::_TIME_ZONE, $value);
    }

    /**
     * Returns value of '_time_zone' property
     *
     * @return string
     */
    public function getTimeZone()
    {
        return $this->get(self::_TIME_ZONE);
    }
}

/**
 * sdk_login_reply message
 */
class Down_SdkLoginReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _UIN = 2;
    const _ACCESS_TOKEN = 3;
    const _RECHARGE_URL = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_Result::fail, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_UIN => array(
            'name' => '_uin',
            'required' => true,
            'type' => 7,
        ),
        self::_ACCESS_TOKEN => array(
            'name' => '_access_token',
            'required' => false,
            'type' => 7,
        ),
        self::_RECHARGE_URL => array(
            'name' => '_recharge_url',
            'required' => false,
            'type' => 7,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_UIN] = null;
        $this->values[self::_ACCESS_TOKEN] = null;
        $this->values[self::_RECHARGE_URL] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_uin' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setUin($value)
    {
        return $this->set(self::_UIN, $value);
    }

    /**
     * Returns value of '_uin' property
     *
     * @return string
     */
    public function getUin()
    {
        return $this->get(self::_UIN);
    }

    /**
     * Sets value of '_access_token' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setAccessToken($value)
    {
        return $this->set(self::_ACCESS_TOKEN, $value);
    }

    /**
     * Returns value of '_access_token' property
     *
     * @return string
     */
    public function getAccessToken()
    {
        return $this->get(self::_ACCESS_TOKEN);
    }

    /**
     * Sets value of '_recharge_url' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setRechargeUrl($value)
    {
        return $this->set(self::_RECHARGE_URL, $value);
    }

    /**
     * Returns value of '_recharge_url' property
     *
     * @return string
     */
    public function getRechargeUrl()
    {
        return $this->get(self::_RECHARGE_URL);
    }
}

/**
 * user_check message
 */
class Down_UserCheck extends \ProtobufMessage
{
    /* Field index constants */
    const _USER = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_USER => array(
            'name' => '_user',
            'required' => true,
            'type' => 'Down_User'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_USER] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_user' property
     *
     * @param Down_User $value Property value
     *
     * @return null
     */
    public function setUser(Down_User $value)
    {
        return $this->set(self::_USER, $value);
    }

    /**
     * Returns value of '_user' property
     *
     * @return Down_User
     */
    public function getUser()
    {
        return $this->get(self::_USER);
    }
}

/**
 * reset message
 */
class Down_Reset extends \ProtobufMessage
{
    /* Field index constants */
    const _USER = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_USER => array(
            'name' => '_user',
            'required' => true,
            'type' => 'Down_User'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_USER] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_user' property
     *
     * @param Down_User $value Property value
     *
     * @return null
     */
    public function setUser(Down_User $value)
    {
        return $this->set(self::_USER, $value);
    }

    /**
     * Returns value of '_user' property
     *
     * @return Down_User
     */
    public function getUser()
    {
        return $this->get(self::_USER);
    }
}

/**
 * enter_stage_reply message
 */
class Down_EnterStageReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RSEED = 1;
    const _LOOTS = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RSEED => array(
            'name' => '_rseed',
            'required' => true,
            'type' => 5,
        ),
        self::_LOOTS => array(
            'name' => '_loots',
            'repeated' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RSEED] = null;
        $this->values[self::_LOOTS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_rseed' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRseed($value)
    {
        return $this->set(self::_RSEED, $value);
    }

    /**
     * Returns value of '_rseed' property
     *
     * @return int
     */
    public function getRseed()
    {
        return $this->get(self::_RSEED);
    }

    /**
     * Appends value to '_loots' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendLoots($value)
    {
        return $this->append(self::_LOOTS, $value);
    }

    /**
     * Clears '_loots' list
     *
     * @return null
     */
    public function clearLoots()
    {
        return $this->clear(self::_LOOTS);
    }

    /**
     * Returns '_loots' list
     *
     * @return int[]
     */
    public function getLoots()
    {
        return $this->get(self::_LOOTS);
    }

    /**
     * Returns '_loots' iterator
     *
     * @return ArrayIterator
     */
    public function getLootsIterator()
    {
        return new \ArrayIterator($this->get(self::_LOOTS));
    }

    /**
     * Returns element from '_loots' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getLootsAt($offset)
    {
        return $this->get(self::_LOOTS, $offset);
    }

    /**
     * Returns count of '_loots' list
     *
     * @return int
     */
    public function getLootsCount()
    {
        return $this->count(self::_LOOTS);
    }
}

/**
 * activity_info_reply message
 */
class Down_ActivityInfoReply extends \ProtobufMessage
{
    /* Field index constants */
    const _LAST_ACTIVITY_INFO = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_LAST_ACTIVITY_INFO => array(
            'name' => '_last_activity_info',
            'repeated' => true,
            'type' => 'Down_LastActivityInfo'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_LAST_ACTIVITY_INFO] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_last_activity_info' list
     *
     * @param Down_LastActivityInfo $value Value to append
     *
     * @return null
     */
    public function appendLastActivityInfo(Down_LastActivityInfo $value)
    {
        return $this->append(self::_LAST_ACTIVITY_INFO, $value);
    }

    /**
     * Clears '_last_activity_info' list
     *
     * @return null
     */
    public function clearLastActivityInfo()
    {
        return $this->clear(self::_LAST_ACTIVITY_INFO);
    }

    /**
     * Returns '_last_activity_info' list
     *
     * @return Down_LastActivityInfo[]
     */
    public function getLastActivityInfo()
    {
        return $this->get(self::_LAST_ACTIVITY_INFO);
    }

    /**
     * Returns '_last_activity_info' iterator
     *
     * @return ArrayIterator
     */
    public function getLastActivityInfoIterator()
    {
        return new \ArrayIterator($this->get(self::_LAST_ACTIVITY_INFO));
    }

    /**
     * Returns element from '_last_activity_info' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_LastActivityInfo
     */
    public function getLastActivityInfoAt($offset)
    {
        return $this->get(self::_LAST_ACTIVITY_INFO, $offset);
    }

    /**
     * Returns count of '_last_activity_info' list
     *
     * @return int
     */
    public function getLastActivityInfoCount()
    {
        return $this->count(self::_LAST_ACTIVITY_INFO);
    }
}

/**
 * last_activity_info message
 */
class Down_LastActivityInfo extends \ProtobufMessage
{
    /* Field index constants */
    const _GROUP_ID = 1;
    const _ACTIVITY_IDS = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_GROUP_ID => array(
            'name' => '_group_id',
            'required' => true,
            'type' => 7,
        ),
        self::_ACTIVITY_IDS => array(
            'name' => '_activity_ids',
            'repeated' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_GROUP_ID] = null;
        $this->values[self::_ACTIVITY_IDS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_group_id' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setGroupId($value)
    {
        return $this->set(self::_GROUP_ID, $value);
    }

    /**
     * Returns value of '_group_id' property
     *
     * @return string
     */
    public function getGroupId()
    {
        return $this->get(self::_GROUP_ID);
    }

    /**
     * Appends value to '_activity_ids' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendActivityIds($value)
    {
        return $this->append(self::_ACTIVITY_IDS, $value);
    }

    /**
     * Clears '_activity_ids' list
     *
     * @return null
     */
    public function clearActivityIds()
    {
        return $this->clear(self::_ACTIVITY_IDS);
    }

    /**
     * Returns '_activity_ids' list
     *
     * @return int[]
     */
    public function getActivityIds()
    {
        return $this->get(self::_ACTIVITY_IDS);
    }

    /**
     * Returns '_activity_ids' iterator
     *
     * @return ArrayIterator
     */
    public function getActivityIdsIterator()
    {
        return new \ArrayIterator($this->get(self::_ACTIVITY_IDS));
    }

    /**
     * Returns element from '_activity_ids' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getActivityIdsAt($offset)
    {
        return $this->get(self::_ACTIVITY_IDS, $offset);
    }

    /**
     * Returns count of '_activity_ids' list
     *
     * @return int
     */
    public function getActivityIdsCount()
    {
        return $this->count(self::_ACTIVITY_IDS);
    }
}

/**
 * activity_lotto_info_reply message
 */
class Down_ActivityLottoInfoReply extends \ProtobufMessage
{
    /* Field index constants */
    const _DIAMOND_NUM = 1;
    const _CURRENT_STEP = 2;
    const _NEED_DIAMOND_NUM = 3;
    const _WIN_DIAMOND_NUM = 4;
    const _REMAIN_TIME = 5;
    const _BROADCAST_TEXTS = 6;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_DIAMOND_NUM => array(
            'name' => '_diamond_num',
            'required' => true,
            'type' => 5,
        ),
        self::_CURRENT_STEP => array(
            'name' => '_current_step',
            'required' => true,
            'type' => 5,
        ),
        self::_NEED_DIAMOND_NUM => array(
            'name' => '_need_diamond_num',
            'required' => true,
            'type' => 5,
        ),
        self::_WIN_DIAMOND_NUM => array(
            'name' => '_win_diamond_num',
            'required' => true,
            'type' => 5,
        ),
        self::_REMAIN_TIME => array(
            'name' => '_remain_time',
            'required' => true,
            'type' => 5,
        ),
        self::_BROADCAST_TEXTS => array(
            'name' => '_broadcast_texts',
            'repeated' => true,
            'type' => 7,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_DIAMOND_NUM] = null;
        $this->values[self::_CURRENT_STEP] = null;
        $this->values[self::_NEED_DIAMOND_NUM] = null;
        $this->values[self::_WIN_DIAMOND_NUM] = null;
        $this->values[self::_REMAIN_TIME] = null;
        $this->values[self::_BROADCAST_TEXTS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_diamond_num' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setDiamondNum($value)
    {
        return $this->set(self::_DIAMOND_NUM, $value);
    }

    /**
     * Returns value of '_diamond_num' property
     *
     * @return int
     */
    public function getDiamondNum()
    {
        return $this->get(self::_DIAMOND_NUM);
    }

    /**
     * Sets value of '_current_step' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCurrentStep($value)
    {
        return $this->set(self::_CURRENT_STEP, $value);
    }

    /**
     * Returns value of '_current_step' property
     *
     * @return int
     */
    public function getCurrentStep()
    {
        return $this->get(self::_CURRENT_STEP);
    }

    /**
     * Sets value of '_need_diamond_num' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setNeedDiamondNum($value)
    {
        return $this->set(self::_NEED_DIAMOND_NUM, $value);
    }

    /**
     * Returns value of '_need_diamond_num' property
     *
     * @return int
     */
    public function getNeedDiamondNum()
    {
        return $this->get(self::_NEED_DIAMOND_NUM);
    }

    /**
     * Sets value of '_win_diamond_num' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setWinDiamondNum($value)
    {
        return $this->set(self::_WIN_DIAMOND_NUM, $value);
    }

    /**
     * Returns value of '_win_diamond_num' property
     *
     * @return int
     */
    public function getWinDiamondNum()
    {
        return $this->get(self::_WIN_DIAMOND_NUM);
    }

    /**
     * Sets value of '_remain_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRemainTime($value)
    {
        return $this->set(self::_REMAIN_TIME, $value);
    }

    /**
     * Returns value of '_remain_time' property
     *
     * @return int
     */
    public function getRemainTime()
    {
        return $this->get(self::_REMAIN_TIME);
    }

    /**
     * Appends value to '_broadcast_texts' list
     *
     * @param string $value Value to append
     *
     * @return null
     */
    public function appendBroadcastTexts($value)
    {
        return $this->append(self::_BROADCAST_TEXTS, $value);
    }

    /**
     * Clears '_broadcast_texts' list
     *
     * @return null
     */
    public function clearBroadcastTexts()
    {
        return $this->clear(self::_BROADCAST_TEXTS);
    }

    /**
     * Returns '_broadcast_texts' list
     *
     * @return string[]
     */
    public function getBroadcastTexts()
    {
        return $this->get(self::_BROADCAST_TEXTS);
    }

    /**
     * Returns '_broadcast_texts' iterator
     *
     * @return ArrayIterator
     */
    public function getBroadcastTextsIterator()
    {
        return new \ArrayIterator($this->get(self::_BROADCAST_TEXTS));
    }

    /**
     * Returns element from '_broadcast_texts' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return string
     */
    public function getBroadcastTextsAt($offset)
    {
        return $this->get(self::_BROADCAST_TEXTS, $offset);
    }

    /**
     * Returns count of '_broadcast_texts' list
     *
     * @return int
     */
    public function getBroadcastTextsCount()
    {
        return $this->count(self::_BROADCAST_TEXTS);
    }
}

/**
 * activity_lotto_reward_reply message
 */
class Down_ActivityLottoRewardReply extends \ProtobufMessage
{
    /* Field index constants */
    const _STATUS = 1;
    const _REWARD_DIAMON_NUM = 2;
    const _HAVE_NEXT_ROUND = 3;
    const _NEED_DIAMOND_NUM = 4;
    const _DIAMOND_NUM = 5;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_STATUS => array(
            'name' => '_status',
            'required' => true,
            'type' => 5,
        ),
        self::_REWARD_DIAMON_NUM => array(
            'name' => '_reward_diamon_num',
            'required' => true,
            'type' => 5,
        ),
        self::_HAVE_NEXT_ROUND => array(
            'name' => '_have_next_round',
            'required' => true,
            'type' => 5,
        ),
        self::_NEED_DIAMOND_NUM => array(
            'name' => '_need_diamond_num',
            'required' => false,
            'type' => 5,
        ),
        self::_DIAMOND_NUM => array(
            'name' => '_diamond_num',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_STATUS] = null;
        $this->values[self::_REWARD_DIAMON_NUM] = null;
        $this->values[self::_HAVE_NEXT_ROUND] = null;
        $this->values[self::_NEED_DIAMOND_NUM] = null;
        $this->values[self::_DIAMOND_NUM] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_status' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStatus($value)
    {
        return $this->set(self::_STATUS, $value);
    }

    /**
     * Returns value of '_status' property
     *
     * @return int
     */
    public function getStatus()
    {
        return $this->get(self::_STATUS);
    }

    /**
     * Sets value of '_reward_diamon_num' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRewardDiamonNum($value)
    {
        return $this->set(self::_REWARD_DIAMON_NUM, $value);
    }

    /**
     * Returns value of '_reward_diamon_num' property
     *
     * @return int
     */
    public function getRewardDiamonNum()
    {
        return $this->get(self::_REWARD_DIAMON_NUM);
    }

    /**
     * Sets value of '_have_next_round' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setHaveNextRound($value)
    {
        return $this->set(self::_HAVE_NEXT_ROUND, $value);
    }

    /**
     * Returns value of '_have_next_round' property
     *
     * @return int
     */
    public function getHaveNextRound()
    {
        return $this->get(self::_HAVE_NEXT_ROUND);
    }

    /**
     * Sets value of '_need_diamond_num' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setNeedDiamondNum($value)
    {
        return $this->set(self::_NEED_DIAMOND_NUM, $value);
    }

    /**
     * Returns value of '_need_diamond_num' property
     *
     * @return int
     */
    public function getNeedDiamondNum()
    {
        return $this->get(self::_NEED_DIAMOND_NUM);
    }

    /**
     * Sets value of '_diamond_num' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setDiamondNum($value)
    {
        return $this->set(self::_DIAMOND_NUM, $value);
    }

    /**
     * Returns value of '_diamond_num' property
     *
     * @return int
     */
    public function getDiamondNum()
    {
        return $this->get(self::_DIAMOND_NUM);
    }
}

/**
 * activity_bigpackage_info_reply message
 */
class Down_ActivityBigpackageInfoReply extends \ProtobufMessage
{
    /* Field index constants */
    const _PEOPLE_COUNT = 1;
    const _REMAIN_TIMES = 2;
    const _NEXT_RESET_PRICE = 3;
    const _CURRENT_RANKING = 4;
    const _GET_BOX_IDS = 5;
    const _DISTANCE_SCORE_20 = 6;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_PEOPLE_COUNT => array(
            'name' => '_people_count',
            'required' => true,
            'type' => 5,
        ),
        self::_REMAIN_TIMES => array(
            'name' => '_remain_times',
            'required' => true,
            'type' => 5,
        ),
        self::_NEXT_RESET_PRICE => array(
            'name' => '_next_reset_price',
            'required' => true,
            'type' => 5,
        ),
        self::_CURRENT_RANKING => array(
            'name' => '_current_ranking',
            'required' => true,
            'type' => 5,
        ),
        self::_GET_BOX_IDS => array(
            'name' => '_get_box_ids',
            'repeated' => true,
            'type' => 5,
        ),
        self::_DISTANCE_SCORE_20 => array(
            'name' => '_distance_score_20',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_PEOPLE_COUNT] = null;
        $this->values[self::_REMAIN_TIMES] = null;
        $this->values[self::_NEXT_RESET_PRICE] = null;
        $this->values[self::_CURRENT_RANKING] = null;
        $this->values[self::_GET_BOX_IDS] = array();
        $this->values[self::_DISTANCE_SCORE_20] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_people_count' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setPeopleCount($value)
    {
        return $this->set(self::_PEOPLE_COUNT, $value);
    }

    /**
     * Returns value of '_people_count' property
     *
     * @return int
     */
    public function getPeopleCount()
    {
        return $this->get(self::_PEOPLE_COUNT);
    }

    /**
     * Sets value of '_remain_times' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRemainTimes($value)
    {
        return $this->set(self::_REMAIN_TIMES, $value);
    }

    /**
     * Returns value of '_remain_times' property
     *
     * @return int
     */
    public function getRemainTimes()
    {
        return $this->get(self::_REMAIN_TIMES);
    }

    /**
     * Sets value of '_next_reset_price' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setNextResetPrice($value)
    {
        return $this->set(self::_NEXT_RESET_PRICE, $value);
    }

    /**
     * Returns value of '_next_reset_price' property
     *
     * @return int
     */
    public function getNextResetPrice()
    {
        return $this->get(self::_NEXT_RESET_PRICE);
    }

    /**
     * Sets value of '_current_ranking' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCurrentRanking($value)
    {
        return $this->set(self::_CURRENT_RANKING, $value);
    }

    /**
     * Returns value of '_current_ranking' property
     *
     * @return int
     */
    public function getCurrentRanking()
    {
        return $this->get(self::_CURRENT_RANKING);
    }

    /**
     * Appends value to '_get_box_ids' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendGetBoxIds($value)
    {
        return $this->append(self::_GET_BOX_IDS, $value);
    }

    /**
     * Clears '_get_box_ids' list
     *
     * @return null
     */
    public function clearGetBoxIds()
    {
        return $this->clear(self::_GET_BOX_IDS);
    }

    /**
     * Returns '_get_box_ids' list
     *
     * @return int[]
     */
    public function getGetBoxIds()
    {
        return $this->get(self::_GET_BOX_IDS);
    }

    /**
     * Returns '_get_box_ids' iterator
     *
     * @return ArrayIterator
     */
    public function getGetBoxIdsIterator()
    {
        return new \ArrayIterator($this->get(self::_GET_BOX_IDS));
    }

    /**
     * Returns element from '_get_box_ids' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getGetBoxIdsAt($offset)
    {
        return $this->get(self::_GET_BOX_IDS, $offset);
    }

    /**
     * Returns count of '_get_box_ids' list
     *
     * @return int
     */
    public function getGetBoxIdsCount()
    {
        return $this->count(self::_GET_BOX_IDS);
    }

    /**
     * Sets value of '_distance_score_20' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setDistanceScore20($value)
    {
        return $this->set(self::_DISTANCE_SCORE_20, $value);
    }

    /**
     * Returns value of '_distance_score_20' property
     *
     * @return int
     */
    public function getDistanceScore20()
    {
        return $this->get(self::_DISTANCE_SCORE_20);
    }
}

/**
 * activity_bigpackage_reward_reply message
 */
class Down_ActivityBigpackageRewardReply extends \ProtobufMessage
{
    /* Field index constants */
    const _STATUS = 1;
    const _REWARDS = 2;
    const _ITEM_IDS = 3;
    const _PEOPLE_COUNT = 4;
    const _CURRENT_RANKING = 5;
    const _DISTANCE_SCORE_20 = 6;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_STATUS => array(
            'name' => '_status',
            'required' => true,
            'type' => 5,
        ),
        self::_REWARDS => array(
            'name' => '_rewards',
            'repeated' => true,
            'type' => 'Down_ActivityReward'
        ),
        self::_ITEM_IDS => array(
            'name' => '_item_ids',
            'repeated' => true,
            'type' => 5,
        ),
        self::_PEOPLE_COUNT => array(
            'name' => '_people_count',
            'required' => true,
            'type' => 5,
        ),
        self::_CURRENT_RANKING => array(
            'name' => '_current_ranking',
            'required' => true,
            'type' => 5,
        ),
        self::_DISTANCE_SCORE_20 => array(
            'name' => '_distance_score_20',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_STATUS] = null;
        $this->values[self::_REWARDS] = array();
        $this->values[self::_ITEM_IDS] = array();
        $this->values[self::_PEOPLE_COUNT] = null;
        $this->values[self::_CURRENT_RANKING] = null;
        $this->values[self::_DISTANCE_SCORE_20] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_status' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStatus($value)
    {
        return $this->set(self::_STATUS, $value);
    }

    /**
     * Returns value of '_status' property
     *
     * @return int
     */
    public function getStatus()
    {
        return $this->get(self::_STATUS);
    }

    /**
     * Appends value to '_rewards' list
     *
     * @param Down_ActivityReward $value Value to append
     *
     * @return null
     */
    public function appendRewards(Down_ActivityReward $value)
    {
        return $this->append(self::_REWARDS, $value);
    }

    /**
     * Clears '_rewards' list
     *
     * @return null
     */
    public function clearRewards()
    {
        return $this->clear(self::_REWARDS);
    }

    /**
     * Returns '_rewards' list
     *
     * @return Down_ActivityReward[]
     */
    public function getRewards()
    {
        return $this->get(self::_REWARDS);
    }

    /**
     * Returns '_rewards' iterator
     *
     * @return ArrayIterator
     */
    public function getRewardsIterator()
    {
        return new \ArrayIterator($this->get(self::_REWARDS));
    }

    /**
     * Returns element from '_rewards' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_ActivityReward
     */
    public function getRewardsAt($offset)
    {
        return $this->get(self::_REWARDS, $offset);
    }

    /**
     * Returns count of '_rewards' list
     *
     * @return int
     */
    public function getRewardsCount()
    {
        return $this->count(self::_REWARDS);
    }

    /**
     * Appends value to '_item_ids' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendItemIds($value)
    {
        return $this->append(self::_ITEM_IDS, $value);
    }

    /**
     * Clears '_item_ids' list
     *
     * @return null
     */
    public function clearItemIds()
    {
        return $this->clear(self::_ITEM_IDS);
    }

    /**
     * Returns '_item_ids' list
     *
     * @return int[]
     */
    public function getItemIds()
    {
        return $this->get(self::_ITEM_IDS);
    }

    /**
     * Returns '_item_ids' iterator
     *
     * @return ArrayIterator
     */
    public function getItemIdsIterator()
    {
        return new \ArrayIterator($this->get(self::_ITEM_IDS));
    }

    /**
     * Returns element from '_item_ids' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getItemIdsAt($offset)
    {
        return $this->get(self::_ITEM_IDS, $offset);
    }

    /**
     * Returns count of '_item_ids' list
     *
     * @return int
     */
    public function getItemIdsCount()
    {
        return $this->count(self::_ITEM_IDS);
    }

    /**
     * Sets value of '_people_count' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setPeopleCount($value)
    {
        return $this->set(self::_PEOPLE_COUNT, $value);
    }

    /**
     * Returns value of '_people_count' property
     *
     * @return int
     */
    public function getPeopleCount()
    {
        return $this->get(self::_PEOPLE_COUNT);
    }

    /**
     * Sets value of '_current_ranking' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCurrentRanking($value)
    {
        return $this->set(self::_CURRENT_RANKING, $value);
    }

    /**
     * Returns value of '_current_ranking' property
     *
     * @return int
     */
    public function getCurrentRanking()
    {
        return $this->get(self::_CURRENT_RANKING);
    }

    /**
     * Sets value of '_distance_score_20' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setDistanceScore20($value)
    {
        return $this->set(self::_DISTANCE_SCORE_20, $value);
    }

    /**
     * Returns value of '_distance_score_20' property
     *
     * @return int
     */
    public function getDistanceScore20()
    {
        return $this->get(self::_DISTANCE_SCORE_20);
    }
}

/**
 * activity_bigpackage_reset_reply message
 */
class Down_ActivityBigpackageResetReply extends \ProtobufMessage
{
    /* Field index constants */
    const _STATUS = 1;
    const _NEXT_RESET_PRICE = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_STATUS => array(
            'name' => '_status',
            'required' => true,
            'type' => 5,
        ),
        self::_NEXT_RESET_PRICE => array(
            'name' => '_next_reset_price',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_STATUS] = null;
        $this->values[self::_NEXT_RESET_PRICE] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_status' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStatus($value)
    {
        return $this->set(self::_STATUS, $value);
    }

    /**
     * Returns value of '_status' property
     *
     * @return int
     */
    public function getStatus()
    {
        return $this->get(self::_STATUS);
    }

    /**
     * Sets value of '_next_reset_price' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setNextResetPrice($value)
    {
        return $this->set(self::_NEXT_RESET_PRICE, $value);
    }

    /**
     * Returns value of '_next_reset_price' property
     *
     * @return int
     */
    public function getNextResetPrice()
    {
        return $this->get(self::_NEXT_RESET_PRICE);
    }
}

/**
 * exit_stage_result enum embedded in exit_stage_reply message
 */
final class Down_ExitStageReply_ExitStageResult
{
    const known = 0;
    const unknown = 1;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'known' => self::known,
            'unknown' => self::unknown,
        );
    }
}

/**
 * exit_stage_reply message
 */
class Down_ExitStageReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _SHOP = 2;
    const _SSHOP = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_ExitStageReply_ExitStageResult::known, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_SHOP => array(
            'name' => '_shop',
            'required' => false,
            'type' => 'Down_UserShop'
        ),
        self::_SSHOP => array(
            'name' => '_sshop',
            'required' => false,
            'type' => 'Down_StarShop'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_SHOP] = null;
        $this->values[self::_SSHOP] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_shop' property
     *
     * @param Down_UserShop $value Property value
     *
     * @return null
     */
    public function setShop(Down_UserShop $value)
    {
        return $this->set(self::_SHOP, $value);
    }

    /**
     * Returns value of '_shop' property
     *
     * @return Down_UserShop
     */
    public function getShop()
    {
        return $this->get(self::_SHOP);
    }

    /**
     * Sets value of '_sshop' property
     *
     * @param Down_StarShop $value Property value
     *
     * @return null
     */
    public function setSshop(Down_StarShop $value)
    {
        return $this->set(self::_SSHOP, $value);
    }

    /**
     * Returns value of '_sshop' property
     *
     * @return Down_StarShop
     */
    public function getSshop()
    {
        return $this->get(self::_SSHOP);
    }
}

/**
 * hero_upgrade_reply message
 */
class Down_HeroUpgradeReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _HERO = 2;
    const _ITEMS = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_Result::fail, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_HERO => array(
            'name' => '_hero',
            'required' => false,
            'type' => 'Down_Hero'
        ),
        self::_ITEMS => array(
            'name' => '_items',
            'repeated' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_HERO] = null;
        $this->values[self::_ITEMS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_hero' property
     *
     * @param Down_Hero $value Property value
     *
     * @return null
     */
    public function setHero(Down_Hero $value)
    {
        return $this->set(self::_HERO, $value);
    }

    /**
     * Returns value of '_hero' property
     *
     * @return Down_Hero
     */
    public function getHero()
    {
        return $this->get(self::_HERO);
    }

    /**
     * Appends value to '_items' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendItems($value)
    {
        return $this->append(self::_ITEMS, $value);
    }

    /**
     * Clears '_items' list
     *
     * @return null
     */
    public function clearItems()
    {
        return $this->clear(self::_ITEMS);
    }

    /**
     * Returns '_items' list
     *
     * @return int[]
     */
    public function getItems()
    {
        return $this->get(self::_ITEMS);
    }

    /**
     * Returns '_items' iterator
     *
     * @return ArrayIterator
     */
    public function getItemsIterator()
    {
        return new \ArrayIterator($this->get(self::_ITEMS));
    }

    /**
     * Returns element from '_items' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getItemsAt($offset)
    {
        return $this->get(self::_ITEMS, $offset);
    }

    /**
     * Returns count of '_items' list
     *
     * @return int
     */
    public function getItemsCount()
    {
        return $this->count(self::_ITEMS);
    }
}

/**
 * equip_synthesis_reply message
 */
class Down_EquipSynthesisReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_Result::fail, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }
}

/**
 * wear_equip_reply message
 */
class Down_WearEquipReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _GS = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_Result::fail, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_GS => array(
            'name' => '_gs',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_GS] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_gs' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setGs($value)
    {
        return $this->set(self::_GS, $value);
    }

    /**
     * Returns value of '_gs' property
     *
     * @return int
     */
    public function getGs()
    {
        return $this->get(self::_GS);
    }
}

/**
 * sync_vitality_reply message
 */
class Down_SyncVitalityReply extends \ProtobufMessage
{
    /* Field index constants */
    const _VITALITY = 1;
    const _SHADOW_RUNES = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_VITALITY => array(
            'name' => '_vitality',
            'required' => true,
            'type' => 'Down_Vitality'
        ),
        self::_SHADOW_RUNES => array(
            'name' => '_shadow_runes',
            'required' => true,
            'type' => 'Down_Vitality'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_VITALITY] = null;
        $this->values[self::_SHADOW_RUNES] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_vitality' property
     *
     * @param Down_Vitality $value Property value
     *
     * @return null
     */
    public function setVitality(Down_Vitality $value)
    {
        return $this->set(self::_VITALITY, $value);
    }

    /**
     * Returns value of '_vitality' property
     *
     * @return Down_Vitality
     */
    public function getVitality()
    {
        return $this->get(self::_VITALITY);
    }

    /**
     * Sets value of '_shadow_runes' property
     *
     * @param Down_Vitality $value Property value
     *
     * @return null
     */
    public function setShadowRunes(Down_Vitality $value)
    {
        return $this->set(self::_SHADOW_RUNES, $value);
    }

    /**
     * Returns value of '_shadow_runes' property
     *
     * @return Down_Vitality
     */
    public function getShadowRunes()
    {
        return $this->get(self::_SHADOW_RUNES);
    }
}

/**
 * consume_item_reply message
 */
class Down_ConsumeItemReply extends \ProtobufMessage
{
    /* Field index constants */
    const _HERO = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_HERO => array(
            'name' => '_hero',
            'required' => true,
            'type' => 'Down_Hero'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_HERO] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_hero' property
     *
     * @param Down_Hero $value Property value
     *
     * @return null
     */
    public function setHero(Down_Hero $value)
    {
        return $this->set(self::_HERO, $value);
    }

    /**
     * Returns value of '_hero' property
     *
     * @return Down_Hero
     */
    public function getHero()
    {
        return $this->get(self::_HERO);
    }
}

/**
 * user_shop message
 */
class Down_UserShop extends \ProtobufMessage
{
    /* Field index constants */
    const _ID = 1;
    const _LAST_AUTO_REFRESH_TIME = 2;
    const _EXPIRE_TIME = 3;
    const _LAST_MANUAL_REFRESH_TIME = 4;
    const _TODAY_TIMES = 5;
    const _CURRENT_GOODS = 6;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ID => array(
            'name' => '_id',
            'required' => true,
            'type' => 5,
        ),
        self::_LAST_AUTO_REFRESH_TIME => array(
            'name' => '_last_auto_refresh_time',
            'required' => false,
            'type' => 5,
        ),
        self::_EXPIRE_TIME => array(
            'name' => '_expire_time',
            'required' => false,
            'type' => 5,
        ),
        self::_LAST_MANUAL_REFRESH_TIME => array(
            'name' => '_last_manual_refresh_time',
            'required' => false,
            'type' => 5,
        ),
        self::_TODAY_TIMES => array(
            'name' => '_today_times',
            'required' => false,
            'type' => 5,
        ),
        self::_CURRENT_GOODS => array(
            'name' => '_current_goods',
            'repeated' => true,
            'type' => 'Down_Goods'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ID] = null;
        $this->values[self::_LAST_AUTO_REFRESH_TIME] = null;
        $this->values[self::_EXPIRE_TIME] = null;
        $this->values[self::_LAST_MANUAL_REFRESH_TIME] = null;
        $this->values[self::_TODAY_TIMES] = null;
        $this->values[self::_CURRENT_GOODS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setId($value)
    {
        return $this->set(self::_ID, $value);
    }

    /**
     * Returns value of '_id' property
     *
     * @return int
     */
    public function getId()
    {
        return $this->get(self::_ID);
    }

    /**
     * Sets value of '_last_auto_refresh_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLastAutoRefreshTime($value)
    {
        return $this->set(self::_LAST_AUTO_REFRESH_TIME, $value);
    }

    /**
     * Returns value of '_last_auto_refresh_time' property
     *
     * @return int
     */
    public function getLastAutoRefreshTime()
    {
        return $this->get(self::_LAST_AUTO_REFRESH_TIME);
    }

    /**
     * Sets value of '_expire_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setExpireTime($value)
    {
        return $this->set(self::_EXPIRE_TIME, $value);
    }

    /**
     * Returns value of '_expire_time' property
     *
     * @return int
     */
    public function getExpireTime()
    {
        return $this->get(self::_EXPIRE_TIME);
    }

    /**
     * Sets value of '_last_manual_refresh_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLastManualRefreshTime($value)
    {
        return $this->set(self::_LAST_MANUAL_REFRESH_TIME, $value);
    }

    /**
     * Returns value of '_last_manual_refresh_time' property
     *
     * @return int
     */
    public function getLastManualRefreshTime()
    {
        return $this->get(self::_LAST_MANUAL_REFRESH_TIME);
    }

    /**
     * Sets value of '_today_times' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setTodayTimes($value)
    {
        return $this->set(self::_TODAY_TIMES, $value);
    }

    /**
     * Returns value of '_today_times' property
     *
     * @return int
     */
    public function getTodayTimes()
    {
        return $this->get(self::_TODAY_TIMES);
    }

    /**
     * Appends value to '_current_goods' list
     *
     * @param Down_Goods $value Value to append
     *
     * @return null
     */
    public function appendCurrentGoods(Down_Goods $value)
    {
        return $this->append(self::_CURRENT_GOODS, $value);
    }

    /**
     * Clears '_current_goods' list
     *
     * @return null
     */
    public function clearCurrentGoods()
    {
        return $this->clear(self::_CURRENT_GOODS);
    }

    /**
     * Returns '_current_goods' list
     *
     * @return Down_Goods[]
     */
    public function getCurrentGoods()
    {
        return $this->get(self::_CURRENT_GOODS);
    }

    /**
     * Returns '_current_goods' iterator
     *
     * @return ArrayIterator
     */
    public function getCurrentGoodsIterator()
    {
        return new \ArrayIterator($this->get(self::_CURRENT_GOODS));
    }

    /**
     * Returns element from '_current_goods' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_Goods
     */
    public function getCurrentGoodsAt($offset)
    {
        return $this->get(self::_CURRENT_GOODS, $offset);
    }

    /**
     * Returns count of '_current_goods' list
     *
     * @return int
     */
    public function getCurrentGoodsCount()
    {
        return $this->count(self::_CURRENT_GOODS);
    }
}

/**
 * star_shop message
 */
class Down_StarShop extends \ProtobufMessage
{
    /* Field index constants */
    const _ID = 1;
    const _EXPIRE_TIME = 2;
    const _STAR_GOODS = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ID => array(
            'name' => '_id',
            'required' => true,
            'type' => 5,
        ),
        self::_EXPIRE_TIME => array(
            'name' => '_expire_time',
            'required' => false,
            'type' => 5,
        ),
        self::_STAR_GOODS => array(
            'name' => '_star_goods',
            'repeated' => true,
            'type' => 'Down_StarGoods'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ID] = null;
        $this->values[self::_EXPIRE_TIME] = null;
        $this->values[self::_STAR_GOODS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setId($value)
    {
        return $this->set(self::_ID, $value);
    }

    /**
     * Returns value of '_id' property
     *
     * @return int
     */
    public function getId()
    {
        return $this->get(self::_ID);
    }

    /**
     * Sets value of '_expire_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setExpireTime($value)
    {
        return $this->set(self::_EXPIRE_TIME, $value);
    }

    /**
     * Returns value of '_expire_time' property
     *
     * @return int
     */
    public function getExpireTime()
    {
        return $this->get(self::_EXPIRE_TIME);
    }

    /**
     * Appends value to '_star_goods' list
     *
     * @param Down_StarGoods $value Value to append
     *
     * @return null
     */
    public function appendStarGoods(Down_StarGoods $value)
    {
        return $this->append(self::_STAR_GOODS, $value);
    }

    /**
     * Clears '_star_goods' list
     *
     * @return null
     */
    public function clearStarGoods()
    {
        return $this->clear(self::_STAR_GOODS);
    }

    /**
     * Returns '_star_goods' list
     *
     * @return Down_StarGoods[]
     */
    public function getStarGoods()
    {
        return $this->get(self::_STAR_GOODS);
    }

    /**
     * Returns '_star_goods' iterator
     *
     * @return ArrayIterator
     */
    public function getStarGoodsIterator()
    {
        return new \ArrayIterator($this->get(self::_STAR_GOODS));
    }

    /**
     * Returns element from '_star_goods' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_StarGoods
     */
    public function getStarGoodsAt($offset)
    {
        return $this->get(self::_STAR_GOODS, $offset);
    }

    /**
     * Returns count of '_star_goods' list
     *
     * @return int
     */
    public function getStarGoodsCount()
    {
        return $this->count(self::_STAR_GOODS);
    }
}

/**
 * shop_consume_reply message
 */
class Down_ShopConsumeReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_Result::success, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }
}

/**
 * skill_levelup_reply message
 */
class Down_SkillLevelupReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _GS = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_Result::fail, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_GS => array(
            'name' => '_gs',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_GS] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_gs' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setGs($value)
    {
        return $this->set(self::_GS, $value);
    }

    /**
     * Returns value of '_gs' property
     *
     * @return int
     */
    public function getGs()
    {
        return $this->get(self::_GS);
    }
}

/**
 * sell_item_reply message
 */
class Down_SellItemReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_Result::success, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }
}

/**
 * fragment_compose_reply message
 */
class Down_FragmentComposeReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_Result::fail, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }
}

/**
 * hero_equip_upgrade_reply message
 */
class Down_HeroEquipUpgradeReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _HERO = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_Result::fail, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_HERO => array(
            'name' => '_hero',
            'required' => false,
            'type' => 'Down_Hero'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_HERO] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_hero' property
     *
     * @param Down_Hero $value Property value
     *
     * @return null
     */
    public function setHero(Down_Hero $value)
    {
        return $this->set(self::_HERO, $value);
    }

    /**
     * Returns value of '_hero' property
     *
     * @return Down_Hero
     */
    public function getHero()
    {
        return $this->get(self::_HERO);
    }
}

/**
 * tutorial_reply message
 */
class Down_TutorialReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_Result::success, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }
}

/**
 * exit enum embedded in error_info message
 */
final class Down_ErrorInfo_Exit
{
    const noneed = 0;
    const force = 1;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'noneed' => self::noneed,
            'force' => self::force,
        );
    }
}

/**
 * error_info message
 */
class Down_ErrorInfo extends \ProtobufMessage
{
    /* Field index constants */
    const _INFO = 1;
    const _EXIT = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_INFO => array(
            'name' => '_info',
            'required' => true,
            'type' => 7,
        ),
        self::_EXIT => array(
            'default' => Down_ErrorInfo_Exit::noneed, 
            'name' => '_exit',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_INFO] = null;
        $this->values[self::_EXIT] = Down_ErrorInfo_Exit::noneed;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_info' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setInfo($value)
    {
        return $this->set(self::_INFO, $value);
    }

    /**
     * Returns value of '_info' property
     *
     * @return string
     */
    public function getInfo()
    {
        return $this->get(self::_INFO);
    }

    /**
     * Sets value of '_exit' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setExit($value)
    {
        return $this->set(self::_EXIT, $value);
    }

    /**
     * Returns value of '_exit' property
     *
     * @return int
     */
    public function getExit()
    {
        return $this->get(self::_EXIT);
    }
}

/**
 * price_type enum embedded in goods message
 */
final class Down_Goods_PriceType
{
    const gold = 0;
    const diamond = 1;
    const crusadepoint = 2;
    const arenapoint = 3;
    const guildpoint = 4;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'gold' => self::gold,
            'diamond' => self::diamond,
            'crusadepoint' => self::crusadepoint,
            'arenapoint' => self::arenapoint,
            'guildpoint' => self::guildpoint,
        );
    }
}

/**
 * goods message
 */
class Down_Goods extends \ProtobufMessage
{
    /* Field index constants */
    const _ID = 1;
    const _AMOUNT = 2;
    const _TYPE = 3;
    const _PRICE = 4;
    const _IS_SALE = 5;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ID => array(
            'name' => '_id',
            'required' => true,
            'type' => 5,
        ),
        self::_AMOUNT => array(
            'name' => '_amount',
            'required' => true,
            'type' => 5,
        ),
        self::_TYPE => array(
            'name' => '_type',
            'required' => true,
            'type' => 5,
        ),
        self::_PRICE => array(
            'name' => '_price',
            'required' => true,
            'type' => 5,
        ),
        self::_IS_SALE => array(
            'name' => '_is_sale',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ID] = null;
        $this->values[self::_AMOUNT] = null;
        $this->values[self::_TYPE] = null;
        $this->values[self::_PRICE] = null;
        $this->values[self::_IS_SALE] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setId($value)
    {
        return $this->set(self::_ID, $value);
    }

    /**
     * Returns value of '_id' property
     *
     * @return int
     */
    public function getId()
    {
        return $this->get(self::_ID);
    }

    /**
     * Sets value of '_amount' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setAmount($value)
    {
        return $this->set(self::_AMOUNT, $value);
    }

    /**
     * Returns value of '_amount' property
     *
     * @return int
     */
    public function getAmount()
    {
        return $this->get(self::_AMOUNT);
    }

    /**
     * Sets value of '_type' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setType($value)
    {
        return $this->set(self::_TYPE, $value);
    }

    /**
     * Returns value of '_type' property
     *
     * @return int
     */
    public function getType()
    {
        return $this->get(self::_TYPE);
    }

    /**
     * Sets value of '_price' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setPrice($value)
    {
        return $this->set(self::_PRICE, $value);
    }

    /**
     * Returns value of '_price' property
     *
     * @return int
     */
    public function getPrice()
    {
        return $this->get(self::_PRICE);
    }

    /**
     * Sets value of '_is_sale' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setIsSale($value)
    {
        return $this->set(self::_IS_SALE, $value);
    }

    /**
     * Returns value of '_is_sale' property
     *
     * @return int
     */
    public function getIsSale()
    {
        return $this->get(self::_IS_SALE);
    }
}

/**
 * box_type enum embedded in star_goods message
 */
final class Down_StarGoods_BoxType
{
    const stone_green = 0;
    const stone_blue = 1;
    const stone_purple = 2;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'stone_green' => self::stone_green,
            'stone_blue' => self::stone_blue,
            'stone_purple' => self::stone_purple,
        );
    }
}

/**
 * star_goods message
 */
class Down_StarGoods extends \ProtobufMessage
{
    /* Field index constants */
    const _TYPE = 1;
    const _AMOUNT = 2;
    const _STONE_ID = 3;
    const _STONE_AMOUNT = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TYPE => array(
            'name' => '_type',
            'required' => true,
            'type' => 5,
        ),
        self::_AMOUNT => array(
            'default' => 1, 
            'name' => '_amount',
            'required' => true,
            'type' => 5,
        ),
        self::_STONE_ID => array(
            'name' => '_stone_id',
            'required' => true,
            'type' => 5,
        ),
        self::_STONE_AMOUNT => array(
            'name' => '_stone_amount',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_TYPE] = null;
        $this->values[self::_AMOUNT] = null;
        $this->values[self::_STONE_ID] = null;
        $this->values[self::_STONE_AMOUNT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_type' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setType($value)
    {
        return $this->set(self::_TYPE, $value);
    }

    /**
     * Returns value of '_type' property
     *
     * @return int
     */
    public function getType()
    {
        return $this->get(self::_TYPE);
    }

    /**
     * Sets value of '_amount' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setAmount($value)
    {
        return $this->set(self::_AMOUNT, $value);
    }

    /**
     * Returns value of '_amount' property
     *
     * @return int
     */
    public function getAmount()
    {
        return $this->get(self::_AMOUNT);
    }

    /**
     * Sets value of '_stone_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStoneId($value)
    {
        return $this->set(self::_STONE_ID, $value);
    }

    /**
     * Returns value of '_stone_id' property
     *
     * @return int
     */
    public function getStoneId()
    {
        return $this->get(self::_STONE_ID);
    }

    /**
     * Sets value of '_stone_amount' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStoneAmount($value)
    {
        return $this->set(self::_STONE_AMOUNT, $value);
    }

    /**
     * Returns value of '_stone_amount' property
     *
     * @return int
     */
    public function getStoneAmount()
    {
        return $this->get(self::_STONE_AMOUNT);
    }
}

/**
 * user message
 */
class Down_User extends \ProtobufMessage
{
    /* Field index constants */
    const _USERID = 1;
    const _NAME_CARD = 2;
    const _LEVEL = 3;
    const _RECHARGE_SUM = 4;
    const _EXP = 5;
    const _MONEY = 6;
    const _RMB = 7;
    const _VITALITY = 8;
    const _HEROES = 10;
    const _ITEMS = 11;
    const _SKILL_LEVEL_UP = 12;
    const _USERSTAGE = 15;
    const _SHOP = 16;
    const _TUTORIAL = 17;
    const _TASK = 18;
    const _TASK_FINISHED = 19;
    const _LAST_LOGIN = 20;
    const _DAILYJOB = 21;
    const _TAVERN_RECORD = 22;
    const _USERMIDAS = 23;
    const _DAILY_LOGIN = 24;
    const _RECHARGE_LIMIT = 25;
    const _VIP_GIFTS_DRAW = 26;
    const _POINTS = 27;
    const _MONTH_CARD = 28;
    const _USER_GUILD = 29;
    const _CHAT = 30;
    const _SSHOP = 31;
    const _FACEBOOK_FOLLOW = 32;
    const _PRAISE = 33;
    const _SESSIONID = 34;
    const _SHADOW_RUNES = 35;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_USERID => array(
            'name' => '_userid',
            'required' => true,
            'type' => 5,
        ),
        self::_NAME_CARD => array(
            'name' => '_name_card',
            'required' => true,
            'type' => 'Down_NameCard'
        ),
        self::_LEVEL => array(
            'name' => '_level',
            'required' => true,
            'type' => 5,
        ),
        self::_RECHARGE_SUM => array(
            'name' => '_recharge_sum',
            'required' => true,
            'type' => 5,
        ),
        self::_EXP => array(
            'name' => '_exp',
            'required' => true,
            'type' => 5,
        ),
        self::_MONEY => array(
            'name' => '_money',
            'required' => true,
            'type' => 5,
        ),
        self::_RMB => array(
            'name' => '_rmb',
            'required' => true,
            'type' => 5,
        ),
        self::_VITALITY => array(
            'name' => '_vitality',
            'required' => true,
            'type' => 'Down_Vitality'
        ),
        self::_HEROES => array(
            'name' => '_heroes',
            'repeated' => true,
            'type' => 'Down_Hero'
        ),
        self::_ITEMS => array(
            'name' => '_items',
            'repeated' => true,
            'type' => 5,
        ),
        self::_SKILL_LEVEL_UP => array(
            'name' => '_skill_level_up',
            'required' => true,
            'type' => 'Down_Skilllevelup'
        ),
        self::_USERSTAGE => array(
            'name' => '_userstage',
            'required' => true,
            'type' => 'Down_Userstage'
        ),
        self::_SHOP => array(
            'name' => '_shop',
            'repeated' => true,
            'type' => 'Down_UserShop'
        ),
        self::_TUTORIAL => array(
            'name' => '_tutorial',
            'repeated' => true,
            'type' => 5,
        ),
        self::_TASK => array(
            'name' => '_task',
            'repeated' => true,
            'type' => 'Down_Usertask'
        ),
        self::_TASK_FINISHED => array(
            'name' => '_task_finished',
            'repeated' => true,
            'type' => 5,
        ),
        self::_LAST_LOGIN => array(
            'name' => '_last_login',
            'required' => false,
            'type' => 5,
        ),
        self::_DAILYJOB => array(
            'name' => '_dailyjob',
            'repeated' => true,
            'type' => 'Down_Dailyjob'
        ),
        self::_TAVERN_RECORD => array(
            'name' => '_tavern_record',
            'repeated' => true,
            'type' => 'Down_TavernRecord'
        ),
        self::_USERMIDAS => array(
            'name' => '_usermidas',
            'required' => true,
            'type' => 'Down_Usermidas'
        ),
        self::_DAILY_LOGIN => array(
            'name' => '_daily_login',
            'required' => true,
            'type' => 'Down_DailyLogin'
        ),
        self::_RECHARGE_LIMIT => array(
            'name' => '_recharge_limit',
            'repeated' => true,
            'type' => 5,
        ),
        self::_VIP_GIFTS_DRAW => array(
            'name' => '_vip_gifts_draw',
            'repeated' => true,
            'type' => 5,
        ),
        self::_POINTS => array(
            'name' => '_points',
            'repeated' => true,
            'type' => 'Down_UserPoint'
        ),
        self::_MONTH_CARD => array(
            'name' => '_month_card',
            'repeated' => true,
            'type' => 'Down_Monthcard'
        ),
        self::_USER_GUILD => array(
            'name' => '_user_guild',
            'required' => true,
            'type' => 'Down_UserGuild'
        ),
        self::_CHAT => array(
            'name' => '_chat',
            'required' => true,
            'type' => 'Down_Chat'
        ),
        self::_SSHOP => array(
            'name' => '_sshop',
            'required' => false,
            'type' => 'Down_StarShop'
        ),
        self::_FACEBOOK_FOLLOW => array(
            'name' => '_facebook_follow',
            'required' => false,
            'type' => 5,
        ),
        self::_PRAISE => array(
            'name' => '_praise',
            'required' => false,
            'type' => 7,
        ),
        self::_SESSIONID => array(
            'name' => '_sessionid',
            'required' => false,
            'type' => 5,
        ),
        self::_SHADOW_RUNES => array(
            'name' => '_shadow_runes',
            'required' => false,
            'type' => 'Down_Vitality'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_USERID] = null;
        $this->values[self::_NAME_CARD] = null;
        $this->values[self::_LEVEL] = null;
        $this->values[self::_RECHARGE_SUM] = null;
        $this->values[self::_EXP] = null;
        $this->values[self::_MONEY] = null;
        $this->values[self::_RMB] = null;
        $this->values[self::_VITALITY] = null;
        $this->values[self::_HEROES] = array();
        $this->values[self::_ITEMS] = array();
        $this->values[self::_SKILL_LEVEL_UP] = null;
        $this->values[self::_USERSTAGE] = null;
        $this->values[self::_SHOP] = array();
        $this->values[self::_TUTORIAL] = array();
        $this->values[self::_TASK] = array();
        $this->values[self::_TASK_FINISHED] = array();
        $this->values[self::_LAST_LOGIN] = null;
        $this->values[self::_DAILYJOB] = array();
        $this->values[self::_TAVERN_RECORD] = array();
        $this->values[self::_USERMIDAS] = null;
        $this->values[self::_DAILY_LOGIN] = null;
        $this->values[self::_RECHARGE_LIMIT] = array();
        $this->values[self::_VIP_GIFTS_DRAW] = array();
        $this->values[self::_POINTS] = array();
        $this->values[self::_MONTH_CARD] = array();
        $this->values[self::_USER_GUILD] = null;
        $this->values[self::_CHAT] = null;
        $this->values[self::_SSHOP] = null;
        $this->values[self::_FACEBOOK_FOLLOW] = null;
        $this->values[self::_PRAISE] = null;
        $this->values[self::_SESSIONID] = null;
        $this->values[self::_SHADOW_RUNES] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_userid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setUserid($value)
    {
        return $this->set(self::_USERID, $value);
    }

    /**
     * Returns value of '_userid' property
     *
     * @return int
     */
    public function getUserid()
    {
        return $this->get(self::_USERID);
    }

    /**
     * Sets value of '_name_card' property
     *
     * @param Down_NameCard $value Property value
     *
     * @return null
     */
    public function setNameCard(Down_NameCard $value)
    {
        return $this->set(self::_NAME_CARD, $value);
    }

    /**
     * Returns value of '_name_card' property
     *
     * @return Down_NameCard
     */
    public function getNameCard()
    {
        return $this->get(self::_NAME_CARD);
    }

    /**
     * Sets value of '_level' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLevel($value)
    {
        return $this->set(self::_LEVEL, $value);
    }

    /**
     * Returns value of '_level' property
     *
     * @return int
     */
    public function getLevel()
    {
        return $this->get(self::_LEVEL);
    }

    /**
     * Sets value of '_recharge_sum' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRechargeSum($value)
    {
        return $this->set(self::_RECHARGE_SUM, $value);
    }

    /**
     * Returns value of '_recharge_sum' property
     *
     * @return int
     */
    public function getRechargeSum()
    {
        return $this->get(self::_RECHARGE_SUM);
    }

    /**
     * Sets value of '_exp' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setExp($value)
    {
        return $this->set(self::_EXP, $value);
    }

    /**
     * Returns value of '_exp' property
     *
     * @return int
     */
    public function getExp()
    {
        return $this->get(self::_EXP);
    }

    /**
     * Sets value of '_money' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setMoney($value)
    {
        return $this->set(self::_MONEY, $value);
    }

    /**
     * Returns value of '_money' property
     *
     * @return int
     */
    public function getMoney()
    {
        return $this->get(self::_MONEY);
    }

    /**
     * Sets value of '_rmb' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRmb($value)
    {
        return $this->set(self::_RMB, $value);
    }

    /**
     * Returns value of '_rmb' property
     *
     * @return int
     */
    public function getRmb()
    {
        return $this->get(self::_RMB);
    }

    /**
     * Sets value of '_vitality' property
     *
     * @param Down_Vitality $value Property value
     *
     * @return null
     */
    public function setVitality(Down_Vitality $value)
    {
        return $this->set(self::_VITALITY, $value);
    }

    /**
     * Returns value of '_vitality' property
     *
     * @return Down_Vitality
     */
    public function getVitality()
    {
        return $this->get(self::_VITALITY);
    }

    /**
     * Appends value to '_heroes' list
     *
     * @param Down_Hero $value Value to append
     *
     * @return null
     */
    public function appendHeroes(Down_Hero $value)
    {
        return $this->append(self::_HEROES, $value);
    }

    /**
     * Clears '_heroes' list
     *
     * @return null
     */
    public function clearHeroes()
    {
        return $this->clear(self::_HEROES);
    }

    /**
     * Returns '_heroes' list
     *
     * @return Down_Hero[]
     */
    public function getHeroes()
    {
        return $this->get(self::_HEROES);
    }

    /**
     * Returns '_heroes' iterator
     *
     * @return ArrayIterator
     */
    public function getHeroesIterator()
    {
        return new \ArrayIterator($this->get(self::_HEROES));
    }

    /**
     * Returns element from '_heroes' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_Hero
     */
    public function getHeroesAt($offset)
    {
        return $this->get(self::_HEROES, $offset);
    }

    /**
     * Returns count of '_heroes' list
     *
     * @return int
     */
    public function getHeroesCount()
    {
        return $this->count(self::_HEROES);
    }

    /**
     * Appends value to '_items' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendItems($value)
    {
        return $this->append(self::_ITEMS, $value);
    }

    /**
     * Clears '_items' list
     *
     * @return null
     */
    public function clearItems()
    {
        return $this->clear(self::_ITEMS);
    }

    /**
     * Returns '_items' list
     *
     * @return int[]
     */
    public function getItems()
    {
        return $this->get(self::_ITEMS);
    }

    /**
     * Returns '_items' iterator
     *
     * @return ArrayIterator
     */
    public function getItemsIterator()
    {
        return new \ArrayIterator($this->get(self::_ITEMS));
    }

    /**
     * Returns element from '_items' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getItemsAt($offset)
    {
        return $this->get(self::_ITEMS, $offset);
    }

    /**
     * Returns count of '_items' list
     *
     * @return int
     */
    public function getItemsCount()
    {
        return $this->count(self::_ITEMS);
    }

    /**
     * Sets value of '_skill_level_up' property
     *
     * @param Down_Skilllevelup $value Property value
     *
     * @return null
     */
    public function setSkillLevelUp(Down_Skilllevelup $value)
    {
        return $this->set(self::_SKILL_LEVEL_UP, $value);
    }

    /**
     * Returns value of '_skill_level_up' property
     *
     * @return Down_Skilllevelup
     */
    public function getSkillLevelUp()
    {
        return $this->get(self::_SKILL_LEVEL_UP);
    }

    /**
     * Sets value of '_userstage' property
     *
     * @param Down_Userstage $value Property value
     *
     * @return null
     */
    public function setUserstage(Down_Userstage $value)
    {
        return $this->set(self::_USERSTAGE, $value);
    }

    /**
     * Returns value of '_userstage' property
     *
     * @return Down_Userstage
     */
    public function getUserstage()
    {
        return $this->get(self::_USERSTAGE);
    }

    /**
     * Appends value to '_shop' list
     *
     * @param Down_UserShop $value Value to append
     *
     * @return null
     */
    public function appendShop(Down_UserShop $value)
    {
        return $this->append(self::_SHOP, $value);
    }

    /**
     * Clears '_shop' list
     *
     * @return null
     */
    public function clearShop()
    {
        return $this->clear(self::_SHOP);
    }

    /**
     * Returns '_shop' list
     *
     * @return Down_UserShop[]
     */
    public function getShop()
    {
        return $this->get(self::_SHOP);
    }

    /**
     * Returns '_shop' iterator
     *
     * @return ArrayIterator
     */
    public function getShopIterator()
    {
        return new \ArrayIterator($this->get(self::_SHOP));
    }

    /**
     * Returns element from '_shop' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_UserShop
     */
    public function getShopAt($offset)
    {
        return $this->get(self::_SHOP, $offset);
    }

    /**
     * Returns count of '_shop' list
     *
     * @return int
     */
    public function getShopCount()
    {
        return $this->count(self::_SHOP);
    }

    /**
     * Appends value to '_tutorial' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendTutorial($value)
    {
        return $this->append(self::_TUTORIAL, $value);
    }

    /**
     * Clears '_tutorial' list
     *
     * @return null
     */
    public function clearTutorial()
    {
        return $this->clear(self::_TUTORIAL);
    }

    /**
     * Returns '_tutorial' list
     *
     * @return int[]
     */
    public function getTutorial()
    {
        return $this->get(self::_TUTORIAL);
    }

    /**
     * Returns '_tutorial' iterator
     *
     * @return ArrayIterator
     */
    public function getTutorialIterator()
    {
        return new \ArrayIterator($this->get(self::_TUTORIAL));
    }

    /**
     * Returns element from '_tutorial' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getTutorialAt($offset)
    {
        return $this->get(self::_TUTORIAL, $offset);
    }

    /**
     * Returns count of '_tutorial' list
     *
     * @return int
     */
    public function getTutorialCount()
    {
        return $this->count(self::_TUTORIAL);
    }

    /**
     * Appends value to '_task' list
     *
     * @param Down_Usertask $value Value to append
     *
     * @return null
     */
    public function appendTask(Down_Usertask $value)
    {
        return $this->append(self::_TASK, $value);
    }

    /**
     * Clears '_task' list
     *
     * @return null
     */
    public function clearTask()
    {
        return $this->clear(self::_TASK);
    }

    /**
     * Returns '_task' list
     *
     * @return Down_Usertask[]
     */
    public function getTask()
    {
        return $this->get(self::_TASK);
    }

    /**
     * Returns '_task' iterator
     *
     * @return ArrayIterator
     */
    public function getTaskIterator()
    {
        return new \ArrayIterator($this->get(self::_TASK));
    }

    /**
     * Returns element from '_task' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_Usertask
     */
    public function getTaskAt($offset)
    {
        return $this->get(self::_TASK, $offset);
    }

    /**
     * Returns count of '_task' list
     *
     * @return int
     */
    public function getTaskCount()
    {
        return $this->count(self::_TASK);
    }

    /**
     * Appends value to '_task_finished' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendTaskFinished($value)
    {
        return $this->append(self::_TASK_FINISHED, $value);
    }

    /**
     * Clears '_task_finished' list
     *
     * @return null
     */
    public function clearTaskFinished()
    {
        return $this->clear(self::_TASK_FINISHED);
    }

    /**
     * Returns '_task_finished' list
     *
     * @return int[]
     */
    public function getTaskFinished()
    {
        return $this->get(self::_TASK_FINISHED);
    }

    /**
     * Returns '_task_finished' iterator
     *
     * @return ArrayIterator
     */
    public function getTaskFinishedIterator()
    {
        return new \ArrayIterator($this->get(self::_TASK_FINISHED));
    }

    /**
     * Returns element from '_task_finished' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getTaskFinishedAt($offset)
    {
        return $this->get(self::_TASK_FINISHED, $offset);
    }

    /**
     * Returns count of '_task_finished' list
     *
     * @return int
     */
    public function getTaskFinishedCount()
    {
        return $this->count(self::_TASK_FINISHED);
    }

    /**
     * Sets value of '_last_login' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLastLogin($value)
    {
        return $this->set(self::_LAST_LOGIN, $value);
    }

    /**
     * Returns value of '_last_login' property
     *
     * @return int
     */
    public function getLastLogin()
    {
        return $this->get(self::_LAST_LOGIN);
    }

    /**
     * Appends value to '_dailyjob' list
     *
     * @param Down_Dailyjob $value Value to append
     *
     * @return null
     */
    public function appendDailyjob(Down_Dailyjob $value)
    {
        return $this->append(self::_DAILYJOB, $value);
    }

    /**
     * Clears '_dailyjob' list
     *
     * @return null
     */
    public function clearDailyjob()
    {
        return $this->clear(self::_DAILYJOB);
    }

    /**
     * Returns '_dailyjob' list
     *
     * @return Down_Dailyjob[]
     */
    public function getDailyjob()
    {
        return $this->get(self::_DAILYJOB);
    }

    /**
     * Returns '_dailyjob' iterator
     *
     * @return ArrayIterator
     */
    public function getDailyjobIterator()
    {
        return new \ArrayIterator($this->get(self::_DAILYJOB));
    }

    /**
     * Returns element from '_dailyjob' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_Dailyjob
     */
    public function getDailyjobAt($offset)
    {
        return $this->get(self::_DAILYJOB, $offset);
    }

    /**
     * Returns count of '_dailyjob' list
     *
     * @return int
     */
    public function getDailyjobCount()
    {
        return $this->count(self::_DAILYJOB);
    }

    /**
     * Appends value to '_tavern_record' list
     *
     * @param Down_TavernRecord $value Value to append
     *
     * @return null
     */
    public function appendTavernRecord(Down_TavernRecord $value)
    {
        return $this->append(self::_TAVERN_RECORD, $value);
    }

    /**
     * Clears '_tavern_record' list
     *
     * @return null
     */
    public function clearTavernRecord()
    {
        return $this->clear(self::_TAVERN_RECORD);
    }

    /**
     * Returns '_tavern_record' list
     *
     * @return Down_TavernRecord[]
     */
    public function getTavernRecord()
    {
        return $this->get(self::_TAVERN_RECORD);
    }

    /**
     * Returns '_tavern_record' iterator
     *
     * @return ArrayIterator
     */
    public function getTavernRecordIterator()
    {
        return new \ArrayIterator($this->get(self::_TAVERN_RECORD));
    }

    /**
     * Returns element from '_tavern_record' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_TavernRecord
     */
    public function getTavernRecordAt($offset)
    {
        return $this->get(self::_TAVERN_RECORD, $offset);
    }

    /**
     * Returns count of '_tavern_record' list
     *
     * @return int
     */
    public function getTavernRecordCount()
    {
        return $this->count(self::_TAVERN_RECORD);
    }

    /**
     * Sets value of '_usermidas' property
     *
     * @param Down_Usermidas $value Property value
     *
     * @return null
     */
    public function setUsermidas(Down_Usermidas $value)
    {
        return $this->set(self::_USERMIDAS, $value);
    }

    /**
     * Returns value of '_usermidas' property
     *
     * @return Down_Usermidas
     */
    public function getUsermidas()
    {
        return $this->get(self::_USERMIDAS);
    }

    /**
     * Sets value of '_daily_login' property
     *
     * @param Down_DailyLogin $value Property value
     *
     * @return null
     */
    public function setDailyLogin(Down_DailyLogin $value)
    {
        return $this->set(self::_DAILY_LOGIN, $value);
    }

    /**
     * Returns value of '_daily_login' property
     *
     * @return Down_DailyLogin
     */
    public function getDailyLogin()
    {
        return $this->get(self::_DAILY_LOGIN);
    }

    /**
     * Appends value to '_recharge_limit' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendRechargeLimit($value)
    {
        return $this->append(self::_RECHARGE_LIMIT, $value);
    }

    /**
     * Clears '_recharge_limit' list
     *
     * @return null
     */
    public function clearRechargeLimit()
    {
        return $this->clear(self::_RECHARGE_LIMIT);
    }

    /**
     * Returns '_recharge_limit' list
     *
     * @return int[]
     */
    public function getRechargeLimit()
    {
        return $this->get(self::_RECHARGE_LIMIT);
    }

    /**
     * Returns '_recharge_limit' iterator
     *
     * @return ArrayIterator
     */
    public function getRechargeLimitIterator()
    {
        return new \ArrayIterator($this->get(self::_RECHARGE_LIMIT));
    }

    /**
     * Returns element from '_recharge_limit' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getRechargeLimitAt($offset)
    {
        return $this->get(self::_RECHARGE_LIMIT, $offset);
    }

    /**
     * Returns count of '_recharge_limit' list
     *
     * @return int
     */
    public function getRechargeLimitCount()
    {
        return $this->count(self::_RECHARGE_LIMIT);
    }

    /**
     * Appends value to '_vip_gifts_draw' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendVipGiftsDraw($value)
    {
        return $this->append(self::_VIP_GIFTS_DRAW, $value);
    }

    /**
     * Clears '_vip_gifts_draw' list
     *
     * @return null
     */
    public function clearVipGiftsDraw()
    {
        return $this->clear(self::_VIP_GIFTS_DRAW);
    }

    /**
     * Returns '_vip_gifts_draw' list
     *
     * @return int[]
     */
    public function getVipGiftsDraw()
    {
        return $this->get(self::_VIP_GIFTS_DRAW);
    }

    /**
     * Returns '_vip_gifts_draw' iterator
     *
     * @return ArrayIterator
     */
    public function getVipGiftsDrawIterator()
    {
        return new \ArrayIterator($this->get(self::_VIP_GIFTS_DRAW));
    }

    /**
     * Returns element from '_vip_gifts_draw' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getVipGiftsDrawAt($offset)
    {
        return $this->get(self::_VIP_GIFTS_DRAW, $offset);
    }

    /**
     * Returns count of '_vip_gifts_draw' list
     *
     * @return int
     */
    public function getVipGiftsDrawCount()
    {
        return $this->count(self::_VIP_GIFTS_DRAW);
    }

    /**
     * Appends value to '_points' list
     *
     * @param Down_UserPoint $value Value to append
     *
     * @return null
     */
    public function appendPoints(Down_UserPoint $value)
    {
        return $this->append(self::_POINTS, $value);
    }

    /**
     * Clears '_points' list
     *
     * @return null
     */
    public function clearPoints()
    {
        return $this->clear(self::_POINTS);
    }

    /**
     * Returns '_points' list
     *
     * @return Down_UserPoint[]
     */
    public function getPoints()
    {
        return $this->get(self::_POINTS);
    }

    /**
     * Returns '_points' iterator
     *
     * @return ArrayIterator
     */
    public function getPointsIterator()
    {
        return new \ArrayIterator($this->get(self::_POINTS));
    }

    /**
     * Returns element from '_points' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_UserPoint
     */
    public function getPointsAt($offset)
    {
        return $this->get(self::_POINTS, $offset);
    }

    /**
     * Returns count of '_points' list
     *
     * @return int
     */
    public function getPointsCount()
    {
        return $this->count(self::_POINTS);
    }

    /**
     * Appends value to '_month_card' list
     *
     * @param Down_Monthcard $value Value to append
     *
     * @return null
     */
    public function appendMonthCard(Down_Monthcard $value)
    {
        return $this->append(self::_MONTH_CARD, $value);
    }

    /**
     * Clears '_month_card' list
     *
     * @return null
     */
    public function clearMonthCard()
    {
        return $this->clear(self::_MONTH_CARD);
    }

    /**
     * Returns '_month_card' list
     *
     * @return Down_Monthcard[]
     */
    public function getMonthCard()
    {
        return $this->get(self::_MONTH_CARD);
    }

    /**
     * Returns '_month_card' iterator
     *
     * @return ArrayIterator
     */
    public function getMonthCardIterator()
    {
        return new \ArrayIterator($this->get(self::_MONTH_CARD));
    }

    /**
     * Returns element from '_month_card' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_Monthcard
     */
    public function getMonthCardAt($offset)
    {
        return $this->get(self::_MONTH_CARD, $offset);
    }

    /**
     * Returns count of '_month_card' list
     *
     * @return int
     */
    public function getMonthCardCount()
    {
        return $this->count(self::_MONTH_CARD);
    }

    /**
     * Sets value of '_user_guild' property
     *
     * @param Down_UserGuild $value Property value
     *
     * @return null
     */
    public function setUserGuild(Down_UserGuild $value)
    {
        return $this->set(self::_USER_GUILD, $value);
    }

    /**
     * Returns value of '_user_guild' property
     *
     * @return Down_UserGuild
     */
    public function getUserGuild()
    {
        return $this->get(self::_USER_GUILD);
    }

    /**
     * Sets value of '_chat' property
     *
     * @param Down_Chat $value Property value
     *
     * @return null
     */
    public function setChat(Down_Chat $value)
    {
        return $this->set(self::_CHAT, $value);
    }

    /**
     * Returns value of '_chat' property
     *
     * @return Down_Chat
     */
    public function getChat()
    {
        return $this->get(self::_CHAT);
    }

    /**
     * Sets value of '_sshop' property
     *
     * @param Down_StarShop $value Property value
     *
     * @return null
     */
    public function setSshop(Down_StarShop $value)
    {
        return $this->set(self::_SSHOP, $value);
    }

    /**
     * Returns value of '_sshop' property
     *
     * @return Down_StarShop
     */
    public function getSshop()
    {
        return $this->get(self::_SSHOP);
    }

    /**
     * Sets value of '_facebook_follow' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setFacebookFollow($value)
    {
        return $this->set(self::_FACEBOOK_FOLLOW, $value);
    }

    /**
     * Returns value of '_facebook_follow' property
     *
     * @return int
     */
    public function getFacebookFollow()
    {
        return $this->get(self::_FACEBOOK_FOLLOW);
    }

    /**
     * Sets value of '_praise' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setPraise($value)
    {
        return $this->set(self::_PRAISE, $value);
    }

    /**
     * Returns value of '_praise' property
     *
     * @return string
     */
    public function getPraise()
    {
        return $this->get(self::_PRAISE);
    }

    /**
     * Sets value of '_sessionid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSessionid($value)
    {
        return $this->set(self::_SESSIONID, $value);
    }

    /**
     * Returns value of '_sessionid' property
     *
     * @return int
     */
    public function getSessionid()
    {
        return $this->get(self::_SESSIONID);
    }

    /**
     * Sets value of '_shadow_runes' property
     *
     * @param Down_Vitality $value Property value
     *
     * @return null
     */
    public function setShadowRunes(Down_Vitality $value)
    {
        return $this->set(self::_SHADOW_RUNES, $value);
    }

    /**
     * Returns value of '_shadow_runes' property
     *
     * @return Down_Vitality
     */
    public function getShadowRunes()
    {
        return $this->get(self::_SHADOW_RUNES);
    }
}

/**
 * user_summary message
 */
class Down_UserSummary extends \ProtobufMessage
{
    /* Field index constants */
    const _AVATAR = 1;
    const _NAME = 2;
    const _VIP = 3;
    const _LEVEL = 4;
    const _GUILD_NAME = 5;
    const _USER_ID = 6;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_AVATAR => array(
            'name' => '_avatar',
            'required' => true,
            'type' => 5,
        ),
        self::_NAME => array(
            'name' => '_name',
            'required' => true,
            'type' => 7,
        ),
        self::_VIP => array(
            'name' => '_vip',
            'required' => true,
            'type' => 5,
        ),
        self::_LEVEL => array(
            'name' => '_level',
            'required' => true,
            'type' => 5,
        ),
        self::_GUILD_NAME => array(
            'name' => '_guild_name',
            'required' => false,
            'type' => 7,
        ),
        self::_USER_ID => array(
            'name' => '_user_id',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_AVATAR] = null;
        $this->values[self::_NAME] = null;
        $this->values[self::_VIP] = null;
        $this->values[self::_LEVEL] = null;
        $this->values[self::_GUILD_NAME] = null;
        $this->values[self::_USER_ID] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_avatar' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setAvatar($value)
    {
        return $this->set(self::_AVATAR, $value);
    }

    /**
     * Returns value of '_avatar' property
     *
     * @return int
     */
    public function getAvatar()
    {
        return $this->get(self::_AVATAR);
    }

    /**
     * Sets value of '_name' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setName($value)
    {
        return $this->set(self::_NAME, $value);
    }

    /**
     * Returns value of '_name' property
     *
     * @return string
     */
    public function getName()
    {
        return $this->get(self::_NAME);
    }

    /**
     * Sets value of '_vip' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setVip($value)
    {
        return $this->set(self::_VIP, $value);
    }

    /**
     * Returns value of '_vip' property
     *
     * @return int
     */
    public function getVip()
    {
        return $this->get(self::_VIP);
    }

    /**
     * Sets value of '_level' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLevel($value)
    {
        return $this->set(self::_LEVEL, $value);
    }

    /**
     * Returns value of '_level' property
     *
     * @return int
     */
    public function getLevel()
    {
        return $this->get(self::_LEVEL);
    }

    /**
     * Sets value of '_guild_name' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setGuildName($value)
    {
        return $this->set(self::_GUILD_NAME, $value);
    }

    /**
     * Returns value of '_guild_name' property
     *
     * @return string
     */
    public function getGuildName()
    {
        return $this->get(self::_GUILD_NAME);
    }

    /**
     * Sets value of '_user_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setUserId($value)
    {
        return $this->set(self::_USER_ID, $value);
    }

    /**
     * Returns value of '_user_id' property
     *
     * @return int
     */
    public function getUserId()
    {
        return $this->get(self::_USER_ID);
    }
}

/**
 * name_card message
 */
class Down_NameCard extends \ProtobufMessage
{
    /* Field index constants */
    const _NAME = 1;
    const _LAST_SET_NAME_TIME = 2;
    const _AVATAR = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_NAME => array(
            'name' => '_name',
            'required' => true,
            'type' => 7,
        ),
        self::_LAST_SET_NAME_TIME => array(
            'name' => '_last_set_name_time',
            'required' => true,
            'type' => 5,
        ),
        self::_AVATAR => array(
            'name' => '_avatar',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_NAME] = null;
        $this->values[self::_LAST_SET_NAME_TIME] = null;
        $this->values[self::_AVATAR] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_name' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setName($value)
    {
        return $this->set(self::_NAME, $value);
    }

    /**
     * Returns value of '_name' property
     *
     * @return string
     */
    public function getName()
    {
        return $this->get(self::_NAME);
    }

    /**
     * Sets value of '_last_set_name_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLastSetNameTime($value)
    {
        return $this->set(self::_LAST_SET_NAME_TIME, $value);
    }

    /**
     * Returns value of '_last_set_name_time' property
     *
     * @return int
     */
    public function getLastSetNameTime()
    {
        return $this->get(self::_LAST_SET_NAME_TIME);
    }

    /**
     * Sets value of '_avatar' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setAvatar($value)
    {
        return $this->set(self::_AVATAR, $value);
    }

    /**
     * Returns value of '_avatar' property
     *
     * @return int
     */
    public function getAvatar()
    {
        return $this->get(self::_AVATAR);
    }
}

/**
 * dailylogin_status enum embedded in daily_login message
 */
final class Down_DailyLogin_DailyloginStatus
{
    const all = 1;
    const part = 2;
    const nothing = 3;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'all' => self::all,
            'part' => self::part,
            'nothing' => self::nothing,
        );
    }
}

/**
 * daily_login message
 */
class Down_DailyLogin extends \ProtobufMessage
{
    /* Field index constants */
    const _STATUS = 1;
    const _FREQUENCY = 2;
    const _LAST_LOGIN_DATE = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_STATUS => array(
            'name' => '_status',
            'required' => true,
            'type' => 5,
        ),
        self::_FREQUENCY => array(
            'name' => '_frequency',
            'required' => true,
            'type' => 5,
        ),
        self::_LAST_LOGIN_DATE => array(
            'name' => '_last_login_date',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_STATUS] = null;
        $this->values[self::_FREQUENCY] = null;
        $this->values[self::_LAST_LOGIN_DATE] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_status' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStatus($value)
    {
        return $this->set(self::_STATUS, $value);
    }

    /**
     * Returns value of '_status' property
     *
     * @return int
     */
    public function getStatus()
    {
        return $this->get(self::_STATUS);
    }

    /**
     * Sets value of '_frequency' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setFrequency($value)
    {
        return $this->set(self::_FREQUENCY, $value);
    }

    /**
     * Returns value of '_frequency' property
     *
     * @return int
     */
    public function getFrequency()
    {
        return $this->get(self::_FREQUENCY);
    }

    /**
     * Sets value of '_last_login_date' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLastLoginDate($value)
    {
        return $this->set(self::_LAST_LOGIN_DATE, $value);
    }

    /**
     * Returns value of '_last_login_date' property
     *
     * @return int
     */
    public function getLastLoginDate()
    {
        return $this->get(self::_LAST_LOGIN_DATE);
    }
}

/**
 * ask_daily_login_reply message
 */
class Down_AskDailyLoginReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _ITEMS = 2;
    const _HERO = 3;
    const _DIAMOND = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_ITEMS => array(
            'name' => '_items',
            'repeated' => true,
            'type' => 5,
        ),
        self::_HERO => array(
            'name' => '_hero',
            'repeated' => true,
            'type' => 'Down_Hero'
        ),
        self::_DIAMOND => array(
            'name' => '_diamond',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_ITEMS] = array();
        $this->values[self::_HERO] = array();
        $this->values[self::_DIAMOND] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Appends value to '_items' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendItems($value)
    {
        return $this->append(self::_ITEMS, $value);
    }

    /**
     * Clears '_items' list
     *
     * @return null
     */
    public function clearItems()
    {
        return $this->clear(self::_ITEMS);
    }

    /**
     * Returns '_items' list
     *
     * @return int[]
     */
    public function getItems()
    {
        return $this->get(self::_ITEMS);
    }

    /**
     * Returns '_items' iterator
     *
     * @return ArrayIterator
     */
    public function getItemsIterator()
    {
        return new \ArrayIterator($this->get(self::_ITEMS));
    }

    /**
     * Returns element from '_items' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getItemsAt($offset)
    {
        return $this->get(self::_ITEMS, $offset);
    }

    /**
     * Returns count of '_items' list
     *
     * @return int
     */
    public function getItemsCount()
    {
        return $this->count(self::_ITEMS);
    }

    /**
     * Appends value to '_hero' list
     *
     * @param Down_Hero $value Value to append
     *
     * @return null
     */
    public function appendHero(Down_Hero $value)
    {
        return $this->append(self::_HERO, $value);
    }

    /**
     * Clears '_hero' list
     *
     * @return null
     */
    public function clearHero()
    {
        return $this->clear(self::_HERO);
    }

    /**
     * Returns '_hero' list
     *
     * @return Down_Hero[]
     */
    public function getHero()
    {
        return $this->get(self::_HERO);
    }

    /**
     * Returns '_hero' iterator
     *
     * @return ArrayIterator
     */
    public function getHeroIterator()
    {
        return new \ArrayIterator($this->get(self::_HERO));
    }

    /**
     * Returns element from '_hero' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_Hero
     */
    public function getHeroAt($offset)
    {
        return $this->get(self::_HERO, $offset);
    }

    /**
     * Returns count of '_hero' list
     *
     * @return int
     */
    public function getHeroCount()
    {
        return $this->count(self::_HERO);
    }

    /**
     * Sets value of '_diamond' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setDiamond($value)
    {
        return $this->set(self::_DIAMOND, $value);
    }

    /**
     * Returns value of '_diamond' property
     *
     * @return int
     */
    public function getDiamond()
    {
        return $this->get(self::_DIAMOND);
    }
}

/**
 * hero_equip message
 */
class Down_HeroEquip extends \ProtobufMessage
{
    /* Field index constants */
    const _INDEX = 1;
    const _ITEM_ID = 2;
    const _EXP = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_INDEX => array(
            'name' => '_index',
            'required' => true,
            'type' => 5,
        ),
        self::_ITEM_ID => array(
            'name' => '_item_id',
            'required' => true,
            'type' => 5,
        ),
        self::_EXP => array(
            'name' => '_exp',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_INDEX] = null;
        $this->values[self::_ITEM_ID] = null;
        $this->values[self::_EXP] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_index' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setIndex($value)
    {
        return $this->set(self::_INDEX, $value);
    }

    /**
     * Returns value of '_index' property
     *
     * @return int
     */
    public function getIndex()
    {
        return $this->get(self::_INDEX);
    }

    /**
     * Sets value of '_item_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setItemId($value)
    {
        return $this->set(self::_ITEM_ID, $value);
    }

    /**
     * Returns value of '_item_id' property
     *
     * @return int
     */
    public function getItemId()
    {
        return $this->get(self::_ITEM_ID);
    }

    /**
     * Sets value of '_exp' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setExp($value)
    {
        return $this->set(self::_EXP, $value);
    }

    /**
     * Returns value of '_exp' property
     *
     * @return int
     */
    public function getExp()
    {
        return $this->get(self::_EXP);
    }
}

/**
 * hero message
 */
class Down_Hero extends \ProtobufMessage
{
    /* Field index constants */
    const _TID = 1;
    const _RANK = 2;
    const _LEVEL = 3;
    const _STARS = 4;
    const _EXP = 5;
    const _GS = 6;
    const _STATE = 7;
    const _SKILL_LEVELS = 8;
    const _ITEMS = 9;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TID => array(
            'name' => '_tid',
            'required' => true,
            'type' => 5,
        ),
        self::_RANK => array(
            'name' => '_rank',
            'required' => false,
            'type' => 5,
        ),
        self::_LEVEL => array(
            'name' => '_level',
            'required' => true,
            'type' => 5,
        ),
        self::_STARS => array(
            'name' => '_stars',
            'required' => true,
            'type' => 5,
        ),
        self::_EXP => array(
            'name' => '_exp',
            'required' => true,
            'type' => 5,
        ),
        self::_GS => array(
            'name' => '_gs',
            'required' => true,
            'type' => 5,
        ),
        self::_STATE => array(
            'name' => '_state',
            'required' => true,
            'type' => 5,
        ),
        self::_SKILL_LEVELS => array(
            'name' => '_skill_levels',
            'repeated' => true,
            'type' => 5,
        ),
        self::_ITEMS => array(
            'name' => '_items',
            'repeated' => true,
            'type' => 'Down_HeroEquip'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_TID] = null;
        $this->values[self::_RANK] = null;
        $this->values[self::_LEVEL] = null;
        $this->values[self::_STARS] = null;
        $this->values[self::_EXP] = null;
        $this->values[self::_GS] = null;
        $this->values[self::_STATE] = null;
        $this->values[self::_SKILL_LEVELS] = array();
        $this->values[self::_ITEMS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_tid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setTid($value)
    {
        return $this->set(self::_TID, $value);
    }

    /**
     * Returns value of '_tid' property
     *
     * @return int
     */
    public function getTid()
    {
        return $this->get(self::_TID);
    }

    /**
     * Sets value of '_rank' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRank($value)
    {
        return $this->set(self::_RANK, $value);
    }

    /**
     * Returns value of '_rank' property
     *
     * @return int
     */
    public function getRank()
    {
        return $this->get(self::_RANK);
    }

    /**
     * Sets value of '_level' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLevel($value)
    {
        return $this->set(self::_LEVEL, $value);
    }

    /**
     * Returns value of '_level' property
     *
     * @return int
     */
    public function getLevel()
    {
        return $this->get(self::_LEVEL);
    }

    /**
     * Sets value of '_stars' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStars($value)
    {
        return $this->set(self::_STARS, $value);
    }

    /**
     * Returns value of '_stars' property
     *
     * @return int
     */
    public function getStars()
    {
        return $this->get(self::_STARS);
    }

    /**
     * Sets value of '_exp' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setExp($value)
    {
        return $this->set(self::_EXP, $value);
    }

    /**
     * Returns value of '_exp' property
     *
     * @return int
     */
    public function getExp()
    {
        return $this->get(self::_EXP);
    }

    /**
     * Sets value of '_gs' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setGs($value)
    {
        return $this->set(self::_GS, $value);
    }

    /**
     * Returns value of '_gs' property
     *
     * @return int
     */
    public function getGs()
    {
        return $this->get(self::_GS);
    }

    /**
     * Sets value of '_state' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setState($value)
    {
        return $this->set(self::_STATE, $value);
    }

    /**
     * Returns value of '_state' property
     *
     * @return int
     */
    public function getState()
    {
        return $this->get(self::_STATE);
    }

    /**
     * Appends value to '_skill_levels' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendSkillLevels($value)
    {
        return $this->append(self::_SKILL_LEVELS, $value);
    }

    /**
     * Clears '_skill_levels' list
     *
     * @return null
     */
    public function clearSkillLevels()
    {
        return $this->clear(self::_SKILL_LEVELS);
    }

    /**
     * Returns '_skill_levels' list
     *
     * @return int[]
     */
    public function getSkillLevels()
    {
        return $this->get(self::_SKILL_LEVELS);
    }

    /**
     * Returns '_skill_levels' iterator
     *
     * @return ArrayIterator
     */
    public function getSkillLevelsIterator()
    {
        return new \ArrayIterator($this->get(self::_SKILL_LEVELS));
    }

    /**
     * Returns element from '_skill_levels' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getSkillLevelsAt($offset)
    {
        return $this->get(self::_SKILL_LEVELS, $offset);
    }

    /**
     * Returns count of '_skill_levels' list
     *
     * @return int
     */
    public function getSkillLevelsCount()
    {
        return $this->count(self::_SKILL_LEVELS);
    }

    /**
     * Appends value to '_items' list
     *
     * @param Down_HeroEquip $value Value to append
     *
     * @return null
     */
    public function appendItems(Down_HeroEquip $value)
    {
        return $this->append(self::_ITEMS, $value);
    }

    /**
     * Clears '_items' list
     *
     * @return null
     */
    public function clearItems()
    {
        return $this->clear(self::_ITEMS);
    }

    /**
     * Returns '_items' list
     *
     * @return Down_HeroEquip[]
     */
    public function getItems()
    {
        return $this->get(self::_ITEMS);
    }

    /**
     * Returns '_items' iterator
     *
     * @return ArrayIterator
     */
    public function getItemsIterator()
    {
        return new \ArrayIterator($this->get(self::_ITEMS));
    }

    /**
     * Returns element from '_items' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_HeroEquip
     */
    public function getItemsAt($offset)
    {
        return $this->get(self::_ITEMS, $offset);
    }

    /**
     * Returns count of '_items' list
     *
     * @return int
     */
    public function getItemsCount()
    {
        return $this->count(self::_ITEMS);
    }
}

/**
 * hero_summary message
 */
class Down_HeroSummary extends \ProtobufMessage
{
    /* Field index constants */
    const _TID = 1;
    const _RANK = 2;
    const _LEVEL = 3;
    const _STARS = 4;
    const _GS = 5;
    const _STATE = 6;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TID => array(
            'name' => '_tid',
            'required' => true,
            'type' => 5,
        ),
        self::_RANK => array(
            'name' => '_rank',
            'required' => false,
            'type' => 5,
        ),
        self::_LEVEL => array(
            'name' => '_level',
            'required' => true,
            'type' => 5,
        ),
        self::_STARS => array(
            'name' => '_stars',
            'required' => true,
            'type' => 5,
        ),
        self::_GS => array(
            'name' => '_gs',
            'required' => false,
            'type' => 5,
        ),
        self::_STATE => array(
            'name' => '_state',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_TID] = null;
        $this->values[self::_RANK] = null;
        $this->values[self::_LEVEL] = null;
        $this->values[self::_STARS] = null;
        $this->values[self::_GS] = null;
        $this->values[self::_STATE] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_tid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setTid($value)
    {
        return $this->set(self::_TID, $value);
    }

    /**
     * Returns value of '_tid' property
     *
     * @return int
     */
    public function getTid()
    {
        return $this->get(self::_TID);
    }

    /**
     * Sets value of '_rank' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRank($value)
    {
        return $this->set(self::_RANK, $value);
    }

    /**
     * Returns value of '_rank' property
     *
     * @return int
     */
    public function getRank()
    {
        return $this->get(self::_RANK);
    }

    /**
     * Sets value of '_level' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLevel($value)
    {
        return $this->set(self::_LEVEL, $value);
    }

    /**
     * Returns value of '_level' property
     *
     * @return int
     */
    public function getLevel()
    {
        return $this->get(self::_LEVEL);
    }

    /**
     * Sets value of '_stars' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStars($value)
    {
        return $this->set(self::_STARS, $value);
    }

    /**
     * Returns value of '_stars' property
     *
     * @return int
     */
    public function getStars()
    {
        return $this->get(self::_STARS);
    }

    /**
     * Sets value of '_gs' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setGs($value)
    {
        return $this->set(self::_GS, $value);
    }

    /**
     * Returns value of '_gs' property
     *
     * @return int
     */
    public function getGs()
    {
        return $this->get(self::_GS);
    }

    /**
     * Sets value of '_state' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setState($value)
    {
        return $this->set(self::_STATE, $value);
    }

    /**
     * Returns value of '_state' property
     *
     * @return int
     */
    public function getState()
    {
        return $this->get(self::_STATE);
    }
}

/**
 * hero_dyna message
 */
class Down_HeroDyna extends \ProtobufMessage
{
    /* Field index constants */
    const _HP_PERC = 1;
    const _MP_PERC = 2;
    const _CUSTOM_DATA = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_HP_PERC => array(
            'name' => '_hp_perc',
            'required' => true,
            'type' => 5,
        ),
        self::_MP_PERC => array(
            'name' => '_mp_perc',
            'required' => true,
            'type' => 5,
        ),
        self::_CUSTOM_DATA => array(
            'name' => '_custom_data',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_HP_PERC] = null;
        $this->values[self::_MP_PERC] = null;
        $this->values[self::_CUSTOM_DATA] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_hp_perc' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setHpPerc($value)
    {
        return $this->set(self::_HP_PERC, $value);
    }

    /**
     * Returns value of '_hp_perc' property
     *
     * @return int
     */
    public function getHpPerc()
    {
        return $this->get(self::_HP_PERC);
    }

    /**
     * Sets value of '_mp_perc' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setMpPerc($value)
    {
        return $this->set(self::_MP_PERC, $value);
    }

    /**
     * Returns value of '_mp_perc' property
     *
     * @return int
     */
    public function getMpPerc()
    {
        return $this->get(self::_MP_PERC);
    }

    /**
     * Sets value of '_custom_data' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCustomData($value)
    {
        return $this->set(self::_CUSTOM_DATA, $value);
    }

    /**
     * Returns value of '_custom_data' property
     *
     * @return int
     */
    public function getCustomData()
    {
        return $this->get(self::_CUSTOM_DATA);
    }
}

/**
 * skilllevelup message
 */
class Down_Skilllevelup extends \ProtobufMessage
{
    /* Field index constants */
    const _SKILL_LEVELUP_CHANCE = 1;
    const _SKILL_LEVELUP_CD = 2;
    const _RESET_TIMES = 3;
    const _LAST_RESET_DATE = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_SKILL_LEVELUP_CHANCE => array(
            'name' => '_skill_levelup_chance',
            'required' => true,
            'type' => 5,
        ),
        self::_SKILL_LEVELUP_CD => array(
            'name' => '_skill_levelup_cd',
            'required' => true,
            'type' => 5,
        ),
        self::_RESET_TIMES => array(
            'name' => '_reset_times',
            'required' => true,
            'type' => 5,
        ),
        self::_LAST_RESET_DATE => array(
            'name' => '_last_reset_date',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_SKILL_LEVELUP_CHANCE] = null;
        $this->values[self::_SKILL_LEVELUP_CD] = null;
        $this->values[self::_RESET_TIMES] = null;
        $this->values[self::_LAST_RESET_DATE] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_skill_levelup_chance' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSkillLevelupChance($value)
    {
        return $this->set(self::_SKILL_LEVELUP_CHANCE, $value);
    }

    /**
     * Returns value of '_skill_levelup_chance' property
     *
     * @return int
     */
    public function getSkillLevelupChance()
    {
        return $this->get(self::_SKILL_LEVELUP_CHANCE);
    }

    /**
     * Sets value of '_skill_levelup_cd' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSkillLevelupCd($value)
    {
        return $this->set(self::_SKILL_LEVELUP_CD, $value);
    }

    /**
     * Returns value of '_skill_levelup_cd' property
     *
     * @return int
     */
    public function getSkillLevelupCd()
    {
        return $this->get(self::_SKILL_LEVELUP_CD);
    }

    /**
     * Sets value of '_reset_times' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResetTimes($value)
    {
        return $this->set(self::_RESET_TIMES, $value);
    }

    /**
     * Returns value of '_reset_times' property
     *
     * @return int
     */
    public function getResetTimes()
    {
        return $this->get(self::_RESET_TIMES);
    }

    /**
     * Sets value of '_last_reset_date' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLastResetDate($value)
    {
        return $this->set(self::_LAST_RESET_DATE, $value);
    }

    /**
     * Returns value of '_last_reset_date' property
     *
     * @return int
     */
    public function getLastResetDate()
    {
        return $this->get(self::_LAST_RESET_DATE);
    }
}

/**
 * status enum embedded in usertask message
 */
final class Down_Usertask_Status
{
    const finished = 0;
    const working = 1;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'finished' => self::finished,
            'working' => self::working,
        );
    }
}

/**
 * usertask message
 */
class Down_Usertask extends \ProtobufMessage
{
    /* Field index constants */
    const _LINE = 1;
    const _ID = 2;
    const _STATUS = 3;
    const _TASK_TARGET = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_LINE => array(
            'name' => '_line',
            'required' => true,
            'type' => 5,
        ),
        self::_ID => array(
            'name' => '_id',
            'required' => true,
            'type' => 5,
        ),
        self::_STATUS => array(
            'default' => Down_Usertask_Status::working, 
            'name' => '_status',
            'required' => true,
            'type' => 5,
        ),
        self::_TASK_TARGET => array(
            'name' => '_task_target',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_LINE] = null;
        $this->values[self::_ID] = null;
        $this->values[self::_STATUS] = null;
        $this->values[self::_TASK_TARGET] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_line' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLine($value)
    {
        return $this->set(self::_LINE, $value);
    }

    /**
     * Returns value of '_line' property
     *
     * @return int
     */
    public function getLine()
    {
        return $this->get(self::_LINE);
    }

    /**
     * Sets value of '_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setId($value)
    {
        return $this->set(self::_ID, $value);
    }

    /**
     * Returns value of '_id' property
     *
     * @return int
     */
    public function getId()
    {
        return $this->get(self::_ID);
    }

    /**
     * Sets value of '_status' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStatus($value)
    {
        return $this->set(self::_STATUS, $value);
    }

    /**
     * Returns value of '_status' property
     *
     * @return int
     */
    public function getStatus()
    {
        return $this->get(self::_STATUS);
    }

    /**
     * Sets value of '_task_target' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setTaskTarget($value)
    {
        return $this->set(self::_TASK_TARGET, $value);
    }

    /**
     * Returns value of '_task_target' property
     *
     * @return int
     */
    public function getTaskTarget()
    {
        return $this->get(self::_TASK_TARGET);
    }
}

/**
 * dailyjob message
 */
class Down_Dailyjob extends \ProtobufMessage
{
    /* Field index constants */
    const _ID = 1;
    const _LAST_REWARDS_TIME = 2;
    const _TASK_TARGET = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ID => array(
            'name' => '_id',
            'required' => true,
            'type' => 5,
        ),
        self::_LAST_REWARDS_TIME => array(
            'name' => '_last_rewards_time',
            'required' => true,
            'type' => 5,
        ),
        self::_TASK_TARGET => array(
            'name' => '_task_target',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ID] = null;
        $this->values[self::_LAST_REWARDS_TIME] = null;
        $this->values[self::_TASK_TARGET] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setId($value)
    {
        return $this->set(self::_ID, $value);
    }

    /**
     * Returns value of '_id' property
     *
     * @return int
     */
    public function getId()
    {
        return $this->get(self::_ID);
    }

    /**
     * Sets value of '_last_rewards_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLastRewardsTime($value)
    {
        return $this->set(self::_LAST_REWARDS_TIME, $value);
    }

    /**
     * Returns value of '_last_rewards_time' property
     *
     * @return int
     */
    public function getLastRewardsTime()
    {
        return $this->get(self::_LAST_REWARDS_TIME);
    }

    /**
     * Sets value of '_task_target' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setTaskTarget($value)
    {
        return $this->set(self::_TASK_TARGET, $value);
    }

    /**
     * Returns value of '_task_target' property
     *
     * @return int
     */
    public function getTaskTarget()
    {
        return $this->get(self::_TASK_TARGET);
    }
}

/**
 * sweeploot message
 */
class Down_Sweeploot extends \ProtobufMessage
{
    /* Field index constants */
    const _EXP = 1;
    const _MONEY = 2;
    const _ITEMS = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_EXP => array(
            'name' => '_exp',
            'required' => true,
            'type' => 5,
        ),
        self::_MONEY => array(
            'name' => '_money',
            'required' => true,
            'type' => 5,
        ),
        self::_ITEMS => array(
            'name' => '_items',
            'repeated' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_EXP] = null;
        $this->values[self::_MONEY] = null;
        $this->values[self::_ITEMS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_exp' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setExp($value)
    {
        return $this->set(self::_EXP, $value);
    }

    /**
     * Returns value of '_exp' property
     *
     * @return int
     */
    public function getExp()
    {
        return $this->get(self::_EXP);
    }

    /**
     * Sets value of '_money' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setMoney($value)
    {
        return $this->set(self::_MONEY, $value);
    }

    /**
     * Returns value of '_money' property
     *
     * @return int
     */
    public function getMoney()
    {
        return $this->get(self::_MONEY);
    }

    /**
     * Appends value to '_items' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendItems($value)
    {
        return $this->append(self::_ITEMS, $value);
    }

    /**
     * Clears '_items' list
     *
     * @return null
     */
    public function clearItems()
    {
        return $this->clear(self::_ITEMS);
    }

    /**
     * Returns '_items' list
     *
     * @return int[]
     */
    public function getItems()
    {
        return $this->get(self::_ITEMS);
    }

    /**
     * Returns '_items' iterator
     *
     * @return ArrayIterator
     */
    public function getItemsIterator()
    {
        return new \ArrayIterator($this->get(self::_ITEMS));
    }

    /**
     * Returns element from '_items' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getItemsAt($offset)
    {
        return $this->get(self::_ITEMS, $offset);
    }

    /**
     * Returns count of '_items' list
     *
     * @return int
     */
    public function getItemsCount()
    {
        return $this->count(self::_ITEMS);
    }
}

/**
 * box_type enum embedded in tavern_record message
 */
final class Down_TavernRecord_BoxType
{
    const green = 1;
    const blue = 2;
    const purple = 3;
    const magicsoul = 4;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'green' => self::green,
            'blue' => self::blue,
            'purple' => self::purple,
            'magicsoul' => self::magicsoul,
        );
    }
}

/**
 * tavern_record message
 */
class Down_TavernRecord extends \ProtobufMessage
{
    /* Field index constants */
    const _BOX_TYPE = 1;
    const _LEFT_CNT = 2;
    const _LAST_GET_TIME = 3;
    const _HAS_FIRST_DRAW = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_BOX_TYPE => array(
            'default' => Down_TavernRecord_BoxType::green, 
            'name' => '_box_type',
            'required' => true,
            'type' => 5,
        ),
        self::_LEFT_CNT => array(
            'name' => '_left_cnt',
            'required' => true,
            'type' => 5,
        ),
        self::_LAST_GET_TIME => array(
            'name' => '_last_get_time',
            'required' => true,
            'type' => 5,
        ),
        self::_HAS_FIRST_DRAW => array(
            'name' => '_has_first_draw',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_BOX_TYPE] = null;
        $this->values[self::_LEFT_CNT] = null;
        $this->values[self::_LAST_GET_TIME] = null;
        $this->values[self::_HAS_FIRST_DRAW] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_box_type' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setBoxType($value)
    {
        return $this->set(self::_BOX_TYPE, $value);
    }

    /**
     * Returns value of '_box_type' property
     *
     * @return int
     */
    public function getBoxType()
    {
        return $this->get(self::_BOX_TYPE);
    }

    /**
     * Sets value of '_left_cnt' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLeftCnt($value)
    {
        return $this->set(self::_LEFT_CNT, $value);
    }

    /**
     * Returns value of '_left_cnt' property
     *
     * @return int
     */
    public function getLeftCnt()
    {
        return $this->get(self::_LEFT_CNT);
    }

    /**
     * Sets value of '_last_get_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLastGetTime($value)
    {
        return $this->set(self::_LAST_GET_TIME, $value);
    }

    /**
     * Returns value of '_last_get_time' property
     *
     * @return int
     */
    public function getLastGetTime()
    {
        return $this->get(self::_LAST_GET_TIME);
    }

    /**
     * Sets value of '_has_first_draw' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setHasFirstDraw($value)
    {
        return $this->set(self::_HAS_FIRST_DRAW, $value);
    }

    /**
     * Returns value of '_has_first_draw' property
     *
     * @return int
     */
    public function getHasFirstDraw()
    {
        return $this->get(self::_HAS_FIRST_DRAW);
    }
}

/**
 * usermidas message
 */
class Down_Usermidas extends \ProtobufMessage
{
    /* Field index constants */
    const _LAST_CHANGE = 1;
    const _TODAY_TIMES = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_LAST_CHANGE => array(
            'name' => '_last_change',
            'required' => true,
            'type' => 5,
        ),
        self::_TODAY_TIMES => array(
            'name' => '_today_times',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_LAST_CHANGE] = null;
        $this->values[self::_TODAY_TIMES] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_last_change' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLastChange($value)
    {
        return $this->set(self::_LAST_CHANGE, $value);
    }

    /**
     * Returns value of '_last_change' property
     *
     * @return int
     */
    public function getLastChange()
    {
        return $this->get(self::_LAST_CHANGE);
    }

    /**
     * Sets value of '_today_times' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setTodayTimes($value)
    {
        return $this->set(self::_TODAY_TIMES, $value);
    }

    /**
     * Returns value of '_today_times' property
     *
     * @return int
     */
    public function getTodayTimes()
    {
        return $this->get(self::_TODAY_TIMES);
    }
}

/**
 * trigger_task_reply message
 */
class Down_TriggerTaskReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_Result::success, 
            'name' => '_result',
            'repeated' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_result' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendResult($value)
    {
        return $this->append(self::_RESULT, $value);
    }

    /**
     * Clears '_result' list
     *
     * @return null
     */
    public function clearResult()
    {
        return $this->clear(self::_RESULT);
    }

    /**
     * Returns '_result' list
     *
     * @return int[]
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Returns '_result' iterator
     *
     * @return ArrayIterator
     */
    public function getResultIterator()
    {
        return new \ArrayIterator($this->get(self::_RESULT));
    }

    /**
     * Returns element from '_result' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getResultAt($offset)
    {
        return $this->get(self::_RESULT, $offset);
    }

    /**
     * Returns count of '_result' list
     *
     * @return int
     */
    public function getResultCount()
    {
        return $this->count(self::_RESULT);
    }
}

/**
 * require_rewards_reply message
 */
class Down_RequireRewardsReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_Result::success, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }
}

/**
 * trigger_job_reply message
 */
class Down_TriggerJobReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_Result::success, 
            'name' => '_result',
            'repeated' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_result' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendResult($value)
    {
        return $this->append(self::_RESULT, $value);
    }

    /**
     * Clears '_result' list
     *
     * @return null
     */
    public function clearResult()
    {
        return $this->clear(self::_RESULT);
    }

    /**
     * Returns '_result' list
     *
     * @return int[]
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Returns '_result' iterator
     *
     * @return ArrayIterator
     */
    public function getResultIterator()
    {
        return new \ArrayIterator($this->get(self::_RESULT));
    }

    /**
     * Returns element from '_result' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getResultAt($offset)
    {
        return $this->get(self::_RESULT, $offset);
    }

    /**
     * Returns count of '_result' list
     *
     * @return int
     */
    public function getResultCount()
    {
        return $this->count(self::_RESULT);
    }
}

/**
 * type enum embedded in dailyjob_reward message
 */
final class Down_DailyjobReward_Type
{
    const rmb = 1;
    const money = 2;
    const item = 3;
    const hero = 4;
    const vitality = 5;
    const playerexp = 6;
    const crusadepoint = 7;
    const arenapoint = 8;
    const guildpoint = 9;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'rmb' => self::rmb,
            'money' => self::money,
            'item' => self::item,
            'hero' => self::hero,
            'vitality' => self::vitality,
            'playerexp' => self::playerexp,
            'crusadepoint' => self::crusadepoint,
            'arenapoint' => self::arenapoint,
            'guildpoint' => self::guildpoint,
        );
    }
}

/**
 * dailyjob_reward message
 */
class Down_DailyjobReward extends \ProtobufMessage
{
    /* Field index constants */
    const _TYPE = 1;
    const _ID = 2;
    const _AMOUNT = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TYPE => array(
            'name' => '_type',
            'required' => false,
            'type' => 5,
        ),
        self::_ID => array(
            'name' => '_id',
            'required' => false,
            'type' => 5,
        ),
        self::_AMOUNT => array(
            'name' => '_amount',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_TYPE] = null;
        $this->values[self::_ID] = null;
        $this->values[self::_AMOUNT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_type' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setType($value)
    {
        return $this->set(self::_TYPE, $value);
    }

    /**
     * Returns value of '_type' property
     *
     * @return int
     */
    public function getType()
    {
        return $this->get(self::_TYPE);
    }

    /**
     * Sets value of '_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setId($value)
    {
        return $this->set(self::_ID, $value);
    }

    /**
     * Returns value of '_id' property
     *
     * @return int
     */
    public function getId()
    {
        return $this->get(self::_ID);
    }

    /**
     * Sets value of '_amount' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setAmount($value)
    {
        return $this->set(self::_AMOUNT, $value);
    }

    /**
     * Returns value of '_amount' property
     *
     * @return int
     */
    public function getAmount()
    {
        return $this->get(self::_AMOUNT);
    }
}

/**
 * job_rewards_reply message
 */
class Down_JobRewardsReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _ACTIVITY_REWARD = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_Result::success, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_ACTIVITY_REWARD => array(
            'name' => '_activity_reward',
            'repeated' => true,
            'type' => 'Down_DailyjobReward'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_ACTIVITY_REWARD] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Appends value to '_activity_reward' list
     *
     * @param Down_DailyjobReward $value Value to append
     *
     * @return null
     */
    public function appendActivityReward(Down_DailyjobReward $value)
    {
        return $this->append(self::_ACTIVITY_REWARD, $value);
    }

    /**
     * Clears '_activity_reward' list
     *
     * @return null
     */
    public function clearActivityReward()
    {
        return $this->clear(self::_ACTIVITY_REWARD);
    }

    /**
     * Returns '_activity_reward' list
     *
     * @return Down_DailyjobReward[]
     */
    public function getActivityReward()
    {
        return $this->get(self::_ACTIVITY_REWARD);
    }

    /**
     * Returns '_activity_reward' iterator
     *
     * @return ArrayIterator
     */
    public function getActivityRewardIterator()
    {
        return new \ArrayIterator($this->get(self::_ACTIVITY_REWARD));
    }

    /**
     * Returns element from '_activity_reward' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_DailyjobReward
     */
    public function getActivityRewardAt($offset)
    {
        return $this->get(self::_ACTIVITY_REWARD, $offset);
    }

    /**
     * Returns count of '_activity_reward' list
     *
     * @return int
     */
    public function getActivityRewardCount()
    {
        return $this->count(self::_ACTIVITY_REWARD);
    }
}

/**
 * tavern_draw_reply message
 */
class Down_TavernDrawReply extends \ProtobufMessage
{
    /* Field index constants */
    const _ITEM_IDS = 1;
    const _NEW_HEROES = 2;
    const _SMASH_IDX = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ITEM_IDS => array(
            'name' => '_item_ids',
            'repeated' => true,
            'type' => 5,
        ),
        self::_NEW_HEROES => array(
            'name' => '_new_heroes',
            'repeated' => true,
            'type' => 'Down_Hero'
        ),
        self::_SMASH_IDX => array(
            'name' => '_smash_idx',
            'repeated' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ITEM_IDS] = array();
        $this->values[self::_NEW_HEROES] = array();
        $this->values[self::_SMASH_IDX] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_item_ids' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendItemIds($value)
    {
        return $this->append(self::_ITEM_IDS, $value);
    }

    /**
     * Clears '_item_ids' list
     *
     * @return null
     */
    public function clearItemIds()
    {
        return $this->clear(self::_ITEM_IDS);
    }

    /**
     * Returns '_item_ids' list
     *
     * @return int[]
     */
    public function getItemIds()
    {
        return $this->get(self::_ITEM_IDS);
    }

    /**
     * Returns '_item_ids' iterator
     *
     * @return ArrayIterator
     */
    public function getItemIdsIterator()
    {
        return new \ArrayIterator($this->get(self::_ITEM_IDS));
    }

    /**
     * Returns element from '_item_ids' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getItemIdsAt($offset)
    {
        return $this->get(self::_ITEM_IDS, $offset);
    }

    /**
     * Returns count of '_item_ids' list
     *
     * @return int
     */
    public function getItemIdsCount()
    {
        return $this->count(self::_ITEM_IDS);
    }

    /**
     * Appends value to '_new_heroes' list
     *
     * @param Down_Hero $value Value to append
     *
     * @return null
     */
    public function appendNewHeroes(Down_Hero $value)
    {
        return $this->append(self::_NEW_HEROES, $value);
    }

    /**
     * Clears '_new_heroes' list
     *
     * @return null
     */
    public function clearNewHeroes()
    {
        return $this->clear(self::_NEW_HEROES);
    }

    /**
     * Returns '_new_heroes' list
     *
     * @return Down_Hero[]
     */
    public function getNewHeroes()
    {
        return $this->get(self::_NEW_HEROES);
    }

    /**
     * Returns '_new_heroes' iterator
     *
     * @return ArrayIterator
     */
    public function getNewHeroesIterator()
    {
        return new \ArrayIterator($this->get(self::_NEW_HEROES));
    }

    /**
     * Returns element from '_new_heroes' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_Hero
     */
    public function getNewHeroesAt($offset)
    {
        return $this->get(self::_NEW_HEROES, $offset);
    }

    /**
     * Returns count of '_new_heroes' list
     *
     * @return int
     */
    public function getNewHeroesCount()
    {
        return $this->count(self::_NEW_HEROES);
    }

    /**
     * Appends value to '_smash_idx' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendSmashIdx($value)
    {
        return $this->append(self::_SMASH_IDX, $value);
    }

    /**
     * Clears '_smash_idx' list
     *
     * @return null
     */
    public function clearSmashIdx()
    {
        return $this->clear(self::_SMASH_IDX);
    }

    /**
     * Returns '_smash_idx' list
     *
     * @return int[]
     */
    public function getSmashIdx()
    {
        return $this->get(self::_SMASH_IDX);
    }

    /**
     * Returns '_smash_idx' iterator
     *
     * @return ArrayIterator
     */
    public function getSmashIdxIterator()
    {
        return new \ArrayIterator($this->get(self::_SMASH_IDX));
    }

    /**
     * Returns element from '_smash_idx' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getSmashIdxAt($offset)
    {
        return $this->get(self::_SMASH_IDX, $offset);
    }

    /**
     * Returns count of '_smash_idx' list
     *
     * @return int
     */
    public function getSmashIdxCount()
    {
        return $this->count(self::_SMASH_IDX);
    }
}

/**
 * reset_elite_reply message
 */
class Down_ResetEliteReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_Result::success, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }
}

/**
 * sweep_stage_reply message
 */
class Down_SweepStageReply extends \ProtobufMessage
{
    /* Field index constants */
    const _LOOT = 1;
    const _ITEMS = 2;
    const _SHOP = 3;
    const _SSHOP = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_LOOT => array(
            'name' => '_loot',
            'repeated' => true,
            'type' => 'Down_Sweeploot'
        ),
        self::_ITEMS => array(
            'name' => '_items',
            'repeated' => true,
            'type' => 5,
        ),
        self::_SHOP => array(
            'name' => '_shop',
            'required' => false,
            'type' => 'Down_UserShop'
        ),
        self::_SSHOP => array(
            'name' => '_sshop',
            'required' => false,
            'type' => 'Down_StarShop'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_LOOT] = array();
        $this->values[self::_ITEMS] = array();
        $this->values[self::_SHOP] = null;
        $this->values[self::_SSHOP] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_loot' list
     *
     * @param Down_Sweeploot $value Value to append
     *
     * @return null
     */
    public function appendLoot(Down_Sweeploot $value)
    {
        return $this->append(self::_LOOT, $value);
    }

    /**
     * Clears '_loot' list
     *
     * @return null
     */
    public function clearLoot()
    {
        return $this->clear(self::_LOOT);
    }

    /**
     * Returns '_loot' list
     *
     * @return Down_Sweeploot[]
     */
    public function getLoot()
    {
        return $this->get(self::_LOOT);
    }

    /**
     * Returns '_loot' iterator
     *
     * @return ArrayIterator
     */
    public function getLootIterator()
    {
        return new \ArrayIterator($this->get(self::_LOOT));
    }

    /**
     * Returns element from '_loot' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_Sweeploot
     */
    public function getLootAt($offset)
    {
        return $this->get(self::_LOOT, $offset);
    }

    /**
     * Returns count of '_loot' list
     *
     * @return int
     */
    public function getLootCount()
    {
        return $this->count(self::_LOOT);
    }

    /**
     * Appends value to '_items' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendItems($value)
    {
        return $this->append(self::_ITEMS, $value);
    }

    /**
     * Clears '_items' list
     *
     * @return null
     */
    public function clearItems()
    {
        return $this->clear(self::_ITEMS);
    }

    /**
     * Returns '_items' list
     *
     * @return int[]
     */
    public function getItems()
    {
        return $this->get(self::_ITEMS);
    }

    /**
     * Returns '_items' iterator
     *
     * @return ArrayIterator
     */
    public function getItemsIterator()
    {
        return new \ArrayIterator($this->get(self::_ITEMS));
    }

    /**
     * Returns element from '_items' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getItemsAt($offset)
    {
        return $this->get(self::_ITEMS, $offset);
    }

    /**
     * Returns count of '_items' list
     *
     * @return int
     */
    public function getItemsCount()
    {
        return $this->count(self::_ITEMS);
    }

    /**
     * Sets value of '_shop' property
     *
     * @param Down_UserShop $value Property value
     *
     * @return null
     */
    public function setShop(Down_UserShop $value)
    {
        return $this->set(self::_SHOP, $value);
    }

    /**
     * Returns value of '_shop' property
     *
     * @return Down_UserShop
     */
    public function getShop()
    {
        return $this->get(self::_SHOP);
    }

    /**
     * Sets value of '_sshop' property
     *
     * @param Down_StarShop $value Property value
     *
     * @return null
     */
    public function setSshop(Down_StarShop $value)
    {
        return $this->set(self::_SSHOP, $value);
    }

    /**
     * Returns value of '_sshop' property
     *
     * @return Down_StarShop
     */
    public function getSshop()
    {
        return $this->get(self::_SSHOP);
    }
}

/**
 * sweep message
 */
class Down_Sweep extends \ProtobufMessage
{
    /* Field index constants */
    const _LAST_RESET_TIME = 1;
    const _TODAY_FREE_SWEEP_TIMES = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_LAST_RESET_TIME => array(
            'name' => '_last_reset_time',
            'required' => true,
            'type' => 5,
        ),
        self::_TODAY_FREE_SWEEP_TIMES => array(
            'name' => '_today_free_sweep_times',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_LAST_RESET_TIME] = null;
        $this->values[self::_TODAY_FREE_SWEEP_TIMES] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_last_reset_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLastResetTime($value)
    {
        return $this->set(self::_LAST_RESET_TIME, $value);
    }

    /**
     * Returns value of '_last_reset_time' property
     *
     * @return int
     */
    public function getLastResetTime()
    {
        return $this->get(self::_LAST_RESET_TIME);
    }

    /**
     * Sets value of '_today_free_sweep_times' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setTodayFreeSweepTimes($value)
    {
        return $this->set(self::_TODAY_FREE_SWEEP_TIMES, $value);
    }

    /**
     * Returns value of '_today_free_sweep_times' property
     *
     * @return int
     */
    public function getTodayFreeSweepTimes()
    {
        return $this->get(self::_TODAY_FREE_SWEEP_TIMES);
    }
}

/**
 * sync_skill_stren_reply message
 */
class Down_SyncSkillStrenReply extends \ProtobufMessage
{
    /* Field index constants */
    const _SKILL_LEVEL_UP = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_SKILL_LEVEL_UP => array(
            'name' => '_skill_level_up',
            'required' => true,
            'type' => 'Down_Skilllevelup'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_SKILL_LEVEL_UP] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_skill_level_up' property
     *
     * @param Down_Skilllevelup $value Property value
     *
     * @return null
     */
    public function setSkillLevelUp(Down_Skilllevelup $value)
    {
        return $this->set(self::_SKILL_LEVEL_UP, $value);
    }

    /**
     * Returns value of '_skill_level_up' property
     *
     * @return Down_Skilllevelup
     */
    public function getSkillLevelUp()
    {
        return $this->get(self::_SKILL_LEVEL_UP);
    }
}

/**
 * hero_evolve_reply message
 */
class Down_HeroEvolveReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _HERO = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_Result::success, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_HERO => array(
            'name' => '_hero',
            'required' => false,
            'type' => 'Down_Hero'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_HERO] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_hero' property
     *
     * @param Down_Hero $value Property value
     *
     * @return null
     */
    public function setHero(Down_Hero $value)
    {
        return $this->set(self::_HERO, $value);
    }

    /**
     * Returns value of '_hero' property
     *
     * @return Down_Hero
     */
    public function getHero()
    {
        return $this->get(self::_HERO);
    }
}

/**
 * vitality message
 */
class Down_Vitality extends \ProtobufMessage
{
    /* Field index constants */
    const _CURRENT = 1;
    const _LASTCHANGE = 2;
    const _TODAYBUY = 3;
    const _LASTBUY = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_CURRENT => array(
            'name' => '_current',
            'required' => true,
            'type' => 5,
        ),
        self::_LASTCHANGE => array(
            'name' => '_lastchange',
            'required' => true,
            'type' => 5,
        ),
        self::_TODAYBUY => array(
            'name' => '_todaybuy',
            'required' => true,
            'type' => 5,
        ),
        self::_LASTBUY => array(
            'name' => '_lastbuy',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_CURRENT] = null;
        $this->values[self::_LASTCHANGE] = null;
        $this->values[self::_TODAYBUY] = null;
        $this->values[self::_LASTBUY] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_current' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCurrent($value)
    {
        return $this->set(self::_CURRENT, $value);
    }

    /**
     * Returns value of '_current' property
     *
     * @return int
     */
    public function getCurrent()
    {
        return $this->get(self::_CURRENT);
    }

    /**
     * Sets value of '_lastchange' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLastchange($value)
    {
        return $this->set(self::_LASTCHANGE, $value);
    }

    /**
     * Returns value of '_lastchange' property
     *
     * @return int
     */
    public function getLastchange()
    {
        return $this->get(self::_LASTCHANGE);
    }

    /**
     * Sets value of '_todaybuy' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setTodaybuy($value)
    {
        return $this->set(self::_TODAYBUY, $value);
    }

    /**
     * Returns value of '_todaybuy' property
     *
     * @return int
     */
    public function getTodaybuy()
    {
        return $this->get(self::_TODAYBUY);
    }

    /**
     * Sets value of '_lastbuy' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLastbuy($value)
    {
        return $this->set(self::_LASTBUY, $value);
    }

    /**
     * Returns value of '_lastbuy' property
     *
     * @return int
     */
    public function getLastbuy()
    {
        return $this->get(self::_LASTBUY);
    }
}

/**
 * userstage message
 */
class Down_Userstage extends \ProtobufMessage
{
    /* Field index constants */
    const _NORMAL_STAGE_STARS = 1;
    const _ELITE_STAGE_STARS = 2;
    const _ELITE_DAILY_RECORD = 3;
    const _ELITE_RESET_TIME = 4;
    const _SWEEP = 5;
    const _ACT_DAILY_RECORD = 6;
    const _ACT_RESET_TIME = 7;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_NORMAL_STAGE_STARS => array(
            'name' => '_normal_stage_stars',
            'repeated' => true,
            'type' => 5,
        ),
        self::_ELITE_STAGE_STARS => array(
            'name' => '_elite_stage_stars',
            'repeated' => true,
            'type' => 5,
        ),
        self::_ELITE_DAILY_RECORD => array(
            'name' => '_elite_daily_record',
            'repeated' => true,
            'type' => 5,
        ),
        self::_ELITE_RESET_TIME => array(
            'name' => '_elite_reset_time',
            'required' => true,
            'type' => 5,
        ),
        self::_SWEEP => array(
            'name' => '_sweep',
            'required' => true,
            'type' => 'Down_Sweep'
        ),
        self::_ACT_DAILY_RECORD => array(
            'name' => '_act_daily_record',
            'repeated' => true,
            'type' => 'Down_ActDailyRecord'
        ),
        self::_ACT_RESET_TIME => array(
            'name' => '_act_reset_time',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_NORMAL_STAGE_STARS] = array();
        $this->values[self::_ELITE_STAGE_STARS] = array();
        $this->values[self::_ELITE_DAILY_RECORD] = array();
        $this->values[self::_ELITE_RESET_TIME] = null;
        $this->values[self::_SWEEP] = null;
        $this->values[self::_ACT_DAILY_RECORD] = array();
        $this->values[self::_ACT_RESET_TIME] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_normal_stage_stars' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendNormalStageStars($value)
    {
        return $this->append(self::_NORMAL_STAGE_STARS, $value);
    }

    /**
     * Clears '_normal_stage_stars' list
     *
     * @return null
     */
    public function clearNormalStageStars()
    {
        return $this->clear(self::_NORMAL_STAGE_STARS);
    }

    /**
     * Returns '_normal_stage_stars' list
     *
     * @return int[]
     */
    public function getNormalStageStars()
    {
        return $this->get(self::_NORMAL_STAGE_STARS);
    }

    /**
     * Returns '_normal_stage_stars' iterator
     *
     * @return ArrayIterator
     */
    public function getNormalStageStarsIterator()
    {
        return new \ArrayIterator($this->get(self::_NORMAL_STAGE_STARS));
    }

    /**
     * Returns element from '_normal_stage_stars' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getNormalStageStarsAt($offset)
    {
        return $this->get(self::_NORMAL_STAGE_STARS, $offset);
    }

    /**
     * Returns count of '_normal_stage_stars' list
     *
     * @return int
     */
    public function getNormalStageStarsCount()
    {
        return $this->count(self::_NORMAL_STAGE_STARS);
    }

    /**
     * Appends value to '_elite_stage_stars' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendEliteStageStars($value)
    {
        return $this->append(self::_ELITE_STAGE_STARS, $value);
    }

    /**
     * Clears '_elite_stage_stars' list
     *
     * @return null
     */
    public function clearEliteStageStars()
    {
        return $this->clear(self::_ELITE_STAGE_STARS);
    }

    /**
     * Returns '_elite_stage_stars' list
     *
     * @return int[]
     */
    public function getEliteStageStars()
    {
        return $this->get(self::_ELITE_STAGE_STARS);
    }

    /**
     * Returns '_elite_stage_stars' iterator
     *
     * @return ArrayIterator
     */
    public function getEliteStageStarsIterator()
    {
        return new \ArrayIterator($this->get(self::_ELITE_STAGE_STARS));
    }

    /**
     * Returns element from '_elite_stage_stars' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getEliteStageStarsAt($offset)
    {
        return $this->get(self::_ELITE_STAGE_STARS, $offset);
    }

    /**
     * Returns count of '_elite_stage_stars' list
     *
     * @return int
     */
    public function getEliteStageStarsCount()
    {
        return $this->count(self::_ELITE_STAGE_STARS);
    }

    /**
     * Appends value to '_elite_daily_record' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendEliteDailyRecord($value)
    {
        return $this->append(self::_ELITE_DAILY_RECORD, $value);
    }

    /**
     * Clears '_elite_daily_record' list
     *
     * @return null
     */
    public function clearEliteDailyRecord()
    {
        return $this->clear(self::_ELITE_DAILY_RECORD);
    }

    /**
     * Returns '_elite_daily_record' list
     *
     * @return int[]
     */
    public function getEliteDailyRecord()
    {
        return $this->get(self::_ELITE_DAILY_RECORD);
    }

    /**
     * Returns '_elite_daily_record' iterator
     *
     * @return ArrayIterator
     */
    public function getEliteDailyRecordIterator()
    {
        return new \ArrayIterator($this->get(self::_ELITE_DAILY_RECORD));
    }

    /**
     * Returns element from '_elite_daily_record' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getEliteDailyRecordAt($offset)
    {
        return $this->get(self::_ELITE_DAILY_RECORD, $offset);
    }

    /**
     * Returns count of '_elite_daily_record' list
     *
     * @return int
     */
    public function getEliteDailyRecordCount()
    {
        return $this->count(self::_ELITE_DAILY_RECORD);
    }

    /**
     * Sets value of '_elite_reset_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setEliteResetTime($value)
    {
        return $this->set(self::_ELITE_RESET_TIME, $value);
    }

    /**
     * Returns value of '_elite_reset_time' property
     *
     * @return int
     */
    public function getEliteResetTime()
    {
        return $this->get(self::_ELITE_RESET_TIME);
    }

    /**
     * Sets value of '_sweep' property
     *
     * @param Down_Sweep $value Property value
     *
     * @return null
     */
    public function setSweep(Down_Sweep $value)
    {
        return $this->set(self::_SWEEP, $value);
    }

    /**
     * Returns value of '_sweep' property
     *
     * @return Down_Sweep
     */
    public function getSweep()
    {
        return $this->get(self::_SWEEP);
    }

    /**
     * Appends value to '_act_daily_record' list
     *
     * @param Down_ActDailyRecord $value Value to append
     *
     * @return null
     */
    public function appendActDailyRecord(Down_ActDailyRecord $value)
    {
        return $this->append(self::_ACT_DAILY_RECORD, $value);
    }

    /**
     * Clears '_act_daily_record' list
     *
     * @return null
     */
    public function clearActDailyRecord()
    {
        return $this->clear(self::_ACT_DAILY_RECORD);
    }

    /**
     * Returns '_act_daily_record' list
     *
     * @return Down_ActDailyRecord[]
     */
    public function getActDailyRecord()
    {
        return $this->get(self::_ACT_DAILY_RECORD);
    }

    /**
     * Returns '_act_daily_record' iterator
     *
     * @return ArrayIterator
     */
    public function getActDailyRecordIterator()
    {
        return new \ArrayIterator($this->get(self::_ACT_DAILY_RECORD));
    }

    /**
     * Returns element from '_act_daily_record' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_ActDailyRecord
     */
    public function getActDailyRecordAt($offset)
    {
        return $this->get(self::_ACT_DAILY_RECORD, $offset);
    }

    /**
     * Returns count of '_act_daily_record' list
     *
     * @return int
     */
    public function getActDailyRecordCount()
    {
        return $this->count(self::_ACT_DAILY_RECORD);
    }

    /**
     * Sets value of '_act_reset_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setActResetTime($value)
    {
        return $this->set(self::_ACT_RESET_TIME, $value);
    }

    /**
     * Returns value of '_act_reset_time' property
     *
     * @return int
     */
    public function getActResetTime()
    {
        return $this->get(self::_ACT_RESET_TIME);
    }
}

/**
 * act_daily_record message
 */
class Down_ActDailyRecord extends \ProtobufMessage
{
    /* Field index constants */
    const _ID = 1;
    const _FREQUENCY = 2;
    const _LAST_CHANGE = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ID => array(
            'name' => '_id',
            'required' => true,
            'type' => 5,
        ),
        self::_FREQUENCY => array(
            'name' => '_frequency',
            'required' => true,
            'type' => 5,
        ),
        self::_LAST_CHANGE => array(
            'name' => '_last_change',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ID] = null;
        $this->values[self::_FREQUENCY] = null;
        $this->values[self::_LAST_CHANGE] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setId($value)
    {
        return $this->set(self::_ID, $value);
    }

    /**
     * Returns value of '_id' property
     *
     * @return int
     */
    public function getId()
    {
        return $this->get(self::_ID);
    }

    /**
     * Sets value of '_frequency' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setFrequency($value)
    {
        return $this->set(self::_FREQUENCY, $value);
    }

    /**
     * Returns value of '_frequency' property
     *
     * @return int
     */
    public function getFrequency()
    {
        return $this->get(self::_FREQUENCY);
    }

    /**
     * Sets value of '_last_change' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLastChange($value)
    {
        return $this->set(self::_LAST_CHANGE, $value);
    }

    /**
     * Returns value of '_last_change' property
     *
     * @return int
     */
    public function getLastChange()
    {
        return $this->get(self::_LAST_CHANGE);
    }
}

/**
 * ladder_reply message
 */
class Down_LadderReply extends \ProtobufMessage
{
    /* Field index constants */
    const _OPEN_PANEL = 1;
    const _APPLY_OPPO = 2;
    const _START_BATTLE = 3;
    const _END_BATTLE = 4;
    const _SET_LINEUP = 5;
    const _QUERY_RECORDS = 6;
    const _QUERY_REPLAY = 7;
    const _QUERY_RANKBORAD = 8;
    const _QUERY_OPPO = 9;
    const _CLEAR_BATTLE_CD = 10;
    const _DRAW_RANK_REWARD = 11;
    const _BUY_BATTLE_CHANCE = 12;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_OPEN_PANEL => array(
            'name' => '_open_panel',
            'required' => false,
            'type' => 'Down_OpenPanel'
        ),
        self::_APPLY_OPPO => array(
            'name' => '_apply_oppo',
            'required' => false,
            'type' => 'Down_ApplyOpponent'
        ),
        self::_START_BATTLE => array(
            'name' => '_start_battle',
            'required' => false,
            'type' => 'Down_StartBattle'
        ),
        self::_END_BATTLE => array(
            'name' => '_end_battle',
            'required' => false,
            'type' => 'Down_EndBattle'
        ),
        self::_SET_LINEUP => array(
            'name' => '_set_lineup',
            'required' => false,
            'type' => 'Down_SetLineup'
        ),
        self::_QUERY_RECORDS => array(
            'name' => '_query_records',
            'required' => false,
            'type' => 'Down_QueryRecords'
        ),
        self::_QUERY_REPLAY => array(
            'name' => '_query_replay',
            'required' => false,
            'type' => 'Down_QueryReplay'
        ),
        self::_QUERY_RANKBORAD => array(
            'name' => '_query_rankborad',
            'required' => false,
            'type' => 'Down_QueryRankboard'
        ),
        self::_QUERY_OPPO => array(
            'name' => '_query_oppo',
            'required' => false,
            'type' => 'Down_QueryOppoInfo'
        ),
        self::_CLEAR_BATTLE_CD => array(
            'name' => '_clear_battle_cd',
            'required' => false,
            'type' => 'Down_ClearBattleCd'
        ),
        self::_DRAW_RANK_REWARD => array(
            'name' => '_draw_rank_reward',
            'required' => false,
            'type' => 'Down_DrawRankReward'
        ),
        self::_BUY_BATTLE_CHANCE => array(
            'name' => '_buy_battle_chance',
            'required' => false,
            'type' => 'Down_BuyBattleChance'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_OPEN_PANEL] = null;
        $this->values[self::_APPLY_OPPO] = null;
        $this->values[self::_START_BATTLE] = null;
        $this->values[self::_END_BATTLE] = null;
        $this->values[self::_SET_LINEUP] = null;
        $this->values[self::_QUERY_RECORDS] = null;
        $this->values[self::_QUERY_REPLAY] = null;
        $this->values[self::_QUERY_RANKBORAD] = null;
        $this->values[self::_QUERY_OPPO] = null;
        $this->values[self::_CLEAR_BATTLE_CD] = null;
        $this->values[self::_DRAW_RANK_REWARD] = null;
        $this->values[self::_BUY_BATTLE_CHANCE] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_open_panel' property
     *
     * @param Down_OpenPanel $value Property value
     *
     * @return null
     */
    public function setOpenPanel(Down_OpenPanel $value)
    {
        return $this->set(self::_OPEN_PANEL, $value);
    }

    /**
     * Returns value of '_open_panel' property
     *
     * @return Down_OpenPanel
     */
    public function getOpenPanel()
    {
        return $this->get(self::_OPEN_PANEL);
    }

    /**
     * Sets value of '_apply_oppo' property
     *
     * @param Down_ApplyOpponent $value Property value
     *
     * @return null
     */
    public function setApplyOppo(Down_ApplyOpponent $value)
    {
        return $this->set(self::_APPLY_OPPO, $value);
    }

    /**
     * Returns value of '_apply_oppo' property
     *
     * @return Down_ApplyOpponent
     */
    public function getApplyOppo()
    {
        return $this->get(self::_APPLY_OPPO);
    }

    /**
     * Sets value of '_start_battle' property
     *
     * @param Down_StartBattle $value Property value
     *
     * @return null
     */
    public function setStartBattle(Down_StartBattle $value)
    {
        return $this->set(self::_START_BATTLE, $value);
    }

    /**
     * Returns value of '_start_battle' property
     *
     * @return Down_StartBattle
     */
    public function getStartBattle()
    {
        return $this->get(self::_START_BATTLE);
    }

    /**
     * Sets value of '_end_battle' property
     *
     * @param Down_EndBattle $value Property value
     *
     * @return null
     */
    public function setEndBattle(Down_EndBattle $value)
    {
        return $this->set(self::_END_BATTLE, $value);
    }

    /**
     * Returns value of '_end_battle' property
     *
     * @return Down_EndBattle
     */
    public function getEndBattle()
    {
        return $this->get(self::_END_BATTLE);
    }

    /**
     * Sets value of '_set_lineup' property
     *
     * @param Down_SetLineup $value Property value
     *
     * @return null
     */
    public function setSetLineup(Down_SetLineup $value)
    {
        return $this->set(self::_SET_LINEUP, $value);
    }

    /**
     * Returns value of '_set_lineup' property
     *
     * @return Down_SetLineup
     */
    public function getSetLineup()
    {
        return $this->get(self::_SET_LINEUP);
    }

    /**
     * Sets value of '_query_records' property
     *
     * @param Down_QueryRecords $value Property value
     *
     * @return null
     */
    public function setQueryRecords(Down_QueryRecords $value)
    {
        return $this->set(self::_QUERY_RECORDS, $value);
    }

    /**
     * Returns value of '_query_records' property
     *
     * @return Down_QueryRecords
     */
    public function getQueryRecords()
    {
        return $this->get(self::_QUERY_RECORDS);
    }

    /**
     * Sets value of '_query_replay' property
     *
     * @param Down_QueryReplay $value Property value
     *
     * @return null
     */
    public function setQueryReplay(Down_QueryReplay $value)
    {
        return $this->set(self::_QUERY_REPLAY, $value);
    }

    /**
     * Returns value of '_query_replay' property
     *
     * @return Down_QueryReplay
     */
    public function getQueryReplay()
    {
        return $this->get(self::_QUERY_REPLAY);
    }

    /**
     * Sets value of '_query_rankborad' property
     *
     * @param Down_QueryRankboard $value Property value
     *
     * @return null
     */
    public function setQueryRankborad(Down_QueryRankboard $value)
    {
        return $this->set(self::_QUERY_RANKBORAD, $value);
    }

    /**
     * Returns value of '_query_rankborad' property
     *
     * @return Down_QueryRankboard
     */
    public function getQueryRankborad()
    {
        return $this->get(self::_QUERY_RANKBORAD);
    }

    /**
     * Sets value of '_query_oppo' property
     *
     * @param Down_QueryOppoInfo $value Property value
     *
     * @return null
     */
    public function setQueryOppo(Down_QueryOppoInfo $value)
    {
        return $this->set(self::_QUERY_OPPO, $value);
    }

    /**
     * Returns value of '_query_oppo' property
     *
     * @return Down_QueryOppoInfo
     */
    public function getQueryOppo()
    {
        return $this->get(self::_QUERY_OPPO);
    }

    /**
     * Sets value of '_clear_battle_cd' property
     *
     * @param Down_ClearBattleCd $value Property value
     *
     * @return null
     */
    public function setClearBattleCd(Down_ClearBattleCd $value)
    {
        return $this->set(self::_CLEAR_BATTLE_CD, $value);
    }

    /**
     * Returns value of '_clear_battle_cd' property
     *
     * @return Down_ClearBattleCd
     */
    public function getClearBattleCd()
    {
        return $this->get(self::_CLEAR_BATTLE_CD);
    }

    /**
     * Sets value of '_draw_rank_reward' property
     *
     * @param Down_DrawRankReward $value Property value
     *
     * @return null
     */
    public function setDrawRankReward(Down_DrawRankReward $value)
    {
        return $this->set(self::_DRAW_RANK_REWARD, $value);
    }

    /**
     * Returns value of '_draw_rank_reward' property
     *
     * @return Down_DrawRankReward
     */
    public function getDrawRankReward()
    {
        return $this->get(self::_DRAW_RANK_REWARD);
    }

    /**
     * Sets value of '_buy_battle_chance' property
     *
     * @param Down_BuyBattleChance $value Property value
     *
     * @return null
     */
    public function setBuyBattleChance(Down_BuyBattleChance $value)
    {
        return $this->set(self::_BUY_BATTLE_CHANCE, $value);
    }

    /**
     * Returns value of '_buy_battle_chance' property
     *
     * @return Down_BuyBattleChance
     */
    public function getBuyBattleChance()
    {
        return $this->get(self::_BUY_BATTLE_CHANCE);
    }
}

/**
 * open_panel message
 */
class Down_OpenPanel extends \ProtobufMessage
{
    /* Field index constants */
    const _RANK = 1;
    const _LEFT_COUNT = 2;
    const _LAST_BT_TIME = 3;
    const _BUY_TIMES = 4;
    const _LINEUP = 5;
    const _GS = 6;
    const _OPPOS = 7;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RANK => array(
            'name' => '_rank',
            'required' => true,
            'type' => 5,
        ),
        self::_LEFT_COUNT => array(
            'name' => '_left_count',
            'required' => true,
            'type' => 5,
        ),
        self::_LAST_BT_TIME => array(
            'name' => '_last_bt_time',
            'required' => true,
            'type' => 5,
        ),
        self::_BUY_TIMES => array(
            'name' => '_buy_times',
            'required' => true,
            'type' => 5,
        ),
        self::_LINEUP => array(
            'name' => '_lineup',
            'repeated' => true,
            'type' => 5,
        ),
        self::_GS => array(
            'name' => '_gs',
            'required' => true,
            'type' => 5,
        ),
        self::_OPPOS => array(
            'name' => '_oppos',
            'repeated' => true,
            'type' => 'Down_LadderOpponent'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RANK] = null;
        $this->values[self::_LEFT_COUNT] = null;
        $this->values[self::_LAST_BT_TIME] = null;
        $this->values[self::_BUY_TIMES] = null;
        $this->values[self::_LINEUP] = array();
        $this->values[self::_GS] = null;
        $this->values[self::_OPPOS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_rank' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRank($value)
    {
        return $this->set(self::_RANK, $value);
    }

    /**
     * Returns value of '_rank' property
     *
     * @return int
     */
    public function getRank()
    {
        return $this->get(self::_RANK);
    }

    /**
     * Sets value of '_left_count' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLeftCount($value)
    {
        return $this->set(self::_LEFT_COUNT, $value);
    }

    /**
     * Returns value of '_left_count' property
     *
     * @return int
     */
    public function getLeftCount()
    {
        return $this->get(self::_LEFT_COUNT);
    }

    /**
     * Sets value of '_last_bt_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLastBtTime($value)
    {
        return $this->set(self::_LAST_BT_TIME, $value);
    }

    /**
     * Returns value of '_last_bt_time' property
     *
     * @return int
     */
    public function getLastBtTime()
    {
        return $this->get(self::_LAST_BT_TIME);
    }

    /**
     * Sets value of '_buy_times' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setBuyTimes($value)
    {
        return $this->set(self::_BUY_TIMES, $value);
    }

    /**
     * Returns value of '_buy_times' property
     *
     * @return int
     */
    public function getBuyTimes()
    {
        return $this->get(self::_BUY_TIMES);
    }

    /**
     * Appends value to '_lineup' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendLineup($value)
    {
        return $this->append(self::_LINEUP, $value);
    }

    /**
     * Clears '_lineup' list
     *
     * @return null
     */
    public function clearLineup()
    {
        return $this->clear(self::_LINEUP);
    }

    /**
     * Returns '_lineup' list
     *
     * @return int[]
     */
    public function getLineup()
    {
        return $this->get(self::_LINEUP);
    }

    /**
     * Returns '_lineup' iterator
     *
     * @return ArrayIterator
     */
    public function getLineupIterator()
    {
        return new \ArrayIterator($this->get(self::_LINEUP));
    }

    /**
     * Returns element from '_lineup' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getLineupAt($offset)
    {
        return $this->get(self::_LINEUP, $offset);
    }

    /**
     * Returns count of '_lineup' list
     *
     * @return int
     */
    public function getLineupCount()
    {
        return $this->count(self::_LINEUP);
    }

    /**
     * Sets value of '_gs' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setGs($value)
    {
        return $this->set(self::_GS, $value);
    }

    /**
     * Returns value of '_gs' property
     *
     * @return int
     */
    public function getGs()
    {
        return $this->get(self::_GS);
    }

    /**
     * Appends value to '_oppos' list
     *
     * @param Down_LadderOpponent $value Value to append
     *
     * @return null
     */
    public function appendOppos(Down_LadderOpponent $value)
    {
        return $this->append(self::_OPPOS, $value);
    }

    /**
     * Clears '_oppos' list
     *
     * @return null
     */
    public function clearOppos()
    {
        return $this->clear(self::_OPPOS);
    }

    /**
     * Returns '_oppos' list
     *
     * @return Down_LadderOpponent[]
     */
    public function getOppos()
    {
        return $this->get(self::_OPPOS);
    }

    /**
     * Returns '_oppos' iterator
     *
     * @return ArrayIterator
     */
    public function getOpposIterator()
    {
        return new \ArrayIterator($this->get(self::_OPPOS));
    }

    /**
     * Returns element from '_oppos' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_LadderOpponent
     */
    public function getOpposAt($offset)
    {
        return $this->get(self::_OPPOS, $offset);
    }

    /**
     * Returns count of '_oppos' list
     *
     * @return int
     */
    public function getOpposCount()
    {
        return $this->count(self::_OPPOS);
    }
}

/**
 * apply_opponent message
 */
class Down_ApplyOpponent extends \ProtobufMessage
{
    /* Field index constants */
    const _OPPOS = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_OPPOS => array(
            'name' => '_oppos',
            'repeated' => true,
            'type' => 'Down_LadderOpponent'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_OPPOS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_oppos' list
     *
     * @param Down_LadderOpponent $value Value to append
     *
     * @return null
     */
    public function appendOppos(Down_LadderOpponent $value)
    {
        return $this->append(self::_OPPOS, $value);
    }

    /**
     * Clears '_oppos' list
     *
     * @return null
     */
    public function clearOppos()
    {
        return $this->clear(self::_OPPOS);
    }

    /**
     * Returns '_oppos' list
     *
     * @return Down_LadderOpponent[]
     */
    public function getOppos()
    {
        return $this->get(self::_OPPOS);
    }

    /**
     * Returns '_oppos' iterator
     *
     * @return ArrayIterator
     */
    public function getOpposIterator()
    {
        return new \ArrayIterator($this->get(self::_OPPOS));
    }

    /**
     * Returns element from '_oppos' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_LadderOpponent
     */
    public function getOpposAt($offset)
    {
        return $this->get(self::_OPPOS, $offset);
    }

    /**
     * Returns count of '_oppos' list
     *
     * @return int
     */
    public function getOpposCount()
    {
        return $this->count(self::_OPPOS);
    }
}

/**
 * start_battle message
 */
class Down_StartBattle extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _RSEED = 2;
    const _SELF_HEROES = 3;
    const _HEROES = 4;
    const _IS_ROBOT = 5;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_RSEED => array(
            'name' => '_rseed',
            'required' => true,
            'type' => 5,
        ),
        self::_SELF_HEROES => array(
            'name' => '_self_heroes',
            'repeated' => true,
            'type' => 'Down_Hero'
        ),
        self::_HEROES => array(
            'name' => '_heroes',
            'repeated' => true,
            'type' => 'Down_Hero'
        ),
        self::_IS_ROBOT => array(
            'name' => '_is_robot',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_RSEED] = null;
        $this->values[self::_SELF_HEROES] = array();
        $this->values[self::_HEROES] = array();
        $this->values[self::_IS_ROBOT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_rseed' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRseed($value)
    {
        return $this->set(self::_RSEED, $value);
    }

    /**
     * Returns value of '_rseed' property
     *
     * @return int
     */
    public function getRseed()
    {
        return $this->get(self::_RSEED);
    }

    /**
     * Appends value to '_self_heroes' list
     *
     * @param Down_Hero $value Value to append
     *
     * @return null
     */
    public function appendSelfHeroes(Down_Hero $value)
    {
        return $this->append(self::_SELF_HEROES, $value);
    }

    /**
     * Clears '_self_heroes' list
     *
     * @return null
     */
    public function clearSelfHeroes()
    {
        return $this->clear(self::_SELF_HEROES);
    }

    /**
     * Returns '_self_heroes' list
     *
     * @return Down_Hero[]
     */
    public function getSelfHeroes()
    {
        return $this->get(self::_SELF_HEROES);
    }

    /**
     * Returns '_self_heroes' iterator
     *
     * @return ArrayIterator
     */
    public function getSelfHeroesIterator()
    {
        return new \ArrayIterator($this->get(self::_SELF_HEROES));
    }

    /**
     * Returns element from '_self_heroes' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_Hero
     */
    public function getSelfHeroesAt($offset)
    {
        return $this->get(self::_SELF_HEROES, $offset);
    }

    /**
     * Returns count of '_self_heroes' list
     *
     * @return int
     */
    public function getSelfHeroesCount()
    {
        return $this->count(self::_SELF_HEROES);
    }

    /**
     * Appends value to '_heroes' list
     *
     * @param Down_Hero $value Value to append
     *
     * @return null
     */
    public function appendHeroes(Down_Hero $value)
    {
        return $this->append(self::_HEROES, $value);
    }

    /**
     * Clears '_heroes' list
     *
     * @return null
     */
    public function clearHeroes()
    {
        return $this->clear(self::_HEROES);
    }

    /**
     * Returns '_heroes' list
     *
     * @return Down_Hero[]
     */
    public function getHeroes()
    {
        return $this->get(self::_HEROES);
    }

    /**
     * Returns '_heroes' iterator
     *
     * @return ArrayIterator
     */
    public function getHeroesIterator()
    {
        return new \ArrayIterator($this->get(self::_HEROES));
    }

    /**
     * Returns element from '_heroes' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_Hero
     */
    public function getHeroesAt($offset)
    {
        return $this->get(self::_HEROES, $offset);
    }

    /**
     * Returns count of '_heroes' list
     *
     * @return int
     */
    public function getHeroesCount()
    {
        return $this->count(self::_HEROES);
    }

    /**
     * Sets value of '_is_robot' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setIsRobot($value)
    {
        return $this->set(self::_IS_ROBOT, $value);
    }

    /**
     * Returns value of '_is_robot' property
     *
     * @return int
     */
    public function getIsRobot()
    {
        return $this->get(self::_IS_ROBOT);
    }
}

/**
 * end_battle message
 */
class Down_EndBattle extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _BEST_RANK_REWARD = 2;
    const _BEST_RANK = 3;
    const _CUR_RANK = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_BEST_RANK_REWARD => array(
            'name' => '_best_rank_reward',
            'required' => true,
            'type' => 5,
        ),
        self::_BEST_RANK => array(
            'name' => '_best_rank',
            'required' => true,
            'type' => 5,
        ),
        self::_CUR_RANK => array(
            'name' => '_cur_rank',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_BEST_RANK_REWARD] = null;
        $this->values[self::_BEST_RANK] = null;
        $this->values[self::_CUR_RANK] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_best_rank_reward' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setBestRankReward($value)
    {
        return $this->set(self::_BEST_RANK_REWARD, $value);
    }

    /**
     * Returns value of '_best_rank_reward' property
     *
     * @return int
     */
    public function getBestRankReward()
    {
        return $this->get(self::_BEST_RANK_REWARD);
    }

    /**
     * Sets value of '_best_rank' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setBestRank($value)
    {
        return $this->set(self::_BEST_RANK, $value);
    }

    /**
     * Returns value of '_best_rank' property
     *
     * @return int
     */
    public function getBestRank()
    {
        return $this->get(self::_BEST_RANK);
    }

    /**
     * Sets value of '_cur_rank' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCurRank($value)
    {
        return $this->set(self::_CUR_RANK, $value);
    }

    /**
     * Returns value of '_cur_rank' property
     *
     * @return int
     */
    public function getCurRank()
    {
        return $this->get(self::_CUR_RANK);
    }
}

/**
 * set_lineup message
 */
class Down_SetLineup extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _LINEUP = 2;
    const _GS = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_LINEUP => array(
            'name' => '_lineup',
            'repeated' => true,
            'type' => 5,
        ),
        self::_GS => array(
            'name' => '_gs',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_LINEUP] = array();
        $this->values[self::_GS] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Appends value to '_lineup' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendLineup($value)
    {
        return $this->append(self::_LINEUP, $value);
    }

    /**
     * Clears '_lineup' list
     *
     * @return null
     */
    public function clearLineup()
    {
        return $this->clear(self::_LINEUP);
    }

    /**
     * Returns '_lineup' list
     *
     * @return int[]
     */
    public function getLineup()
    {
        return $this->get(self::_LINEUP);
    }

    /**
     * Returns '_lineup' iterator
     *
     * @return ArrayIterator
     */
    public function getLineupIterator()
    {
        return new \ArrayIterator($this->get(self::_LINEUP));
    }

    /**
     * Returns element from '_lineup' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getLineupAt($offset)
    {
        return $this->get(self::_LINEUP, $offset);
    }

    /**
     * Returns count of '_lineup' list
     *
     * @return int
     */
    public function getLineupCount()
    {
        return $this->count(self::_LINEUP);
    }

    /**
     * Sets value of '_gs' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setGs($value)
    {
        return $this->set(self::_GS, $value);
    }

    /**
     * Returns value of '_gs' property
     *
     * @return int
     */
    public function getGs()
    {
        return $this->get(self::_GS);
    }
}

/**
 * query_records message
 */
class Down_QueryRecords extends \ProtobufMessage
{
    /* Field index constants */
    const _RECORDS = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RECORDS => array(
            'name' => '_records',
            'repeated' => true,
            'type' => 'Down_LadderRecord'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RECORDS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_records' list
     *
     * @param Down_LadderRecord $value Value to append
     *
     * @return null
     */
    public function appendRecords(Down_LadderRecord $value)
    {
        return $this->append(self::_RECORDS, $value);
    }

    /**
     * Clears '_records' list
     *
     * @return null
     */
    public function clearRecords()
    {
        return $this->clear(self::_RECORDS);
    }

    /**
     * Returns '_records' list
     *
     * @return Down_LadderRecord[]
     */
    public function getRecords()
    {
        return $this->get(self::_RECORDS);
    }

    /**
     * Returns '_records' iterator
     *
     * @return ArrayIterator
     */
    public function getRecordsIterator()
    {
        return new \ArrayIterator($this->get(self::_RECORDS));
    }

    /**
     * Returns element from '_records' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_LadderRecord
     */
    public function getRecordsAt($offset)
    {
        return $this->get(self::_RECORDS, $offset);
    }

    /**
     * Returns count of '_records' list
     *
     * @return int
     */
    public function getRecordsCount()
    {
        return $this->count(self::_RECORDS);
    }
}

/**
 * query_replay message
 */
class Down_QueryReplay extends \ProtobufMessage
{
    /* Field index constants */
    const _RECORD = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RECORD => array(
            'name' => '_record',
            'required' => true,
            'type' => 'Down_PvpRecord'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RECORD] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_record' property
     *
     * @param Down_PvpRecord $value Property value
     *
     * @return null
     */
    public function setRecord(Down_PvpRecord $value)
    {
        return $this->set(self::_RECORD, $value);
    }

    /**
     * Returns value of '_record' property
     *
     * @return Down_PvpRecord
     */
    public function getRecord()
    {
        return $this->get(self::_RECORD);
    }
}

/**
 * pvp_record message
 */
class Down_PvpRecord extends \ProtobufMessage
{
    /* Field index constants */
    const _CHECKID = 1;
    const _USERID = 2;
    const _USERNAME = 3;
    const _LEVEL = 4;
    const _AVATAR = 5;
    const _VIP = 6;
    const _OPPO_USERID = 7;
    const _OPPO_NAME = 8;
    const _OPPO_LEVEL = 9;
    const _OPPO_AVATAR = 10;
    const _OPPO_VIP = 11;
    const _OPPO_ROBOT = 12;
    const _RESULT = 13;
    const _SELF_HEROES = 14;
    const _SELF_DYNAS = 15;
    const _OPPO_HEROES = 16;
    const _OPPO_DYNAS = 17;
    const _RSEED = 18;
    const _SELF_ROBOT = 19;
    const _PARAM1 = 20;
    const _OPERATIONS = 21;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_CHECKID => array(
            'name' => '_checkid',
            'required' => true,
            'type' => 5,
        ),
        self::_USERID => array(
            'name' => '_userid',
            'required' => true,
            'type' => 5,
        ),
        self::_USERNAME => array(
            'name' => '_username',
            'required' => false,
            'type' => 7,
        ),
        self::_LEVEL => array(
            'name' => '_level',
            'required' => false,
            'type' => 5,
        ),
        self::_AVATAR => array(
            'name' => '_avatar',
            'required' => false,
            'type' => 5,
        ),
        self::_VIP => array(
            'name' => '_vip',
            'required' => false,
            'type' => 5,
        ),
        self::_OPPO_USERID => array(
            'name' => '_oppo_userid',
            'required' => true,
            'type' => 5,
        ),
        self::_OPPO_NAME => array(
            'name' => '_oppo_name',
            'required' => false,
            'type' => 7,
        ),
        self::_OPPO_LEVEL => array(
            'name' => '_oppo_level',
            'required' => false,
            'type' => 5,
        ),
        self::_OPPO_AVATAR => array(
            'name' => '_oppo_avatar',
            'required' => false,
            'type' => 5,
        ),
        self::_OPPO_VIP => array(
            'name' => '_oppo_vip',
            'required' => false,
            'type' => 5,
        ),
        self::_OPPO_ROBOT => array(
            'name' => '_oppo_robot',
            'required' => false,
            'type' => 5,
        ),
        self::_RESULT => array(
            'default' => Down_BattleResult::victory, 
            'name' => '_result',
            'required' => false,
            'type' => 5,
        ),
        self::_SELF_HEROES => array(
            'name' => '_self_heroes',
            'repeated' => true,
            'type' => 'Down_Hero'
        ),
        self::_SELF_DYNAS => array(
            'name' => '_self_dynas',
            'repeated' => true,
            'type' => 'Down_HeroDyna'
        ),
        self::_OPPO_HEROES => array(
            'name' => '_oppo_heroes',
            'repeated' => true,
            'type' => 'Down_Hero'
        ),
        self::_OPPO_DYNAS => array(
            'name' => '_oppo_dynas',
            'repeated' => true,
            'type' => 'Down_HeroDyna'
        ),
        self::_RSEED => array(
            'name' => '_rseed',
            'required' => true,
            'type' => 5,
        ),
        self::_SELF_ROBOT => array(
            'name' => '_self_robot',
            'required' => false,
            'type' => 5,
        ),
        self::_PARAM1 => array(
            'name' => '_param1',
            'required' => false,
            'type' => 5,
        ),
        self::_OPERATIONS => array(
            'name' => '_operations',
            'repeated' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_CHECKID] = null;
        $this->values[self::_USERID] = null;
        $this->values[self::_USERNAME] = null;
        $this->values[self::_LEVEL] = null;
        $this->values[self::_AVATAR] = null;
        $this->values[self::_VIP] = null;
        $this->values[self::_OPPO_USERID] = null;
        $this->values[self::_OPPO_NAME] = null;
        $this->values[self::_OPPO_LEVEL] = null;
        $this->values[self::_OPPO_AVATAR] = null;
        $this->values[self::_OPPO_VIP] = null;
        $this->values[self::_OPPO_ROBOT] = null;
        $this->values[self::_RESULT] = Down_BattleResult::victory;
        $this->values[self::_SELF_HEROES] = array();
        $this->values[self::_SELF_DYNAS] = array();
        $this->values[self::_OPPO_HEROES] = array();
        $this->values[self::_OPPO_DYNAS] = array();
        $this->values[self::_RSEED] = null;
        $this->values[self::_SELF_ROBOT] = null;
        $this->values[self::_PARAM1] = null;
        $this->values[self::_OPERATIONS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_checkid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCheckid($value)
    {
        return $this->set(self::_CHECKID, $value);
    }

    /**
     * Returns value of '_checkid' property
     *
     * @return int
     */
    public function getCheckid()
    {
        return $this->get(self::_CHECKID);
    }

    /**
     * Sets value of '_userid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setUserid($value)
    {
        return $this->set(self::_USERID, $value);
    }

    /**
     * Returns value of '_userid' property
     *
     * @return int
     */
    public function getUserid()
    {
        return $this->get(self::_USERID);
    }

    /**
     * Sets value of '_username' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setUsername($value)
    {
        return $this->set(self::_USERNAME, $value);
    }

    /**
     * Returns value of '_username' property
     *
     * @return string
     */
    public function getUsername()
    {
        return $this->get(self::_USERNAME);
    }

    /**
     * Sets value of '_level' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLevel($value)
    {
        return $this->set(self::_LEVEL, $value);
    }

    /**
     * Returns value of '_level' property
     *
     * @return int
     */
    public function getLevel()
    {
        return $this->get(self::_LEVEL);
    }

    /**
     * Sets value of '_avatar' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setAvatar($value)
    {
        return $this->set(self::_AVATAR, $value);
    }

    /**
     * Returns value of '_avatar' property
     *
     * @return int
     */
    public function getAvatar()
    {
        return $this->get(self::_AVATAR);
    }

    /**
     * Sets value of '_vip' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setVip($value)
    {
        return $this->set(self::_VIP, $value);
    }

    /**
     * Returns value of '_vip' property
     *
     * @return int
     */
    public function getVip()
    {
        return $this->get(self::_VIP);
    }

    /**
     * Sets value of '_oppo_userid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setOppoUserid($value)
    {
        return $this->set(self::_OPPO_USERID, $value);
    }

    /**
     * Returns value of '_oppo_userid' property
     *
     * @return int
     */
    public function getOppoUserid()
    {
        return $this->get(self::_OPPO_USERID);
    }

    /**
     * Sets value of '_oppo_name' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setOppoName($value)
    {
        return $this->set(self::_OPPO_NAME, $value);
    }

    /**
     * Returns value of '_oppo_name' property
     *
     * @return string
     */
    public function getOppoName()
    {
        return $this->get(self::_OPPO_NAME);
    }

    /**
     * Sets value of '_oppo_level' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setOppoLevel($value)
    {
        return $this->set(self::_OPPO_LEVEL, $value);
    }

    /**
     * Returns value of '_oppo_level' property
     *
     * @return int
     */
    public function getOppoLevel()
    {
        return $this->get(self::_OPPO_LEVEL);
    }

    /**
     * Sets value of '_oppo_avatar' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setOppoAvatar($value)
    {
        return $this->set(self::_OPPO_AVATAR, $value);
    }

    /**
     * Returns value of '_oppo_avatar' property
     *
     * @return int
     */
    public function getOppoAvatar()
    {
        return $this->get(self::_OPPO_AVATAR);
    }

    /**
     * Sets value of '_oppo_vip' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setOppoVip($value)
    {
        return $this->set(self::_OPPO_VIP, $value);
    }

    /**
     * Returns value of '_oppo_vip' property
     *
     * @return int
     */
    public function getOppoVip()
    {
        return $this->get(self::_OPPO_VIP);
    }

    /**
     * Sets value of '_oppo_robot' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setOppoRobot($value)
    {
        return $this->set(self::_OPPO_ROBOT, $value);
    }

    /**
     * Returns value of '_oppo_robot' property
     *
     * @return int
     */
    public function getOppoRobot()
    {
        return $this->get(self::_OPPO_ROBOT);
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Appends value to '_self_heroes' list
     *
     * @param Down_Hero $value Value to append
     *
     * @return null
     */
    public function appendSelfHeroes(Down_Hero $value)
    {
        return $this->append(self::_SELF_HEROES, $value);
    }

    /**
     * Clears '_self_heroes' list
     *
     * @return null
     */
    public function clearSelfHeroes()
    {
        return $this->clear(self::_SELF_HEROES);
    }

    /**
     * Returns '_self_heroes' list
     *
     * @return Down_Hero[]
     */
    public function getSelfHeroes()
    {
        return $this->get(self::_SELF_HEROES);
    }

    /**
     * Returns '_self_heroes' iterator
     *
     * @return ArrayIterator
     */
    public function getSelfHeroesIterator()
    {
        return new \ArrayIterator($this->get(self::_SELF_HEROES));
    }

    /**
     * Returns element from '_self_heroes' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_Hero
     */
    public function getSelfHeroesAt($offset)
    {
        return $this->get(self::_SELF_HEROES, $offset);
    }

    /**
     * Returns count of '_self_heroes' list
     *
     * @return int
     */
    public function getSelfHeroesCount()
    {
        return $this->count(self::_SELF_HEROES);
    }

    /**
     * Appends value to '_self_dynas' list
     *
     * @param Down_HeroDyna $value Value to append
     *
     * @return null
     */
    public function appendSelfDynas(Down_HeroDyna $value)
    {
        return $this->append(self::_SELF_DYNAS, $value);
    }

    /**
     * Clears '_self_dynas' list
     *
     * @return null
     */
    public function clearSelfDynas()
    {
        return $this->clear(self::_SELF_DYNAS);
    }

    /**
     * Returns '_self_dynas' list
     *
     * @return Down_HeroDyna[]
     */
    public function getSelfDynas()
    {
        return $this->get(self::_SELF_DYNAS);
    }

    /**
     * Returns '_self_dynas' iterator
     *
     * @return ArrayIterator
     */
    public function getSelfDynasIterator()
    {
        return new \ArrayIterator($this->get(self::_SELF_DYNAS));
    }

    /**
     * Returns element from '_self_dynas' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_HeroDyna
     */
    public function getSelfDynasAt($offset)
    {
        return $this->get(self::_SELF_DYNAS, $offset);
    }

    /**
     * Returns count of '_self_dynas' list
     *
     * @return int
     */
    public function getSelfDynasCount()
    {
        return $this->count(self::_SELF_DYNAS);
    }

    /**
     * Appends value to '_oppo_heroes' list
     *
     * @param Down_Hero $value Value to append
     *
     * @return null
     */
    public function appendOppoHeroes(Down_Hero $value)
    {
        return $this->append(self::_OPPO_HEROES, $value);
    }

    /**
     * Clears '_oppo_heroes' list
     *
     * @return null
     */
    public function clearOppoHeroes()
    {
        return $this->clear(self::_OPPO_HEROES);
    }

    /**
     * Returns '_oppo_heroes' list
     *
     * @return Down_Hero[]
     */
    public function getOppoHeroes()
    {
        return $this->get(self::_OPPO_HEROES);
    }

    /**
     * Returns '_oppo_heroes' iterator
     *
     * @return ArrayIterator
     */
    public function getOppoHeroesIterator()
    {
        return new \ArrayIterator($this->get(self::_OPPO_HEROES));
    }

    /**
     * Returns element from '_oppo_heroes' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_Hero
     */
    public function getOppoHeroesAt($offset)
    {
        return $this->get(self::_OPPO_HEROES, $offset);
    }

    /**
     * Returns count of '_oppo_heroes' list
     *
     * @return int
     */
    public function getOppoHeroesCount()
    {
        return $this->count(self::_OPPO_HEROES);
    }

    /**
     * Appends value to '_oppo_dynas' list
     *
     * @param Down_HeroDyna $value Value to append
     *
     * @return null
     */
    public function appendOppoDynas(Down_HeroDyna $value)
    {
        return $this->append(self::_OPPO_DYNAS, $value);
    }

    /**
     * Clears '_oppo_dynas' list
     *
     * @return null
     */
    public function clearOppoDynas()
    {
        return $this->clear(self::_OPPO_DYNAS);
    }

    /**
     * Returns '_oppo_dynas' list
     *
     * @return Down_HeroDyna[]
     */
    public function getOppoDynas()
    {
        return $this->get(self::_OPPO_DYNAS);
    }

    /**
     * Returns '_oppo_dynas' iterator
     *
     * @return ArrayIterator
     */
    public function getOppoDynasIterator()
    {
        return new \ArrayIterator($this->get(self::_OPPO_DYNAS));
    }

    /**
     * Returns element from '_oppo_dynas' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_HeroDyna
     */
    public function getOppoDynasAt($offset)
    {
        return $this->get(self::_OPPO_DYNAS, $offset);
    }

    /**
     * Returns count of '_oppo_dynas' list
     *
     * @return int
     */
    public function getOppoDynasCount()
    {
        return $this->count(self::_OPPO_DYNAS);
    }

    /**
     * Sets value of '_rseed' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRseed($value)
    {
        return $this->set(self::_RSEED, $value);
    }

    /**
     * Returns value of '_rseed' property
     *
     * @return int
     */
    public function getRseed()
    {
        return $this->get(self::_RSEED);
    }

    /**
     * Sets value of '_self_robot' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSelfRobot($value)
    {
        return $this->set(self::_SELF_ROBOT, $value);
    }

    /**
     * Returns value of '_self_robot' property
     *
     * @return int
     */
    public function getSelfRobot()
    {
        return $this->get(self::_SELF_ROBOT);
    }

    /**
     * Sets value of '_param1' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setParam1($value)
    {
        return $this->set(self::_PARAM1, $value);
    }

    /**
     * Returns value of '_param1' property
     *
     * @return int
     */
    public function getParam1()
    {
        return $this->get(self::_PARAM1);
    }

    /**
     * Appends value to '_operations' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendOperations($value)
    {
        return $this->append(self::_OPERATIONS, $value);
    }

    /**
     * Clears '_operations' list
     *
     * @return null
     */
    public function clearOperations()
    {
        return $this->clear(self::_OPERATIONS);
    }

    /**
     * Returns '_operations' list
     *
     * @return int[]
     */
    public function getOperations()
    {
        return $this->get(self::_OPERATIONS);
    }

    /**
     * Returns '_operations' iterator
     *
     * @return ArrayIterator
     */
    public function getOperationsIterator()
    {
        return new \ArrayIterator($this->get(self::_OPERATIONS));
    }

    /**
     * Returns element from '_operations' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getOperationsAt($offset)
    {
        return $this->get(self::_OPERATIONS, $offset);
    }

    /**
     * Returns count of '_operations' list
     *
     * @return int
     */
    public function getOperationsCount()
    {
        return $this->count(self::_OPERATIONS);
    }
}

/**
 * query_rankboard message
 */
class Down_QueryRankboard extends \ProtobufMessage
{
    /* Field index constants */
    const _RANK_LIST = 1;
    const _SELF_RANK = 2;
    const _POS = 3;
    const _PREV_POS = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RANK_LIST => array(
            'name' => '_rank_list',
            'repeated' => true,
            'type' => 'Down_RankboardData'
        ),
        self::_SELF_RANK => array(
            'name' => '_self_rank',
            'required' => false,
            'type' => 'Down_RankboardData'
        ),
        self::_POS => array(
            'name' => '_pos',
            'required' => false,
            'type' => 5,
        ),
        self::_PREV_POS => array(
            'name' => '_prev_pos',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RANK_LIST] = array();
        $this->values[self::_SELF_RANK] = null;
        $this->values[self::_POS] = null;
        $this->values[self::_PREV_POS] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_rank_list' list
     *
     * @param Down_RankboardData $value Value to append
     *
     * @return null
     */
    public function appendRankList(Down_RankboardData $value)
    {
        return $this->append(self::_RANK_LIST, $value);
    }

    /**
     * Clears '_rank_list' list
     *
     * @return null
     */
    public function clearRankList()
    {
        return $this->clear(self::_RANK_LIST);
    }

    /**
     * Returns '_rank_list' list
     *
     * @return Down_RankboardData[]
     */
    public function getRankList()
    {
        return $this->get(self::_RANK_LIST);
    }

    /**
     * Returns '_rank_list' iterator
     *
     * @return ArrayIterator
     */
    public function getRankListIterator()
    {
        return new \ArrayIterator($this->get(self::_RANK_LIST));
    }

    /**
     * Returns element from '_rank_list' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_RankboardData
     */
    public function getRankListAt($offset)
    {
        return $this->get(self::_RANK_LIST, $offset);
    }

    /**
     * Returns count of '_rank_list' list
     *
     * @return int
     */
    public function getRankListCount()
    {
        return $this->count(self::_RANK_LIST);
    }

    /**
     * Sets value of '_self_rank' property
     *
     * @param Down_RankboardData $value Property value
     *
     * @return null
     */
    public function setSelfRank(Down_RankboardData $value)
    {
        return $this->set(self::_SELF_RANK, $value);
    }

    /**
     * Returns value of '_self_rank' property
     *
     * @return Down_RankboardData
     */
    public function getSelfRank()
    {
        return $this->get(self::_SELF_RANK);
    }

    /**
     * Sets value of '_pos' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setPos($value)
    {
        return $this->set(self::_POS, $value);
    }

    /**
     * Returns value of '_pos' property
     *
     * @return int
     */
    public function getPos()
    {
        return $this->get(self::_POS);
    }

    /**
     * Sets value of '_prev_pos' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setPrevPos($value)
    {
        return $this->set(self::_PREV_POS, $value);
    }

    /**
     * Returns value of '_prev_pos' property
     *
     * @return int
     */
    public function getPrevPos()
    {
        return $this->get(self::_PREV_POS);
    }
}

/**
 * query_oppo_info message
 */
class Down_QueryOppoInfo extends \ProtobufMessage
{
    /* Field index constants */
    const _USER = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_USER => array(
            'name' => '_user',
            'required' => true,
            'type' => 'Down_LadderOpponent'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_USER] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_user' property
     *
     * @param Down_LadderOpponent $value Property value
     *
     * @return null
     */
    public function setUser(Down_LadderOpponent $value)
    {
        return $this->set(self::_USER, $value);
    }

    /**
     * Returns value of '_user' property
     *
     * @return Down_LadderOpponent
     */
    public function getUser()
    {
        return $this->get(self::_USER);
    }
}

/**
 * clear_battle_cd message
 */
class Down_ClearBattleCd extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }
}

/**
 * rankboard_data message
 */
class Down_RankboardData extends \ProtobufMessage
{
    /* Field index constants */
    const _USER_ID = 1;
    const _SUMMARY = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_USER_ID => array(
            'name' => '_user_id',
            'required' => true,
            'type' => 5,
        ),
        self::_SUMMARY => array(
            'name' => '_summary',
            'required' => false,
            'type' => 'Down_UserSummary'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_USER_ID] = null;
        $this->values[self::_SUMMARY] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_user_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setUserId($value)
    {
        return $this->set(self::_USER_ID, $value);
    }

    /**
     * Returns value of '_user_id' property
     *
     * @return int
     */
    public function getUserId()
    {
        return $this->get(self::_USER_ID);
    }

    /**
     * Sets value of '_summary' property
     *
     * @param Down_UserSummary $value Property value
     *
     * @return null
     */
    public function setSummary(Down_UserSummary $value)
    {
        return $this->set(self::_SUMMARY, $value);
    }

    /**
     * Returns value of '_summary' property
     *
     * @return Down_UserSummary
     */
    public function getSummary()
    {
        return $this->get(self::_SUMMARY);
    }
}

/**
 * ladder_record message
 */
class Down_LadderRecord extends \ProtobufMessage
{
    /* Field index constants */
    const _USER_ID = 1;
    const _SUMMARY = 2;
    const _DETA_RANK = 3;
    const _BT_TIME = 4;
    const _BT_RESULT = 5;
    const _REPLAY_ID = 6;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_USER_ID => array(
            'name' => '_user_id',
            'required' => true,
            'type' => 5,
        ),
        self::_SUMMARY => array(
            'name' => '_summary',
            'required' => true,
            'type' => 'Down_UserSummary'
        ),
        self::_DETA_RANK => array(
            'name' => '_deta_rank',
            'required' => true,
            'type' => 5,
        ),
        self::_BT_TIME => array(
            'name' => '_bt_time',
            'required' => true,
            'type' => 5,
        ),
        self::_BT_RESULT => array(
            'name' => '_bt_result',
            'required' => true,
            'type' => 5,
        ),
        self::_REPLAY_ID => array(
            'name' => '_replay_id',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_USER_ID] = null;
        $this->values[self::_SUMMARY] = null;
        $this->values[self::_DETA_RANK] = null;
        $this->values[self::_BT_TIME] = null;
        $this->values[self::_BT_RESULT] = null;
        $this->values[self::_REPLAY_ID] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_user_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setUserId($value)
    {
        return $this->set(self::_USER_ID, $value);
    }

    /**
     * Returns value of '_user_id' property
     *
     * @return int
     */
    public function getUserId()
    {
        return $this->get(self::_USER_ID);
    }

    /**
     * Sets value of '_summary' property
     *
     * @param Down_UserSummary $value Property value
     *
     * @return null
     */
    public function setSummary(Down_UserSummary $value)
    {
        return $this->set(self::_SUMMARY, $value);
    }

    /**
     * Returns value of '_summary' property
     *
     * @return Down_UserSummary
     */
    public function getSummary()
    {
        return $this->get(self::_SUMMARY);
    }

    /**
     * Sets value of '_deta_rank' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setDetaRank($value)
    {
        return $this->set(self::_DETA_RANK, $value);
    }

    /**
     * Returns value of '_deta_rank' property
     *
     * @return int
     */
    public function getDetaRank()
    {
        return $this->get(self::_DETA_RANK);
    }

    /**
     * Sets value of '_bt_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setBtTime($value)
    {
        return $this->set(self::_BT_TIME, $value);
    }

    /**
     * Returns value of '_bt_time' property
     *
     * @return int
     */
    public function getBtTime()
    {
        return $this->get(self::_BT_TIME);
    }

    /**
     * Sets value of '_bt_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setBtResult($value)
    {
        return $this->set(self::_BT_RESULT, $value);
    }

    /**
     * Returns value of '_bt_result' property
     *
     * @return int
     */
    public function getBtResult()
    {
        return $this->get(self::_BT_RESULT);
    }

    /**
     * Sets value of '_replay_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setReplayId($value)
    {
        return $this->set(self::_REPLAY_ID, $value);
    }

    /**
     * Returns value of '_replay_id' property
     *
     * @return int
     */
    public function getReplayId()
    {
        return $this->get(self::_REPLAY_ID);
    }
}

/**
 * ladder_opponent message
 */
class Down_LadderOpponent extends \ProtobufMessage
{
    /* Field index constants */
    const _USER_ID = 1;
    const _SUMMARY = 2;
    const _RANK = 3;
    const _WIN_CNT = 4;
    const _GS = 5;
    const _IS_ROBOT = 6;
    const _HEROS = 7;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_USER_ID => array(
            'name' => '_user_id',
            'required' => true,
            'type' => 5,
        ),
        self::_SUMMARY => array(
            'name' => '_summary',
            'required' => true,
            'type' => 'Down_UserSummary'
        ),
        self::_RANK => array(
            'name' => '_rank',
            'required' => true,
            'type' => 5,
        ),
        self::_WIN_CNT => array(
            'name' => '_win_cnt',
            'required' => true,
            'type' => 5,
        ),
        self::_GS => array(
            'name' => '_gs',
            'required' => true,
            'type' => 5,
        ),
        self::_IS_ROBOT => array(
            'name' => '_is_robot',
            'required' => true,
            'type' => 5,
        ),
        self::_HEROS => array(
            'name' => '_heros',
            'repeated' => true,
            'type' => 'Down_HeroSummary'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_USER_ID] = null;
        $this->values[self::_SUMMARY] = null;
        $this->values[self::_RANK] = null;
        $this->values[self::_WIN_CNT] = null;
        $this->values[self::_GS] = null;
        $this->values[self::_IS_ROBOT] = null;
        $this->values[self::_HEROS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_user_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setUserId($value)
    {
        return $this->set(self::_USER_ID, $value);
    }

    /**
     * Returns value of '_user_id' property
     *
     * @return int
     */
    public function getUserId()
    {
        return $this->get(self::_USER_ID);
    }

    /**
     * Sets value of '_summary' property
     *
     * @param Down_UserSummary $value Property value
     *
     * @return null
     */
    public function setSummary(Down_UserSummary $value)
    {
        return $this->set(self::_SUMMARY, $value);
    }

    /**
     * Returns value of '_summary' property
     *
     * @return Down_UserSummary
     */
    public function getSummary()
    {
        return $this->get(self::_SUMMARY);
    }

    /**
     * Sets value of '_rank' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRank($value)
    {
        return $this->set(self::_RANK, $value);
    }

    /**
     * Returns value of '_rank' property
     *
     * @return int
     */
    public function getRank()
    {
        return $this->get(self::_RANK);
    }

    /**
     * Sets value of '_win_cnt' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setWinCnt($value)
    {
        return $this->set(self::_WIN_CNT, $value);
    }

    /**
     * Returns value of '_win_cnt' property
     *
     * @return int
     */
    public function getWinCnt()
    {
        return $this->get(self::_WIN_CNT);
    }

    /**
     * Sets value of '_gs' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setGs($value)
    {
        return $this->set(self::_GS, $value);
    }

    /**
     * Returns value of '_gs' property
     *
     * @return int
     */
    public function getGs()
    {
        return $this->get(self::_GS);
    }

    /**
     * Sets value of '_is_robot' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setIsRobot($value)
    {
        return $this->set(self::_IS_ROBOT, $value);
    }

    /**
     * Returns value of '_is_robot' property
     *
     * @return int
     */
    public function getIsRobot()
    {
        return $this->get(self::_IS_ROBOT);
    }

    /**
     * Appends value to '_heros' list
     *
     * @param Down_HeroSummary $value Value to append
     *
     * @return null
     */
    public function appendHeros(Down_HeroSummary $value)
    {
        return $this->append(self::_HEROS, $value);
    }

    /**
     * Clears '_heros' list
     *
     * @return null
     */
    public function clearHeros()
    {
        return $this->clear(self::_HEROS);
    }

    /**
     * Returns '_heros' list
     *
     * @return Down_HeroSummary[]
     */
    public function getHeros()
    {
        return $this->get(self::_HEROS);
    }

    /**
     * Returns '_heros' iterator
     *
     * @return ArrayIterator
     */
    public function getHerosIterator()
    {
        return new \ArrayIterator($this->get(self::_HEROS));
    }

    /**
     * Returns element from '_heros' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_HeroSummary
     */
    public function getHerosAt($offset)
    {
        return $this->get(self::_HEROS, $offset);
    }

    /**
     * Returns count of '_heros' list
     *
     * @return int
     */
    public function getHerosCount()
    {
        return $this->count(self::_HEROS);
    }
}

/**
 * reward_type enum embedded in ladder_rank_reward message
 */
final class Down_LadderRankReward_RewardType
{
    const gold = 1;
    const diamond = 2;
    const item = 3;
    const arenapoint = 4;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'gold' => self::gold,
            'diamond' => self::diamond,
            'item' => self::item,
            'arenapoint' => self::arenapoint,
        );
    }
}

/**
 * ladder_rank_reward message
 */
class Down_LadderRankReward extends \ProtobufMessage
{
    /* Field index constants */
    const _TYPE = 1;
    const _PARAM1 = 2;
    const _PARAM2 = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TYPE => array(
            'name' => '_type',
            'required' => true,
            'type' => 5,
        ),
        self::_PARAM1 => array(
            'name' => '_param1',
            'required' => false,
            'type' => 5,
        ),
        self::_PARAM2 => array(
            'name' => '_param2',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_TYPE] = null;
        $this->values[self::_PARAM1] = null;
        $this->values[self::_PARAM2] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_type' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setType($value)
    {
        return $this->set(self::_TYPE, $value);
    }

    /**
     * Returns value of '_type' property
     *
     * @return int
     */
    public function getType()
    {
        return $this->get(self::_TYPE);
    }

    /**
     * Sets value of '_param1' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setParam1($value)
    {
        return $this->set(self::_PARAM1, $value);
    }

    /**
     * Returns value of '_param1' property
     *
     * @return int
     */
    public function getParam1()
    {
        return $this->get(self::_PARAM1);
    }

    /**
     * Sets value of '_param2' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setParam2($value)
    {
        return $this->set(self::_PARAM2, $value);
    }

    /**
     * Returns value of '_param2' property
     *
     * @return int
     */
    public function getParam2()
    {
        return $this->get(self::_PARAM2);
    }
}

/**
 * draw_rank_reward message
 */
class Down_DrawRankReward extends \ProtobufMessage
{
    /* Field index constants */
    const _REWARDS = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_REWARDS => array(
            'name' => '_rewards',
            'repeated' => true,
            'type' => 'Down_LadderRankReward'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_REWARDS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_rewards' list
     *
     * @param Down_LadderRankReward $value Value to append
     *
     * @return null
     */
    public function appendRewards(Down_LadderRankReward $value)
    {
        return $this->append(self::_REWARDS, $value);
    }

    /**
     * Clears '_rewards' list
     *
     * @return null
     */
    public function clearRewards()
    {
        return $this->clear(self::_REWARDS);
    }

    /**
     * Returns '_rewards' list
     *
     * @return Down_LadderRankReward[]
     */
    public function getRewards()
    {
        return $this->get(self::_REWARDS);
    }

    /**
     * Returns '_rewards' iterator
     *
     * @return ArrayIterator
     */
    public function getRewardsIterator()
    {
        return new \ArrayIterator($this->get(self::_REWARDS));
    }

    /**
     * Returns element from '_rewards' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_LadderRankReward
     */
    public function getRewardsAt($offset)
    {
        return $this->get(self::_REWARDS, $offset);
    }

    /**
     * Returns count of '_rewards' list
     *
     * @return int
     */
    public function getRewardsCount()
    {
        return $this->count(self::_REWARDS);
    }
}

/**
 * buy_battle_chance message
 */
class Down_BuyBattleChance extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _BUY_TIMES = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_Result::success, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_BUY_TIMES => array(
            'name' => '_buy_times',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_BUY_TIMES] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_buy_times' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setBuyTimes($value)
    {
        return $this->set(self::_BUY_TIMES, $value);
    }

    /**
     * Returns value of '_buy_times' property
     *
     * @return int
     */
    public function getBuyTimes()
    {
        return $this->get(self::_BUY_TIMES);
    }
}

/**
 * set_name_result enum embedded in set_name_reply message
 */
final class Down_SetNameReply_SetNameResult
{
    const success = 0;
    const exists = 1;
    const dirty_word = 2;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'success' => self::success,
            'exists' => self::exists,
            'dirty_word' => self::dirty_word,
        );
    }
}

/**
 * set_name_reply message
 */
class Down_SetNameReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_SetNameReply_SetNameResult::success, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }
}

/**
 * set_avatar_reply message
 */
class Down_SetAvatarReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }
}

/**
 * query_data_reply message
 */
class Down_QueryDataReply extends \ProtobufMessage
{
    /* Field index constants */
    const RMB = 1;
    const CHARGE_SUM = 2;
    const HEROES = 3;
    const RECHARGE_LIMIT = 4;
    const _MONTH_CARD = 5;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::RMB => array(
            'name' => 'rmb',
            'required' => false,
            'type' => 5,
        ),
        self::CHARGE_SUM => array(
            'name' => 'charge_sum',
            'required' => false,
            'type' => 5,
        ),
        self::HEROES => array(
            'name' => 'heroes',
            'repeated' => true,
            'type' => 'Down_Hero'
        ),
        self::RECHARGE_LIMIT => array(
            'name' => 'recharge_limit',
            'repeated' => true,
            'type' => 5,
        ),
        self::_MONTH_CARD => array(
            'name' => '_month_card',
            'repeated' => true,
            'type' => 'Down_Monthcard'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::RMB] = null;
        $this->values[self::CHARGE_SUM] = null;
        $this->values[self::HEROES] = array();
        $this->values[self::RECHARGE_LIMIT] = array();
        $this->values[self::_MONTH_CARD] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of 'rmb' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRmb($value)
    {
        return $this->set(self::RMB, $value);
    }

    /**
     * Returns value of 'rmb' property
     *
     * @return int
     */
    public function getRmb()
    {
        return $this->get(self::RMB);
    }

    /**
     * Sets value of 'charge_sum' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setChargeSum($value)
    {
        return $this->set(self::CHARGE_SUM, $value);
    }

    /**
     * Returns value of 'charge_sum' property
     *
     * @return int
     */
    public function getChargeSum()
    {
        return $this->get(self::CHARGE_SUM);
    }

    /**
     * Appends value to 'heroes' list
     *
     * @param Down_Hero $value Value to append
     *
     * @return null
     */
    public function appendHeroes(Down_Hero $value)
    {
        return $this->append(self::HEROES, $value);
    }

    /**
     * Clears 'heroes' list
     *
     * @return null
     */
    public function clearHeroes()
    {
        return $this->clear(self::HEROES);
    }

    /**
     * Returns 'heroes' list
     *
     * @return Down_Hero[]
     */
    public function getHeroes()
    {
        return $this->get(self::HEROES);
    }

    /**
     * Returns 'heroes' iterator
     *
     * @return ArrayIterator
     */
    public function getHeroesIterator()
    {
        return new \ArrayIterator($this->get(self::HEROES));
    }

    /**
     * Returns element from 'heroes' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_Hero
     */
    public function getHeroesAt($offset)
    {
        return $this->get(self::HEROES, $offset);
    }

    /**
     * Returns count of 'heroes' list
     *
     * @return int
     */
    public function getHeroesCount()
    {
        return $this->count(self::HEROES);
    }

    /**
     * Appends value to 'recharge_limit' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendRechargeLimit($value)
    {
        return $this->append(self::RECHARGE_LIMIT, $value);
    }

    /**
     * Clears 'recharge_limit' list
     *
     * @return null
     */
    public function clearRechargeLimit()
    {
        return $this->clear(self::RECHARGE_LIMIT);
    }

    /**
     * Returns 'recharge_limit' list
     *
     * @return int[]
     */
    public function getRechargeLimit()
    {
        return $this->get(self::RECHARGE_LIMIT);
    }

    /**
     * Returns 'recharge_limit' iterator
     *
     * @return ArrayIterator
     */
    public function getRechargeLimitIterator()
    {
        return new \ArrayIterator($this->get(self::RECHARGE_LIMIT));
    }

    /**
     * Returns element from 'recharge_limit' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getRechargeLimitAt($offset)
    {
        return $this->get(self::RECHARGE_LIMIT, $offset);
    }

    /**
     * Returns count of 'recharge_limit' list
     *
     * @return int
     */
    public function getRechargeLimitCount()
    {
        return $this->count(self::RECHARGE_LIMIT);
    }

    /**
     * Appends value to '_month_card' list
     *
     * @param Down_Monthcard $value Value to append
     *
     * @return null
     */
    public function appendMonthCard(Down_Monthcard $value)
    {
        return $this->append(self::_MONTH_CARD, $value);
    }

    /**
     * Clears '_month_card' list
     *
     * @return null
     */
    public function clearMonthCard()
    {
        return $this->clear(self::_MONTH_CARD);
    }

    /**
     * Returns '_month_card' list
     *
     * @return Down_Monthcard[]
     */
    public function getMonthCard()
    {
        return $this->get(self::_MONTH_CARD);
    }

    /**
     * Returns '_month_card' iterator
     *
     * @return ArrayIterator
     */
    public function getMonthCardIterator()
    {
        return new \ArrayIterator($this->get(self::_MONTH_CARD));
    }

    /**
     * Returns element from '_month_card' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_Monthcard
     */
    public function getMonthCardAt($offset)
    {
        return $this->get(self::_MONTH_CARD, $offset);
    }

    /**
     * Returns count of '_month_card' list
     *
     * @return int
     */
    public function getMonthCardCount()
    {
        return $this->count(self::_MONTH_CARD);
    }
}

/**
 * midas_acquire message
 */
class Down_MidasAcquire extends \ProtobufMessage
{
    /* Field index constants */
    const _TYPE = 1;
    const _MONEY = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TYPE => array(
            'name' => '_type',
            'required' => true,
            'type' => 5,
        ),
        self::_MONEY => array(
            'name' => '_money',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_TYPE] = null;
        $this->values[self::_MONEY] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_type' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setType($value)
    {
        return $this->set(self::_TYPE, $value);
    }

    /**
     * Returns value of '_type' property
     *
     * @return int
     */
    public function getType()
    {
        return $this->get(self::_TYPE);
    }

    /**
     * Sets value of '_money' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setMoney($value)
    {
        return $this->set(self::_MONEY, $value);
    }

    /**
     * Returns value of '_money' property
     *
     * @return int
     */
    public function getMoney()
    {
        return $this->get(self::_MONEY);
    }
}

/**
 * midas_reply message
 */
class Down_MidasReply extends \ProtobufMessage
{
    /* Field index constants */
    const _ACQUIRE = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ACQUIRE => array(
            'name' => '_acquire',
            'repeated' => true,
            'type' => 'Down_MidasAcquire'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ACQUIRE] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_acquire' list
     *
     * @param Down_MidasAcquire $value Value to append
     *
     * @return null
     */
    public function appendAcquire(Down_MidasAcquire $value)
    {
        return $this->append(self::_ACQUIRE, $value);
    }

    /**
     * Clears '_acquire' list
     *
     * @return null
     */
    public function clearAcquire()
    {
        return $this->clear(self::_ACQUIRE);
    }

    /**
     * Returns '_acquire' list
     *
     * @return Down_MidasAcquire[]
     */
    public function getAcquire()
    {
        return $this->get(self::_ACQUIRE);
    }

    /**
     * Returns '_acquire' iterator
     *
     * @return ArrayIterator
     */
    public function getAcquireIterator()
    {
        return new \ArrayIterator($this->get(self::_ACQUIRE));
    }

    /**
     * Returns element from '_acquire' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_MidasAcquire
     */
    public function getAcquireAt($offset)
    {
        return $this->get(self::_ACQUIRE, $offset);
    }

    /**
     * Returns count of '_acquire' list
     *
     * @return int
     */
    public function getAcquireCount()
    {
        return $this->count(self::_ACQUIRE);
    }
}

/**
 * open_shop_reply message
 */
class Down_OpenShopReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _SHOP = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_SHOP => array(
            'name' => '_shop',
            'required' => false,
            'type' => 'Down_UserShop'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_SHOP] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_shop' property
     *
     * @param Down_UserShop $value Property value
     *
     * @return null
     */
    public function setShop(Down_UserShop $value)
    {
        return $this->set(self::_SHOP, $value);
    }

    /**
     * Returns value of '_shop' property
     *
     * @return Down_UserShop
     */
    public function getShop()
    {
        return $this->get(self::_SHOP);
    }
}

/**
 * charge_reply message
 */
class Down_ChargeReply extends \ProtobufMessage
{
    /* Field index constants */
    const _SERIAL_ID = 1;
    const _CHARGE_ID = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_SERIAL_ID => array(
            'name' => '_serial_id',
            'required' => true,
            'type' => 7,
        ),
        self::_CHARGE_ID => array(
            'name' => '_charge_id',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_SERIAL_ID] = null;
        $this->values[self::_CHARGE_ID] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_serial_id' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setSerialId($value)
    {
        return $this->set(self::_SERIAL_ID, $value);
    }

    /**
     * Returns value of '_serial_id' property
     *
     * @return string
     */
    public function getSerialId()
    {
        return $this->get(self::_SERIAL_ID);
    }

    /**
     * Sets value of '_charge_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setChargeId($value)
    {
        return $this->set(self::_CHARGE_ID, $value);
    }

    /**
     * Returns value of '_charge_id' property
     *
     * @return int
     */
    public function getChargeId()
    {
        return $this->get(self::_CHARGE_ID);
    }
}

/**
 * notify_msg message
 */
class Down_NotifyMsg extends \ProtobufMessage
{
    /* Field index constants */
    const _LADDER_NOTIFY = 1;
    const _NEW_MAIL = 2;
    const _GUILD_CHAT = 3;
    const _ACTIVITY_NOTIFY = 4;
    const _ACTIVITY_REWARD = 5;
    const _RELEASE_HEROES = 6;
    const _EXCAV_RECORD = 7;
    const _GUILD_DROP = 8;
    const _PERSONAL_CHAT = 9;
    const _SPLITABLE_HEROES = 10;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_LADDER_NOTIFY => array(
            'name' => '_ladder_notify',
            'required' => false,
            'type' => 'Down_LadderNotify'
        ),
        self::_NEW_MAIL => array(
            'name' => '_new_mail',
            'required' => false,
            'type' => 5,
        ),
        self::_GUILD_CHAT => array(
            'name' => '_guild_chat',
            'required' => false,
            'type' => 5,
        ),
        self::_ACTIVITY_NOTIFY => array(
            'name' => '_activity_notify',
            'required' => false,
            'type' => 5,
        ),
        self::_ACTIVITY_REWARD => array(
            'name' => '_activity_reward',
            'required' => false,
            'type' => 5,
        ),
        self::_RELEASE_HEROES => array(
            'name' => '_release_heroes',
            'repeated' => true,
            'type' => 5,
        ),
        self::_EXCAV_RECORD => array(
            'name' => '_excav_record',
            'required' => false,
            'type' => 5,
        ),
        self::_GUILD_DROP => array(
            'name' => '_guild_drop',
            'required' => false,
            'type' => 5,
        ),
        self::_PERSONAL_CHAT => array(
            'name' => '_personal_chat',
            'required' => false,
            'type' => 5,
        ),
        self::_SPLITABLE_HEROES => array(
            'name' => '_splitable_heroes',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_LADDER_NOTIFY] = null;
        $this->values[self::_NEW_MAIL] = null;
        $this->values[self::_GUILD_CHAT] = null;
        $this->values[self::_ACTIVITY_NOTIFY] = null;
        $this->values[self::_ACTIVITY_REWARD] = null;
        $this->values[self::_RELEASE_HEROES] = array();
        $this->values[self::_EXCAV_RECORD] = null;
        $this->values[self::_GUILD_DROP] = null;
        $this->values[self::_PERSONAL_CHAT] = null;
        $this->values[self::_SPLITABLE_HEROES] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_ladder_notify' property
     *
     * @param Down_LadderNotify $value Property value
     *
     * @return null
     */
    public function setLadderNotify(Down_LadderNotify $value)
    {
        return $this->set(self::_LADDER_NOTIFY, $value);
    }

    /**
     * Returns value of '_ladder_notify' property
     *
     * @return Down_LadderNotify
     */
    public function getLadderNotify()
    {
        return $this->get(self::_LADDER_NOTIFY);
    }

    /**
     * Sets value of '_new_mail' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setNewMail($value)
    {
        return $this->set(self::_NEW_MAIL, $value);
    }

    /**
     * Returns value of '_new_mail' property
     *
     * @return int
     */
    public function getNewMail()
    {
        return $this->get(self::_NEW_MAIL);
    }

    /**
     * Sets value of '_guild_chat' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setGuildChat($value)
    {
        return $this->set(self::_GUILD_CHAT, $value);
    }

    /**
     * Returns value of '_guild_chat' property
     *
     * @return int
     */
    public function getGuildChat()
    {
        return $this->get(self::_GUILD_CHAT);
    }

    /**
     * Sets value of '_activity_notify' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setActivityNotify($value)
    {
        return $this->set(self::_ACTIVITY_NOTIFY, $value);
    }

    /**
     * Returns value of '_activity_notify' property
     *
     * @return int
     */
    public function getActivityNotify()
    {
        return $this->get(self::_ACTIVITY_NOTIFY);
    }

    /**
     * Sets value of '_activity_reward' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setActivityReward($value)
    {
        return $this->set(self::_ACTIVITY_REWARD, $value);
    }

    /**
     * Returns value of '_activity_reward' property
     *
     * @return int
     */
    public function getActivityReward()
    {
        return $this->get(self::_ACTIVITY_REWARD);
    }

    /**
     * Appends value to '_release_heroes' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendReleaseHeroes($value)
    {
        return $this->append(self::_RELEASE_HEROES, $value);
    }

    /**
     * Clears '_release_heroes' list
     *
     * @return null
     */
    public function clearReleaseHeroes()
    {
        return $this->clear(self::_RELEASE_HEROES);
    }

    /**
     * Returns '_release_heroes' list
     *
     * @return int[]
     */
    public function getReleaseHeroes()
    {
        return $this->get(self::_RELEASE_HEROES);
    }

    /**
     * Returns '_release_heroes' iterator
     *
     * @return ArrayIterator
     */
    public function getReleaseHeroesIterator()
    {
        return new \ArrayIterator($this->get(self::_RELEASE_HEROES));
    }

    /**
     * Returns element from '_release_heroes' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getReleaseHeroesAt($offset)
    {
        return $this->get(self::_RELEASE_HEROES, $offset);
    }

    /**
     * Returns count of '_release_heroes' list
     *
     * @return int
     */
    public function getReleaseHeroesCount()
    {
        return $this->count(self::_RELEASE_HEROES);
    }

    /**
     * Sets value of '_excav_record' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setExcavRecord($value)
    {
        return $this->set(self::_EXCAV_RECORD, $value);
    }

    /**
     * Returns value of '_excav_record' property
     *
     * @return int
     */
    public function getExcavRecord()
    {
        return $this->get(self::_EXCAV_RECORD);
    }

    /**
     * Sets value of '_guild_drop' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setGuildDrop($value)
    {
        return $this->set(self::_GUILD_DROP, $value);
    }

    /**
     * Returns value of '_guild_drop' property
     *
     * @return int
     */
    public function getGuildDrop()
    {
        return $this->get(self::_GUILD_DROP);
    }

    /**
     * Sets value of '_personal_chat' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setPersonalChat($value)
    {
        return $this->set(self::_PERSONAL_CHAT, $value);
    }

    /**
     * Returns value of '_personal_chat' property
     *
     * @return int
     */
    public function getPersonalChat()
    {
        return $this->get(self::_PERSONAL_CHAT);
    }

    /**
     * Sets value of '_splitable_heroes' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSplitableHeroes($value)
    {
        return $this->set(self::_SPLITABLE_HEROES, $value);
    }

    /**
     * Returns value of '_splitable_heroes' property
     *
     * @return int
     */
    public function getSplitableHeroes()
    {
        return $this->get(self::_SPLITABLE_HEROES);
    }
}

/**
 * ladder_notify message
 */
class Down_LadderNotify extends \ProtobufMessage
{
    /* Field index constants */
    const _IS_ATTACKED = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_IS_ATTACKED => array(
            'name' => '_is_attacked',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_IS_ATTACKED] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_is_attacked' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setIsAttacked($value)
    {
        return $this->set(self::_IS_ATTACKED, $value);
    }

    /**
     * Returns value of '_is_attacked' property
     *
     * @return int
     */
    public function getIsAttacked()
    {
        return $this->get(self::_IS_ATTACKED);
    }
}

/**
 * tbc_reply message
 */
class Down_TbcReply extends \ProtobufMessage
{
    /* Field index constants */
    const _OPEN_PANEL = 1;
    const _QUERY_OPPO = 2;
    const _START_BAT = 3;
    const _END_BAT = 4;
    const _RESET = 5;
    const _DRAW_REWARD = 6;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_OPEN_PANEL => array(
            'name' => '_open_panel',
            'required' => false,
            'type' => 'Down_TbcOpenPanel'
        ),
        self::_QUERY_OPPO => array(
            'name' => '_query_oppo',
            'required' => false,
            'type' => 'Down_TbcQueryOppo'
        ),
        self::_START_BAT => array(
            'name' => '_start_bat',
            'required' => false,
            'type' => 'Down_TbcStartBattle'
        ),
        self::_END_BAT => array(
            'name' => '_end_bat',
            'required' => false,
            'type' => 'Down_TbcEndBattle'
        ),
        self::_RESET => array(
            'name' => '_reset',
            'required' => false,
            'type' => 'Down_TbcReset'
        ),
        self::_DRAW_REWARD => array(
            'name' => '_draw_reward',
            'required' => false,
            'type' => 'Down_TbcDrawReward'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_OPEN_PANEL] = null;
        $this->values[self::_QUERY_OPPO] = null;
        $this->values[self::_START_BAT] = null;
        $this->values[self::_END_BAT] = null;
        $this->values[self::_RESET] = null;
        $this->values[self::_DRAW_REWARD] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_open_panel' property
     *
     * @param Down_TbcOpenPanel $value Property value
     *
     * @return null
     */
    public function setOpenPanel(Down_TbcOpenPanel $value)
    {
        return $this->set(self::_OPEN_PANEL, $value);
    }

    /**
     * Returns value of '_open_panel' property
     *
     * @return Down_TbcOpenPanel
     */
    public function getOpenPanel()
    {
        return $this->get(self::_OPEN_PANEL);
    }

    /**
     * Sets value of '_query_oppo' property
     *
     * @param Down_TbcQueryOppo $value Property value
     *
     * @return null
     */
    public function setQueryOppo(Down_TbcQueryOppo $value)
    {
        return $this->set(self::_QUERY_OPPO, $value);
    }

    /**
     * Returns value of '_query_oppo' property
     *
     * @return Down_TbcQueryOppo
     */
    public function getQueryOppo()
    {
        return $this->get(self::_QUERY_OPPO);
    }

    /**
     * Sets value of '_start_bat' property
     *
     * @param Down_TbcStartBattle $value Property value
     *
     * @return null
     */
    public function setStartBat(Down_TbcStartBattle $value)
    {
        return $this->set(self::_START_BAT, $value);
    }

    /**
     * Returns value of '_start_bat' property
     *
     * @return Down_TbcStartBattle
     */
    public function getStartBat()
    {
        return $this->get(self::_START_BAT);
    }

    /**
     * Sets value of '_end_bat' property
     *
     * @param Down_TbcEndBattle $value Property value
     *
     * @return null
     */
    public function setEndBat(Down_TbcEndBattle $value)
    {
        return $this->set(self::_END_BAT, $value);
    }

    /**
     * Returns value of '_end_bat' property
     *
     * @return Down_TbcEndBattle
     */
    public function getEndBat()
    {
        return $this->get(self::_END_BAT);
    }

    /**
     * Sets value of '_reset' property
     *
     * @param Down_TbcReset $value Property value
     *
     * @return null
     */
    public function setReset(Down_TbcReset $value)
    {
        return $this->set(self::_RESET, $value);
    }

    /**
     * Returns value of '_reset' property
     *
     * @return Down_TbcReset
     */
    public function getReset()
    {
        return $this->get(self::_RESET);
    }

    /**
     * Sets value of '_draw_reward' property
     *
     * @param Down_TbcDrawReward $value Property value
     *
     * @return null
     */
    public function setDrawReward(Down_TbcDrawReward $value)
    {
        return $this->set(self::_DRAW_REWARD, $value);
    }

    /**
     * Returns value of '_draw_reward' property
     *
     * @return Down_TbcDrawReward
     */
    public function getDrawReward()
    {
        return $this->get(self::_DRAW_REWARD);
    }
}

/**
 * tbc_self_hero message
 */
class Down_TbcSelfHero extends \ProtobufMessage
{
    /* Field index constants */
    const _TID = 1;
    const _DYNA = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TID => array(
            'name' => '_tid',
            'required' => true,
            'type' => 5,
        ),
        self::_DYNA => array(
            'name' => '_dyna',
            'required' => true,
            'type' => 'Down_HeroDyna'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_TID] = null;
        $this->values[self::_DYNA] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_tid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setTid($value)
    {
        return $this->set(self::_TID, $value);
    }

    /**
     * Returns value of '_tid' property
     *
     * @return int
     */
    public function getTid()
    {
        return $this->get(self::_TID);
    }

    /**
     * Sets value of '_dyna' property
     *
     * @param Down_HeroDyna $value Property value
     *
     * @return null
     */
    public function setDyna(Down_HeroDyna $value)
    {
        return $this->set(self::_DYNA, $value);
    }

    /**
     * Returns value of '_dyna' property
     *
     * @return Down_HeroDyna
     */
    public function getDyna()
    {
        return $this->get(self::_DYNA);
    }
}

/**
 * tbc_oppo_hero message
 */
class Down_TbcOppoHero extends \ProtobufMessage
{
    /* Field index constants */
    const _BASE = 1;
    const _DYNA = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_BASE => array(
            'name' => '_base',
            'required' => true,
            'type' => 'Down_Hero'
        ),
        self::_DYNA => array(
            'name' => '_dyna',
            'required' => true,
            'type' => 'Down_HeroDyna'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_BASE] = null;
        $this->values[self::_DYNA] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_base' property
     *
     * @param Down_Hero $value Property value
     *
     * @return null
     */
    public function setBase(Down_Hero $value)
    {
        return $this->set(self::_BASE, $value);
    }

    /**
     * Returns value of '_base' property
     *
     * @return Down_Hero
     */
    public function getBase()
    {
        return $this->get(self::_BASE);
    }

    /**
     * Sets value of '_dyna' property
     *
     * @param Down_HeroDyna $value Property value
     *
     * @return null
     */
    public function setDyna(Down_HeroDyna $value)
    {
        return $this->set(self::_DYNA, $value);
    }

    /**
     * Returns value of '_dyna' property
     *
     * @return Down_HeroDyna
     */
    public function getDyna()
    {
        return $this->get(self::_DYNA);
    }
}

/**
 * type enum embedded in tbc_reward message
 */
final class Down_TbcReward_Type
{
    const gold = 1;
    const diamond = 2;
    const item = 3;
    const chest = 4;
    const crusadepoint = 5;
    const chestbox = 6;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'gold' => self::gold,
            'diamond' => self::diamond,
            'item' => self::item,
            'chest' => self::chest,
            'crusadepoint' => self::crusadepoint,
            'chestbox' => self::chestbox,
        );
    }
}

/**
 * tbc_reward message
 */
class Down_TbcReward extends \ProtobufMessage
{
    /* Field index constants */
    const _TYPE = 1;
    const _PARAM1 = 2;
    const _PARAM2 = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TYPE => array(
            'name' => '_type',
            'required' => true,
            'type' => 5,
        ),
        self::_PARAM1 => array(
            'name' => '_param1',
            'required' => false,
            'type' => 5,
        ),
        self::_PARAM2 => array(
            'name' => '_param2',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_TYPE] = null;
        $this->values[self::_PARAM1] = null;
        $this->values[self::_PARAM2] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_type' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setType($value)
    {
        return $this->set(self::_TYPE, $value);
    }

    /**
     * Returns value of '_type' property
     *
     * @return int
     */
    public function getType()
    {
        return $this->get(self::_TYPE);
    }

    /**
     * Sets value of '_param1' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setParam1($value)
    {
        return $this->set(self::_PARAM1, $value);
    }

    /**
     * Returns value of '_param1' property
     *
     * @return int
     */
    public function getParam1()
    {
        return $this->get(self::_PARAM1);
    }

    /**
     * Sets value of '_param2' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setParam2($value)
    {
        return $this->set(self::_PARAM2, $value);
    }

    /**
     * Returns value of '_param2' property
     *
     * @return int
     */
    public function getParam2()
    {
        return $this->get(self::_PARAM2);
    }
}

/**
 * status enum embedded in tbc_stage message
 */
final class Down_TbcStage_Status
{
    const unpassed = 0;
    const passed = 1;
    const rewarded = 2;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'unpassed' => self::unpassed,
            'passed' => self::passed,
            'rewarded' => self::rewarded,
        );
    }
}

/**
 * tbc_stage message
 */
class Down_TbcStage extends \ProtobufMessage
{
    /* Field index constants */
    const _STATUS = 1;
    const _REWARDS = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_STATUS => array(
            'default' => Down_TbcStage_Status::unpassed, 
            'name' => '_status',
            'required' => true,
            'type' => 5,
        ),
        self::_REWARDS => array(
            'name' => '_rewards',
            'repeated' => true,
            'type' => 'Down_TbcReward'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_STATUS] = null;
        $this->values[self::_REWARDS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_status' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStatus($value)
    {
        return $this->set(self::_STATUS, $value);
    }

    /**
     * Returns value of '_status' property
     *
     * @return int
     */
    public function getStatus()
    {
        return $this->get(self::_STATUS);
    }

    /**
     * Appends value to '_rewards' list
     *
     * @param Down_TbcReward $value Value to append
     *
     * @return null
     */
    public function appendRewards(Down_TbcReward $value)
    {
        return $this->append(self::_REWARDS, $value);
    }

    /**
     * Clears '_rewards' list
     *
     * @return null
     */
    public function clearRewards()
    {
        return $this->clear(self::_REWARDS);
    }

    /**
     * Returns '_rewards' list
     *
     * @return Down_TbcReward[]
     */
    public function getRewards()
    {
        return $this->get(self::_REWARDS);
    }

    /**
     * Returns '_rewards' iterator
     *
     * @return ArrayIterator
     */
    public function getRewardsIterator()
    {
        return new \ArrayIterator($this->get(self::_REWARDS));
    }

    /**
     * Returns element from '_rewards' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_TbcReward
     */
    public function getRewardsAt($offset)
    {
        return $this->get(self::_REWARDS, $offset);
    }

    /**
     * Returns count of '_rewards' list
     *
     * @return int
     */
    public function getRewardsCount()
    {
        return $this->count(self::_REWARDS);
    }
}

/**
 * tbc_info message
 */
class Down_TbcInfo extends \ProtobufMessage
{
    /* Field index constants */
    const _CUR_STAGE = 1;
    const _RESET_TIMES = 2;
    const _HEROES = 3;
    const _STAGES = 4;
    const _HIRE_HERO = 5;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_CUR_STAGE => array(
            'name' => '_cur_stage',
            'required' => true,
            'type' => 5,
        ),
        self::_RESET_TIMES => array(
            'name' => '_reset_times',
            'required' => true,
            'type' => 5,
        ),
        self::_HEROES => array(
            'name' => '_heroes',
            'repeated' => true,
            'type' => 'Down_TbcSelfHero'
        ),
        self::_STAGES => array(
            'name' => '_stages',
            'repeated' => true,
            'type' => 'Down_TbcStage'
        ),
        self::_HIRE_HERO => array(
            'name' => '_hire_hero',
            'required' => false,
            'type' => 'Down_HireData'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_CUR_STAGE] = null;
        $this->values[self::_RESET_TIMES] = null;
        $this->values[self::_HEROES] = array();
        $this->values[self::_STAGES] = array();
        $this->values[self::_HIRE_HERO] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_cur_stage' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCurStage($value)
    {
        return $this->set(self::_CUR_STAGE, $value);
    }

    /**
     * Returns value of '_cur_stage' property
     *
     * @return int
     */
    public function getCurStage()
    {
        return $this->get(self::_CUR_STAGE);
    }

    /**
     * Sets value of '_reset_times' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResetTimes($value)
    {
        return $this->set(self::_RESET_TIMES, $value);
    }

    /**
     * Returns value of '_reset_times' property
     *
     * @return int
     */
    public function getResetTimes()
    {
        return $this->get(self::_RESET_TIMES);
    }

    /**
     * Appends value to '_heroes' list
     *
     * @param Down_TbcSelfHero $value Value to append
     *
     * @return null
     */
    public function appendHeroes(Down_TbcSelfHero $value)
    {
        return $this->append(self::_HEROES, $value);
    }

    /**
     * Clears '_heroes' list
     *
     * @return null
     */
    public function clearHeroes()
    {
        return $this->clear(self::_HEROES);
    }

    /**
     * Returns '_heroes' list
     *
     * @return Down_TbcSelfHero[]
     */
    public function getHeroes()
    {
        return $this->get(self::_HEROES);
    }

    /**
     * Returns '_heroes' iterator
     *
     * @return ArrayIterator
     */
    public function getHeroesIterator()
    {
        return new \ArrayIterator($this->get(self::_HEROES));
    }

    /**
     * Returns element from '_heroes' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_TbcSelfHero
     */
    public function getHeroesAt($offset)
    {
        return $this->get(self::_HEROES, $offset);
    }

    /**
     * Returns count of '_heroes' list
     *
     * @return int
     */
    public function getHeroesCount()
    {
        return $this->count(self::_HEROES);
    }

    /**
     * Appends value to '_stages' list
     *
     * @param Down_TbcStage $value Value to append
     *
     * @return null
     */
    public function appendStages(Down_TbcStage $value)
    {
        return $this->append(self::_STAGES, $value);
    }

    /**
     * Clears '_stages' list
     *
     * @return null
     */
    public function clearStages()
    {
        return $this->clear(self::_STAGES);
    }

    /**
     * Returns '_stages' list
     *
     * @return Down_TbcStage[]
     */
    public function getStages()
    {
        return $this->get(self::_STAGES);
    }

    /**
     * Returns '_stages' iterator
     *
     * @return ArrayIterator
     */
    public function getStagesIterator()
    {
        return new \ArrayIterator($this->get(self::_STAGES));
    }

    /**
     * Returns element from '_stages' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_TbcStage
     */
    public function getStagesAt($offset)
    {
        return $this->get(self::_STAGES, $offset);
    }

    /**
     * Returns count of '_stages' list
     *
     * @return int
     */
    public function getStagesCount()
    {
        return $this->count(self::_STAGES);
    }

    /**
     * Sets value of '_hire_hero' property
     *
     * @param Down_HireData $value Property value
     *
     * @return null
     */
    public function setHireHero(Down_HireData $value)
    {
        return $this->set(self::_HIRE_HERO, $value);
    }

    /**
     * Returns value of '_hire_hero' property
     *
     * @return Down_HireData
     */
    public function getHireHero()
    {
        return $this->get(self::_HIRE_HERO);
    }
}

/**
 * tbc_open_panel message
 */
class Down_TbcOpenPanel extends \ProtobufMessage
{
    /* Field index constants */
    const _INFO = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_INFO => array(
            'name' => '_info',
            'required' => true,
            'type' => 'Down_TbcInfo'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_INFO] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_info' property
     *
     * @param Down_TbcInfo $value Property value
     *
     * @return null
     */
    public function setInfo(Down_TbcInfo $value)
    {
        return $this->set(self::_INFO, $value);
    }

    /**
     * Returns value of '_info' property
     *
     * @return Down_TbcInfo
     */
    public function getInfo()
    {
        return $this->get(self::_INFO);
    }
}

/**
 * tbc_query_oppo message
 */
class Down_TbcQueryOppo extends \ProtobufMessage
{
    /* Field index constants */
    const _SUMMARY = 1;
    const _OPPOS = 2;
    const _IS_ROBOT = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_SUMMARY => array(
            'name' => '_summary',
            'required' => true,
            'type' => 'Down_UserSummary'
        ),
        self::_OPPOS => array(
            'name' => '_oppos',
            'repeated' => true,
            'type' => 'Down_TbcOppoHero'
        ),
        self::_IS_ROBOT => array(
            'name' => '_is_robot',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_SUMMARY] = null;
        $this->values[self::_OPPOS] = array();
        $this->values[self::_IS_ROBOT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_summary' property
     *
     * @param Down_UserSummary $value Property value
     *
     * @return null
     */
    public function setSummary(Down_UserSummary $value)
    {
        return $this->set(self::_SUMMARY, $value);
    }

    /**
     * Returns value of '_summary' property
     *
     * @return Down_UserSummary
     */
    public function getSummary()
    {
        return $this->get(self::_SUMMARY);
    }

    /**
     * Appends value to '_oppos' list
     *
     * @param Down_TbcOppoHero $value Value to append
     *
     * @return null
     */
    public function appendOppos(Down_TbcOppoHero $value)
    {
        return $this->append(self::_OPPOS, $value);
    }

    /**
     * Clears '_oppos' list
     *
     * @return null
     */
    public function clearOppos()
    {
        return $this->clear(self::_OPPOS);
    }

    /**
     * Returns '_oppos' list
     *
     * @return Down_TbcOppoHero[]
     */
    public function getOppos()
    {
        return $this->get(self::_OPPOS);
    }

    /**
     * Returns '_oppos' iterator
     *
     * @return ArrayIterator
     */
    public function getOpposIterator()
    {
        return new \ArrayIterator($this->get(self::_OPPOS));
    }

    /**
     * Returns element from '_oppos' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_TbcOppoHero
     */
    public function getOpposAt($offset)
    {
        return $this->get(self::_OPPOS, $offset);
    }

    /**
     * Returns count of '_oppos' list
     *
     * @return int
     */
    public function getOpposCount()
    {
        return $this->count(self::_OPPOS);
    }

    /**
     * Sets value of '_is_robot' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setIsRobot($value)
    {
        return $this->set(self::_IS_ROBOT, $value);
    }

    /**
     * Returns value of '_is_robot' property
     *
     * @return int
     */
    public function getIsRobot()
    {
        return $this->get(self::_IS_ROBOT);
    }
}

/**
 * tbc_start_battle message
 */
class Down_TbcStartBattle extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _RSEED = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_Result::success, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_RSEED => array(
            'name' => '_rseed',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_RSEED] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_rseed' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRseed($value)
    {
        return $this->set(self::_RSEED, $value);
    }

    /**
     * Returns value of '_rseed' property
     *
     * @return int
     */
    public function getRseed()
    {
        return $this->get(self::_RSEED);
    }
}

/**
 * tbc_end_battle message
 */
class Down_TbcEndBattle extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_BattleResult::victory, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }
}

/**
 * tbc_reset message
 */
class Down_TbcReset extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _INFO = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_Result::success, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_INFO => array(
            'name' => '_info',
            'required' => false,
            'type' => 'Down_TbcInfo'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_INFO] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_info' property
     *
     * @param Down_TbcInfo $value Property value
     *
     * @return null
     */
    public function setInfo(Down_TbcInfo $value)
    {
        return $this->set(self::_INFO, $value);
    }

    /**
     * Returns value of '_info' property
     *
     * @return Down_TbcInfo
     */
    public function getInfo()
    {
        return $this->get(self::_INFO);
    }
}

/**
 * tbc_draw_reward message
 */
class Down_TbcDrawReward extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _STAGE_ID = 2;
    const _REWARDS = 3;
    const _HEROES = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_Result::success, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_STAGE_ID => array(
            'name' => '_stage_id',
            'required' => true,
            'type' => 5,
        ),
        self::_REWARDS => array(
            'name' => '_rewards',
            'repeated' => true,
            'type' => 'Down_TbcReward'
        ),
        self::_HEROES => array(
            'name' => '_heroes',
            'repeated' => true,
            'type' => 'Down_Hero'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_STAGE_ID] = null;
        $this->values[self::_REWARDS] = array();
        $this->values[self::_HEROES] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_stage_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStageId($value)
    {
        return $this->set(self::_STAGE_ID, $value);
    }

    /**
     * Returns value of '_stage_id' property
     *
     * @return int
     */
    public function getStageId()
    {
        return $this->get(self::_STAGE_ID);
    }

    /**
     * Appends value to '_rewards' list
     *
     * @param Down_TbcReward $value Value to append
     *
     * @return null
     */
    public function appendRewards(Down_TbcReward $value)
    {
        return $this->append(self::_REWARDS, $value);
    }

    /**
     * Clears '_rewards' list
     *
     * @return null
     */
    public function clearRewards()
    {
        return $this->clear(self::_REWARDS);
    }

    /**
     * Returns '_rewards' list
     *
     * @return Down_TbcReward[]
     */
    public function getRewards()
    {
        return $this->get(self::_REWARDS);
    }

    /**
     * Returns '_rewards' iterator
     *
     * @return ArrayIterator
     */
    public function getRewardsIterator()
    {
        return new \ArrayIterator($this->get(self::_REWARDS));
    }

    /**
     * Returns element from '_rewards' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_TbcReward
     */
    public function getRewardsAt($offset)
    {
        return $this->get(self::_REWARDS, $offset);
    }

    /**
     * Returns count of '_rewards' list
     *
     * @return int
     */
    public function getRewardsCount()
    {
        return $this->count(self::_REWARDS);
    }

    /**
     * Appends value to '_heroes' list
     *
     * @param Down_Hero $value Value to append
     *
     * @return null
     */
    public function appendHeroes(Down_Hero $value)
    {
        return $this->append(self::_HEROES, $value);
    }

    /**
     * Clears '_heroes' list
     *
     * @return null
     */
    public function clearHeroes()
    {
        return $this->clear(self::_HEROES);
    }

    /**
     * Returns '_heroes' list
     *
     * @return Down_Hero[]
     */
    public function getHeroes()
    {
        return $this->get(self::_HEROES);
    }

    /**
     * Returns '_heroes' iterator
     *
     * @return ArrayIterator
     */
    public function getHeroesIterator()
    {
        return new \ArrayIterator($this->get(self::_HEROES));
    }

    /**
     * Returns element from '_heroes' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_Hero
     */
    public function getHeroesAt($offset)
    {
        return $this->get(self::_HEROES, $offset);
    }

    /**
     * Returns count of '_heroes' list
     *
     * @return int
     */
    public function getHeroesCount()
    {
        return $this->count(self::_HEROES);
    }
}

/**
 * get_maillist_reply message
 */
class Down_GetMaillistReply extends \ProtobufMessage
{
    /* Field index constants */
    const _SYS_MAIL_LIST = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_SYS_MAIL_LIST => array(
            'name' => '_sys_mail_list',
            'repeated' => true,
            'type' => 'Down_SysMail'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_SYS_MAIL_LIST] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_sys_mail_list' list
     *
     * @param Down_SysMail $value Value to append
     *
     * @return null
     */
    public function appendSysMailList(Down_SysMail $value)
    {
        return $this->append(self::_SYS_MAIL_LIST, $value);
    }

    /**
     * Clears '_sys_mail_list' list
     *
     * @return null
     */
    public function clearSysMailList()
    {
        return $this->clear(self::_SYS_MAIL_LIST);
    }

    /**
     * Returns '_sys_mail_list' list
     *
     * @return Down_SysMail[]
     */
    public function getSysMailList()
    {
        return $this->get(self::_SYS_MAIL_LIST);
    }

    /**
     * Returns '_sys_mail_list' iterator
     *
     * @return ArrayIterator
     */
    public function getSysMailListIterator()
    {
        return new \ArrayIterator($this->get(self::_SYS_MAIL_LIST));
    }

    /**
     * Returns element from '_sys_mail_list' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_SysMail
     */
    public function getSysMailListAt($offset)
    {
        return $this->get(self::_SYS_MAIL_LIST, $offset);
    }

    /**
     * Returns count of '_sys_mail_list' list
     *
     * @return int
     */
    public function getSysMailListCount()
    {
        return $this->count(self::_SYS_MAIL_LIST);
    }
}

/**
 * status enum embedded in sys_mail message
 */
final class Down_SysMail_Status
{
    const unread = 0;
    const read = 1;
    const delete = 2;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'unread' => self::unread,
            'read' => self::read,
            'delete' => self::delete,
        );
    }
}

/**
 * sys_mail message
 */
class Down_SysMail extends \ProtobufMessage
{
    /* Field index constants */
    const _ID = 1;
    const _STATUS = 2;
    const _MAIL_TIME = 3;
    const _EXPIRE_TIME = 4;
    const _CONTENT = 5;
    const _MONEY = 6;
    const _DIAMONDS = 7;
    const _SKILL_POINT = 8;
    const _ITEMS = 9;
    const _TYPE = 11;
    const _POINTS = 10;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ID => array(
            'name' => '_id',
            'required' => true,
            'type' => 5,
        ),
        self::_STATUS => array(
            'name' => '_status',
            'required' => true,
            'type' => 5,
        ),
        self::_MAIL_TIME => array(
            'name' => '_mail_time',
            'required' => true,
            'type' => 5,
        ),
        self::_EXPIRE_TIME => array(
            'name' => '_expire_time',
            'required' => true,
            'type' => 5,
        ),
        self::_CONTENT => array(
            'name' => '_content',
            'required' => true,
            'type' => 'Down_MailContent'
        ),
        self::_MONEY => array(
            'name' => '_money',
            'required' => false,
            'type' => 5,
        ),
        self::_DIAMONDS => array(
            'name' => '_diamonds',
            'required' => false,
            'type' => 5,
        ),
        self::_SKILL_POINT => array(
            'name' => '_skill_point',
            'required' => false,
            'type' => 5,
        ),
        self::_ITEMS => array(
            'name' => '_items',
            'repeated' => true,
            'type' => 5,
        ),
        self::_TYPE => array(
            'name' => '_type',
            'required' => true,
            'type' => 5,
        ),
        self::_POINTS => array(
            'name' => '_points',
            'repeated' => true,
            'type' => 'Down_UserPoint'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ID] = null;
        $this->values[self::_STATUS] = null;
        $this->values[self::_MAIL_TIME] = null;
        $this->values[self::_EXPIRE_TIME] = null;
        $this->values[self::_CONTENT] = null;
        $this->values[self::_MONEY] = null;
        $this->values[self::_DIAMONDS] = null;
        $this->values[self::_SKILL_POINT] = null;
        $this->values[self::_ITEMS] = array();
        $this->values[self::_TYPE] = null;
        $this->values[self::_POINTS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setId($value)
    {
        return $this->set(self::_ID, $value);
    }

    /**
     * Returns value of '_id' property
     *
     * @return int
     */
    public function getId()
    {
        return $this->get(self::_ID);
    }

    /**
     * Sets value of '_status' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStatus($value)
    {
        return $this->set(self::_STATUS, $value);
    }

    /**
     * Returns value of '_status' property
     *
     * @return int
     */
    public function getStatus()
    {
        return $this->get(self::_STATUS);
    }

    /**
     * Sets value of '_mail_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setMailTime($value)
    {
        return $this->set(self::_MAIL_TIME, $value);
    }

    /**
     * Returns value of '_mail_time' property
     *
     * @return int
     */
    public function getMailTime()
    {
        return $this->get(self::_MAIL_TIME);
    }

    /**
     * Sets value of '_expire_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setExpireTime($value)
    {
        return $this->set(self::_EXPIRE_TIME, $value);
    }

    /**
     * Returns value of '_expire_time' property
     *
     * @return int
     */
    public function getExpireTime()
    {
        return $this->get(self::_EXPIRE_TIME);
    }

    /**
     * Sets value of '_content' property
     *
     * @param Down_MailContent $value Property value
     *
     * @return null
     */
    public function setContent(Down_MailContent $value)
    {
        return $this->set(self::_CONTENT, $value);
    }

    /**
     * Returns value of '_content' property
     *
     * @return Down_MailContent
     */
    public function getContent()
    {
        return $this->get(self::_CONTENT);
    }

    /**
     * Sets value of '_money' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setMoney($value)
    {
        return $this->set(self::_MONEY, $value);
    }

    /**
     * Returns value of '_money' property
     *
     * @return int
     */
    public function getMoney()
    {
        return $this->get(self::_MONEY);
    }

    /**
     * Sets value of '_diamonds' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setDiamonds($value)
    {
        return $this->set(self::_DIAMONDS, $value);
    }

    /**
     * Returns value of '_diamonds' property
     *
     * @return int
     */
    public function getDiamonds()
    {
        return $this->get(self::_DIAMONDS);
    }

    /**
     * Sets value of '_skill_point' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSkillPoint($value)
    {
        return $this->set(self::_SKILL_POINT, $value);
    }

    /**
     * Returns value of '_skill_point' property
     *
     * @return int
     */
    public function getSkillPoint()
    {
        return $this->get(self::_SKILL_POINT);
    }

    /**
     * Appends value to '_items' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendItems($value)
    {
        return $this->append(self::_ITEMS, $value);
    }

    /**
     * Clears '_items' list
     *
     * @return null
     */
    public function clearItems()
    {
        return $this->clear(self::_ITEMS);
    }

    /**
     * Returns '_items' list
     *
     * @return int[]
     */
    public function getItems()
    {
        return $this->get(self::_ITEMS);
    }

    /**
     * Returns '_items' iterator
     *
     * @return ArrayIterator
     */
    public function getItemsIterator()
    {
        return new \ArrayIterator($this->get(self::_ITEMS));
    }

    /**
     * Returns element from '_items' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getItemsAt($offset)
    {
        return $this->get(self::_ITEMS, $offset);
    }

    /**
     * Returns count of '_items' list
     *
     * @return int
     */
    public function getItemsCount()
    {
        return $this->count(self::_ITEMS);
    }

    /**
     * Sets value of '_type' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setType($value)
    {
        return $this->set(self::_TYPE, $value);
    }

    /**
     * Returns value of '_type' property
     *
     * @return int
     */
    public function getType()
    {
        return $this->get(self::_TYPE);
    }

    /**
     * Appends value to '_points' list
     *
     * @param Down_UserPoint $value Value to append
     *
     * @return null
     */
    public function appendPoints(Down_UserPoint $value)
    {
        return $this->append(self::_POINTS, $value);
    }

    /**
     * Clears '_points' list
     *
     * @return null
     */
    public function clearPoints()
    {
        return $this->clear(self::_POINTS);
    }

    /**
     * Returns '_points' list
     *
     * @return Down_UserPoint[]
     */
    public function getPoints()
    {
        return $this->get(self::_POINTS);
    }

    /**
     * Returns '_points' iterator
     *
     * @return ArrayIterator
     */
    public function getPointsIterator()
    {
        return new \ArrayIterator($this->get(self::_POINTS));
    }

    /**
     * Returns element from '_points' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_UserPoint
     */
    public function getPointsAt($offset)
    {
        return $this->get(self::_POINTS, $offset);
    }

    /**
     * Returns count of '_points' list
     *
     * @return int
     */
    public function getPointsCount()
    {
        return $this->count(self::_POINTS);
    }
}

/**
 * mail_content message
 */
class Down_MailContent extends \ProtobufMessage
{
    /* Field index constants */
    const _PLAIN_MAIL = 1;
    const _FORMAT_MAIL = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_PLAIN_MAIL => array(
            'name' => '_plain_mail',
            'required' => false,
            'type' => 'Down_PlainMail'
        ),
        self::_FORMAT_MAIL => array(
            'name' => '_format_mail',
            'required' => false,
            'type' => 'Down_FormatMail'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_PLAIN_MAIL] = null;
        $this->values[self::_FORMAT_MAIL] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_plain_mail' property
     *
     * @param Down_PlainMail $value Property value
     *
     * @return null
     */
    public function setPlainMail(Down_PlainMail $value)
    {
        return $this->set(self::_PLAIN_MAIL, $value);
    }

    /**
     * Returns value of '_plain_mail' property
     *
     * @return Down_PlainMail
     */
    public function getPlainMail()
    {
        return $this->get(self::_PLAIN_MAIL);
    }

    /**
     * Sets value of '_format_mail' property
     *
     * @param Down_FormatMail $value Property value
     *
     * @return null
     */
    public function setFormatMail(Down_FormatMail $value)
    {
        return $this->set(self::_FORMAT_MAIL, $value);
    }

    /**
     * Returns value of '_format_mail' property
     *
     * @return Down_FormatMail
     */
    public function getFormatMail()
    {
        return $this->get(self::_FORMAT_MAIL);
    }
}

/**
 * plain_mail message
 */
class Down_PlainMail extends \ProtobufMessage
{
    /* Field index constants */
    const _FROM = 1;
    const _TITLE = 2;
    const _CONTENT = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_FROM => array(
            'name' => '_from',
            'required' => true,
            'type' => 7,
        ),
        self::_TITLE => array(
            'name' => '_title',
            'required' => true,
            'type' => 7,
        ),
        self::_CONTENT => array(
            'name' => '_content',
            'required' => true,
            'type' => 7,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_FROM] = null;
        $this->values[self::_TITLE] = null;
        $this->values[self::_CONTENT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_from' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setFrom($value)
    {
        return $this->set(self::_FROM, $value);
    }

    /**
     * Returns value of '_from' property
     *
     * @return string
     */
    public function getFrom()
    {
        return $this->get(self::_FROM);
    }

    /**
     * Sets value of '_title' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setTitle($value)
    {
        return $this->set(self::_TITLE, $value);
    }

    /**
     * Returns value of '_title' property
     *
     * @return string
     */
    public function getTitle()
    {
        return $this->get(self::_TITLE);
    }

    /**
     * Sets value of '_content' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setContent($value)
    {
        return $this->set(self::_CONTENT, $value);
    }

    /**
     * Returns value of '_content' property
     *
     * @return string
     */
    public function getContent()
    {
        return $this->get(self::_CONTENT);
    }
}

/**
 * format_mail message
 */
class Down_FormatMail extends \ProtobufMessage
{
    /* Field index constants */
    const _MAIL_CFG_ID = 1;
    const _PARAMS = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_MAIL_CFG_ID => array(
            'name' => '_mail_cfg_id',
            'required' => true,
            'type' => 5,
        ),
        self::_PARAMS => array(
            'name' => '_params',
            'repeated' => true,
            'type' => 'Down_MailParam'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_MAIL_CFG_ID] = null;
        $this->values[self::_PARAMS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_mail_cfg_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setMailCfgId($value)
    {
        return $this->set(self::_MAIL_CFG_ID, $value);
    }

    /**
     * Returns value of '_mail_cfg_id' property
     *
     * @return int
     */
    public function getMailCfgId()
    {
        return $this->get(self::_MAIL_CFG_ID);
    }

    /**
     * Appends value to '_params' list
     *
     * @param Down_MailParam $value Value to append
     *
     * @return null
     */
    public function appendParams(Down_MailParam $value)
    {
        return $this->append(self::_PARAMS, $value);
    }

    /**
     * Clears '_params' list
     *
     * @return null
     */
    public function clearParams()
    {
        return $this->clear(self::_PARAMS);
    }

    /**
     * Returns '_params' list
     *
     * @return Down_MailParam[]
     */
    public function getParams()
    {
        return $this->get(self::_PARAMS);
    }

    /**
     * Returns '_params' iterator
     *
     * @return ArrayIterator
     */
    public function getParamsIterator()
    {
        return new \ArrayIterator($this->get(self::_PARAMS));
    }

    /**
     * Returns element from '_params' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_MailParam
     */
    public function getParamsAt($offset)
    {
        return $this->get(self::_PARAMS, $offset);
    }

    /**
     * Returns count of '_params' list
     *
     * @return int
     */
    public function getParamsCount()
    {
        return $this->count(self::_PARAMS);
    }
}

/**
 * mail_param_type enum embedded in mail_param message
 */
final class Down_MailParam_MailParamType
{
    const value = 1;
    const money = 2;
    const item = 3;
    const mine = 4;
    const self_hero = 5;
    const excav_battle_id = 6;
    const hero_name = 7;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'value' => self::value,
            'money' => self::money,
            'item' => self::item,
            'mine' => self::mine,
            'self_hero' => self::self_hero,
            'excav_battle_id' => self::excav_battle_id,
            'hero_name' => self::hero_name,
        );
    }
}

/**
 * mail_param message
 */
class Down_MailParam extends \ProtobufMessage
{
    /* Field index constants */
    const _IDX = 1;
    const _TYPE = 2;
    const _VALUE = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_IDX => array(
            'name' => '_idx',
            'required' => true,
            'type' => 5,
        ),
        self::_TYPE => array(
            'name' => '_type',
            'required' => false,
            'type' => 5,
        ),
        self::_VALUE => array(
            'name' => '_value',
            'required' => false,
            'type' => 7,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_IDX] = null;
        $this->values[self::_TYPE] = null;
        $this->values[self::_VALUE] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_idx' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setIdx($value)
    {
        return $this->set(self::_IDX, $value);
    }

    /**
     * Returns value of '_idx' property
     *
     * @return int
     */
    public function getIdx()
    {
        return $this->get(self::_IDX);
    }

    /**
     * Sets value of '_type' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setType($value)
    {
        return $this->set(self::_TYPE, $value);
    }

    /**
     * Returns value of '_type' property
     *
     * @return int
     */
    public function getType()
    {
        return $this->get(self::_TYPE);
    }

    /**
     * Sets value of '_value' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setValue($value)
    {
        return $this->set(self::_VALUE, $value);
    }

    /**
     * Returns value of '_value' property
     *
     * @return string
     */
    public function getValue()
    {
        return $this->get(self::_VALUE);
    }
}

/**
 * user_point_type enum embedded in user_point message
 */
final class Down_UserPoint_UserPointType
{
    const arenapoint = 1;
    const crusadepoint = 2;
    const guildpoint = 3;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'arenapoint' => self::arenapoint,
            'crusadepoint' => self::crusadepoint,
            'guildpoint' => self::guildpoint,
        );
    }
}

/**
 * user_point message
 */
class Down_UserPoint extends \ProtobufMessage
{
    /* Field index constants */
    const _TYPE = 1;
    const _VALUE = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TYPE => array(
            'default' => Down_UserPoint_UserPointType::arenapoint, 
            'name' => '_type',
            'required' => true,
            'type' => 5,
        ),
        self::_VALUE => array(
            'name' => '_value',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_TYPE] = null;
        $this->values[self::_VALUE] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_type' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setType($value)
    {
        return $this->set(self::_TYPE, $value);
    }

    /**
     * Returns value of '_type' property
     *
     * @return int
     */
    public function getType()
    {
        return $this->get(self::_TYPE);
    }

    /**
     * Sets value of '_value' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setValue($value)
    {
        return $this->set(self::_VALUE, $value);
    }

    /**
     * Returns value of '_value' property
     *
     * @return int
     */
    public function getValue()
    {
        return $this->get(self::_VALUE);
    }
}

/**
 * read_mail_reply message
 */
class Down_ReadMailReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }
}

/**
 * get_vip_gift_reply message
 */
class Down_GetVipGiftReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }
}

/**
 * chat_reply message
 */
class Down_ChatReply extends \ProtobufMessage
{
    /* Field index constants */
    const _SAY = 1;
    const _FRESH = 2;
    const _FETCH = 3;
    const _CHAT_ADD_BL = 4;
    const _CHAT_DEL_BL = 5;
    const _CHAT_BLACKLIST = 6;
    const _CHAT_BORAD_SAY = 7;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_SAY => array(
            'name' => '_say',
            'required' => false,
            'type' => 'Down_ChatSay'
        ),
        self::_FRESH => array(
            'name' => '_fresh',
            'required' => false,
            'type' => 'Down_ChatFresh'
        ),
        self::_FETCH => array(
            'name' => '_fetch',
            'required' => false,
            'type' => 'Down_ChatFetch'
        ),
        self::_CHAT_ADD_BL => array(
            'name' => '_chat_add_bl',
            'required' => false,
            'type' => 'Down_ChatAddBl'
        ),
        self::_CHAT_DEL_BL => array(
            'name' => '_chat_del_bl',
            'required' => false,
            'type' => 'Down_ChatDelBl'
        ),
        self::_CHAT_BLACKLIST => array(
            'name' => '_chat_blacklist',
            'required' => false,
            'type' => 'Down_ChatBlacklist'
        ),
        self::_CHAT_BORAD_SAY => array(
            'name' => '_chat_borad_say',
            'required' => false,
            'type' => 'Down_ChatBroadSay'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_SAY] = null;
        $this->values[self::_FRESH] = null;
        $this->values[self::_FETCH] = null;
        $this->values[self::_CHAT_ADD_BL] = null;
        $this->values[self::_CHAT_DEL_BL] = null;
        $this->values[self::_CHAT_BLACKLIST] = null;
        $this->values[self::_CHAT_BORAD_SAY] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_say' property
     *
     * @param Down_ChatSay $value Property value
     *
     * @return null
     */
    public function setSay(Down_ChatSay $value)
    {
        return $this->set(self::_SAY, $value);
    }

    /**
     * Returns value of '_say' property
     *
     * @return Down_ChatSay
     */
    public function getSay()
    {
        return $this->get(self::_SAY);
    }

    /**
     * Sets value of '_fresh' property
     *
     * @param Down_ChatFresh $value Property value
     *
     * @return null
     */
    public function setFresh(Down_ChatFresh $value)
    {
        return $this->set(self::_FRESH, $value);
    }

    /**
     * Returns value of '_fresh' property
     *
     * @return Down_ChatFresh
     */
    public function getFresh()
    {
        return $this->get(self::_FRESH);
    }

    /**
     * Sets value of '_fetch' property
     *
     * @param Down_ChatFetch $value Property value
     *
     * @return null
     */
    public function setFetch(Down_ChatFetch $value)
    {
        return $this->set(self::_FETCH, $value);
    }

    /**
     * Returns value of '_fetch' property
     *
     * @return Down_ChatFetch
     */
    public function getFetch()
    {
        return $this->get(self::_FETCH);
    }

    /**
     * Sets value of '_chat_add_bl' property
     *
     * @param Down_ChatAddBl $value Property value
     *
     * @return null
     */
    public function setChatAddBl(Down_ChatAddBl $value)
    {
        return $this->set(self::_CHAT_ADD_BL, $value);
    }

    /**
     * Returns value of '_chat_add_bl' property
     *
     * @return Down_ChatAddBl
     */
    public function getChatAddBl()
    {
        return $this->get(self::_CHAT_ADD_BL);
    }

    /**
     * Sets value of '_chat_del_bl' property
     *
     * @param Down_ChatDelBl $value Property value
     *
     * @return null
     */
    public function setChatDelBl(Down_ChatDelBl $value)
    {
        return $this->set(self::_CHAT_DEL_BL, $value);
    }

    /**
     * Returns value of '_chat_del_bl' property
     *
     * @return Down_ChatDelBl
     */
    public function getChatDelBl()
    {
        return $this->get(self::_CHAT_DEL_BL);
    }

    /**
     * Sets value of '_chat_blacklist' property
     *
     * @param Down_ChatBlacklist $value Property value
     *
     * @return null
     */
    public function setChatBlacklist(Down_ChatBlacklist $value)
    {
        return $this->set(self::_CHAT_BLACKLIST, $value);
    }

    /**
     * Returns value of '_chat_blacklist' property
     *
     * @return Down_ChatBlacklist
     */
    public function getChatBlacklist()
    {
        return $this->get(self::_CHAT_BLACKLIST);
    }

    /**
     * Sets value of '_chat_borad_say' property
     *
     * @param Down_ChatBroadSay $value Property value
     *
     * @return null
     */
    public function setChatBoradSay(Down_ChatBroadSay $value)
    {
        return $this->set(self::_CHAT_BORAD_SAY, $value);
    }

    /**
     * Returns value of '_chat_borad_say' property
     *
     * @return Down_ChatBroadSay
     */
    public function getChatBoradSay()
    {
        return $this->get(self::_CHAT_BORAD_SAY);
    }
}

/**
 * chat_blacklist_user message
 */
class Down_ChatBlacklistUser extends \ProtobufMessage
{
    /* Field index constants */
    const _USERID = 1;
    const _USER_SUMMARY = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_USERID => array(
            'name' => '_userid',
            'required' => false,
            'type' => 5,
        ),
        self::_USER_SUMMARY => array(
            'name' => '_user_summary',
            'required' => false,
            'type' => 'Down_UserSummary'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_USERID] = null;
        $this->values[self::_USER_SUMMARY] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_userid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setUserid($value)
    {
        return $this->set(self::_USERID, $value);
    }

    /**
     * Returns value of '_userid' property
     *
     * @return int
     */
    public function getUserid()
    {
        return $this->get(self::_USERID);
    }

    /**
     * Sets value of '_user_summary' property
     *
     * @param Down_UserSummary $value Property value
     *
     * @return null
     */
    public function setUserSummary(Down_UserSummary $value)
    {
        return $this->set(self::_USER_SUMMARY, $value);
    }

    /**
     * Returns value of '_user_summary' property
     *
     * @return Down_UserSummary
     */
    public function getUserSummary()
    {
        return $this->get(self::_USER_SUMMARY);
    }
}

/**
 * chat_blacklist message
 */
class Down_ChatBlacklist extends \ProtobufMessage
{
    /* Field index constants */
    const _CHAT_BLACKLIST_USER = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_CHAT_BLACKLIST_USER => array(
            'name' => '_chat_blacklist_user',
            'repeated' => true,
            'type' => 'Down_ChatBlacklistUser'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_CHAT_BLACKLIST_USER] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_chat_blacklist_user' list
     *
     * @param Down_ChatBlacklistUser $value Value to append
     *
     * @return null
     */
    public function appendChatBlacklistUser(Down_ChatBlacklistUser $value)
    {
        return $this->append(self::_CHAT_BLACKLIST_USER, $value);
    }

    /**
     * Clears '_chat_blacklist_user' list
     *
     * @return null
     */
    public function clearChatBlacklistUser()
    {
        return $this->clear(self::_CHAT_BLACKLIST_USER);
    }

    /**
     * Returns '_chat_blacklist_user' list
     *
     * @return Down_ChatBlacklistUser[]
     */
    public function getChatBlacklistUser()
    {
        return $this->get(self::_CHAT_BLACKLIST_USER);
    }

    /**
     * Returns '_chat_blacklist_user' iterator
     *
     * @return ArrayIterator
     */
    public function getChatBlacklistUserIterator()
    {
        return new \ArrayIterator($this->get(self::_CHAT_BLACKLIST_USER));
    }

    /**
     * Returns element from '_chat_blacklist_user' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_ChatBlacklistUser
     */
    public function getChatBlacklistUserAt($offset)
    {
        return $this->get(self::_CHAT_BLACKLIST_USER, $offset);
    }

    /**
     * Returns count of '_chat_blacklist_user' list
     *
     * @return int
     */
    public function getChatBlacklistUserCount()
    {
        return $this->count(self::_CHAT_BLACKLIST_USER);
    }
}

/**
 * chat_broad_say message
 */
class Down_ChatBroadSay extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _CHANNEL = 2;
    const _CONTENTS = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => false,
            'type' => 5,
        ),
        self::_CHANNEL => array(
            'name' => '_channel',
            'required' => false,
            'type' => 5,
        ),
        self::_CONTENTS => array(
            'name' => '_contents',
            'repeated' => true,
            'type' => 'Down_ChatContent'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_CHANNEL] = null;
        $this->values[self::_CONTENTS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_channel' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setChannel($value)
    {
        return $this->set(self::_CHANNEL, $value);
    }

    /**
     * Returns value of '_channel' property
     *
     * @return int
     */
    public function getChannel()
    {
        return $this->get(self::_CHANNEL);
    }

    /**
     * Appends value to '_contents' list
     *
     * @param Down_ChatContent $value Value to append
     *
     * @return null
     */
    public function appendContents(Down_ChatContent $value)
    {
        return $this->append(self::_CONTENTS, $value);
    }

    /**
     * Clears '_contents' list
     *
     * @return null
     */
    public function clearContents()
    {
        return $this->clear(self::_CONTENTS);
    }

    /**
     * Returns '_contents' list
     *
     * @return Down_ChatContent[]
     */
    public function getContents()
    {
        return $this->get(self::_CONTENTS);
    }

    /**
     * Returns '_contents' iterator
     *
     * @return ArrayIterator
     */
    public function getContentsIterator()
    {
        return new \ArrayIterator($this->get(self::_CONTENTS));
    }

    /**
     * Returns element from '_contents' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_ChatContent
     */
    public function getContentsAt($offset)
    {
        return $this->get(self::_CONTENTS, $offset);
    }

    /**
     * Returns count of '_contents' list
     *
     * @return int
     */
    public function getContentsCount()
    {
        return $this->count(self::_CONTENTS);
    }
}

/**
 * chat_say message
 */
class Down_ChatSay extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _CHANNEL = 2;
    const _CONTENTS = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_Result::success, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_CHANNEL => array(
            'default' => Down_ChatChannel::world_channel, 
            'name' => '_channel',
            'required' => true,
            'type' => 5,
        ),
        self::_CONTENTS => array(
            'name' => '_contents',
            'repeated' => true,
            'type' => 'Down_ChatContent'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_CHANNEL] = null;
        $this->values[self::_CONTENTS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_channel' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setChannel($value)
    {
        return $this->set(self::_CHANNEL, $value);
    }

    /**
     * Returns value of '_channel' property
     *
     * @return int
     */
    public function getChannel()
    {
        return $this->get(self::_CHANNEL);
    }

    /**
     * Appends value to '_contents' list
     *
     * @param Down_ChatContent $value Value to append
     *
     * @return null
     */
    public function appendContents(Down_ChatContent $value)
    {
        return $this->append(self::_CONTENTS, $value);
    }

    /**
     * Clears '_contents' list
     *
     * @return null
     */
    public function clearContents()
    {
        return $this->clear(self::_CONTENTS);
    }

    /**
     * Returns '_contents' list
     *
     * @return Down_ChatContent[]
     */
    public function getContents()
    {
        return $this->get(self::_CONTENTS);
    }

    /**
     * Returns '_contents' iterator
     *
     * @return ArrayIterator
     */
    public function getContentsIterator()
    {
        return new \ArrayIterator($this->get(self::_CONTENTS));
    }

    /**
     * Returns element from '_contents' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_ChatContent
     */
    public function getContentsAt($offset)
    {
        return $this->get(self::_CONTENTS, $offset);
    }

    /**
     * Returns count of '_contents' list
     *
     * @return int
     */
    public function getContentsCount()
    {
        return $this->count(self::_CONTENTS);
    }
}

/**
 * chat_fresh message
 */
class Down_ChatFresh extends \ProtobufMessage
{
    /* Field index constants */
    const _CHANNEL = 1;
    const _CONTENTS = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_CHANNEL => array(
            'default' => Down_ChatChannel::world_channel, 
            'name' => '_channel',
            'required' => true,
            'type' => 5,
        ),
        self::_CONTENTS => array(
            'name' => '_contents',
            'repeated' => true,
            'type' => 'Down_ChatContent'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_CHANNEL] = null;
        $this->values[self::_CONTENTS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_channel' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setChannel($value)
    {
        return $this->set(self::_CHANNEL, $value);
    }

    /**
     * Returns value of '_channel' property
     *
     * @return int
     */
    public function getChannel()
    {
        return $this->get(self::_CHANNEL);
    }

    /**
     * Appends value to '_contents' list
     *
     * @param Down_ChatContent $value Value to append
     *
     * @return null
     */
    public function appendContents(Down_ChatContent $value)
    {
        return $this->append(self::_CONTENTS, $value);
    }

    /**
     * Clears '_contents' list
     *
     * @return null
     */
    public function clearContents()
    {
        return $this->clear(self::_CONTENTS);
    }

    /**
     * Returns '_contents' list
     *
     * @return Down_ChatContent[]
     */
    public function getContents()
    {
        return $this->get(self::_CONTENTS);
    }

    /**
     * Returns '_contents' iterator
     *
     * @return ArrayIterator
     */
    public function getContentsIterator()
    {
        return new \ArrayIterator($this->get(self::_CONTENTS));
    }

    /**
     * Returns element from '_contents' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_ChatContent
     */
    public function getContentsAt($offset)
    {
        return $this->get(self::_CONTENTS, $offset);
    }

    /**
     * Returns count of '_contents' list
     *
     * @return int
     */
    public function getContentsCount()
    {
        return $this->count(self::_CONTENTS);
    }
}

/**
 * chat_fetch message
 */
class Down_ChatFetch extends \ProtobufMessage
{
    /* Field index constants */
    const _CHANNEL = 1;
    const _CHAT_ID = 2;
    const _ACCESSORY = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_CHANNEL => array(
            'default' => Down_ChatChannel::world_channel, 
            'name' => '_channel',
            'required' => true,
            'type' => 5,
        ),
        self::_CHAT_ID => array(
            'name' => '_chat_id',
            'required' => true,
            'type' => 5,
        ),
        self::_ACCESSORY => array(
            'name' => '_accessory',
            'required' => false,
            'type' => 'Down_ChatAcc'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_CHANNEL] = null;
        $this->values[self::_CHAT_ID] = null;
        $this->values[self::_ACCESSORY] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_channel' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setChannel($value)
    {
        return $this->set(self::_CHANNEL, $value);
    }

    /**
     * Returns value of '_channel' property
     *
     * @return int
     */
    public function getChannel()
    {
        return $this->get(self::_CHANNEL);
    }

    /**
     * Sets value of '_chat_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setChatId($value)
    {
        return $this->set(self::_CHAT_ID, $value);
    }

    /**
     * Returns value of '_chat_id' property
     *
     * @return int
     */
    public function getChatId()
    {
        return $this->get(self::_CHAT_ID);
    }

    /**
     * Sets value of '_accessory' property
     *
     * @param Down_ChatAcc $value Property value
     *
     * @return null
     */
    public function setAccessory(Down_ChatAcc $value)
    {
        return $this->set(self::_ACCESSORY, $value);
    }

    /**
     * Returns value of '_accessory' property
     *
     * @return Down_ChatAcc
     */
    public function getAccessory()
    {
        return $this->get(self::_ACCESSORY);
    }
}

/**
 * chat_acc_t enum embedded in chat_acc message
 */
final class Down_ChatAcc_ChatAccT
{
    const binary = 1;
    const pvp_replay = 2;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'binary' => self::binary,
            'pvp_replay' => self::pvp_replay,
        );
    }
}

/**
 * chat_acc message
 */
class Down_ChatAcc extends \ProtobufMessage
{
    /* Field index constants */
    const _TYPE = 1;
    const _BINARY = 2;
    const _REPLAY = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TYPE => array(
            'default' => Down_ChatAcc_ChatAccT::binary, 
            'name' => '_type',
            'required' => true,
            'type' => 5,
        ),
        self::_BINARY => array(
            'name' => '_binary',
            'required' => false,
            'type' => 7,
        ),
        self::_REPLAY => array(
            'name' => '_replay',
            'required' => false,
            'type' => 'Down_PvpRecord'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_TYPE] = null;
        $this->values[self::_BINARY] = null;
        $this->values[self::_REPLAY] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_type' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setType($value)
    {
        return $this->set(self::_TYPE, $value);
    }

    /**
     * Returns value of '_type' property
     *
     * @return int
     */
    public function getType()
    {
        return $this->get(self::_TYPE);
    }

    /**
     * Sets value of '_binary' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setBinary($value)
    {
        return $this->set(self::_BINARY, $value);
    }

    /**
     * Returns value of '_binary' property
     *
     * @return string
     */
    public function getBinary()
    {
        return $this->get(self::_BINARY);
    }

    /**
     * Sets value of '_replay' property
     *
     * @param Down_PvpRecord $value Property value
     *
     * @return null
     */
    public function setReplay(Down_PvpRecord $value)
    {
        return $this->set(self::_REPLAY, $value);
    }

    /**
     * Returns value of '_replay' property
     *
     * @return Down_PvpRecord
     */
    public function getReplay()
    {
        return $this->get(self::_REPLAY);
    }
}

/**
 * chat_content message
 */
class Down_ChatContent extends \ProtobufMessage
{
    /* Field index constants */
    const _CHAT_ID = 1;
    const _SPEAKER_UID = 2;
    const _SPEAKER_SUMMARY = 3;
    const _TARGET_UID = 4;
    const _TARGET_SUMMARY = 5;
    const _SPEAKER_POST = 6;
    const _SPEAK_TIME = 7;
    const _CONTENT_TYPE = 8;
    const _CONTENT = 9;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_CHAT_ID => array(
            'name' => '_chat_id',
            'required' => true,
            'type' => 5,
        ),
        self::_SPEAKER_UID => array(
            'name' => '_speaker_uid',
            'required' => true,
            'type' => 5,
        ),
        self::_SPEAKER_SUMMARY => array(
            'name' => '_speaker_summary',
            'required' => true,
            'type' => 'Down_UserSummary'
        ),
        self::_TARGET_UID => array(
            'name' => '_target_uid',
            'required' => false,
            'type' => 5,
        ),
        self::_TARGET_SUMMARY => array(
            'name' => '_target_summary',
            'required' => false,
            'type' => 'Down_UserSummary'
        ),
        self::_SPEAKER_POST => array(
            'name' => '_speaker_post',
            'required' => false,
            'type' => 5,
        ),
        self::_SPEAK_TIME => array(
            'name' => '_speak_time',
            'required' => true,
            'type' => 5,
        ),
        self::_CONTENT_TYPE => array(
            'name' => '_content_type',
            'required' => true,
            'type' => 5,
        ),
        self::_CONTENT => array(
            'name' => '_content',
            'required' => true,
            'type' => 7,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_CHAT_ID] = null;
        $this->values[self::_SPEAKER_UID] = null;
        $this->values[self::_SPEAKER_SUMMARY] = null;
        $this->values[self::_TARGET_UID] = null;
        $this->values[self::_TARGET_SUMMARY] = null;
        $this->values[self::_SPEAKER_POST] = null;
        $this->values[self::_SPEAK_TIME] = null;
        $this->values[self::_CONTENT_TYPE] = null;
        $this->values[self::_CONTENT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_chat_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setChatId($value)
    {
        return $this->set(self::_CHAT_ID, $value);
    }

    /**
     * Returns value of '_chat_id' property
     *
     * @return int
     */
    public function getChatId()
    {
        return $this->get(self::_CHAT_ID);
    }

    /**
     * Sets value of '_speaker_uid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSpeakerUid($value)
    {
        return $this->set(self::_SPEAKER_UID, $value);
    }

    /**
     * Returns value of '_speaker_uid' property
     *
     * @return int
     */
    public function getSpeakerUid()
    {
        return $this->get(self::_SPEAKER_UID);
    }

    /**
     * Sets value of '_speaker_summary' property
     *
     * @param Down_UserSummary $value Property value
     *
     * @return null
     */
    public function setSpeakerSummary(Down_UserSummary $value)
    {
        return $this->set(self::_SPEAKER_SUMMARY, $value);
    }

    /**
     * Returns value of '_speaker_summary' property
     *
     * @return Down_UserSummary
     */
    public function getSpeakerSummary()
    {
        return $this->get(self::_SPEAKER_SUMMARY);
    }

    /**
     * Sets value of '_target_uid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setTargetUid($value)
    {
        return $this->set(self::_TARGET_UID, $value);
    }

    /**
     * Returns value of '_target_uid' property
     *
     * @return int
     */
    public function getTargetUid()
    {
        return $this->get(self::_TARGET_UID);
    }

    /**
     * Sets value of '_target_summary' property
     *
     * @param Down_UserSummary $value Property value
     *
     * @return null
     */
    public function setTargetSummary(Down_UserSummary $value)
    {
        return $this->set(self::_TARGET_SUMMARY, $value);
    }

    /**
     * Returns value of '_target_summary' property
     *
     * @return Down_UserSummary
     */
    public function getTargetSummary()
    {
        return $this->get(self::_TARGET_SUMMARY);
    }

    /**
     * Sets value of '_speaker_post' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSpeakerPost($value)
    {
        return $this->set(self::_SPEAKER_POST, $value);
    }

    /**
     * Returns value of '_speaker_post' property
     *
     * @return int
     */
    public function getSpeakerPost()
    {
        return $this->get(self::_SPEAKER_POST);
    }

    /**
     * Sets value of '_speak_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSpeakTime($value)
    {
        return $this->set(self::_SPEAK_TIME, $value);
    }

    /**
     * Returns value of '_speak_time' property
     *
     * @return int
     */
    public function getSpeakTime()
    {
        return $this->get(self::_SPEAK_TIME);
    }

    /**
     * Sets value of '_content_type' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setContentType($value)
    {
        return $this->set(self::_CONTENT_TYPE, $value);
    }

    /**
     * Returns value of '_content_type' property
     *
     * @return int
     */
    public function getContentType()
    {
        return $this->get(self::_CONTENT_TYPE);
    }

    /**
     * Sets value of '_content' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setContent($value)
    {
        return $this->set(self::_CONTENT, $value);
    }

    /**
     * Returns value of '_content' property
     *
     * @return string
     */
    public function getContent()
    {
        return $this->get(self::_CONTENT);
    }
}

/**
 * chat_add_bl message
 */
class Down_ChatAddBl extends \ProtobufMessage
{
    /* Field index constants */
    const _RET = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RET => array(
            'name' => '_ret',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RET] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_ret' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRet($value)
    {
        return $this->set(self::_RET, $value);
    }

    /**
     * Returns value of '_ret' property
     *
     * @return int
     */
    public function getRet()
    {
        return $this->get(self::_RET);
    }
}

/**
 * chat_del_bl message
 */
class Down_ChatDelBl extends \ProtobufMessage
{
    /* Field index constants */
    const _RET = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RET => array(
            'name' => '_ret',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RET] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_ret' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRet($value)
    {
        return $this->set(self::_RET, $value);
    }

    /**
     * Returns value of '_ret' property
     *
     * @return int
     */
    public function getRet()
    {
        return $this->get(self::_RET);
    }
}

/**
 * chat message
 */
class Down_Chat extends \ProtobufMessage
{
    /* Field index constants */
    const _WORLD_CHAT_TIMES = 1;
    const _LAST_RESET_WORLD_CHAT_TIME = 2;
    const _BLACK_LIST = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_WORLD_CHAT_TIMES => array(
            'name' => '_world_chat_times',
            'required' => true,
            'type' => 5,
        ),
        self::_LAST_RESET_WORLD_CHAT_TIME => array(
            'name' => '_last_reset_world_chat_time',
            'required' => true,
            'type' => 5,
        ),
        self::_BLACK_LIST => array(
            'name' => '_black_list',
            'repeated' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_WORLD_CHAT_TIMES] = null;
        $this->values[self::_LAST_RESET_WORLD_CHAT_TIME] = null;
        $this->values[self::_BLACK_LIST] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_world_chat_times' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setWorldChatTimes($value)
    {
        return $this->set(self::_WORLD_CHAT_TIMES, $value);
    }

    /**
     * Returns value of '_world_chat_times' property
     *
     * @return int
     */
    public function getWorldChatTimes()
    {
        return $this->get(self::_WORLD_CHAT_TIMES);
    }

    /**
     * Sets value of '_last_reset_world_chat_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLastResetWorldChatTime($value)
    {
        return $this->set(self::_LAST_RESET_WORLD_CHAT_TIME, $value);
    }

    /**
     * Returns value of '_last_reset_world_chat_time' property
     *
     * @return int
     */
    public function getLastResetWorldChatTime()
    {
        return $this->get(self::_LAST_RESET_WORLD_CHAT_TIME);
    }

    /**
     * Appends value to '_black_list' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendBlackList($value)
    {
        return $this->append(self::_BLACK_LIST, $value);
    }

    /**
     * Clears '_black_list' list
     *
     * @return null
     */
    public function clearBlackList()
    {
        return $this->clear(self::_BLACK_LIST);
    }

    /**
     * Returns '_black_list' list
     *
     * @return int[]
     */
    public function getBlackList()
    {
        return $this->get(self::_BLACK_LIST);
    }

    /**
     * Returns '_black_list' iterator
     *
     * @return ArrayIterator
     */
    public function getBlackListIterator()
    {
        return new \ArrayIterator($this->get(self::_BLACK_LIST));
    }

    /**
     * Returns element from '_black_list' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getBlackListAt($offset)
    {
        return $this->get(self::_BLACK_LIST, $offset);
    }

    /**
     * Returns count of '_black_list' list
     *
     * @return int
     */
    public function getBlackListCount()
    {
        return $this->count(self::_BLACK_LIST);
    }
}

/**
 * user_guild message
 */
class Down_UserGuild extends \ProtobufMessage
{
    /* Field index constants */
    const _ID = 1;
    const _NAME = 2;
    const _JOB = 3;
    const _REQ_GUILD_ID = 4;
    const _HIRE_HERO = 5;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ID => array(
            'name' => '_id',
            'required' => true,
            'type' => 5,
        ),
        self::_NAME => array(
            'name' => '_name',
            'required' => true,
            'type' => 7,
        ),
        self::_JOB => array(
            'default' => Down_GuildJobT::member, 
            'name' => '_job',
            'required' => false,
            'type' => 5,
        ),
        self::_REQ_GUILD_ID => array(
            'name' => '_req_guild_id',
            'required' => false,
            'type' => 5,
        ),
        self::_HIRE_HERO => array(
            'name' => '_hire_hero',
            'repeated' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ID] = null;
        $this->values[self::_NAME] = null;
        $this->values[self::_JOB] = Down_GuildJobT::member;
        $this->values[self::_REQ_GUILD_ID] = null;
        $this->values[self::_HIRE_HERO] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setId($value)
    {
        return $this->set(self::_ID, $value);
    }

    /**
     * Returns value of '_id' property
     *
     * @return int
     */
    public function getId()
    {
        return $this->get(self::_ID);
    }

    /**
     * Sets value of '_name' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setName($value)
    {
        return $this->set(self::_NAME, $value);
    }

    /**
     * Returns value of '_name' property
     *
     * @return string
     */
    public function getName()
    {
        return $this->get(self::_NAME);
    }

    /**
     * Sets value of '_job' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setJob($value)
    {
        return $this->set(self::_JOB, $value);
    }

    /**
     * Returns value of '_job' property
     *
     * @return int
     */
    public function getJob()
    {
        return $this->get(self::_JOB);
    }

    /**
     * Sets value of '_req_guild_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setReqGuildId($value)
    {
        return $this->set(self::_REQ_GUILD_ID, $value);
    }

    /**
     * Returns value of '_req_guild_id' property
     *
     * @return int
     */
    public function getReqGuildId()
    {
        return $this->get(self::_REQ_GUILD_ID);
    }

    /**
     * Appends value to '_hire_hero' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendHireHero($value)
    {
        return $this->append(self::_HIRE_HERO, $value);
    }

    /**
     * Clears '_hire_hero' list
     *
     * @return null
     */
    public function clearHireHero()
    {
        return $this->clear(self::_HIRE_HERO);
    }

    /**
     * Returns '_hire_hero' list
     *
     * @return int[]
     */
    public function getHireHero()
    {
        return $this->get(self::_HIRE_HERO);
    }

    /**
     * Returns '_hire_hero' iterator
     *
     * @return ArrayIterator
     */
    public function getHireHeroIterator()
    {
        return new \ArrayIterator($this->get(self::_HIRE_HERO));
    }

    /**
     * Returns element from '_hire_hero' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getHireHeroAt($offset)
    {
        return $this->get(self::_HIRE_HERO, $offset);
    }

    /**
     * Returns count of '_hire_hero' list
     *
     * @return int
     */
    public function getHireHeroCount()
    {
        return $this->count(self::_HIRE_HERO);
    }
}

/**
 * guild_reply message
 */
class Down_GuildReply extends \ProtobufMessage
{
    /* Field index constants */
    const _CREATE = 1;
    const _DISMISS = 2;
    const _LIST = 3;
    const _SEARCH = 4;
    const _JOIN = 5;
    const _JOIN_CONFIRM = 6;
    const _LEAVE = 7;
    const _KICK = 8;
    const _SET = 9;
    const _QUERY = 10;
    const _SET_JOB = 11;
    const _ADD_HIRE = 12;
    const _DEL_HIRE = 13;
    const _QUERY_HIRES = 14;
    const _HIRE_HERO = 15;
    const _WORSHIP_REQ = 16;
    const _WORSHIP_WITHDRAW = 17;
    const _QUERY_HH_DETAIL = 18;
    const _RESULT = 19;
    const _INSTANCE_QUERY = 20;
    const _INSTANCE_DETAIL = 21;
    const _INSTANCE_START = 22;
    const _INSTANCE_END = 23;
    const _INSTANCE_DROP = 24;
    const _INSTANCE_OPEN = 25;
    const _INSTANCE_APPLY = 26;
    const _DROP_INFO = 27;
    const _DROP_GIVE = 28;
    const _INSTANCE_DAMAGE = 29;
    const _ITEMS_HISTORY = 30;
    const _GUILD_JUMP = 31;
    const _GUILD_APP_QUEUE = 32;
    const _INSTANCE_PREPARE = 33;
    const _GUILD_MEMBERS = 34;
    const _GUILD_STAGE_RANK = 35;
    const _SET_JUMP = 36;
    const _SEND_MAIL_REPLY = 37;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_CREATE => array(
            'name' => '_create',
            'required' => false,
            'type' => 'Down_GuildCreate'
        ),
        self::_DISMISS => array(
            'name' => '_dismiss',
            'required' => false,
            'type' => 'Down_GuildDismiss'
        ),
        self::_LIST => array(
            'name' => '_list',
            'required' => false,
            'type' => 'Down_GuildList'
        ),
        self::_SEARCH => array(
            'name' => '_search',
            'required' => false,
            'type' => 'Down_GuildSearch'
        ),
        self::_JOIN => array(
            'name' => '_join',
            'required' => false,
            'type' => 'Down_GuildJoin'
        ),
        self::_JOIN_CONFIRM => array(
            'name' => '_join_confirm',
            'required' => false,
            'type' => 'Down_GuildJoinConfirm'
        ),
        self::_LEAVE => array(
            'name' => '_leave',
            'required' => false,
            'type' => 'Down_GuildLeave'
        ),
        self::_KICK => array(
            'name' => '_kick',
            'required' => false,
            'type' => 'Down_GuildKick'
        ),
        self::_SET => array(
            'name' => '_set',
            'required' => false,
            'type' => 'Down_GuildSet'
        ),
        self::_QUERY => array(
            'name' => '_query',
            'required' => false,
            'type' => 'Down_GuildQuery'
        ),
        self::_SET_JOB => array(
            'name' => '_set_job',
            'required' => false,
            'type' => 'Down_GuildSetJob'
        ),
        self::_ADD_HIRE => array(
            'name' => '_add_hire',
            'required' => false,
            'type' => 'Down_GuildAddHire'
        ),
        self::_DEL_HIRE => array(
            'name' => '_del_hire',
            'required' => false,
            'type' => 'Down_GuildDelHire'
        ),
        self::_QUERY_HIRES => array(
            'name' => '_query_hires',
            'required' => false,
            'type' => 'Down_GuildQueryHires'
        ),
        self::_HIRE_HERO => array(
            'name' => '_hire_hero',
            'required' => false,
            'type' => 'Down_GuildHireHero'
        ),
        self::_WORSHIP_REQ => array(
            'name' => '_worship_req',
            'required' => false,
            'type' => 'Down_GuildWorshipReq'
        ),
        self::_WORSHIP_WITHDRAW => array(
            'name' => '_worship_withdraw',
            'required' => false,
            'type' => 'Down_GuildWorshipWithdraw'
        ),
        self::_QUERY_HH_DETAIL => array(
            'name' => '_query_hh_detail',
            'required' => false,
            'type' => 'Down_GuildQureyHhDetail'
        ),
        self::_RESULT => array(
            'default' => Down_Result::success, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_INSTANCE_QUERY => array(
            'name' => '_instance_query',
            'required' => false,
            'type' => 'Down_GuildInstanceQuery'
        ),
        self::_INSTANCE_DETAIL => array(
            'name' => '_instance_detail',
            'required' => false,
            'type' => 'Down_GuildInstanceDetail'
        ),
        self::_INSTANCE_START => array(
            'name' => '_instance_start',
            'required' => false,
            'type' => 'Down_GuildInstanceStart'
        ),
        self::_INSTANCE_END => array(
            'name' => '_instance_end',
            'required' => false,
            'type' => 'Down_GuildInstanceEndDown'
        ),
        self::_INSTANCE_DROP => array(
            'name' => '_instance_drop',
            'required' => false,
            'type' => 'Down_GuildInstanceDrop'
        ),
        self::_INSTANCE_OPEN => array(
            'name' => '_instance_open',
            'required' => false,
            'type' => 'Down_GuildInstanceOpen'
        ),
        self::_INSTANCE_APPLY => array(
            'name' => '_instance_apply',
            'required' => false,
            'type' => 'Down_GuildInstanceApply'
        ),
        self::_DROP_INFO => array(
            'name' => '_drop_info',
            'required' => false,
            'type' => 'Down_GuildDropInfo'
        ),
        self::_DROP_GIVE => array(
            'name' => '_drop_give',
            'required' => false,
            'type' => 'Down_GuildDropGive'
        ),
        self::_INSTANCE_DAMAGE => array(
            'name' => '_instance_damage',
            'required' => false,
            'type' => 'Down_GuildInstanceDamage'
        ),
        self::_ITEMS_HISTORY => array(
            'name' => '_items_history',
            'required' => false,
            'type' => 'Down_GuildItemsHistory'
        ),
        self::_GUILD_JUMP => array(
            'name' => '_guild_jump',
            'required' => false,
            'type' => 'Down_GuildJump'
        ),
        self::_GUILD_APP_QUEUE => array(
            'name' => '_guild_app_queue',
            'required' => false,
            'type' => 'Down_GuildAppQueue'
        ),
        self::_INSTANCE_PREPARE => array(
            'name' => '_instance_prepare',
            'required' => false,
            'type' => 'Down_GuildInstancePrepare'
        ),
        self::_GUILD_MEMBERS => array(
            'name' => '_guild_members',
            'required' => false,
            'type' => 'Down_GuildMembers'
        ),
        self::_GUILD_STAGE_RANK => array(
            'name' => '_guild_stage_rank',
            'required' => false,
            'type' => 'Down_GuildStageRank'
        ),
        self::_SET_JUMP => array(
            'name' => '_set_jump',
            'required' => false,
            'type' => 'Down_GuildSetJump'
        ),
        self::_SEND_MAIL_REPLY => array(
            'name' => '_send_mail_reply',
            'required' => false,
            'type' => 'Down_GuildSendMail'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_CREATE] = null;
        $this->values[self::_DISMISS] = null;
        $this->values[self::_LIST] = null;
        $this->values[self::_SEARCH] = null;
        $this->values[self::_JOIN] = null;
        $this->values[self::_JOIN_CONFIRM] = null;
        $this->values[self::_LEAVE] = null;
        $this->values[self::_KICK] = null;
        $this->values[self::_SET] = null;
        $this->values[self::_QUERY] = null;
        $this->values[self::_SET_JOB] = null;
        $this->values[self::_ADD_HIRE] = null;
        $this->values[self::_DEL_HIRE] = null;
        $this->values[self::_QUERY_HIRES] = null;
        $this->values[self::_HIRE_HERO] = null;
        $this->values[self::_WORSHIP_REQ] = null;
        $this->values[self::_WORSHIP_WITHDRAW] = null;
        $this->values[self::_QUERY_HH_DETAIL] = null;
        $this->values[self::_RESULT] = null;
        $this->values[self::_INSTANCE_QUERY] = null;
        $this->values[self::_INSTANCE_DETAIL] = null;
        $this->values[self::_INSTANCE_START] = null;
        $this->values[self::_INSTANCE_END] = null;
        $this->values[self::_INSTANCE_DROP] = null;
        $this->values[self::_INSTANCE_OPEN] = null;
        $this->values[self::_INSTANCE_APPLY] = null;
        $this->values[self::_DROP_INFO] = null;
        $this->values[self::_DROP_GIVE] = null;
        $this->values[self::_INSTANCE_DAMAGE] = null;
        $this->values[self::_ITEMS_HISTORY] = null;
        $this->values[self::_GUILD_JUMP] = null;
        $this->values[self::_GUILD_APP_QUEUE] = null;
        $this->values[self::_INSTANCE_PREPARE] = null;
        $this->values[self::_GUILD_MEMBERS] = null;
        $this->values[self::_GUILD_STAGE_RANK] = null;
        $this->values[self::_SET_JUMP] = null;
        $this->values[self::_SEND_MAIL_REPLY] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_create' property
     *
     * @param Down_GuildCreate $value Property value
     *
     * @return null
     */
    public function setCreate(Down_GuildCreate $value)
    {
        return $this->set(self::_CREATE, $value);
    }

    /**
     * Returns value of '_create' property
     *
     * @return Down_GuildCreate
     */
    public function getCreate()
    {
        return $this->get(self::_CREATE);
    }

    /**
     * Sets value of '_dismiss' property
     *
     * @param Down_GuildDismiss $value Property value
     *
     * @return null
     */
    public function setDismiss(Down_GuildDismiss $value)
    {
        return $this->set(self::_DISMISS, $value);
    }

    /**
     * Returns value of '_dismiss' property
     *
     * @return Down_GuildDismiss
     */
    public function getDismiss()
    {
        return $this->get(self::_DISMISS);
    }

    /**
     * Sets value of '_list' property
     *
     * @param Down_GuildList $value Property value
     *
     * @return null
     */
    public function setList(Down_GuildList $value)
    {
        return $this->set(self::_LIST, $value);
    }

    /**
     * Returns value of '_list' property
     *
     * @return Down_GuildList
     */
    public function getList()
    {
        return $this->get(self::_LIST);
    }

    /**
     * Sets value of '_search' property
     *
     * @param Down_GuildSearch $value Property value
     *
     * @return null
     */
    public function setSearch(Down_GuildSearch $value)
    {
        return $this->set(self::_SEARCH, $value);
    }

    /**
     * Returns value of '_search' property
     *
     * @return Down_GuildSearch
     */
    public function getSearch()
    {
        return $this->get(self::_SEARCH);
    }

    /**
     * Sets value of '_join' property
     *
     * @param Down_GuildJoin $value Property value
     *
     * @return null
     */
    public function setJoin(Down_GuildJoin $value)
    {
        return $this->set(self::_JOIN, $value);
    }

    /**
     * Returns value of '_join' property
     *
     * @return Down_GuildJoin
     */
    public function getJoin()
    {
        return $this->get(self::_JOIN);
    }

    /**
     * Sets value of '_join_confirm' property
     *
     * @param Down_GuildJoinConfirm $value Property value
     *
     * @return null
     */
    public function setJoinConfirm(Down_GuildJoinConfirm $value)
    {
        return $this->set(self::_JOIN_CONFIRM, $value);
    }

    /**
     * Returns value of '_join_confirm' property
     *
     * @return Down_GuildJoinConfirm
     */
    public function getJoinConfirm()
    {
        return $this->get(self::_JOIN_CONFIRM);
    }

    /**
     * Sets value of '_leave' property
     *
     * @param Down_GuildLeave $value Property value
     *
     * @return null
     */
    public function setLeave(Down_GuildLeave $value)
    {
        return $this->set(self::_LEAVE, $value);
    }

    /**
     * Returns value of '_leave' property
     *
     * @return Down_GuildLeave
     */
    public function getLeave()
    {
        return $this->get(self::_LEAVE);
    }

    /**
     * Sets value of '_kick' property
     *
     * @param Down_GuildKick $value Property value
     *
     * @return null
     */
    public function setKick(Down_GuildKick $value)
    {
        return $this->set(self::_KICK, $value);
    }

    /**
     * Returns value of '_kick' property
     *
     * @return Down_GuildKick
     */
    public function getKick()
    {
        return $this->get(self::_KICK);
    }

    /**
     * Sets value of '_set' property
     *
     * @param Down_GuildSet $value Property value
     *
     * @return null
     */
    public function setSet(Down_GuildSet $value)
    {
        return $this->set(self::_SET, $value);
    }

    /**
     * Returns value of '_set' property
     *
     * @return Down_GuildSet
     */
    public function getSet()
    {
        return $this->get(self::_SET);
    }

    /**
     * Sets value of '_query' property
     *
     * @param Down_GuildQuery $value Property value
     *
     * @return null
     */
    public function setQuery(Down_GuildQuery $value)
    {
        return $this->set(self::_QUERY, $value);
    }

    /**
     * Returns value of '_query' property
     *
     * @return Down_GuildQuery
     */
    public function getQuery()
    {
        return $this->get(self::_QUERY);
    }

    /**
     * Sets value of '_set_job' property
     *
     * @param Down_GuildSetJob $value Property value
     *
     * @return null
     */
    public function setSetJob(Down_GuildSetJob $value)
    {
        return $this->set(self::_SET_JOB, $value);
    }

    /**
     * Returns value of '_set_job' property
     *
     * @return Down_GuildSetJob
     */
    public function getSetJob()
    {
        return $this->get(self::_SET_JOB);
    }

    /**
     * Sets value of '_add_hire' property
     *
     * @param Down_GuildAddHire $value Property value
     *
     * @return null
     */
    public function setAddHire(Down_GuildAddHire $value)
    {
        return $this->set(self::_ADD_HIRE, $value);
    }

    /**
     * Returns value of '_add_hire' property
     *
     * @return Down_GuildAddHire
     */
    public function getAddHire()
    {
        return $this->get(self::_ADD_HIRE);
    }

    /**
     * Sets value of '_del_hire' property
     *
     * @param Down_GuildDelHire $value Property value
     *
     * @return null
     */
    public function setDelHire(Down_GuildDelHire $value)
    {
        return $this->set(self::_DEL_HIRE, $value);
    }

    /**
     * Returns value of '_del_hire' property
     *
     * @return Down_GuildDelHire
     */
    public function getDelHire()
    {
        return $this->get(self::_DEL_HIRE);
    }

    /**
     * Sets value of '_query_hires' property
     *
     * @param Down_GuildQueryHires $value Property value
     *
     * @return null
     */
    public function setQueryHires(Down_GuildQueryHires $value)
    {
        return $this->set(self::_QUERY_HIRES, $value);
    }

    /**
     * Returns value of '_query_hires' property
     *
     * @return Down_GuildQueryHires
     */
    public function getQueryHires()
    {
        return $this->get(self::_QUERY_HIRES);
    }

    /**
     * Sets value of '_hire_hero' property
     *
     * @param Down_GuildHireHero $value Property value
     *
     * @return null
     */
    public function setHireHero(Down_GuildHireHero $value)
    {
        return $this->set(self::_HIRE_HERO, $value);
    }

    /**
     * Returns value of '_hire_hero' property
     *
     * @return Down_GuildHireHero
     */
    public function getHireHero()
    {
        return $this->get(self::_HIRE_HERO);
    }

    /**
     * Sets value of '_worship_req' property
     *
     * @param Down_GuildWorshipReq $value Property value
     *
     * @return null
     */
    public function setWorshipReq(Down_GuildWorshipReq $value)
    {
        return $this->set(self::_WORSHIP_REQ, $value);
    }

    /**
     * Returns value of '_worship_req' property
     *
     * @return Down_GuildWorshipReq
     */
    public function getWorshipReq()
    {
        return $this->get(self::_WORSHIP_REQ);
    }

    /**
     * Sets value of '_worship_withdraw' property
     *
     * @param Down_GuildWorshipWithdraw $value Property value
     *
     * @return null
     */
    public function setWorshipWithdraw(Down_GuildWorshipWithdraw $value)
    {
        return $this->set(self::_WORSHIP_WITHDRAW, $value);
    }

    /**
     * Returns value of '_worship_withdraw' property
     *
     * @return Down_GuildWorshipWithdraw
     */
    public function getWorshipWithdraw()
    {
        return $this->get(self::_WORSHIP_WITHDRAW);
    }

    /**
     * Sets value of '_query_hh_detail' property
     *
     * @param Down_GuildQureyHhDetail $value Property value
     *
     * @return null
     */
    public function setQueryHhDetail(Down_GuildQureyHhDetail $value)
    {
        return $this->set(self::_QUERY_HH_DETAIL, $value);
    }

    /**
     * Returns value of '_query_hh_detail' property
     *
     * @return Down_GuildQureyHhDetail
     */
    public function getQueryHhDetail()
    {
        return $this->get(self::_QUERY_HH_DETAIL);
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_instance_query' property
     *
     * @param Down_GuildInstanceQuery $value Property value
     *
     * @return null
     */
    public function setInstanceQuery(Down_GuildInstanceQuery $value)
    {
        return $this->set(self::_INSTANCE_QUERY, $value);
    }

    /**
     * Returns value of '_instance_query' property
     *
     * @return Down_GuildInstanceQuery
     */
    public function getInstanceQuery()
    {
        return $this->get(self::_INSTANCE_QUERY);
    }

    /**
     * Sets value of '_instance_detail' property
     *
     * @param Down_GuildInstanceDetail $value Property value
     *
     * @return null
     */
    public function setInstanceDetail(Down_GuildInstanceDetail $value)
    {
        return $this->set(self::_INSTANCE_DETAIL, $value);
    }

    /**
     * Returns value of '_instance_detail' property
     *
     * @return Down_GuildInstanceDetail
     */
    public function getInstanceDetail()
    {
        return $this->get(self::_INSTANCE_DETAIL);
    }

    /**
     * Sets value of '_instance_start' property
     *
     * @param Down_GuildInstanceStart $value Property value
     *
     * @return null
     */
    public function setInstanceStart(Down_GuildInstanceStart $value)
    {
        return $this->set(self::_INSTANCE_START, $value);
    }

    /**
     * Returns value of '_instance_start' property
     *
     * @return Down_GuildInstanceStart
     */
    public function getInstanceStart()
    {
        return $this->get(self::_INSTANCE_START);
    }

    /**
     * Sets value of '_instance_end' property
     *
     * @param Down_GuildInstanceEndDown $value Property value
     *
     * @return null
     */
    public function setInstanceEnd(Down_GuildInstanceEndDown $value)
    {
        return $this->set(self::_INSTANCE_END, $value);
    }

    /**
     * Returns value of '_instance_end' property
     *
     * @return Down_GuildInstanceEndDown
     */
    public function getInstanceEnd()
    {
        return $this->get(self::_INSTANCE_END);
    }

    /**
     * Sets value of '_instance_drop' property
     *
     * @param Down_GuildInstanceDrop $value Property value
     *
     * @return null
     */
    public function setInstanceDrop(Down_GuildInstanceDrop $value)
    {
        return $this->set(self::_INSTANCE_DROP, $value);
    }

    /**
     * Returns value of '_instance_drop' property
     *
     * @return Down_GuildInstanceDrop
     */
    public function getInstanceDrop()
    {
        return $this->get(self::_INSTANCE_DROP);
    }

    /**
     * Sets value of '_instance_open' property
     *
     * @param Down_GuildInstanceOpen $value Property value
     *
     * @return null
     */
    public function setInstanceOpen(Down_GuildInstanceOpen $value)
    {
        return $this->set(self::_INSTANCE_OPEN, $value);
    }

    /**
     * Returns value of '_instance_open' property
     *
     * @return Down_GuildInstanceOpen
     */
    public function getInstanceOpen()
    {
        return $this->get(self::_INSTANCE_OPEN);
    }

    /**
     * Sets value of '_instance_apply' property
     *
     * @param Down_GuildInstanceApply $value Property value
     *
     * @return null
     */
    public function setInstanceApply(Down_GuildInstanceApply $value)
    {
        return $this->set(self::_INSTANCE_APPLY, $value);
    }

    /**
     * Returns value of '_instance_apply' property
     *
     * @return Down_GuildInstanceApply
     */
    public function getInstanceApply()
    {
        return $this->get(self::_INSTANCE_APPLY);
    }

    /**
     * Sets value of '_drop_info' property
     *
     * @param Down_GuildDropInfo $value Property value
     *
     * @return null
     */
    public function setDropInfo(Down_GuildDropInfo $value)
    {
        return $this->set(self::_DROP_INFO, $value);
    }

    /**
     * Returns value of '_drop_info' property
     *
     * @return Down_GuildDropInfo
     */
    public function getDropInfo()
    {
        return $this->get(self::_DROP_INFO);
    }

    /**
     * Sets value of '_drop_give' property
     *
     * @param Down_GuildDropGive $value Property value
     *
     * @return null
     */
    public function setDropGive(Down_GuildDropGive $value)
    {
        return $this->set(self::_DROP_GIVE, $value);
    }

    /**
     * Returns value of '_drop_give' property
     *
     * @return Down_GuildDropGive
     */
    public function getDropGive()
    {
        return $this->get(self::_DROP_GIVE);
    }

    /**
     * Sets value of '_instance_damage' property
     *
     * @param Down_GuildInstanceDamage $value Property value
     *
     * @return null
     */
    public function setInstanceDamage(Down_GuildInstanceDamage $value)
    {
        return $this->set(self::_INSTANCE_DAMAGE, $value);
    }

    /**
     * Returns value of '_instance_damage' property
     *
     * @return Down_GuildInstanceDamage
     */
    public function getInstanceDamage()
    {
        return $this->get(self::_INSTANCE_DAMAGE);
    }

    /**
     * Sets value of '_items_history' property
     *
     * @param Down_GuildItemsHistory $value Property value
     *
     * @return null
     */
    public function setItemsHistory(Down_GuildItemsHistory $value)
    {
        return $this->set(self::_ITEMS_HISTORY, $value);
    }

    /**
     * Returns value of '_items_history' property
     *
     * @return Down_GuildItemsHistory
     */
    public function getItemsHistory()
    {
        return $this->get(self::_ITEMS_HISTORY);
    }

    /**
     * Sets value of '_guild_jump' property
     *
     * @param Down_GuildJump $value Property value
     *
     * @return null
     */
    public function setGuildJump(Down_GuildJump $value)
    {
        return $this->set(self::_GUILD_JUMP, $value);
    }

    /**
     * Returns value of '_guild_jump' property
     *
     * @return Down_GuildJump
     */
    public function getGuildJump()
    {
        return $this->get(self::_GUILD_JUMP);
    }

    /**
     * Sets value of '_guild_app_queue' property
     *
     * @param Down_GuildAppQueue $value Property value
     *
     * @return null
     */
    public function setGuildAppQueue(Down_GuildAppQueue $value)
    {
        return $this->set(self::_GUILD_APP_QUEUE, $value);
    }

    /**
     * Returns value of '_guild_app_queue' property
     *
     * @return Down_GuildAppQueue
     */
    public function getGuildAppQueue()
    {
        return $this->get(self::_GUILD_APP_QUEUE);
    }

    /**
     * Sets value of '_instance_prepare' property
     *
     * @param Down_GuildInstancePrepare $value Property value
     *
     * @return null
     */
    public function setInstancePrepare(Down_GuildInstancePrepare $value)
    {
        return $this->set(self::_INSTANCE_PREPARE, $value);
    }

    /**
     * Returns value of '_instance_prepare' property
     *
     * @return Down_GuildInstancePrepare
     */
    public function getInstancePrepare()
    {
        return $this->get(self::_INSTANCE_PREPARE);
    }

    /**
     * Sets value of '_guild_members' property
     *
     * @param Down_GuildMembers $value Property value
     *
     * @return null
     */
    public function setGuildMembers(Down_GuildMembers $value)
    {
        return $this->set(self::_GUILD_MEMBERS, $value);
    }

    /**
     * Returns value of '_guild_members' property
     *
     * @return Down_GuildMembers
     */
    public function getGuildMembers()
    {
        return $this->get(self::_GUILD_MEMBERS);
    }

    /**
     * Sets value of '_guild_stage_rank' property
     *
     * @param Down_GuildStageRank $value Property value
     *
     * @return null
     */
    public function setGuildStageRank(Down_GuildStageRank $value)
    {
        return $this->set(self::_GUILD_STAGE_RANK, $value);
    }

    /**
     * Returns value of '_guild_stage_rank' property
     *
     * @return Down_GuildStageRank
     */
    public function getGuildStageRank()
    {
        return $this->get(self::_GUILD_STAGE_RANK);
    }

    /**
     * Sets value of '_set_jump' property
     *
     * @param Down_GuildSetJump $value Property value
     *
     * @return null
     */
    public function setSetJump(Down_GuildSetJump $value)
    {
        return $this->set(self::_SET_JUMP, $value);
    }

    /**
     * Returns value of '_set_jump' property
     *
     * @return Down_GuildSetJump
     */
    public function getSetJump()
    {
        return $this->get(self::_SET_JUMP);
    }

    /**
     * Sets value of '_send_mail_reply' property
     *
     * @param Down_GuildSendMail $value Property value
     *
     * @return null
     */
    public function setSendMailReply(Down_GuildSendMail $value)
    {
        return $this->set(self::_SEND_MAIL_REPLY, $value);
    }

    /**
     * Returns value of '_send_mail_reply' property
     *
     * @return Down_GuildSendMail
     */
    public function getSendMailReply()
    {
        return $this->get(self::_SEND_MAIL_REPLY);
    }
}

/**
 * guild_send_mail message
 */
class Down_GuildSendMail extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }
}

/**
 * guild_set_jump message
 */
class Down_GuildSetJump extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }
}

/**
 * guild_instance_prepare message
 */
class Down_GuildInstancePrepare extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _LEFT_TIME = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_LEFT_TIME => array(
            'name' => '_left_time',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_LEFT_TIME] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_left_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLeftTime($value)
    {
        return $this->set(self::_LEFT_TIME, $value);
    }

    /**
     * Returns value of '_left_time' property
     *
     * @return int
     */
    public function getLeftTime()
    {
        return $this->get(self::_LEFT_TIME);
    }
}

/**
 * dps_rank message
 */
class Down_DpsRank extends \ProtobufMessage
{
    /* Field index constants */
    const _DPS = 1;
    const _DPS_USER = 2;
    const _ARRAY = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_DPS => array(
            'name' => '_dps',
            'required' => true,
            'type' => 5,
        ),
        self::_DPS_USER => array(
            'name' => '_dps_user',
            'required' => true,
            'type' => 'Down_UserSummary'
        ),
        self::_ARRAY => array(
            'name' => '_array',
            'required' => false,
            'type' => 'Down_DpsRankArray'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_DPS] = null;
        $this->values[self::_DPS_USER] = null;
        $this->values[self::_ARRAY] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_dps' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setDps($value)
    {
        return $this->set(self::_DPS, $value);
    }

    /**
     * Returns value of '_dps' property
     *
     * @return int
     */
    public function getDps()
    {
        return $this->get(self::_DPS);
    }

    /**
     * Sets value of '_dps_user' property
     *
     * @param Down_UserSummary $value Property value
     *
     * @return null
     */
    public function setDpsUser(Down_UserSummary $value)
    {
        return $this->set(self::_DPS_USER, $value);
    }

    /**
     * Returns value of '_dps_user' property
     *
     * @return Down_UserSummary
     */
    public function getDpsUser()
    {
        return $this->get(self::_DPS_USER);
    }

    /**
     * Sets value of '_array' property
     *
     * @param Down_DpsRankArray $value Property value
     *
     * @return null
     */
    public function setArray(Down_DpsRankArray $value)
    {
        return $this->set(self::_ARRAY, $value);
    }

    /**
     * Returns value of '_array' property
     *
     * @return Down_DpsRankArray
     */
    public function getArray()
    {
        return $this->get(self::_ARRAY);
    }
}

/**
 * dps_rank_array message
 */
class Down_DpsRankArray extends \ProtobufMessage
{
    /* Field index constants */
    const _HEROS = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_HEROS => array(
            'name' => '_heros',
            'repeated' => true,
            'type' => 'Down_HeroSummary'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_HEROS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_heros' list
     *
     * @param Down_HeroSummary $value Value to append
     *
     * @return null
     */
    public function appendHeros(Down_HeroSummary $value)
    {
        return $this->append(self::_HEROS, $value);
    }

    /**
     * Clears '_heros' list
     *
     * @return null
     */
    public function clearHeros()
    {
        return $this->clear(self::_HEROS);
    }

    /**
     * Returns '_heros' list
     *
     * @return Down_HeroSummary[]
     */
    public function getHeros()
    {
        return $this->get(self::_HEROS);
    }

    /**
     * Returns '_heros' iterator
     *
     * @return ArrayIterator
     */
    public function getHerosIterator()
    {
        return new \ArrayIterator($this->get(self::_HEROS));
    }

    /**
     * Returns element from '_heros' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_HeroSummary
     */
    public function getHerosAt($offset)
    {
        return $this->get(self::_HEROS, $offset);
    }

    /**
     * Returns count of '_heros' list
     *
     * @return int
     */
    public function getHerosCount()
    {
        return $this->count(self::_HEROS);
    }
}

/**
 * guild_first_pass message
 */
class Down_GuildFirstPass extends \ProtobufMessage
{
    /* Field index constants */
    const _SUMMARY = 1;
    const _PASS_TIME = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_SUMMARY => array(
            'name' => '_summary',
            'required' => true,
            'type' => 'Down_UserSummary'
        ),
        self::_PASS_TIME => array(
            'name' => '_pass_time',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_SUMMARY] = null;
        $this->values[self::_PASS_TIME] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_summary' property
     *
     * @param Down_UserSummary $value Property value
     *
     * @return null
     */
    public function setSummary(Down_UserSummary $value)
    {
        return $this->set(self::_SUMMARY, $value);
    }

    /**
     * Returns value of '_summary' property
     *
     * @return Down_UserSummary
     */
    public function getSummary()
    {
        return $this->get(self::_SUMMARY);
    }

    /**
     * Sets value of '_pass_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setPassTime($value)
    {
        return $this->set(self::_PASS_TIME, $value);
    }

    /**
     * Returns value of '_pass_time' property
     *
     * @return int
     */
    public function getPassTime()
    {
        return $this->get(self::_PASS_TIME);
    }
}

/**
 * guild_fast_pass message
 */
class Down_GuildFastPass extends \ProtobufMessage
{
    /* Field index constants */
    const _ID = 1;
    const _ICON = 2;
    const _TIME = 3;
    const _NAME = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ID => array(
            'name' => '_id',
            'required' => true,
            'type' => 5,
        ),
        self::_ICON => array(
            'name' => '_icon',
            'required' => true,
            'type' => 5,
        ),
        self::_TIME => array(
            'name' => '_time',
            'required' => true,
            'type' => 5,
        ),
        self::_NAME => array(
            'name' => '_name',
            'required' => true,
            'type' => 7,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ID] = null;
        $this->values[self::_ICON] = null;
        $this->values[self::_TIME] = null;
        $this->values[self::_NAME] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setId($value)
    {
        return $this->set(self::_ID, $value);
    }

    /**
     * Returns value of '_id' property
     *
     * @return int
     */
    public function getId()
    {
        return $this->get(self::_ID);
    }

    /**
     * Sets value of '_icon' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setIcon($value)
    {
        return $this->set(self::_ICON, $value);
    }

    /**
     * Returns value of '_icon' property
     *
     * @return int
     */
    public function getIcon()
    {
        return $this->get(self::_ICON);
    }

    /**
     * Sets value of '_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setTime($value)
    {
        return $this->set(self::_TIME, $value);
    }

    /**
     * Returns value of '_time' property
     *
     * @return int
     */
    public function getTime()
    {
        return $this->get(self::_TIME);
    }

    /**
     * Sets value of '_name' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setName($value)
    {
        return $this->set(self::_NAME, $value);
    }

    /**
     * Returns value of '_name' property
     *
     * @return string
     */
    public function getName()
    {
        return $this->get(self::_NAME);
    }
}

/**
 * guild_stage_rank message
 */
class Down_GuildStageRank extends \ProtobufMessage
{
    /* Field index constants */
    const _STAGE_ID = 1;
    const _DPS_RANK = 2;
    const _FIRST_PASS = 3;
    const _FAST_PASS = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_STAGE_ID => array(
            'name' => '_stage_id',
            'required' => true,
            'type' => 5,
        ),
        self::_DPS_RANK => array(
            'name' => '_dps_rank',
            'repeated' => true,
            'type' => 'Down_DpsRank'
        ),
        self::_FIRST_PASS => array(
            'name' => '_first_pass',
            'required' => false,
            'type' => 'Down_GuildFirstPass'
        ),
        self::_FAST_PASS => array(
            'name' => '_fast_pass',
            'required' => false,
            'type' => 'Down_GuildFastPass'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_STAGE_ID] = null;
        $this->values[self::_DPS_RANK] = array();
        $this->values[self::_FIRST_PASS] = null;
        $this->values[self::_FAST_PASS] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_stage_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStageId($value)
    {
        return $this->set(self::_STAGE_ID, $value);
    }

    /**
     * Returns value of '_stage_id' property
     *
     * @return int
     */
    public function getStageId()
    {
        return $this->get(self::_STAGE_ID);
    }

    /**
     * Appends value to '_dps_rank' list
     *
     * @param Down_DpsRank $value Value to append
     *
     * @return null
     */
    public function appendDpsRank(Down_DpsRank $value)
    {
        return $this->append(self::_DPS_RANK, $value);
    }

    /**
     * Clears '_dps_rank' list
     *
     * @return null
     */
    public function clearDpsRank()
    {
        return $this->clear(self::_DPS_RANK);
    }

    /**
     * Returns '_dps_rank' list
     *
     * @return Down_DpsRank[]
     */
    public function getDpsRank()
    {
        return $this->get(self::_DPS_RANK);
    }

    /**
     * Returns '_dps_rank' iterator
     *
     * @return ArrayIterator
     */
    public function getDpsRankIterator()
    {
        return new \ArrayIterator($this->get(self::_DPS_RANK));
    }

    /**
     * Returns element from '_dps_rank' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_DpsRank
     */
    public function getDpsRankAt($offset)
    {
        return $this->get(self::_DPS_RANK, $offset);
    }

    /**
     * Returns count of '_dps_rank' list
     *
     * @return int
     */
    public function getDpsRankCount()
    {
        return $this->count(self::_DPS_RANK);
    }

    /**
     * Sets value of '_first_pass' property
     *
     * @param Down_GuildFirstPass $value Property value
     *
     * @return null
     */
    public function setFirstPass(Down_GuildFirstPass $value)
    {
        return $this->set(self::_FIRST_PASS, $value);
    }

    /**
     * Returns value of '_first_pass' property
     *
     * @return Down_GuildFirstPass
     */
    public function getFirstPass()
    {
        return $this->get(self::_FIRST_PASS);
    }

    /**
     * Sets value of '_fast_pass' property
     *
     * @param Down_GuildFastPass $value Property value
     *
     * @return null
     */
    public function setFastPass(Down_GuildFastPass $value)
    {
        return $this->set(self::_FAST_PASS, $value);
    }

    /**
     * Returns value of '_fast_pass' property
     *
     * @return Down_GuildFastPass
     */
    public function getFastPass()
    {
        return $this->get(self::_FAST_PASS);
    }
}

/**
 * guild_app_queue message
 */
class Down_GuildAppQueue extends \ProtobufMessage
{
    /* Field index constants */
    const _SUMMARY = 1;
    const _TIMEOUT = 2;
    const _ITEM_COUNT = 3;
    const _RANK = 4;
    const _ITEM_ID = 5;
    const _JUMP_TIMES = 6;
    const _COST_MONEY = 7;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_SUMMARY => array(
            'name' => '_summary',
            'repeated' => true,
            'type' => 'Down_UserSummary'
        ),
        self::_TIMEOUT => array(
            'name' => '_timeout',
            'required' => true,
            'type' => 5,
        ),
        self::_ITEM_COUNT => array(
            'name' => '_item_count',
            'required' => true,
            'type' => 5,
        ),
        self::_RANK => array(
            'name' => '_rank',
            'required' => true,
            'type' => 5,
        ),
        self::_ITEM_ID => array(
            'name' => '_item_id',
            'required' => true,
            'type' => 5,
        ),
        self::_JUMP_TIMES => array(
            'name' => '_jump_times',
            'required' => true,
            'type' => 5,
        ),
        self::_COST_MONEY => array(
            'name' => '_cost_money',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_SUMMARY] = array();
        $this->values[self::_TIMEOUT] = null;
        $this->values[self::_ITEM_COUNT] = null;
        $this->values[self::_RANK] = null;
        $this->values[self::_ITEM_ID] = null;
        $this->values[self::_JUMP_TIMES] = null;
        $this->values[self::_COST_MONEY] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_summary' list
     *
     * @param Down_UserSummary $value Value to append
     *
     * @return null
     */
    public function appendSummary(Down_UserSummary $value)
    {
        return $this->append(self::_SUMMARY, $value);
    }

    /**
     * Clears '_summary' list
     *
     * @return null
     */
    public function clearSummary()
    {
        return $this->clear(self::_SUMMARY);
    }

    /**
     * Returns '_summary' list
     *
     * @return Down_UserSummary[]
     */
    public function getSummary()
    {
        return $this->get(self::_SUMMARY);
    }

    /**
     * Returns '_summary' iterator
     *
     * @return ArrayIterator
     */
    public function getSummaryIterator()
    {
        return new \ArrayIterator($this->get(self::_SUMMARY));
    }

    /**
     * Returns element from '_summary' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_UserSummary
     */
    public function getSummaryAt($offset)
    {
        return $this->get(self::_SUMMARY, $offset);
    }

    /**
     * Returns count of '_summary' list
     *
     * @return int
     */
    public function getSummaryCount()
    {
        return $this->count(self::_SUMMARY);
    }

    /**
     * Sets value of '_timeout' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setTimeout($value)
    {
        return $this->set(self::_TIMEOUT, $value);
    }

    /**
     * Returns value of '_timeout' property
     *
     * @return int
     */
    public function getTimeout()
    {
        return $this->get(self::_TIMEOUT);
    }

    /**
     * Sets value of '_item_count' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setItemCount($value)
    {
        return $this->set(self::_ITEM_COUNT, $value);
    }

    /**
     * Returns value of '_item_count' property
     *
     * @return int
     */
    public function getItemCount()
    {
        return $this->get(self::_ITEM_COUNT);
    }

    /**
     * Sets value of '_rank' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRank($value)
    {
        return $this->set(self::_RANK, $value);
    }

    /**
     * Returns value of '_rank' property
     *
     * @return int
     */
    public function getRank()
    {
        return $this->get(self::_RANK);
    }

    /**
     * Sets value of '_item_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setItemId($value)
    {
        return $this->set(self::_ITEM_ID, $value);
    }

    /**
     * Returns value of '_item_id' property
     *
     * @return int
     */
    public function getItemId()
    {
        return $this->get(self::_ITEM_ID);
    }

    /**
     * Sets value of '_jump_times' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setJumpTimes($value)
    {
        return $this->set(self::_JUMP_TIMES, $value);
    }

    /**
     * Returns value of '_jump_times' property
     *
     * @return int
     */
    public function getJumpTimes()
    {
        return $this->get(self::_JUMP_TIMES);
    }

    /**
     * Sets value of '_cost_money' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCostMoney($value)
    {
        return $this->set(self::_COST_MONEY, $value);
    }

    /**
     * Returns value of '_cost_money' property
     *
     * @return int
     */
    public function getCostMoney()
    {
        return $this->get(self::_COST_MONEY);
    }
}

/**
 * guild_members message
 */
class Down_GuildMembers extends \ProtobufMessage
{
    /* Field index constants */
    const _GUILD_MEMBER = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_GUILD_MEMBER => array(
            'name' => '_guild_member',
            'repeated' => true,
            'type' => 'Down_GuildMember'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_GUILD_MEMBER] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_guild_member' list
     *
     * @param Down_GuildMember $value Value to append
     *
     * @return null
     */
    public function appendGuildMember(Down_GuildMember $value)
    {
        return $this->append(self::_GUILD_MEMBER, $value);
    }

    /**
     * Clears '_guild_member' list
     *
     * @return null
     */
    public function clearGuildMember()
    {
        return $this->clear(self::_GUILD_MEMBER);
    }

    /**
     * Returns '_guild_member' list
     *
     * @return Down_GuildMember[]
     */
    public function getGuildMember()
    {
        return $this->get(self::_GUILD_MEMBER);
    }

    /**
     * Returns '_guild_member' iterator
     *
     * @return ArrayIterator
     */
    public function getGuildMemberIterator()
    {
        return new \ArrayIterator($this->get(self::_GUILD_MEMBER));
    }

    /**
     * Returns element from '_guild_member' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_GuildMember
     */
    public function getGuildMemberAt($offset)
    {
        return $this->get(self::_GUILD_MEMBER, $offset);
    }

    /**
     * Returns count of '_guild_member' list
     *
     * @return int
     */
    public function getGuildMemberCount()
    {
        return $this->count(self::_GUILD_MEMBER);
    }
}

/**
 * guild_jump message
 */
class Down_GuildJump extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _APP_QUEUE = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_APP_QUEUE => array(
            'name' => '_app_queue',
            'required' => true,
            'type' => 'Down_GuildAppQueue'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_APP_QUEUE] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_app_queue' property
     *
     * @param Down_GuildAppQueue $value Property value
     *
     * @return null
     */
    public function setAppQueue(Down_GuildAppQueue $value)
    {
        return $this->set(self::_APP_QUEUE, $value);
    }

    /**
     * Returns value of '_app_queue' property
     *
     * @return Down_GuildAppQueue
     */
    public function getAppQueue()
    {
        return $this->get(self::_APP_QUEUE);
    }
}

/**
 * guild_items_history message
 */
class Down_GuildItemsHistory extends \ProtobufMessage
{
    /* Field index constants */
    const _ISTHERE = 1;
    const _ITEM_HISTORYS = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ISTHERE => array(
            'name' => '_isthere',
            'required' => true,
            'type' => 5,
        ),
        self::_ITEM_HISTORYS => array(
            'name' => '_item_historys',
            'repeated' => true,
            'type' => 'Down_GuildItemHistory'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ISTHERE] = null;
        $this->values[self::_ITEM_HISTORYS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_isthere' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setIsthere($value)
    {
        return $this->set(self::_ISTHERE, $value);
    }

    /**
     * Returns value of '_isthere' property
     *
     * @return int
     */
    public function getIsthere()
    {
        return $this->get(self::_ISTHERE);
    }

    /**
     * Appends value to '_item_historys' list
     *
     * @param Down_GuildItemHistory $value Value to append
     *
     * @return null
     */
    public function appendItemHistorys(Down_GuildItemHistory $value)
    {
        return $this->append(self::_ITEM_HISTORYS, $value);
    }

    /**
     * Clears '_item_historys' list
     *
     * @return null
     */
    public function clearItemHistorys()
    {
        return $this->clear(self::_ITEM_HISTORYS);
    }

    /**
     * Returns '_item_historys' list
     *
     * @return Down_GuildItemHistory[]
     */
    public function getItemHistorys()
    {
        return $this->get(self::_ITEM_HISTORYS);
    }

    /**
     * Returns '_item_historys' iterator
     *
     * @return ArrayIterator
     */
    public function getItemHistorysIterator()
    {
        return new \ArrayIterator($this->get(self::_ITEM_HISTORYS));
    }

    /**
     * Returns element from '_item_historys' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_GuildItemHistory
     */
    public function getItemHistorysAt($offset)
    {
        return $this->get(self::_ITEM_HISTORYS, $offset);
    }

    /**
     * Returns count of '_item_historys' list
     *
     * @return int
     */
    public function getItemHistorysCount()
    {
        return $this->count(self::_ITEM_HISTORYS);
    }
}

/**
 * guild_item_history message
 */
class Down_GuildItemHistory extends \ProtobufMessage
{
    /* Field index constants */
    const _ITEM_ID = 1;
    const _RECEIVER_NAME = 2;
    const _SEND_TIME = 3;
    const _SENDER_NAME = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ITEM_ID => array(
            'name' => '_item_id',
            'required' => true,
            'type' => 5,
        ),
        self::_RECEIVER_NAME => array(
            'name' => '_receiver_name',
            'required' => true,
            'type' => 7,
        ),
        self::_SEND_TIME => array(
            'name' => '_send_time',
            'required' => true,
            'type' => 5,
        ),
        self::_SENDER_NAME => array(
            'name' => '_sender_name',
            'required' => false,
            'type' => 7,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ITEM_ID] = null;
        $this->values[self::_RECEIVER_NAME] = null;
        $this->values[self::_SEND_TIME] = null;
        $this->values[self::_SENDER_NAME] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_item_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setItemId($value)
    {
        return $this->set(self::_ITEM_ID, $value);
    }

    /**
     * Returns value of '_item_id' property
     *
     * @return int
     */
    public function getItemId()
    {
        return $this->get(self::_ITEM_ID);
    }

    /**
     * Sets value of '_receiver_name' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setReceiverName($value)
    {
        return $this->set(self::_RECEIVER_NAME, $value);
    }

    /**
     * Returns value of '_receiver_name' property
     *
     * @return string
     */
    public function getReceiverName()
    {
        return $this->get(self::_RECEIVER_NAME);
    }

    /**
     * Sets value of '_send_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSendTime($value)
    {
        return $this->set(self::_SEND_TIME, $value);
    }

    /**
     * Returns value of '_send_time' property
     *
     * @return int
     */
    public function getSendTime()
    {
        return $this->get(self::_SEND_TIME);
    }

    /**
     * Sets value of '_sender_name' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setSenderName($value)
    {
        return $this->set(self::_SENDER_NAME, $value);
    }

    /**
     * Returns value of '_sender_name' property
     *
     * @return string
     */
    public function getSenderName()
    {
        return $this->get(self::_SENDER_NAME);
    }
}

/**
 * guild_challenger_damage message
 */
class Down_GuildChallengerDamage extends \ProtobufMessage
{
    /* Field index constants */
    const _CHALLENGER = 1;
    const _DAMAGE = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_CHALLENGER => array(
            'name' => '_challenger',
            'required' => true,
            'type' => 'Down_GuildChallenger'
        ),
        self::_DAMAGE => array(
            'name' => '_damage',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_CHALLENGER] = null;
        $this->values[self::_DAMAGE] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_challenger' property
     *
     * @param Down_GuildChallenger $value Property value
     *
     * @return null
     */
    public function setChallenger(Down_GuildChallenger $value)
    {
        return $this->set(self::_CHALLENGER, $value);
    }

    /**
     * Returns value of '_challenger' property
     *
     * @return Down_GuildChallenger
     */
    public function getChallenger()
    {
        return $this->get(self::_CHALLENGER);
    }

    /**
     * Sets value of '_damage' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setDamage($value)
    {
        return $this->set(self::_DAMAGE, $value);
    }

    /**
     * Returns value of '_damage' property
     *
     * @return int
     */
    public function getDamage()
    {
        return $this->get(self::_DAMAGE);
    }
}

/**
 * guild_instance_damage message
 */
class Down_GuildInstanceDamage extends \ProtobufMessage
{
    /* Field index constants */
    const _ISTHERE = 1;
    const _DAMAGES = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ISTHERE => array(
            'name' => '_isthere',
            'required' => true,
            'type' => 5,
        ),
        self::_DAMAGES => array(
            'name' => '_damages',
            'repeated' => true,
            'type' => 'Down_GuildChallengerDamage'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ISTHERE] = null;
        $this->values[self::_DAMAGES] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_isthere' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setIsthere($value)
    {
        return $this->set(self::_ISTHERE, $value);
    }

    /**
     * Returns value of '_isthere' property
     *
     * @return int
     */
    public function getIsthere()
    {
        return $this->get(self::_ISTHERE);
    }

    /**
     * Appends value to '_damages' list
     *
     * @param Down_GuildChallengerDamage $value Value to append
     *
     * @return null
     */
    public function appendDamages(Down_GuildChallengerDamage $value)
    {
        return $this->append(self::_DAMAGES, $value);
    }

    /**
     * Clears '_damages' list
     *
     * @return null
     */
    public function clearDamages()
    {
        return $this->clear(self::_DAMAGES);
    }

    /**
     * Returns '_damages' list
     *
     * @return Down_GuildChallengerDamage[]
     */
    public function getDamages()
    {
        return $this->get(self::_DAMAGES);
    }

    /**
     * Returns '_damages' iterator
     *
     * @return ArrayIterator
     */
    public function getDamagesIterator()
    {
        return new \ArrayIterator($this->get(self::_DAMAGES));
    }

    /**
     * Returns element from '_damages' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_GuildChallengerDamage
     */
    public function getDamagesAt($offset)
    {
        return $this->get(self::_DAMAGES, $offset);
    }

    /**
     * Returns count of '_damages' list
     *
     * @return int
     */
    public function getDamagesCount()
    {
        return $this->count(self::_DAMAGES);
    }
}

/**
 * guild_drop_give message
 */
class Down_GuildDropGive extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }
}

/**
 * guild_drop_item_info message
 */
class Down_GuildDropItemInfo extends \ProtobufMessage
{
    /* Field index constants */
    const _ITEM_ID = 1;
    const _TIME_OUT_END = 2;
    const _USER_ID = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ITEM_ID => array(
            'name' => '_item_id',
            'required' => true,
            'type' => 5,
        ),
        self::_TIME_OUT_END => array(
            'name' => '_time_out_end',
            'required' => true,
            'type' => 5,
        ),
        self::_USER_ID => array(
            'name' => '_user_id',
            'repeated' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ITEM_ID] = null;
        $this->values[self::_TIME_OUT_END] = null;
        $this->values[self::_USER_ID] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_item_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setItemId($value)
    {
        return $this->set(self::_ITEM_ID, $value);
    }

    /**
     * Returns value of '_item_id' property
     *
     * @return int
     */
    public function getItemId()
    {
        return $this->get(self::_ITEM_ID);
    }

    /**
     * Sets value of '_time_out_end' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setTimeOutEnd($value)
    {
        return $this->set(self::_TIME_OUT_END, $value);
    }

    /**
     * Returns value of '_time_out_end' property
     *
     * @return int
     */
    public function getTimeOutEnd()
    {
        return $this->get(self::_TIME_OUT_END);
    }

    /**
     * Appends value to '_user_id' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendUserId($value)
    {
        return $this->append(self::_USER_ID, $value);
    }

    /**
     * Clears '_user_id' list
     *
     * @return null
     */
    public function clearUserId()
    {
        return $this->clear(self::_USER_ID);
    }

    /**
     * Returns '_user_id' list
     *
     * @return int[]
     */
    public function getUserId()
    {
        return $this->get(self::_USER_ID);
    }

    /**
     * Returns '_user_id' iterator
     *
     * @return ArrayIterator
     */
    public function getUserIdIterator()
    {
        return new \ArrayIterator($this->get(self::_USER_ID));
    }

    /**
     * Returns element from '_user_id' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getUserIdAt($offset)
    {
        return $this->get(self::_USER_ID, $offset);
    }

    /**
     * Returns count of '_user_id' list
     *
     * @return int
     */
    public function getUserIdCount()
    {
        return $this->count(self::_USER_ID);
    }
}

/**
 * guild_drop_item message
 */
class Down_GuildDropItem extends \ProtobufMessage
{
    /* Field index constants */
    const _RAID_ID = 1;
    const _DPS_LIST = 2;
    const _ITEM_INFO = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RAID_ID => array(
            'name' => '_raid_id',
            'required' => true,
            'type' => 5,
        ),
        self::_DPS_LIST => array(
            'name' => '_dps_list',
            'repeated' => true,
            'type' => 'Down_GuildInstanceDps'
        ),
        self::_ITEM_INFO => array(
            'name' => '_item_info',
            'repeated' => true,
            'type' => 'Down_GuildDropItemInfo'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RAID_ID] = null;
        $this->values[self::_DPS_LIST] = array();
        $this->values[self::_ITEM_INFO] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_raid_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRaidId($value)
    {
        return $this->set(self::_RAID_ID, $value);
    }

    /**
     * Returns value of '_raid_id' property
     *
     * @return int
     */
    public function getRaidId()
    {
        return $this->get(self::_RAID_ID);
    }

    /**
     * Appends value to '_dps_list' list
     *
     * @param Down_GuildInstanceDps $value Value to append
     *
     * @return null
     */
    public function appendDpsList(Down_GuildInstanceDps $value)
    {
        return $this->append(self::_DPS_LIST, $value);
    }

    /**
     * Clears '_dps_list' list
     *
     * @return null
     */
    public function clearDpsList()
    {
        return $this->clear(self::_DPS_LIST);
    }

    /**
     * Returns '_dps_list' list
     *
     * @return Down_GuildInstanceDps[]
     */
    public function getDpsList()
    {
        return $this->get(self::_DPS_LIST);
    }

    /**
     * Returns '_dps_list' iterator
     *
     * @return ArrayIterator
     */
    public function getDpsListIterator()
    {
        return new \ArrayIterator($this->get(self::_DPS_LIST));
    }

    /**
     * Returns element from '_dps_list' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_GuildInstanceDps
     */
    public function getDpsListAt($offset)
    {
        return $this->get(self::_DPS_LIST, $offset);
    }

    /**
     * Returns count of '_dps_list' list
     *
     * @return int
     */
    public function getDpsListCount()
    {
        return $this->count(self::_DPS_LIST);
    }

    /**
     * Appends value to '_item_info' list
     *
     * @param Down_GuildDropItemInfo $value Value to append
     *
     * @return null
     */
    public function appendItemInfo(Down_GuildDropItemInfo $value)
    {
        return $this->append(self::_ITEM_INFO, $value);
    }

    /**
     * Clears '_item_info' list
     *
     * @return null
     */
    public function clearItemInfo()
    {
        return $this->clear(self::_ITEM_INFO);
    }

    /**
     * Returns '_item_info' list
     *
     * @return Down_GuildDropItemInfo[]
     */
    public function getItemInfo()
    {
        return $this->get(self::_ITEM_INFO);
    }

    /**
     * Returns '_item_info' iterator
     *
     * @return ArrayIterator
     */
    public function getItemInfoIterator()
    {
        return new \ArrayIterator($this->get(self::_ITEM_INFO));
    }

    /**
     * Returns element from '_item_info' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_GuildDropItemInfo
     */
    public function getItemInfoAt($offset)
    {
        return $this->get(self::_ITEM_INFO, $offset);
    }

    /**
     * Returns count of '_item_info' list
     *
     * @return int
     */
    public function getItemInfoCount()
    {
        return $this->count(self::_ITEM_INFO);
    }
}

/**
 * guild_instance_dps message
 */
class Down_GuildInstanceDps extends \ProtobufMessage
{
    /* Field index constants */
    const _UID = 1;
    const _DPS = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_UID => array(
            'name' => '_uid',
            'required' => true,
            'type' => 5,
        ),
        self::_DPS => array(
            'name' => '_dps',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_UID] = null;
        $this->values[self::_DPS] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_uid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setUid($value)
    {
        return $this->set(self::_UID, $value);
    }

    /**
     * Returns value of '_uid' property
     *
     * @return int
     */
    public function getUid()
    {
        return $this->get(self::_UID);
    }

    /**
     * Sets value of '_dps' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setDps($value)
    {
        return $this->set(self::_DPS, $value);
    }

    /**
     * Returns value of '_dps' property
     *
     * @return int
     */
    public function getDps()
    {
        return $this->get(self::_DPS);
    }
}

/**
 * guild_drop_info message
 */
class Down_GuildDropInfo extends \ProtobufMessage
{
    /* Field index constants */
    const _MEMBERS = 1;
    const _ITEMS = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_MEMBERS => array(
            'name' => '_members',
            'repeated' => true,
            'type' => 'Down_GuildMember'
        ),
        self::_ITEMS => array(
            'name' => '_items',
            'repeated' => true,
            'type' => 'Down_GuildDropItem'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_MEMBERS] = array();
        $this->values[self::_ITEMS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_members' list
     *
     * @param Down_GuildMember $value Value to append
     *
     * @return null
     */
    public function appendMembers(Down_GuildMember $value)
    {
        return $this->append(self::_MEMBERS, $value);
    }

    /**
     * Clears '_members' list
     *
     * @return null
     */
    public function clearMembers()
    {
        return $this->clear(self::_MEMBERS);
    }

    /**
     * Returns '_members' list
     *
     * @return Down_GuildMember[]
     */
    public function getMembers()
    {
        return $this->get(self::_MEMBERS);
    }

    /**
     * Returns '_members' iterator
     *
     * @return ArrayIterator
     */
    public function getMembersIterator()
    {
        return new \ArrayIterator($this->get(self::_MEMBERS));
    }

    /**
     * Returns element from '_members' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_GuildMember
     */
    public function getMembersAt($offset)
    {
        return $this->get(self::_MEMBERS, $offset);
    }

    /**
     * Returns count of '_members' list
     *
     * @return int
     */
    public function getMembersCount()
    {
        return $this->count(self::_MEMBERS);
    }

    /**
     * Appends value to '_items' list
     *
     * @param Down_GuildDropItem $value Value to append
     *
     * @return null
     */
    public function appendItems(Down_GuildDropItem $value)
    {
        return $this->append(self::_ITEMS, $value);
    }

    /**
     * Clears '_items' list
     *
     * @return null
     */
    public function clearItems()
    {
        return $this->clear(self::_ITEMS);
    }

    /**
     * Returns '_items' list
     *
     * @return Down_GuildDropItem[]
     */
    public function getItems()
    {
        return $this->get(self::_ITEMS);
    }

    /**
     * Returns '_items' iterator
     *
     * @return ArrayIterator
     */
    public function getItemsIterator()
    {
        return new \ArrayIterator($this->get(self::_ITEMS));
    }

    /**
     * Returns element from '_items' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_GuildDropItem
     */
    public function getItemsAt($offset)
    {
        return $this->get(self::_ITEMS, $offset);
    }

    /**
     * Returns count of '_items' list
     *
     * @return int
     */
    public function getItemsCount()
    {
        return $this->count(self::_ITEMS);
    }
}

/**
 * guild_instance_apply message
 */
class Down_GuildInstanceApply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _APP_QUEUE = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_APP_QUEUE => array(
            'name' => '_app_queue',
            'required' => true,
            'type' => 'Down_GuildAppQueue'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_APP_QUEUE] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_app_queue' property
     *
     * @param Down_GuildAppQueue $value Property value
     *
     * @return null
     */
    public function setAppQueue(Down_GuildAppQueue $value)
    {
        return $this->set(self::_APP_QUEUE, $value);
    }

    /**
     * Returns value of '_app_queue' property
     *
     * @return Down_GuildAppQueue
     */
    public function getAppQueue()
    {
        return $this->get(self::_APP_QUEUE);
    }
}

/**
 * guild_instance_info message
 */
class Down_GuildInstanceInfo extends \ProtobufMessage
{
    /* Field index constants */
    const _RAID_ID = 1;
    const _STAGE_INDEX = 2;
    const _WAVE_INDEX = 3;
    const _HP_INFO = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RAID_ID => array(
            'name' => '_raid_id',
            'required' => true,
            'type' => 5,
        ),
        self::_STAGE_INDEX => array(
            'name' => '_stage_index',
            'required' => true,
            'type' => 5,
        ),
        self::_WAVE_INDEX => array(
            'name' => '_wave_index',
            'required' => true,
            'type' => 5,
        ),
        self::_HP_INFO => array(
            'name' => '_hp_info',
            'repeated' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RAID_ID] = null;
        $this->values[self::_STAGE_INDEX] = null;
        $this->values[self::_WAVE_INDEX] = null;
        $this->values[self::_HP_INFO] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_raid_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRaidId($value)
    {
        return $this->set(self::_RAID_ID, $value);
    }

    /**
     * Returns value of '_raid_id' property
     *
     * @return int
     */
    public function getRaidId()
    {
        return $this->get(self::_RAID_ID);
    }

    /**
     * Sets value of '_stage_index' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStageIndex($value)
    {
        return $this->set(self::_STAGE_INDEX, $value);
    }

    /**
     * Returns value of '_stage_index' property
     *
     * @return int
     */
    public function getStageIndex()
    {
        return $this->get(self::_STAGE_INDEX);
    }

    /**
     * Sets value of '_wave_index' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setWaveIndex($value)
    {
        return $this->set(self::_WAVE_INDEX, $value);
    }

    /**
     * Returns value of '_wave_index' property
     *
     * @return int
     */
    public function getWaveIndex()
    {
        return $this->get(self::_WAVE_INDEX);
    }

    /**
     * Appends value to '_hp_info' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendHpInfo($value)
    {
        return $this->append(self::_HP_INFO, $value);
    }

    /**
     * Clears '_hp_info' list
     *
     * @return null
     */
    public function clearHpInfo()
    {
        return $this->clear(self::_HP_INFO);
    }

    /**
     * Returns '_hp_info' list
     *
     * @return int[]
     */
    public function getHpInfo()
    {
        return $this->get(self::_HP_INFO);
    }

    /**
     * Returns '_hp_info' iterator
     *
     * @return ArrayIterator
     */
    public function getHpInfoIterator()
    {
        return new \ArrayIterator($this->get(self::_HP_INFO));
    }

    /**
     * Returns element from '_hp_info' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getHpInfoAt($offset)
    {
        return $this->get(self::_HP_INFO, $offset);
    }

    /**
     * Returns count of '_hp_info' list
     *
     * @return int
     */
    public function getHpInfoCount()
    {
        return $this->count(self::_HP_INFO);
    }
}

/**
 * guild_instance_start message
 */
class Down_GuildInstanceStart extends \ProtobufMessage
{
    /* Field index constants */
    const _INSTANCE_INFO = 1;
    const _RSEED = 2;
    const _LOOTS = 3;
    const _HP_DROP = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_INSTANCE_INFO => array(
            'name' => '_instance_info',
            'required' => true,
            'type' => 'Down_GuildInstanceInfo'
        ),
        self::_RSEED => array(
            'name' => '_rseed',
            'required' => true,
            'type' => 5,
        ),
        self::_LOOTS => array(
            'name' => '_loots',
            'repeated' => true,
            'type' => 5,
        ),
        self::_HP_DROP => array(
            'name' => '_hp_drop',
            'repeated' => true,
            'type' => 'Down_GuildStageHpDrop'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_INSTANCE_INFO] = null;
        $this->values[self::_RSEED] = null;
        $this->values[self::_LOOTS] = array();
        $this->values[self::_HP_DROP] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_instance_info' property
     *
     * @param Down_GuildInstanceInfo $value Property value
     *
     * @return null
     */
    public function setInstanceInfo(Down_GuildInstanceInfo $value)
    {
        return $this->set(self::_INSTANCE_INFO, $value);
    }

    /**
     * Returns value of '_instance_info' property
     *
     * @return Down_GuildInstanceInfo
     */
    public function getInstanceInfo()
    {
        return $this->get(self::_INSTANCE_INFO);
    }

    /**
     * Sets value of '_rseed' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRseed($value)
    {
        return $this->set(self::_RSEED, $value);
    }

    /**
     * Returns value of '_rseed' property
     *
     * @return int
     */
    public function getRseed()
    {
        return $this->get(self::_RSEED);
    }

    /**
     * Appends value to '_loots' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendLoots($value)
    {
        return $this->append(self::_LOOTS, $value);
    }

    /**
     * Clears '_loots' list
     *
     * @return null
     */
    public function clearLoots()
    {
        return $this->clear(self::_LOOTS);
    }

    /**
     * Returns '_loots' list
     *
     * @return int[]
     */
    public function getLoots()
    {
        return $this->get(self::_LOOTS);
    }

    /**
     * Returns '_loots' iterator
     *
     * @return ArrayIterator
     */
    public function getLootsIterator()
    {
        return new \ArrayIterator($this->get(self::_LOOTS));
    }

    /**
     * Returns element from '_loots' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getLootsAt($offset)
    {
        return $this->get(self::_LOOTS, $offset);
    }

    /**
     * Returns count of '_loots' list
     *
     * @return int
     */
    public function getLootsCount()
    {
        return $this->count(self::_LOOTS);
    }

    /**
     * Appends value to '_hp_drop' list
     *
     * @param Down_GuildStageHpDrop $value Value to append
     *
     * @return null
     */
    public function appendHpDrop(Down_GuildStageHpDrop $value)
    {
        return $this->append(self::_HP_DROP, $value);
    }

    /**
     * Clears '_hp_drop' list
     *
     * @return null
     */
    public function clearHpDrop()
    {
        return $this->clear(self::_HP_DROP);
    }

    /**
     * Returns '_hp_drop' list
     *
     * @return Down_GuildStageHpDrop[]
     */
    public function getHpDrop()
    {
        return $this->get(self::_HP_DROP);
    }

    /**
     * Returns '_hp_drop' iterator
     *
     * @return ArrayIterator
     */
    public function getHpDropIterator()
    {
        return new \ArrayIterator($this->get(self::_HP_DROP));
    }

    /**
     * Returns element from '_hp_drop' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_GuildStageHpDrop
     */
    public function getHpDropAt($offset)
    {
        return $this->get(self::_HP_DROP, $offset);
    }

    /**
     * Returns count of '_hp_drop' list
     *
     * @return int
     */
    public function getHpDropCount()
    {
        return $this->count(self::_HP_DROP);
    }
}

/**
 * guild_stage_hp_drop message
 */
class Down_GuildStageHpDrop extends \ProtobufMessage
{
    /* Field index constants */
    const _MONSTER_INFO = 1;
    const _LOOTS = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_MONSTER_INFO => array(
            'name' => '_monster_info',
            'required' => true,
            'type' => 5,
        ),
        self::_LOOTS => array(
            'name' => '_loots',
            'repeated' => true,
            'type' => 'Down_HpDrop'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_MONSTER_INFO] = null;
        $this->values[self::_LOOTS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_monster_info' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setMonsterInfo($value)
    {
        return $this->set(self::_MONSTER_INFO, $value);
    }

    /**
     * Returns value of '_monster_info' property
     *
     * @return int
     */
    public function getMonsterInfo()
    {
        return $this->get(self::_MONSTER_INFO);
    }

    /**
     * Appends value to '_loots' list
     *
     * @param Down_HpDrop $value Value to append
     *
     * @return null
     */
    public function appendLoots(Down_HpDrop $value)
    {
        return $this->append(self::_LOOTS, $value);
    }

    /**
     * Clears '_loots' list
     *
     * @return null
     */
    public function clearLoots()
    {
        return $this->clear(self::_LOOTS);
    }

    /**
     * Returns '_loots' list
     *
     * @return Down_HpDrop[]
     */
    public function getLoots()
    {
        return $this->get(self::_LOOTS);
    }

    /**
     * Returns '_loots' iterator
     *
     * @return ArrayIterator
     */
    public function getLootsIterator()
    {
        return new \ArrayIterator($this->get(self::_LOOTS));
    }

    /**
     * Returns element from '_loots' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_HpDrop
     */
    public function getLootsAt($offset)
    {
        return $this->get(self::_LOOTS, $offset);
    }

    /**
     * Returns count of '_loots' list
     *
     * @return int
     */
    public function getLootsCount()
    {
        return $this->count(self::_LOOTS);
    }
}

/**
 * hp_drop message
 */
class Down_HpDrop extends \ProtobufMessage
{
    /* Field index constants */
    const _PER = 1;
    const _ITEMS = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_PER => array(
            'name' => '_per',
            'required' => true,
            'type' => 5,
        ),
        self::_ITEMS => array(
            'name' => '_items',
            'repeated' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_PER] = null;
        $this->values[self::_ITEMS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_per' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setPer($value)
    {
        return $this->set(self::_PER, $value);
    }

    /**
     * Returns value of '_per' property
     *
     * @return int
     */
    public function getPer()
    {
        return $this->get(self::_PER);
    }

    /**
     * Appends value to '_items' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendItems($value)
    {
        return $this->append(self::_ITEMS, $value);
    }

    /**
     * Clears '_items' list
     *
     * @return null
     */
    public function clearItems()
    {
        return $this->clear(self::_ITEMS);
    }

    /**
     * Returns '_items' list
     *
     * @return int[]
     */
    public function getItems()
    {
        return $this->get(self::_ITEMS);
    }

    /**
     * Returns '_items' iterator
     *
     * @return ArrayIterator
     */
    public function getItemsIterator()
    {
        return new \ArrayIterator($this->get(self::_ITEMS));
    }

    /**
     * Returns element from '_items' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getItemsAt($offset)
    {
        return $this->get(self::_ITEMS, $offset);
    }

    /**
     * Returns count of '_items' list
     *
     * @return int
     */
    public function getItemsCount()
    {
        return $this->count(self::_ITEMS);
    }
}

/**
 * guild_instance_end_down message
 */
class Down_GuildInstanceEndDown extends \ProtobufMessage
{
    /* Field index constants */
    const _SUMMARY = 1;
    const _RESULT = 2;
    const _REWARDS = 3;
    const _APPLY_REWARDS = 4;
    const _STAGE_OLD_PROGRESS = 5;
    const _JOIN_TIMES = 6;
    const _BREAK_HISTORY = 7;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_SUMMARY => array(
            'name' => '_summary',
            'required' => true,
            'type' => 'Down_GuildInstanceSummary'
        ),
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_REWARDS => array(
            'name' => '_rewards',
            'repeated' => true,
            'type' => 5,
        ),
        self::_APPLY_REWARDS => array(
            'name' => '_apply_rewards',
            'repeated' => true,
            'type' => 5,
        ),
        self::_STAGE_OLD_PROGRESS => array(
            'name' => '_stage_old_progress',
            'required' => true,
            'type' => 5,
        ),
        self::_JOIN_TIMES => array(
            'name' => '_join_times',
            'required' => true,
            'type' => 5,
        ),
        self::_BREAK_HISTORY => array(
            'name' => '_break_history',
            'required' => false,
            'type' => 'Down_BreakHistory'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_SUMMARY] = null;
        $this->values[self::_RESULT] = null;
        $this->values[self::_REWARDS] = array();
        $this->values[self::_APPLY_REWARDS] = array();
        $this->values[self::_STAGE_OLD_PROGRESS] = null;
        $this->values[self::_JOIN_TIMES] = null;
        $this->values[self::_BREAK_HISTORY] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_summary' property
     *
     * @param Down_GuildInstanceSummary $value Property value
     *
     * @return null
     */
    public function setSummary(Down_GuildInstanceSummary $value)
    {
        return $this->set(self::_SUMMARY, $value);
    }

    /**
     * Returns value of '_summary' property
     *
     * @return Down_GuildInstanceSummary
     */
    public function getSummary()
    {
        return $this->get(self::_SUMMARY);
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Appends value to '_rewards' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendRewards($value)
    {
        return $this->append(self::_REWARDS, $value);
    }

    /**
     * Clears '_rewards' list
     *
     * @return null
     */
    public function clearRewards()
    {
        return $this->clear(self::_REWARDS);
    }

    /**
     * Returns '_rewards' list
     *
     * @return int[]
     */
    public function getRewards()
    {
        return $this->get(self::_REWARDS);
    }

    /**
     * Returns '_rewards' iterator
     *
     * @return ArrayIterator
     */
    public function getRewardsIterator()
    {
        return new \ArrayIterator($this->get(self::_REWARDS));
    }

    /**
     * Returns element from '_rewards' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getRewardsAt($offset)
    {
        return $this->get(self::_REWARDS, $offset);
    }

    /**
     * Returns count of '_rewards' list
     *
     * @return int
     */
    public function getRewardsCount()
    {
        return $this->count(self::_REWARDS);
    }

    /**
     * Appends value to '_apply_rewards' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendApplyRewards($value)
    {
        return $this->append(self::_APPLY_REWARDS, $value);
    }

    /**
     * Clears '_apply_rewards' list
     *
     * @return null
     */
    public function clearApplyRewards()
    {
        return $this->clear(self::_APPLY_REWARDS);
    }

    /**
     * Returns '_apply_rewards' list
     *
     * @return int[]
     */
    public function getApplyRewards()
    {
        return $this->get(self::_APPLY_REWARDS);
    }

    /**
     * Returns '_apply_rewards' iterator
     *
     * @return ArrayIterator
     */
    public function getApplyRewardsIterator()
    {
        return new \ArrayIterator($this->get(self::_APPLY_REWARDS));
    }

    /**
     * Returns element from '_apply_rewards' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getApplyRewardsAt($offset)
    {
        return $this->get(self::_APPLY_REWARDS, $offset);
    }

    /**
     * Returns count of '_apply_rewards' list
     *
     * @return int
     */
    public function getApplyRewardsCount()
    {
        return $this->count(self::_APPLY_REWARDS);
    }

    /**
     * Sets value of '_stage_old_progress' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStageOldProgress($value)
    {
        return $this->set(self::_STAGE_OLD_PROGRESS, $value);
    }

    /**
     * Returns value of '_stage_old_progress' property
     *
     * @return int
     */
    public function getStageOldProgress()
    {
        return $this->get(self::_STAGE_OLD_PROGRESS);
    }

    /**
     * Sets value of '_join_times' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setJoinTimes($value)
    {
        return $this->set(self::_JOIN_TIMES, $value);
    }

    /**
     * Returns value of '_join_times' property
     *
     * @return int
     */
    public function getJoinTimes()
    {
        return $this->get(self::_JOIN_TIMES);
    }

    /**
     * Sets value of '_break_history' property
     *
     * @param Down_BreakHistory $value Property value
     *
     * @return null
     */
    public function setBreakHistory(Down_BreakHistory $value)
    {
        return $this->set(self::_BREAK_HISTORY, $value);
    }

    /**
     * Returns value of '_break_history' property
     *
     * @return Down_BreakHistory
     */
    public function getBreakHistory()
    {
        return $this->get(self::_BREAK_HISTORY);
    }
}

/**
 * break_history message
 */
class Down_BreakHistory extends \ProtobufMessage
{
    /* Field index constants */
    const _DIAMOND = 1;
    const _GUILDPOINT = 2;
    const _DPS = 3;
    const _OLD_DPS = 4;
    const _OLD_SUMMARY = 5;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_DIAMOND => array(
            'name' => '_diamond',
            'required' => true,
            'type' => 5,
        ),
        self::_GUILDPOINT => array(
            'name' => '_guildpoint',
            'required' => true,
            'type' => 5,
        ),
        self::_DPS => array(
            'name' => '_dps',
            'required' => true,
            'type' => 5,
        ),
        self::_OLD_DPS => array(
            'name' => '_old_dps',
            'required' => false,
            'type' => 5,
        ),
        self::_OLD_SUMMARY => array(
            'name' => '_old_summary',
            'required' => false,
            'type' => 'Down_UserSummary'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_DIAMOND] = null;
        $this->values[self::_GUILDPOINT] = null;
        $this->values[self::_DPS] = null;
        $this->values[self::_OLD_DPS] = null;
        $this->values[self::_OLD_SUMMARY] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_diamond' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setDiamond($value)
    {
        return $this->set(self::_DIAMOND, $value);
    }

    /**
     * Returns value of '_diamond' property
     *
     * @return int
     */
    public function getDiamond()
    {
        return $this->get(self::_DIAMOND);
    }

    /**
     * Sets value of '_guildpoint' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setGuildpoint($value)
    {
        return $this->set(self::_GUILDPOINT, $value);
    }

    /**
     * Returns value of '_guildpoint' property
     *
     * @return int
     */
    public function getGuildpoint()
    {
        return $this->get(self::_GUILDPOINT);
    }

    /**
     * Sets value of '_dps' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setDps($value)
    {
        return $this->set(self::_DPS, $value);
    }

    /**
     * Returns value of '_dps' property
     *
     * @return int
     */
    public function getDps()
    {
        return $this->get(self::_DPS);
    }

    /**
     * Sets value of '_old_dps' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setOldDps($value)
    {
        return $this->set(self::_OLD_DPS, $value);
    }

    /**
     * Returns value of '_old_dps' property
     *
     * @return int
     */
    public function getOldDps()
    {
        return $this->get(self::_OLD_DPS);
    }

    /**
     * Sets value of '_old_summary' property
     *
     * @param Down_UserSummary $value Property value
     *
     * @return null
     */
    public function setOldSummary(Down_UserSummary $value)
    {
        return $this->set(self::_OLD_SUMMARY, $value);
    }

    /**
     * Returns value of '_old_summary' property
     *
     * @return Down_UserSummary
     */
    public function getOldSummary()
    {
        return $this->get(self::_OLD_SUMMARY);
    }
}

/**
 * guild_instance_open message
 */
class Down_GuildInstanceOpen extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _RAID_ID = 2;
    const _LEFT_TIME = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_RAID_ID => array(
            'name' => '_raid_id',
            'required' => true,
            'type' => 5,
        ),
        self::_LEFT_TIME => array(
            'name' => '_left_time',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_RAID_ID] = null;
        $this->values[self::_LEFT_TIME] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_raid_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRaidId($value)
    {
        return $this->set(self::_RAID_ID, $value);
    }

    /**
     * Returns value of '_raid_id' property
     *
     * @return int
     */
    public function getRaidId()
    {
        return $this->get(self::_RAID_ID);
    }

    /**
     * Sets value of '_left_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLeftTime($value)
    {
        return $this->set(self::_LEFT_TIME, $value);
    }

    /**
     * Returns value of '_left_time' property
     *
     * @return int
     */
    public function getLeftTime()
    {
        return $this->get(self::_LEFT_TIME);
    }
}

/**
 * guild_create message
 */
class Down_GuildCreate extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _GUILD_INFO = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_GUILD_INFO => array(
            'name' => '_guild_info',
            'required' => false,
            'type' => 'Down_GuildInfo'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_GUILD_INFO] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_guild_info' property
     *
     * @param Down_GuildInfo $value Property value
     *
     * @return null
     */
    public function setGuildInfo(Down_GuildInfo $value)
    {
        return $this->set(self::_GUILD_INFO, $value);
    }

    /**
     * Returns value of '_guild_info' property
     *
     * @return Down_GuildInfo
     */
    public function getGuildInfo()
    {
        return $this->get(self::_GUILD_INFO);
    }
}

/**
 * guild_dismiss message
 */
class Down_GuildDismiss extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }
}

/**
 * guild_info message
 */
class Down_GuildInfo extends \ProtobufMessage
{
    /* Field index constants */
    const _SUMMARY = 1;
    const _MEMBERS = 2;
    const _APPLIERS = 3;
    const _VITALITY = 4;
    const _SELF_VITALITY = 5;
    const _LEFT_DISTRIBUTE_TIME = 6;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_SUMMARY => array(
            'name' => '_summary',
            'required' => true,
            'type' => 'Down_GuildSummary'
        ),
        self::_MEMBERS => array(
            'name' => '_members',
            'repeated' => true,
            'type' => 'Down_GuildMember'
        ),
        self::_APPLIERS => array(
            'name' => '_appliers',
            'repeated' => true,
            'type' => 'Down_GuildApplier'
        ),
        self::_VITALITY => array(
            'name' => '_vitality',
            'required' => true,
            'type' => 5,
        ),
        self::_SELF_VITALITY => array(
            'name' => '_self_vitality',
            'required' => true,
            'type' => 5,
        ),
        self::_LEFT_DISTRIBUTE_TIME => array(
            'name' => '_left_distribute_time',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_SUMMARY] = null;
        $this->values[self::_MEMBERS] = array();
        $this->values[self::_APPLIERS] = array();
        $this->values[self::_VITALITY] = null;
        $this->values[self::_SELF_VITALITY] = null;
        $this->values[self::_LEFT_DISTRIBUTE_TIME] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_summary' property
     *
     * @param Down_GuildSummary $value Property value
     *
     * @return null
     */
    public function setSummary(Down_GuildSummary $value)
    {
        return $this->set(self::_SUMMARY, $value);
    }

    /**
     * Returns value of '_summary' property
     *
     * @return Down_GuildSummary
     */
    public function getSummary()
    {
        return $this->get(self::_SUMMARY);
    }

    /**
     * Appends value to '_members' list
     *
     * @param Down_GuildMember $value Value to append
     *
     * @return null
     */
    public function appendMembers(Down_GuildMember $value)
    {
        return $this->append(self::_MEMBERS, $value);
    }

    /**
     * Clears '_members' list
     *
     * @return null
     */
    public function clearMembers()
    {
        return $this->clear(self::_MEMBERS);
    }

    /**
     * Returns '_members' list
     *
     * @return Down_GuildMember[]
     */
    public function getMembers()
    {
        return $this->get(self::_MEMBERS);
    }

    /**
     * Returns '_members' iterator
     *
     * @return ArrayIterator
     */
    public function getMembersIterator()
    {
        return new \ArrayIterator($this->get(self::_MEMBERS));
    }

    /**
     * Returns element from '_members' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_GuildMember
     */
    public function getMembersAt($offset)
    {
        return $this->get(self::_MEMBERS, $offset);
    }

    /**
     * Returns count of '_members' list
     *
     * @return int
     */
    public function getMembersCount()
    {
        return $this->count(self::_MEMBERS);
    }

    /**
     * Appends value to '_appliers' list
     *
     * @param Down_GuildApplier $value Value to append
     *
     * @return null
     */
    public function appendAppliers(Down_GuildApplier $value)
    {
        return $this->append(self::_APPLIERS, $value);
    }

    /**
     * Clears '_appliers' list
     *
     * @return null
     */
    public function clearAppliers()
    {
        return $this->clear(self::_APPLIERS);
    }

    /**
     * Returns '_appliers' list
     *
     * @return Down_GuildApplier[]
     */
    public function getAppliers()
    {
        return $this->get(self::_APPLIERS);
    }

    /**
     * Returns '_appliers' iterator
     *
     * @return ArrayIterator
     */
    public function getAppliersIterator()
    {
        return new \ArrayIterator($this->get(self::_APPLIERS));
    }

    /**
     * Returns element from '_appliers' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_GuildApplier
     */
    public function getAppliersAt($offset)
    {
        return $this->get(self::_APPLIERS, $offset);
    }

    /**
     * Returns count of '_appliers' list
     *
     * @return int
     */
    public function getAppliersCount()
    {
        return $this->count(self::_APPLIERS);
    }

    /**
     * Sets value of '_vitality' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setVitality($value)
    {
        return $this->set(self::_VITALITY, $value);
    }

    /**
     * Returns value of '_vitality' property
     *
     * @return int
     */
    public function getVitality()
    {
        return $this->get(self::_VITALITY);
    }

    /**
     * Sets value of '_self_vitality' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSelfVitality($value)
    {
        return $this->set(self::_SELF_VITALITY, $value);
    }

    /**
     * Returns value of '_self_vitality' property
     *
     * @return int
     */
    public function getSelfVitality()
    {
        return $this->get(self::_SELF_VITALITY);
    }

    /**
     * Sets value of '_left_distribute_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLeftDistributeTime($value)
    {
        return $this->set(self::_LEFT_DISTRIBUTE_TIME, $value);
    }

    /**
     * Returns value of '_left_distribute_time' property
     *
     * @return int
     */
    public function getLeftDistributeTime()
    {
        return $this->get(self::_LEFT_DISTRIBUTE_TIME);
    }
}

/**
 * guild_summary message
 */
class Down_GuildSummary extends \ProtobufMessage
{
    /* Field index constants */
    const _ID = 1;
    const _NAME = 2;
    const _AVATAR = 3;
    const _SLOGAN = 4;
    const _JOIN_TYPE = 5;
    const _JOIN_LIMIT = 6;
    const _MEMBER_CNT = 7;
    const _PRESIDENT = 8;
    const _LIVENESS = 9;
    const _CAN_JUMP = 10;
    const _HOST_ID = 11;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ID => array(
            'name' => '_id',
            'required' => true,
            'type' => 5,
        ),
        self::_NAME => array(
            'name' => '_name',
            'required' => true,
            'type' => 7,
        ),
        self::_AVATAR => array(
            'name' => '_avatar',
            'required' => true,
            'type' => 5,
        ),
        self::_SLOGAN => array(
            'name' => '_slogan',
            'required' => true,
            'type' => 7,
        ),
        self::_JOIN_TYPE => array(
            'name' => '_join_type',
            'required' => true,
            'type' => 5,
        ),
        self::_JOIN_LIMIT => array(
            'name' => '_join_limit',
            'required' => true,
            'type' => 5,
        ),
        self::_MEMBER_CNT => array(
            'name' => '_member_cnt',
            'required' => true,
            'type' => 5,
        ),
        self::_PRESIDENT => array(
            'name' => '_president',
            'required' => true,
            'type' => 'Down_UserSummary'
        ),
        self::_LIVENESS => array(
            'name' => '_liveness',
            'required' => false,
            'type' => 5,
        ),
        self::_CAN_JUMP => array(
            'name' => '_can_jump',
            'required' => false,
            'type' => 5,
        ),
        self::_HOST_ID => array(
            'name' => '_host_id',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ID] = null;
        $this->values[self::_NAME] = null;
        $this->values[self::_AVATAR] = null;
        $this->values[self::_SLOGAN] = null;
        $this->values[self::_JOIN_TYPE] = null;
        $this->values[self::_JOIN_LIMIT] = null;
        $this->values[self::_MEMBER_CNT] = null;
        $this->values[self::_PRESIDENT] = null;
        $this->values[self::_LIVENESS] = null;
        $this->values[self::_CAN_JUMP] = null;
        $this->values[self::_HOST_ID] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setId($value)
    {
        return $this->set(self::_ID, $value);
    }

    /**
     * Returns value of '_id' property
     *
     * @return int
     */
    public function getId()
    {
        return $this->get(self::_ID);
    }

    /**
     * Sets value of '_name' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setName($value)
    {
        return $this->set(self::_NAME, $value);
    }

    /**
     * Returns value of '_name' property
     *
     * @return string
     */
    public function getName()
    {
        return $this->get(self::_NAME);
    }

    /**
     * Sets value of '_avatar' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setAvatar($value)
    {
        return $this->set(self::_AVATAR, $value);
    }

    /**
     * Returns value of '_avatar' property
     *
     * @return int
     */
    public function getAvatar()
    {
        return $this->get(self::_AVATAR);
    }

    /**
     * Sets value of '_slogan' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setSlogan($value)
    {
        return $this->set(self::_SLOGAN, $value);
    }

    /**
     * Returns value of '_slogan' property
     *
     * @return string
     */
    public function getSlogan()
    {
        return $this->get(self::_SLOGAN);
    }

    /**
     * Sets value of '_join_type' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setJoinType($value)
    {
        return $this->set(self::_JOIN_TYPE, $value);
    }

    /**
     * Returns value of '_join_type' property
     *
     * @return int
     */
    public function getJoinType()
    {
        return $this->get(self::_JOIN_TYPE);
    }

    /**
     * Sets value of '_join_limit' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setJoinLimit($value)
    {
        return $this->set(self::_JOIN_LIMIT, $value);
    }

    /**
     * Returns value of '_join_limit' property
     *
     * @return int
     */
    public function getJoinLimit()
    {
        return $this->get(self::_JOIN_LIMIT);
    }

    /**
     * Sets value of '_member_cnt' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setMemberCnt($value)
    {
        return $this->set(self::_MEMBER_CNT, $value);
    }

    /**
     * Returns value of '_member_cnt' property
     *
     * @return int
     */
    public function getMemberCnt()
    {
        return $this->get(self::_MEMBER_CNT);
    }

    /**
     * Sets value of '_president' property
     *
     * @param Down_UserSummary $value Property value
     *
     * @return null
     */
    public function setPresident(Down_UserSummary $value)
    {
        return $this->set(self::_PRESIDENT, $value);
    }

    /**
     * Returns value of '_president' property
     *
     * @return Down_UserSummary
     */
    public function getPresident()
    {
        return $this->get(self::_PRESIDENT);
    }

    /**
     * Sets value of '_liveness' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLiveness($value)
    {
        return $this->set(self::_LIVENESS, $value);
    }

    /**
     * Returns value of '_liveness' property
     *
     * @return int
     */
    public function getLiveness()
    {
        return $this->get(self::_LIVENESS);
    }

    /**
     * Sets value of '_can_jump' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCanJump($value)
    {
        return $this->set(self::_CAN_JUMP, $value);
    }

    /**
     * Returns value of '_can_jump' property
     *
     * @return int
     */
    public function getCanJump()
    {
        return $this->get(self::_CAN_JUMP);
    }

    /**
     * Sets value of '_host_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setHostId($value)
    {
        return $this->set(self::_HOST_ID, $value);
    }

    /**
     * Returns value of '_host_id' property
     *
     * @return int
     */
    public function getHostId()
    {
        return $this->get(self::_HOST_ID);
    }
}

/**
 * guild_member message
 */
class Down_GuildMember extends \ProtobufMessage
{
    /* Field index constants */
    const _UID = 1;
    const _SUMMARY = 2;
    const _JOB = 3;
    const _LAST_LOGIN = 4;
    const _ACTIVE = 5;
    const _JOIN_INSTANCE_TIME = 6;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_UID => array(
            'name' => '_uid',
            'required' => true,
            'type' => 5,
        ),
        self::_SUMMARY => array(
            'name' => '_summary',
            'required' => true,
            'type' => 'Down_UserSummary'
        ),
        self::_JOB => array(
            'name' => '_job',
            'required' => true,
            'type' => 5,
        ),
        self::_LAST_LOGIN => array(
            'name' => '_last_login',
            'required' => true,
            'type' => 5,
        ),
        self::_ACTIVE => array(
            'name' => '_active',
            'required' => false,
            'type' => 5,
        ),
        self::_JOIN_INSTANCE_TIME => array(
            'name' => '_join_instance_time',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_UID] = null;
        $this->values[self::_SUMMARY] = null;
        $this->values[self::_JOB] = null;
        $this->values[self::_LAST_LOGIN] = null;
        $this->values[self::_ACTIVE] = null;
        $this->values[self::_JOIN_INSTANCE_TIME] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_uid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setUid($value)
    {
        return $this->set(self::_UID, $value);
    }

    /**
     * Returns value of '_uid' property
     *
     * @return int
     */
    public function getUid()
    {
        return $this->get(self::_UID);
    }

    /**
     * Sets value of '_summary' property
     *
     * @param Down_UserSummary $value Property value
     *
     * @return null
     */
    public function setSummary(Down_UserSummary $value)
    {
        return $this->set(self::_SUMMARY, $value);
    }

    /**
     * Returns value of '_summary' property
     *
     * @return Down_UserSummary
     */
    public function getSummary()
    {
        return $this->get(self::_SUMMARY);
    }

    /**
     * Sets value of '_job' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setJob($value)
    {
        return $this->set(self::_JOB, $value);
    }

    /**
     * Returns value of '_job' property
     *
     * @return int
     */
    public function getJob()
    {
        return $this->get(self::_JOB);
    }

    /**
     * Sets value of '_last_login' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLastLogin($value)
    {
        return $this->set(self::_LAST_LOGIN, $value);
    }

    /**
     * Returns value of '_last_login' property
     *
     * @return int
     */
    public function getLastLogin()
    {
        return $this->get(self::_LAST_LOGIN);
    }

    /**
     * Sets value of '_active' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setActive($value)
    {
        return $this->set(self::_ACTIVE, $value);
    }

    /**
     * Returns value of '_active' property
     *
     * @return int
     */
    public function getActive()
    {
        return $this->get(self::_ACTIVE);
    }

    /**
     * Sets value of '_join_instance_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setJoinInstanceTime($value)
    {
        return $this->set(self::_JOIN_INSTANCE_TIME, $value);
    }

    /**
     * Returns value of '_join_instance_time' property
     *
     * @return int
     */
    public function getJoinInstanceTime()
    {
        return $this->get(self::_JOIN_INSTANCE_TIME);
    }
}

/**
 * guild_applier message
 */
class Down_GuildApplier extends \ProtobufMessage
{
    /* Field index constants */
    const _UID = 1;
    const _USER_SUMMARY = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_UID => array(
            'name' => '_uid',
            'required' => true,
            'type' => 5,
        ),
        self::_USER_SUMMARY => array(
            'name' => '_user_summary',
            'required' => false,
            'type' => 'Down_UserSummary'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_UID] = null;
        $this->values[self::_USER_SUMMARY] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_uid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setUid($value)
    {
        return $this->set(self::_UID, $value);
    }

    /**
     * Returns value of '_uid' property
     *
     * @return int
     */
    public function getUid()
    {
        return $this->get(self::_UID);
    }

    /**
     * Sets value of '_user_summary' property
     *
     * @param Down_UserSummary $value Property value
     *
     * @return null
     */
    public function setUserSummary(Down_UserSummary $value)
    {
        return $this->set(self::_USER_SUMMARY, $value);
    }

    /**
     * Returns value of '_user_summary' property
     *
     * @return Down_UserSummary
     */
    public function getUserSummary()
    {
        return $this->get(self::_USER_SUMMARY);
    }
}

/**
 * guild_list message
 */
class Down_GuildList extends \ProtobufMessage
{
    /* Field index constants */
    const _GUILDS = 1;
    const _RESULT = 2;
    const _CREATE_COST = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_GUILDS => array(
            'name' => '_guilds',
            'repeated' => true,
            'type' => 'Down_GuildSummary'
        ),
        self::_RESULT => array(
            'default' => Down_Result::success, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_CREATE_COST => array(
            'name' => '_create_cost',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_GUILDS] = array();
        $this->values[self::_RESULT] = null;
        $this->values[self::_CREATE_COST] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_guilds' list
     *
     * @param Down_GuildSummary $value Value to append
     *
     * @return null
     */
    public function appendGuilds(Down_GuildSummary $value)
    {
        return $this->append(self::_GUILDS, $value);
    }

    /**
     * Clears '_guilds' list
     *
     * @return null
     */
    public function clearGuilds()
    {
        return $this->clear(self::_GUILDS);
    }

    /**
     * Returns '_guilds' list
     *
     * @return Down_GuildSummary[]
     */
    public function getGuilds()
    {
        return $this->get(self::_GUILDS);
    }

    /**
     * Returns '_guilds' iterator
     *
     * @return ArrayIterator
     */
    public function getGuildsIterator()
    {
        return new \ArrayIterator($this->get(self::_GUILDS));
    }

    /**
     * Returns element from '_guilds' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_GuildSummary
     */
    public function getGuildsAt($offset)
    {
        return $this->get(self::_GUILDS, $offset);
    }

    /**
     * Returns count of '_guilds' list
     *
     * @return int
     */
    public function getGuildsCount()
    {
        return $this->count(self::_GUILDS);
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_create_cost' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCreateCost($value)
    {
        return $this->set(self::_CREATE_COST, $value);
    }

    /**
     * Returns value of '_create_cost' property
     *
     * @return int
     */
    public function getCreateCost()
    {
        return $this->get(self::_CREATE_COST);
    }
}

/**
 * guild_search message
 */
class Down_GuildSearch extends \ProtobufMessage
{
    /* Field index constants */
    const _GUILDS = 1;
    const _RESULT = 2;
    const _CREATE_COST = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_GUILDS => array(
            'name' => '_guilds',
            'required' => false,
            'type' => 'Down_GuildSummary'
        ),
        self::_RESULT => array(
            'default' => Down_Result::success, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_CREATE_COST => array(
            'name' => '_create_cost',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_GUILDS] = null;
        $this->values[self::_RESULT] = null;
        $this->values[self::_CREATE_COST] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_guilds' property
     *
     * @param Down_GuildSummary $value Property value
     *
     * @return null
     */
    public function setGuilds(Down_GuildSummary $value)
    {
        return $this->set(self::_GUILDS, $value);
    }

    /**
     * Returns value of '_guilds' property
     *
     * @return Down_GuildSummary
     */
    public function getGuilds()
    {
        return $this->get(self::_GUILDS);
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_create_cost' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCreateCost($value)
    {
        return $this->set(self::_CREATE_COST, $value);
    }

    /**
     * Returns value of '_create_cost' property
     *
     * @return int
     */
    public function getCreateCost()
    {
        return $this->get(self::_CREATE_COST);
    }
}

/**
 * join_result enum embedded in guild_join message
 */
final class Down_GuildJoin_JoinResult
{
    const join_fail = 0;
    const join_enter = 1;
    const join_wait = 2;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'join_fail' => self::join_fail,
            'join_enter' => self::join_enter,
            'join_wait' => self::join_wait,
        );
    }
}

/**
 * guild_join message
 */
class Down_GuildJoin extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _JOIN_GUILD_ID = 2;
    const _GUILD_INFO = 3;
    const _CD_TIME = 4;
    const _FAIL_REASON = 5;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_JOIN_GUILD_ID => array(
            'name' => '_join_guild_id',
            'required' => true,
            'type' => 5,
        ),
        self::_GUILD_INFO => array(
            'name' => '_guild_info',
            'required' => false,
            'type' => 'Down_GuildInfo'
        ),
        self::_CD_TIME => array(
            'name' => '_cd_time',
            'required' => false,
            'type' => 5,
        ),
        self::_FAIL_REASON => array(
            'name' => '_fail_reason',
            'required' => false,
            'type' => 7,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_JOIN_GUILD_ID] = null;
        $this->values[self::_GUILD_INFO] = null;
        $this->values[self::_CD_TIME] = null;
        $this->values[self::_FAIL_REASON] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_join_guild_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setJoinGuildId($value)
    {
        return $this->set(self::_JOIN_GUILD_ID, $value);
    }

    /**
     * Returns value of '_join_guild_id' property
     *
     * @return int
     */
    public function getJoinGuildId()
    {
        return $this->get(self::_JOIN_GUILD_ID);
    }

    /**
     * Sets value of '_guild_info' property
     *
     * @param Down_GuildInfo $value Property value
     *
     * @return null
     */
    public function setGuildInfo(Down_GuildInfo $value)
    {
        return $this->set(self::_GUILD_INFO, $value);
    }

    /**
     * Returns value of '_guild_info' property
     *
     * @return Down_GuildInfo
     */
    public function getGuildInfo()
    {
        return $this->get(self::_GUILD_INFO);
    }

    /**
     * Sets value of '_cd_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCdTime($value)
    {
        return $this->set(self::_CD_TIME, $value);
    }

    /**
     * Returns value of '_cd_time' property
     *
     * @return int
     */
    public function getCdTime()
    {
        return $this->get(self::_CD_TIME);
    }

    /**
     * Sets value of '_fail_reason' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setFailReason($value)
    {
        return $this->set(self::_FAIL_REASON, $value);
    }

    /**
     * Returns value of '_fail_reason' property
     *
     * @return string
     */
    public function getFailReason()
    {
        return $this->get(self::_FAIL_REASON);
    }
}

/**
 * guild_join_confirm message
 */
class Down_GuildJoinConfirm extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _NEW_MAN = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_NEW_MAN => array(
            'name' => '_new_man',
            'required' => false,
            'type' => 'Down_GuildMember'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_NEW_MAN] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_new_man' property
     *
     * @param Down_GuildMember $value Property value
     *
     * @return null
     */
    public function setNewMan(Down_GuildMember $value)
    {
        return $this->set(self::_NEW_MAN, $value);
    }

    /**
     * Returns value of '_new_man' property
     *
     * @return Down_GuildMember
     */
    public function getNewMan()
    {
        return $this->get(self::_NEW_MAN);
    }
}

/**
 * guild_leave message
 */
class Down_GuildLeave extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }
}

/**
 * guild_kick message
 */
class Down_GuildKick extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }
}

/**
 * guild_set message
 */
class Down_GuildSet extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }
}

/**
 * guild_query message
 */
class Down_GuildQuery extends \ProtobufMessage
{
    /* Field index constants */
    const _INFO = 1;
    const _WORSHIP = 2;
    const _DROP_INFO = 3;
    const _TO_CHAIRMAN = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_INFO => array(
            'name' => '_info',
            'required' => false,
            'type' => 'Down_GuildInfo'
        ),
        self::_WORSHIP => array(
            'name' => '_worship',
            'required' => false,
            'type' => 'Down_GuildWorship'
        ),
        self::_DROP_INFO => array(
            'name' => '_drop_info',
            'required' => false,
            'type' => 5,
        ),
        self::_TO_CHAIRMAN => array(
            'name' => '_to_chairman',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_INFO] = null;
        $this->values[self::_WORSHIP] = null;
        $this->values[self::_DROP_INFO] = null;
        $this->values[self::_TO_CHAIRMAN] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_info' property
     *
     * @param Down_GuildInfo $value Property value
     *
     * @return null
     */
    public function setInfo(Down_GuildInfo $value)
    {
        return $this->set(self::_INFO, $value);
    }

    /**
     * Returns value of '_info' property
     *
     * @return Down_GuildInfo
     */
    public function getInfo()
    {
        return $this->get(self::_INFO);
    }

    /**
     * Sets value of '_worship' property
     *
     * @param Down_GuildWorship $value Property value
     *
     * @return null
     */
    public function setWorship(Down_GuildWorship $value)
    {
        return $this->set(self::_WORSHIP, $value);
    }

    /**
     * Returns value of '_worship' property
     *
     * @return Down_GuildWorship
     */
    public function getWorship()
    {
        return $this->get(self::_WORSHIP);
    }

    /**
     * Sets value of '_drop_info' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setDropInfo($value)
    {
        return $this->set(self::_DROP_INFO, $value);
    }

    /**
     * Returns value of '_drop_info' property
     *
     * @return int
     */
    public function getDropInfo()
    {
        return $this->get(self::_DROP_INFO);
    }

    /**
     * Sets value of '_to_chairman' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setToChairman($value)
    {
        return $this->set(self::_TO_CHAIRMAN, $value);
    }

    /**
     * Returns value of '_to_chairman' property
     *
     * @return int
     */
    public function getToChairman()
    {
        return $this->get(self::_TO_CHAIRMAN);
    }
}

/**
 * guild_worship message
 */
class Down_GuildWorship extends \ProtobufMessage
{
    /* Field index constants */
    const _USE_TIMES = 1;
    const _REWARDS = 2;
    const _TIMES = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_USE_TIMES => array(
            'name' => '_use_times',
            'required' => true,
            'type' => 5,
        ),
        self::_REWARDS => array(
            'name' => '_rewards',
            'repeated' => true,
            'type' => 'Down_WorshipReward'
        ),
        self::_TIMES => array(
            'name' => '_times',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_USE_TIMES] = null;
        $this->values[self::_REWARDS] = array();
        $this->values[self::_TIMES] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_use_times' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setUseTimes($value)
    {
        return $this->set(self::_USE_TIMES, $value);
    }

    /**
     * Returns value of '_use_times' property
     *
     * @return int
     */
    public function getUseTimes()
    {
        return $this->get(self::_USE_TIMES);
    }

    /**
     * Appends value to '_rewards' list
     *
     * @param Down_WorshipReward $value Value to append
     *
     * @return null
     */
    public function appendRewards(Down_WorshipReward $value)
    {
        return $this->append(self::_REWARDS, $value);
    }

    /**
     * Clears '_rewards' list
     *
     * @return null
     */
    public function clearRewards()
    {
        return $this->clear(self::_REWARDS);
    }

    /**
     * Returns '_rewards' list
     *
     * @return Down_WorshipReward[]
     */
    public function getRewards()
    {
        return $this->get(self::_REWARDS);
    }

    /**
     * Returns '_rewards' iterator
     *
     * @return ArrayIterator
     */
    public function getRewardsIterator()
    {
        return new \ArrayIterator($this->get(self::_REWARDS));
    }

    /**
     * Returns element from '_rewards' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_WorshipReward
     */
    public function getRewardsAt($offset)
    {
        return $this->get(self::_REWARDS, $offset);
    }

    /**
     * Returns count of '_rewards' list
     *
     * @return int
     */
    public function getRewardsCount()
    {
        return $this->count(self::_REWARDS);
    }

    /**
     * Sets value of '_times' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setTimes($value)
    {
        return $this->set(self::_TIMES, $value);
    }

    /**
     * Returns value of '_times' property
     *
     * @return int
     */
    public function getTimes()
    {
        return $this->get(self::_TIMES);
    }
}

/**
 * guild_set_job message
 */
class Down_GuildSetJob extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }
}

/**
 * guild_add_hire message
 */
class Down_GuildAddHire extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _INCOME = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_INCOME => array(
            'name' => '_income',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_INCOME] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_income' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setIncome($value)
    {
        return $this->set(self::_INCOME, $value);
    }

    /**
     * Returns value of '_income' property
     *
     * @return int
     */
    public function getIncome()
    {
        return $this->get(self::_INCOME);
    }
}

/**
 * guild_del_hire message
 */
class Down_GuildDelHire extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _HIRE_REWARD = 2;
    const _STAY_REWARD = 3;
    const _HEROID = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_HIRE_REWARD => array(
            'name' => '_hire_reward',
            'required' => false,
            'type' => 5,
        ),
        self::_STAY_REWARD => array(
            'name' => '_stay_reward',
            'required' => false,
            'type' => 5,
        ),
        self::_HEROID => array(
            'name' => '_heroid',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_HIRE_REWARD] = null;
        $this->values[self::_STAY_REWARD] = null;
        $this->values[self::_HEROID] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_hire_reward' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setHireReward($value)
    {
        return $this->set(self::_HIRE_REWARD, $value);
    }

    /**
     * Returns value of '_hire_reward' property
     *
     * @return int
     */
    public function getHireReward()
    {
        return $this->get(self::_HIRE_REWARD);
    }

    /**
     * Sets value of '_stay_reward' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStayReward($value)
    {
        return $this->set(self::_STAY_REWARD, $value);
    }

    /**
     * Returns value of '_stay_reward' property
     *
     * @return int
     */
    public function getStayReward()
    {
        return $this->get(self::_STAY_REWARD);
    }

    /**
     * Sets value of '_heroid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setHeroid($value)
    {
        return $this->set(self::_HEROID, $value);
    }

    /**
     * Returns value of '_heroid' property
     *
     * @return int
     */
    public function getHeroid()
    {
        return $this->get(self::_HEROID);
    }
}

/**
 * guild_query_hires message
 */
class Down_GuildQueryHires extends \ProtobufMessage
{
    /* Field index constants */
    const _USERS = 1;
    const _HIRE_UIDS = 2;
    const _FROM = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_USERS => array(
            'name' => '_users',
            'repeated' => true,
            'type' => 'Down_GuildHireUser'
        ),
        self::_HIRE_UIDS => array(
            'name' => '_hire_uids',
            'repeated' => true,
            'type' => 5,
        ),
        self::_FROM => array(
            'name' => '_from',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_USERS] = array();
        $this->values[self::_HIRE_UIDS] = array();
        $this->values[self::_FROM] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_users' list
     *
     * @param Down_GuildHireUser $value Value to append
     *
     * @return null
     */
    public function appendUsers(Down_GuildHireUser $value)
    {
        return $this->append(self::_USERS, $value);
    }

    /**
     * Clears '_users' list
     *
     * @return null
     */
    public function clearUsers()
    {
        return $this->clear(self::_USERS);
    }

    /**
     * Returns '_users' list
     *
     * @return Down_GuildHireUser[]
     */
    public function getUsers()
    {
        return $this->get(self::_USERS);
    }

    /**
     * Returns '_users' iterator
     *
     * @return ArrayIterator
     */
    public function getUsersIterator()
    {
        return new \ArrayIterator($this->get(self::_USERS));
    }

    /**
     * Returns element from '_users' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_GuildHireUser
     */
    public function getUsersAt($offset)
    {
        return $this->get(self::_USERS, $offset);
    }

    /**
     * Returns count of '_users' list
     *
     * @return int
     */
    public function getUsersCount()
    {
        return $this->count(self::_USERS);
    }

    /**
     * Appends value to '_hire_uids' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendHireUids($value)
    {
        return $this->append(self::_HIRE_UIDS, $value);
    }

    /**
     * Clears '_hire_uids' list
     *
     * @return null
     */
    public function clearHireUids()
    {
        return $this->clear(self::_HIRE_UIDS);
    }

    /**
     * Returns '_hire_uids' list
     *
     * @return int[]
     */
    public function getHireUids()
    {
        return $this->get(self::_HIRE_UIDS);
    }

    /**
     * Returns '_hire_uids' iterator
     *
     * @return ArrayIterator
     */
    public function getHireUidsIterator()
    {
        return new \ArrayIterator($this->get(self::_HIRE_UIDS));
    }

    /**
     * Returns element from '_hire_uids' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getHireUidsAt($offset)
    {
        return $this->get(self::_HIRE_UIDS, $offset);
    }

    /**
     * Returns count of '_hire_uids' list
     *
     * @return int
     */
    public function getHireUidsCount()
    {
        return $this->count(self::_HIRE_UIDS);
    }

    /**
     * Sets value of '_from' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setFrom($value)
    {
        return $this->set(self::_FROM, $value);
    }

    /**
     * Returns value of '_from' property
     *
     * @return int
     */
    public function getFrom()
    {
        return $this->get(self::_FROM);
    }
}

/**
 * guild_hire_user message
 */
class Down_GuildHireUser extends \ProtobufMessage
{
    /* Field index constants */
    const _UID = 1;
    const _NAME = 2;
    const _LEVEL = 3;
    const _AVATAR = 4;
    const _HEROES = 5;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_UID => array(
            'name' => '_uid',
            'required' => true,
            'type' => 5,
        ),
        self::_NAME => array(
            'name' => '_name',
            'required' => true,
            'type' => 7,
        ),
        self::_LEVEL => array(
            'name' => '_level',
            'required' => true,
            'type' => 5,
        ),
        self::_AVATAR => array(
            'name' => '_avatar',
            'required' => true,
            'type' => 5,
        ),
        self::_HEROES => array(
            'name' => '_heroes',
            'repeated' => true,
            'type' => 'Down_HireHeroSummary'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_UID] = null;
        $this->values[self::_NAME] = null;
        $this->values[self::_LEVEL] = null;
        $this->values[self::_AVATAR] = null;
        $this->values[self::_HEROES] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_uid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setUid($value)
    {
        return $this->set(self::_UID, $value);
    }

    /**
     * Returns value of '_uid' property
     *
     * @return int
     */
    public function getUid()
    {
        return $this->get(self::_UID);
    }

    /**
     * Sets value of '_name' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setName($value)
    {
        return $this->set(self::_NAME, $value);
    }

    /**
     * Returns value of '_name' property
     *
     * @return string
     */
    public function getName()
    {
        return $this->get(self::_NAME);
    }

    /**
     * Sets value of '_level' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLevel($value)
    {
        return $this->set(self::_LEVEL, $value);
    }

    /**
     * Returns value of '_level' property
     *
     * @return int
     */
    public function getLevel()
    {
        return $this->get(self::_LEVEL);
    }

    /**
     * Sets value of '_avatar' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setAvatar($value)
    {
        return $this->set(self::_AVATAR, $value);
    }

    /**
     * Returns value of '_avatar' property
     *
     * @return int
     */
    public function getAvatar()
    {
        return $this->get(self::_AVATAR);
    }

    /**
     * Appends value to '_heroes' list
     *
     * @param Down_HireHeroSummary $value Value to append
     *
     * @return null
     */
    public function appendHeroes(Down_HireHeroSummary $value)
    {
        return $this->append(self::_HEROES, $value);
    }

    /**
     * Clears '_heroes' list
     *
     * @return null
     */
    public function clearHeroes()
    {
        return $this->clear(self::_HEROES);
    }

    /**
     * Returns '_heroes' list
     *
     * @return Down_HireHeroSummary[]
     */
    public function getHeroes()
    {
        return $this->get(self::_HEROES);
    }

    /**
     * Returns '_heroes' iterator
     *
     * @return ArrayIterator
     */
    public function getHeroesIterator()
    {
        return new \ArrayIterator($this->get(self::_HEROES));
    }

    /**
     * Returns element from '_heroes' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_HireHeroSummary
     */
    public function getHeroesAt($offset)
    {
        return $this->get(self::_HEROES, $offset);
    }

    /**
     * Returns count of '_heroes' list
     *
     * @return int
     */
    public function getHeroesCount()
    {
        return $this->count(self::_HEROES);
    }
}

/**
 * hire_hero_summary message
 */
class Down_HireHeroSummary extends \ProtobufMessage
{
    /* Field index constants */
    const _HERO = 1;
    const _COST = 2;
    const _INCOME = 3;
    const _HIRE_TS = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_HERO => array(
            'name' => '_hero',
            'required' => true,
            'type' => 'Down_HeroSummary'
        ),
        self::_COST => array(
            'name' => '_cost',
            'required' => true,
            'type' => 5,
        ),
        self::_INCOME => array(
            'name' => '_income',
            'required' => true,
            'type' => 5,
        ),
        self::_HIRE_TS => array(
            'name' => '_hire_ts',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_HERO] = null;
        $this->values[self::_COST] = null;
        $this->values[self::_INCOME] = null;
        $this->values[self::_HIRE_TS] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_hero' property
     *
     * @param Down_HeroSummary $value Property value
     *
     * @return null
     */
    public function setHero(Down_HeroSummary $value)
    {
        return $this->set(self::_HERO, $value);
    }

    /**
     * Returns value of '_hero' property
     *
     * @return Down_HeroSummary
     */
    public function getHero()
    {
        return $this->get(self::_HERO);
    }

    /**
     * Sets value of '_cost' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCost($value)
    {
        return $this->set(self::_COST, $value);
    }

    /**
     * Returns value of '_cost' property
     *
     * @return int
     */
    public function getCost()
    {
        return $this->get(self::_COST);
    }

    /**
     * Sets value of '_income' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setIncome($value)
    {
        return $this->set(self::_INCOME, $value);
    }

    /**
     * Returns value of '_income' property
     *
     * @return int
     */
    public function getIncome()
    {
        return $this->get(self::_INCOME);
    }

    /**
     * Sets value of '_hire_ts' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setHireTs($value)
    {
        return $this->set(self::_HIRE_TS, $value);
    }

    /**
     * Returns value of '_hire_ts' property
     *
     * @return int
     */
    public function getHireTs()
    {
        return $this->get(self::_HIRE_TS);
    }
}

/**
 * guild_hire_hero message
 */
class Down_GuildHireHero extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _FROM = 2;
    const _UID = 3;
    const _HERO = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_FROM => array(
            'name' => '_from',
            'required' => false,
            'type' => 5,
        ),
        self::_UID => array(
            'name' => '_uid',
            'required' => false,
            'type' => 5,
        ),
        self::_HERO => array(
            'name' => '_hero',
            'required' => false,
            'type' => 'Down_Hero'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_FROM] = null;
        $this->values[self::_UID] = null;
        $this->values[self::_HERO] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_from' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setFrom($value)
    {
        return $this->set(self::_FROM, $value);
    }

    /**
     * Returns value of '_from' property
     *
     * @return int
     */
    public function getFrom()
    {
        return $this->get(self::_FROM);
    }

    /**
     * Sets value of '_uid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setUid($value)
    {
        return $this->set(self::_UID, $value);
    }

    /**
     * Returns value of '_uid' property
     *
     * @return int
     */
    public function getUid()
    {
        return $this->get(self::_UID);
    }

    /**
     * Sets value of '_hero' property
     *
     * @param Down_Hero $value Property value
     *
     * @return null
     */
    public function setHero(Down_Hero $value)
    {
        return $this->set(self::_HERO, $value);
    }

    /**
     * Returns value of '_hero' property
     *
     * @return Down_Hero
     */
    public function getHero()
    {
        return $this->get(self::_HERO);
    }
}

/**
 * guild_worship_req message
 */
class Down_GuildWorshipReq extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }
}

/**
 * guild_worship_withdraw message
 */
class Down_GuildWorshipWithdraw extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _REWARDS = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_REWARDS => array(
            'name' => '_rewards',
            'repeated' => true,
            'type' => 'Down_WorshipReward'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_REWARDS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Appends value to '_rewards' list
     *
     * @param Down_WorshipReward $value Value to append
     *
     * @return null
     */
    public function appendRewards(Down_WorshipReward $value)
    {
        return $this->append(self::_REWARDS, $value);
    }

    /**
     * Clears '_rewards' list
     *
     * @return null
     */
    public function clearRewards()
    {
        return $this->clear(self::_REWARDS);
    }

    /**
     * Returns '_rewards' list
     *
     * @return Down_WorshipReward[]
     */
    public function getRewards()
    {
        return $this->get(self::_REWARDS);
    }

    /**
     * Returns '_rewards' iterator
     *
     * @return ArrayIterator
     */
    public function getRewardsIterator()
    {
        return new \ArrayIterator($this->get(self::_REWARDS));
    }

    /**
     * Returns element from '_rewards' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_WorshipReward
     */
    public function getRewardsAt($offset)
    {
        return $this->get(self::_REWARDS, $offset);
    }

    /**
     * Returns count of '_rewards' list
     *
     * @return int
     */
    public function getRewardsCount()
    {
        return $this->count(self::_REWARDS);
    }
}

/**
 * guild_qurey_hh_detail message
 */
class Down_GuildQureyHhDetail extends \ProtobufMessage
{
    /* Field index constants */
    const _HERO = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_HERO => array(
            'name' => '_hero',
            'required' => false,
            'type' => 'Down_Hero'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_HERO] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_hero' property
     *
     * @param Down_Hero $value Property value
     *
     * @return null
     */
    public function setHero(Down_Hero $value)
    {
        return $this->set(self::_HERO, $value);
    }

    /**
     * Returns value of '_hero' property
     *
     * @return Down_Hero
     */
    public function getHero()
    {
        return $this->get(self::_HERO);
    }
}

/**
 * type enum embedded in worship_reward message
 */
final class Down_WorshipReward_Type
{
    const gold = 1;
    const diamond = 2;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'gold' => self::gold,
            'diamond' => self::diamond,
        );
    }
}

/**
 * worship_reward message
 */
class Down_WorshipReward extends \ProtobufMessage
{
    /* Field index constants */
    const _TYPE = 1;
    const _PARAM1 = 2;
    const _PARAM2 = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TYPE => array(
            'name' => '_type',
            'required' => true,
            'type' => 5,
        ),
        self::_PARAM1 => array(
            'name' => '_param1',
            'required' => false,
            'type' => 5,
        ),
        self::_PARAM2 => array(
            'name' => '_param2',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_TYPE] = null;
        $this->values[self::_PARAM1] = null;
        $this->values[self::_PARAM2] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_type' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setType($value)
    {
        return $this->set(self::_TYPE, $value);
    }

    /**
     * Returns value of '_type' property
     *
     * @return int
     */
    public function getType()
    {
        return $this->get(self::_TYPE);
    }

    /**
     * Sets value of '_param1' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setParam1($value)
    {
        return $this->set(self::_PARAM1, $value);
    }

    /**
     * Returns value of '_param1' property
     *
     * @return int
     */
    public function getParam1()
    {
        return $this->get(self::_PARAM1);
    }

    /**
     * Sets value of '_param2' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setParam2($value)
    {
        return $this->set(self::_PARAM2, $value);
    }

    /**
     * Returns value of '_param2' property
     *
     * @return int
     */
    public function getParam2()
    {
        return $this->get(self::_PARAM2);
    }
}

/**
 * type enum embedded in activity_reward message
 */
final class Down_ActivityReward_Type
{
    const rmb = 1;
    const money = 2;
    const item = 3;
    const hero = 4;
    const rand_soul = 5;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'rmb' => self::rmb,
            'money' => self::money,
            'item' => self::item,
            'hero' => self::hero,
            'rand_soul' => self::rand_soul,
        );
    }
}

/**
 * activity_reward message
 */
class Down_ActivityReward extends \ProtobufMessage
{
    /* Field index constants */
    const _TYPE = 1;
    const _ID = 2;
    const _AMOUNT = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TYPE => array(
            'name' => '_type',
            'required' => false,
            'type' => 5,
        ),
        self::_ID => array(
            'name' => '_id',
            'required' => false,
            'type' => 5,
        ),
        self::_AMOUNT => array(
            'name' => '_amount',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_TYPE] = null;
        $this->values[self::_ID] = null;
        $this->values[self::_AMOUNT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_type' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setType($value)
    {
        return $this->set(self::_TYPE, $value);
    }

    /**
     * Returns value of '_type' property
     *
     * @return int
     */
    public function getType()
    {
        return $this->get(self::_TYPE);
    }

    /**
     * Sets value of '_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setId($value)
    {
        return $this->set(self::_ID, $value);
    }

    /**
     * Returns value of '_id' property
     *
     * @return int
     */
    public function getId()
    {
        return $this->get(self::_ID);
    }

    /**
     * Sets value of '_amount' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setAmount($value)
    {
        return $this->set(self::_AMOUNT, $value);
    }

    /**
     * Returns value of '_amount' property
     *
     * @return int
     */
    public function getAmount()
    {
        return $this->get(self::_AMOUNT);
    }
}

/**
 * activity_infos message
 */
class Down_ActivityInfos extends \ProtobufMessage
{
    /* Field index constants */
    const _ACTIVITY_INFO = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ACTIVITY_INFO => array(
            'name' => '_activity_info',
            'repeated' => true,
            'type' => 'Down_ActivityInfo'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ACTIVITY_INFO] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_activity_info' list
     *
     * @param Down_ActivityInfo $value Value to append
     *
     * @return null
     */
    public function appendActivityInfo(Down_ActivityInfo $value)
    {
        return $this->append(self::_ACTIVITY_INFO, $value);
    }

    /**
     * Clears '_activity_info' list
     *
     * @return null
     */
    public function clearActivityInfo()
    {
        return $this->clear(self::_ACTIVITY_INFO);
    }

    /**
     * Returns '_activity_info' list
     *
     * @return Down_ActivityInfo[]
     */
    public function getActivityInfo()
    {
        return $this->get(self::_ACTIVITY_INFO);
    }

    /**
     * Returns '_activity_info' iterator
     *
     * @return ArrayIterator
     */
    public function getActivityInfoIterator()
    {
        return new \ArrayIterator($this->get(self::_ACTIVITY_INFO));
    }

    /**
     * Returns element from '_activity_info' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_ActivityInfo
     */
    public function getActivityInfoAt($offset)
    {
        return $this->get(self::_ACTIVITY_INFO, $offset);
    }

    /**
     * Returns count of '_activity_info' list
     *
     * @return int
     */
    public function getActivityInfoCount()
    {
        return $this->count(self::_ACTIVITY_INFO);
    }
}

/**
 * activity_rewards message
 */
class Down_ActivityRewards extends \ProtobufMessage
{
    /* Field index constants */
    const _AMOUNT = 1;
    const _REWARDS = 2;
    const _DAILYJOB = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_AMOUNT => array(
            'name' => '_amount',
            'required' => false,
            'type' => 5,
        ),
        self::_REWARDS => array(
            'name' => '_rewards',
            'repeated' => true,
            'type' => 'Down_ActivityReward'
        ),
        self::_DAILYJOB => array(
            'name' => '_dailyjob',
            'required' => false,
            'type' => 'Down_Dailyjob'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_AMOUNT] = null;
        $this->values[self::_REWARDS] = array();
        $this->values[self::_DAILYJOB] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_amount' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setAmount($value)
    {
        return $this->set(self::_AMOUNT, $value);
    }

    /**
     * Returns value of '_amount' property
     *
     * @return int
     */
    public function getAmount()
    {
        return $this->get(self::_AMOUNT);
    }

    /**
     * Appends value to '_rewards' list
     *
     * @param Down_ActivityReward $value Value to append
     *
     * @return null
     */
    public function appendRewards(Down_ActivityReward $value)
    {
        return $this->append(self::_REWARDS, $value);
    }

    /**
     * Clears '_rewards' list
     *
     * @return null
     */
    public function clearRewards()
    {
        return $this->clear(self::_REWARDS);
    }

    /**
     * Returns '_rewards' list
     *
     * @return Down_ActivityReward[]
     */
    public function getRewards()
    {
        return $this->get(self::_REWARDS);
    }

    /**
     * Returns '_rewards' iterator
     *
     * @return ArrayIterator
     */
    public function getRewardsIterator()
    {
        return new \ArrayIterator($this->get(self::_REWARDS));
    }

    /**
     * Returns element from '_rewards' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_ActivityReward
     */
    public function getRewardsAt($offset)
    {
        return $this->get(self::_REWARDS, $offset);
    }

    /**
     * Returns count of '_rewards' list
     *
     * @return int
     */
    public function getRewardsCount()
    {
        return $this->count(self::_REWARDS);
    }

    /**
     * Sets value of '_dailyjob' property
     *
     * @param Down_Dailyjob $value Property value
     *
     * @return null
     */
    public function setDailyjob(Down_Dailyjob $value)
    {
        return $this->set(self::_DAILYJOB, $value);
    }

    /**
     * Returns value of '_dailyjob' property
     *
     * @return Down_Dailyjob
     */
    public function getDailyjob()
    {
        return $this->get(self::_DAILYJOB);
    }
}

/**
 * type enum embedded in activity_info message
 */
final class Down_ActivityInfo_Type
{
    const single_br_tavern = 1;
    const combo_br_tavern = 2;
    const single_gd_tavern = 3;
    const combo_gd_tavern = 4;
    const magic_soul_tavern = 5;
    const rmb_recharge = 6;
    const diamond_consume = 7;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'single_br_tavern' => self::single_br_tavern,
            'combo_br_tavern' => self::combo_br_tavern,
            'single_gd_tavern' => self::single_gd_tavern,
            'combo_gd_tavern' => self::combo_gd_tavern,
            'magic_soul_tavern' => self::magic_soul_tavern,
            'rmb_recharge' => self::rmb_recharge,
            'diamond_consume' => self::diamond_consume,
        );
    }
}

/**
 * activity_info message
 */
class Down_ActivityInfo extends \ProtobufMessage
{
    /* Field index constants */
    const _ID = 1;
    const _TYPE = 2;
    const _START_TIME = 3;
    const _END_TIME = 4;
    const _REWARDS = 5;
    const _TITLE = 6;
    const _DESC = 7;
    const _RULES = 8;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ID => array(
            'name' => '_id',
            'required' => false,
            'type' => 5,
        ),
        self::_TYPE => array(
            'name' => '_type',
            'required' => false,
            'type' => 5,
        ),
        self::_START_TIME => array(
            'name' => '_start_time',
            'required' => false,
            'type' => 5,
        ),
        self::_END_TIME => array(
            'name' => '_end_time',
            'required' => false,
            'type' => 5,
        ),
        self::_REWARDS => array(
            'name' => '_rewards',
            'repeated' => true,
            'type' => 'Down_ActivityRewards'
        ),
        self::_TITLE => array(
            'name' => '_title',
            'required' => false,
            'type' => 7,
        ),
        self::_DESC => array(
            'name' => '_desc',
            'required' => false,
            'type' => 7,
        ),
        self::_RULES => array(
            'name' => '_rules',
            'required' => false,
            'type' => 7,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ID] = null;
        $this->values[self::_TYPE] = null;
        $this->values[self::_START_TIME] = null;
        $this->values[self::_END_TIME] = null;
        $this->values[self::_REWARDS] = array();
        $this->values[self::_TITLE] = null;
        $this->values[self::_DESC] = null;
        $this->values[self::_RULES] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setId($value)
    {
        return $this->set(self::_ID, $value);
    }

    /**
     * Returns value of '_id' property
     *
     * @return int
     */
    public function getId()
    {
        return $this->get(self::_ID);
    }

    /**
     * Sets value of '_type' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setType($value)
    {
        return $this->set(self::_TYPE, $value);
    }

    /**
     * Returns value of '_type' property
     *
     * @return int
     */
    public function getType()
    {
        return $this->get(self::_TYPE);
    }

    /**
     * Sets value of '_start_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStartTime($value)
    {
        return $this->set(self::_START_TIME, $value);
    }

    /**
     * Returns value of '_start_time' property
     *
     * @return int
     */
    public function getStartTime()
    {
        return $this->get(self::_START_TIME);
    }

    /**
     * Sets value of '_end_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setEndTime($value)
    {
        return $this->set(self::_END_TIME, $value);
    }

    /**
     * Returns value of '_end_time' property
     *
     * @return int
     */
    public function getEndTime()
    {
        return $this->get(self::_END_TIME);
    }

    /**
     * Appends value to '_rewards' list
     *
     * @param Down_ActivityRewards $value Value to append
     *
     * @return null
     */
    public function appendRewards(Down_ActivityRewards $value)
    {
        return $this->append(self::_REWARDS, $value);
    }

    /**
     * Clears '_rewards' list
     *
     * @return null
     */
    public function clearRewards()
    {
        return $this->clear(self::_REWARDS);
    }

    /**
     * Returns '_rewards' list
     *
     * @return Down_ActivityRewards[]
     */
    public function getRewards()
    {
        return $this->get(self::_REWARDS);
    }

    /**
     * Returns '_rewards' iterator
     *
     * @return ArrayIterator
     */
    public function getRewardsIterator()
    {
        return new \ArrayIterator($this->get(self::_REWARDS));
    }

    /**
     * Returns element from '_rewards' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_ActivityRewards
     */
    public function getRewardsAt($offset)
    {
        return $this->get(self::_REWARDS, $offset);
    }

    /**
     * Returns count of '_rewards' list
     *
     * @return int
     */
    public function getRewardsCount()
    {
        return $this->count(self::_REWARDS);
    }

    /**
     * Sets value of '_title' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setTitle($value)
    {
        return $this->set(self::_TITLE, $value);
    }

    /**
     * Returns value of '_title' property
     *
     * @return string
     */
    public function getTitle()
    {
        return $this->get(self::_TITLE);
    }

    /**
     * Sets value of '_desc' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setDesc($value)
    {
        return $this->set(self::_DESC, $value);
    }

    /**
     * Returns value of '_desc' property
     *
     * @return string
     */
    public function getDesc()
    {
        return $this->get(self::_DESC);
    }

    /**
     * Sets value of '_rules' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setRules($value)
    {
        return $this->set(self::_RULES, $value);
    }

    /**
     * Returns value of '_rules' property
     *
     * @return string
     */
    public function getRules()
    {
        return $this->get(self::_RULES);
    }
}

/**
 * cdkey_result enum embedded in cdkey_gift_reply message
 */
final class Down_CdkeyGiftReply_CdkeyResult
{
    const success = 0;
    const already_used = 1;
    const not_exists = 2;
    const once_only = 3;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'success' => self::success,
            'already_used' => self::already_used,
            'not_exists' => self::not_exists,
            'once_only' => self::once_only,
        );
    }
}

/**
 * cdkey_gift_reply message
 */
class Down_CdkeyGiftReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _PACK = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_PACK => array(
            'name' => '_pack',
            'required' => false,
            'type' => 'Down_ResPack'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_PACK] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_pack' property
     *
     * @param Down_ResPack $value Property value
     *
     * @return null
     */
    public function setPack(Down_ResPack $value)
    {
        return $this->set(self::_PACK, $value);
    }

    /**
     * Returns value of '_pack' property
     *
     * @return Down_ResPack
     */
    public function getPack()
    {
        return $this->get(self::_PACK);
    }
}

/**
 * res_pack message
 */
class Down_ResPack extends \ProtobufMessage
{
    /* Field index constants */
    const _MONEY = 1;
    const _DIAMOND = 2;
    const _ITEMS = 3;
    const _HEROES = 4;
    const _MONTH_CARD = 5;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_MONEY => array(
            'name' => '_money',
            'required' => false,
            'type' => 5,
        ),
        self::_DIAMOND => array(
            'name' => '_diamond',
            'required' => false,
            'type' => 5,
        ),
        self::_ITEMS => array(
            'name' => '_items',
            'repeated' => true,
            'type' => 5,
        ),
        self::_HEROES => array(
            'name' => '_heroes',
            'repeated' => true,
            'type' => 'Down_Hero'
        ),
        self::_MONTH_CARD => array(
            'name' => '_month_card',
            'required' => false,
            'type' => 'Down_Monthcard'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_MONEY] = null;
        $this->values[self::_DIAMOND] = null;
        $this->values[self::_ITEMS] = array();
        $this->values[self::_HEROES] = array();
        $this->values[self::_MONTH_CARD] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_money' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setMoney($value)
    {
        return $this->set(self::_MONEY, $value);
    }

    /**
     * Returns value of '_money' property
     *
     * @return int
     */
    public function getMoney()
    {
        return $this->get(self::_MONEY);
    }

    /**
     * Sets value of '_diamond' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setDiamond($value)
    {
        return $this->set(self::_DIAMOND, $value);
    }

    /**
     * Returns value of '_diamond' property
     *
     * @return int
     */
    public function getDiamond()
    {
        return $this->get(self::_DIAMOND);
    }

    /**
     * Appends value to '_items' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendItems($value)
    {
        return $this->append(self::_ITEMS, $value);
    }

    /**
     * Clears '_items' list
     *
     * @return null
     */
    public function clearItems()
    {
        return $this->clear(self::_ITEMS);
    }

    /**
     * Returns '_items' list
     *
     * @return int[]
     */
    public function getItems()
    {
        return $this->get(self::_ITEMS);
    }

    /**
     * Returns '_items' iterator
     *
     * @return ArrayIterator
     */
    public function getItemsIterator()
    {
        return new \ArrayIterator($this->get(self::_ITEMS));
    }

    /**
     * Returns element from '_items' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getItemsAt($offset)
    {
        return $this->get(self::_ITEMS, $offset);
    }

    /**
     * Returns count of '_items' list
     *
     * @return int
     */
    public function getItemsCount()
    {
        return $this->count(self::_ITEMS);
    }

    /**
     * Appends value to '_heroes' list
     *
     * @param Down_Hero $value Value to append
     *
     * @return null
     */
    public function appendHeroes(Down_Hero $value)
    {
        return $this->append(self::_HEROES, $value);
    }

    /**
     * Clears '_heroes' list
     *
     * @return null
     */
    public function clearHeroes()
    {
        return $this->clear(self::_HEROES);
    }

    /**
     * Returns '_heroes' list
     *
     * @return Down_Hero[]
     */
    public function getHeroes()
    {
        return $this->get(self::_HEROES);
    }

    /**
     * Returns '_heroes' iterator
     *
     * @return ArrayIterator
     */
    public function getHeroesIterator()
    {
        return new \ArrayIterator($this->get(self::_HEROES));
    }

    /**
     * Returns element from '_heroes' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_Hero
     */
    public function getHeroesAt($offset)
    {
        return $this->get(self::_HEROES, $offset);
    }

    /**
     * Returns count of '_heroes' list
     *
     * @return int
     */
    public function getHeroesCount()
    {
        return $this->count(self::_HEROES);
    }

    /**
     * Sets value of '_month_card' property
     *
     * @param Down_Monthcard $value Property value
     *
     * @return null
     */
    public function setMonthCard(Down_Monthcard $value)
    {
        return $this->set(self::_MONTH_CARD, $value);
    }

    /**
     * Returns value of '_month_card' property
     *
     * @return Down_Monthcard
     */
    public function getMonthCard()
    {
        return $this->get(self::_MONTH_CARD);
    }
}

/**
 * ask_magicsoul_reply message
 */
class Down_AskMagicsoulReply extends \ProtobufMessage
{
    /* Field index constants */
    const _ID = 0;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ID => array(
            'name' => '_id',
            'repeated' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ID] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_id' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendId($value)
    {
        return $this->append(self::_ID, $value);
    }

    /**
     * Clears '_id' list
     *
     * @return null
     */
    public function clearId()
    {
        return $this->clear(self::_ID);
    }

    /**
     * Returns '_id' list
     *
     * @return int[]
     */
    public function getId()
    {
        return $this->get(self::_ID);
    }

    /**
     * Returns '_id' iterator
     *
     * @return ArrayIterator
     */
    public function getIdIterator()
    {
        return new \ArrayIterator($this->get(self::_ID));
    }

    /**
     * Returns element from '_id' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getIdAt($offset)
    {
        return $this->get(self::_ID, $offset);
    }

    /**
     * Returns count of '_id' list
     *
     * @return int
     */
    public function getIdCount()
    {
        return $this->count(self::_ID);
    }
}

/**
 * important_data message
 */
class Down_ImportantData extends \ProtobufMessage
{
    /* Field index constants */
    const _MONEY = 1;
    const _RMB = 2;
    const _HEROES = 3;
    const _ITEMS = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_MONEY => array(
            'name' => '_money',
            'required' => true,
            'type' => 5,
        ),
        self::_RMB => array(
            'name' => '_rmb',
            'required' => true,
            'type' => 5,
        ),
        self::_HEROES => array(
            'name' => '_heroes',
            'repeated' => true,
            'type' => 'Down_Hero'
        ),
        self::_ITEMS => array(
            'name' => '_items',
            'repeated' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_MONEY] = null;
        $this->values[self::_RMB] = null;
        $this->values[self::_HEROES] = array();
        $this->values[self::_ITEMS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_money' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setMoney($value)
    {
        return $this->set(self::_MONEY, $value);
    }

    /**
     * Returns value of '_money' property
     *
     * @return int
     */
    public function getMoney()
    {
        return $this->get(self::_MONEY);
    }

    /**
     * Sets value of '_rmb' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRmb($value)
    {
        return $this->set(self::_RMB, $value);
    }

    /**
     * Returns value of '_rmb' property
     *
     * @return int
     */
    public function getRmb()
    {
        return $this->get(self::_RMB);
    }

    /**
     * Appends value to '_heroes' list
     *
     * @param Down_Hero $value Value to append
     *
     * @return null
     */
    public function appendHeroes(Down_Hero $value)
    {
        return $this->append(self::_HEROES, $value);
    }

    /**
     * Clears '_heroes' list
     *
     * @return null
     */
    public function clearHeroes()
    {
        return $this->clear(self::_HEROES);
    }

    /**
     * Returns '_heroes' list
     *
     * @return Down_Hero[]
     */
    public function getHeroes()
    {
        return $this->get(self::_HEROES);
    }

    /**
     * Returns '_heroes' iterator
     *
     * @return ArrayIterator
     */
    public function getHeroesIterator()
    {
        return new \ArrayIterator($this->get(self::_HEROES));
    }

    /**
     * Returns element from '_heroes' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_Hero
     */
    public function getHeroesAt($offset)
    {
        return $this->get(self::_HEROES, $offset);
    }

    /**
     * Returns count of '_heroes' list
     *
     * @return int
     */
    public function getHeroesCount()
    {
        return $this->count(self::_HEROES);
    }

    /**
     * Appends value to '_items' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendItems($value)
    {
        return $this->append(self::_ITEMS, $value);
    }

    /**
     * Clears '_items' list
     *
     * @return null
     */
    public function clearItems()
    {
        return $this->clear(self::_ITEMS);
    }

    /**
     * Returns '_items' list
     *
     * @return int[]
     */
    public function getItems()
    {
        return $this->get(self::_ITEMS);
    }

    /**
     * Returns '_items' iterator
     *
     * @return ArrayIterator
     */
    public function getItemsIterator()
    {
        return new \ArrayIterator($this->get(self::_ITEMS));
    }

    /**
     * Returns element from '_items' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getItemsAt($offset)
    {
        return $this->get(self::_ITEMS, $offset);
    }

    /**
     * Returns count of '_items' list
     *
     * @return int
     */
    public function getItemsCount()
    {
        return $this->count(self::_ITEMS);
    }
}

/**
 * monthcard message
 */
class Down_Monthcard extends \ProtobufMessage
{
    /* Field index constants */
    const _ID = 1;
    const _EXPIRE_TIME = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ID => array(
            'name' => '_id',
            'required' => true,
            'type' => 5,
        ),
        self::_EXPIRE_TIME => array(
            'name' => '_expire_time',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ID] = null;
        $this->values[self::_EXPIRE_TIME] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setId($value)
    {
        return $this->set(self::_ID, $value);
    }

    /**
     * Returns value of '_id' property
     *
     * @return int
     */
    public function getId()
    {
        return $this->get(self::_ID);
    }

    /**
     * Sets value of '_expire_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setExpireTime($value)
    {
        return $this->set(self::_EXPIRE_TIME, $value);
    }

    /**
     * Returns value of '_expire_time' property
     *
     * @return int
     */
    public function getExpireTime()
    {
        return $this->get(self::_EXPIRE_TIME);
    }
}

/**
 * excavate_reply message
 */
class Down_ExcavateReply extends \ProtobufMessage
{
    /* Field index constants */
    const _SEARCH_EXCAVATE_REPLY = 1;
    const _QUERY_EXCAVATE_DATA_REPLY = 2;
    const _QUERY_EXCAVATE_HISTORY_REPLY = 3;
    const _QUERY_EXCAVATE_BATTLE_REPLY = 4;
    const _SET_EXCAVATE_TEAM_REPLY = 5;
    const _EXCAVATE_START_BATTLE_REPLY = 6;
    const _EXCAVATE_END_BATTLE_REPLY = 7;
    const _QUERY_EXCAVATE_DEF_REPLY = 8;
    const _CLEAR_EXCAVATE_BATTLE_REPLY = 9;
    const _DRAW_EXCAVATE_DEF_RWD_REPLY = 10;
    const _REVENGE_EXCAVATE_REPLY = 11;
    const _DRAW_EXCAV_RES_REPLY = 12;
    const _WITHDRAW_EXCAVATE_HERO_REPLY = 13;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_SEARCH_EXCAVATE_REPLY => array(
            'name' => '_search_excavate_reply',
            'required' => false,
            'type' => 'Down_SearchExcavateReply'
        ),
        self::_QUERY_EXCAVATE_DATA_REPLY => array(
            'name' => '_query_excavate_data_reply',
            'required' => false,
            'type' => 'Down_QueryExcavateDataReply'
        ),
        self::_QUERY_EXCAVATE_HISTORY_REPLY => array(
            'name' => '_query_excavate_history_reply',
            'required' => false,
            'type' => 'Down_QueryExcavateHistoryReply'
        ),
        self::_QUERY_EXCAVATE_BATTLE_REPLY => array(
            'name' => '_query_excavate_battle_reply',
            'required' => false,
            'type' => 'Down_QueryExcavateBattleReply'
        ),
        self::_SET_EXCAVATE_TEAM_REPLY => array(
            'name' => '_set_excavate_team_reply',
            'required' => false,
            'type' => 'Down_SetExcavateTeamReply'
        ),
        self::_EXCAVATE_START_BATTLE_REPLY => array(
            'name' => '_excavate_start_battle_reply',
            'required' => false,
            'type' => 'Down_ExcavateStartBattleReply'
        ),
        self::_EXCAVATE_END_BATTLE_REPLY => array(
            'name' => '_excavate_end_battle_reply',
            'required' => false,
            'type' => 'Down_ExcavateEndBattleReply'
        ),
        self::_QUERY_EXCAVATE_DEF_REPLY => array(
            'name' => '_query_excavate_def_reply',
            'required' => false,
            'type' => 'Down_QueryExcavateDefReply'
        ),
        self::_CLEAR_EXCAVATE_BATTLE_REPLY => array(
            'name' => '_clear_excavate_battle_reply',
            'required' => false,
            'type' => 'Down_ClearExcavateBattleReply'
        ),
        self::_DRAW_EXCAVATE_DEF_RWD_REPLY => array(
            'name' => '_draw_excavate_def_rwd_reply',
            'required' => false,
            'type' => 'Down_DrawExcavateDefRwdReply'
        ),
        self::_REVENGE_EXCAVATE_REPLY => array(
            'name' => '_revenge_excavate_reply',
            'required' => false,
            'type' => 'Down_RevengeExcavateReply'
        ),
        self::_DRAW_EXCAV_RES_REPLY => array(
            'name' => '_draw_excav_res_reply',
            'required' => false,
            'type' => 'Down_DrawExcavResReply'
        ),
        self::_WITHDRAW_EXCAVATE_HERO_REPLY => array(
            'name' => '_withdraw_excavate_hero_reply',
            'required' => false,
            'type' => 'Down_WithdrawExcavateHeroReply'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_SEARCH_EXCAVATE_REPLY] = null;
        $this->values[self::_QUERY_EXCAVATE_DATA_REPLY] = null;
        $this->values[self::_QUERY_EXCAVATE_HISTORY_REPLY] = null;
        $this->values[self::_QUERY_EXCAVATE_BATTLE_REPLY] = null;
        $this->values[self::_SET_EXCAVATE_TEAM_REPLY] = null;
        $this->values[self::_EXCAVATE_START_BATTLE_REPLY] = null;
        $this->values[self::_EXCAVATE_END_BATTLE_REPLY] = null;
        $this->values[self::_QUERY_EXCAVATE_DEF_REPLY] = null;
        $this->values[self::_CLEAR_EXCAVATE_BATTLE_REPLY] = null;
        $this->values[self::_DRAW_EXCAVATE_DEF_RWD_REPLY] = null;
        $this->values[self::_REVENGE_EXCAVATE_REPLY] = null;
        $this->values[self::_DRAW_EXCAV_RES_REPLY] = null;
        $this->values[self::_WITHDRAW_EXCAVATE_HERO_REPLY] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_search_excavate_reply' property
     *
     * @param Down_SearchExcavateReply $value Property value
     *
     * @return null
     */
    public function setSearchExcavateReply(Down_SearchExcavateReply $value)
    {
        return $this->set(self::_SEARCH_EXCAVATE_REPLY, $value);
    }

    /**
     * Returns value of '_search_excavate_reply' property
     *
     * @return Down_SearchExcavateReply
     */
    public function getSearchExcavateReply()
    {
        return $this->get(self::_SEARCH_EXCAVATE_REPLY);
    }

    /**
     * Sets value of '_query_excavate_data_reply' property
     *
     * @param Down_QueryExcavateDataReply $value Property value
     *
     * @return null
     */
    public function setQueryExcavateDataReply(Down_QueryExcavateDataReply $value)
    {
        return $this->set(self::_QUERY_EXCAVATE_DATA_REPLY, $value);
    }

    /**
     * Returns value of '_query_excavate_data_reply' property
     *
     * @return Down_QueryExcavateDataReply
     */
    public function getQueryExcavateDataReply()
    {
        return $this->get(self::_QUERY_EXCAVATE_DATA_REPLY);
    }

    /**
     * Sets value of '_query_excavate_history_reply' property
     *
     * @param Down_QueryExcavateHistoryReply $value Property value
     *
     * @return null
     */
    public function setQueryExcavateHistoryReply(Down_QueryExcavateHistoryReply $value)
    {
        return $this->set(self::_QUERY_EXCAVATE_HISTORY_REPLY, $value);
    }

    /**
     * Returns value of '_query_excavate_history_reply' property
     *
     * @return Down_QueryExcavateHistoryReply
     */
    public function getQueryExcavateHistoryReply()
    {
        return $this->get(self::_QUERY_EXCAVATE_HISTORY_REPLY);
    }

    /**
     * Sets value of '_query_excavate_battle_reply' property
     *
     * @param Down_QueryExcavateBattleReply $value Property value
     *
     * @return null
     */
    public function setQueryExcavateBattleReply(Down_QueryExcavateBattleReply $value)
    {
        return $this->set(self::_QUERY_EXCAVATE_BATTLE_REPLY, $value);
    }

    /**
     * Returns value of '_query_excavate_battle_reply' property
     *
     * @return Down_QueryExcavateBattleReply
     */
    public function getQueryExcavateBattleReply()
    {
        return $this->get(self::_QUERY_EXCAVATE_BATTLE_REPLY);
    }

    /**
     * Sets value of '_set_excavate_team_reply' property
     *
     * @param Down_SetExcavateTeamReply $value Property value
     *
     * @return null
     */
    public function setSetExcavateTeamReply(Down_SetExcavateTeamReply $value)
    {
        return $this->set(self::_SET_EXCAVATE_TEAM_REPLY, $value);
    }

    /**
     * Returns value of '_set_excavate_team_reply' property
     *
     * @return Down_SetExcavateTeamReply
     */
    public function getSetExcavateTeamReply()
    {
        return $this->get(self::_SET_EXCAVATE_TEAM_REPLY);
    }

    /**
     * Sets value of '_excavate_start_battle_reply' property
     *
     * @param Down_ExcavateStartBattleReply $value Property value
     *
     * @return null
     */
    public function setExcavateStartBattleReply(Down_ExcavateStartBattleReply $value)
    {
        return $this->set(self::_EXCAVATE_START_BATTLE_REPLY, $value);
    }

    /**
     * Returns value of '_excavate_start_battle_reply' property
     *
     * @return Down_ExcavateStartBattleReply
     */
    public function getExcavateStartBattleReply()
    {
        return $this->get(self::_EXCAVATE_START_BATTLE_REPLY);
    }

    /**
     * Sets value of '_excavate_end_battle_reply' property
     *
     * @param Down_ExcavateEndBattleReply $value Property value
     *
     * @return null
     */
    public function setExcavateEndBattleReply(Down_ExcavateEndBattleReply $value)
    {
        return $this->set(self::_EXCAVATE_END_BATTLE_REPLY, $value);
    }

    /**
     * Returns value of '_excavate_end_battle_reply' property
     *
     * @return Down_ExcavateEndBattleReply
     */
    public function getExcavateEndBattleReply()
    {
        return $this->get(self::_EXCAVATE_END_BATTLE_REPLY);
    }

    /**
     * Sets value of '_query_excavate_def_reply' property
     *
     * @param Down_QueryExcavateDefReply $value Property value
     *
     * @return null
     */
    public function setQueryExcavateDefReply(Down_QueryExcavateDefReply $value)
    {
        return $this->set(self::_QUERY_EXCAVATE_DEF_REPLY, $value);
    }

    /**
     * Returns value of '_query_excavate_def_reply' property
     *
     * @return Down_QueryExcavateDefReply
     */
    public function getQueryExcavateDefReply()
    {
        return $this->get(self::_QUERY_EXCAVATE_DEF_REPLY);
    }

    /**
     * Sets value of '_clear_excavate_battle_reply' property
     *
     * @param Down_ClearExcavateBattleReply $value Property value
     *
     * @return null
     */
    public function setClearExcavateBattleReply(Down_ClearExcavateBattleReply $value)
    {
        return $this->set(self::_CLEAR_EXCAVATE_BATTLE_REPLY, $value);
    }

    /**
     * Returns value of '_clear_excavate_battle_reply' property
     *
     * @return Down_ClearExcavateBattleReply
     */
    public function getClearExcavateBattleReply()
    {
        return $this->get(self::_CLEAR_EXCAVATE_BATTLE_REPLY);
    }

    /**
     * Sets value of '_draw_excavate_def_rwd_reply' property
     *
     * @param Down_DrawExcavateDefRwdReply $value Property value
     *
     * @return null
     */
    public function setDrawExcavateDefRwdReply(Down_DrawExcavateDefRwdReply $value)
    {
        return $this->set(self::_DRAW_EXCAVATE_DEF_RWD_REPLY, $value);
    }

    /**
     * Returns value of '_draw_excavate_def_rwd_reply' property
     *
     * @return Down_DrawExcavateDefRwdReply
     */
    public function getDrawExcavateDefRwdReply()
    {
        return $this->get(self::_DRAW_EXCAVATE_DEF_RWD_REPLY);
    }

    /**
     * Sets value of '_revenge_excavate_reply' property
     *
     * @param Down_RevengeExcavateReply $value Property value
     *
     * @return null
     */
    public function setRevengeExcavateReply(Down_RevengeExcavateReply $value)
    {
        return $this->set(self::_REVENGE_EXCAVATE_REPLY, $value);
    }

    /**
     * Returns value of '_revenge_excavate_reply' property
     *
     * @return Down_RevengeExcavateReply
     */
    public function getRevengeExcavateReply()
    {
        return $this->get(self::_REVENGE_EXCAVATE_REPLY);
    }

    /**
     * Sets value of '_draw_excav_res_reply' property
     *
     * @param Down_DrawExcavResReply $value Property value
     *
     * @return null
     */
    public function setDrawExcavResReply(Down_DrawExcavResReply $value)
    {
        return $this->set(self::_DRAW_EXCAV_RES_REPLY, $value);
    }

    /**
     * Returns value of '_draw_excav_res_reply' property
     *
     * @return Down_DrawExcavResReply
     */
    public function getDrawExcavResReply()
    {
        return $this->get(self::_DRAW_EXCAV_RES_REPLY);
    }

    /**
     * Sets value of '_withdraw_excavate_hero_reply' property
     *
     * @param Down_WithdrawExcavateHeroReply $value Property value
     *
     * @return null
     */
    public function setWithdrawExcavateHeroReply(Down_WithdrawExcavateHeroReply $value)
    {
        return $this->set(self::_WITHDRAW_EXCAVATE_HERO_REPLY, $value);
    }

    /**
     * Returns value of '_withdraw_excavate_hero_reply' property
     *
     * @return Down_WithdrawExcavateHeroReply
     */
    public function getWithdrawExcavateHeroReply()
    {
        return $this->get(self::_WITHDRAW_EXCAVATE_HERO_REPLY);
    }
}

/**
 * revenge_excavate_reply message
 */
class Down_RevengeExcavateReply extends \ProtobufMessage
{
    /* Field index constants */
    const _EXCAVATE = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_EXCAVATE => array(
            'name' => '_excavate',
            'required' => false,
            'type' => 'Down_Excavate'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_EXCAVATE] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_excavate' property
     *
     * @param Down_Excavate $value Property value
     *
     * @return null
     */
    public function setExcavate(Down_Excavate $value)
    {
        return $this->set(self::_EXCAVATE, $value);
    }

    /**
     * Returns value of '_excavate' property
     *
     * @return Down_Excavate
     */
    public function getExcavate()
    {
        return $this->get(self::_EXCAVATE);
    }
}

/**
 * search_result enum embedded in search_excavate_reply message
 */
final class Down_SearchExcavateReply_SearchResult
{
    const success = 0;
    const failed = 1;
    const lack_money = 2;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'success' => self::success,
            'failed' => self::failed,
            'lack_money' => self::lack_money,
        );
    }
}

/**
 * search_excavate_reply message
 */
class Down_SearchExcavateReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _EXCAVATE = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_EXCAVATE => array(
            'name' => '_excavate',
            'required' => false,
            'type' => 'Down_Excavate'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_EXCAVATE] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_excavate' property
     *
     * @param Down_Excavate $value Property value
     *
     * @return null
     */
    public function setExcavate(Down_Excavate $value)
    {
        return $this->set(self::_EXCAVATE, $value);
    }

    /**
     * Returns value of '_excavate' property
     *
     * @return Down_Excavate
     */
    public function getExcavate()
    {
        return $this->get(self::_EXCAVATE);
    }
}

/**
 * query_excavate_data_reply message
 */
class Down_QueryExcavateDataReply extends \ProtobufMessage
{
    /* Field index constants */
    const _EXCAVATE = 1;
    const _SEARCHED_ID = 2;
    const _SEARCH_TIMES = 3;
    const _LAST_SEARCH_TS = 4;
    const _ATTACKING_ID = 5;
    const _BAT_HEROES = 6;
    const _CFG = 7;
    const _HIRE = 8;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_EXCAVATE => array(
            'name' => '_excavate',
            'repeated' => true,
            'type' => 'Down_Excavate'
        ),
        self::_SEARCHED_ID => array(
            'name' => '_searched_id',
            'required' => true,
            'type' => 5,
        ),
        self::_SEARCH_TIMES => array(
            'name' => '_search_times',
            'required' => true,
            'type' => 5,
        ),
        self::_LAST_SEARCH_TS => array(
            'name' => '_last_search_ts',
            'required' => true,
            'type' => 5,
        ),
        self::_ATTACKING_ID => array(
            'name' => '_attacking_id',
            'required' => false,
            'type' => 5,
        ),
        self::_BAT_HEROES => array(
            'name' => '_bat_heroes',
            'repeated' => true,
            'type' => 'Down_ExcavateSelfHero'
        ),
        self::_CFG => array(
            'name' => '_cfg',
            'required' => false,
            'type' => 'Down_ExcavateCfg'
        ),
        self::_HIRE => array(
            'name' => '_hire',
            'required' => false,
            'type' => 'Down_HireData'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_EXCAVATE] = array();
        $this->values[self::_SEARCHED_ID] = null;
        $this->values[self::_SEARCH_TIMES] = null;
        $this->values[self::_LAST_SEARCH_TS] = null;
        $this->values[self::_ATTACKING_ID] = null;
        $this->values[self::_BAT_HEROES] = array();
        $this->values[self::_CFG] = null;
        $this->values[self::_HIRE] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_excavate' list
     *
     * @param Down_Excavate $value Value to append
     *
     * @return null
     */
    public function appendExcavate(Down_Excavate $value)
    {
        return $this->append(self::_EXCAVATE, $value);
    }

    /**
     * Clears '_excavate' list
     *
     * @return null
     */
    public function clearExcavate()
    {
        return $this->clear(self::_EXCAVATE);
    }

    /**
     * Returns '_excavate' list
     *
     * @return Down_Excavate[]
     */
    public function getExcavate()
    {
        return $this->get(self::_EXCAVATE);
    }

    /**
     * Returns '_excavate' iterator
     *
     * @return ArrayIterator
     */
    public function getExcavateIterator()
    {
        return new \ArrayIterator($this->get(self::_EXCAVATE));
    }

    /**
     * Returns element from '_excavate' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_Excavate
     */
    public function getExcavateAt($offset)
    {
        return $this->get(self::_EXCAVATE, $offset);
    }

    /**
     * Returns count of '_excavate' list
     *
     * @return int
     */
    public function getExcavateCount()
    {
        return $this->count(self::_EXCAVATE);
    }

    /**
     * Sets value of '_searched_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSearchedId($value)
    {
        return $this->set(self::_SEARCHED_ID, $value);
    }

    /**
     * Returns value of '_searched_id' property
     *
     * @return int
     */
    public function getSearchedId()
    {
        return $this->get(self::_SEARCHED_ID);
    }

    /**
     * Sets value of '_search_times' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSearchTimes($value)
    {
        return $this->set(self::_SEARCH_TIMES, $value);
    }

    /**
     * Returns value of '_search_times' property
     *
     * @return int
     */
    public function getSearchTimes()
    {
        return $this->get(self::_SEARCH_TIMES);
    }

    /**
     * Sets value of '_last_search_ts' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLastSearchTs($value)
    {
        return $this->set(self::_LAST_SEARCH_TS, $value);
    }

    /**
     * Returns value of '_last_search_ts' property
     *
     * @return int
     */
    public function getLastSearchTs()
    {
        return $this->get(self::_LAST_SEARCH_TS);
    }

    /**
     * Sets value of '_attacking_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setAttackingId($value)
    {
        return $this->set(self::_ATTACKING_ID, $value);
    }

    /**
     * Returns value of '_attacking_id' property
     *
     * @return int
     */
    public function getAttackingId()
    {
        return $this->get(self::_ATTACKING_ID);
    }

    /**
     * Appends value to '_bat_heroes' list
     *
     * @param Down_ExcavateSelfHero $value Value to append
     *
     * @return null
     */
    public function appendBatHeroes(Down_ExcavateSelfHero $value)
    {
        return $this->append(self::_BAT_HEROES, $value);
    }

    /**
     * Clears '_bat_heroes' list
     *
     * @return null
     */
    public function clearBatHeroes()
    {
        return $this->clear(self::_BAT_HEROES);
    }

    /**
     * Returns '_bat_heroes' list
     *
     * @return Down_ExcavateSelfHero[]
     */
    public function getBatHeroes()
    {
        return $this->get(self::_BAT_HEROES);
    }

    /**
     * Returns '_bat_heroes' iterator
     *
     * @return ArrayIterator
     */
    public function getBatHeroesIterator()
    {
        return new \ArrayIterator($this->get(self::_BAT_HEROES));
    }

    /**
     * Returns element from '_bat_heroes' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_ExcavateSelfHero
     */
    public function getBatHeroesAt($offset)
    {
        return $this->get(self::_BAT_HEROES, $offset);
    }

    /**
     * Returns count of '_bat_heroes' list
     *
     * @return int
     */
    public function getBatHeroesCount()
    {
        return $this->count(self::_BAT_HEROES);
    }

    /**
     * Sets value of '_cfg' property
     *
     * @param Down_ExcavateCfg $value Property value
     *
     * @return null
     */
    public function setCfg(Down_ExcavateCfg $value)
    {
        return $this->set(self::_CFG, $value);
    }

    /**
     * Returns value of '_cfg' property
     *
     * @return Down_ExcavateCfg
     */
    public function getCfg()
    {
        return $this->get(self::_CFG);
    }

    /**
     * Sets value of '_hire' property
     *
     * @param Down_HireData $value Property value
     *
     * @return null
     */
    public function setHire(Down_HireData $value)
    {
        return $this->set(self::_HIRE, $value);
    }

    /**
     * Returns value of '_hire' property
     *
     * @return Down_HireData
     */
    public function getHire()
    {
        return $this->get(self::_HIRE);
    }
}

/**
 * excavate_self_hero message
 */
class Down_ExcavateSelfHero extends \ProtobufMessage
{
    /* Field index constants */
    const _HERO_ID = 1;
    const _DYNA = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_HERO_ID => array(
            'name' => '_hero_id',
            'required' => true,
            'type' => 5,
        ),
        self::_DYNA => array(
            'name' => '_dyna',
            'required' => true,
            'type' => 'Down_HeroDyna'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_HERO_ID] = null;
        $this->values[self::_DYNA] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_hero_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setHeroId($value)
    {
        return $this->set(self::_HERO_ID, $value);
    }

    /**
     * Returns value of '_hero_id' property
     *
     * @return int
     */
    public function getHeroId()
    {
        return $this->get(self::_HERO_ID);
    }

    /**
     * Sets value of '_dyna' property
     *
     * @param Down_HeroDyna $value Property value
     *
     * @return null
     */
    public function setDyna(Down_HeroDyna $value)
    {
        return $this->set(self::_DYNA, $value);
    }

    /**
     * Returns value of '_dyna' property
     *
     * @return Down_HeroDyna
     */
    public function getDyna()
    {
        return $this->get(self::_DYNA);
    }
}

/**
 * excavate_cfg message
 */
class Down_ExcavateCfg extends \ProtobufMessage
{
    /* Field index constants */
    const _ATTACK_TIMEOUT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ATTACK_TIMEOUT => array(
            'name' => '_attack_timeout',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ATTACK_TIMEOUT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_attack_timeout' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setAttackTimeout($value)
    {
        return $this->set(self::_ATTACK_TIMEOUT, $value);
    }

    /**
     * Returns value of '_attack_timeout' property
     *
     * @return int
     */
    public function getAttackTimeout()
    {
        return $this->get(self::_ATTACK_TIMEOUT);
    }
}

/**
 * excavate_team message
 */
class Down_ExcavateTeam extends \ProtobufMessage
{
    /* Field index constants */
    const _TEAM_ID = 1;
    const _PLAYER = 2;
    const _HERO_BASES = 3;
    const _HERO_DYNAS = 4;
    const _RES_GOT = 5;
    const _SVR_ID = 6;
    const _DISPLAY_SVR_ID = 7;
    const _SVR_NAME = 8;
    const _TEAM_GS = 9;
    const _SPEED = 10;
    const _ROBBED = 11;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TEAM_ID => array(
            'name' => '_team_id',
            'required' => true,
            'type' => 5,
        ),
        self::_PLAYER => array(
            'name' => '_player',
            'required' => false,
            'type' => 'Down_UserSummary'
        ),
        self::_HERO_BASES => array(
            'name' => '_hero_bases',
            'repeated' => true,
            'type' => 'Down_HeroSummary'
        ),
        self::_HERO_DYNAS => array(
            'name' => '_hero_dynas',
            'repeated' => true,
            'type' => 'Down_HeroDyna'
        ),
        self::_RES_GOT => array(
            'name' => '_res_got',
            'required' => true,
            'type' => 5,
        ),
        self::_SVR_ID => array(
            'name' => '_svr_id',
            'required' => false,
            'type' => 5,
        ),
        self::_DISPLAY_SVR_ID => array(
            'name' => '_display_svr_id',
            'required' => false,
            'type' => 5,
        ),
        self::_SVR_NAME => array(
            'name' => '_svr_name',
            'required' => false,
            'type' => 7,
        ),
        self::_TEAM_GS => array(
            'name' => '_team_gs',
            'required' => false,
            'type' => 5,
        ),
        self::_SPEED => array(
            'name' => '_speed',
            'required' => false,
            'type' => 5,
        ),
        self::_ROBBED => array(
            'name' => '_robbed',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_TEAM_ID] = null;
        $this->values[self::_PLAYER] = null;
        $this->values[self::_HERO_BASES] = array();
        $this->values[self::_HERO_DYNAS] = array();
        $this->values[self::_RES_GOT] = null;
        $this->values[self::_SVR_ID] = null;
        $this->values[self::_DISPLAY_SVR_ID] = null;
        $this->values[self::_SVR_NAME] = null;
        $this->values[self::_TEAM_GS] = null;
        $this->values[self::_SPEED] = null;
        $this->values[self::_ROBBED] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_team_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setTeamId($value)
    {
        return $this->set(self::_TEAM_ID, $value);
    }

    /**
     * Returns value of '_team_id' property
     *
     * @return int
     */
    public function getTeamId()
    {
        return $this->get(self::_TEAM_ID);
    }

    /**
     * Sets value of '_player' property
     *
     * @param Down_UserSummary $value Property value
     *
     * @return null
     */
    public function setPlayer(Down_UserSummary $value)
    {
        return $this->set(self::_PLAYER, $value);
    }

    /**
     * Returns value of '_player' property
     *
     * @return Down_UserSummary
     */
    public function getPlayer()
    {
        return $this->get(self::_PLAYER);
    }

    /**
     * Appends value to '_hero_bases' list
     *
     * @param Down_HeroSummary $value Value to append
     *
     * @return null
     */
    public function appendHeroBases(Down_HeroSummary $value)
    {
        return $this->append(self::_HERO_BASES, $value);
    }

    /**
     * Clears '_hero_bases' list
     *
     * @return null
     */
    public function clearHeroBases()
    {
        return $this->clear(self::_HERO_BASES);
    }

    /**
     * Returns '_hero_bases' list
     *
     * @return Down_HeroSummary[]
     */
    public function getHeroBases()
    {
        return $this->get(self::_HERO_BASES);
    }

    /**
     * Returns '_hero_bases' iterator
     *
     * @return ArrayIterator
     */
    public function getHeroBasesIterator()
    {
        return new \ArrayIterator($this->get(self::_HERO_BASES));
    }

    /**
     * Returns element from '_hero_bases' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_HeroSummary
     */
    public function getHeroBasesAt($offset)
    {
        return $this->get(self::_HERO_BASES, $offset);
    }

    /**
     * Returns count of '_hero_bases' list
     *
     * @return int
     */
    public function getHeroBasesCount()
    {
        return $this->count(self::_HERO_BASES);
    }

    /**
     * Appends value to '_hero_dynas' list
     *
     * @param Down_HeroDyna $value Value to append
     *
     * @return null
     */
    public function appendHeroDynas(Down_HeroDyna $value)
    {
        return $this->append(self::_HERO_DYNAS, $value);
    }

    /**
     * Clears '_hero_dynas' list
     *
     * @return null
     */
    public function clearHeroDynas()
    {
        return $this->clear(self::_HERO_DYNAS);
    }

    /**
     * Returns '_hero_dynas' list
     *
     * @return Down_HeroDyna[]
     */
    public function getHeroDynas()
    {
        return $this->get(self::_HERO_DYNAS);
    }

    /**
     * Returns '_hero_dynas' iterator
     *
     * @return ArrayIterator
     */
    public function getHeroDynasIterator()
    {
        return new \ArrayIterator($this->get(self::_HERO_DYNAS));
    }

    /**
     * Returns element from '_hero_dynas' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_HeroDyna
     */
    public function getHeroDynasAt($offset)
    {
        return $this->get(self::_HERO_DYNAS, $offset);
    }

    /**
     * Returns count of '_hero_dynas' list
     *
     * @return int
     */
    public function getHeroDynasCount()
    {
        return $this->count(self::_HERO_DYNAS);
    }

    /**
     * Sets value of '_res_got' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResGot($value)
    {
        return $this->set(self::_RES_GOT, $value);
    }

    /**
     * Returns value of '_res_got' property
     *
     * @return int
     */
    public function getResGot()
    {
        return $this->get(self::_RES_GOT);
    }

    /**
     * Sets value of '_svr_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSvrId($value)
    {
        return $this->set(self::_SVR_ID, $value);
    }

    /**
     * Returns value of '_svr_id' property
     *
     * @return int
     */
    public function getSvrId()
    {
        return $this->get(self::_SVR_ID);
    }

    /**
     * Sets value of '_display_svr_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setDisplaySvrId($value)
    {
        return $this->set(self::_DISPLAY_SVR_ID, $value);
    }

    /**
     * Returns value of '_display_svr_id' property
     *
     * @return int
     */
    public function getDisplaySvrId()
    {
        return $this->get(self::_DISPLAY_SVR_ID);
    }

    /**
     * Sets value of '_svr_name' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setSvrName($value)
    {
        return $this->set(self::_SVR_NAME, $value);
    }

    /**
     * Returns value of '_svr_name' property
     *
     * @return string
     */
    public function getSvrName()
    {
        return $this->get(self::_SVR_NAME);
    }

    /**
     * Sets value of '_team_gs' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setTeamGs($value)
    {
        return $this->set(self::_TEAM_GS, $value);
    }

    /**
     * Returns value of '_team_gs' property
     *
     * @return int
     */
    public function getTeamGs()
    {
        return $this->get(self::_TEAM_GS);
    }

    /**
     * Sets value of '_speed' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSpeed($value)
    {
        return $this->set(self::_SPEED, $value);
    }

    /**
     * Returns value of '_speed' property
     *
     * @return int
     */
    public function getSpeed()
    {
        return $this->get(self::_SPEED);
    }

    /**
     * Sets value of '_robbed' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRobbed($value)
    {
        return $this->set(self::_ROBBED, $value);
    }

    /**
     * Returns value of '_robbed' property
     *
     * @return int
     */
    public function getRobbed()
    {
        return $this->get(self::_ROBBED);
    }
}

/**
 * owner enum embedded in excavate message
 */
final class Down_Excavate_Owner
{
    const mine = 0;
    const others = 1;
    const robot = 2;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'mine' => self::mine,
            'others' => self::others,
            'robot' => self::robot,
        );
    }
}

/**
 * state enum embedded in excavate message
 */
final class Down_Excavate_State
{
    const searched = 1;
    const battle = 2;
    const shield = 3;
    const occupy = 4;
    const protect = 5;
    const dead = 6;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'searched' => self::searched,
            'battle' => self::battle,
            'shield' => self::shield,
            'occupy' => self::occupy,
            'protect' => self::protect,
            'dead' => self::dead,
        );
    }
}

/**
 * excavate message
 */
class Down_Excavate extends \ProtobufMessage
{
    /* Field index constants */
    const _OWNER = 1;
    const _ID = 2;
    const _TYPE_ID = 3;
    const _TEAM = 4;
    const _STATE = 5;
    const _STATE_END_TS = 6;
    const _CREATE_TIME = 7;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_OWNER => array(
            'name' => '_owner',
            'required' => true,
            'type' => 5,
        ),
        self::_ID => array(
            'name' => '_id',
            'required' => true,
            'type' => 5,
        ),
        self::_TYPE_ID => array(
            'name' => '_type_id',
            'required' => true,
            'type' => 5,
        ),
        self::_TEAM => array(
            'name' => '_team',
            'repeated' => true,
            'type' => 'Down_ExcavateTeam'
        ),
        self::_STATE => array(
            'name' => '_state',
            'required' => true,
            'type' => 5,
        ),
        self::_STATE_END_TS => array(
            'name' => '_state_end_ts',
            'required' => false,
            'type' => 5,
        ),
        self::_CREATE_TIME => array(
            'name' => '_create_time',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_OWNER] = null;
        $this->values[self::_ID] = null;
        $this->values[self::_TYPE_ID] = null;
        $this->values[self::_TEAM] = array();
        $this->values[self::_STATE] = null;
        $this->values[self::_STATE_END_TS] = null;
        $this->values[self::_CREATE_TIME] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_owner' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setOwner($value)
    {
        return $this->set(self::_OWNER, $value);
    }

    /**
     * Returns value of '_owner' property
     *
     * @return int
     */
    public function getOwner()
    {
        return $this->get(self::_OWNER);
    }

    /**
     * Sets value of '_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setId($value)
    {
        return $this->set(self::_ID, $value);
    }

    /**
     * Returns value of '_id' property
     *
     * @return int
     */
    public function getId()
    {
        return $this->get(self::_ID);
    }

    /**
     * Sets value of '_type_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setTypeId($value)
    {
        return $this->set(self::_TYPE_ID, $value);
    }

    /**
     * Returns value of '_type_id' property
     *
     * @return int
     */
    public function getTypeId()
    {
        return $this->get(self::_TYPE_ID);
    }

    /**
     * Appends value to '_team' list
     *
     * @param Down_ExcavateTeam $value Value to append
     *
     * @return null
     */
    public function appendTeam(Down_ExcavateTeam $value)
    {
        return $this->append(self::_TEAM, $value);
    }

    /**
     * Clears '_team' list
     *
     * @return null
     */
    public function clearTeam()
    {
        return $this->clear(self::_TEAM);
    }

    /**
     * Returns '_team' list
     *
     * @return Down_ExcavateTeam[]
     */
    public function getTeam()
    {
        return $this->get(self::_TEAM);
    }

    /**
     * Returns '_team' iterator
     *
     * @return ArrayIterator
     */
    public function getTeamIterator()
    {
        return new \ArrayIterator($this->get(self::_TEAM));
    }

    /**
     * Returns element from '_team' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_ExcavateTeam
     */
    public function getTeamAt($offset)
    {
        return $this->get(self::_TEAM, $offset);
    }

    /**
     * Returns count of '_team' list
     *
     * @return int
     */
    public function getTeamCount()
    {
        return $this->count(self::_TEAM);
    }

    /**
     * Sets value of '_state' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setState($value)
    {
        return $this->set(self::_STATE, $value);
    }

    /**
     * Returns value of '_state' property
     *
     * @return int
     */
    public function getState()
    {
        return $this->get(self::_STATE);
    }

    /**
     * Sets value of '_state_end_ts' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStateEndTs($value)
    {
        return $this->set(self::_STATE_END_TS, $value);
    }

    /**
     * Returns value of '_state_end_ts' property
     *
     * @return int
     */
    public function getStateEndTs()
    {
        return $this->get(self::_STATE_END_TS);
    }

    /**
     * Sets value of '_create_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCreateTime($value)
    {
        return $this->set(self::_CREATE_TIME, $value);
    }

    /**
     * Returns value of '_create_time' property
     *
     * @return int
     */
    public function getCreateTime()
    {
        return $this->get(self::_CREATE_TIME);
    }
}

/**
 * def_result enum embedded in excavate_history message
 */
final class Down_ExcavateHistory_DefResult
{
    const win = 0;
    const fail = 1;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'win' => self::win,
            'fail' => self::fail,
        );
    }
}

/**
 * excavate_history message
 */
class Down_ExcavateHistory extends \ProtobufMessage
{
    /* Field index constants */
    const _ID = 1;
    const _EXCAVATE_ID = 2;
    const _RESULT = 3;
    const _ENEMY_NAME = 4;
    const _ENEMY_SVRID = 5;
    const _ENEMY_SVRNAME = 6;
    const _TIME = 7;
    const _VATILITY = 8;
    const _REWARD = 9;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ID => array(
            'name' => '_id',
            'required' => true,
            'type' => 7,
        ),
        self::_EXCAVATE_ID => array(
            'name' => '_excavate_id',
            'required' => true,
            'type' => 5,
        ),
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_ENEMY_NAME => array(
            'name' => '_enemy_name',
            'required' => true,
            'type' => 7,
        ),
        self::_ENEMY_SVRID => array(
            'name' => '_enemy_svrid',
            'required' => false,
            'type' => 5,
        ),
        self::_ENEMY_SVRNAME => array(
            'name' => '_enemy_svrname',
            'required' => false,
            'type' => 7,
        ),
        self::_TIME => array(
            'name' => '_time',
            'required' => true,
            'type' => 5,
        ),
        self::_VATILITY => array(
            'name' => '_vatility',
            'required' => false,
            'type' => 5,
        ),
        self::_REWARD => array(
            'name' => '_reward',
            'repeated' => true,
            'type' => 'Down_ExcavateReward'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ID] = null;
        $this->values[self::_EXCAVATE_ID] = null;
        $this->values[self::_RESULT] = null;
        $this->values[self::_ENEMY_NAME] = null;
        $this->values[self::_ENEMY_SVRID] = null;
        $this->values[self::_ENEMY_SVRNAME] = null;
        $this->values[self::_TIME] = null;
        $this->values[self::_VATILITY] = null;
        $this->values[self::_REWARD] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_id' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setId($value)
    {
        return $this->set(self::_ID, $value);
    }

    /**
     * Returns value of '_id' property
     *
     * @return string
     */
    public function getId()
    {
        return $this->get(self::_ID);
    }

    /**
     * Sets value of '_excavate_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setExcavateId($value)
    {
        return $this->set(self::_EXCAVATE_ID, $value);
    }

    /**
     * Returns value of '_excavate_id' property
     *
     * @return int
     */
    public function getExcavateId()
    {
        return $this->get(self::_EXCAVATE_ID);
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_enemy_name' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setEnemyName($value)
    {
        return $this->set(self::_ENEMY_NAME, $value);
    }

    /**
     * Returns value of '_enemy_name' property
     *
     * @return string
     */
    public function getEnemyName()
    {
        return $this->get(self::_ENEMY_NAME);
    }

    /**
     * Sets value of '_enemy_svrid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setEnemySvrid($value)
    {
        return $this->set(self::_ENEMY_SVRID, $value);
    }

    /**
     * Returns value of '_enemy_svrid' property
     *
     * @return int
     */
    public function getEnemySvrid()
    {
        return $this->get(self::_ENEMY_SVRID);
    }

    /**
     * Sets value of '_enemy_svrname' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setEnemySvrname($value)
    {
        return $this->set(self::_ENEMY_SVRNAME, $value);
    }

    /**
     * Returns value of '_enemy_svrname' property
     *
     * @return string
     */
    public function getEnemySvrname()
    {
        return $this->get(self::_ENEMY_SVRNAME);
    }

    /**
     * Sets value of '_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setTime($value)
    {
        return $this->set(self::_TIME, $value);
    }

    /**
     * Returns value of '_time' property
     *
     * @return int
     */
    public function getTime()
    {
        return $this->get(self::_TIME);
    }

    /**
     * Sets value of '_vatility' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setVatility($value)
    {
        return $this->set(self::_VATILITY, $value);
    }

    /**
     * Returns value of '_vatility' property
     *
     * @return int
     */
    public function getVatility()
    {
        return $this->get(self::_VATILITY);
    }

    /**
     * Appends value to '_reward' list
     *
     * @param Down_ExcavateReward $value Value to append
     *
     * @return null
     */
    public function appendReward(Down_ExcavateReward $value)
    {
        return $this->append(self::_REWARD, $value);
    }

    /**
     * Clears '_reward' list
     *
     * @return null
     */
    public function clearReward()
    {
        return $this->clear(self::_REWARD);
    }

    /**
     * Returns '_reward' list
     *
     * @return Down_ExcavateReward[]
     */
    public function getReward()
    {
        return $this->get(self::_REWARD);
    }

    /**
     * Returns '_reward' iterator
     *
     * @return ArrayIterator
     */
    public function getRewardIterator()
    {
        return new \ArrayIterator($this->get(self::_REWARD));
    }

    /**
     * Returns element from '_reward' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_ExcavateReward
     */
    public function getRewardAt($offset)
    {
        return $this->get(self::_REWARD, $offset);
    }

    /**
     * Returns count of '_reward' list
     *
     * @return int
     */
    public function getRewardCount()
    {
        return $this->count(self::_REWARD);
    }
}

/**
 * query_excavate_history_reply message
 */
class Down_QueryExcavateHistoryReply extends \ProtobufMessage
{
    /* Field index constants */
    const _EXCAVATE_HISTORY = 1;
    const _DRAW_DEF_VITALITY = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_EXCAVATE_HISTORY => array(
            'name' => '_excavate_history',
            'repeated' => true,
            'type' => 'Down_ExcavateHistory'
        ),
        self::_DRAW_DEF_VITALITY => array(
            'name' => '_draw_def_vitality',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_EXCAVATE_HISTORY] = array();
        $this->values[self::_DRAW_DEF_VITALITY] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_excavate_history' list
     *
     * @param Down_ExcavateHistory $value Value to append
     *
     * @return null
     */
    public function appendExcavateHistory(Down_ExcavateHistory $value)
    {
        return $this->append(self::_EXCAVATE_HISTORY, $value);
    }

    /**
     * Clears '_excavate_history' list
     *
     * @return null
     */
    public function clearExcavateHistory()
    {
        return $this->clear(self::_EXCAVATE_HISTORY);
    }

    /**
     * Returns '_excavate_history' list
     *
     * @return Down_ExcavateHistory[]
     */
    public function getExcavateHistory()
    {
        return $this->get(self::_EXCAVATE_HISTORY);
    }

    /**
     * Returns '_excavate_history' iterator
     *
     * @return ArrayIterator
     */
    public function getExcavateHistoryIterator()
    {
        return new \ArrayIterator($this->get(self::_EXCAVATE_HISTORY));
    }

    /**
     * Returns element from '_excavate_history' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_ExcavateHistory
     */
    public function getExcavateHistoryAt($offset)
    {
        return $this->get(self::_EXCAVATE_HISTORY, $offset);
    }

    /**
     * Returns count of '_excavate_history' list
     *
     * @return int
     */
    public function getExcavateHistoryCount()
    {
        return $this->count(self::_EXCAVATE_HISTORY);
    }

    /**
     * Sets value of '_draw_def_vitality' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setDrawDefVitality($value)
    {
        return $this->set(self::_DRAW_DEF_VITALITY, $value);
    }

    /**
     * Returns value of '_draw_def_vitality' property
     *
     * @return int
     */
    public function getDrawDefVitality()
    {
        return $this->get(self::_DRAW_DEF_VITALITY);
    }
}

/**
 * excavate_battle_hero message
 */
class Down_ExcavateBattleHero extends \ProtobufMessage
{
    /* Field index constants */
    const _BASE = 1;
    const _DYNA = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_BASE => array(
            'name' => '_base',
            'required' => true,
            'type' => 'Down_HeroSummary'
        ),
        self::_DYNA => array(
            'name' => '_dyna',
            'required' => true,
            'type' => 'Down_HeroDyna'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_BASE] = null;
        $this->values[self::_DYNA] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_base' property
     *
     * @param Down_HeroSummary $value Property value
     *
     * @return null
     */
    public function setBase(Down_HeroSummary $value)
    {
        return $this->set(self::_BASE, $value);
    }

    /**
     * Returns value of '_base' property
     *
     * @return Down_HeroSummary
     */
    public function getBase()
    {
        return $this->get(self::_BASE);
    }

    /**
     * Sets value of '_dyna' property
     *
     * @param Down_HeroDyna $value Property value
     *
     * @return null
     */
    public function setDyna(Down_HeroDyna $value)
    {
        return $this->set(self::_DYNA, $value);
    }

    /**
     * Returns value of '_dyna' property
     *
     * @return Down_HeroDyna
     */
    public function getDyna()
    {
        return $this->get(self::_DYNA);
    }
}

/**
 * excavate_battle_team message
 */
class Down_ExcavateBattleTeam extends \ProtobufMessage
{
    /* Field index constants */
    const _PLAYER = 1;
    const _HERO = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_PLAYER => array(
            'name' => '_player',
            'required' => true,
            'type' => 'Down_UserSummary'
        ),
        self::_HERO => array(
            'name' => '_hero',
            'repeated' => true,
            'type' => 'Down_ExcavateBattleHero'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_PLAYER] = null;
        $this->values[self::_HERO] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_player' property
     *
     * @param Down_UserSummary $value Property value
     *
     * @return null
     */
    public function setPlayer(Down_UserSummary $value)
    {
        return $this->set(self::_PLAYER, $value);
    }

    /**
     * Returns value of '_player' property
     *
     * @return Down_UserSummary
     */
    public function getPlayer()
    {
        return $this->get(self::_PLAYER);
    }

    /**
     * Appends value to '_hero' list
     *
     * @param Down_ExcavateBattleHero $value Value to append
     *
     * @return null
     */
    public function appendHero(Down_ExcavateBattleHero $value)
    {
        return $this->append(self::_HERO, $value);
    }

    /**
     * Clears '_hero' list
     *
     * @return null
     */
    public function clearHero()
    {
        return $this->clear(self::_HERO);
    }

    /**
     * Returns '_hero' list
     *
     * @return Down_ExcavateBattleHero[]
     */
    public function getHero()
    {
        return $this->get(self::_HERO);
    }

    /**
     * Returns '_hero' iterator
     *
     * @return ArrayIterator
     */
    public function getHeroIterator()
    {
        return new \ArrayIterator($this->get(self::_HERO));
    }

    /**
     * Returns element from '_hero' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_ExcavateBattleHero
     */
    public function getHeroAt($offset)
    {
        return $this->get(self::_HERO, $offset);
    }

    /**
     * Returns count of '_hero' list
     *
     * @return int
     */
    public function getHeroCount()
    {
        return $this->count(self::_HERO);
    }
}

/**
 * excavate_battle message
 */
class Down_ExcavateBattle extends \ProtobufMessage
{
    /* Field index constants */
    const _SELF_TEAM = 1;
    const _OPPO_TEAM = 2;
    const _RESULT = 3;
    const _RECORD_ID = 4;
    const _RECORD_SVRID = 5;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_SELF_TEAM => array(
            'name' => '_self_team',
            'required' => true,
            'type' => 'Down_ExcavateBattleTeam'
        ),
        self::_OPPO_TEAM => array(
            'name' => '_oppo_team',
            'required' => true,
            'type' => 'Down_ExcavateBattleTeam'
        ),
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_RECORD_ID => array(
            'name' => '_record_id',
            'required' => true,
            'type' => 5,
        ),
        self::_RECORD_SVRID => array(
            'name' => '_record_svrid',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_SELF_TEAM] = null;
        $this->values[self::_OPPO_TEAM] = null;
        $this->values[self::_RESULT] = null;
        $this->values[self::_RECORD_ID] = null;
        $this->values[self::_RECORD_SVRID] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_self_team' property
     *
     * @param Down_ExcavateBattleTeam $value Property value
     *
     * @return null
     */
    public function setSelfTeam(Down_ExcavateBattleTeam $value)
    {
        return $this->set(self::_SELF_TEAM, $value);
    }

    /**
     * Returns value of '_self_team' property
     *
     * @return Down_ExcavateBattleTeam
     */
    public function getSelfTeam()
    {
        return $this->get(self::_SELF_TEAM);
    }

    /**
     * Sets value of '_oppo_team' property
     *
     * @param Down_ExcavateBattleTeam $value Property value
     *
     * @return null
     */
    public function setOppoTeam(Down_ExcavateBattleTeam $value)
    {
        return $this->set(self::_OPPO_TEAM, $value);
    }

    /**
     * Returns value of '_oppo_team' property
     *
     * @return Down_ExcavateBattleTeam
     */
    public function getOppoTeam()
    {
        return $this->get(self::_OPPO_TEAM);
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_record_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRecordId($value)
    {
        return $this->set(self::_RECORD_ID, $value);
    }

    /**
     * Returns value of '_record_id' property
     *
     * @return int
     */
    public function getRecordId()
    {
        return $this->get(self::_RECORD_ID);
    }

    /**
     * Sets value of '_record_svrid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRecordSvrid($value)
    {
        return $this->set(self::_RECORD_SVRID, $value);
    }

    /**
     * Returns value of '_record_svrid' property
     *
     * @return int
     */
    public function getRecordSvrid()
    {
        return $this->get(self::_RECORD_SVRID);
    }
}

/**
 * query_excavate_battle_reply message
 */
class Down_QueryExcavateBattleReply extends \ProtobufMessage
{
    /* Field index constants */
    const _BATTLES = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_BATTLES => array(
            'name' => '_battles',
            'repeated' => true,
            'type' => 'Down_ExcavateBattle'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_BATTLES] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_battles' list
     *
     * @param Down_ExcavateBattle $value Value to append
     *
     * @return null
     */
    public function appendBattles(Down_ExcavateBattle $value)
    {
        return $this->append(self::_BATTLES, $value);
    }

    /**
     * Clears '_battles' list
     *
     * @return null
     */
    public function clearBattles()
    {
        return $this->clear(self::_BATTLES);
    }

    /**
     * Returns '_battles' list
     *
     * @return Down_ExcavateBattle[]
     */
    public function getBattles()
    {
        return $this->get(self::_BATTLES);
    }

    /**
     * Returns '_battles' iterator
     *
     * @return ArrayIterator
     */
    public function getBattlesIterator()
    {
        return new \ArrayIterator($this->get(self::_BATTLES));
    }

    /**
     * Returns element from '_battles' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_ExcavateBattle
     */
    public function getBattlesAt($offset)
    {
        return $this->get(self::_BATTLES, $offset);
    }

    /**
     * Returns count of '_battles' list
     *
     * @return int
     */
    public function getBattlesCount()
    {
        return $this->count(self::_BATTLES);
    }
}

/**
 * result enum embedded in set_excavate_team_reply message
 */
final class Down_SetExcavateTeamReply_Result
{
    const success = 0;
    const failed = 1;
    const expired = 2;
    const fall = 3;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'success' => self::success,
            'failed' => self::failed,
            'expired' => self::expired,
            'fall' => self::fall,
        );
    }
}

/**
 * set_excavate_team_reply message
 */
class Down_SetExcavateTeamReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _MINE = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_MINE => array(
            'name' => '_mine',
            'required' => false,
            'type' => 'Down_Excavate'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_MINE] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_mine' property
     *
     * @param Down_Excavate $value Property value
     *
     * @return null
     */
    public function setMine(Down_Excavate $value)
    {
        return $this->set(self::_MINE, $value);
    }

    /**
     * Returns value of '_mine' property
     *
     * @return Down_Excavate
     */
    public function getMine()
    {
        return $this->get(self::_MINE);
    }
}

/**
 * excavate_start_battle_reply message
 */
class Down_ExcavateStartBattleReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _RSEED = 2;
    const _HERO_BASES = 3;
    const _HERO_DYNAS = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_Result::success, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_RSEED => array(
            'name' => '_rseed',
            'required' => true,
            'type' => 5,
        ),
        self::_HERO_BASES => array(
            'name' => '_hero_bases',
            'repeated' => true,
            'type' => 'Down_Hero'
        ),
        self::_HERO_DYNAS => array(
            'name' => '_hero_dynas',
            'repeated' => true,
            'type' => 'Down_HeroDyna'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_RSEED] = null;
        $this->values[self::_HERO_BASES] = array();
        $this->values[self::_HERO_DYNAS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_rseed' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRseed($value)
    {
        return $this->set(self::_RSEED, $value);
    }

    /**
     * Returns value of '_rseed' property
     *
     * @return int
     */
    public function getRseed()
    {
        return $this->get(self::_RSEED);
    }

    /**
     * Appends value to '_hero_bases' list
     *
     * @param Down_Hero $value Value to append
     *
     * @return null
     */
    public function appendHeroBases(Down_Hero $value)
    {
        return $this->append(self::_HERO_BASES, $value);
    }

    /**
     * Clears '_hero_bases' list
     *
     * @return null
     */
    public function clearHeroBases()
    {
        return $this->clear(self::_HERO_BASES);
    }

    /**
     * Returns '_hero_bases' list
     *
     * @return Down_Hero[]
     */
    public function getHeroBases()
    {
        return $this->get(self::_HERO_BASES);
    }

    /**
     * Returns '_hero_bases' iterator
     *
     * @return ArrayIterator
     */
    public function getHeroBasesIterator()
    {
        return new \ArrayIterator($this->get(self::_HERO_BASES));
    }

    /**
     * Returns element from '_hero_bases' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_Hero
     */
    public function getHeroBasesAt($offset)
    {
        return $this->get(self::_HERO_BASES, $offset);
    }

    /**
     * Returns count of '_hero_bases' list
     *
     * @return int
     */
    public function getHeroBasesCount()
    {
        return $this->count(self::_HERO_BASES);
    }

    /**
     * Appends value to '_hero_dynas' list
     *
     * @param Down_HeroDyna $value Value to append
     *
     * @return null
     */
    public function appendHeroDynas(Down_HeroDyna $value)
    {
        return $this->append(self::_HERO_DYNAS, $value);
    }

    /**
     * Clears '_hero_dynas' list
     *
     * @return null
     */
    public function clearHeroDynas()
    {
        return $this->clear(self::_HERO_DYNAS);
    }

    /**
     * Returns '_hero_dynas' list
     *
     * @return Down_HeroDyna[]
     */
    public function getHeroDynas()
    {
        return $this->get(self::_HERO_DYNAS);
    }

    /**
     * Returns '_hero_dynas' iterator
     *
     * @return ArrayIterator
     */
    public function getHeroDynasIterator()
    {
        return new \ArrayIterator($this->get(self::_HERO_DYNAS));
    }

    /**
     * Returns element from '_hero_dynas' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_HeroDyna
     */
    public function getHeroDynasAt($offset)
    {
        return $this->get(self::_HERO_DYNAS, $offset);
    }

    /**
     * Returns count of '_hero_dynas' list
     *
     * @return int
     */
    public function getHeroDynasCount()
    {
        return $this->count(self::_HERO_DYNAS);
    }
}

/**
 * mine_battle_result enum embedded in excavate_end_battle_reply message
 */
final class Down_ExcavateEndBattleReply_MineBattleResult
{
    const success = 0;
    const timeout = 1;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'success' => self::success,
            'timeout' => self::timeout,
        );
    }
}

/**
 * excavate_end_battle_reply message
 */
class Down_ExcavateEndBattleReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _EXCAVATE = 2;
    const _REWARD = 3;
    const _MINE_BATTLE_RESULT = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_BattleResult::victory, 
            'name' => '_result',
            'required' => false,
            'type' => 5,
        ),
        self::_EXCAVATE => array(
            'name' => '_excavate',
            'required' => false,
            'type' => 'Down_Excavate'
        ),
        self::_REWARD => array(
            'name' => '_reward',
            'repeated' => true,
            'type' => 'Down_ExcavateReward'
        ),
        self::_MINE_BATTLE_RESULT => array(
            'default' => Down_ExcavateEndBattleReply_MineBattleResult::success, 
            'name' => '_mine_battle_result',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = Down_BattleResult::victory;
        $this->values[self::_EXCAVATE] = null;
        $this->values[self::_REWARD] = array();
        $this->values[self::_MINE_BATTLE_RESULT] = Down_ExcavateEndBattleReply_MineBattleResult::success;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_excavate' property
     *
     * @param Down_Excavate $value Property value
     *
     * @return null
     */
    public function setExcavate(Down_Excavate $value)
    {
        return $this->set(self::_EXCAVATE, $value);
    }

    /**
     * Returns value of '_excavate' property
     *
     * @return Down_Excavate
     */
    public function getExcavate()
    {
        return $this->get(self::_EXCAVATE);
    }

    /**
     * Appends value to '_reward' list
     *
     * @param Down_ExcavateReward $value Value to append
     *
     * @return null
     */
    public function appendReward(Down_ExcavateReward $value)
    {
        return $this->append(self::_REWARD, $value);
    }

    /**
     * Clears '_reward' list
     *
     * @return null
     */
    public function clearReward()
    {
        return $this->clear(self::_REWARD);
    }

    /**
     * Returns '_reward' list
     *
     * @return Down_ExcavateReward[]
     */
    public function getReward()
    {
        return $this->get(self::_REWARD);
    }

    /**
     * Returns '_reward' iterator
     *
     * @return ArrayIterator
     */
    public function getRewardIterator()
    {
        return new \ArrayIterator($this->get(self::_REWARD));
    }

    /**
     * Returns element from '_reward' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_ExcavateReward
     */
    public function getRewardAt($offset)
    {
        return $this->get(self::_REWARD, $offset);
    }

    /**
     * Returns count of '_reward' list
     *
     * @return int
     */
    public function getRewardCount()
    {
        return $this->count(self::_REWARD);
    }

    /**
     * Sets value of '_mine_battle_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setMineBattleResult($value)
    {
        return $this->set(self::_MINE_BATTLE_RESULT, $value);
    }

    /**
     * Returns value of '_mine_battle_result' property
     *
     * @return int
     */
    public function getMineBattleResult()
    {
        return $this->get(self::_MINE_BATTLE_RESULT);
    }
}

/**
 * draw_excav_res_reply message
 */
class Down_DrawExcavResReply extends \ProtobufMessage
{
    /* Field index constants */
    const _DIAMOND = 1;
    const _REWARD = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_DIAMOND => array(
            'name' => '_diamond',
            'required' => false,
            'type' => 5,
        ),
        self::_REWARD => array(
            'name' => '_reward',
            'repeated' => true,
            'type' => 'Down_ExcavateReward'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_DIAMOND] = null;
        $this->values[self::_REWARD] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_diamond' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setDiamond($value)
    {
        return $this->set(self::_DIAMOND, $value);
    }

    /**
     * Returns value of '_diamond' property
     *
     * @return int
     */
    public function getDiamond()
    {
        return $this->get(self::_DIAMOND);
    }

    /**
     * Appends value to '_reward' list
     *
     * @param Down_ExcavateReward $value Value to append
     *
     * @return null
     */
    public function appendReward(Down_ExcavateReward $value)
    {
        return $this->append(self::_REWARD, $value);
    }

    /**
     * Clears '_reward' list
     *
     * @return null
     */
    public function clearReward()
    {
        return $this->clear(self::_REWARD);
    }

    /**
     * Returns '_reward' list
     *
     * @return Down_ExcavateReward[]
     */
    public function getReward()
    {
        return $this->get(self::_REWARD);
    }

    /**
     * Returns '_reward' iterator
     *
     * @return ArrayIterator
     */
    public function getRewardIterator()
    {
        return new \ArrayIterator($this->get(self::_REWARD));
    }

    /**
     * Returns element from '_reward' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_ExcavateReward
     */
    public function getRewardAt($offset)
    {
        return $this->get(self::_REWARD, $offset);
    }

    /**
     * Returns count of '_reward' list
     *
     * @return int
     */
    public function getRewardCount()
    {
        return $this->count(self::_REWARD);
    }
}

/**
 * type enum embedded in excavate_reward message
 */
final class Down_ExcavateReward_Type
{
    const gold = 1;
    const diamond = 2;
    const item = 3;
    const wood = 4;
    const iron = 5;
    const crystal = 6;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'gold' => self::gold,
            'diamond' => self::diamond,
            'item' => self::item,
            'wood' => self::wood,
            'iron' => self::iron,
            'crystal' => self::crystal,
        );
    }
}

/**
 * excavate_reward message
 */
class Down_ExcavateReward extends \ProtobufMessage
{
    /* Field index constants */
    const _TYPE = 1;
    const _TEAM_ID = 2;
    const _PARAM1 = 3;
    const _PARAM2 = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TYPE => array(
            'name' => '_type',
            'required' => true,
            'type' => 5,
        ),
        self::_TEAM_ID => array(
            'name' => '_team_id',
            'required' => false,
            'type' => 5,
        ),
        self::_PARAM1 => array(
            'name' => '_param1',
            'required' => false,
            'type' => 5,
        ),
        self::_PARAM2 => array(
            'name' => '_param2',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_TYPE] = null;
        $this->values[self::_TEAM_ID] = null;
        $this->values[self::_PARAM1] = null;
        $this->values[self::_PARAM2] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_type' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setType($value)
    {
        return $this->set(self::_TYPE, $value);
    }

    /**
     * Returns value of '_type' property
     *
     * @return int
     */
    public function getType()
    {
        return $this->get(self::_TYPE);
    }

    /**
     * Sets value of '_team_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setTeamId($value)
    {
        return $this->set(self::_TEAM_ID, $value);
    }

    /**
     * Returns value of '_team_id' property
     *
     * @return int
     */
    public function getTeamId()
    {
        return $this->get(self::_TEAM_ID);
    }

    /**
     * Sets value of '_param1' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setParam1($value)
    {
        return $this->set(self::_PARAM1, $value);
    }

    /**
     * Returns value of '_param1' property
     *
     * @return int
     */
    public function getParam1()
    {
        return $this->get(self::_PARAM1);
    }

    /**
     * Sets value of '_param2' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setParam2($value)
    {
        return $this->set(self::_PARAM2, $value);
    }

    /**
     * Returns value of '_param2' property
     *
     * @return int
     */
    public function getParam2()
    {
        return $this->get(self::_PARAM2);
    }
}

/**
 * query_excavate_def_reply message
 */
class Down_QueryExcavateDefReply extends \ProtobufMessage
{
    /* Field index constants */
    const _EXCAVATE = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_EXCAVATE => array(
            'name' => '_excavate',
            'required' => false,
            'type' => 'Down_Excavate'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_EXCAVATE] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_excavate' property
     *
     * @param Down_Excavate $value Property value
     *
     * @return null
     */
    public function setExcavate(Down_Excavate $value)
    {
        return $this->set(self::_EXCAVATE, $value);
    }

    /**
     * Returns value of '_excavate' property
     *
     * @return Down_Excavate
     */
    public function getExcavate()
    {
        return $this->get(self::_EXCAVATE);
    }
}

/**
 * clear_excavate_battle_reply message
 */
class Down_ClearExcavateBattleReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_Result::success, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }
}

/**
 * withdraw_excavate_hero_reply message
 */
class Down_WithdrawExcavateHeroReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_Result::success, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }
}

/**
 * draw_excavate_def_rwd_reply message
 */
class Down_DrawExcavateDefRwdReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _DRAW_VITALITY = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_Result::success, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_DRAW_VITALITY => array(
            'name' => '_draw_vitality',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_DRAW_VITALITY] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_draw_vitality' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setDrawVitality($value)
    {
        return $this->set(self::_DRAW_VITALITY, $value);
    }

    /**
     * Returns value of '_draw_vitality' property
     *
     * @return int
     */
    public function getDrawVitality()
    {
        return $this->get(self::_DRAW_VITALITY);
    }
}

/**
 * drop_excavate_reply message
 */
class Down_DropExcavateReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _REWARD = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Down_Result::success, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_REWARD => array(
            'name' => '_reward',
            'required' => false,
            'type' => 'Down_ExcavateReward'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_REWARD] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_reward' property
     *
     * @param Down_ExcavateReward $value Property value
     *
     * @return null
     */
    public function setReward(Down_ExcavateReward $value)
    {
        return $this->set(self::_REWARD, $value);
    }

    /**
     * Returns value of '_reward' property
     *
     * @return Down_ExcavateReward
     */
    public function getReward()
    {
        return $this->get(self::_REWARD);
    }
}

/**
 * change_server_reply message
 */
class Down_ChangeServerReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _SERVER_INFO = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_SERVER_INFO => array(
            'name' => '_server_info',
            'repeated' => true,
            'type' => 'Down_ServerInfo'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_SERVER_INFO] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Appends value to '_server_info' list
     *
     * @param Down_ServerInfo $value Value to append
     *
     * @return null
     */
    public function appendServerInfo(Down_ServerInfo $value)
    {
        return $this->append(self::_SERVER_INFO, $value);
    }

    /**
     * Clears '_server_info' list
     *
     * @return null
     */
    public function clearServerInfo()
    {
        return $this->clear(self::_SERVER_INFO);
    }

    /**
     * Returns '_server_info' list
     *
     * @return Down_ServerInfo[]
     */
    public function getServerInfo()
    {
        return $this->get(self::_SERVER_INFO);
    }

    /**
     * Returns '_server_info' iterator
     *
     * @return ArrayIterator
     */
    public function getServerInfoIterator()
    {
        return new \ArrayIterator($this->get(self::_SERVER_INFO));
    }

    /**
     * Returns element from '_server_info' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_ServerInfo
     */
    public function getServerInfoAt($offset)
    {
        return $this->get(self::_SERVER_INFO, $offset);
    }

    /**
     * Returns count of '_server_info' list
     *
     * @return int
     */
    public function getServerInfoCount()
    {
        return $this->count(self::_SERVER_INFO);
    }
}

/**
 * server_info message
 */
class Down_ServerInfo extends \ProtobufMessage
{
    /* Field index constants */
    const _SERVER_ID = 1;
    const _SERVER_NAME = 2;
    const _PLAYER_NAME = 3;
    const _PLAYER_LEVEL = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_SERVER_ID => array(
            'name' => '_server_id',
            'required' => true,
            'type' => 5,
        ),
        self::_SERVER_NAME => array(
            'name' => '_server_name',
            'required' => true,
            'type' => 7,
        ),
        self::_PLAYER_NAME => array(
            'name' => '_player_name',
            'required' => false,
            'type' => 7,
        ),
        self::_PLAYER_LEVEL => array(
            'name' => '_player_level',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_SERVER_ID] = null;
        $this->values[self::_SERVER_NAME] = null;
        $this->values[self::_PLAYER_NAME] = null;
        $this->values[self::_PLAYER_LEVEL] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_server_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setServerId($value)
    {
        return $this->set(self::_SERVER_ID, $value);
    }

    /**
     * Returns value of '_server_id' property
     *
     * @return int
     */
    public function getServerId()
    {
        return $this->get(self::_SERVER_ID);
    }

    /**
     * Sets value of '_server_name' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setServerName($value)
    {
        return $this->set(self::_SERVER_NAME, $value);
    }

    /**
     * Returns value of '_server_name' property
     *
     * @return string
     */
    public function getServerName()
    {
        return $this->get(self::_SERVER_NAME);
    }

    /**
     * Sets value of '_player_name' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setPlayerName($value)
    {
        return $this->set(self::_PLAYER_NAME, $value);
    }

    /**
     * Returns value of '_player_name' property
     *
     * @return string
     */
    public function getPlayerName()
    {
        return $this->get(self::_PLAYER_NAME);
    }

    /**
     * Sets value of '_player_level' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setPlayerLevel($value)
    {
        return $this->set(self::_PLAYER_LEVEL, $value);
    }

    /**
     * Returns value of '_player_level' property
     *
     * @return int
     */
    public function getPlayerLevel()
    {
        return $this->get(self::_PLAYER_LEVEL);
    }
}

/**
 * is_can_jump enum embedded in guild_instance_query message
 */
final class Down_GuildInstanceQuery_IsCanJump
{
    const true = 1;
    const false = 2;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'true' => self::true,
            'false' => self::false,
        );
    }
}

/**
 * guild_instance_query message
 */
class Down_GuildInstanceQuery extends \ProtobufMessage
{
    /* Field index constants */
    const _CURRENT_RAID_ID = 1;
    const _SUMMARY = 2;
    const _STAGE_PASS = 3;
    const _IS_CAN_JUMP = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_CURRENT_RAID_ID => array(
            'name' => '_current_raid_id',
            'required' => true,
            'type' => 5,
        ),
        self::_SUMMARY => array(
            'name' => '_summary',
            'repeated' => true,
            'type' => 'Down_GuildInstanceSummary'
        ),
        self::_STAGE_PASS => array(
            'name' => '_stage_pass',
            'required' => false,
            'type' => 5,
        ),
        self::_IS_CAN_JUMP => array(
            'name' => '_is_can_jump',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_CURRENT_RAID_ID] = null;
        $this->values[self::_SUMMARY] = array();
        $this->values[self::_STAGE_PASS] = null;
        $this->values[self::_IS_CAN_JUMP] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_current_raid_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCurrentRaidId($value)
    {
        return $this->set(self::_CURRENT_RAID_ID, $value);
    }

    /**
     * Returns value of '_current_raid_id' property
     *
     * @return int
     */
    public function getCurrentRaidId()
    {
        return $this->get(self::_CURRENT_RAID_ID);
    }

    /**
     * Appends value to '_summary' list
     *
     * @param Down_GuildInstanceSummary $value Value to append
     *
     * @return null
     */
    public function appendSummary(Down_GuildInstanceSummary $value)
    {
        return $this->append(self::_SUMMARY, $value);
    }

    /**
     * Clears '_summary' list
     *
     * @return null
     */
    public function clearSummary()
    {
        return $this->clear(self::_SUMMARY);
    }

    /**
     * Returns '_summary' list
     *
     * @return Down_GuildInstanceSummary[]
     */
    public function getSummary()
    {
        return $this->get(self::_SUMMARY);
    }

    /**
     * Returns '_summary' iterator
     *
     * @return ArrayIterator
     */
    public function getSummaryIterator()
    {
        return new \ArrayIterator($this->get(self::_SUMMARY));
    }

    /**
     * Returns element from '_summary' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_GuildInstanceSummary
     */
    public function getSummaryAt($offset)
    {
        return $this->get(self::_SUMMARY, $offset);
    }

    /**
     * Returns count of '_summary' list
     *
     * @return int
     */
    public function getSummaryCount()
    {
        return $this->count(self::_SUMMARY);
    }

    /**
     * Sets value of '_stage_pass' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStagePass($value)
    {
        return $this->set(self::_STAGE_PASS, $value);
    }

    /**
     * Returns value of '_stage_pass' property
     *
     * @return int
     */
    public function getStagePass()
    {
        return $this->get(self::_STAGE_PASS);
    }

    /**
     * Sets value of '_is_can_jump' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setIsCanJump($value)
    {
        return $this->set(self::_IS_CAN_JUMP, $value);
    }

    /**
     * Returns value of '_is_can_jump' property
     *
     * @return int
     */
    public function getIsCanJump()
    {
        return $this->get(self::_IS_CAN_JUMP);
    }
}

/**
 * guild_chapter message
 */
class Down_GuildChapter extends \ProtobufMessage
{
    /* Field index constants */
    const _ID = 1;
    const _PROGRESS = 2;
    const _BEGIN_TIME = 3;
    const _REST_TIMES = 4;
    const _CUR_STAGE_ID = 5;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ID => array(
            'name' => '_id',
            'required' => true,
            'type' => 5,
        ),
        self::_PROGRESS => array(
            'name' => '_progress',
            'required' => true,
            'type' => 5,
        ),
        self::_BEGIN_TIME => array(
            'name' => '_begin_time',
            'required' => true,
            'type' => 5,
        ),
        self::_REST_TIMES => array(
            'name' => '_rest_times',
            'required' => true,
            'type' => 5,
        ),
        self::_CUR_STAGE_ID => array(
            'name' => '_cur_stage_id',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ID] = null;
        $this->values[self::_PROGRESS] = null;
        $this->values[self::_BEGIN_TIME] = null;
        $this->values[self::_REST_TIMES] = null;
        $this->values[self::_CUR_STAGE_ID] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setId($value)
    {
        return $this->set(self::_ID, $value);
    }

    /**
     * Returns value of '_id' property
     *
     * @return int
     */
    public function getId()
    {
        return $this->get(self::_ID);
    }

    /**
     * Sets value of '_progress' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setProgress($value)
    {
        return $this->set(self::_PROGRESS, $value);
    }

    /**
     * Returns value of '_progress' property
     *
     * @return int
     */
    public function getProgress()
    {
        return $this->get(self::_PROGRESS);
    }

    /**
     * Sets value of '_begin_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setBeginTime($value)
    {
        return $this->set(self::_BEGIN_TIME, $value);
    }

    /**
     * Returns value of '_begin_time' property
     *
     * @return int
     */
    public function getBeginTime()
    {
        return $this->get(self::_BEGIN_TIME);
    }

    /**
     * Sets value of '_rest_times' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRestTimes($value)
    {
        return $this->set(self::_REST_TIMES, $value);
    }

    /**
     * Returns value of '_rest_times' property
     *
     * @return int
     */
    public function getRestTimes()
    {
        return $this->get(self::_REST_TIMES);
    }

    /**
     * Sets value of '_cur_stage_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCurStageId($value)
    {
        return $this->set(self::_CUR_STAGE_ID, $value);
    }

    /**
     * Returns value of '_cur_stage_id' property
     *
     * @return int
     */
    public function getCurStageId()
    {
        return $this->get(self::_CUR_STAGE_ID);
    }
}

/**
 * challenger_status enum embedded in guild_instance_detail message
 */
final class Down_GuildInstanceDetail_ChallengerStatus
{
    const battle = 1;
    const prepare = 2;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'battle' => self::battle,
            'prepare' => self::prepare,
        );
    }
}

/**
 * guild_instance_detail message
 */
class Down_GuildInstanceDetail extends \ProtobufMessage
{
    /* Field index constants */
    const _STAGE = 1;
    const _WAVE = 2;
    const _HP = 3;
    const _RECORD = 4;
    const _CHALLENGER = 5;
    const _CHALLENGER_STATUS = 6;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_STAGE => array(
            'name' => '_stage',
            'required' => true,
            'type' => 5,
        ),
        self::_WAVE => array(
            'name' => '_wave',
            'required' => true,
            'type' => 5,
        ),
        self::_HP => array(
            'name' => '_hp',
            'repeated' => true,
            'type' => 5,
        ),
        self::_RECORD => array(
            'name' => '_record',
            'repeated' => true,
            'type' => 'Down_GuildInstanceRecord'
        ),
        self::_CHALLENGER => array(
            'name' => '_challenger',
            'required' => false,
            'type' => 'Down_GuildChallenger'
        ),
        self::_CHALLENGER_STATUS => array(
            'name' => '_challenger_status',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_STAGE] = null;
        $this->values[self::_WAVE] = null;
        $this->values[self::_HP] = array();
        $this->values[self::_RECORD] = array();
        $this->values[self::_CHALLENGER] = null;
        $this->values[self::_CHALLENGER_STATUS] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_stage' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStage($value)
    {
        return $this->set(self::_STAGE, $value);
    }

    /**
     * Returns value of '_stage' property
     *
     * @return int
     */
    public function getStage()
    {
        return $this->get(self::_STAGE);
    }

    /**
     * Sets value of '_wave' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setWave($value)
    {
        return $this->set(self::_WAVE, $value);
    }

    /**
     * Returns value of '_wave' property
     *
     * @return int
     */
    public function getWave()
    {
        return $this->get(self::_WAVE);
    }

    /**
     * Appends value to '_hp' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendHp($value)
    {
        return $this->append(self::_HP, $value);
    }

    /**
     * Clears '_hp' list
     *
     * @return null
     */
    public function clearHp()
    {
        return $this->clear(self::_HP);
    }

    /**
     * Returns '_hp' list
     *
     * @return int[]
     */
    public function getHp()
    {
        return $this->get(self::_HP);
    }

    /**
     * Returns '_hp' iterator
     *
     * @return ArrayIterator
     */
    public function getHpIterator()
    {
        return new \ArrayIterator($this->get(self::_HP));
    }

    /**
     * Returns element from '_hp' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getHpAt($offset)
    {
        return $this->get(self::_HP, $offset);
    }

    /**
     * Returns count of '_hp' list
     *
     * @return int
     */
    public function getHpCount()
    {
        return $this->count(self::_HP);
    }

    /**
     * Appends value to '_record' list
     *
     * @param Down_GuildInstanceRecord $value Value to append
     *
     * @return null
     */
    public function appendRecord(Down_GuildInstanceRecord $value)
    {
        return $this->append(self::_RECORD, $value);
    }

    /**
     * Clears '_record' list
     *
     * @return null
     */
    public function clearRecord()
    {
        return $this->clear(self::_RECORD);
    }

    /**
     * Returns '_record' list
     *
     * @return Down_GuildInstanceRecord[]
     */
    public function getRecord()
    {
        return $this->get(self::_RECORD);
    }

    /**
     * Returns '_record' iterator
     *
     * @return ArrayIterator
     */
    public function getRecordIterator()
    {
        return new \ArrayIterator($this->get(self::_RECORD));
    }

    /**
     * Returns element from '_record' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_GuildInstanceRecord
     */
    public function getRecordAt($offset)
    {
        return $this->get(self::_RECORD, $offset);
    }

    /**
     * Returns count of '_record' list
     *
     * @return int
     */
    public function getRecordCount()
    {
        return $this->count(self::_RECORD);
    }

    /**
     * Sets value of '_challenger' property
     *
     * @param Down_GuildChallenger $value Property value
     *
     * @return null
     */
    public function setChallenger(Down_GuildChallenger $value)
    {
        return $this->set(self::_CHALLENGER, $value);
    }

    /**
     * Returns value of '_challenger' property
     *
     * @return Down_GuildChallenger
     */
    public function getChallenger()
    {
        return $this->get(self::_CHALLENGER);
    }

    /**
     * Sets value of '_challenger_status' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setChallengerStatus($value)
    {
        return $this->set(self::_CHALLENGER_STATUS, $value);
    }

    /**
     * Returns value of '_challenger_status' property
     *
     * @return int
     */
    public function getChallengerStatus()
    {
        return $this->get(self::_CHALLENGER_STATUS);
    }
}

/**
 * guild_challenger message
 */
class Down_GuildChallenger extends \ProtobufMessage
{
    /* Field index constants */
    const _SUMMARY = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_SUMMARY => array(
            'name' => '_summary',
            'required' => true,
            'type' => 'Down_UserSummary'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_SUMMARY] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_summary' property
     *
     * @param Down_UserSummary $value Property value
     *
     * @return null
     */
    public function setSummary(Down_UserSummary $value)
    {
        return $this->set(self::_SUMMARY, $value);
    }

    /**
     * Returns value of '_summary' property
     *
     * @return Down_UserSummary
     */
    public function getSummary()
    {
        return $this->get(self::_SUMMARY);
    }
}

/**
 * guild_instance_record message
 */
class Down_GuildInstanceRecord extends \ProtobufMessage
{
    /* Field index constants */
    const _CHALLENGER = 1;
    const _DAMAGE = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_CHALLENGER => array(
            'name' => '_challenger',
            'required' => true,
            'type' => 'Down_GuildChallenger'
        ),
        self::_DAMAGE => array(
            'name' => '_damage',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_CHALLENGER] = null;
        $this->values[self::_DAMAGE] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_challenger' property
     *
     * @param Down_GuildChallenger $value Property value
     *
     * @return null
     */
    public function setChallenger(Down_GuildChallenger $value)
    {
        return $this->set(self::_CHALLENGER, $value);
    }

    /**
     * Returns value of '_challenger' property
     *
     * @return Down_GuildChallenger
     */
    public function getChallenger()
    {
        return $this->get(self::_CHALLENGER);
    }

    /**
     * Sets value of '_damage' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setDamage($value)
    {
        return $this->set(self::_DAMAGE, $value);
    }

    /**
     * Returns value of '_damage' property
     *
     * @return int
     */
    public function getDamage()
    {
        return $this->get(self::_DAMAGE);
    }
}

/**
 * guild_instance_summary message
 */
class Down_GuildInstanceSummary extends \ProtobufMessage
{
    /* Field index constants */
    const _ID = 1;
    const _STAGE_ID = 2;
    const _LEFT_TIME = 3;
    const _START_TIME = 4;
    const _PROGRESS = 5;
    const _STAGE_PROGRESS = 6;
    const _BATTLE_USER_ID = 7;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ID => array(
            'name' => '_id',
            'required' => true,
            'type' => 5,
        ),
        self::_STAGE_ID => array(
            'name' => '_stage_id',
            'required' => true,
            'type' => 5,
        ),
        self::_LEFT_TIME => array(
            'name' => '_left_time',
            'required' => true,
            'type' => 5,
        ),
        self::_START_TIME => array(
            'name' => '_start_time',
            'required' => true,
            'type' => 5,
        ),
        self::_PROGRESS => array(
            'name' => '_progress',
            'required' => true,
            'type' => 5,
        ),
        self::_STAGE_PROGRESS => array(
            'name' => '_stage_progress',
            'required' => true,
            'type' => 5,
        ),
        self::_BATTLE_USER_ID => array(
            'name' => '_battle_user_id',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ID] = null;
        $this->values[self::_STAGE_ID] = null;
        $this->values[self::_LEFT_TIME] = null;
        $this->values[self::_START_TIME] = null;
        $this->values[self::_PROGRESS] = null;
        $this->values[self::_STAGE_PROGRESS] = null;
        $this->values[self::_BATTLE_USER_ID] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setId($value)
    {
        return $this->set(self::_ID, $value);
    }

    /**
     * Returns value of '_id' property
     *
     * @return int
     */
    public function getId()
    {
        return $this->get(self::_ID);
    }

    /**
     * Sets value of '_stage_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStageId($value)
    {
        return $this->set(self::_STAGE_ID, $value);
    }

    /**
     * Returns value of '_stage_id' property
     *
     * @return int
     */
    public function getStageId()
    {
        return $this->get(self::_STAGE_ID);
    }

    /**
     * Sets value of '_left_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setLeftTime($value)
    {
        return $this->set(self::_LEFT_TIME, $value);
    }

    /**
     * Returns value of '_left_time' property
     *
     * @return int
     */
    public function getLeftTime()
    {
        return $this->get(self::_LEFT_TIME);
    }

    /**
     * Sets value of '_start_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStartTime($value)
    {
        return $this->set(self::_START_TIME, $value);
    }

    /**
     * Returns value of '_start_time' property
     *
     * @return int
     */
    public function getStartTime()
    {
        return $this->get(self::_START_TIME);
    }

    /**
     * Sets value of '_progress' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setProgress($value)
    {
        return $this->set(self::_PROGRESS, $value);
    }

    /**
     * Returns value of '_progress' property
     *
     * @return int
     */
    public function getProgress()
    {
        return $this->get(self::_PROGRESS);
    }

    /**
     * Sets value of '_stage_progress' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStageProgress($value)
    {
        return $this->set(self::_STAGE_PROGRESS, $value);
    }

    /**
     * Returns value of '_stage_progress' property
     *
     * @return int
     */
    public function getStageProgress()
    {
        return $this->get(self::_STAGE_PROGRESS);
    }

    /**
     * Sets value of '_battle_user_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setBattleUserId($value)
    {
        return $this->set(self::_BATTLE_USER_ID, $value);
    }

    /**
     * Returns value of '_battle_user_id' property
     *
     * @return int
     */
    public function getBattleUserId()
    {
        return $this->get(self::_BATTLE_USER_ID);
    }
}

/**
 * drop_state enum embedded in guild_instance_item message
 */
final class Down_GuildInstanceItem_DropState
{
    const no_apply = 1;
    const apply = 2;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'no_apply' => self::no_apply,
            'apply' => self::apply,
        );
    }
}

/**
 * guild_instance_item message
 */
class Down_GuildInstanceItem extends \ProtobufMessage
{
    /* Field index constants */
    const _ITEM_ID = 1;
    const _NUM = 2;
    const _STATE = 3;
    const _APPLY_NUM = 4;
    const _ABLE_APP_COUNT = 5;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ITEM_ID => array(
            'name' => '_item_id',
            'required' => true,
            'type' => 5,
        ),
        self::_NUM => array(
            'name' => '_num',
            'required' => true,
            'type' => 5,
        ),
        self::_STATE => array(
            'name' => '_state',
            'required' => true,
            'type' => 5,
        ),
        self::_APPLY_NUM => array(
            'name' => '_apply_num',
            'required' => true,
            'type' => 5,
        ),
        self::_ABLE_APP_COUNT => array(
            'name' => '_able_app_count',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ITEM_ID] = null;
        $this->values[self::_NUM] = null;
        $this->values[self::_STATE] = null;
        $this->values[self::_APPLY_NUM] = null;
        $this->values[self::_ABLE_APP_COUNT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_item_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setItemId($value)
    {
        return $this->set(self::_ITEM_ID, $value);
    }

    /**
     * Returns value of '_item_id' property
     *
     * @return int
     */
    public function getItemId()
    {
        return $this->get(self::_ITEM_ID);
    }

    /**
     * Sets value of '_num' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setNum($value)
    {
        return $this->set(self::_NUM, $value);
    }

    /**
     * Returns value of '_num' property
     *
     * @return int
     */
    public function getNum()
    {
        return $this->get(self::_NUM);
    }

    /**
     * Sets value of '_state' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setState($value)
    {
        return $this->set(self::_STATE, $value);
    }

    /**
     * Returns value of '_state' property
     *
     * @return int
     */
    public function getState()
    {
        return $this->get(self::_STATE);
    }

    /**
     * Sets value of '_apply_num' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setApplyNum($value)
    {
        return $this->set(self::_APPLY_NUM, $value);
    }

    /**
     * Returns value of '_apply_num' property
     *
     * @return int
     */
    public function getApplyNum()
    {
        return $this->get(self::_APPLY_NUM);
    }

    /**
     * Sets value of '_able_app_count' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setAbleAppCount($value)
    {
        return $this->set(self::_ABLE_APP_COUNT, $value);
    }

    /**
     * Returns value of '_able_app_count' property
     *
     * @return int
     */
    public function getAbleAppCount()
    {
        return $this->get(self::_ABLE_APP_COUNT);
    }
}

/**
 * guild_instance_drop message
 */
class Down_GuildInstanceDrop extends \ProtobufMessage
{
    /* Field index constants */
    const _ITEMS = 1;
    const _RAID_ID = 2;
    const _APPLY_ITEM_ID = 3;
    const _RANK = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ITEMS => array(
            'name' => '_items',
            'repeated' => true,
            'type' => 'Down_GuildInstanceItem'
        ),
        self::_RAID_ID => array(
            'name' => '_raid_id',
            'required' => true,
            'type' => 5,
        ),
        self::_APPLY_ITEM_ID => array(
            'name' => '_apply_item_id',
            'required' => false,
            'type' => 5,
        ),
        self::_RANK => array(
            'name' => '_rank',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ITEMS] = array();
        $this->values[self::_RAID_ID] = null;
        $this->values[self::_APPLY_ITEM_ID] = null;
        $this->values[self::_RANK] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_items' list
     *
     * @param Down_GuildInstanceItem $value Value to append
     *
     * @return null
     */
    public function appendItems(Down_GuildInstanceItem $value)
    {
        return $this->append(self::_ITEMS, $value);
    }

    /**
     * Clears '_items' list
     *
     * @return null
     */
    public function clearItems()
    {
        return $this->clear(self::_ITEMS);
    }

    /**
     * Returns '_items' list
     *
     * @return Down_GuildInstanceItem[]
     */
    public function getItems()
    {
        return $this->get(self::_ITEMS);
    }

    /**
     * Returns '_items' iterator
     *
     * @return ArrayIterator
     */
    public function getItemsIterator()
    {
        return new \ArrayIterator($this->get(self::_ITEMS));
    }

    /**
     * Returns element from '_items' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_GuildInstanceItem
     */
    public function getItemsAt($offset)
    {
        return $this->get(self::_ITEMS, $offset);
    }

    /**
     * Returns count of '_items' list
     *
     * @return int
     */
    public function getItemsCount()
    {
        return $this->count(self::_ITEMS);
    }

    /**
     * Sets value of '_raid_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRaidId($value)
    {
        return $this->set(self::_RAID_ID, $value);
    }

    /**
     * Returns value of '_raid_id' property
     *
     * @return int
     */
    public function getRaidId()
    {
        return $this->get(self::_RAID_ID);
    }

    /**
     * Sets value of '_apply_item_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setApplyItemId($value)
    {
        return $this->set(self::_APPLY_ITEM_ID, $value);
    }

    /**
     * Returns value of '_apply_item_id' property
     *
     * @return int
     */
    public function getApplyItemId()
    {
        return $this->get(self::_APPLY_ITEM_ID);
    }

    /**
     * Sets value of '_rank' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRank($value)
    {
        return $this->set(self::_RANK, $value);
    }

    /**
     * Returns value of '_rank' property
     *
     * @return int
     */
    public function getRank()
    {
        return $this->get(self::_RANK);
    }
}

/**
 * splitable_hero message
 */
class Down_SplitableHero extends \ProtobufMessage
{
    /* Field index constants */
    const _TID = 1;
    const _SPLIT_TIMES = 2;
    const _END_POINT = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TID => array(
            'name' => '_tid',
            'required' => true,
            'type' => 5,
        ),
        self::_SPLIT_TIMES => array(
            'name' => '_split_times',
            'required' => true,
            'type' => 5,
        ),
        self::_END_POINT => array(
            'name' => '_end_point',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_TID] = null;
        $this->values[self::_SPLIT_TIMES] = null;
        $this->values[self::_END_POINT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_tid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setTid($value)
    {
        return $this->set(self::_TID, $value);
    }

    /**
     * Returns value of '_tid' property
     *
     * @return int
     */
    public function getTid()
    {
        return $this->get(self::_TID);
    }

    /**
     * Sets value of '_split_times' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSplitTimes($value)
    {
        return $this->set(self::_SPLIT_TIMES, $value);
    }

    /**
     * Returns value of '_split_times' property
     *
     * @return int
     */
    public function getSplitTimes()
    {
        return $this->get(self::_SPLIT_TIMES);
    }

    /**
     * Sets value of '_end_point' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setEndPoint($value)
    {
        return $this->set(self::_END_POINT, $value);
    }

    /**
     * Returns value of '_end_point' property
     *
     * @return int
     */
    public function getEndPoint()
    {
        return $this->get(self::_END_POINT);
    }
}

/**
 * query_split_data_reply message
 */
class Down_QuerySplitDataReply extends \ProtobufMessage
{
    /* Field index constants */
    const _HEROES = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_HEROES => array(
            'name' => '_heroes',
            'repeated' => true,
            'type' => 'Down_SplitableHero'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_HEROES] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_heroes' list
     *
     * @param Down_SplitableHero $value Value to append
     *
     * @return null
     */
    public function appendHeroes(Down_SplitableHero $value)
    {
        return $this->append(self::_HEROES, $value);
    }

    /**
     * Clears '_heroes' list
     *
     * @return null
     */
    public function clearHeroes()
    {
        return $this->clear(self::_HEROES);
    }

    /**
     * Returns '_heroes' list
     *
     * @return Down_SplitableHero[]
     */
    public function getHeroes()
    {
        return $this->get(self::_HEROES);
    }

    /**
     * Returns '_heroes' iterator
     *
     * @return ArrayIterator
     */
    public function getHeroesIterator()
    {
        return new \ArrayIterator($this->get(self::_HEROES));
    }

    /**
     * Returns element from '_heroes' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_SplitableHero
     */
    public function getHeroesAt($offset)
    {
        return $this->get(self::_HEROES, $offset);
    }

    /**
     * Returns count of '_heroes' list
     *
     * @return int
     */
    public function getHeroesCount()
    {
        return $this->count(self::_HEROES);
    }
}

/**
 * query_split_return_reply message
 */
class Down_QuerySplitReturnReply extends \ProtobufMessage
{
    /* Field index constants */
    const _ITEMS = 1;
    const _GOLD = 2;
    const _SKILL_POINT = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ITEMS => array(
            'name' => '_items',
            'repeated' => true,
            'type' => 5,
        ),
        self::_GOLD => array(
            'name' => '_gold',
            'required' => true,
            'type' => 5,
        ),
        self::_SKILL_POINT => array(
            'name' => '_skill_point',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ITEMS] = array();
        $this->values[self::_GOLD] = null;
        $this->values[self::_SKILL_POINT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_items' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendItems($value)
    {
        return $this->append(self::_ITEMS, $value);
    }

    /**
     * Clears '_items' list
     *
     * @return null
     */
    public function clearItems()
    {
        return $this->clear(self::_ITEMS);
    }

    /**
     * Returns '_items' list
     *
     * @return int[]
     */
    public function getItems()
    {
        return $this->get(self::_ITEMS);
    }

    /**
     * Returns '_items' iterator
     *
     * @return ArrayIterator
     */
    public function getItemsIterator()
    {
        return new \ArrayIterator($this->get(self::_ITEMS));
    }

    /**
     * Returns element from '_items' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getItemsAt($offset)
    {
        return $this->get(self::_ITEMS, $offset);
    }

    /**
     * Returns count of '_items' list
     *
     * @return int
     */
    public function getItemsCount()
    {
        return $this->count(self::_ITEMS);
    }

    /**
     * Sets value of '_gold' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setGold($value)
    {
        return $this->set(self::_GOLD, $value);
    }

    /**
     * Returns value of '_gold' property
     *
     * @return int
     */
    public function getGold()
    {
        return $this->get(self::_GOLD);
    }

    /**
     * Sets value of '_skill_point' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSkillPoint($value)
    {
        return $this->set(self::_SKILL_POINT, $value);
    }

    /**
     * Returns value of '_skill_point' property
     *
     * @return int
     */
    public function getSkillPoint()
    {
        return $this->get(self::_SKILL_POINT);
    }
}

/**
 * split_hero_reply message
 */
class Down_SplitHeroReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _HERO = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_HERO => array(
            'name' => '_hero',
            'required' => false,
            'type' => 'Down_Hero'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
        $this->values[self::_HERO] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }

    /**
     * Sets value of '_hero' property
     *
     * @param Down_Hero $value Property value
     *
     * @return null
     */
    public function setHero(Down_Hero $value)
    {
        return $this->set(self::_HERO, $value);
    }

    /**
     * Returns value of '_hero' property
     *
     * @return Down_Hero
     */
    public function getHero()
    {
        return $this->get(self::_HERO);
    }
}

/**
 * worldcup_reply message
 */
class Down_WorldcupReply extends \ProtobufMessage
{
    /* Field index constants */
    const _WORLDCUP_QUERY_REPLY = 1;
    const _WORLDCUP_SUBMIT_REPLY = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_WORLDCUP_QUERY_REPLY => array(
            'name' => '_worldcup_query_reply',
            'required' => false,
            'type' => 'Down_WorldcupQueryReply'
        ),
        self::_WORLDCUP_SUBMIT_REPLY => array(
            'name' => '_worldcup_submit_reply',
            'required' => false,
            'type' => 'Down_WorldcupSubmitReply'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_WORLDCUP_QUERY_REPLY] = null;
        $this->values[self::_WORLDCUP_SUBMIT_REPLY] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_worldcup_query_reply' property
     *
     * @param Down_WorldcupQueryReply $value Property value
     *
     * @return null
     */
    public function setWorldcupQueryReply(Down_WorldcupQueryReply $value)
    {
        return $this->set(self::_WORLDCUP_QUERY_REPLY, $value);
    }

    /**
     * Returns value of '_worldcup_query_reply' property
     *
     * @return Down_WorldcupQueryReply
     */
    public function getWorldcupQueryReply()
    {
        return $this->get(self::_WORLDCUP_QUERY_REPLY);
    }

    /**
     * Sets value of '_worldcup_submit_reply' property
     *
     * @param Down_WorldcupSubmitReply $value Property value
     *
     * @return null
     */
    public function setWorldcupSubmitReply(Down_WorldcupSubmitReply $value)
    {
        return $this->set(self::_WORLDCUP_SUBMIT_REPLY, $value);
    }

    /**
     * Returns value of '_worldcup_submit_reply' property
     *
     * @return Down_WorldcupSubmitReply
     */
    public function getWorldcupSubmitReply()
    {
        return $this->get(self::_WORLDCUP_SUBMIT_REPLY);
    }
}

/**
 * worldcup_reward message
 */
class Down_WorldcupReward extends \ProtobufMessage
{
    /* Field index constants */
    const _GOLD = 1;
    const _DIAMOND = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_GOLD => array(
            'name' => '_gold',
            'required' => false,
            'type' => 5,
        ),
        self::_DIAMOND => array(
            'name' => '_diamond',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_GOLD] = null;
        $this->values[self::_DIAMOND] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_gold' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setGold($value)
    {
        return $this->set(self::_GOLD, $value);
    }

    /**
     * Returns value of '_gold' property
     *
     * @return int
     */
    public function getGold()
    {
        return $this->get(self::_GOLD);
    }

    /**
     * Sets value of '_diamond' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setDiamond($value)
    {
        return $this->set(self::_DIAMOND, $value);
    }

    /**
     * Returns value of '_diamond' property
     *
     * @return int
     */
    public function getDiamond()
    {
        return $this->get(self::_DIAMOND);
    }
}

/**
 * worldcup_comp message
 */
class Down_WorldcupComp extends \ProtobufMessage
{
    /* Field index constants */
    const _TEAMS = 1;
    const _REWARD = 2;
    const _GUESS = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TEAMS => array(
            'name' => '_teams',
            'repeated' => true,
            'type' => 5,
        ),
        self::_REWARD => array(
            'name' => '_reward',
            'required' => true,
            'type' => 'Down_WorldcupReward'
        ),
        self::_GUESS => array(
            'name' => '_guess',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_TEAMS] = array();
        $this->values[self::_REWARD] = null;
        $this->values[self::_GUESS] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_teams' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendTeams($value)
    {
        return $this->append(self::_TEAMS, $value);
    }

    /**
     * Clears '_teams' list
     *
     * @return null
     */
    public function clearTeams()
    {
        return $this->clear(self::_TEAMS);
    }

    /**
     * Returns '_teams' list
     *
     * @return int[]
     */
    public function getTeams()
    {
        return $this->get(self::_TEAMS);
    }

    /**
     * Returns '_teams' iterator
     *
     * @return ArrayIterator
     */
    public function getTeamsIterator()
    {
        return new \ArrayIterator($this->get(self::_TEAMS));
    }

    /**
     * Returns element from '_teams' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getTeamsAt($offset)
    {
        return $this->get(self::_TEAMS, $offset);
    }

    /**
     * Returns count of '_teams' list
     *
     * @return int
     */
    public function getTeamsCount()
    {
        return $this->count(self::_TEAMS);
    }

    /**
     * Sets value of '_reward' property
     *
     * @param Down_WorldcupReward $value Property value
     *
     * @return null
     */
    public function setReward(Down_WorldcupReward $value)
    {
        return $this->set(self::_REWARD, $value);
    }

    /**
     * Returns value of '_reward' property
     *
     * @return Down_WorldcupReward
     */
    public function getReward()
    {
        return $this->get(self::_REWARD);
    }

    /**
     * Sets value of '_guess' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setGuess($value)
    {
        return $this->set(self::_GUESS, $value);
    }

    /**
     * Returns value of '_guess' property
     *
     * @return int
     */
    public function getGuess()
    {
        return $this->get(self::_GUESS);
    }
}

/**
 * worldcup_query_reply message
 */
class Down_WorldcupQueryReply extends \ProtobufMessage
{
    /* Field index constants */
    const _COMP = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_COMP => array(
            'name' => '_comp',
            'repeated' => true,
            'type' => 'Down_WorldcupComp'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_COMP] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_comp' list
     *
     * @param Down_WorldcupComp $value Value to append
     *
     * @return null
     */
    public function appendComp(Down_WorldcupComp $value)
    {
        return $this->append(self::_COMP, $value);
    }

    /**
     * Clears '_comp' list
     *
     * @return null
     */
    public function clearComp()
    {
        return $this->clear(self::_COMP);
    }

    /**
     * Returns '_comp' list
     *
     * @return Down_WorldcupComp[]
     */
    public function getComp()
    {
        return $this->get(self::_COMP);
    }

    /**
     * Returns '_comp' iterator
     *
     * @return ArrayIterator
     */
    public function getCompIterator()
    {
        return new \ArrayIterator($this->get(self::_COMP));
    }

    /**
     * Returns element from '_comp' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_WorldcupComp
     */
    public function getCompAt($offset)
    {
        return $this->get(self::_COMP, $offset);
    }

    /**
     * Returns count of '_comp' list
     *
     * @return int
     */
    public function getCompCount()
    {
        return $this->count(self::_COMP);
    }
}

/**
 * worldcup_submit_reply message
 */
class Down_WorldcupSubmitReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RESULT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_result' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResult($value)
    {
        return $this->set(self::_RESULT, $value);
    }

    /**
     * Returns value of '_result' property
     *
     * @return int
     */
    public function getResult()
    {
        return $this->get(self::_RESULT);
    }
}

/**
 * battle_check_fail message
 */
class Down_BattleCheckFail extends \ProtobufMessage
{
    /* Field index constants */
    const _CHECKID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_CHECKID => array(
            'name' => '_checkid',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_CHECKID] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_checkid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCheckid($value)
    {
        return $this->set(self::_CHECKID, $value);
    }

    /**
     * Returns value of '_checkid' property
     *
     * @return int
     */
    public function getCheckid()
    {
        return $this->get(self::_CHECKID);
    }
}

/**
 * super_link message
 */
class Down_SuperLink extends \ProtobufMessage
{
    /* Field index constants */
    const _INFO = 2;
    const _ADDR = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_INFO => array(
            'name' => '_info',
            'required' => true,
            'type' => 7,
        ),
        self::_ADDR => array(
            'name' => '_addr',
            'required' => true,
            'type' => 7,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_INFO] = null;
        $this->values[self::_ADDR] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_info' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setInfo($value)
    {
        return $this->set(self::_INFO, $value);
    }

    /**
     * Returns value of '_info' property
     *
     * @return string
     */
    public function getInfo()
    {
        return $this->get(self::_INFO);
    }

    /**
     * Sets value of '_addr' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setAddr($value)
    {
        return $this->set(self::_ADDR, $value);
    }

    /**
     * Returns value of '_addr' property
     *
     * @return string
     */
    public function getAddr()
    {
        return $this->get(self::_ADDR);
    }
}

/**
 * ranklist_item message
 */
class Down_RanklistItem extends \ProtobufMessage
{
    /* Field index constants */
    const _USER_SUMMARY = 1;
    const _GUILD_SUMMARY = 2;
    const _PARAM1 = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_USER_SUMMARY => array(
            'name' => '_user_summary',
            'required' => false,
            'type' => 'Down_UserSummary'
        ),
        self::_GUILD_SUMMARY => array(
            'name' => '_guild_summary',
            'required' => false,
            'type' => 'Down_GuildSummary'
        ),
        self::_PARAM1 => array(
            'name' => '_param1',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_USER_SUMMARY] = null;
        $this->values[self::_GUILD_SUMMARY] = null;
        $this->values[self::_PARAM1] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_user_summary' property
     *
     * @param Down_UserSummary $value Property value
     *
     * @return null
     */
    public function setUserSummary(Down_UserSummary $value)
    {
        return $this->set(self::_USER_SUMMARY, $value);
    }

    /**
     * Returns value of '_user_summary' property
     *
     * @return Down_UserSummary
     */
    public function getUserSummary()
    {
        return $this->get(self::_USER_SUMMARY);
    }

    /**
     * Sets value of '_guild_summary' property
     *
     * @param Down_GuildSummary $value Property value
     *
     * @return null
     */
    public function setGuildSummary(Down_GuildSummary $value)
    {
        return $this->set(self::_GUILD_SUMMARY, $value);
    }

    /**
     * Returns value of '_guild_summary' property
     *
     * @return Down_GuildSummary
     */
    public function getGuildSummary()
    {
        return $this->get(self::_GUILD_SUMMARY);
    }

    /**
     * Sets value of '_param1' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setParam1($value)
    {
        return $this->set(self::_PARAM1, $value);
    }

    /**
     * Returns value of '_param1' property
     *
     * @return int
     */
    public function getParam1()
    {
        return $this->get(self::_PARAM1);
    }
}

/**
 * rank_type enum embedded in query_ranklist_reply message
 */
final class Down_QueryRanklistReply_RankType
{
    const guildliveness = 1;
    const excavate_rob = 2;
    const excavate_gold = 3;
    const excavate_exp = 4;
    const top_gs = 5;
    const full_hero_gs = 6;
    const hero_team_gs = 7;
    const hero_evo_star = 8;
    const hero_arousal = 9;
    const top_arena = 10;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'guildliveness' => self::guildliveness,
            'excavate_rob' => self::excavate_rob,
            'excavate_gold' => self::excavate_gold,
            'excavate_exp' => self::excavate_exp,
            'top_gs' => self::top_gs,
            'full_hero_gs' => self::full_hero_gs,
            'hero_team_gs' => self::hero_team_gs,
            'hero_evo_star' => self::hero_evo_star,
            'hero_arousal' => self::hero_arousal,
            'top_arena' => self::top_arena,
        );
    }
}

/**
 * query_ranklist_reply message
 */
class Down_QueryRanklistReply extends \ProtobufMessage
{
    /* Field index constants */
    const _RANK_TYPE = 1;
    const _RANKLIST_ITEM = 2;
    const _SELF_RANKING = 3;
    const _SELF_ITEM = 4;
    const _SELF_PREV_POS = 5;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RANK_TYPE => array(
            'name' => '_rank_type',
            'required' => true,
            'type' => 5,
        ),
        self::_RANKLIST_ITEM => array(
            'name' => '_ranklist_item',
            'repeated' => true,
            'type' => 'Down_RanklistItem'
        ),
        self::_SELF_RANKING => array(
            'name' => '_self_ranking',
            'required' => false,
            'type' => 5,
        ),
        self::_SELF_ITEM => array(
            'name' => '_self_item',
            'required' => false,
            'type' => 'Down_RanklistItem'
        ),
        self::_SELF_PREV_POS => array(
            'name' => '_self_prev_pos',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_RANK_TYPE] = null;
        $this->values[self::_RANKLIST_ITEM] = array();
        $this->values[self::_SELF_RANKING] = null;
        $this->values[self::_SELF_ITEM] = null;
        $this->values[self::_SELF_PREV_POS] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_rank_type' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRankType($value)
    {
        return $this->set(self::_RANK_TYPE, $value);
    }

    /**
     * Returns value of '_rank_type' property
     *
     * @return int
     */
    public function getRankType()
    {
        return $this->get(self::_RANK_TYPE);
    }

    /**
     * Appends value to '_ranklist_item' list
     *
     * @param Down_RanklistItem $value Value to append
     *
     * @return null
     */
    public function appendRanklistItem(Down_RanklistItem $value)
    {
        return $this->append(self::_RANKLIST_ITEM, $value);
    }

    /**
     * Clears '_ranklist_item' list
     *
     * @return null
     */
    public function clearRanklistItem()
    {
        return $this->clear(self::_RANKLIST_ITEM);
    }

    /**
     * Returns '_ranklist_item' list
     *
     * @return Down_RanklistItem[]
     */
    public function getRanklistItem()
    {
        return $this->get(self::_RANKLIST_ITEM);
    }

    /**
     * Returns '_ranklist_item' iterator
     *
     * @return ArrayIterator
     */
    public function getRanklistItemIterator()
    {
        return new \ArrayIterator($this->get(self::_RANKLIST_ITEM));
    }

    /**
     * Returns element from '_ranklist_item' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_RanklistItem
     */
    public function getRanklistItemAt($offset)
    {
        return $this->get(self::_RANKLIST_ITEM, $offset);
    }

    /**
     * Returns count of '_ranklist_item' list
     *
     * @return int
     */
    public function getRanklistItemCount()
    {
        return $this->count(self::_RANKLIST_ITEM);
    }

    /**
     * Sets value of '_self_ranking' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSelfRanking($value)
    {
        return $this->set(self::_SELF_RANKING, $value);
    }

    /**
     * Returns value of '_self_ranking' property
     *
     * @return int
     */
    public function getSelfRanking()
    {
        return $this->get(self::_SELF_RANKING);
    }

    /**
     * Sets value of '_self_item' property
     *
     * @param Down_RanklistItem $value Property value
     *
     * @return null
     */
    public function setSelfItem(Down_RanklistItem $value)
    {
        return $this->set(self::_SELF_ITEM, $value);
    }

    /**
     * Returns value of '_self_item' property
     *
     * @return Down_RanklistItem
     */
    public function getSelfItem()
    {
        return $this->get(self::_SELF_ITEM);
    }

    /**
     * Sets value of '_self_prev_pos' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSelfPrevPos($value)
    {
        return $this->set(self::_SELF_PREV_POS, $value);
    }

    /**
     * Returns value of '_self_prev_pos' property
     *
     * @return int
     */
    public function getSelfPrevPos()
    {
        return $this->get(self::_SELF_PREV_POS);
    }
}

/**
 * request_guild_log_reply message
 */
class Down_RequestGuildLogReply extends \ProtobufMessage
{
    /* Field index constants */
    const _GUILD_LOG = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_GUILD_LOG => array(
            'name' => '_guild_log',
            'repeated' => true,
            'type' => 'Down_GuildLog'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_GUILD_LOG] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_guild_log' list
     *
     * @param Down_GuildLog $value Value to append
     *
     * @return null
     */
    public function appendGuildLog(Down_GuildLog $value)
    {
        return $this->append(self::_GUILD_LOG, $value);
    }

    /**
     * Clears '_guild_log' list
     *
     * @return null
     */
    public function clearGuildLog()
    {
        return $this->clear(self::_GUILD_LOG);
    }

    /**
     * Returns '_guild_log' list
     *
     * @return Down_GuildLog[]
     */
    public function getGuildLog()
    {
        return $this->get(self::_GUILD_LOG);
    }

    /**
     * Returns '_guild_log' iterator
     *
     * @return ArrayIterator
     */
    public function getGuildLogIterator()
    {
        return new \ArrayIterator($this->get(self::_GUILD_LOG));
    }

    /**
     * Returns element from '_guild_log' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_GuildLog
     */
    public function getGuildLogAt($offset)
    {
        return $this->get(self::_GUILD_LOG, $offset);
    }

    /**
     * Returns count of '_guild_log' list
     *
     * @return int
     */
    public function getGuildLogCount()
    {
        return $this->count(self::_GUILD_LOG);
    }
}

/**
 * guild_log message
 */
class Down_GuildLog extends \ProtobufMessage
{
    /* Field index constants */
    const _ID = 1;
    const _GUILD_LOG_CONTENT = 2;
    const _DATE = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ID => array(
            'name' => '_id',
            'required' => true,
            'type' => 5,
        ),
        self::_GUILD_LOG_CONTENT => array(
            'name' => '_guild_log_content',
            'repeated' => true,
            'type' => 'Down_GuildLogContent'
        ),
        self::_DATE => array(
            'name' => '_date',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ID] = null;
        $this->values[self::_GUILD_LOG_CONTENT] = array();
        $this->values[self::_DATE] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setId($value)
    {
        return $this->set(self::_ID, $value);
    }

    /**
     * Returns value of '_id' property
     *
     * @return int
     */
    public function getId()
    {
        return $this->get(self::_ID);
    }

    /**
     * Appends value to '_guild_log_content' list
     *
     * @param Down_GuildLogContent $value Value to append
     *
     * @return null
     */
    public function appendGuildLogContent(Down_GuildLogContent $value)
    {
        return $this->append(self::_GUILD_LOG_CONTENT, $value);
    }

    /**
     * Clears '_guild_log_content' list
     *
     * @return null
     */
    public function clearGuildLogContent()
    {
        return $this->clear(self::_GUILD_LOG_CONTENT);
    }

    /**
     * Returns '_guild_log_content' list
     *
     * @return Down_GuildLogContent[]
     */
    public function getGuildLogContent()
    {
        return $this->get(self::_GUILD_LOG_CONTENT);
    }

    /**
     * Returns '_guild_log_content' iterator
     *
     * @return ArrayIterator
     */
    public function getGuildLogContentIterator()
    {
        return new \ArrayIterator($this->get(self::_GUILD_LOG_CONTENT));
    }

    /**
     * Returns element from '_guild_log_content' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_GuildLogContent
     */
    public function getGuildLogContentAt($offset)
    {
        return $this->get(self::_GUILD_LOG_CONTENT, $offset);
    }

    /**
     * Returns count of '_guild_log_content' list
     *
     * @return int
     */
    public function getGuildLogContentCount()
    {
        return $this->count(self::_GUILD_LOG_CONTENT);
    }

    /**
     * Sets value of '_date' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setDate($value)
    {
        return $this->set(self::_DATE, $value);
    }

    /**
     * Returns value of '_date' property
     *
     * @return int
     */
    public function getDate()
    {
        return $this->get(self::_DATE);
    }
}

/**
 * guild_log_content message
 */
class Down_GuildLogContent extends \ProtobufMessage
{
    /* Field index constants */
    const _TIME = 1;
    const _CONTENT = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TIME => array(
            'name' => '_time',
            'required' => true,
            'type' => 5,
        ),
        self::_CONTENT => array(
            'name' => '_content',
            'required' => true,
            'type' => 7,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_TIME] = null;
        $this->values[self::_CONTENT] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setTime($value)
    {
        return $this->set(self::_TIME, $value);
    }

    /**
     * Returns value of '_time' property
     *
     * @return int
     */
    public function getTime()
    {
        return $this->get(self::_TIME);
    }

    /**
     * Sets value of '_content' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setContent($value)
    {
        return $this->set(self::_CONTENT, $value);
    }

    /**
     * Returns value of '_content' property
     *
     * @return string
     */
    public function getContent()
    {
        return $this->get(self::_CONTENT);
    }
}

/**
 * client_update_version message
 */
class Down_ClientUpdateVersion extends \ProtobufMessage
{
    /* Field index constants */
    const _VERSION = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_VERSION => array(
            'name' => '_version',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_VERSION] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_version' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setVersion($value)
    {
        return $this->set(self::_VERSION, $value);
    }

    /**
     * Returns value of '_version' property
     *
     * @return int
     */
    public function getVersion()
    {
        return $this->get(self::_VERSION);
    }
}

/**
 * query_act_stage_reply message
 */
class Down_QueryActStageReply extends \ProtobufMessage
{
    /* Field index constants */
    const _OPENED_ACT_STAGE = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_OPENED_ACT_STAGE => array(
            'name' => '_opened_act_stage',
            'repeated' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_OPENED_ACT_STAGE] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Appends value to '_opened_act_stage' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendOpenedActStage($value)
    {
        return $this->append(self::_OPENED_ACT_STAGE, $value);
    }

    /**
     * Clears '_opened_act_stage' list
     *
     * @return null
     */
    public function clearOpenedActStage()
    {
        return $this->clear(self::_OPENED_ACT_STAGE);
    }

    /**
     * Returns '_opened_act_stage' list
     *
     * @return int[]
     */
    public function getOpenedActStage()
    {
        return $this->get(self::_OPENED_ACT_STAGE);
    }

    /**
     * Returns '_opened_act_stage' iterator
     *
     * @return ArrayIterator
     */
    public function getOpenedActStageIterator()
    {
        return new \ArrayIterator($this->get(self::_OPENED_ACT_STAGE));
    }

    /**
     * Returns element from '_opened_act_stage' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getOpenedActStageAt($offset)
    {
        return $this->get(self::_OPENED_ACT_STAGE, $offset);
    }

    /**
     * Returns count of '_opened_act_stage' list
     *
     * @return int
     */
    public function getOpenedActStageCount()
    {
        return $this->count(self::_OPENED_ACT_STAGE);
    }
}

/**
 * fb_attention_reply message
 */
class Down_FbAttentionReply extends \ProtobufMessage
{
    /* Field index constants */
    const _ATTENTION = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ATTENTION => array(
            'name' => '_attention',
            'required' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_ATTENTION] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_attention' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setAttention($value)
    {
        return $this->set(self::_ATTENTION, $value);
    }

    /**
     * Returns value of '_attention' property
     *
     * @return int
     */
    public function getAttention()
    {
        return $this->get(self::_ATTENTION);
    }
}

/**
 * continue_pay_reply message
 */
class Down_ContinuePayReply extends \ProtobufMessage
{
    /* Field index constants */
    const _TIME = 1;
    const _STATUS = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TIME => array(
            'name' => '_time',
            'required' => true,
            'type' => 5,
        ),
        self::_STATUS => array(
            'name' => '_status',
            'repeated' => true,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_TIME] = null;
        $this->values[self::_STATUS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setTime($value)
    {
        return $this->set(self::_TIME, $value);
    }

    /**
     * Returns value of '_time' property
     *
     * @return int
     */
    public function getTime()
    {
        return $this->get(self::_TIME);
    }

    /**
     * Appends value to '_status' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendStatus($value)
    {
        return $this->append(self::_STATUS, $value);
    }

    /**
     * Clears '_status' list
     *
     * @return null
     */
    public function clearStatus()
    {
        return $this->clear(self::_STATUS);
    }

    /**
     * Returns '_status' list
     *
     * @return int[]
     */
    public function getStatus()
    {
        return $this->get(self::_STATUS);
    }

    /**
     * Returns '_status' iterator
     *
     * @return ArrayIterator
     */
    public function getStatusIterator()
    {
        return new \ArrayIterator($this->get(self::_STATUS));
    }

    /**
     * Returns element from '_status' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getStatusAt($offset)
    {
        return $this->get(self::_STATUS, $offset);
    }

    /**
     * Returns count of '_status' list
     *
     * @return int
     */
    public function getStatusCount()
    {
        return $this->count(self::_STATUS);
    }
}

/**
 * recharge_rebate_reply message
 */
class Down_RechargeRebateReply extends \ProtobufMessage
{
    /* Field index constants */
    const _TIME = 1;
    const _STATUS = 2;
    const _RECHARGE_MONEY = 3;
    const _GET_DAY = 4;
    const _GET_STATUS = 5;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TIME => array(
            'name' => '_time',
            'required' => true,
            'type' => 5,
        ),
        self::_STATUS => array(
            'name' => '_status',
            'required' => true,
            'type' => 5,
        ),
        self::_RECHARGE_MONEY => array(
            'name' => '_recharge_money',
            'required' => true,
            'type' => 5,
        ),
        self::_GET_DAY => array(
            'name' => '_get_day',
            'required' => false,
            'type' => 5,
        ),
        self::_GET_STATUS => array(
            'name' => '_get_status',
            'required' => false,
            'type' => 5,
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_TIME] = null;
        $this->values[self::_STATUS] = null;
        $this->values[self::_RECHARGE_MONEY] = null;
        $this->values[self::_GET_DAY] = null;
        $this->values[self::_GET_STATUS] = null;
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_time' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setTime($value)
    {
        return $this->set(self::_TIME, $value);
    }

    /**
     * Returns value of '_time' property
     *
     * @return int
     */
    public function getTime()
    {
        return $this->get(self::_TIME);
    }

    /**
     * Sets value of '_status' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStatus($value)
    {
        return $this->set(self::_STATUS, $value);
    }

    /**
     * Returns value of '_status' property
     *
     * @return int
     */
    public function getStatus()
    {
        return $this->get(self::_STATUS);
    }

    /**
     * Sets value of '_recharge_money' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRechargeMoney($value)
    {
        return $this->set(self::_RECHARGE_MONEY, $value);
    }

    /**
     * Returns value of '_recharge_money' property
     *
     * @return int
     */
    public function getRechargeMoney()
    {
        return $this->get(self::_RECHARGE_MONEY);
    }

    /**
     * Sets value of '_get_day' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setGetDay($value)
    {
        return $this->set(self::_GET_DAY, $value);
    }

    /**
     * Returns value of '_get_day' property
     *
     * @return int
     */
    public function getGetDay()
    {
        return $this->get(self::_GET_DAY);
    }

    /**
     * Sets value of '_get_status' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setGetStatus($value)
    {
        return $this->set(self::_GET_STATUS, $value);
    }

    /**
     * Returns value of '_get_status' property
     *
     * @return int
     */
    public function getGetStatus()
    {
        return $this->get(self::_GET_STATUS);
    }
}

/**
 * every_day_happy_reply message
 */
class Down_EveryDayHappyReply extends \ProtobufMessage
{
    /* Field index constants */
    const _STATUS = 5;
    const _GOLDCARD_NUMBER = 1;
    const _SILVERCARD_NUMBER = 2;
    const _COPPERCARD_NUMBER = 3;
    const _REWARDS = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_STATUS => array(
            'name' => '_status',
            'required' => true,
            'type' => 5,
        ),
        self::_GOLDCARD_NUMBER => array(
            'name' => '_goldcard_number',
            'required' => true,
            'type' => 5,
        ),
        self::_SILVERCARD_NUMBER => array(
            'name' => '_silvercard_number',
            'required' => true,
            'type' => 5,
        ),
        self::_COPPERCARD_NUMBER => array(
            'name' => '_coppercard_number',
            'required' => true,
            'type' => 5,
        ),
        self::_REWARDS => array(
            'name' => '_rewards',
            'repeated' => true,
            'type' => 'Down_ActivityReward'
        ),
    );

    /**
     * Constructs new message container and clears its internal state
     *
     * @return null
     */
    public function __construct()
    {
        $this->reset();
    }

    /**
     * Clears message values and sets default ones
     *
     * @return null
     */
    public function reset()
    {
        $this->values[self::_STATUS] = null;
        $this->values[self::_GOLDCARD_NUMBER] = null;
        $this->values[self::_SILVERCARD_NUMBER] = null;
        $this->values[self::_COPPERCARD_NUMBER] = null;
        $this->values[self::_REWARDS] = array();
    }

    /**
     * Returns field descriptors
     *
     * @return array
     */
    public function fields()
    {
        return self::$fields;
    }

    /**
     * Sets value of '_status' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStatus($value)
    {
        return $this->set(self::_STATUS, $value);
    }

    /**
     * Returns value of '_status' property
     *
     * @return int
     */
    public function getStatus()
    {
        return $this->get(self::_STATUS);
    }

    /**
     * Sets value of '_goldcard_number' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setGoldcardNumber($value)
    {
        return $this->set(self::_GOLDCARD_NUMBER, $value);
    }

    /**
     * Returns value of '_goldcard_number' property
     *
     * @return int
     */
    public function getGoldcardNumber()
    {
        return $this->get(self::_GOLDCARD_NUMBER);
    }

    /**
     * Sets value of '_silvercard_number' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSilvercardNumber($value)
    {
        return $this->set(self::_SILVERCARD_NUMBER, $value);
    }

    /**
     * Returns value of '_silvercard_number' property
     *
     * @return int
     */
    public function getSilvercardNumber()
    {
        return $this->get(self::_SILVERCARD_NUMBER);
    }

    /**
     * Sets value of '_coppercard_number' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCoppercardNumber($value)
    {
        return $this->set(self::_COPPERCARD_NUMBER, $value);
    }

    /**
     * Returns value of '_coppercard_number' property
     *
     * @return int
     */
    public function getCoppercardNumber()
    {
        return $this->get(self::_COPPERCARD_NUMBER);
    }

    /**
     * Appends value to '_rewards' list
     *
     * @param Down_ActivityReward $value Value to append
     *
     * @return null
     */
    public function appendRewards(Down_ActivityReward $value)
    {
        return $this->append(self::_REWARDS, $value);
    }

    /**
     * Clears '_rewards' list
     *
     * @return null
     */
    public function clearRewards()
    {
        return $this->clear(self::_REWARDS);
    }

    /**
     * Returns '_rewards' list
     *
     * @return Down_ActivityReward[]
     */
    public function getRewards()
    {
        return $this->get(self::_REWARDS);
    }

    /**
     * Returns '_rewards' iterator
     *
     * @return ArrayIterator
     */
    public function getRewardsIterator()
    {
        return new \ArrayIterator($this->get(self::_REWARDS));
    }

    /**
     * Returns element from '_rewards' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Down_ActivityReward
     */
    public function getRewardsAt($offset)
    {
        return $this->get(self::_REWARDS, $offset);
    }

    /**
     * Returns count of '_rewards' list
     *
     * @return int
     */
    public function getRewardsCount()
    {
        return $this->count(self::_REWARDS);
    }
}
