<?php
/**
 * Auto generated from up.proto at 2014-09-10 01:47:43
 *
 * up package
 */

/**
 * hero_status enum
 */
final class Up_HeroStatus
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
 * guild_job_t enum
 */
final class Up_GuildJobT
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
 * hire_from enum
 */
final class Up_HireFrom
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
 * chat_channel enum
 */
final class Up_ChatChannel
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
 * server_opt_type enum
 */
final class Up_ServerOptType
{
    const get = 0;
    const change = 1;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'get' => self::get,
            'change' => self::change,
        );
    }
}

/**
 * platform_type enum
 */
final class Up_PlatformType
{
    const self = 0;
    const s91 = 1;
    const tbt = 2;
    const pp = 3;
    const lemon = 4;
    const itools = 5;
    const kuaiyong = 6;
    const tuyoo = 7;
    const lemonyueyu = 8;
    const ky_android = 101;
    const xm_android = 102;
    const lemon_android = 103;
    const s360_android = 104;
    const uc_android = 105;
    const duoku_android = 106;
    const s91_android = 107;
    const wandoujia_android = 108;
    const pps_android = 109;
    const dangle_android = 110;
    const oppo_android = 111;
    const anzhi_android = 112;
    const s37wan_android = 113;
    const huawei_android = 114;
    const lianxiang_android = 115;
    const pptv_android = 116;
    const vivo_android = 117;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'self' => self::self,
            's91' => self::s91,
            'tbt' => self::tbt,
            'pp' => self::pp,
            'lemon' => self::lemon,
            'itools' => self::itools,
            'kuaiyong' => self::kuaiyong,
            'tuyoo' => self::tuyoo,
            'lemonyueyu' => self::lemonyueyu,
            'ky_android' => self::ky_android,
            'xm_android' => self::xm_android,
            'lemon_android' => self::lemon_android,
            's360_android' => self::s360_android,
            'uc_android' => self::uc_android,
            'duoku_android' => self::duoku_android,
            's91_android' => self::s91_android,
            'wandoujia_android' => self::wandoujia_android,
            'pps_android' => self::pps_android,
            'dangle_android' => self::dangle_android,
            'oppo_android' => self::oppo_android,
            'anzhi_android' => self::anzhi_android,
            's37wan_android' => self::s37wan_android,
            'huawei_android' => self::huawei_android,
            'lianxiang_android' => self::lianxiang_android,
            'pptv_android' => self::pptv_android,
            'vivo_android' => self::vivo_android,
        );
    }
}

/**
 * battle_result enum
 */
final class Up_BattleResult
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
 * up_msg message
 */
class Up_UpMsg extends \ProtobufMessage
{
    /* Field index constants */
    const _REPEAT = 1;
    const _USER_ID = 2;
    const _LOGIN = 3;
    const _REQUEST_USERINFO = 4;
    const _ENTER_STAGE = 5;
    const _EXIT_STAGE = 6;
    const _GM_CMD = 7;
    const _HERO_UPGRADE = 8;
    const _EQUIP_SYNTHESIS = 9;
    const _WEAR_EQUIP = 10;
    const _CONSUME_ITEM = 11;
    const _SHOP_REFRESH = 12;
    const _SHOP_CONSUME = 13;
    const _SKILL_LEVELUP = 14;
    const _SELL_ITEM = 15;
    const _FRAGMENT_COMPOSE = 16;
    const _HERO_EQUIP_UPGRADE = 17;
    const _TRIGGER_TASK = 18;
    const _REQUIRE_REWARDS = 19;
    const _TRIGGER_JOB = 20;
    const _JOB_REWARDS = 21;
    const _RESET_ELITE = 22;
    const _SWEEP_STAGE = 23;
    const _BUY_VITALITY = 24;
    const _BUY_SKILL_STREN_POINT = 25;
    const _TAVERN_DRAW = 26;
    const _QUERY_DATA = 27;
    const _HERO_EVOLVE = 28;
    const _ENTER_ACT_STAGE = 29;
    const _SYNC_VITALITY = 30;
    const _SUSPEND_REPORT = 31;
    const _TUTORIAL = 32;
    const _LADDER = 33;
    const _SET_NAME = 34;
    const _MIDAS = 35;
    const _OPEN_SHOP = 36;
    const _CHARGE = 37;
    const _SDK_LOGIN = 38;
    const _SET_AVATAR = 39;
    const _ASK_DAILY_LOGIN = 40;
    const _TBC = 41;
    const _GET_MAILLIST = 42;
    const _READ_MAIL = 43;
    const _GET_SVR_TIME = 44;
    const _GET_VIP_GIFT = 45;
    const _IMPORTANT_DATA_MD5 = 46;
    const _CHAT = 47;
    const _CDKEY_GIFT = 48;
    const _GUILD = 49;
    const _ASK_MAGICSOUL = 50;
    const _ASK_ACTIVITY_INFO = 51;
    const _EXCAVATE = 52;
    const _PUSH_NOTIFY = 53;
    const _SYSTEM_SETTING = 54;
    const _QUERY_SPLIT_DATA = 55;
    const _QUERY_SPLIT_RETURN = 56;
    const _SPLIT_HERO = 57;
    const _WORLDCUP = 58;
    const _REPORT_BATTLE = 59;
    const _QUERY_REPLAY = 60;
    const _SYNC_SKILL_STREN = 61;
    const _QUERY_RANKLIST = 62;
    const _CHANGE_SERVER = 63;
    const _REQUIRE_AROUSAL = 64;
    const _CHANGE_TASK_STATUS = 65;
    const _REQUEST_GUILD_LOG = 66;
    const _QUERY_ACT_STAGE = 67;
    const _REQUEST_UPGRADE_AROUSAL_LEVEL = 68;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_REPEAT => array(
            'name' => '_repeat',
            'required' => true,
            'type' => 5,
        ),
        self::_USER_ID => array(
            'name' => '_user_id',
            'required' => false,
            'type' => 5,
        ),
        self::_LOGIN => array(
            'name' => '_login',
            'required' => false,
            'type' => 'Up_Login'
        ),
        self::_REQUEST_USERINFO => array(
            'name' => '_request_userinfo',
            'required' => false,
            'type' => 'Up_RequestUserinfo'
        ),
        self::_ENTER_STAGE => array(
            'name' => '_enter_stage',
            'required' => false,
            'type' => 'Up_EnterStage'
        ),
        self::_EXIT_STAGE => array(
            'name' => '_exit_stage',
            'required' => false,
            'type' => 'Up_ExitStage'
        ),
        self::_GM_CMD => array(
            'name' => '_gm_cmd',
            'required' => false,
            'type' => 'Up_GmCmd'
        ),
        self::_HERO_UPGRADE => array(
            'name' => '_hero_upgrade',
            'required' => false,
            'type' => 'Up_HeroUpgrade'
        ),
        self::_EQUIP_SYNTHESIS => array(
            'name' => '_equip_synthesis',
            'required' => false,
            'type' => 'Up_EquipSynthesis'
        ),
        self::_WEAR_EQUIP => array(
            'name' => '_wear_equip',
            'required' => false,
            'type' => 'Up_WearEquip'
        ),
        self::_CONSUME_ITEM => array(
            'name' => '_consume_item',
            'required' => false,
            'type' => 'Up_ConsumeItem'
        ),
        self::_SHOP_REFRESH => array(
            'name' => '_shop_refresh',
            'required' => false,
            'type' => 'Up_ShopRefresh'
        ),
        self::_SHOP_CONSUME => array(
            'name' => '_shop_consume',
            'required' => false,
            'type' => 'Up_ShopConsume'
        ),
        self::_SKILL_LEVELUP => array(
            'name' => '_skill_levelup',
            'required' => false,
            'type' => 'Up_SkillLevelup'
        ),
        self::_SELL_ITEM => array(
            'name' => '_sell_item',
            'required' => false,
            'type' => 'Up_SellItem'
        ),
        self::_FRAGMENT_COMPOSE => array(
            'name' => '_fragment_compose',
            'required' => false,
            'type' => 'Up_FragmentCompose'
        ),
        self::_HERO_EQUIP_UPGRADE => array(
            'name' => '_hero_equip_upgrade',
            'required' => false,
            'type' => 'Up_HeroEquipUpgrade'
        ),
        self::_TRIGGER_TASK => array(
            'name' => '_trigger_task',
            'required' => false,
            'type' => 'Up_TriggerTask'
        ),
        self::_REQUIRE_REWARDS => array(
            'name' => '_require_rewards',
            'required' => false,
            'type' => 'Up_RequireRewards'
        ),
        self::_TRIGGER_JOB => array(
            'name' => '_trigger_job',
            'required' => false,
            'type' => 'Up_TriggerJob'
        ),
        self::_JOB_REWARDS => array(
            'name' => '_job_rewards',
            'required' => false,
            'type' => 'Up_JobRewards'
        ),
        self::_RESET_ELITE => array(
            'name' => '_reset_elite',
            'required' => false,
            'type' => 'Up_ResetElite'
        ),
        self::_SWEEP_STAGE => array(
            'name' => '_sweep_stage',
            'required' => false,
            'type' => 'Up_SweepStage'
        ),
        self::_BUY_VITALITY => array(
            'name' => '_buy_vitality',
            'required' => false,
            'type' => 'Up_BuyVitality'
        ),
        self::_BUY_SKILL_STREN_POINT => array(
            'name' => '_buy_skill_stren_point',
            'required' => false,
            'type' => 'Up_BuySkillStrenPoint'
        ),
        self::_TAVERN_DRAW => array(
            'name' => '_tavern_draw',
            'required' => false,
            'type' => 'Up_TavernDraw'
        ),
        self::_QUERY_DATA => array(
            'name' => '_query_data',
            'required' => false,
            'type' => 'Up_QueryData'
        ),
        self::_HERO_EVOLVE => array(
            'name' => '_hero_evolve',
            'required' => false,
            'type' => 'Up_HeroEvolve'
        ),
        self::_ENTER_ACT_STAGE => array(
            'name' => '_enter_act_stage',
            'required' => false,
            'type' => 'Up_EnterActStage'
        ),
        self::_SYNC_VITALITY => array(
            'name' => '_sync_vitality',
            'required' => false,
            'type' => 'Up_SyncVitality'
        ),
        self::_SUSPEND_REPORT => array(
            'name' => '_suspend_report',
            'required' => false,
            'type' => 'Up_SuspendReport'
        ),
        self::_TUTORIAL => array(
            'name' => '_tutorial',
            'required' => false,
            'type' => 'Up_Tutorial'
        ),
        self::_LADDER => array(
            'name' => '_ladder',
            'required' => false,
            'type' => 'Up_Ladder'
        ),
        self::_SET_NAME => array(
            'name' => '_set_name',
            'required' => false,
            'type' => 'Up_SetName'
        ),
        self::_MIDAS => array(
            'name' => '_midas',
            'required' => false,
            'type' => 'Up_Midas'
        ),
        self::_OPEN_SHOP => array(
            'name' => '_open_shop',
            'required' => false,
            'type' => 'Up_OpenShop'
        ),
        self::_CHARGE => array(
            'name' => '_charge',
            'required' => false,
            'type' => 'Up_Charge'
        ),
        self::_SDK_LOGIN => array(
            'name' => '_sdk_login',
            'required' => false,
            'type' => 'Up_SdkLogin'
        ),
        self::_SET_AVATAR => array(
            'name' => '_set_avatar',
            'required' => false,
            'type' => 'Up_SetAvatar'
        ),
        self::_ASK_DAILY_LOGIN => array(
            'name' => '_ask_daily_login',
            'required' => false,
            'type' => 'Up_AskDailyLogin'
        ),
        self::_TBC => array(
            'name' => '_tbc',
            'required' => false,
            'type' => 'Up_Tbc'
        ),
        self::_GET_MAILLIST => array(
            'name' => '_get_maillist',
            'required' => false,
            'type' => 'Up_GetMaillist'
        ),
        self::_READ_MAIL => array(
            'name' => '_read_mail',
            'required' => false,
            'type' => 'Up_ReadMail'
        ),
        self::_GET_SVR_TIME => array(
            'name' => '_get_svr_time',
            'required' => false,
            'type' => 'Up_GetSvrTime'
        ),
        self::_GET_VIP_GIFT => array(
            'name' => '_get_vip_gift',
            'required' => false,
            'type' => 'Up_GetVipGift'
        ),
        self::_IMPORTANT_DATA_MD5 => array(
            'name' => '_important_data_md5',
            'required' => false,
            'type' => 7,
        ),
        self::_CHAT => array(
            'name' => '_chat',
            'required' => false,
            'type' => 'Up_Chat'
        ),
        self::_CDKEY_GIFT => array(
            'name' => '_cdkey_gift',
            'required' => false,
            'type' => 'Up_CdkeyGift'
        ),
        self::_GUILD => array(
            'name' => '_guild',
            'required' => false,
            'type' => 'Up_Guild'
        ),
        self::_ASK_MAGICSOUL => array(
            'name' => '_ask_magicsoul',
            'required' => false,
            'type' => 'Up_AskMagicsoul'
        ),
        self::_ASK_ACTIVITY_INFO => array(
            'name' => '_ask_activity_info',
            'required' => false,
            'type' => 'Up_AskActivityInfo'
        ),
        self::_EXCAVATE => array(
            'name' => '_excavate',
            'required' => false,
            'type' => 'Up_Excavate'
        ),
        self::_PUSH_NOTIFY => array(
            'name' => '_push_notify',
            'required' => false,
            'type' => 'Up_PushNotify'
        ),
        self::_SYSTEM_SETTING => array(
            'name' => '_system_setting',
            'required' => false,
            'type' => 'Up_SystemSetting'
        ),
        self::_QUERY_SPLIT_DATA => array(
            'name' => '_query_split_data',
            'required' => false,
            'type' => 'Up_QuerySplitData'
        ),
        self::_QUERY_SPLIT_RETURN => array(
            'name' => '_query_split_return',
            'required' => false,
            'type' => 'Up_QuerySplitReturn'
        ),
        self::_SPLIT_HERO => array(
            'name' => '_split_hero',
            'required' => false,
            'type' => 'Up_SplitHero'
        ),
        self::_WORLDCUP => array(
            'name' => '_worldcup',
            'required' => false,
            'type' => 'Up_Worldcup'
        ),
        self::_REPORT_BATTLE => array(
            'name' => '_report_battle',
            'required' => false,
            'type' => 'Up_ReportBattle'
        ),
        self::_QUERY_REPLAY => array(
            'name' => '_query_replay',
            'required' => false,
            'type' => 'Up_QueryReplay'
        ),
        self::_SYNC_SKILL_STREN => array(
            'name' => '_sync_skill_stren',
            'required' => false,
            'type' => 'Up_SyncSkillStren'
        ),
        self::_QUERY_RANKLIST => array(
            'name' => '_query_ranklist',
            'required' => false,
            'type' => 'Up_QueryRanklist'
        ),
        self::_CHANGE_SERVER => array(
            'name' => '_change_server',
            'required' => false,
            'type' => 'Up_ChangeServer'
        ),
        self::_REQUIRE_AROUSAL => array(
            'name' => '_require_arousal',
            'required' => false,
            'type' => 'Up_RequireArousal'
        ),
        self::_CHANGE_TASK_STATUS => array(
            'name' => '_change_task_status',
            'required' => false,
            'type' => 'Up_ChangeTaskStatus'
        ),
        self::_REQUEST_GUILD_LOG => array(
            'name' => '_request_guild_log',
            'required' => false,
            'type' => 'Up_RequestGuildLog'
        ),
        self::_QUERY_ACT_STAGE => array(
            'name' => '_query_act_stage',
            'required' => false,
            'type' => 'Up_QueryActStage'
        ),
        self::_REQUEST_UPGRADE_AROUSAL_LEVEL => array(
            'name' => '_request_upgrade_arousal_level',
            'required' => false,
            'type' => 'Up_RequestUpgradeArousalLevel'
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
        $this->values[self::_REPEAT] = null;
        $this->values[self::_USER_ID] = null;
        $this->values[self::_LOGIN] = null;
        $this->values[self::_REQUEST_USERINFO] = null;
        $this->values[self::_ENTER_STAGE] = null;
        $this->values[self::_EXIT_STAGE] = null;
        $this->values[self::_GM_CMD] = null;
        $this->values[self::_HERO_UPGRADE] = null;
        $this->values[self::_EQUIP_SYNTHESIS] = null;
        $this->values[self::_WEAR_EQUIP] = null;
        $this->values[self::_CONSUME_ITEM] = null;
        $this->values[self::_SHOP_REFRESH] = null;
        $this->values[self::_SHOP_CONSUME] = null;
        $this->values[self::_SKILL_LEVELUP] = null;
        $this->values[self::_SELL_ITEM] = null;
        $this->values[self::_FRAGMENT_COMPOSE] = null;
        $this->values[self::_HERO_EQUIP_UPGRADE] = null;
        $this->values[self::_TRIGGER_TASK] = null;
        $this->values[self::_REQUIRE_REWARDS] = null;
        $this->values[self::_TRIGGER_JOB] = null;
        $this->values[self::_JOB_REWARDS] = null;
        $this->values[self::_RESET_ELITE] = null;
        $this->values[self::_SWEEP_STAGE] = null;
        $this->values[self::_BUY_VITALITY] = null;
        $this->values[self::_BUY_SKILL_STREN_POINT] = null;
        $this->values[self::_TAVERN_DRAW] = null;
        $this->values[self::_QUERY_DATA] = null;
        $this->values[self::_HERO_EVOLVE] = null;
        $this->values[self::_ENTER_ACT_STAGE] = null;
        $this->values[self::_SYNC_VITALITY] = null;
        $this->values[self::_SUSPEND_REPORT] = null;
        $this->values[self::_TUTORIAL] = null;
        $this->values[self::_LADDER] = null;
        $this->values[self::_SET_NAME] = null;
        $this->values[self::_MIDAS] = null;
        $this->values[self::_OPEN_SHOP] = null;
        $this->values[self::_CHARGE] = null;
        $this->values[self::_SDK_LOGIN] = null;
        $this->values[self::_SET_AVATAR] = null;
        $this->values[self::_ASK_DAILY_LOGIN] = null;
        $this->values[self::_TBC] = null;
        $this->values[self::_GET_MAILLIST] = null;
        $this->values[self::_READ_MAIL] = null;
        $this->values[self::_GET_SVR_TIME] = null;
        $this->values[self::_GET_VIP_GIFT] = null;
        $this->values[self::_IMPORTANT_DATA_MD5] = null;
        $this->values[self::_CHAT] = null;
        $this->values[self::_CDKEY_GIFT] = null;
        $this->values[self::_GUILD] = null;
        $this->values[self::_ASK_MAGICSOUL] = null;
        $this->values[self::_ASK_ACTIVITY_INFO] = null;
        $this->values[self::_EXCAVATE] = null;
        $this->values[self::_PUSH_NOTIFY] = null;
        $this->values[self::_SYSTEM_SETTING] = null;
        $this->values[self::_QUERY_SPLIT_DATA] = null;
        $this->values[self::_QUERY_SPLIT_RETURN] = null;
        $this->values[self::_SPLIT_HERO] = null;
        $this->values[self::_WORLDCUP] = null;
        $this->values[self::_REPORT_BATTLE] = null;
        $this->values[self::_QUERY_REPLAY] = null;
        $this->values[self::_SYNC_SKILL_STREN] = null;
        $this->values[self::_QUERY_RANKLIST] = null;
        $this->values[self::_CHANGE_SERVER] = null;
        $this->values[self::_REQUIRE_AROUSAL] = null;
        $this->values[self::_CHANGE_TASK_STATUS] = null;
        $this->values[self::_REQUEST_GUILD_LOG] = null;
        $this->values[self::_QUERY_ACT_STAGE] = null;
        $this->values[self::_REQUEST_UPGRADE_AROUSAL_LEVEL] = null;
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
     * Sets value of '_repeat' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRepeat($value)
    {
        return $this->set(self::_REPEAT, $value);
    }

    /**
     * Returns value of '_repeat' property
     *
     * @return int
     */
    public function getRepeat()
    {
        return $this->get(self::_REPEAT);
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
     * Sets value of '_login' property
     *
     * @param Up_Login $value Property value
     *
     * @return null
     */
    public function setLogin(Up_Login $value)
    {
        return $this->set(self::_LOGIN, $value);
    }

    /**
     * Returns value of '_login' property
     *
     * @return Up_Login
     */
    public function getLogin()
    {
        return $this->get(self::_LOGIN);
    }

    /**
     * Sets value of '_request_userinfo' property
     *
     * @param Up_RequestUserinfo $value Property value
     *
     * @return null
     */
    public function setRequestUserinfo(Up_RequestUserinfo $value)
    {
        return $this->set(self::_REQUEST_USERINFO, $value);
    }

    /**
     * Returns value of '_request_userinfo' property
     *
     * @return Up_RequestUserinfo
     */
    public function getRequestUserinfo()
    {
        return $this->get(self::_REQUEST_USERINFO);
    }

    /**
     * Sets value of '_enter_stage' property
     *
     * @param Up_EnterStage $value Property value
     *
     * @return null
     */
    public function setEnterStage(Up_EnterStage $value)
    {
        return $this->set(self::_ENTER_STAGE, $value);
    }

    /**
     * Returns value of '_enter_stage' property
     *
     * @return Up_EnterStage
     */
    public function getEnterStage()
    {
        return $this->get(self::_ENTER_STAGE);
    }

    /**
     * Sets value of '_exit_stage' property
     *
     * @param Up_ExitStage $value Property value
     *
     * @return null
     */
    public function setExitStage(Up_ExitStage $value)
    {
        return $this->set(self::_EXIT_STAGE, $value);
    }

    /**
     * Returns value of '_exit_stage' property
     *
     * @return Up_ExitStage
     */
    public function getExitStage()
    {
        return $this->get(self::_EXIT_STAGE);
    }

    /**
     * Sets value of '_gm_cmd' property
     *
     * @param Up_GmCmd $value Property value
     *
     * @return null
     */
    public function setGmCmd(Up_GmCmd $value)
    {
        return $this->set(self::_GM_CMD, $value);
    }

    /**
     * Returns value of '_gm_cmd' property
     *
     * @return Up_GmCmd
     */
    public function getGmCmd()
    {
        return $this->get(self::_GM_CMD);
    }

    /**
     * Sets value of '_hero_upgrade' property
     *
     * @param Up_HeroUpgrade $value Property value
     *
     * @return null
     */
    public function setHeroUpgrade(Up_HeroUpgrade $value)
    {
        return $this->set(self::_HERO_UPGRADE, $value);
    }

    /**
     * Returns value of '_hero_upgrade' property
     *
     * @return Up_HeroUpgrade
     */
    public function getHeroUpgrade()
    {
        return $this->get(self::_HERO_UPGRADE);
    }

    /**
     * Sets value of '_equip_synthesis' property
     *
     * @param Up_EquipSynthesis $value Property value
     *
     * @return null
     */
    public function setEquipSynthesis(Up_EquipSynthesis $value)
    {
        return $this->set(self::_EQUIP_SYNTHESIS, $value);
    }

    /**
     * Returns value of '_equip_synthesis' property
     *
     * @return Up_EquipSynthesis
     */
    public function getEquipSynthesis()
    {
        return $this->get(self::_EQUIP_SYNTHESIS);
    }

    /**
     * Sets value of '_wear_equip' property
     *
     * @param Up_WearEquip $value Property value
     *
     * @return null
     */
    public function setWearEquip(Up_WearEquip $value)
    {
        return $this->set(self::_WEAR_EQUIP, $value);
    }

    /**
     * Returns value of '_wear_equip' property
     *
     * @return Up_WearEquip
     */
    public function getWearEquip()
    {
        return $this->get(self::_WEAR_EQUIP);
    }

    /**
     * Sets value of '_consume_item' property
     *
     * @param Up_ConsumeItem $value Property value
     *
     * @return null
     */
    public function setConsumeItem(Up_ConsumeItem $value)
    {
        return $this->set(self::_CONSUME_ITEM, $value);
    }

    /**
     * Returns value of '_consume_item' property
     *
     * @return Up_ConsumeItem
     */
    public function getConsumeItem()
    {
        return $this->get(self::_CONSUME_ITEM);
    }

    /**
     * Sets value of '_shop_refresh' property
     *
     * @param Up_ShopRefresh $value Property value
     *
     * @return null
     */
    public function setShopRefresh(Up_ShopRefresh $value)
    {
        return $this->set(self::_SHOP_REFRESH, $value);
    }

    /**
     * Returns value of '_shop_refresh' property
     *
     * @return Up_ShopRefresh
     */
    public function getShopRefresh()
    {
        return $this->get(self::_SHOP_REFRESH);
    }

    /**
     * Sets value of '_shop_consume' property
     *
     * @param Up_ShopConsume $value Property value
     *
     * @return null
     */
    public function setShopConsume(Up_ShopConsume $value)
    {
        return $this->set(self::_SHOP_CONSUME, $value);
    }

    /**
     * Returns value of '_shop_consume' property
     *
     * @return Up_ShopConsume
     */
    public function getShopConsume()
    {
        return $this->get(self::_SHOP_CONSUME);
    }

    /**
     * Sets value of '_skill_levelup' property
     *
     * @param Up_SkillLevelup $value Property value
     *
     * @return null
     */
    public function setSkillLevelup(Up_SkillLevelup $value)
    {
        return $this->set(self::_SKILL_LEVELUP, $value);
    }

    /**
     * Returns value of '_skill_levelup' property
     *
     * @return Up_SkillLevelup
     */
    public function getSkillLevelup()
    {
        return $this->get(self::_SKILL_LEVELUP);
    }

    /**
     * Sets value of '_sell_item' property
     *
     * @param Up_SellItem $value Property value
     *
     * @return null
     */
    public function setSellItem(Up_SellItem $value)
    {
        return $this->set(self::_SELL_ITEM, $value);
    }

    /**
     * Returns value of '_sell_item' property
     *
     * @return Up_SellItem
     */
    public function getSellItem()
    {
        return $this->get(self::_SELL_ITEM);
    }

    /**
     * Sets value of '_fragment_compose' property
     *
     * @param Up_FragmentCompose $value Property value
     *
     * @return null
     */
    public function setFragmentCompose(Up_FragmentCompose $value)
    {
        return $this->set(self::_FRAGMENT_COMPOSE, $value);
    }

    /**
     * Returns value of '_fragment_compose' property
     *
     * @return Up_FragmentCompose
     */
    public function getFragmentCompose()
    {
        return $this->get(self::_FRAGMENT_COMPOSE);
    }

    /**
     * Sets value of '_hero_equip_upgrade' property
     *
     * @param Up_HeroEquipUpgrade $value Property value
     *
     * @return null
     */
    public function setHeroEquipUpgrade(Up_HeroEquipUpgrade $value)
    {
        return $this->set(self::_HERO_EQUIP_UPGRADE, $value);
    }

    /**
     * Returns value of '_hero_equip_upgrade' property
     *
     * @return Up_HeroEquipUpgrade
     */
    public function getHeroEquipUpgrade()
    {
        return $this->get(self::_HERO_EQUIP_UPGRADE);
    }

    /**
     * Sets value of '_trigger_task' property
     *
     * @param Up_TriggerTask $value Property value
     *
     * @return null
     */
    public function setTriggerTask(Up_TriggerTask $value)
    {
        return $this->set(self::_TRIGGER_TASK, $value);
    }

    /**
     * Returns value of '_trigger_task' property
     *
     * @return Up_TriggerTask
     */
    public function getTriggerTask()
    {
        return $this->get(self::_TRIGGER_TASK);
    }

    /**
     * Sets value of '_require_rewards' property
     *
     * @param Up_RequireRewards $value Property value
     *
     * @return null
     */
    public function setRequireRewards(Up_RequireRewards $value)
    {
        return $this->set(self::_REQUIRE_REWARDS, $value);
    }

    /**
     * Returns value of '_require_rewards' property
     *
     * @return Up_RequireRewards
     */
    public function getRequireRewards()
    {
        return $this->get(self::_REQUIRE_REWARDS);
    }

    /**
     * Sets value of '_trigger_job' property
     *
     * @param Up_TriggerJob $value Property value
     *
     * @return null
     */
    public function setTriggerJob(Up_TriggerJob $value)
    {
        return $this->set(self::_TRIGGER_JOB, $value);
    }

    /**
     * Returns value of '_trigger_job' property
     *
     * @return Up_TriggerJob
     */
    public function getTriggerJob()
    {
        return $this->get(self::_TRIGGER_JOB);
    }

    /**
     * Sets value of '_job_rewards' property
     *
     * @param Up_JobRewards $value Property value
     *
     * @return null
     */
    public function setJobRewards(Up_JobRewards $value)
    {
        return $this->set(self::_JOB_REWARDS, $value);
    }

    /**
     * Returns value of '_job_rewards' property
     *
     * @return Up_JobRewards
     */
    public function getJobRewards()
    {
        return $this->get(self::_JOB_REWARDS);
    }

    /**
     * Sets value of '_reset_elite' property
     *
     * @param Up_ResetElite $value Property value
     *
     * @return null
     */
    public function setResetElite(Up_ResetElite $value)
    {
        return $this->set(self::_RESET_ELITE, $value);
    }

    /**
     * Returns value of '_reset_elite' property
     *
     * @return Up_ResetElite
     */
    public function getResetElite()
    {
        return $this->get(self::_RESET_ELITE);
    }

    /**
     * Sets value of '_sweep_stage' property
     *
     * @param Up_SweepStage $value Property value
     *
     * @return null
     */
    public function setSweepStage(Up_SweepStage $value)
    {
        return $this->set(self::_SWEEP_STAGE, $value);
    }

    /**
     * Returns value of '_sweep_stage' property
     *
     * @return Up_SweepStage
     */
    public function getSweepStage()
    {
        return $this->get(self::_SWEEP_STAGE);
    }

    /**
     * Sets value of '_buy_vitality' property
     *
     * @param Up_BuyVitality $value Property value
     *
     * @return null
     */
    public function setBuyVitality(Up_BuyVitality $value)
    {
        return $this->set(self::_BUY_VITALITY, $value);
    }

    /**
     * Returns value of '_buy_vitality' property
     *
     * @return Up_BuyVitality
     */
    public function getBuyVitality()
    {
        return $this->get(self::_BUY_VITALITY);
    }

    /**
     * Sets value of '_buy_skill_stren_point' property
     *
     * @param Up_BuySkillStrenPoint $value Property value
     *
     * @return null
     */
    public function setBuySkillStrenPoint(Up_BuySkillStrenPoint $value)
    {
        return $this->set(self::_BUY_SKILL_STREN_POINT, $value);
    }

    /**
     * Returns value of '_buy_skill_stren_point' property
     *
     * @return Up_BuySkillStrenPoint
     */
    public function getBuySkillStrenPoint()
    {
        return $this->get(self::_BUY_SKILL_STREN_POINT);
    }

    /**
     * Sets value of '_tavern_draw' property
     *
     * @param Up_TavernDraw $value Property value
     *
     * @return null
     */
    public function setTavernDraw(Up_TavernDraw $value)
    {
        return $this->set(self::_TAVERN_DRAW, $value);
    }

    /**
     * Returns value of '_tavern_draw' property
     *
     * @return Up_TavernDraw
     */
    public function getTavernDraw()
    {
        return $this->get(self::_TAVERN_DRAW);
    }

    /**
     * Sets value of '_query_data' property
     *
     * @param Up_QueryData $value Property value
     *
     * @return null
     */
    public function setQueryData(Up_QueryData $value)
    {
        return $this->set(self::_QUERY_DATA, $value);
    }

    /**
     * Returns value of '_query_data' property
     *
     * @return Up_QueryData
     */
    public function getQueryData()
    {
        return $this->get(self::_QUERY_DATA);
    }

    /**
     * Sets value of '_hero_evolve' property
     *
     * @param Up_HeroEvolve $value Property value
     *
     * @return null
     */
    public function setHeroEvolve(Up_HeroEvolve $value)
    {
        return $this->set(self::_HERO_EVOLVE, $value);
    }

    /**
     * Returns value of '_hero_evolve' property
     *
     * @return Up_HeroEvolve
     */
    public function getHeroEvolve()
    {
        return $this->get(self::_HERO_EVOLVE);
    }

    /**
     * Sets value of '_enter_act_stage' property
     *
     * @param Up_EnterActStage $value Property value
     *
     * @return null
     */
    public function setEnterActStage(Up_EnterActStage $value)
    {
        return $this->set(self::_ENTER_ACT_STAGE, $value);
    }

    /**
     * Returns value of '_enter_act_stage' property
     *
     * @return Up_EnterActStage
     */
    public function getEnterActStage()
    {
        return $this->get(self::_ENTER_ACT_STAGE);
    }

    /**
     * Sets value of '_sync_vitality' property
     *
     * @param Up_SyncVitality $value Property value
     *
     * @return null
     */
    public function setSyncVitality(Up_SyncVitality $value)
    {
        return $this->set(self::_SYNC_VITALITY, $value);
    }

    /**
     * Returns value of '_sync_vitality' property
     *
     * @return Up_SyncVitality
     */
    public function getSyncVitality()
    {
        return $this->get(self::_SYNC_VITALITY);
    }

    /**
     * Sets value of '_suspend_report' property
     *
     * @param Up_SuspendReport $value Property value
     *
     * @return null
     */
    public function setSuspendReport(Up_SuspendReport $value)
    {
        return $this->set(self::_SUSPEND_REPORT, $value);
    }

    /**
     * Returns value of '_suspend_report' property
     *
     * @return Up_SuspendReport
     */
    public function getSuspendReport()
    {
        return $this->get(self::_SUSPEND_REPORT);
    }

    /**
     * Sets value of '_tutorial' property
     *
     * @param Up_Tutorial $value Property value
     *
     * @return null
     */
    public function setTutorial(Up_Tutorial $value)
    {
        return $this->set(self::_TUTORIAL, $value);
    }

    /**
     * Returns value of '_tutorial' property
     *
     * @return Up_Tutorial
     */
    public function getTutorial()
    {
        return $this->get(self::_TUTORIAL);
    }

    /**
     * Sets value of '_ladder' property
     *
     * @param Up_Ladder $value Property value
     *
     * @return null
     */
    public function setLadder(Up_Ladder $value)
    {
        return $this->set(self::_LADDER, $value);
    }

    /**
     * Returns value of '_ladder' property
     *
     * @return Up_Ladder
     */
    public function getLadder()
    {
        return $this->get(self::_LADDER);
    }

    /**
     * Sets value of '_set_name' property
     *
     * @param Up_SetName $value Property value
     *
     * @return null
     */
    public function setSetName(Up_SetName $value)
    {
        return $this->set(self::_SET_NAME, $value);
    }

    /**
     * Returns value of '_set_name' property
     *
     * @return Up_SetName
     */
    public function getSetName()
    {
        return $this->get(self::_SET_NAME);
    }

    /**
     * Sets value of '_midas' property
     *
     * @param Up_Midas $value Property value
     *
     * @return null
     */
    public function setMidas(Up_Midas $value)
    {
        return $this->set(self::_MIDAS, $value);
    }

    /**
     * Returns value of '_midas' property
     *
     * @return Up_Midas
     */
    public function getMidas()
    {
        return $this->get(self::_MIDAS);
    }

    /**
     * Sets value of '_open_shop' property
     *
     * @param Up_OpenShop $value Property value
     *
     * @return null
     */
    public function setOpenShop(Up_OpenShop $value)
    {
        return $this->set(self::_OPEN_SHOP, $value);
    }

    /**
     * Returns value of '_open_shop' property
     *
     * @return Up_OpenShop
     */
    public function getOpenShop()
    {
        return $this->get(self::_OPEN_SHOP);
    }

    /**
     * Sets value of '_charge' property
     *
     * @param Up_Charge $value Property value
     *
     * @return null
     */
    public function setCharge(Up_Charge $value)
    {
        return $this->set(self::_CHARGE, $value);
    }

    /**
     * Returns value of '_charge' property
     *
     * @return Up_Charge
     */
    public function getCharge()
    {
        return $this->get(self::_CHARGE);
    }

    /**
     * Sets value of '_sdk_login' property
     *
     * @param Up_SdkLogin $value Property value
     *
     * @return null
     */
    public function setSdkLogin(Up_SdkLogin $value)
    {
        return $this->set(self::_SDK_LOGIN, $value);
    }

    /**
     * Returns value of '_sdk_login' property
     *
     * @return Up_SdkLogin
     */
    public function getSdkLogin()
    {
        return $this->get(self::_SDK_LOGIN);
    }

    /**
     * Sets value of '_set_avatar' property
     *
     * @param Up_SetAvatar $value Property value
     *
     * @return null
     */
    public function setSetAvatar(Up_SetAvatar $value)
    {
        return $this->set(self::_SET_AVATAR, $value);
    }

    /**
     * Returns value of '_set_avatar' property
     *
     * @return Up_SetAvatar
     */
    public function getSetAvatar()
    {
        return $this->get(self::_SET_AVATAR);
    }

    /**
     * Sets value of '_ask_daily_login' property
     *
     * @param Up_AskDailyLogin $value Property value
     *
     * @return null
     */
    public function setAskDailyLogin(Up_AskDailyLogin $value)
    {
        return $this->set(self::_ASK_DAILY_LOGIN, $value);
    }

    /**
     * Returns value of '_ask_daily_login' property
     *
     * @return Up_AskDailyLogin
     */
    public function getAskDailyLogin()
    {
        return $this->get(self::_ASK_DAILY_LOGIN);
    }

    /**
     * Sets value of '_tbc' property
     *
     * @param Up_Tbc $value Property value
     *
     * @return null
     */
    public function setTbc(Up_Tbc $value)
    {
        return $this->set(self::_TBC, $value);
    }

    /**
     * Returns value of '_tbc' property
     *
     * @return Up_Tbc
     */
    public function getTbc()
    {
        return $this->get(self::_TBC);
    }

    /**
     * Sets value of '_get_maillist' property
     *
     * @param Up_GetMaillist $value Property value
     *
     * @return null
     */
    public function setGetMaillist(Up_GetMaillist $value)
    {
        return $this->set(self::_GET_MAILLIST, $value);
    }

    /**
     * Returns value of '_get_maillist' property
     *
     * @return Up_GetMaillist
     */
    public function getGetMaillist()
    {
        return $this->get(self::_GET_MAILLIST);
    }

    /**
     * Sets value of '_read_mail' property
     *
     * @param Up_ReadMail $value Property value
     *
     * @return null
     */
    public function setReadMail(Up_ReadMail $value)
    {
        return $this->set(self::_READ_MAIL, $value);
    }

    /**
     * Returns value of '_read_mail' property
     *
     * @return Up_ReadMail
     */
    public function getReadMail()
    {
        return $this->get(self::_READ_MAIL);
    }

    /**
     * Sets value of '_get_svr_time' property
     *
     * @param Up_GetSvrTime $value Property value
     *
     * @return null
     */
    public function setGetSvrTime(Up_GetSvrTime $value)
    {
        return $this->set(self::_GET_SVR_TIME, $value);
    }

    /**
     * Returns value of '_get_svr_time' property
     *
     * @return Up_GetSvrTime
     */
    public function getGetSvrTime()
    {
        return $this->get(self::_GET_SVR_TIME);
    }

    /**
     * Sets value of '_get_vip_gift' property
     *
     * @param Up_GetVipGift $value Property value
     *
     * @return null
     */
    public function setGetVipGift(Up_GetVipGift $value)
    {
        return $this->set(self::_GET_VIP_GIFT, $value);
    }

    /**
     * Returns value of '_get_vip_gift' property
     *
     * @return Up_GetVipGift
     */
    public function getGetVipGift()
    {
        return $this->get(self::_GET_VIP_GIFT);
    }

    /**
     * Sets value of '_important_data_md5' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setImportantDataMd5($value)
    {
        return $this->set(self::_IMPORTANT_DATA_MD5, $value);
    }

    /**
     * Returns value of '_important_data_md5' property
     *
     * @return string
     */
    public function getImportantDataMd5()
    {
        return $this->get(self::_IMPORTANT_DATA_MD5);
    }

    /**
     * Sets value of '_chat' property
     *
     * @param Up_Chat $value Property value
     *
     * @return null
     */
    public function setChat(Up_Chat $value)
    {
        return $this->set(self::_CHAT, $value);
    }

    /**
     * Returns value of '_chat' property
     *
     * @return Up_Chat
     */
    public function getChat()
    {
        return $this->get(self::_CHAT);
    }

    /**
     * Sets value of '_cdkey_gift' property
     *
     * @param Up_CdkeyGift $value Property value
     *
     * @return null
     */
    public function setCdkeyGift(Up_CdkeyGift $value)
    {
        return $this->set(self::_CDKEY_GIFT, $value);
    }

    /**
     * Returns value of '_cdkey_gift' property
     *
     * @return Up_CdkeyGift
     */
    public function getCdkeyGift()
    {
        return $this->get(self::_CDKEY_GIFT);
    }

    /**
     * Sets value of '_guild' property
     *
     * @param Up_Guild $value Property value
     *
     * @return null
     */
    public function setGuild(Up_Guild $value)
    {
        return $this->set(self::_GUILD, $value);
    }

    /**
     * Returns value of '_guild' property
     *
     * @return Up_Guild
     */
    public function getGuild()
    {
        return $this->get(self::_GUILD);
    }

    /**
     * Sets value of '_ask_magicsoul' property
     *
     * @param Up_AskMagicsoul $value Property value
     *
     * @return null
     */
    public function setAskMagicsoul(Up_AskMagicsoul $value)
    {
        return $this->set(self::_ASK_MAGICSOUL, $value);
    }

    /**
     * Returns value of '_ask_magicsoul' property
     *
     * @return Up_AskMagicsoul
     */
    public function getAskMagicsoul()
    {
        return $this->get(self::_ASK_MAGICSOUL);
    }

    /**
     * Sets value of '_ask_activity_info' property
     *
     * @param Up_AskActivityInfo $value Property value
     *
     * @return null
     */
    public function setAskActivityInfo(Up_AskActivityInfo $value)
    {
        return $this->set(self::_ASK_ACTIVITY_INFO, $value);
    }

    /**
     * Returns value of '_ask_activity_info' property
     *
     * @return Up_AskActivityInfo
     */
    public function getAskActivityInfo()
    {
        return $this->get(self::_ASK_ACTIVITY_INFO);
    }

    /**
     * Sets value of '_excavate' property
     *
     * @param Up_Excavate $value Property value
     *
     * @return null
     */
    public function setExcavate(Up_Excavate $value)
    {
        return $this->set(self::_EXCAVATE, $value);
    }

    /**
     * Returns value of '_excavate' property
     *
     * @return Up_Excavate
     */
    public function getExcavate()
    {
        return $this->get(self::_EXCAVATE);
    }

    /**
     * Sets value of '_push_notify' property
     *
     * @param Up_PushNotify $value Property value
     *
     * @return null
     */
    public function setPushNotify(Up_PushNotify $value)
    {
        return $this->set(self::_PUSH_NOTIFY, $value);
    }

    /**
     * Returns value of '_push_notify' property
     *
     * @return Up_PushNotify
     */
    public function getPushNotify()
    {
        return $this->get(self::_PUSH_NOTIFY);
    }

    /**
     * Sets value of '_system_setting' property
     *
     * @param Up_SystemSetting $value Property value
     *
     * @return null
     */
    public function setSystemSetting(Up_SystemSetting $value)
    {
        return $this->set(self::_SYSTEM_SETTING, $value);
    }

    /**
     * Returns value of '_system_setting' property
     *
     * @return Up_SystemSetting
     */
    public function getSystemSetting()
    {
        return $this->get(self::_SYSTEM_SETTING);
    }

    /**
     * Sets value of '_query_split_data' property
     *
     * @param Up_QuerySplitData $value Property value
     *
     * @return null
     */
    public function setQuerySplitData(Up_QuerySplitData $value)
    {
        return $this->set(self::_QUERY_SPLIT_DATA, $value);
    }

    /**
     * Returns value of '_query_split_data' property
     *
     * @return Up_QuerySplitData
     */
    public function getQuerySplitData()
    {
        return $this->get(self::_QUERY_SPLIT_DATA);
    }

    /**
     * Sets value of '_query_split_return' property
     *
     * @param Up_QuerySplitReturn $value Property value
     *
     * @return null
     */
    public function setQuerySplitReturn(Up_QuerySplitReturn $value)
    {
        return $this->set(self::_QUERY_SPLIT_RETURN, $value);
    }

    /**
     * Returns value of '_query_split_return' property
     *
     * @return Up_QuerySplitReturn
     */
    public function getQuerySplitReturn()
    {
        return $this->get(self::_QUERY_SPLIT_RETURN);
    }

    /**
     * Sets value of '_split_hero' property
     *
     * @param Up_SplitHero $value Property value
     *
     * @return null
     */
    public function setSplitHero(Up_SplitHero $value)
    {
        return $this->set(self::_SPLIT_HERO, $value);
    }

    /**
     * Returns value of '_split_hero' property
     *
     * @return Up_SplitHero
     */
    public function getSplitHero()
    {
        return $this->get(self::_SPLIT_HERO);
    }

    /**
     * Sets value of '_worldcup' property
     *
     * @param Up_Worldcup $value Property value
     *
     * @return null
     */
    public function setWorldcup(Up_Worldcup $value)
    {
        return $this->set(self::_WORLDCUP, $value);
    }

    /**
     * Returns value of '_worldcup' property
     *
     * @return Up_Worldcup
     */
    public function getWorldcup()
    {
        return $this->get(self::_WORLDCUP);
    }

    /**
     * Sets value of '_report_battle' property
     *
     * @param Up_ReportBattle $value Property value
     *
     * @return null
     */
    public function setReportBattle(Up_ReportBattle $value)
    {
        return $this->set(self::_REPORT_BATTLE, $value);
    }

    /**
     * Returns value of '_report_battle' property
     *
     * @return Up_ReportBattle
     */
    public function getReportBattle()
    {
        return $this->get(self::_REPORT_BATTLE);
    }

    /**
     * Sets value of '_query_replay' property
     *
     * @param Up_QueryReplay $value Property value
     *
     * @return null
     */
    public function setQueryReplay(Up_QueryReplay $value)
    {
        return $this->set(self::_QUERY_REPLAY, $value);
    }

    /**
     * Returns value of '_query_replay' property
     *
     * @return Up_QueryReplay
     */
    public function getQueryReplay()
    {
        return $this->get(self::_QUERY_REPLAY);
    }

    /**
     * Sets value of '_sync_skill_stren' property
     *
     * @param Up_SyncSkillStren $value Property value
     *
     * @return null
     */
    public function setSyncSkillStren(Up_SyncSkillStren $value)
    {
        return $this->set(self::_SYNC_SKILL_STREN, $value);
    }

    /**
     * Returns value of '_sync_skill_stren' property
     *
     * @return Up_SyncSkillStren
     */
    public function getSyncSkillStren()
    {
        return $this->get(self::_SYNC_SKILL_STREN);
    }

    /**
     * Sets value of '_query_ranklist' property
     *
     * @param Up_QueryRanklist $value Property value
     *
     * @return null
     */
    public function setQueryRanklist(Up_QueryRanklist $value)
    {
        return $this->set(self::_QUERY_RANKLIST, $value);
    }

    /**
     * Returns value of '_query_ranklist' property
     *
     * @return Up_QueryRanklist
     */
    public function getQueryRanklist()
    {
        return $this->get(self::_QUERY_RANKLIST);
    }

    /**
     * Sets value of '_change_server' property
     *
     * @param Up_ChangeServer $value Property value
     *
     * @return null
     */
    public function setChangeServer(Up_ChangeServer $value)
    {
        return $this->set(self::_CHANGE_SERVER, $value);
    }

    /**
     * Returns value of '_change_server' property
     *
     * @return Up_ChangeServer
     */
    public function getChangeServer()
    {
        return $this->get(self::_CHANGE_SERVER);
    }

    /**
     * Sets value of '_require_arousal' property
     *
     * @param Up_RequireArousal $value Property value
     *
     * @return null
     */
    public function setRequireArousal(Up_RequireArousal $value)
    {
        return $this->set(self::_REQUIRE_AROUSAL, $value);
    }

    /**
     * Returns value of '_require_arousal' property
     *
     * @return Up_RequireArousal
     */
    public function getRequireArousal()
    {
        return $this->get(self::_REQUIRE_AROUSAL);
    }

    /**
     * Sets value of '_change_task_status' property
     *
     * @param Up_ChangeTaskStatus $value Property value
     *
     * @return null
     */
    public function setChangeTaskStatus(Up_ChangeTaskStatus $value)
    {
        return $this->set(self::_CHANGE_TASK_STATUS, $value);
    }

    /**
     * Returns value of '_change_task_status' property
     *
     * @return Up_ChangeTaskStatus
     */
    public function getChangeTaskStatus()
    {
        return $this->get(self::_CHANGE_TASK_STATUS);
    }

    /**
     * Sets value of '_request_guild_log' property
     *
     * @param Up_RequestGuildLog $value Property value
     *
     * @return null
     */
    public function setRequestGuildLog(Up_RequestGuildLog $value)
    {
        return $this->set(self::_REQUEST_GUILD_LOG, $value);
    }

    /**
     * Returns value of '_request_guild_log' property
     *
     * @return Up_RequestGuildLog
     */
    public function getRequestGuildLog()
    {
        return $this->get(self::_REQUEST_GUILD_LOG);
    }

    /**
     * Sets value of '_query_act_stage' property
     *
     * @param Up_QueryActStage $value Property value
     *
     * @return null
     */
    public function setQueryActStage(Up_QueryActStage $value)
    {
        return $this->set(self::_QUERY_ACT_STAGE, $value);
    }

    /**
     * Returns value of '_query_act_stage' property
     *
     * @return Up_QueryActStage
     */
    public function getQueryActStage()
    {
        return $this->get(self::_QUERY_ACT_STAGE);
    }

    /**
     * Sets value of '_request_upgrade_arousal_level' property
     *
     * @param Up_RequestUpgradeArousalLevel $value Property value
     *
     * @return null
     */
    public function setRequestUpgradeArousalLevel(Up_RequestUpgradeArousalLevel $value)
    {
        return $this->set(self::_REQUEST_UPGRADE_AROUSAL_LEVEL, $value);
    }

    /**
     * Returns value of '_request_upgrade_arousal_level' property
     *
     * @return Up_RequestUpgradeArousalLevel
     */
    public function getRequestUpgradeArousalLevel()
    {
        return $this->get(self::_REQUEST_UPGRADE_AROUSAL_LEVEL);
    }
}

/**
 * request_upgrade_arousal_level message
 */
class Up_RequestUpgradeArousalLevel extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * system_setting message
 */
class Up_SystemSetting extends \ProtobufMessage
{
    /* Field index constants */
    const _REQUEST = 1;
    const _CHANGE = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_REQUEST => array(
            'name' => '_request',
            'required' => false,
            'type' => 'Up_SystemSettingRequest'
        ),
        self::_CHANGE => array(
            'name' => '_change',
            'required' => false,
            'type' => 'Up_SystemSettingChange'
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
     * @param Up_SystemSettingRequest $value Property value
     *
     * @return null
     */
    public function setRequest(Up_SystemSettingRequest $value)
    {
        return $this->set(self::_REQUEST, $value);
    }

    /**
     * Returns value of '_request' property
     *
     * @return Up_SystemSettingRequest
     */
    public function getRequest()
    {
        return $this->get(self::_REQUEST);
    }

    /**
     * Sets value of '_change' property
     *
     * @param Up_SystemSettingChange $value Property value
     *
     * @return null
     */
    public function setChange(Up_SystemSettingChange $value)
    {
        return $this->set(self::_CHANGE, $value);
    }

    /**
     * Returns value of '_change' property
     *
     * @return Up_SystemSettingChange
     */
    public function getChange()
    {
        return $this->get(self::_CHANGE);
    }
}

/**
 * setting_status enum embedded in system_setting_change message
 */
final class Up_SystemSettingChange_SettingStatus
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
 * system_setting_change message
 */
class Up_SystemSettingChange extends \ProtobufMessage
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
     * @param string $value Property value
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
     * @return string
     */
    public function getValue()
    {
        return $this->get(self::VALUE);
    }
}

/**
 * system_setting_request message
 */
class Up_SystemSettingRequest extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * push_notify message
 */
class Up_PushNotify extends \ProtobufMessage
{
    /* Field index constants */
    const _CLIENT_ID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_CLIENT_ID => array(
            'name' => '_client_id',
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
        $this->values[self::_CLIENT_ID] = null;
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
     * Sets value of '_client_id' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setClientId($value)
    {
        return $this->set(self::_CLIENT_ID, $value);
    }

    /**
     * Returns value of '_client_id' property
     *
     * @return string
     */
    public function getClientId()
    {
        return $this->get(self::_CLIENT_ID);
    }
}

/**
 * login message
 */
class Up_Login extends \ProtobufMessage
{
    /* Field index constants */
    const _ACTIVE_CODE = 1;
    const _OLD_DEVICEID = 2;
    const _VERSION = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ACTIVE_CODE => array(
            'name' => '_active_code',
            'required' => false,
            'type' => 5,
        ),
        self::_OLD_DEVICEID => array(
            'name' => '_old_deviceid',
            'required' => false,
            'type' => 7,
        ),
        self::_VERSION => array(
            'name' => '_version',
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
        $this->values[self::_ACTIVE_CODE] = null;
        $this->values[self::_OLD_DEVICEID] = null;
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
     * Sets value of '_active_code' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setActiveCode($value)
    {
        return $this->set(self::_ACTIVE_CODE, $value);
    }

    /**
     * Returns value of '_active_code' property
     *
     * @return int
     */
    public function getActiveCode()
    {
        return $this->get(self::_ACTIVE_CODE);
    }

    /**
     * Sets value of '_old_deviceid' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setOldDeviceid($value)
    {
        return $this->set(self::_OLD_DEVICEID, $value);
    }

    /**
     * Returns value of '_old_deviceid' property
     *
     * @return string
     */
    public function getOldDeviceid()
    {
        return $this->get(self::_OLD_DEVICEID);
    }

    /**
     * Sets value of '_version' property
     *
     * @param string $value Property value
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
     * @return string
     */
    public function getVersion()
    {
        return $this->get(self::_VERSION);
    }
}

/**
 * sdk_login message
 */
class Up_SdkLogin extends \ProtobufMessage
{
    /* Field index constants */
    const _SESSION_KEY = 1;
    const _PLAT_ID = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_SESSION_KEY => array(
            'name' => '_session_key',
            'required' => true,
            'type' => 7,
        ),
        self::_PLAT_ID => array(
            'name' => '_plat_id',
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
        $this->values[self::_SESSION_KEY] = null;
        $this->values[self::_PLAT_ID] = null;
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
     * Sets value of '_session_key' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setSessionKey($value)
    {
        return $this->set(self::_SESSION_KEY, $value);
    }

    /**
     * Returns value of '_session_key' property
     *
     * @return string
     */
    public function getSessionKey()
    {
        return $this->get(self::_SESSION_KEY);
    }

    /**
     * Sets value of '_plat_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setPlatId($value)
    {
        return $this->set(self::_PLAT_ID, $value);
    }

    /**
     * Returns value of '_plat_id' property
     *
     * @return int
     */
    public function getPlatId()
    {
        return $this->get(self::_PLAT_ID);
    }
}

/**
 * request_userinfo message
 */
class Up_RequestUserinfo extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * enter_stage message
 */
class Up_EnterStage extends \ProtobufMessage
{
    /* Field index constants */
    const _STAGE_ID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_STAGE_ID => array(
            'name' => '_stage_id',
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
        $this->values[self::_STAGE_ID] = null;
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
}

/**
 * exit_stage message
 */
class Up_ExitStage extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _STARS = 2;
    const _HEROES = 3;
    const _OPRATIONS = 4;
    const _MD5 = 5;
    const _SELF_DATA = 6;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Up_BattleResult::victory, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_STARS => array(
            'name' => '_stars',
            'required' => false,
            'type' => 5,
        ),
        self::_HEROES => array(
            'name' => '_heroes',
            'repeated' => true,
            'type' => 5,
        ),
        self::_OPRATIONS => array(
            'name' => '_oprations',
            'repeated' => true,
            'type' => 5,
        ),
        self::_MD5 => array(
            'name' => '_md5',
            'required' => false,
            'type' => 7,
        ),
        self::_SELF_DATA => array(
            'name' => '_self_data',
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
        $this->values[self::_STARS] = null;
        $this->values[self::_HEROES] = array();
        $this->values[self::_OPRATIONS] = array();
        $this->values[self::_MD5] = null;
        $this->values[self::_SELF_DATA] = array();
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
     * Appends value to '_heroes' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendHeroes($value)
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
     * @return int[]
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
     * @return int
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
     * Appends value to '_oprations' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendOprations($value)
    {
        return $this->append(self::_OPRATIONS, $value);
    }

    /**
     * Clears '_oprations' list
     *
     * @return null
     */
    public function clearOprations()
    {
        return $this->clear(self::_OPRATIONS);
    }

    /**
     * Returns '_oprations' list
     *
     * @return int[]
     */
    public function getOprations()
    {
        return $this->get(self::_OPRATIONS);
    }

    /**
     * Returns '_oprations' iterator
     *
     * @return ArrayIterator
     */
    public function getOprationsIterator()
    {
        return new \ArrayIterator($this->get(self::_OPRATIONS));
    }

    /**
     * Returns element from '_oprations' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getOprationsAt($offset)
    {
        return $this->get(self::_OPRATIONS, $offset);
    }

    /**
     * Returns count of '_oprations' list
     *
     * @return int
     */
    public function getOprationsCount()
    {
        return $this->count(self::_OPRATIONS);
    }

    /**
     * Sets value of '_md5' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setMd5($value)
    {
        return $this->set(self::_MD5, $value);
    }

    /**
     * Returns value of '_md5' property
     *
     * @return string
     */
    public function getMd5()
    {
        return $this->get(self::_MD5);
    }

    /**
     * Appends value to '_self_data' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendSelfData($value)
    {
        return $this->append(self::_SELF_DATA, $value);
    }

    /**
     * Clears '_self_data' list
     *
     * @return null
     */
    public function clearSelfData()
    {
        return $this->clear(self::_SELF_DATA);
    }

    /**
     * Returns '_self_data' list
     *
     * @return int[]
     */
    public function getSelfData()
    {
        return $this->get(self::_SELF_DATA);
    }

    /**
     * Returns '_self_data' iterator
     *
     * @return ArrayIterator
     */
    public function getSelfDataIterator()
    {
        return new \ArrayIterator($this->get(self::_SELF_DATA));
    }

    /**
     * Returns element from '_self_data' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getSelfDataAt($offset)
    {
        return $this->get(self::_SELF_DATA, $offset);
    }

    /**
     * Returns count of '_self_data' list
     *
     * @return int
     */
    public function getSelfDataCount()
    {
        return $this->count(self::_SELF_DATA);
    }
}

/**
 * gm_cmd message
 */
class Up_GmCmd extends \ProtobufMessage
{
    /* Field index constants */
    const _UNLOCK_ALL_STAGES = 1;
    const _GET_ALL_HEROES = 2;
    const _SET_HERO_INFO = 3;
    const _SET_VITALITY = 4;
    const _SET_MONEY = 5;
    const _SET_RECHARGE_SUM = 6;
    const _SET_PLAYER_LEVEL = 7;
    const _SET_PLAYER_EXP = 8;
    const _SET_ITEMS = 9;
    const _RESET_DEVICE = 10;
    const _OPEN_MYSTERY_SHOP = 11;
    const _ARCHIVE_ID = 12;
    const _RESTORE_ID = 13;
    const _RESET_SWEEP = 14;
    const _SET_DAILYLOGIN_DAYS = 15;
    const _OPEN_GUILD_STAGE = 16;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_UNLOCK_ALL_STAGES => array(
            'name' => '_unlock_all_stages',
            'required' => false,
            'type' => 5,
        ),
        self::_GET_ALL_HEROES => array(
            'name' => '_get_all_heroes',
            'required' => false,
            'type' => 5,
        ),
        self::_SET_HERO_INFO => array(
            'name' => '_set_hero_info',
            'repeated' => true,
            'type' => 'Up_Hero'
        ),
        self::_SET_VITALITY => array(
            'name' => '_set_vitality',
            'required' => false,
            'type' => 5,
        ),
        self::_SET_MONEY => array(
            'name' => '_set_money',
            'required' => false,
            'type' => 'Up_SetMoney'
        ),
        self::_SET_RECHARGE_SUM => array(
            'name' => '_set_recharge_sum',
            'required' => false,
            'type' => 5,
        ),
        self::_SET_PLAYER_LEVEL => array(
            'name' => '_set_player_level',
            'required' => false,
            'type' => 5,
        ),
        self::_SET_PLAYER_EXP => array(
            'name' => '_set_player_exp',
            'required' => false,
            'type' => 5,
        ),
        self::_SET_ITEMS => array(
            'name' => '_set_items',
            'repeated' => true,
            'type' => 5,
        ),
        self::_RESET_DEVICE => array(
            'name' => '_reset_device',
            'required' => false,
            'type' => 5,
        ),
        self::_OPEN_MYSTERY_SHOP => array(
            'name' => '_open_mystery_shop',
            'required' => false,
            'type' => 5,
        ),
        self::_ARCHIVE_ID => array(
            'name' => '_archive_id',
            'required' => false,
            'type' => 5,
        ),
        self::_RESTORE_ID => array(
            'name' => '_restore_id',
            'required' => false,
            'type' => 5,
        ),
        self::_RESET_SWEEP => array(
            'name' => '_reset_sweep',
            'required' => false,
            'type' => 5,
        ),
        self::_SET_DAILYLOGIN_DAYS => array(
            'name' => '_set_dailylogin_days',
            'required' => false,
            'type' => 5,
        ),
        self::_OPEN_GUILD_STAGE => array(
            'name' => '_open_guild_stage',
            'required' => false,
            'type' => 'Up_OpenAllGuildStage'
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
        $this->values[self::_UNLOCK_ALL_STAGES] = null;
        $this->values[self::_GET_ALL_HEROES] = null;
        $this->values[self::_SET_HERO_INFO] = array();
        $this->values[self::_SET_VITALITY] = null;
        $this->values[self::_SET_MONEY] = null;
        $this->values[self::_SET_RECHARGE_SUM] = null;
        $this->values[self::_SET_PLAYER_LEVEL] = null;
        $this->values[self::_SET_PLAYER_EXP] = null;
        $this->values[self::_SET_ITEMS] = array();
        $this->values[self::_RESET_DEVICE] = null;
        $this->values[self::_OPEN_MYSTERY_SHOP] = null;
        $this->values[self::_ARCHIVE_ID] = null;
        $this->values[self::_RESTORE_ID] = null;
        $this->values[self::_RESET_SWEEP] = null;
        $this->values[self::_SET_DAILYLOGIN_DAYS] = null;
        $this->values[self::_OPEN_GUILD_STAGE] = null;
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
     * Sets value of '_unlock_all_stages' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setUnlockAllStages($value)
    {
        return $this->set(self::_UNLOCK_ALL_STAGES, $value);
    }

    /**
     * Returns value of '_unlock_all_stages' property
     *
     * @return int
     */
    public function getUnlockAllStages()
    {
        return $this->get(self::_UNLOCK_ALL_STAGES);
    }

    /**
     * Sets value of '_get_all_heroes' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setGetAllHeroes($value)
    {
        return $this->set(self::_GET_ALL_HEROES, $value);
    }

    /**
     * Returns value of '_get_all_heroes' property
     *
     * @return int
     */
    public function getGetAllHeroes()
    {
        return $this->get(self::_GET_ALL_HEROES);
    }

    /**
     * Appends value to '_set_hero_info' list
     *
     * @param Up_Hero $value Value to append
     *
     * @return null
     */
    public function appendSetHeroInfo(Up_Hero $value)
    {
        return $this->append(self::_SET_HERO_INFO, $value);
    }

    /**
     * Clears '_set_hero_info' list
     *
     * @return null
     */
    public function clearSetHeroInfo()
    {
        return $this->clear(self::_SET_HERO_INFO);
    }

    /**
     * Returns '_set_hero_info' list
     *
     * @return Up_Hero[]
     */
    public function getSetHeroInfo()
    {
        return $this->get(self::_SET_HERO_INFO);
    }

    /**
     * Returns '_set_hero_info' iterator
     *
     * @return ArrayIterator
     */
    public function getSetHeroInfoIterator()
    {
        return new \ArrayIterator($this->get(self::_SET_HERO_INFO));
    }

    /**
     * Returns element from '_set_hero_info' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return Up_Hero
     */
    public function getSetHeroInfoAt($offset)
    {
        return $this->get(self::_SET_HERO_INFO, $offset);
    }

    /**
     * Returns count of '_set_hero_info' list
     *
     * @return int
     */
    public function getSetHeroInfoCount()
    {
        return $this->count(self::_SET_HERO_INFO);
    }

    /**
     * Sets value of '_set_vitality' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSetVitality($value)
    {
        return $this->set(self::_SET_VITALITY, $value);
    }

    /**
     * Returns value of '_set_vitality' property
     *
     * @return int
     */
    public function getSetVitality()
    {
        return $this->get(self::_SET_VITALITY);
    }

    /**
     * Sets value of '_set_money' property
     *
     * @param Up_SetMoney $value Property value
     *
     * @return null
     */
    public function setSetMoney(Up_SetMoney $value)
    {
        return $this->set(self::_SET_MONEY, $value);
    }

    /**
     * Returns value of '_set_money' property
     *
     * @return Up_SetMoney
     */
    public function getSetMoney()
    {
        return $this->get(self::_SET_MONEY);
    }

    /**
     * Sets value of '_set_recharge_sum' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSetRechargeSum($value)
    {
        return $this->set(self::_SET_RECHARGE_SUM, $value);
    }

    /**
     * Returns value of '_set_recharge_sum' property
     *
     * @return int
     */
    public function getSetRechargeSum()
    {
        return $this->get(self::_SET_RECHARGE_SUM);
    }

    /**
     * Sets value of '_set_player_level' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSetPlayerLevel($value)
    {
        return $this->set(self::_SET_PLAYER_LEVEL, $value);
    }

    /**
     * Returns value of '_set_player_level' property
     *
     * @return int
     */
    public function getSetPlayerLevel()
    {
        return $this->get(self::_SET_PLAYER_LEVEL);
    }

    /**
     * Sets value of '_set_player_exp' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSetPlayerExp($value)
    {
        return $this->set(self::_SET_PLAYER_EXP, $value);
    }

    /**
     * Returns value of '_set_player_exp' property
     *
     * @return int
     */
    public function getSetPlayerExp()
    {
        return $this->get(self::_SET_PLAYER_EXP);
    }

    /**
     * Appends value to '_set_items' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendSetItems($value)
    {
        return $this->append(self::_SET_ITEMS, $value);
    }

    /**
     * Clears '_set_items' list
     *
     * @return null
     */
    public function clearSetItems()
    {
        return $this->clear(self::_SET_ITEMS);
    }

    /**
     * Returns '_set_items' list
     *
     * @return int[]
     */
    public function getSetItems()
    {
        return $this->get(self::_SET_ITEMS);
    }

    /**
     * Returns '_set_items' iterator
     *
     * @return ArrayIterator
     */
    public function getSetItemsIterator()
    {
        return new \ArrayIterator($this->get(self::_SET_ITEMS));
    }

    /**
     * Returns element from '_set_items' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getSetItemsAt($offset)
    {
        return $this->get(self::_SET_ITEMS, $offset);
    }

    /**
     * Returns count of '_set_items' list
     *
     * @return int
     */
    public function getSetItemsCount()
    {
        return $this->count(self::_SET_ITEMS);
    }

    /**
     * Sets value of '_reset_device' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResetDevice($value)
    {
        return $this->set(self::_RESET_DEVICE, $value);
    }

    /**
     * Returns value of '_reset_device' property
     *
     * @return int
     */
    public function getResetDevice()
    {
        return $this->get(self::_RESET_DEVICE);
    }

    /**
     * Sets value of '_open_mystery_shop' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setOpenMysteryShop($value)
    {
        return $this->set(self::_OPEN_MYSTERY_SHOP, $value);
    }

    /**
     * Returns value of '_open_mystery_shop' property
     *
     * @return int
     */
    public function getOpenMysteryShop()
    {
        return $this->get(self::_OPEN_MYSTERY_SHOP);
    }

    /**
     * Sets value of '_archive_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setArchiveId($value)
    {
        return $this->set(self::_ARCHIVE_ID, $value);
    }

    /**
     * Returns value of '_archive_id' property
     *
     * @return int
     */
    public function getArchiveId()
    {
        return $this->get(self::_ARCHIVE_ID);
    }

    /**
     * Sets value of '_restore_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRestoreId($value)
    {
        return $this->set(self::_RESTORE_ID, $value);
    }

    /**
     * Returns value of '_restore_id' property
     *
     * @return int
     */
    public function getRestoreId()
    {
        return $this->get(self::_RESTORE_ID);
    }

    /**
     * Sets value of '_reset_sweep' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setResetSweep($value)
    {
        return $this->set(self::_RESET_SWEEP, $value);
    }

    /**
     * Returns value of '_reset_sweep' property
     *
     * @return int
     */
    public function getResetSweep()
    {
        return $this->get(self::_RESET_SWEEP);
    }

    /**
     * Sets value of '_set_dailylogin_days' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSetDailyloginDays($value)
    {
        return $this->set(self::_SET_DAILYLOGIN_DAYS, $value);
    }

    /**
     * Returns value of '_set_dailylogin_days' property
     *
     * @return int
     */
    public function getSetDailyloginDays()
    {
        return $this->get(self::_SET_DAILYLOGIN_DAYS);
    }

    /**
     * Sets value of '_open_guild_stage' property
     *
     * @param Up_OpenAllGuildStage $value Property value
     *
     * @return null
     */
    public function setOpenGuildStage(Up_OpenAllGuildStage $value)
    {
        return $this->set(self::_OPEN_GUILD_STAGE, $value);
    }

    /**
     * Returns value of '_open_guild_stage' property
     *
     * @return Up_OpenAllGuildStage
     */
    public function getOpenGuildStage()
    {
        return $this->get(self::_OPEN_GUILD_STAGE);
    }
}

/**
 * open_all_guild_stage message
 */
class Up_OpenAllGuildStage extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * price_type enum embedded in set_money message
 */
final class Up_SetMoney_PriceType
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
 * set_money message
 */
class Up_SetMoney extends \ProtobufMessage
{
    /* Field index constants */
    const _TYPE = 1;
    const _AMOUNT = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TYPE => array(
            'name' => '_type',
            'required' => true,
            'type' => 5,
        ),
        self::_AMOUNT => array(
            'name' => '_amount',
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
}

/**
 * hero_upgrade message
 */
class Up_HeroUpgrade extends \ProtobufMessage
{
    /* Field index constants */
    const _HERO_ID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_HERO_ID => array(
            'name' => '_hero_id',
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
        $this->values[self::_HERO_ID] = null;
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
}

/**
 * equip_synthesis message
 */
class Up_EquipSynthesis extends \ProtobufMessage
{
    /* Field index constants */
    const _EQUIP_ID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_EQUIP_ID => array(
            'name' => '_equip_id',
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
        $this->values[self::_EQUIP_ID] = null;
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
     * Sets value of '_equip_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setEquipId($value)
    {
        return $this->set(self::_EQUIP_ID, $value);
    }

    /**
     * Returns value of '_equip_id' property
     *
     * @return int
     */
    public function getEquipId()
    {
        return $this->get(self::_EQUIP_ID);
    }
}

/**
 * wear_equip message
 */
class Up_WearEquip extends \ProtobufMessage
{
    /* Field index constants */
    const _HERO_ID = 1;
    const _ITEM_POS = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_HERO_ID => array(
            'name' => '_hero_id',
            'required' => true,
            'type' => 5,
        ),
        self::_ITEM_POS => array(
            'name' => '_item_pos',
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
        $this->values[self::_HERO_ID] = null;
        $this->values[self::_ITEM_POS] = null;
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
     * Sets value of '_item_pos' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setItemPos($value)
    {
        return $this->set(self::_ITEM_POS, $value);
    }

    /**
     * Returns value of '_item_pos' property
     *
     * @return int
     */
    public function getItemPos()
    {
        return $this->get(self::_ITEM_POS);
    }
}

/**
 * sync_vitality message
 */
class Up_SyncVitality extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * buy_vitality message
 */
class Up_BuyVitality extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * consume_item message
 */
class Up_ConsumeItem extends \ProtobufMessage
{
    /* Field index constants */
    const _HERO_ID = 1;
    const _ITEM_ID = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_HERO_ID => array(
            'name' => '_hero_id',
            'required' => true,
            'type' => 5,
        ),
        self::_ITEM_ID => array(
            'name' => '_item_id',
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
        $this->values[self::_HERO_ID] = null;
        $this->values[self::_ITEM_ID] = null;
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
}

/**
 * rtype enum embedded in shop_refresh message
 */
final class Up_ShopRefresh_Rtype
{
    const sync = 0;
    const auto_refresh = 1;
    const manual_refresh = 2;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'sync' => self::sync,
            'auto_refresh' => self::auto_refresh,
            'manual_refresh' => self::manual_refresh,
        );
    }
}

/**
 * shop_refresh message
 */
class Up_ShopRefresh extends \ProtobufMessage
{
    /* Field index constants */
    const _TYPE = 1;
    const _SHOP_ID = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TYPE => array(
            'default' => Up_ShopRefresh_Rtype::sync, 
            'name' => '_type',
            'required' => true,
            'type' => 5,
        ),
        self::_SHOP_ID => array(
            'name' => '_shop_id',
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
        $this->values[self::_SHOP_ID] = null;
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
     * Sets value of '_shop_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setShopId($value)
    {
        return $this->set(self::_SHOP_ID, $value);
    }

    /**
     * Returns value of '_shop_id' property
     *
     * @return int
     */
    public function getShopId()
    {
        return $this->get(self::_SHOP_ID);
    }
}

/**
 * shop_consume message
 */
class Up_ShopConsume extends \ProtobufMessage
{
    /* Field index constants */
    const _SID = 1;
    const _SLOTID = 2;
    const _AMOUNT = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_SID => array(
            'name' => '_sid',
            'required' => true,
            'type' => 5,
        ),
        self::_SLOTID => array(
            'name' => '_slotid',
            'required' => true,
            'type' => 5,
        ),
        self::_AMOUNT => array(
            'name' => '_amount',
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
        $this->values[self::_SID] = null;
        $this->values[self::_SLOTID] = null;
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
     * Sets value of '_sid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSid($value)
    {
        return $this->set(self::_SID, $value);
    }

    /**
     * Returns value of '_sid' property
     *
     * @return int
     */
    public function getSid()
    {
        return $this->get(self::_SID);
    }

    /**
     * Sets value of '_slotid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSlotid($value)
    {
        return $this->set(self::_SLOTID, $value);
    }

    /**
     * Returns value of '_slotid' property
     *
     * @return int
     */
    public function getSlotid()
    {
        return $this->get(self::_SLOTID);
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
 * skill_levelup message
 */
class Up_SkillLevelup extends \ProtobufMessage
{
    /* Field index constants */
    const _HEROID = 1;
    const _ORDER = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_HEROID => array(
            'name' => '_heroid',
            'required' => true,
            'type' => 5,
        ),
        self::_ORDER => array(
            'name' => '_order',
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
        $this->values[self::_HEROID] = null;
        $this->values[self::_ORDER] = array();
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

    /**
     * Appends value to '_order' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendOrder($value)
    {
        return $this->append(self::_ORDER, $value);
    }

    /**
     * Clears '_order' list
     *
     * @return null
     */
    public function clearOrder()
    {
        return $this->clear(self::_ORDER);
    }

    /**
     * Returns '_order' list
     *
     * @return int[]
     */
    public function getOrder()
    {
        return $this->get(self::_ORDER);
    }

    /**
     * Returns '_order' iterator
     *
     * @return ArrayIterator
     */
    public function getOrderIterator()
    {
        return new \ArrayIterator($this->get(self::_ORDER));
    }

    /**
     * Returns element from '_order' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getOrderAt($offset)
    {
        return $this->get(self::_ORDER, $offset);
    }

    /**
     * Returns count of '_order' list
     *
     * @return int
     */
    public function getOrderCount()
    {
        return $this->count(self::_ORDER);
    }
}

/**
 * sell_item message
 */
class Up_SellItem extends \ProtobufMessage
{
    /* Field index constants */
    const _ITEM = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ITEM => array(
            'name' => '_item',
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
        $this->values[self::_ITEM] = array();
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
     * Appends value to '_item' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendItem($value)
    {
        return $this->append(self::_ITEM, $value);
    }

    /**
     * Clears '_item' list
     *
     * @return null
     */
    public function clearItem()
    {
        return $this->clear(self::_ITEM);
    }

    /**
     * Returns '_item' list
     *
     * @return int[]
     */
    public function getItem()
    {
        return $this->get(self::_ITEM);
    }

    /**
     * Returns '_item' iterator
     *
     * @return ArrayIterator
     */
    public function getItemIterator()
    {
        return new \ArrayIterator($this->get(self::_ITEM));
    }

    /**
     * Returns element from '_item' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getItemAt($offset)
    {
        return $this->get(self::_ITEM, $offset);
    }

    /**
     * Returns count of '_item' list
     *
     * @return int
     */
    public function getItemCount()
    {
        return $this->count(self::_ITEM);
    }
}

/**
 * fragment_compose message
 */
class Up_FragmentCompose extends \ProtobufMessage
{
    /* Field index constants */
    const _FRAGMENT = 1;
    const _FRAG_AMOUNT = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_FRAGMENT => array(
            'name' => '_fragment',
            'required' => true,
            'type' => 5,
        ),
        self::_FRAG_AMOUNT => array(
            'name' => '_frag_amount',
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
        $this->values[self::_FRAGMENT] = null;
        $this->values[self::_FRAG_AMOUNT] = null;
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
     * Sets value of '_fragment' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setFragment($value)
    {
        return $this->set(self::_FRAGMENT, $value);
    }

    /**
     * Returns value of '_fragment' property
     *
     * @return int
     */
    public function getFragment()
    {
        return $this->get(self::_FRAGMENT);
    }

    /**
     * Sets value of '_frag_amount' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setFragAmount($value)
    {
        return $this->set(self::_FRAG_AMOUNT, $value);
    }

    /**
     * Returns value of '_frag_amount' property
     *
     * @return int
     */
    public function getFragAmount()
    {
        return $this->get(self::_FRAG_AMOUNT);
    }
}

/**
 * OP_TYPE enum embedded in hero_equip_upgrade message
 */
final class Up_HeroEquipUpgrade_OPTYPE
{
    const normal = 1;
    const boss = 2;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'normal' => self::normal,
            'boss' => self::boss,
        );
    }
}

/**
 * hero_equip_upgrade message
 */
class Up_HeroEquipUpgrade extends \ProtobufMessage
{
    /* Field index constants */
    const _OP_TYPE = 1;
    const _HEROID = 2;
    const _SLOT = 3;
    const _MATERIALS = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_OP_TYPE => array(
            'default' => Up_HeroEquipUpgrade_OPTYPE::normal, 
            'name' => '_op_type',
            'required' => true,
            'type' => 5,
        ),
        self::_HEROID => array(
            'name' => '_heroid',
            'required' => true,
            'type' => 5,
        ),
        self::_SLOT => array(
            'name' => '_slot',
            'required' => true,
            'type' => 5,
        ),
        self::_MATERIALS => array(
            'name' => '_materials',
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
        $this->values[self::_OP_TYPE] = null;
        $this->values[self::_HEROID] = null;
        $this->values[self::_SLOT] = null;
        $this->values[self::_MATERIALS] = array();
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
     * Sets value of '_op_type' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setOpType($value)
    {
        return $this->set(self::_OP_TYPE, $value);
    }

    /**
     * Returns value of '_op_type' property
     *
     * @return int
     */
    public function getOpType()
    {
        return $this->get(self::_OP_TYPE);
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

    /**
     * Sets value of '_slot' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setSlot($value)
    {
        return $this->set(self::_SLOT, $value);
    }

    /**
     * Returns value of '_slot' property
     *
     * @return int
     */
    public function getSlot()
    {
        return $this->get(self::_SLOT);
    }

    /**
     * Appends value to '_materials' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendMaterials($value)
    {
        return $this->append(self::_MATERIALS, $value);
    }

    /**
     * Clears '_materials' list
     *
     * @return null
     */
    public function clearMaterials()
    {
        return $this->clear(self::_MATERIALS);
    }

    /**
     * Returns '_materials' list
     *
     * @return int[]
     */
    public function getMaterials()
    {
        return $this->get(self::_MATERIALS);
    }

    /**
     * Returns '_materials' iterator
     *
     * @return ArrayIterator
     */
    public function getMaterialsIterator()
    {
        return new \ArrayIterator($this->get(self::_MATERIALS));
    }

    /**
     * Returns element from '_materials' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getMaterialsAt($offset)
    {
        return $this->get(self::_MATERIALS, $offset);
    }

    /**
     * Returns count of '_materials' list
     *
     * @return int
     */
    public function getMaterialsCount()
    {
        return $this->count(self::_MATERIALS);
    }
}

/**
 * hero_equip message
 */
class Up_HeroEquip extends \ProtobufMessage
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
class Up_Hero extends \ProtobufMessage
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
    const _AROUSAL = 10;

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
            'type' => 'Up_HeroEquip'
        ),
        self::_AROUSAL => array(
            'name' => '_arousal',
            'required' => false,
            'type' => 'Up_HeroArousal'
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
        $this->values[self::_AROUSAL] = null;
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
     * @param Up_HeroEquip $value Value to append
     *
     * @return null
     */
    public function appendItems(Up_HeroEquip $value)
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
     * @return Up_HeroEquip[]
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
     * @return Up_HeroEquip
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
     * Sets value of '_arousal' property
     *
     * @param Up_HeroArousal $value Property value
     *
     * @return null
     */
    public function setArousal(Up_HeroArousal $value)
    {
        return $this->set(self::_AROUSAL, $value);
    }

    /**
     * Returns value of '_arousal' property
     *
     * @return Up_HeroArousal
     */
    public function getArousal()
    {
        return $this->get(self::_AROUSAL);
    }
}

/**
 * hero_arousal message
 */
class Up_HeroArousal extends \ProtobufMessage
{
    /* Field index constants */
    const _STATUS = 1;
    const _STR = 2;
    const _AGI = 3;
    const _INT = 4;
    const _STR_VAR = 5;
    const _AGI_VAR = 6;
    const _INT_VAR = 7;
    const _COST_GOLD = 8;
    const _COST_DIAMOND = 9;
    const _ARO_EXP = 10;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_STATUS => array(
            'name' => '_status',
            'required' => true,
            'type' => 5,
        ),
        self::_STR => array(
            'name' => '_str',
            'required' => true,
            'type' => 5,
        ),
        self::_AGI => array(
            'name' => '_agi',
            'required' => true,
            'type' => 5,
        ),
        self::_INT => array(
            'name' => '_int',
            'required' => true,
            'type' => 5,
        ),
        self::_STR_VAR => array(
            'name' => '_str_var',
            'required' => true,
            'type' => 5,
        ),
        self::_AGI_VAR => array(
            'name' => '_agi_var',
            'required' => true,
            'type' => 5,
        ),
        self::_INT_VAR => array(
            'name' => '_int_var',
            'required' => true,
            'type' => 5,
        ),
        self::_COST_GOLD => array(
            'name' => '_cost_gold',
            'required' => true,
            'type' => 5,
        ),
        self::_COST_DIAMOND => array(
            'name' => '_cost_diamond',
            'required' => true,
            'type' => 5,
        ),
        self::_ARO_EXP => array(
            'name' => '_aro_exp',
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
        $this->values[self::_STR] = null;
        $this->values[self::_AGI] = null;
        $this->values[self::_INT] = null;
        $this->values[self::_STR_VAR] = null;
        $this->values[self::_AGI_VAR] = null;
        $this->values[self::_INT_VAR] = null;
        $this->values[self::_COST_GOLD] = null;
        $this->values[self::_COST_DIAMOND] = null;
        $this->values[self::_ARO_EXP] = null;
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
     * Sets value of '_str' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStr($value)
    {
        return $this->set(self::_STR, $value);
    }

    /**
     * Returns value of '_str' property
     *
     * @return int
     */
    public function getStr()
    {
        return $this->get(self::_STR);
    }

    /**
     * Sets value of '_agi' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setAgi($value)
    {
        return $this->set(self::_AGI, $value);
    }

    /**
     * Returns value of '_agi' property
     *
     * @return int
     */
    public function getAgi()
    {
        return $this->get(self::_AGI);
    }

    /**
     * Sets value of '_int' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setInt($value)
    {
        return $this->set(self::_INT, $value);
    }

    /**
     * Returns value of '_int' property
     *
     * @return int
     */
    public function getInt()
    {
        return $this->get(self::_INT);
    }

    /**
     * Sets value of '_str_var' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStrVar($value)
    {
        return $this->set(self::_STR_VAR, $value);
    }

    /**
     * Returns value of '_str_var' property
     *
     * @return int
     */
    public function getStrVar()
    {
        return $this->get(self::_STR_VAR);
    }

    /**
     * Sets value of '_agi_var' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setAgiVar($value)
    {
        return $this->set(self::_AGI_VAR, $value);
    }

    /**
     * Returns value of '_agi_var' property
     *
     * @return int
     */
    public function getAgiVar()
    {
        return $this->get(self::_AGI_VAR);
    }

    /**
     * Sets value of '_int_var' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setIntVar($value)
    {
        return $this->set(self::_INT_VAR, $value);
    }

    /**
     * Returns value of '_int_var' property
     *
     * @return int
     */
    public function getIntVar()
    {
        return $this->get(self::_INT_VAR);
    }

    /**
     * Sets value of '_cost_gold' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCostGold($value)
    {
        return $this->set(self::_COST_GOLD, $value);
    }

    /**
     * Returns value of '_cost_gold' property
     *
     * @return int
     */
    public function getCostGold()
    {
        return $this->get(self::_COST_GOLD);
    }

    /**
     * Sets value of '_cost_diamond' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setCostDiamond($value)
    {
        return $this->set(self::_COST_DIAMOND, $value);
    }

    /**
     * Returns value of '_cost_diamond' property
     *
     * @return int
     */
    public function getCostDiamond()
    {
        return $this->get(self::_COST_DIAMOND);
    }

    /**
     * Sets value of '_aro_exp' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setAroExp($value)
    {
        return $this->set(self::_ARO_EXP, $value);
    }

    /**
     * Returns value of '_aro_exp' property
     *
     * @return int
     */
    public function getAroExp()
    {
        return $this->get(self::_ARO_EXP);
    }
}

/**
 * tutorial message
 */
class Up_Tutorial extends \ProtobufMessage
{
    /* Field index constants */
    const _RECORD = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RECORD => array(
            'name' => '_record',
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
        $this->values[self::_RECORD] = array();
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
     * Appends value to '_record' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendRecord($value)
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
     * @return int[]
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
     * @return int
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
}

/**
 * trigger_task message
 */
class Up_TriggerTask extends \ProtobufMessage
{
    /* Field index constants */
    const _TASK = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TASK => array(
            'name' => '_task',
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
        $this->values[self::_TASK] = array();
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
     * Appends value to '_task' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendTask($value)
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
     * @return int[]
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
     * @return int
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
}

/**
 * require_rewards message
 */
class Up_RequireRewards extends \ProtobufMessage
{
    /* Field index constants */
    const _LINE = 1;
    const _ID = 2;

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
}

/**
 * change_task_status message
 */
class Up_ChangeTaskStatus extends \ProtobufMessage
{
    /* Field index constants */
    const _LINE = 1;
    const _ID = 2;
    const _OPERATION = 3;

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
        self::_OPERATION => array(
            'name' => '_operation',
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
        $this->values[self::_LINE] = null;
        $this->values[self::_ID] = null;
        $this->values[self::_OPERATION] = null;
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
     * Sets value of '_operation' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setOperation($value)
    {
        return $this->set(self::_OPERATION, $value);
    }

    /**
     * Returns value of '_operation' property
     *
     * @return int
     */
    public function getOperation()
    {
        return $this->get(self::_OPERATION);
    }
}

/**
 * trigger_job message
 */
class Up_TriggerJob extends \ProtobufMessage
{
    /* Field index constants */
    const _JOBS = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_JOBS => array(
            'name' => '_jobs',
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
        $this->values[self::_JOBS] = array();
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
     * Appends value to '_jobs' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendJobs($value)
    {
        return $this->append(self::_JOBS, $value);
    }

    /**
     * Clears '_jobs' list
     *
     * @return null
     */
    public function clearJobs()
    {
        return $this->clear(self::_JOBS);
    }

    /**
     * Returns '_jobs' list
     *
     * @return int[]
     */
    public function getJobs()
    {
        return $this->get(self::_JOBS);
    }

    /**
     * Returns '_jobs' iterator
     *
     * @return ArrayIterator
     */
    public function getJobsIterator()
    {
        return new \ArrayIterator($this->get(self::_JOBS));
    }

    /**
     * Returns element from '_jobs' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getJobsAt($offset)
    {
        return $this->get(self::_JOBS, $offset);
    }

    /**
     * Returns count of '_jobs' list
     *
     * @return int
     */
    public function getJobsCount()
    {
        return $this->count(self::_JOBS);
    }
}

/**
 * job_rewards message
 */
class Up_JobRewards extends \ProtobufMessage
{
    /* Field index constants */
    const _JOB = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_JOB => array(
            'name' => '_job',
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
        $this->values[self::_JOB] = null;
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
}

/**
 * suspend_report message
 */
class Up_SuspendReport extends \ProtobufMessage
{
    /* Field index constants */
    const _GAMETIME = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_GAMETIME => array(
            'name' => '_gametime',
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
        $this->values[self::_GAMETIME] = null;
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
     * Sets value of '_gametime' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setGametime($value)
    {
        return $this->set(self::_GAMETIME, $value);
    }

    /**
     * Returns value of '_gametime' property
     *
     * @return int
     */
    public function getGametime()
    {
        return $this->get(self::_GAMETIME);
    }
}

/**
 * rtype enum embedded in reset_elite message
 */
final class Up_ResetElite_Rtype
{
    const daily_free = 0;
    const vip_reset = 1;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'daily_free' => self::daily_free,
            'vip_reset' => self::vip_reset,
        );
    }
}

/**
 * reset_elite message
 */
class Up_ResetElite extends \ProtobufMessage
{
    /* Field index constants */
    const _TYPE = 1;
    const _STAGEID = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TYPE => array(
            'default' => Up_ResetElite_Rtype::daily_free, 
            'name' => '_type',
            'required' => true,
            'type' => 5,
        ),
        self::_STAGEID => array(
            'name' => '_stageid',
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
        $this->values[self::_STAGEID] = null;
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
     * Sets value of '_stageid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStageid($value)
    {
        return $this->set(self::_STAGEID, $value);
    }

    /**
     * Returns value of '_stageid' property
     *
     * @return int
     */
    public function getStageid()
    {
        return $this->get(self::_STAGEID);
    }
}

/**
 * rtype enum embedded in sweep_stage message
 */
final class Up_SweepStage_Rtype
{
    const sweep_with_ticket = 0;
    const sweep_with_rmb = 1;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'sweep_with_ticket' => self::sweep_with_ticket,
            'sweep_with_rmb' => self::sweep_with_rmb,
        );
    }
}

/**
 * sweep_stage message
 */
class Up_SweepStage extends \ProtobufMessage
{
    /* Field index constants */
    const _TYPE = 1;
    const _STAGEID = 2;
    const _TIMES = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TYPE => array(
            'name' => '_type',
            'required' => true,
            'type' => 5,
        ),
        self::_STAGEID => array(
            'name' => '_stageid',
            'required' => true,
            'type' => 5,
        ),
        self::_TIMES => array(
            'name' => '_times',
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
        $this->values[self::_STAGEID] = null;
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
     * Sets value of '_stageid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStageid($value)
    {
        return $this->set(self::_STAGEID, $value);
    }

    /**
     * Returns value of '_stageid' property
     *
     * @return int
     */
    public function getStageid()
    {
        return $this->get(self::_STAGEID);
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
 * buy_skill_stren_point message
 */
class Up_BuySkillStrenPoint extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * ask_magicsoul message
 */
class Up_AskMagicsoul extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * draw_type enum embedded in tavern_draw message
 */
final class Up_TavernDraw_DrawType
{
    const single = 0;
    const combo = 1;
    const stone = 3;
    const free = 4;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'single' => self::single,
            'combo' => self::combo,
            'stone' => self::stone,
            'free' => self::free,
        );
    }
}

/**
 * box_type enum embedded in tavern_draw message
 */
final class Up_TavernDraw_BoxType
{
    const green = 1;
    const blue = 2;
    const purple = 3;
    const magicsoul = 4;
    const stone_green = 5;
    const stone_blue = 6;
    const stone_purple = 7;

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
            'stone_green' => self::stone_green,
            'stone_blue' => self::stone_blue,
            'stone_purple' => self::stone_purple,
        );
    }
}

/**
 * tavern_draw message
 */
class Up_TavernDraw extends \ProtobufMessage
{
    /* Field index constants */
    const _DRAW_TYPE = 1;
    const _BOX_TYPE = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_DRAW_TYPE => array(
            'default' => Up_TavernDraw_DrawType::single, 
            'name' => '_draw_type',
            'required' => true,
            'type' => 5,
        ),
        self::_BOX_TYPE => array(
            'default' => Up_TavernDraw_BoxType::green, 
            'name' => '_box_type',
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
        $this->values[self::_DRAW_TYPE] = null;
        $this->values[self::_BOX_TYPE] = null;
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
     * Sets value of '_draw_type' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setDrawType($value)
    {
        return $this->set(self::_DRAW_TYPE, $value);
    }

    /**
     * Returns value of '_draw_type' property
     *
     * @return int
     */
    public function getDrawType()
    {
        return $this->get(self::_DRAW_TYPE);
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
}

/**
 * hero_evolve message
 */
class Up_HeroEvolve extends \ProtobufMessage
{
    /* Field index constants */
    const _HEROID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_HEROID => array(
            'name' => '_heroid',
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
 * enter_act_stage message
 */
class Up_EnterActStage extends \ProtobufMessage
{
    /* Field index constants */
    const _STAGE_GROUP = 1;
    const _STAGE = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_STAGE_GROUP => array(
            'name' => '_stage_group',
            'required' => true,
            'type' => 5,
        ),
        self::_STAGE => array(
            'name' => '_stage',
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
        $this->values[self::_STAGE_GROUP] = null;
        $this->values[self::_STAGE] = null;
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
     * Sets value of '_stage_group' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setStageGroup($value)
    {
        return $this->set(self::_STAGE_GROUP, $value);
    }

    /**
     * Returns value of '_stage_group' property
     *
     * @return int
     */
    public function getStageGroup()
    {
        return $this->get(self::_STAGE_GROUP);
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
}

/**
 * ladder message
 */
class Up_Ladder extends \ProtobufMessage
{
    /* Field index constants */
    const _OPEN_PANEL = 1;
    const _APPLY_OPPONENT = 2;
    const _START_BATTLE = 3;
    const _END_BATTLE = 4;
    const _SET_LINEUP = 5;
    const _QUERY_RECORDS = 6;
    const _QUERY_REPLAY = 7;
    const _QUERY_RANKBOARD = 8;
    const _QUERY_OPPO = 9;
    const _CLEAR_BATTLE_CD = 10;
    const _DRAW_RANK_REWARD = 11;
    const _BUY_BATTLE_CHANCE = 12;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_OPEN_PANEL => array(
            'name' => '_open_panel',
            'required' => false,
            'type' => 'Up_OpenPanel'
        ),
        self::_APPLY_OPPONENT => array(
            'name' => '_apply_opponent',
            'required' => false,
            'type' => 'Up_ApplyOpponent'
        ),
        self::_START_BATTLE => array(
            'name' => '_start_battle',
            'required' => false,
            'type' => 'Up_StartBattle'
        ),
        self::_END_BATTLE => array(
            'name' => '_end_battle',
            'required' => false,
            'type' => 'Up_EndBattle'
        ),
        self::_SET_LINEUP => array(
            'name' => '_set_lineup',
            'required' => false,
            'type' => 'Up_SetLineup'
        ),
        self::_QUERY_RECORDS => array(
            'name' => '_query_records',
            'required' => false,
            'type' => 'Up_QueryRecords'
        ),
        self::_QUERY_REPLAY => array(
            'name' => '_query_replay',
            'required' => false,
            'type' => 'Up_QueryReplay'
        ),
        self::_QUERY_RANKBOARD => array(
            'name' => '_query_rankboard',
            'required' => false,
            'type' => 'Up_QueryRankboard'
        ),
        self::_QUERY_OPPO => array(
            'name' => '_query_oppo',
            'required' => false,
            'type' => 'Up_QueryOppoInfo'
        ),
        self::_CLEAR_BATTLE_CD => array(
            'name' => '_clear_battle_cd',
            'required' => false,
            'type' => 'Up_ClearBattleCd'
        ),
        self::_DRAW_RANK_REWARD => array(
            'name' => '_draw_rank_reward',
            'required' => false,
            'type' => 'Up_DrawRankReward'
        ),
        self::_BUY_BATTLE_CHANCE => array(
            'name' => '_buy_battle_chance',
            'required' => false,
            'type' => 'Up_BuyBattleChance'
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
        $this->values[self::_APPLY_OPPONENT] = null;
        $this->values[self::_START_BATTLE] = null;
        $this->values[self::_END_BATTLE] = null;
        $this->values[self::_SET_LINEUP] = null;
        $this->values[self::_QUERY_RECORDS] = null;
        $this->values[self::_QUERY_REPLAY] = null;
        $this->values[self::_QUERY_RANKBOARD] = null;
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
     * @param Up_OpenPanel $value Property value
     *
     * @return null
     */
    public function setOpenPanel(Up_OpenPanel $value)
    {
        return $this->set(self::_OPEN_PANEL, $value);
    }

    /**
     * Returns value of '_open_panel' property
     *
     * @return Up_OpenPanel
     */
    public function getOpenPanel()
    {
        return $this->get(self::_OPEN_PANEL);
    }

    /**
     * Sets value of '_apply_opponent' property
     *
     * @param Up_ApplyOpponent $value Property value
     *
     * @return null
     */
    public function setApplyOpponent(Up_ApplyOpponent $value)
    {
        return $this->set(self::_APPLY_OPPONENT, $value);
    }

    /**
     * Returns value of '_apply_opponent' property
     *
     * @return Up_ApplyOpponent
     */
    public function getApplyOpponent()
    {
        return $this->get(self::_APPLY_OPPONENT);
    }

    /**
     * Sets value of '_start_battle' property
     *
     * @param Up_StartBattle $value Property value
     *
     * @return null
     */
    public function setStartBattle(Up_StartBattle $value)
    {
        return $this->set(self::_START_BATTLE, $value);
    }

    /**
     * Returns value of '_start_battle' property
     *
     * @return Up_StartBattle
     */
    public function getStartBattle()
    {
        return $this->get(self::_START_BATTLE);
    }

    /**
     * Sets value of '_end_battle' property
     *
     * @param Up_EndBattle $value Property value
     *
     * @return null
     */
    public function setEndBattle(Up_EndBattle $value)
    {
        return $this->set(self::_END_BATTLE, $value);
    }

    /**
     * Returns value of '_end_battle' property
     *
     * @return Up_EndBattle
     */
    public function getEndBattle()
    {
        return $this->get(self::_END_BATTLE);
    }

    /**
     * Sets value of '_set_lineup' property
     *
     * @param Up_SetLineup $value Property value
     *
     * @return null
     */
    public function setSetLineup(Up_SetLineup $value)
    {
        return $this->set(self::_SET_LINEUP, $value);
    }

    /**
     * Returns value of '_set_lineup' property
     *
     * @return Up_SetLineup
     */
    public function getSetLineup()
    {
        return $this->get(self::_SET_LINEUP);
    }

    /**
     * Sets value of '_query_records' property
     *
     * @param Up_QueryRecords $value Property value
     *
     * @return null
     */
    public function setQueryRecords(Up_QueryRecords $value)
    {
        return $this->set(self::_QUERY_RECORDS, $value);
    }

    /**
     * Returns value of '_query_records' property
     *
     * @return Up_QueryRecords
     */
    public function getQueryRecords()
    {
        return $this->get(self::_QUERY_RECORDS);
    }

    /**
     * Sets value of '_query_replay' property
     *
     * @param Up_QueryReplay $value Property value
     *
     * @return null
     */
    public function setQueryReplay(Up_QueryReplay $value)
    {
        return $this->set(self::_QUERY_REPLAY, $value);
    }

    /**
     * Returns value of '_query_replay' property
     *
     * @return Up_QueryReplay
     */
    public function getQueryReplay()
    {
        return $this->get(self::_QUERY_REPLAY);
    }

    /**
     * Sets value of '_query_rankboard' property
     *
     * @param Up_QueryRankboard $value Property value
     *
     * @return null
     */
    public function setQueryRankboard(Up_QueryRankboard $value)
    {
        return $this->set(self::_QUERY_RANKBOARD, $value);
    }

    /**
     * Returns value of '_query_rankboard' property
     *
     * @return Up_QueryRankboard
     */
    public function getQueryRankboard()
    {
        return $this->get(self::_QUERY_RANKBOARD);
    }

    /**
     * Sets value of '_query_oppo' property
     *
     * @param Up_QueryOppoInfo $value Property value
     *
     * @return null
     */
    public function setQueryOppo(Up_QueryOppoInfo $value)
    {
        return $this->set(self::_QUERY_OPPO, $value);
    }

    /**
     * Returns value of '_query_oppo' property
     *
     * @return Up_QueryOppoInfo
     */
    public function getQueryOppo()
    {
        return $this->get(self::_QUERY_OPPO);
    }

    /**
     * Sets value of '_clear_battle_cd' property
     *
     * @param Up_ClearBattleCd $value Property value
     *
     * @return null
     */
    public function setClearBattleCd(Up_ClearBattleCd $value)
    {
        return $this->set(self::_CLEAR_BATTLE_CD, $value);
    }

    /**
     * Returns value of '_clear_battle_cd' property
     *
     * @return Up_ClearBattleCd
     */
    public function getClearBattleCd()
    {
        return $this->get(self::_CLEAR_BATTLE_CD);
    }

    /**
     * Sets value of '_draw_rank_reward' property
     *
     * @param Up_DrawRankReward $value Property value
     *
     * @return null
     */
    public function setDrawRankReward(Up_DrawRankReward $value)
    {
        return $this->set(self::_DRAW_RANK_REWARD, $value);
    }

    /**
     * Returns value of '_draw_rank_reward' property
     *
     * @return Up_DrawRankReward
     */
    public function getDrawRankReward()
    {
        return $this->get(self::_DRAW_RANK_REWARD);
    }

    /**
     * Sets value of '_buy_battle_chance' property
     *
     * @param Up_BuyBattleChance $value Property value
     *
     * @return null
     */
    public function setBuyBattleChance(Up_BuyBattleChance $value)
    {
        return $this->set(self::_BUY_BATTLE_CHANCE, $value);
    }

    /**
     * Returns value of '_buy_battle_chance' property
     *
     * @return Up_BuyBattleChance
     */
    public function getBuyBattleChance()
    {
        return $this->get(self::_BUY_BATTLE_CHANCE);
    }
}

/**
 * open_panel message
 */
class Up_OpenPanel extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * apply_opponent message
 */
class Up_ApplyOpponent extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * start_battle message
 */
class Up_StartBattle extends \ProtobufMessage
{
    /* Field index constants */
    const _OPPO_USER_ID = 1;
    const _ATTACK_LINEUP = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_OPPO_USER_ID => array(
            'name' => '_oppo_user_id',
            'required' => true,
            'type' => 5,
        ),
        self::_ATTACK_LINEUP => array(
            'name' => '_attack_lineup',
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
        $this->values[self::_OPPO_USER_ID] = null;
        $this->values[self::_ATTACK_LINEUP] = array();
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
     * Sets value of '_oppo_user_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setOppoUserId($value)
    {
        return $this->set(self::_OPPO_USER_ID, $value);
    }

    /**
     * Returns value of '_oppo_user_id' property
     *
     * @return int
     */
    public function getOppoUserId()
    {
        return $this->get(self::_OPPO_USER_ID);
    }

    /**
     * Appends value to '_attack_lineup' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendAttackLineup($value)
    {
        return $this->append(self::_ATTACK_LINEUP, $value);
    }

    /**
     * Clears '_attack_lineup' list
     *
     * @return null
     */
    public function clearAttackLineup()
    {
        return $this->clear(self::_ATTACK_LINEUP);
    }

    /**
     * Returns '_attack_lineup' list
     *
     * @return int[]
     */
    public function getAttackLineup()
    {
        return $this->get(self::_ATTACK_LINEUP);
    }

    /**
     * Returns '_attack_lineup' iterator
     *
     * @return ArrayIterator
     */
    public function getAttackLineupIterator()
    {
        return new \ArrayIterator($this->get(self::_ATTACK_LINEUP));
    }

    /**
     * Returns element from '_attack_lineup' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getAttackLineupAt($offset)
    {
        return $this->get(self::_ATTACK_LINEUP, $offset);
    }

    /**
     * Returns count of '_attack_lineup' list
     *
     * @return int
     */
    public function getAttackLineupCount()
    {
        return $this->count(self::_ATTACK_LINEUP);
    }
}

/**
 * end_battle message
 */
class Up_EndBattle extends \ProtobufMessage
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
 * set_lineup message
 */
class Up_SetLineup extends \ProtobufMessage
{
    /* Field index constants */
    const _LINEUP = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_LINEUP => array(
            'name' => '_lineup',
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
        $this->values[self::_LINEUP] = array();
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
}

/**
 * query_records message
 */
class Up_QueryRecords extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * query_replay message
 */
class Up_QueryReplay extends \ProtobufMessage
{
    /* Field index constants */
    const _RECORD_INDEX = 1;
    const _RECORD_SVRID = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RECORD_INDEX => array(
            'name' => '_record_index',
            'required' => true,
            'type' => 5,
        ),
        self::_RECORD_SVRID => array(
            'name' => '_record_svrid',
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
        $this->values[self::_RECORD_INDEX] = null;
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
     * Sets value of '_record_index' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setRecordIndex($value)
    {
        return $this->set(self::_RECORD_INDEX, $value);
    }

    /**
     * Returns value of '_record_index' property
     *
     * @return int
     */
    public function getRecordIndex()
    {
        return $this->get(self::_RECORD_INDEX);
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
 * sync_skill_stren message
 */
class Up_SyncSkillStren extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * query_rankboard message
 */
class Up_QueryRankboard extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * query_oppo_info message
 */
class Up_QueryOppoInfo extends \ProtobufMessage
{
    /* Field index constants */
    const _OPPO_USER_ID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_OPPO_USER_ID => array(
            'name' => '_oppo_user_id',
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
        $this->values[self::_OPPO_USER_ID] = null;
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
     * Sets value of '_oppo_user_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setOppoUserId($value)
    {
        return $this->set(self::_OPPO_USER_ID, $value);
    }

    /**
     * Returns value of '_oppo_user_id' property
     *
     * @return int
     */
    public function getOppoUserId()
    {
        return $this->get(self::_OPPO_USER_ID);
    }
}

/**
 * clear_battle_cd message
 */
class Up_ClearBattleCd extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * draw_rank_reward message
 */
class Up_DrawRankReward extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * buy_battle_chance message
 */
class Up_BuyBattleChance extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * set_type enum embedded in set_name message
 */
final class Up_SetName_SetType
{
    const free = 0;
    const rmb = 1;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'free' => self::free,
            'rmb' => self::rmb,
        );
    }
}

/**
 * set_name message
 */
class Up_SetName extends \ProtobufMessage
{
    /* Field index constants */
    const _TYPE = 1;
    const _NAME = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TYPE => array(
            'name' => '_type',
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
        $this->values[self::_TYPE] = null;
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
 * set_avatar message
 */
class Up_SetAvatar extends \ProtobufMessage
{
    /* Field index constants */
    const _AVATAR = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
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
 * query_type enum embedded in query_data message
 */
final class Up_QueryData_QueryType
{
    const rmb = 1;
    const hero = 2;
    const recharge = 3;
    const monthcard = 4;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'rmb' => self::rmb,
            'hero' => self::hero,
            'recharge' => self::recharge,
            'monthcard' => self::monthcard,
        );
    }
}

/**
 * query_data message
 */
class Up_QueryData extends \ProtobufMessage
{
    /* Field index constants */
    const _TYPE = 1;
    const _QUERY_HEROES = 2;
    const _MONTH_CARD_ID = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TYPE => array(
            'name' => '_type',
            'repeated' => true,
            'type' => 5,
        ),
        self::_QUERY_HEROES => array(
            'name' => '_query_heroes',
            'repeated' => true,
            'type' => 5,
        ),
        self::_MONTH_CARD_ID => array(
            'name' => '_month_card_id',
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
        $this->values[self::_TYPE] = array();
        $this->values[self::_QUERY_HEROES] = array();
        $this->values[self::_MONTH_CARD_ID] = array();
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
     * Appends value to '_type' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendType($value)
    {
        return $this->append(self::_TYPE, $value);
    }

    /**
     * Clears '_type' list
     *
     * @return null
     */
    public function clearType()
    {
        return $this->clear(self::_TYPE);
    }

    /**
     * Returns '_type' list
     *
     * @return int[]
     */
    public function getType()
    {
        return $this->get(self::_TYPE);
    }

    /**
     * Returns '_type' iterator
     *
     * @return ArrayIterator
     */
    public function getTypeIterator()
    {
        return new \ArrayIterator($this->get(self::_TYPE));
    }

    /**
     * Returns element from '_type' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getTypeAt($offset)
    {
        return $this->get(self::_TYPE, $offset);
    }

    /**
     * Returns count of '_type' list
     *
     * @return int
     */
    public function getTypeCount()
    {
        return $this->count(self::_TYPE);
    }

    /**
     * Appends value to '_query_heroes' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendQueryHeroes($value)
    {
        return $this->append(self::_QUERY_HEROES, $value);
    }

    /**
     * Clears '_query_heroes' list
     *
     * @return null
     */
    public function clearQueryHeroes()
    {
        return $this->clear(self::_QUERY_HEROES);
    }

    /**
     * Returns '_query_heroes' list
     *
     * @return int[]
     */
    public function getQueryHeroes()
    {
        return $this->get(self::_QUERY_HEROES);
    }

    /**
     * Returns '_query_heroes' iterator
     *
     * @return ArrayIterator
     */
    public function getQueryHeroesIterator()
    {
        return new \ArrayIterator($this->get(self::_QUERY_HEROES));
    }

    /**
     * Returns element from '_query_heroes' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getQueryHeroesAt($offset)
    {
        return $this->get(self::_QUERY_HEROES, $offset);
    }

    /**
     * Returns count of '_query_heroes' list
     *
     * @return int
     */
    public function getQueryHeroesCount()
    {
        return $this->count(self::_QUERY_HEROES);
    }

    /**
     * Appends value to '_month_card_id' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendMonthCardId($value)
    {
        return $this->append(self::_MONTH_CARD_ID, $value);
    }

    /**
     * Clears '_month_card_id' list
     *
     * @return null
     */
    public function clearMonthCardId()
    {
        return $this->clear(self::_MONTH_CARD_ID);
    }

    /**
     * Returns '_month_card_id' list
     *
     * @return int[]
     */
    public function getMonthCardId()
    {
        return $this->get(self::_MONTH_CARD_ID);
    }

    /**
     * Returns '_month_card_id' iterator
     *
     * @return ArrayIterator
     */
    public function getMonthCardIdIterator()
    {
        return new \ArrayIterator($this->get(self::_MONTH_CARD_ID));
    }

    /**
     * Returns element from '_month_card_id' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getMonthCardIdAt($offset)
    {
        return $this->get(self::_MONTH_CARD_ID, $offset);
    }

    /**
     * Returns count of '_month_card_id' list
     *
     * @return int
     */
    public function getMonthCardIdCount()
    {
        return $this->count(self::_MONTH_CARD_ID);
    }
}

/**
 * midas message
 */
class Up_Midas extends \ProtobufMessage
{
    /* Field index constants */
    const _TIMES = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
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
 * open_shop message
 */
class Up_OpenShop extends \ProtobufMessage
{
    /* Field index constants */
    const _SHOPID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_SHOPID => array(
            'name' => '_shopid',
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
        $this->values[self::_SHOPID] = null;
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
     * Sets value of '_shopid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setShopid($value)
    {
        return $this->set(self::_SHOPID, $value);
    }

    /**
     * Returns value of '_shopid' property
     *
     * @return int
     */
    public function getShopid()
    {
        return $this->get(self::_SHOPID);
    }
}

/**
 * charge message
 */
class Up_Charge extends \ProtobufMessage
{
    /* Field index constants */
    const _PLATID = 1;
    const _CHARGEID = 2;
    const _EXTRADATA = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_PLATID => array(
            'default' => Up_PlatformType::self, 
            'name' => '_platid',
            'required' => true,
            'type' => 5,
        ),
        self::_CHARGEID => array(
            'name' => '_chargeid',
            'required' => true,
            'type' => 5,
        ),
        self::_EXTRADATA => array(
            'name' => '_extradata',
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
        $this->values[self::_PLATID] = null;
        $this->values[self::_CHARGEID] = null;
        $this->values[self::_EXTRADATA] = null;
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
     * Sets value of '_platid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setPlatid($value)
    {
        return $this->set(self::_PLATID, $value);
    }

    /**
     * Returns value of '_platid' property
     *
     * @return int
     */
    public function getPlatid()
    {
        return $this->get(self::_PLATID);
    }

    /**
     * Sets value of '_chargeid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setChargeid($value)
    {
        return $this->set(self::_CHARGEID, $value);
    }

    /**
     * Returns value of '_chargeid' property
     *
     * @return int
     */
    public function getChargeid()
    {
        return $this->get(self::_CHARGEID);
    }

    /**
     * Sets value of '_extradata' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setExtradata($value)
    {
        return $this->set(self::_EXTRADATA, $value);
    }

    /**
     * Returns value of '_extradata' property
     *
     * @return string
     */
    public function getExtradata()
    {
        return $this->get(self::_EXTRADATA);
    }
}

/**
 * status enum embedded in ask_daily_login message
 */
final class Up_AskDailyLogin_Status
{
    const all = 1;
    const common = 2;
    const vip = 3;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'all' => self::all,
            'common' => self::common,
            'vip' => self::vip,
        );
    }
}

/**
 * ask_daily_login message
 */
class Up_AskDailyLogin extends \ProtobufMessage
{
    /* Field index constants */
    const _STATUS = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_STATUS => array(
            'name' => '_status',
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
}

/**
 * tbc message
 */
class Up_Tbc extends \ProtobufMessage
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
            'type' => 'Up_TbcOpenPanel'
        ),
        self::_QUERY_OPPO => array(
            'name' => '_query_oppo',
            'required' => false,
            'type' => 'Up_TbcQueryOppo'
        ),
        self::_START_BAT => array(
            'name' => '_start_bat',
            'required' => false,
            'type' => 'Up_TbcStartBattle'
        ),
        self::_END_BAT => array(
            'name' => '_end_bat',
            'required' => false,
            'type' => 'Up_TbcEndBattle'
        ),
        self::_RESET => array(
            'name' => '_reset',
            'required' => false,
            'type' => 'Up_TbcReset'
        ),
        self::_DRAW_REWARD => array(
            'name' => '_draw_reward',
            'required' => false,
            'type' => 'Up_TbcDrawReward'
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
     * @param Up_TbcOpenPanel $value Property value
     *
     * @return null
     */
    public function setOpenPanel(Up_TbcOpenPanel $value)
    {
        return $this->set(self::_OPEN_PANEL, $value);
    }

    /**
     * Returns value of '_open_panel' property
     *
     * @return Up_TbcOpenPanel
     */
    public function getOpenPanel()
    {
        return $this->get(self::_OPEN_PANEL);
    }

    /**
     * Sets value of '_query_oppo' property
     *
     * @param Up_TbcQueryOppo $value Property value
     *
     * @return null
     */
    public function setQueryOppo(Up_TbcQueryOppo $value)
    {
        return $this->set(self::_QUERY_OPPO, $value);
    }

    /**
     * Returns value of '_query_oppo' property
     *
     * @return Up_TbcQueryOppo
     */
    public function getQueryOppo()
    {
        return $this->get(self::_QUERY_OPPO);
    }

    /**
     * Sets value of '_start_bat' property
     *
     * @param Up_TbcStartBattle $value Property value
     *
     * @return null
     */
    public function setStartBat(Up_TbcStartBattle $value)
    {
        return $this->set(self::_START_BAT, $value);
    }

    /**
     * Returns value of '_start_bat' property
     *
     * @return Up_TbcStartBattle
     */
    public function getStartBat()
    {
        return $this->get(self::_START_BAT);
    }

    /**
     * Sets value of '_end_bat' property
     *
     * @param Up_TbcEndBattle $value Property value
     *
     * @return null
     */
    public function setEndBat(Up_TbcEndBattle $value)
    {
        return $this->set(self::_END_BAT, $value);
    }

    /**
     * Returns value of '_end_bat' property
     *
     * @return Up_TbcEndBattle
     */
    public function getEndBat()
    {
        return $this->get(self::_END_BAT);
    }

    /**
     * Sets value of '_reset' property
     *
     * @param Up_TbcReset $value Property value
     *
     * @return null
     */
    public function setReset(Up_TbcReset $value)
    {
        return $this->set(self::_RESET, $value);
    }

    /**
     * Returns value of '_reset' property
     *
     * @return Up_TbcReset
     */
    public function getReset()
    {
        return $this->get(self::_RESET);
    }

    /**
     * Sets value of '_draw_reward' property
     *
     * @param Up_TbcDrawReward $value Property value
     *
     * @return null
     */
    public function setDrawReward(Up_TbcDrawReward $value)
    {
        return $this->set(self::_DRAW_REWARD, $value);
    }

    /**
     * Returns value of '_draw_reward' property
     *
     * @return Up_TbcDrawReward
     */
    public function getDrawReward()
    {
        return $this->get(self::_DRAW_REWARD);
    }
}

/**
 * tbc_open_panel message
 */
class Up_TbcOpenPanel extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * tbc_query_oppo message
 */
class Up_TbcQueryOppo extends \ProtobufMessage
{
    /* Field index constants */
    const _STAGE_ID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_STAGE_ID => array(
            'name' => '_stage_id',
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
        $this->values[self::_STAGE_ID] = null;
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
}

/**
 * tbc_start_battle message
 */
class Up_TbcStartBattle extends \ProtobufMessage
{
    /* Field index constants */
    const _HEROIDS = 1;
    const _USE_HIRE = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_HEROIDS => array(
            'name' => '_heroids',
            'repeated' => true,
            'type' => 5,
        ),
        self::_USE_HIRE => array(
            'name' => '_use_hire',
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
        $this->values[self::_HEROIDS] = array();
        $this->values[self::_USE_HIRE] = null;
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
     * Appends value to '_heroids' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendHeroids($value)
    {
        return $this->append(self::_HEROIDS, $value);
    }

    /**
     * Clears '_heroids' list
     *
     * @return null
     */
    public function clearHeroids()
    {
        return $this->clear(self::_HEROIDS);
    }

    /**
     * Returns '_heroids' list
     *
     * @return int[]
     */
    public function getHeroids()
    {
        return $this->get(self::_HEROIDS);
    }

    /**
     * Returns '_heroids' iterator
     *
     * @return ArrayIterator
     */
    public function getHeroidsIterator()
    {
        return new \ArrayIterator($this->get(self::_HEROIDS));
    }

    /**
     * Returns element from '_heroids' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getHeroidsAt($offset)
    {
        return $this->get(self::_HEROIDS, $offset);
    }

    /**
     * Returns count of '_heroids' list
     *
     * @return int
     */
    public function getHeroidsCount()
    {
        return $this->count(self::_HEROIDS);
    }

    /**
     * Sets value of '_use_hire' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setUseHire($value)
    {
        return $this->set(self::_USE_HIRE, $value);
    }

    /**
     * Returns value of '_use_hire' property
     *
     * @return int
     */
    public function getUseHire()
    {
        return $this->get(self::_USE_HIRE);
    }
}

/**
 * tbc_hero message
 */
class Up_TbcHero extends \ProtobufMessage
{
    /* Field index constants */
    const _HEROID = 1;
    const _HP_PERC = 2;
    const _MP_PERC = 3;
    const _CUSTOM_DATA = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_HEROID => array(
            'name' => '_heroid',
            'required' => true,
            'type' => 5,
        ),
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
        $this->values[self::_HEROID] = null;
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
 * tbc_end_battle message
 */
class Up_TbcEndBattle extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _SELF_HEROES = 2;
    const _OPPO_HEROES = 3;
    const _OPRATIONS = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Up_BattleResult::victory, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_SELF_HEROES => array(
            'name' => '_self_heroes',
            'repeated' => true,
            'type' => 'Up_TbcHero'
        ),
        self::_OPPO_HEROES => array(
            'name' => '_oppo_heroes',
            'repeated' => true,
            'type' => 'Up_TbcHero'
        ),
        self::_OPRATIONS => array(
            'name' => '_oprations',
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
        $this->values[self::_SELF_HEROES] = array();
        $this->values[self::_OPPO_HEROES] = array();
        $this->values[self::_OPRATIONS] = array();
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
     * Appends value to '_self_heroes' list
     *
     * @param Up_TbcHero $value Value to append
     *
     * @return null
     */
    public function appendSelfHeroes(Up_TbcHero $value)
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
     * @return Up_TbcHero[]
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
     * @return Up_TbcHero
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
     * Appends value to '_oppo_heroes' list
     *
     * @param Up_TbcHero $value Value to append
     *
     * @return null
     */
    public function appendOppoHeroes(Up_TbcHero $value)
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
     * @return Up_TbcHero[]
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
     * @return Up_TbcHero
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
     * Appends value to '_oprations' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendOprations($value)
    {
        return $this->append(self::_OPRATIONS, $value);
    }

    /**
     * Clears '_oprations' list
     *
     * @return null
     */
    public function clearOprations()
    {
        return $this->clear(self::_OPRATIONS);
    }

    /**
     * Returns '_oprations' list
     *
     * @return int[]
     */
    public function getOprations()
    {
        return $this->get(self::_OPRATIONS);
    }

    /**
     * Returns '_oprations' iterator
     *
     * @return ArrayIterator
     */
    public function getOprationsIterator()
    {
        return new \ArrayIterator($this->get(self::_OPRATIONS));
    }

    /**
     * Returns element from '_oprations' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getOprationsAt($offset)
    {
        return $this->get(self::_OPRATIONS, $offset);
    }

    /**
     * Returns count of '_oprations' list
     *
     * @return int
     */
    public function getOprationsCount()
    {
        return $this->count(self::_OPRATIONS);
    }
}

/**
 * tbc_reset message
 */
class Up_TbcReset extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * tbc_draw_reward message
 */
class Up_TbcDrawReward extends \ProtobufMessage
{
    /* Field index constants */
    const _STAGE_ID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_STAGE_ID => array(
            'name' => '_stage_id',
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
        $this->values[self::_STAGE_ID] = null;
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
}

/**
 * get_maillist message
 */
class Up_GetMaillist extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * read_mail message
 */
class Up_ReadMail extends \ProtobufMessage
{
    /* Field index constants */
    const _ID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ID => array(
            'name' => '_id',
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
}

/**
 * get_svr_time message
 */
class Up_GetSvrTime extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * get_vip_gift message
 */
class Up_GetVipGift extends \ProtobufMessage
{
    /* Field index constants */
    const _VIP = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_VIP => array(
            'name' => '_vip',
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
        $this->values[self::_VIP] = null;
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
}

/**
 * chat message
 */
class Up_Chat extends \ProtobufMessage
{
    /* Field index constants */
    const _SAY = 1;
    const _FRESH = 2;
    const _FETCH = 3;
    const _CHAT_ADD_BL = 4;
    const _CHAT_DEL_BL = 5;
    const _CHAT_FETCH_BL = 6;
    const _CHAT_BROAD_SAY = 7;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_SAY => array(
            'name' => '_say',
            'required' => false,
            'type' => 'Up_ChatSay'
        ),
        self::_FRESH => array(
            'name' => '_fresh',
            'required' => false,
            'type' => 'Up_ChatFresh'
        ),
        self::_FETCH => array(
            'name' => '_fetch',
            'required' => false,
            'type' => 'Up_ChatFetch'
        ),
        self::_CHAT_ADD_BL => array(
            'name' => '_chat_add_bl',
            'required' => false,
            'type' => 'Up_ChatAddBl'
        ),
        self::_CHAT_DEL_BL => array(
            'name' => '_chat_del_bl',
            'required' => false,
            'type' => 'Up_ChatDelBl'
        ),
        self::_CHAT_FETCH_BL => array(
            'name' => '_chat_fetch_bl',
            'required' => false,
            'type' => 'Up_ChatFetchBl'
        ),
        self::_CHAT_BROAD_SAY => array(
            'name' => '_chat_broad_say',
            'required' => false,
            'type' => 'Up_ChatBroadSay'
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
        $this->values[self::_CHAT_FETCH_BL] = null;
        $this->values[self::_CHAT_BROAD_SAY] = null;
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
     * @param Up_ChatSay $value Property value
     *
     * @return null
     */
    public function setSay(Up_ChatSay $value)
    {
        return $this->set(self::_SAY, $value);
    }

    /**
     * Returns value of '_say' property
     *
     * @return Up_ChatSay
     */
    public function getSay()
    {
        return $this->get(self::_SAY);
    }

    /**
     * Sets value of '_fresh' property
     *
     * @param Up_ChatFresh $value Property value
     *
     * @return null
     */
    public function setFresh(Up_ChatFresh $value)
    {
        return $this->set(self::_FRESH, $value);
    }

    /**
     * Returns value of '_fresh' property
     *
     * @return Up_ChatFresh
     */
    public function getFresh()
    {
        return $this->get(self::_FRESH);
    }

    /**
     * Sets value of '_fetch' property
     *
     * @param Up_ChatFetch $value Property value
     *
     * @return null
     */
    public function setFetch(Up_ChatFetch $value)
    {
        return $this->set(self::_FETCH, $value);
    }

    /**
     * Returns value of '_fetch' property
     *
     * @return Up_ChatFetch
     */
    public function getFetch()
    {
        return $this->get(self::_FETCH);
    }

    /**
     * Sets value of '_chat_add_bl' property
     *
     * @param Up_ChatAddBl $value Property value
     *
     * @return null
     */
    public function setChatAddBl(Up_ChatAddBl $value)
    {
        return $this->set(self::_CHAT_ADD_BL, $value);
    }

    /**
     * Returns value of '_chat_add_bl' property
     *
     * @return Up_ChatAddBl
     */
    public function getChatAddBl()
    {
        return $this->get(self::_CHAT_ADD_BL);
    }

    /**
     * Sets value of '_chat_del_bl' property
     *
     * @param Up_ChatDelBl $value Property value
     *
     * @return null
     */
    public function setChatDelBl(Up_ChatDelBl $value)
    {
        return $this->set(self::_CHAT_DEL_BL, $value);
    }

    /**
     * Returns value of '_chat_del_bl' property
     *
     * @return Up_ChatDelBl
     */
    public function getChatDelBl()
    {
        return $this->get(self::_CHAT_DEL_BL);
    }

    /**
     * Sets value of '_chat_fetch_bl' property
     *
     * @param Up_ChatFetchBl $value Property value
     *
     * @return null
     */
    public function setChatFetchBl(Up_ChatFetchBl $value)
    {
        return $this->set(self::_CHAT_FETCH_BL, $value);
    }

    /**
     * Returns value of '_chat_fetch_bl' property
     *
     * @return Up_ChatFetchBl
     */
    public function getChatFetchBl()
    {
        return $this->get(self::_CHAT_FETCH_BL);
    }

    /**
     * Sets value of '_chat_broad_say' property
     *
     * @param Up_ChatBroadSay $value Property value
     *
     * @return null
     */
    public function setChatBroadSay(Up_ChatBroadSay $value)
    {
        return $this->set(self::_CHAT_BROAD_SAY, $value);
    }

    /**
     * Returns value of '_chat_broad_say' property
     *
     * @return Up_ChatBroadSay
     */
    public function getChatBroadSay()
    {
        return $this->get(self::_CHAT_BROAD_SAY);
    }
}

/**
 * chat_broad_say message
 */
class Up_ChatBroadSay extends \ProtobufMessage
{
    /* Field index constants */
    const _CHANNEL = 1;
    const _TARGET_IDS = 2;
    const _CONTENT_TYPE = 3;
    const _CONTENT = 4;
    const _ACCESSORY = 5;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_CHANNEL => array(
            'name' => '_channel',
            'required' => false,
            'type' => 5,
        ),
        self::_TARGET_IDS => array(
            'name' => '_target_ids',
            'repeated' => true,
            'type' => 5,
        ),
        self::_CONTENT_TYPE => array(
            'name' => '_content_type',
            'required' => false,
            'type' => 5,
        ),
        self::_CONTENT => array(
            'name' => '_content',
            'required' => false,
            'type' => 7,
        ),
        self::_ACCESSORY => array(
            'name' => '_accessory',
            'required' => false,
            'type' => 'Up_ChatAcc'
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
        $this->values[self::_TARGET_IDS] = array();
        $this->values[self::_CONTENT_TYPE] = null;
        $this->values[self::_CONTENT] = null;
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
     * Appends value to '_target_ids' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendTargetIds($value)
    {
        return $this->append(self::_TARGET_IDS, $value);
    }

    /**
     * Clears '_target_ids' list
     *
     * @return null
     */
    public function clearTargetIds()
    {
        return $this->clear(self::_TARGET_IDS);
    }

    /**
     * Returns '_target_ids' list
     *
     * @return int[]
     */
    public function getTargetIds()
    {
        return $this->get(self::_TARGET_IDS);
    }

    /**
     * Returns '_target_ids' iterator
     *
     * @return ArrayIterator
     */
    public function getTargetIdsIterator()
    {
        return new \ArrayIterator($this->get(self::_TARGET_IDS));
    }

    /**
     * Returns element from '_target_ids' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getTargetIdsAt($offset)
    {
        return $this->get(self::_TARGET_IDS, $offset);
    }

    /**
     * Returns count of '_target_ids' list
     *
     * @return int
     */
    public function getTargetIdsCount()
    {
        return $this->count(self::_TARGET_IDS);
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

    /**
     * Sets value of '_accessory' property
     *
     * @param Up_ChatAcc $value Property value
     *
     * @return null
     */
    public function setAccessory(Up_ChatAcc $value)
    {
        return $this->set(self::_ACCESSORY, $value);
    }

    /**
     * Returns value of '_accessory' property
     *
     * @return Up_ChatAcc
     */
    public function getAccessory()
    {
        return $this->get(self::_ACCESSORY);
    }
}

/**
 * chat_fetch_bl message
 */
class Up_ChatFetchBl extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * chat_say message
 */
class Up_ChatSay extends \ProtobufMessage
{
    /* Field index constants */
    const _CHANNEL = 1;
    const _TARGET_ID = 2;
    const _CONTENT_TYPE = 3;
    const _CONTENT = 4;
    const _ACCESSORY = 5;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_CHANNEL => array(
            'default' => Up_ChatChannel::world_channel, 
            'name' => '_channel',
            'required' => true,
            'type' => 5,
        ),
        self::_TARGET_ID => array(
            'name' => '_target_id',
            'required' => false,
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
        self::_ACCESSORY => array(
            'name' => '_accessory',
            'required' => false,
            'type' => 'Up_ChatAcc'
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
        $this->values[self::_TARGET_ID] = null;
        $this->values[self::_CONTENT_TYPE] = null;
        $this->values[self::_CONTENT] = null;
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
     * Sets value of '_target_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setTargetId($value)
    {
        return $this->set(self::_TARGET_ID, $value);
    }

    /**
     * Returns value of '_target_id' property
     *
     * @return int
     */
    public function getTargetId()
    {
        return $this->get(self::_TARGET_ID);
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

    /**
     * Sets value of '_accessory' property
     *
     * @param Up_ChatAcc $value Property value
     *
     * @return null
     */
    public function setAccessory(Up_ChatAcc $value)
    {
        return $this->set(self::_ACCESSORY, $value);
    }

    /**
     * Returns value of '_accessory' property
     *
     * @return Up_ChatAcc
     */
    public function getAccessory()
    {
        return $this->get(self::_ACCESSORY);
    }
}

/**
 * chat_acc_t enum embedded in chat_acc message
 */
final class Up_ChatAcc_ChatAccT
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
class Up_ChatAcc extends \ProtobufMessage
{
    /* Field index constants */
    const _TYPE = 1;
    const _BINARY = 2;
    const _RECORD_ID = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TYPE => array(
            'default' => Up_ChatAcc_ChatAccT::binary, 
            'name' => '_type',
            'required' => true,
            'type' => 5,
        ),
        self::_BINARY => array(
            'name' => '_binary',
            'required' => false,
            'type' => 7,
        ),
        self::_RECORD_ID => array(
            'name' => '_record_id',
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
        $this->values[self::_BINARY] = null;
        $this->values[self::_RECORD_ID] = null;
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
}

/**
 * chat_fresh message
 */
class Up_ChatFresh extends \ProtobufMessage
{
    /* Field index constants */
    const _CHANNEL = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_CHANNEL => array(
            'default' => Up_ChatChannel::world_channel, 
            'name' => '_channel',
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
        $this->values[self::_CHANNEL] = null;
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
}

/**
 * chat_fetch message
 */
class Up_ChatFetch extends \ProtobufMessage
{
    /* Field index constants */
    const _CHANNEL = 1;
    const _CHAT_ID = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_CHANNEL => array(
            'default' => Up_ChatChannel::world_channel, 
            'name' => '_channel',
            'required' => true,
            'type' => 5,
        ),
        self::_CHAT_ID => array(
            'name' => '_chat_id',
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
        $this->values[self::_CHANNEL] = null;
        $this->values[self::_CHAT_ID] = null;
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
}

/**
 * chat_add_bl message
 */
class Up_ChatAddBl extends \ProtobufMessage
{
    /* Field index constants */
    const _UID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_UID => array(
            'name' => '_uid',
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
}

/**
 * chat_del_bl message
 */
class Up_ChatDelBl extends \ProtobufMessage
{
    /* Field index constants */
    const _UID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_UID => array(
            'name' => '_uid',
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
}

/**
 * guild message
 */
class Up_Guild extends \ProtobufMessage
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
    const _OPEN_PANNEL = 11;
    const _SET_JOB = 12;
    const _ADD_HIRE = 13;
    const _DEL_HIRE = 14;
    const _QUERY_HIRES = 15;
    const _HIRE_HERO = 16;
    const _WORSHIP_REQ = 17;
    const _WORSHIP_WITHDRAW = 18;
    const _QUERY_HH_DETAIL = 19;
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
    const _GUILD_QUERY_MEMBER = 34;
    const _GUILD_STAGE_RANK = 35;
    const _SET_JUMP = 36;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_CREATE => array(
            'name' => '_create',
            'required' => false,
            'type' => 'Up_GuildCreate'
        ),
        self::_DISMISS => array(
            'name' => '_dismiss',
            'required' => false,
            'type' => 'Up_GuildDismiss'
        ),
        self::_LIST => array(
            'name' => '_list',
            'required' => false,
            'type' => 'Up_GuildList'
        ),
        self::_SEARCH => array(
            'name' => '_search',
            'required' => false,
            'type' => 'Up_GuildSearch'
        ),
        self::_JOIN => array(
            'name' => '_join',
            'required' => false,
            'type' => 'Up_GuildJoin'
        ),
        self::_JOIN_CONFIRM => array(
            'name' => '_join_confirm',
            'required' => false,
            'type' => 'Up_GuildJoinConfirm'
        ),
        self::_LEAVE => array(
            'name' => '_leave',
            'required' => false,
            'type' => 'Up_GuildLeave'
        ),
        self::_KICK => array(
            'name' => '_kick',
            'required' => false,
            'type' => 'Up_GuildKick'
        ),
        self::_SET => array(
            'name' => '_set',
            'required' => false,
            'type' => 'Up_GuildSet'
        ),
        self::_QUERY => array(
            'name' => '_query',
            'required' => false,
            'type' => 'Up_GuildQuery'
        ),
        self::_OPEN_PANNEL => array(
            'name' => '_open_pannel',
            'required' => false,
            'type' => 'Up_GuildOpenPannel'
        ),
        self::_SET_JOB => array(
            'name' => '_set_job',
            'required' => false,
            'type' => 'Up_GuildSetJob'
        ),
        self::_ADD_HIRE => array(
            'name' => '_add_hire',
            'required' => false,
            'type' => 'Up_GuildAddHire'
        ),
        self::_DEL_HIRE => array(
            'name' => '_del_hire',
            'required' => false,
            'type' => 'Up_GuildDelHire'
        ),
        self::_QUERY_HIRES => array(
            'name' => '_query_hires',
            'required' => false,
            'type' => 'Up_GuildQueryHires'
        ),
        self::_HIRE_HERO => array(
            'name' => '_hire_hero',
            'required' => false,
            'type' => 'Up_GuildHireHero'
        ),
        self::_WORSHIP_REQ => array(
            'name' => '_worship_req',
            'required' => false,
            'type' => 'Up_GuildWorshipReq'
        ),
        self::_WORSHIP_WITHDRAW => array(
            'name' => '_worship_withdraw',
            'required' => false,
            'type' => 'Up_GuildWorshipWithdraw'
        ),
        self::_QUERY_HH_DETAIL => array(
            'name' => '_query_hh_detail',
            'required' => false,
            'type' => 'Up_GuildQureyHhDetail'
        ),
        self::_INSTANCE_QUERY => array(
            'name' => '_instance_query',
            'required' => false,
            'type' => 'Up_GuildInstanceQuery'
        ),
        self::_INSTANCE_DETAIL => array(
            'name' => '_instance_detail',
            'required' => false,
            'type' => 'Up_GuildInstanceDetail'
        ),
        self::_INSTANCE_START => array(
            'name' => '_instance_start',
            'required' => false,
            'type' => 'Up_GuildInstanceStart'
        ),
        self::_INSTANCE_END => array(
            'name' => '_instance_end',
            'required' => false,
            'type' => 'Up_GuildInstanceEnd'
        ),
        self::_INSTANCE_DROP => array(
            'name' => '_instance_drop',
            'required' => false,
            'type' => 'Up_GuildInstanceDrop'
        ),
        self::_INSTANCE_OPEN => array(
            'name' => '_instance_open',
            'required' => false,
            'type' => 'Up_GuildInstanceOpen'
        ),
        self::_INSTANCE_APPLY => array(
            'name' => '_instance_apply',
            'required' => false,
            'type' => 'Up_GuildInstanceApply'
        ),
        self::_DROP_INFO => array(
            'name' => '_drop_info',
            'required' => false,
            'type' => 'Up_GuildDropInfo'
        ),
        self::_DROP_GIVE => array(
            'name' => '_drop_give',
            'required' => false,
            'type' => 'Up_GuildDropGive'
        ),
        self::_INSTANCE_DAMAGE => array(
            'name' => '_instance_damage',
            'required' => false,
            'type' => 'Up_GuildInstanceDamage'
        ),
        self::_ITEMS_HISTORY => array(
            'name' => '_items_history',
            'required' => false,
            'type' => 'Up_GuildItemsHistory'
        ),
        self::_GUILD_JUMP => array(
            'name' => '_guild_jump',
            'required' => false,
            'type' => 'Up_GuildJump'
        ),
        self::_GUILD_APP_QUEUE => array(
            'name' => '_guild_app_queue',
            'required' => false,
            'type' => 'Up_GuildAppQueue'
        ),
        self::_INSTANCE_PREPARE => array(
            'name' => '_instance_prepare',
            'required' => false,
            'type' => 'Up_GuildPrepareInstance'
        ),
        self::_GUILD_QUERY_MEMBER => array(
            'name' => '_guild_query_member',
            'required' => false,
            'type' => 'Up_GuildQueryMember'
        ),
        self::_GUILD_STAGE_RANK => array(
            'name' => '_guild_stage_rank',
            'required' => false,
            'type' => 'Up_GuildStageRank'
        ),
        self::_SET_JUMP => array(
            'name' => '_set_jump',
            'required' => false,
            'type' => 'Up_GuildSetJump'
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
        $this->values[self::_OPEN_PANNEL] = null;
        $this->values[self::_SET_JOB] = null;
        $this->values[self::_ADD_HIRE] = null;
        $this->values[self::_DEL_HIRE] = null;
        $this->values[self::_QUERY_HIRES] = null;
        $this->values[self::_HIRE_HERO] = null;
        $this->values[self::_WORSHIP_REQ] = null;
        $this->values[self::_WORSHIP_WITHDRAW] = null;
        $this->values[self::_QUERY_HH_DETAIL] = null;
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
        $this->values[self::_GUILD_QUERY_MEMBER] = null;
        $this->values[self::_GUILD_STAGE_RANK] = null;
        $this->values[self::_SET_JUMP] = null;
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
     * @param Up_GuildCreate $value Property value
     *
     * @return null
     */
    public function setCreate(Up_GuildCreate $value)
    {
        return $this->set(self::_CREATE, $value);
    }

    /**
     * Returns value of '_create' property
     *
     * @return Up_GuildCreate
     */
    public function getCreate()
    {
        return $this->get(self::_CREATE);
    }

    /**
     * Sets value of '_dismiss' property
     *
     * @param Up_GuildDismiss $value Property value
     *
     * @return null
     */
    public function setDismiss(Up_GuildDismiss $value)
    {
        return $this->set(self::_DISMISS, $value);
    }

    /**
     * Returns value of '_dismiss' property
     *
     * @return Up_GuildDismiss
     */
    public function getDismiss()
    {
        return $this->get(self::_DISMISS);
    }

    /**
     * Sets value of '_list' property
     *
     * @param Up_GuildList $value Property value
     *
     * @return null
     */
    public function setList(Up_GuildList $value)
    {
        return $this->set(self::_LIST, $value);
    }

    /**
     * Returns value of '_list' property
     *
     * @return Up_GuildList
     */
    public function getList()
    {
        return $this->get(self::_LIST);
    }

    /**
     * Sets value of '_search' property
     *
     * @param Up_GuildSearch $value Property value
     *
     * @return null
     */
    public function setSearch(Up_GuildSearch $value)
    {
        return $this->set(self::_SEARCH, $value);
    }

    /**
     * Returns value of '_search' property
     *
     * @return Up_GuildSearch
     */
    public function getSearch()
    {
        return $this->get(self::_SEARCH);
    }

    /**
     * Sets value of '_join' property
     *
     * @param Up_GuildJoin $value Property value
     *
     * @return null
     */
    public function setJoin(Up_GuildJoin $value)
    {
        return $this->set(self::_JOIN, $value);
    }

    /**
     * Returns value of '_join' property
     *
     * @return Up_GuildJoin
     */
    public function getJoin()
    {
        return $this->get(self::_JOIN);
    }

    /**
     * Sets value of '_join_confirm' property
     *
     * @param Up_GuildJoinConfirm $value Property value
     *
     * @return null
     */
    public function setJoinConfirm(Up_GuildJoinConfirm $value)
    {
        return $this->set(self::_JOIN_CONFIRM, $value);
    }

    /**
     * Returns value of '_join_confirm' property
     *
     * @return Up_GuildJoinConfirm
     */
    public function getJoinConfirm()
    {
        return $this->get(self::_JOIN_CONFIRM);
    }

    /**
     * Sets value of '_leave' property
     *
     * @param Up_GuildLeave $value Property value
     *
     * @return null
     */
    public function setLeave(Up_GuildLeave $value)
    {
        return $this->set(self::_LEAVE, $value);
    }

    /**
     * Returns value of '_leave' property
     *
     * @return Up_GuildLeave
     */
    public function getLeave()
    {
        return $this->get(self::_LEAVE);
    }

    /**
     * Sets value of '_kick' property
     *
     * @param Up_GuildKick $value Property value
     *
     * @return null
     */
    public function setKick(Up_GuildKick $value)
    {
        return $this->set(self::_KICK, $value);
    }

    /**
     * Returns value of '_kick' property
     *
     * @return Up_GuildKick
     */
    public function getKick()
    {
        return $this->get(self::_KICK);
    }

    /**
     * Sets value of '_set' property
     *
     * @param Up_GuildSet $value Property value
     *
     * @return null
     */
    public function setSet(Up_GuildSet $value)
    {
        return $this->set(self::_SET, $value);
    }

    /**
     * Returns value of '_set' property
     *
     * @return Up_GuildSet
     */
    public function getSet()
    {
        return $this->get(self::_SET);
    }

    /**
     * Sets value of '_query' property
     *
     * @param Up_GuildQuery $value Property value
     *
     * @return null
     */
    public function setQuery(Up_GuildQuery $value)
    {
        return $this->set(self::_QUERY, $value);
    }

    /**
     * Returns value of '_query' property
     *
     * @return Up_GuildQuery
     */
    public function getQuery()
    {
        return $this->get(self::_QUERY);
    }

    /**
     * Sets value of '_open_pannel' property
     *
     * @param Up_GuildOpenPannel $value Property value
     *
     * @return null
     */
    public function setOpenPannel(Up_GuildOpenPannel $value)
    {
        return $this->set(self::_OPEN_PANNEL, $value);
    }

    /**
     * Returns value of '_open_pannel' property
     *
     * @return Up_GuildOpenPannel
     */
    public function getOpenPannel()
    {
        return $this->get(self::_OPEN_PANNEL);
    }

    /**
     * Sets value of '_set_job' property
     *
     * @param Up_GuildSetJob $value Property value
     *
     * @return null
     */
    public function setSetJob(Up_GuildSetJob $value)
    {
        return $this->set(self::_SET_JOB, $value);
    }

    /**
     * Returns value of '_set_job' property
     *
     * @return Up_GuildSetJob
     */
    public function getSetJob()
    {
        return $this->get(self::_SET_JOB);
    }

    /**
     * Sets value of '_add_hire' property
     *
     * @param Up_GuildAddHire $value Property value
     *
     * @return null
     */
    public function setAddHire(Up_GuildAddHire $value)
    {
        return $this->set(self::_ADD_HIRE, $value);
    }

    /**
     * Returns value of '_add_hire' property
     *
     * @return Up_GuildAddHire
     */
    public function getAddHire()
    {
        return $this->get(self::_ADD_HIRE);
    }

    /**
     * Sets value of '_del_hire' property
     *
     * @param Up_GuildDelHire $value Property value
     *
     * @return null
     */
    public function setDelHire(Up_GuildDelHire $value)
    {
        return $this->set(self::_DEL_HIRE, $value);
    }

    /**
     * Returns value of '_del_hire' property
     *
     * @return Up_GuildDelHire
     */
    public function getDelHire()
    {
        return $this->get(self::_DEL_HIRE);
    }

    /**
     * Sets value of '_query_hires' property
     *
     * @param Up_GuildQueryHires $value Property value
     *
     * @return null
     */
    public function setQueryHires(Up_GuildQueryHires $value)
    {
        return $this->set(self::_QUERY_HIRES, $value);
    }

    /**
     * Returns value of '_query_hires' property
     *
     * @return Up_GuildQueryHires
     */
    public function getQueryHires()
    {
        return $this->get(self::_QUERY_HIRES);
    }

    /**
     * Sets value of '_hire_hero' property
     *
     * @param Up_GuildHireHero $value Property value
     *
     * @return null
     */
    public function setHireHero(Up_GuildHireHero $value)
    {
        return $this->set(self::_HIRE_HERO, $value);
    }

    /**
     * Returns value of '_hire_hero' property
     *
     * @return Up_GuildHireHero
     */
    public function getHireHero()
    {
        return $this->get(self::_HIRE_HERO);
    }

    /**
     * Sets value of '_worship_req' property
     *
     * @param Up_GuildWorshipReq $value Property value
     *
     * @return null
     */
    public function setWorshipReq(Up_GuildWorshipReq $value)
    {
        return $this->set(self::_WORSHIP_REQ, $value);
    }

    /**
     * Returns value of '_worship_req' property
     *
     * @return Up_GuildWorshipReq
     */
    public function getWorshipReq()
    {
        return $this->get(self::_WORSHIP_REQ);
    }

    /**
     * Sets value of '_worship_withdraw' property
     *
     * @param Up_GuildWorshipWithdraw $value Property value
     *
     * @return null
     */
    public function setWorshipWithdraw(Up_GuildWorshipWithdraw $value)
    {
        return $this->set(self::_WORSHIP_WITHDRAW, $value);
    }

    /**
     * Returns value of '_worship_withdraw' property
     *
     * @return Up_GuildWorshipWithdraw
     */
    public function getWorshipWithdraw()
    {
        return $this->get(self::_WORSHIP_WITHDRAW);
    }

    /**
     * Sets value of '_query_hh_detail' property
     *
     * @param Up_GuildQureyHhDetail $value Property value
     *
     * @return null
     */
    public function setQueryHhDetail(Up_GuildQureyHhDetail $value)
    {
        return $this->set(self::_QUERY_HH_DETAIL, $value);
    }

    /**
     * Returns value of '_query_hh_detail' property
     *
     * @return Up_GuildQureyHhDetail
     */
    public function getQueryHhDetail()
    {
        return $this->get(self::_QUERY_HH_DETAIL);
    }

    /**
     * Sets value of '_instance_query' property
     *
     * @param Up_GuildInstanceQuery $value Property value
     *
     * @return null
     */
    public function setInstanceQuery(Up_GuildInstanceQuery $value)
    {
        return $this->set(self::_INSTANCE_QUERY, $value);
    }

    /**
     * Returns value of '_instance_query' property
     *
     * @return Up_GuildInstanceQuery
     */
    public function getInstanceQuery()
    {
        return $this->get(self::_INSTANCE_QUERY);
    }

    /**
     * Sets value of '_instance_detail' property
     *
     * @param Up_GuildInstanceDetail $value Property value
     *
     * @return null
     */
    public function setInstanceDetail(Up_GuildInstanceDetail $value)
    {
        return $this->set(self::_INSTANCE_DETAIL, $value);
    }

    /**
     * Returns value of '_instance_detail' property
     *
     * @return Up_GuildInstanceDetail
     */
    public function getInstanceDetail()
    {
        return $this->get(self::_INSTANCE_DETAIL);
    }

    /**
     * Sets value of '_instance_start' property
     *
     * @param Up_GuildInstanceStart $value Property value
     *
     * @return null
     */
    public function setInstanceStart(Up_GuildInstanceStart $value)
    {
        return $this->set(self::_INSTANCE_START, $value);
    }

    /**
     * Returns value of '_instance_start' property
     *
     * @return Up_GuildInstanceStart
     */
    public function getInstanceStart()
    {
        return $this->get(self::_INSTANCE_START);
    }

    /**
     * Sets value of '_instance_end' property
     *
     * @param Up_GuildInstanceEnd $value Property value
     *
     * @return null
     */
    public function setInstanceEnd(Up_GuildInstanceEnd $value)
    {
        return $this->set(self::_INSTANCE_END, $value);
    }

    /**
     * Returns value of '_instance_end' property
     *
     * @return Up_GuildInstanceEnd
     */
    public function getInstanceEnd()
    {
        return $this->get(self::_INSTANCE_END);
    }

    /**
     * Sets value of '_instance_drop' property
     *
     * @param Up_GuildInstanceDrop $value Property value
     *
     * @return null
     */
    public function setInstanceDrop(Up_GuildInstanceDrop $value)
    {
        return $this->set(self::_INSTANCE_DROP, $value);
    }

    /**
     * Returns value of '_instance_drop' property
     *
     * @return Up_GuildInstanceDrop
     */
    public function getInstanceDrop()
    {
        return $this->get(self::_INSTANCE_DROP);
    }

    /**
     * Sets value of '_instance_open' property
     *
     * @param Up_GuildInstanceOpen $value Property value
     *
     * @return null
     */
    public function setInstanceOpen(Up_GuildInstanceOpen $value)
    {
        return $this->set(self::_INSTANCE_OPEN, $value);
    }

    /**
     * Returns value of '_instance_open' property
     *
     * @return Up_GuildInstanceOpen
     */
    public function getInstanceOpen()
    {
        return $this->get(self::_INSTANCE_OPEN);
    }

    /**
     * Sets value of '_instance_apply' property
     *
     * @param Up_GuildInstanceApply $value Property value
     *
     * @return null
     */
    public function setInstanceApply(Up_GuildInstanceApply $value)
    {
        return $this->set(self::_INSTANCE_APPLY, $value);
    }

    /**
     * Returns value of '_instance_apply' property
     *
     * @return Up_GuildInstanceApply
     */
    public function getInstanceApply()
    {
        return $this->get(self::_INSTANCE_APPLY);
    }

    /**
     * Sets value of '_drop_info' property
     *
     * @param Up_GuildDropInfo $value Property value
     *
     * @return null
     */
    public function setDropInfo(Up_GuildDropInfo $value)
    {
        return $this->set(self::_DROP_INFO, $value);
    }

    /**
     * Returns value of '_drop_info' property
     *
     * @return Up_GuildDropInfo
     */
    public function getDropInfo()
    {
        return $this->get(self::_DROP_INFO);
    }

    /**
     * Sets value of '_drop_give' property
     *
     * @param Up_GuildDropGive $value Property value
     *
     * @return null
     */
    public function setDropGive(Up_GuildDropGive $value)
    {
        return $this->set(self::_DROP_GIVE, $value);
    }

    /**
     * Returns value of '_drop_give' property
     *
     * @return Up_GuildDropGive
     */
    public function getDropGive()
    {
        return $this->get(self::_DROP_GIVE);
    }

    /**
     * Sets value of '_instance_damage' property
     *
     * @param Up_GuildInstanceDamage $value Property value
     *
     * @return null
     */
    public function setInstanceDamage(Up_GuildInstanceDamage $value)
    {
        return $this->set(self::_INSTANCE_DAMAGE, $value);
    }

    /**
     * Returns value of '_instance_damage' property
     *
     * @return Up_GuildInstanceDamage
     */
    public function getInstanceDamage()
    {
        return $this->get(self::_INSTANCE_DAMAGE);
    }

    /**
     * Sets value of '_items_history' property
     *
     * @param Up_GuildItemsHistory $value Property value
     *
     * @return null
     */
    public function setItemsHistory(Up_GuildItemsHistory $value)
    {
        return $this->set(self::_ITEMS_HISTORY, $value);
    }

    /**
     * Returns value of '_items_history' property
     *
     * @return Up_GuildItemsHistory
     */
    public function getItemsHistory()
    {
        return $this->get(self::_ITEMS_HISTORY);
    }

    /**
     * Sets value of '_guild_jump' property
     *
     * @param Up_GuildJump $value Property value
     *
     * @return null
     */
    public function setGuildJump(Up_GuildJump $value)
    {
        return $this->set(self::_GUILD_JUMP, $value);
    }

    /**
     * Returns value of '_guild_jump' property
     *
     * @return Up_GuildJump
     */
    public function getGuildJump()
    {
        return $this->get(self::_GUILD_JUMP);
    }

    /**
     * Sets value of '_guild_app_queue' property
     *
     * @param Up_GuildAppQueue $value Property value
     *
     * @return null
     */
    public function setGuildAppQueue(Up_GuildAppQueue $value)
    {
        return $this->set(self::_GUILD_APP_QUEUE, $value);
    }

    /**
     * Returns value of '_guild_app_queue' property
     *
     * @return Up_GuildAppQueue
     */
    public function getGuildAppQueue()
    {
        return $this->get(self::_GUILD_APP_QUEUE);
    }

    /**
     * Sets value of '_instance_prepare' property
     *
     * @param Up_GuildPrepareInstance $value Property value
     *
     * @return null
     */
    public function setInstancePrepare(Up_GuildPrepareInstance $value)
    {
        return $this->set(self::_INSTANCE_PREPARE, $value);
    }

    /**
     * Returns value of '_instance_prepare' property
     *
     * @return Up_GuildPrepareInstance
     */
    public function getInstancePrepare()
    {
        return $this->get(self::_INSTANCE_PREPARE);
    }

    /**
     * Sets value of '_guild_query_member' property
     *
     * @param Up_GuildQueryMember $value Property value
     *
     * @return null
     */
    public function setGuildQueryMember(Up_GuildQueryMember $value)
    {
        return $this->set(self::_GUILD_QUERY_MEMBER, $value);
    }

    /**
     * Returns value of '_guild_query_member' property
     *
     * @return Up_GuildQueryMember
     */
    public function getGuildQueryMember()
    {
        return $this->get(self::_GUILD_QUERY_MEMBER);
    }

    /**
     * Sets value of '_guild_stage_rank' property
     *
     * @param Up_GuildStageRank $value Property value
     *
     * @return null
     */
    public function setGuildStageRank(Up_GuildStageRank $value)
    {
        return $this->set(self::_GUILD_STAGE_RANK, $value);
    }

    /**
     * Returns value of '_guild_stage_rank' property
     *
     * @return Up_GuildStageRank
     */
    public function getGuildStageRank()
    {
        return $this->get(self::_GUILD_STAGE_RANK);
    }

    /**
     * Sets value of '_set_jump' property
     *
     * @param Up_GuildSetJump $value Property value
     *
     * @return null
     */
    public function setSetJump(Up_GuildSetJump $value)
    {
        return $this->set(self::_SET_JUMP, $value);
    }

    /**
     * Returns value of '_set_jump' property
     *
     * @return Up_GuildSetJump
     */
    public function getSetJump()
    {
        return $this->get(self::_SET_JUMP);
    }
}

/**
 * is_can_jump enum embedded in guild_set_jump message
 */
final class Up_GuildSetJump_IsCanJump
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
 * guild_set_jump message
 */
class Up_GuildSetJump extends \ProtobufMessage
{
    /* Field index constants */
    const _IS_CAN_JUMP = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
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
 * guild_stage_rank message
 */
class Up_GuildStageRank extends \ProtobufMessage
{
    /* Field index constants */
    const _STAGE_ID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_STAGE_ID => array(
            'name' => '_stage_id',
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
        $this->values[self::_STAGE_ID] = null;
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
}

/**
 * guild_query_member message
 */
class Up_GuildQueryMember extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * guild_prepare_instance message
 */
class Up_GuildPrepareInstance extends \ProtobufMessage
{
    /* Field index constants */
    const _STAGE_ID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_STAGE_ID => array(
            'name' => '_stage_id',
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
        $this->values[self::_STAGE_ID] = null;
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
}

/**
 * guild_app_queue message
 */
class Up_GuildAppQueue extends \ProtobufMessage
{
    /* Field index constants */
    const _ITEM_ID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ITEM_ID => array(
            'name' => '_item_id',
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
}

/**
 * guild_jump message
 */
class Up_GuildJump extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * guild_items_history message
 */
class Up_GuildItemsHistory extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * guild_drop_give message
 */
class Up_GuildDropGive extends \ProtobufMessage
{
    /* Field index constants */
    const _ITEM_ID = 1;
    const _RAID_ID = 2;
    const _USER_ID = 3;
    const _TIME_OUT_END = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ITEM_ID => array(
            'name' => '_item_id',
            'required' => true,
            'type' => 5,
        ),
        self::_RAID_ID => array(
            'name' => '_raid_id',
            'required' => true,
            'type' => 5,
        ),
        self::_USER_ID => array(
            'name' => '_user_id',
            'required' => true,
            'type' => 5,
        ),
        self::_TIME_OUT_END => array(
            'name' => '_time_out_end',
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
        $this->values[self::_RAID_ID] = null;
        $this->values[self::_USER_ID] = null;
        $this->values[self::_TIME_OUT_END] = null;
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
}

/**
 * guild_instance_damage message
 */
class Up_GuildInstanceDamage extends \ProtobufMessage
{
    /* Field index constants */
    const _RAID_ID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RAID_ID => array(
            'name' => '_raid_id',
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
        $this->values[self::_RAID_ID] = null;
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
}

/**
 * guild_drop_info message
 */
class Up_GuildDropInfo extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * guild_instance_apply message
 */
class Up_GuildInstanceApply extends \ProtobufMessage
{
    /* Field index constants */
    const _RAID_ID = 1;
    const _ITEM_ID = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RAID_ID => array(
            'name' => '_raid_id',
            'required' => true,
            'type' => 5,
        ),
        self::_ITEM_ID => array(
            'name' => '_item_id',
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
        $this->values[self::_RAID_ID] = null;
        $this->values[self::_ITEM_ID] = null;
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
}

/**
 * guild_instance_start message
 */
class Up_GuildInstanceStart extends \ProtobufMessage
{
    /* Field index constants */
    const _STAGE_ID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_STAGE_ID => array(
            'name' => '_stage_id',
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
        $this->values[self::_STAGE_ID] = null;
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
}

/**
 * guild_instance_end message
 */
class Up_GuildInstanceEnd extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _HP_INFO = 2;
    const _WAVE = 3;
    const _DAMAGE = 4;
    const _PROGRESS = 5;
    const _STAGE_PROGRESS = 6;
    const _OPRATIONS = 7;
    const _HEROES = 8;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_HP_INFO => array(
            'name' => '_hp_info',
            'repeated' => true,
            'type' => 5,
        ),
        self::_WAVE => array(
            'name' => '_wave',
            'required' => true,
            'type' => 5,
        ),
        self::_DAMAGE => array(
            'name' => '_damage',
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
        self::_OPRATIONS => array(
            'name' => '_oprations',
            'repeated' => true,
            'type' => 5,
        ),
        self::_HEROES => array(
            'name' => '_heroes',
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
        $this->values[self::_HP_INFO] = array();
        $this->values[self::_WAVE] = null;
        $this->values[self::_DAMAGE] = null;
        $this->values[self::_PROGRESS] = null;
        $this->values[self::_STAGE_PROGRESS] = null;
        $this->values[self::_OPRATIONS] = array();
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
     * Appends value to '_oprations' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendOprations($value)
    {
        return $this->append(self::_OPRATIONS, $value);
    }

    /**
     * Clears '_oprations' list
     *
     * @return null
     */
    public function clearOprations()
    {
        return $this->clear(self::_OPRATIONS);
    }

    /**
     * Returns '_oprations' list
     *
     * @return int[]
     */
    public function getOprations()
    {
        return $this->get(self::_OPRATIONS);
    }

    /**
     * Returns '_oprations' iterator
     *
     * @return ArrayIterator
     */
    public function getOprationsIterator()
    {
        return new \ArrayIterator($this->get(self::_OPRATIONS));
    }

    /**
     * Returns element from '_oprations' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getOprationsAt($offset)
    {
        return $this->get(self::_OPRATIONS, $offset);
    }

    /**
     * Returns count of '_oprations' list
     *
     * @return int
     */
    public function getOprationsCount()
    {
        return $this->count(self::_OPRATIONS);
    }

    /**
     * Appends value to '_heroes' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendHeroes($value)
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
     * @return int[]
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
     * @return int
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
 * guild_instance_drop message
 */
class Up_GuildInstanceDrop extends \ProtobufMessage
{
    /* Field index constants */
    const _RAID_ID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RAID_ID => array(
            'name' => '_raid_id',
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
        $this->values[self::_RAID_ID] = null;
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
}

/**
 * guild_instance_open message
 */
class Up_GuildInstanceOpen extends \ProtobufMessage
{
    /* Field index constants */
    const _RAID_ID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RAID_ID => array(
            'name' => '_raid_id',
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
        $this->values[self::_RAID_ID] = null;
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
}

/**
 * guild_instance_query message
 */
class Up_GuildInstanceQuery extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * guild_instance_detail message
 */
class Up_GuildInstanceDetail extends \ProtobufMessage
{
    /* Field index constants */
    const _STAGE_ID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_STAGE_ID => array(
            'name' => '_stage_id',
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
        $this->values[self::_STAGE_ID] = null;
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
}

/**
 * guild_create message
 */
class Up_GuildCreate extends \ProtobufMessage
{
    /* Field index constants */
    const _NAME = 1;
    const _AVATAR = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
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
 * guild_dismiss message
 */
class Up_GuildDismiss extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * guild_list message
 */
class Up_GuildList extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * guild_search message
 */
class Up_GuildSearch extends \ProtobufMessage
{
    /* Field index constants */
    const _GUILD_ID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_GUILD_ID => array(
            'name' => '_guild_id',
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
        $this->values[self::_GUILD_ID] = null;
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
     * Sets value of '_guild_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setGuildId($value)
    {
        return $this->set(self::_GUILD_ID, $value);
    }

    /**
     * Returns value of '_guild_id' property
     *
     * @return int
     */
    public function getGuildId()
    {
        return $this->get(self::_GUILD_ID);
    }
}

/**
 * guild_join message
 */
class Up_GuildJoin extends \ProtobufMessage
{
    /* Field index constants */
    const _GUILD_ID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_GUILD_ID => array(
            'name' => '_guild_id',
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
        $this->values[self::_GUILD_ID] = null;
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
     * Sets value of '_guild_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setGuildId($value)
    {
        return $this->set(self::_GUILD_ID, $value);
    }

    /**
     * Returns value of '_guild_id' property
     *
     * @return int
     */
    public function getGuildId()
    {
        return $this->get(self::_GUILD_ID);
    }
}

/**
 * confirm_type enum embedded in guild_join_confirm message
 */
final class Up_GuildJoinConfirm_ConfirmType
{
    const accept = 1;
    const reject = 2;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'accept' => self::accept,
            'reject' => self::reject,
        );
    }
}

/**
 * guild_join_confirm message
 */
class Up_GuildJoinConfirm extends \ProtobufMessage
{
    /* Field index constants */
    const _UID = 1;
    const _TYPE = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_UID => array(
            'name' => '_uid',
            'required' => true,
            'type' => 5,
        ),
        self::_TYPE => array(
            'default' => Up_GuildJoinConfirm_ConfirmType::accept, 
            'name' => '_type',
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
        $this->values[self::_TYPE] = null;
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
}

/**
 * guild_leave message
 */
class Up_GuildLeave extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * guild_kick message
 */
class Up_GuildKick extends \ProtobufMessage
{
    /* Field index constants */
    const _UID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_UID => array(
            'name' => '_uid',
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
}

/**
 * guild_join_t enum embedded in guild_set message
 */
final class Up_GuildSet_GuildJoinT
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
 * guild_set message
 */
class Up_GuildSet extends \ProtobufMessage
{
    /* Field index constants */
    const _AVATAR = 1;
    const _JOIN_TYPE = 2;
    const _JOIN_LIMIT = 3;
    const _SLOGAN = 4;
    const _CAN_JUMP = 5;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_AVATAR => array(
            'name' => '_avatar',
            'required' => false,
            'type' => 5,
        ),
        self::_JOIN_TYPE => array(
            'name' => '_join_type',
            'required' => false,
            'type' => 5,
        ),
        self::_JOIN_LIMIT => array(
            'name' => '_join_limit',
            'required' => false,
            'type' => 5,
        ),
        self::_SLOGAN => array(
            'name' => '_slogan',
            'required' => false,
            'type' => 7,
        ),
        self::_CAN_JUMP => array(
            'name' => '_can_jump',
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
        $this->values[self::_JOIN_TYPE] = null;
        $this->values[self::_JOIN_LIMIT] = null;
        $this->values[self::_SLOGAN] = null;
        $this->values[self::_CAN_JUMP] = null;
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
}

/**
 * guild_query message
 */
class Up_GuildQuery extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * guild_open_pannel message
 */
class Up_GuildOpenPannel extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * guild_set_job message
 */
class Up_GuildSetJob extends \ProtobufMessage
{
    /* Field index constants */
    const _UID = 1;
    const _JOB = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_UID => array(
            'name' => '_uid',
            'required' => true,
            'type' => 5,
        ),
        self::_JOB => array(
            'name' => '_job',
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
        $this->values[self::_JOB] = null;
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
}

/**
 * guild_add_hire message
 */
class Up_GuildAddHire extends \ProtobufMessage
{
    /* Field index constants */
    const _HEROID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_HEROID => array(
            'name' => '_heroid',
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
 * guild_del_hire message
 */
class Up_GuildDelHire extends \ProtobufMessage
{
    /* Field index constants */
    const _HEROID = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_HEROID => array(
            'name' => '_heroid',
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
class Up_GuildQueryHires extends \ProtobufMessage
{
    /* Field index constants */
    const _FROM = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
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
 * guild_hire_hero message
 */
class Up_GuildHireHero extends \ProtobufMessage
{
    /* Field index constants */
    const _UID = 1;
    const _HEROID = 2;
    const _FROM = 3;
    const _STAGE_ID = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_UID => array(
            'name' => '_uid',
            'required' => true,
            'type' => 5,
        ),
        self::_HEROID => array(
            'name' => '_heroid',
            'required' => true,
            'type' => 5,
        ),
        self::_FROM => array(
            'name' => '_from',
            'required' => true,
            'type' => 5,
        ),
        self::_STAGE_ID => array(
            'name' => '_stage_id',
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
        $this->values[self::_HEROID] = null;
        $this->values[self::_FROM] = null;
        $this->values[self::_STAGE_ID] = null;
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
}

/**
 * guild_worship_req message
 */
class Up_GuildWorshipReq extends \ProtobufMessage
{
    /* Field index constants */
    const _ID = 1;
    const _UID = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ID => array(
            'name' => '_id',
            'required' => true,
            'type' => 5,
        ),
        self::_UID => array(
            'name' => '_uid',
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
        $this->values[self::_UID] = null;
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
}

/**
 * guild_worship_withdraw message
 */
class Up_GuildWorshipWithdraw extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * guild_qurey_hh_detail message
 */
class Up_GuildQureyHhDetail extends \ProtobufMessage
{
    /* Field index constants */
    const _UID = 1;
    const _HEROID = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_UID => array(
            'name' => '_uid',
            'required' => true,
            'type' => 5,
        ),
        self::_HEROID => array(
            'name' => '_heroid',
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
 * ask_activity_info message
 */
class Up_AskActivityInfo extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * cdkey_gift message
 */
class Up_CdkeyGift extends \ProtobufMessage
{
    /* Field index constants */
    const _CDKEY = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_CDKEY => array(
            'name' => '_cdkey',
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
        $this->values[self::_CDKEY] = null;
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
     * Sets value of '_cdkey' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setCdkey($value)
    {
        return $this->set(self::_CDKEY, $value);
    }

    /**
     * Returns value of '_cdkey' property
     *
     * @return string
     */
    public function getCdkey()
    {
        return $this->get(self::_CDKEY);
    }
}

/**
 * excavate message
 */
class Up_Excavate extends \ProtobufMessage
{
    /* Field index constants */
    const _SEARCH_EXCAVATE = 1;
    const _QUERY_EXCAVATE_DATA = 2;
    const _QUERY_EXCAVATE_HISTORY = 3;
    const _QUERY_EXCAVATE_BATTLE = 4;
    const _SET_EXCAVATE_TEAM = 5;
    const _EXCAVATE_START_BATTLE = 6;
    const _EXCAVATE_END_BATTLE = 7;
    const _QUERY_EXCAVATE_DEF = 8;
    const _CLEAR_EXCAVATE_BATTLE = 9;
    const _WITHDRAW_EXCAVATE_HERO = 10;
    const _DRAW_EXCAVATE_DEF_RWD = 11;
    const _DROP_EXCAVATE = 12;
    const _QUERY_REPLAY = 13;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_SEARCH_EXCAVATE => array(
            'name' => '_search_excavate',
            'required' => false,
            'type' => 'Up_SearchExcavate'
        ),
        self::_QUERY_EXCAVATE_DATA => array(
            'name' => '_query_excavate_data',
            'required' => false,
            'type' => 'Up_QueryExcavateData'
        ),
        self::_QUERY_EXCAVATE_HISTORY => array(
            'name' => '_query_excavate_history',
            'required' => false,
            'type' => 'Up_QueryExcavateHistory'
        ),
        self::_QUERY_EXCAVATE_BATTLE => array(
            'name' => '_query_excavate_battle',
            'required' => false,
            'type' => 'Up_QueryExcavateBattle'
        ),
        self::_SET_EXCAVATE_TEAM => array(
            'name' => '_set_excavate_team',
            'required' => false,
            'type' => 'Up_SetExcavateTeam'
        ),
        self::_EXCAVATE_START_BATTLE => array(
            'name' => '_excavate_start_battle',
            'required' => false,
            'type' => 'Up_ExcavateStartBattle'
        ),
        self::_EXCAVATE_END_BATTLE => array(
            'name' => '_excavate_end_battle',
            'required' => false,
            'type' => 'Up_ExcavateEndBattle'
        ),
        self::_QUERY_EXCAVATE_DEF => array(
            'name' => '_query_excavate_def',
            'required' => false,
            'type' => 'Up_QueryExcavateDef'
        ),
        self::_CLEAR_EXCAVATE_BATTLE => array(
            'name' => '_clear_excavate_battle',
            'required' => false,
            'type' => 'Up_ClearExcavateBattle'
        ),
        self::_WITHDRAW_EXCAVATE_HERO => array(
            'name' => '_withdraw_excavate_hero',
            'required' => false,
            'type' => 'Up_WithdrawExcavateHero'
        ),
        self::_DRAW_EXCAVATE_DEF_RWD => array(
            'name' => '_draw_excavate_def_rwd',
            'required' => false,
            'type' => 'Up_DrawExcavateDefRwd'
        ),
        self::_DROP_EXCAVATE => array(
            'name' => '_drop_excavate',
            'required' => false,
            'type' => 'Up_DropExcavate'
        ),
        self::_QUERY_REPLAY => array(
            'name' => '_query_replay',
            'required' => false,
            'type' => 'Up_QueryReplay'
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
        $this->values[self::_SEARCH_EXCAVATE] = null;
        $this->values[self::_QUERY_EXCAVATE_DATA] = null;
        $this->values[self::_QUERY_EXCAVATE_HISTORY] = null;
        $this->values[self::_QUERY_EXCAVATE_BATTLE] = null;
        $this->values[self::_SET_EXCAVATE_TEAM] = null;
        $this->values[self::_EXCAVATE_START_BATTLE] = null;
        $this->values[self::_EXCAVATE_END_BATTLE] = null;
        $this->values[self::_QUERY_EXCAVATE_DEF] = null;
        $this->values[self::_CLEAR_EXCAVATE_BATTLE] = null;
        $this->values[self::_WITHDRAW_EXCAVATE_HERO] = null;
        $this->values[self::_DRAW_EXCAVATE_DEF_RWD] = null;
        $this->values[self::_DROP_EXCAVATE] = null;
        $this->values[self::_QUERY_REPLAY] = null;
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
     * Sets value of '_search_excavate' property
     *
     * @param Up_SearchExcavate $value Property value
     *
     * @return null
     */
    public function setSearchExcavate(Up_SearchExcavate $value)
    {
        return $this->set(self::_SEARCH_EXCAVATE, $value);
    }

    /**
     * Returns value of '_search_excavate' property
     *
     * @return Up_SearchExcavate
     */
    public function getSearchExcavate()
    {
        return $this->get(self::_SEARCH_EXCAVATE);
    }

    /**
     * Sets value of '_query_excavate_data' property
     *
     * @param Up_QueryExcavateData $value Property value
     *
     * @return null
     */
    public function setQueryExcavateData(Up_QueryExcavateData $value)
    {
        return $this->set(self::_QUERY_EXCAVATE_DATA, $value);
    }

    /**
     * Returns value of '_query_excavate_data' property
     *
     * @return Up_QueryExcavateData
     */
    public function getQueryExcavateData()
    {
        return $this->get(self::_QUERY_EXCAVATE_DATA);
    }

    /**
     * Sets value of '_query_excavate_history' property
     *
     * @param Up_QueryExcavateHistory $value Property value
     *
     * @return null
     */
    public function setQueryExcavateHistory(Up_QueryExcavateHistory $value)
    {
        return $this->set(self::_QUERY_EXCAVATE_HISTORY, $value);
    }

    /**
     * Returns value of '_query_excavate_history' property
     *
     * @return Up_QueryExcavateHistory
     */
    public function getQueryExcavateHistory()
    {
        return $this->get(self::_QUERY_EXCAVATE_HISTORY);
    }

    /**
     * Sets value of '_query_excavate_battle' property
     *
     * @param Up_QueryExcavateBattle $value Property value
     *
     * @return null
     */
    public function setQueryExcavateBattle(Up_QueryExcavateBattle $value)
    {
        return $this->set(self::_QUERY_EXCAVATE_BATTLE, $value);
    }

    /**
     * Returns value of '_query_excavate_battle' property
     *
     * @return Up_QueryExcavateBattle
     */
    public function getQueryExcavateBattle()
    {
        return $this->get(self::_QUERY_EXCAVATE_BATTLE);
    }

    /**
     * Sets value of '_set_excavate_team' property
     *
     * @param Up_SetExcavateTeam $value Property value
     *
     * @return null
     */
    public function setSetExcavateTeam(Up_SetExcavateTeam $value)
    {
        return $this->set(self::_SET_EXCAVATE_TEAM, $value);
    }

    /**
     * Returns value of '_set_excavate_team' property
     *
     * @return Up_SetExcavateTeam
     */
    public function getSetExcavateTeam()
    {
        return $this->get(self::_SET_EXCAVATE_TEAM);
    }

    /**
     * Sets value of '_excavate_start_battle' property
     *
     * @param Up_ExcavateStartBattle $value Property value
     *
     * @return null
     */
    public function setExcavateStartBattle(Up_ExcavateStartBattle $value)
    {
        return $this->set(self::_EXCAVATE_START_BATTLE, $value);
    }

    /**
     * Returns value of '_excavate_start_battle' property
     *
     * @return Up_ExcavateStartBattle
     */
    public function getExcavateStartBattle()
    {
        return $this->get(self::_EXCAVATE_START_BATTLE);
    }

    /**
     * Sets value of '_excavate_end_battle' property
     *
     * @param Up_ExcavateEndBattle $value Property value
     *
     * @return null
     */
    public function setExcavateEndBattle(Up_ExcavateEndBattle $value)
    {
        return $this->set(self::_EXCAVATE_END_BATTLE, $value);
    }

    /**
     * Returns value of '_excavate_end_battle' property
     *
     * @return Up_ExcavateEndBattle
     */
    public function getExcavateEndBattle()
    {
        return $this->get(self::_EXCAVATE_END_BATTLE);
    }

    /**
     * Sets value of '_query_excavate_def' property
     *
     * @param Up_QueryExcavateDef $value Property value
     *
     * @return null
     */
    public function setQueryExcavateDef(Up_QueryExcavateDef $value)
    {
        return $this->set(self::_QUERY_EXCAVATE_DEF, $value);
    }

    /**
     * Returns value of '_query_excavate_def' property
     *
     * @return Up_QueryExcavateDef
     */
    public function getQueryExcavateDef()
    {
        return $this->get(self::_QUERY_EXCAVATE_DEF);
    }

    /**
     * Sets value of '_clear_excavate_battle' property
     *
     * @param Up_ClearExcavateBattle $value Property value
     *
     * @return null
     */
    public function setClearExcavateBattle(Up_ClearExcavateBattle $value)
    {
        return $this->set(self::_CLEAR_EXCAVATE_BATTLE, $value);
    }

    /**
     * Returns value of '_clear_excavate_battle' property
     *
     * @return Up_ClearExcavateBattle
     */
    public function getClearExcavateBattle()
    {
        return $this->get(self::_CLEAR_EXCAVATE_BATTLE);
    }

    /**
     * Sets value of '_withdraw_excavate_hero' property
     *
     * @param Up_WithdrawExcavateHero $value Property value
     *
     * @return null
     */
    public function setWithdrawExcavateHero(Up_WithdrawExcavateHero $value)
    {
        return $this->set(self::_WITHDRAW_EXCAVATE_HERO, $value);
    }

    /**
     * Returns value of '_withdraw_excavate_hero' property
     *
     * @return Up_WithdrawExcavateHero
     */
    public function getWithdrawExcavateHero()
    {
        return $this->get(self::_WITHDRAW_EXCAVATE_HERO);
    }

    /**
     * Sets value of '_draw_excavate_def_rwd' property
     *
     * @param Up_DrawExcavateDefRwd $value Property value
     *
     * @return null
     */
    public function setDrawExcavateDefRwd(Up_DrawExcavateDefRwd $value)
    {
        return $this->set(self::_DRAW_EXCAVATE_DEF_RWD, $value);
    }

    /**
     * Returns value of '_draw_excavate_def_rwd' property
     *
     * @return Up_DrawExcavateDefRwd
     */
    public function getDrawExcavateDefRwd()
    {
        return $this->get(self::_DRAW_EXCAVATE_DEF_RWD);
    }

    /**
     * Sets value of '_drop_excavate' property
     *
     * @param Up_DropExcavate $value Property value
     *
     * @return null
     */
    public function setDropExcavate(Up_DropExcavate $value)
    {
        return $this->set(self::_DROP_EXCAVATE, $value);
    }

    /**
     * Returns value of '_drop_excavate' property
     *
     * @return Up_DropExcavate
     */
    public function getDropExcavate()
    {
        return $this->get(self::_DROP_EXCAVATE);
    }

    /**
     * Sets value of '_query_replay' property
     *
     * @param Up_QueryReplay $value Property value
     *
     * @return null
     */
    public function setQueryReplay(Up_QueryReplay $value)
    {
        return $this->set(self::_QUERY_REPLAY, $value);
    }

    /**
     * Returns value of '_query_replay' property
     *
     * @return Up_QueryReplay
     */
    public function getQueryReplay()
    {
        return $this->get(self::_QUERY_REPLAY);
    }
}

/**
 * search_excavate message
 */
class Up_SearchExcavate extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * query_excavate_data message
 */
class Up_QueryExcavateData extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * query_excavate_history message
 */
class Up_QueryExcavateHistory extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * query_excavate_battle message
 */
class Up_QueryExcavateBattle extends \ProtobufMessage
{
    /* Field index constants */
    const _ID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ID => array(
            'name' => '_id',
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
}

/**
 * set_excavate_team message
 */
class Up_SetExcavateTeam extends \ProtobufMessage
{
    /* Field index constants */
    const _EXCAVATE_ID = 1;
    const _TID = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_EXCAVATE_ID => array(
            'name' => '_excavate_id',
            'required' => true,
            'type' => 5,
        ),
        self::_TID => array(
            'name' => '_tid',
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
        $this->values[self::_EXCAVATE_ID] = null;
        $this->values[self::_TID] = array();
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
     * Appends value to '_tid' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendTid($value)
    {
        return $this->append(self::_TID, $value);
    }

    /**
     * Clears '_tid' list
     *
     * @return null
     */
    public function clearTid()
    {
        return $this->clear(self::_TID);
    }

    /**
     * Returns '_tid' list
     *
     * @return int[]
     */
    public function getTid()
    {
        return $this->get(self::_TID);
    }

    /**
     * Returns '_tid' iterator
     *
     * @return ArrayIterator
     */
    public function getTidIterator()
    {
        return new \ArrayIterator($this->get(self::_TID));
    }

    /**
     * Returns element from '_tid' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getTidAt($offset)
    {
        return $this->get(self::_TID, $offset);
    }

    /**
     * Returns count of '_tid' list
     *
     * @return int
     */
    public function getTidCount()
    {
        return $this->count(self::_TID);
    }
}

/**
 * excavate_start_battle message
 */
class Up_ExcavateStartBattle extends \ProtobufMessage
{
    /* Field index constants */
    const _HEROIDS = 1;
    const _EXCAVATE_ID = 2;
    const _TEAM_ID = 3;
    const _TEAM_SVR_ID = 4;
    const _USE_HIRE = 5;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_HEROIDS => array(
            'name' => '_heroids',
            'repeated' => true,
            'type' => 5,
        ),
        self::_EXCAVATE_ID => array(
            'name' => '_excavate_id',
            'required' => true,
            'type' => 5,
        ),
        self::_TEAM_ID => array(
            'name' => '_team_id',
            'required' => true,
            'type' => 5,
        ),
        self::_TEAM_SVR_ID => array(
            'name' => '_team_svr_id',
            'required' => false,
            'type' => 5,
        ),
        self::_USE_HIRE => array(
            'name' => '_use_hire',
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
        $this->values[self::_HEROIDS] = array();
        $this->values[self::_EXCAVATE_ID] = null;
        $this->values[self::_TEAM_ID] = null;
        $this->values[self::_TEAM_SVR_ID] = null;
        $this->values[self::_USE_HIRE] = null;
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
     * Appends value to '_heroids' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendHeroids($value)
    {
        return $this->append(self::_HEROIDS, $value);
    }

    /**
     * Clears '_heroids' list
     *
     * @return null
     */
    public function clearHeroids()
    {
        return $this->clear(self::_HEROIDS);
    }

    /**
     * Returns '_heroids' list
     *
     * @return int[]
     */
    public function getHeroids()
    {
        return $this->get(self::_HEROIDS);
    }

    /**
     * Returns '_heroids' iterator
     *
     * @return ArrayIterator
     */
    public function getHeroidsIterator()
    {
        return new \ArrayIterator($this->get(self::_HEROIDS));
    }

    /**
     * Returns element from '_heroids' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getHeroidsAt($offset)
    {
        return $this->get(self::_HEROIDS, $offset);
    }

    /**
     * Returns count of '_heroids' list
     *
     * @return int
     */
    public function getHeroidsCount()
    {
        return $this->count(self::_HEROIDS);
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
     * Sets value of '_team_svr_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setTeamSvrId($value)
    {
        return $this->set(self::_TEAM_SVR_ID, $value);
    }

    /**
     * Returns value of '_team_svr_id' property
     *
     * @return int
     */
    public function getTeamSvrId()
    {
        return $this->get(self::_TEAM_SVR_ID);
    }

    /**
     * Sets value of '_use_hire' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setUseHire($value)
    {
        return $this->set(self::_USE_HIRE, $value);
    }

    /**
     * Returns value of '_use_hire' property
     *
     * @return int
     */
    public function getUseHire()
    {
        return $this->get(self::_USE_HIRE);
    }
}

/**
 * excavate_end_battle message
 */
class Up_ExcavateEndBattle extends \ProtobufMessage
{
    /* Field index constants */
    const _RESULT = 1;
    const _SELF_HEROES = 2;
    const _OPPO_HEROES = 3;
    const _OPRATIONS = 4;
    const _TYPE_ID = 5;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RESULT => array(
            'default' => Up_BattleResult::victory, 
            'name' => '_result',
            'required' => true,
            'type' => 5,
        ),
        self::_SELF_HEROES => array(
            'name' => '_self_heroes',
            'repeated' => true,
            'type' => 'Up_ExcavateHero'
        ),
        self::_OPPO_HEROES => array(
            'name' => '_oppo_heroes',
            'repeated' => true,
            'type' => 'Up_ExcavateHero'
        ),
        self::_OPRATIONS => array(
            'name' => '_oprations',
            'repeated' => true,
            'type' => 5,
        ),
        self::_TYPE_ID => array(
            'name' => '_type_id',
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
        $this->values[self::_SELF_HEROES] = array();
        $this->values[self::_OPPO_HEROES] = array();
        $this->values[self::_OPRATIONS] = array();
        $this->values[self::_TYPE_ID] = null;
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
     * Appends value to '_self_heroes' list
     *
     * @param Up_ExcavateHero $value Value to append
     *
     * @return null
     */
    public function appendSelfHeroes(Up_ExcavateHero $value)
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
     * @return Up_ExcavateHero[]
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
     * @return Up_ExcavateHero
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
     * Appends value to '_oppo_heroes' list
     *
     * @param Up_ExcavateHero $value Value to append
     *
     * @return null
     */
    public function appendOppoHeroes(Up_ExcavateHero $value)
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
     * @return Up_ExcavateHero[]
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
     * @return Up_ExcavateHero
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
     * Appends value to '_oprations' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendOprations($value)
    {
        return $this->append(self::_OPRATIONS, $value);
    }

    /**
     * Clears '_oprations' list
     *
     * @return null
     */
    public function clearOprations()
    {
        return $this->clear(self::_OPRATIONS);
    }

    /**
     * Returns '_oprations' list
     *
     * @return int[]
     */
    public function getOprations()
    {
        return $this->get(self::_OPRATIONS);
    }

    /**
     * Returns '_oprations' iterator
     *
     * @return ArrayIterator
     */
    public function getOprationsIterator()
    {
        return new \ArrayIterator($this->get(self::_OPRATIONS));
    }

    /**
     * Returns element from '_oprations' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getOprationsAt($offset)
    {
        return $this->get(self::_OPRATIONS, $offset);
    }

    /**
     * Returns count of '_oprations' list
     *
     * @return int
     */
    public function getOprationsCount()
    {
        return $this->count(self::_OPRATIONS);
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
}

/**
 * query_excavate_def message
 */
class Up_QueryExcavateDef extends \ProtobufMessage
{
    /* Field index constants */
    const _MINE_ID = 1;
    const _APPLIER_UID = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_MINE_ID => array(
            'name' => '_mine_id',
            'required' => true,
            'type' => 5,
        ),
        self::_APPLIER_UID => array(
            'name' => '_applier_uid',
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
        $this->values[self::_MINE_ID] = null;
        $this->values[self::_APPLIER_UID] = null;
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
     * Sets value of '_mine_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setMineId($value)
    {
        return $this->set(self::_MINE_ID, $value);
    }

    /**
     * Returns value of '_mine_id' property
     *
     * @return int
     */
    public function getMineId()
    {
        return $this->get(self::_MINE_ID);
    }

    /**
     * Sets value of '_applier_uid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setApplierUid($value)
    {
        return $this->set(self::_APPLIER_UID, $value);
    }

    /**
     * Returns value of '_applier_uid' property
     *
     * @return int
     */
    public function getApplierUid()
    {
        return $this->get(self::_APPLIER_UID);
    }
}

/**
 * clear_excavate_battle message
 */
class Up_ClearExcavateBattle extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * withdraw_excavate_hero message
 */
class Up_WithdrawExcavateHero extends \ProtobufMessage
{
    /* Field index constants */
    const _HERO_ID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_HERO_ID => array(
            'name' => '_hero_id',
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
        $this->values[self::_HERO_ID] = null;
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
}

/**
 * draw_excavate_def_rwd message
 */
class Up_DrawExcavateDefRwd extends \ProtobufMessage
{
    /* Field index constants */
    const _ID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ID => array(
            'name' => '_id',
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
}

/**
 * drop_excavate message
 */
class Up_DropExcavate extends \ProtobufMessage
{
    /* Field index constants */
    const _MINE_ID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_MINE_ID => array(
            'name' => '_mine_id',
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
        $this->values[self::_MINE_ID] = null;
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
     * Sets value of '_mine_id' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setMineId($value)
    {
        return $this->set(self::_MINE_ID, $value);
    }

    /**
     * Returns value of '_mine_id' property
     *
     * @return int
     */
    public function getMineId()
    {
        return $this->get(self::_MINE_ID);
    }
}

/**
 * excavate_hero message
 */
class Up_ExcavateHero extends \ProtobufMessage
{
    /* Field index constants */
    const _HEROID = 1;
    const _HP_PERC = 2;
    const _MP_PERC = 3;
    const _CUSTOM_DATA = 4;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_HEROID => array(
            'name' => '_heroid',
            'required' => true,
            'type' => 5,
        ),
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
        $this->values[self::_HEROID] = null;
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
 * query_split_data message
 */
class Up_QuerySplitData extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * query_split_return message
 */
class Up_QuerySplitReturn extends \ProtobufMessage
{
    /* Field index constants */
    const _TID = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TID => array(
            'name' => '_tid',
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
}

/**
 * split_hero message
 */
class Up_SplitHero extends \ProtobufMessage
{
    /* Field index constants */
    const _TID = 1;
    const _STONE_ID = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_TID => array(
            'name' => '_tid',
            'required' => true,
            'type' => 5,
        ),
        self::_STONE_ID => array(
            'name' => '_stone_id',
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
        $this->values[self::_STONE_ID] = null;
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
}

/**
 * worldcup message
 */
class Up_Worldcup extends \ProtobufMessage
{
    /* Field index constants */
    const _WORLDCUP_QUERY = 1;
    const _WORLDCUP_SUBMIT = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_WORLDCUP_QUERY => array(
            'name' => '_worldcup_query',
            'required' => false,
            'type' => 'Up_WorldcupQuery'
        ),
        self::_WORLDCUP_SUBMIT => array(
            'name' => '_worldcup_submit',
            'required' => false,
            'type' => 'Up_WorldcupSubmit'
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
        $this->values[self::_WORLDCUP_QUERY] = null;
        $this->values[self::_WORLDCUP_SUBMIT] = null;
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
     * Sets value of '_worldcup_query' property
     *
     * @param Up_WorldcupQuery $value Property value
     *
     * @return null
     */
    public function setWorldcupQuery(Up_WorldcupQuery $value)
    {
        return $this->set(self::_WORLDCUP_QUERY, $value);
    }

    /**
     * Returns value of '_worldcup_query' property
     *
     * @return Up_WorldcupQuery
     */
    public function getWorldcupQuery()
    {
        return $this->get(self::_WORLDCUP_QUERY);
    }

    /**
     * Sets value of '_worldcup_submit' property
     *
     * @param Up_WorldcupSubmit $value Property value
     *
     * @return null
     */
    public function setWorldcupSubmit(Up_WorldcupSubmit $value)
    {
        return $this->set(self::_WORLDCUP_SUBMIT, $value);
    }

    /**
     * Returns value of '_worldcup_submit' property
     *
     * @return Up_WorldcupSubmit
     */
    public function getWorldcupSubmit()
    {
        return $this->get(self::_WORLDCUP_SUBMIT);
    }
}

/**
 * worldcup_query message
 */
class Up_WorldcupQuery extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * worldcup_submit message
 */
class Up_WorldcupSubmit extends \ProtobufMessage
{
    /* Field index constants */
    const _GUESS1 = 1;
    const _GUESS2 = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_GUESS1 => array(
            'name' => '_guess1',
            'required' => true,
            'type' => 5,
        ),
        self::_GUESS2 => array(
            'name' => '_guess2',
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
        $this->values[self::_GUESS1] = null;
        $this->values[self::_GUESS2] = null;
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
     * Sets value of '_guess1' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setGuess1($value)
    {
        return $this->set(self::_GUESS1, $value);
    }

    /**
     * Returns value of '_guess1' property
     *
     * @return int
     */
    public function getGuess1()
    {
        return $this->get(self::_GUESS1);
    }

    /**
     * Sets value of '_guess2' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setGuess2($value)
    {
        return $this->set(self::_GUESS2, $value);
    }

    /**
     * Returns value of '_guess2' property
     *
     * @return int
     */
    public function getGuess2()
    {
        return $this->get(self::_GUESS2);
    }
}

/**
 * report_battle message
 */
class Up_ReportBattle extends \ProtobufMessage
{
    /* Field index constants */
    const _ID = 1;
    const _DATA = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ID => array(
            'name' => '_id',
            'required' => true,
            'type' => 5,
        ),
        self::_DATA => array(
            'name' => '_data',
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
        $this->values[self::_DATA] = null;
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
     * Sets value of '_data' property
     *
     * @param string $value Property value
     *
     * @return null
     */
    public function setData($value)
    {
        return $this->set(self::_DATA, $value);
    }

    /**
     * Returns value of '_data' property
     *
     * @return string
     */
    public function getData()
    {
        return $this->get(self::_DATA);
    }
}

/**
 * rank_type enum embedded in query_ranklist message
 */
final class Up_QueryRanklist_RankType
{
    const guildliveness = 1;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'guildliveness' => self::guildliveness,
        );
    }
}

/**
 * query_ranklist message
 */
class Up_QueryRanklist extends \ProtobufMessage
{
    /* Field index constants */
    const _RANK_TYPE = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_RANK_TYPE => array(
            'name' => '_rank_type',
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
        $this->values[self::_RANK_TYPE] = null;
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
}

/**
 * arousal_type enum embedded in require_arousal message
 */
final class Up_RequireArousal_ArousalType
{
    const require_arousal = 1;
    const apply_arousal = 2;

    /**
     * Returns defined enum values
     *
     * @return int[]
     */
    public function getEnumValues()
    {
        return array(
            'require_arousal' => self::require_arousal,
            'apply_arousal' => self::apply_arousal,
        );
    }
}

/**
 * require_arousal message
 */
class Up_RequireArousal extends \ProtobufMessage
{
    /* Field index constants */
    const _HID = 1;
    const _AROUSAL_TYPE = 2;
    const _AID = 3;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_HID => array(
            'name' => '_hid',
            'required' => true,
            'type' => 5,
        ),
        self::_AROUSAL_TYPE => array(
            'name' => '_arousal_type',
            'required' => true,
            'type' => 5,
        ),
        self::_AID => array(
            'name' => '_aid',
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
        $this->values[self::_HID] = null;
        $this->values[self::_AROUSAL_TYPE] = null;
        $this->values[self::_AID] = null;
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
     * Sets value of '_hid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setHid($value)
    {
        return $this->set(self::_HID, $value);
    }

    /**
     * Returns value of '_hid' property
     *
     * @return int
     */
    public function getHid()
    {
        return $this->get(self::_HID);
    }

    /**
     * Sets value of '_arousal_type' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setArousalType($value)
    {
        return $this->set(self::_AROUSAL_TYPE, $value);
    }

    /**
     * Returns value of '_arousal_type' property
     *
     * @return int
     */
    public function getArousalType()
    {
        return $this->get(self::_AROUSAL_TYPE);
    }

    /**
     * Sets value of '_aid' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setAid($value)
    {
        return $this->set(self::_AID, $value);
    }

    /**
     * Returns value of '_aid' property
     *
     * @return int
     */
    public function getAid()
    {
        return $this->get(self::_AID);
    }
}

/**
 * change_server message
 */
class Up_ChangeServer extends \ProtobufMessage
{
    /* Field index constants */
    const _OP_TYPE = 1;
    const _SERVER_ID = 2;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_OP_TYPE => array(
            'name' => '_op_type',
            'required' => true,
            'type' => 5,
        ),
        self::_SERVER_ID => array(
            'name' => '_server_id',
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
        $this->values[self::_OP_TYPE] = null;
        $this->values[self::_SERVER_ID] = null;
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
     * Sets value of '_op_type' property
     *
     * @param int $value Property value
     *
     * @return null
     */
    public function setOpType($value)
    {
        return $this->set(self::_OP_TYPE, $value);
    }

    /**
     * Returns value of '_op_type' property
     *
     * @return int
     */
    public function getOpType()
    {
        return $this->get(self::_OP_TYPE);
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
}

/**
 * request_guild_log message
 */
class Up_RequestGuildLog extends \ProtobufMessage
{
    /* Field index constants */

    /* @var array Field descriptors */
    protected static $fields = array(
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
}

/**
 * query_act_stage message
 */
class Up_QueryActStage extends \ProtobufMessage
{
    /* Field index constants */
    const _ACT_STAGE_GROUPS = 1;

    /* @var array Field descriptors */
    protected static $fields = array(
        self::_ACT_STAGE_GROUPS => array(
            'name' => '_act_stage_groups',
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
        $this->values[self::_ACT_STAGE_GROUPS] = array();
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
     * Appends value to '_act_stage_groups' list
     *
     * @param int $value Value to append
     *
     * @return null
     */
    public function appendActStageGroups($value)
    {
        return $this->append(self::_ACT_STAGE_GROUPS, $value);
    }

    /**
     * Clears '_act_stage_groups' list
     *
     * @return null
     */
    public function clearActStageGroups()
    {
        return $this->clear(self::_ACT_STAGE_GROUPS);
    }

    /**
     * Returns '_act_stage_groups' list
     *
     * @return int[]
     */
    public function getActStageGroups()
    {
        return $this->get(self::_ACT_STAGE_GROUPS);
    }

    /**
     * Returns '_act_stage_groups' iterator
     *
     * @return ArrayIterator
     */
    public function getActStageGroupsIterator()
    {
        return new \ArrayIterator($this->get(self::_ACT_STAGE_GROUPS));
    }

    /**
     * Returns element from '_act_stage_groups' list at given offset
     *
     * @param int $offset Position in list
     *
     * @return int
     */
    public function getActStageGroupsAt($offset)
    {
        return $this->get(self::_ACT_STAGE_GROUPS, $offset);
    }

    /**
     * Returns count of '_act_stage_groups' list
     *
     * @return int
     */
    public function getActStageGroupsCount()
    {
        return $this->count(self::_ACT_STAGE_GROUPS);
    }
}
