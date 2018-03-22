--Author : xinghui
return {
    ["NearActivity"] =
    {
        [1] =
        {
            -- 大乐透
            ["id"] = 1,
            ["name"] = "Lotto",
            ["page"] = LottoPage,
            ["need_vip"] = false,
            ["limit_vip_level"] = 1,
            ["start_time"] = "20141201",
            ["during_time"] = "7",
            -- 以天为单位
            ["need_level"] = true,
            ["limit_level"] = 1,
            ["icon"] = "UI/NB.jpg",
            ["sound"] = "sound/adventure.mp3",
            ["show_name"] = T(LSTR("ACTIVITY.BIGLOTTO"))
        }
    },
    ["OpenServerActivity"] =
    {
        [1] =
        {
            -- 充值返利
            ["id"] = 1,
            ["name"] = "RechargeRebate",
            ["page"] = ActiveRechargeRebatePage,
            ["need_vip"] = false,
            ["limit_vip_level"] = 0,
            ["start_time"] = "20141201",
            ["during_time"] = "7",
            -- 以天为单位
            ["need_level"] = true,
            ["limit_level"] = 1,
            ["min_values"] = 1000,
            -- 最低返还
            ["max_values"] = 10000,
            -- 最高返还
            ["return_days"] = 30,
            -- 返还天数
            ["icon"] = "UI/NB.jpg",
            ["sound"] = "sound/adventure.mp3",
            ["show_name"] = T(LSTR("RECHARGE_REBATE.RECHARGE_REBATE")),
            ["show_type"] = 1
        },
        [2] =
        {
            -- 每日充值
            ["id"] = 2,
            ["name"] = "ContinueRecharge",
            ["page"] = ContinueCharge,
            ["need_vip"] = false,
            ["limit_vip_level"] = 0,
            ["start_time"] = "20141217",
            ["during_time"] = "7",--以天为单位
            ["need_level"] = true,
            ["limit_level"] = 1,
            ["icon"] = "UI/NB.jpg",
            ["sound"] = "sound/adventure.mp3",
            ["show_name"] = T(LSTR("CONTINUECHARGE_BUTTONNAME"))
        }
    },
    ["ChristmasActivity"] =
    {
        [1] =
        {
            -- 大礼包
            ["id"] = 1,
            ["name"] = "BigPackage",
            ["page"] = BigPackagePage,
            ["need_vip"] = false,
            ["limit_vip_level"] = 0,
            ["start_time"] = "20141219",
            ["during_time"] = "7",
            ["need_level"] = true,
            ["limit_level"] = 1,
            ["icon"] = "UI/NB.jpg",
            ["sound"] = "sound/adventure.mp3",
            ["show_name"] = T(LSTR("Big Package")),
            ["boss_appear_count"] = 1,
            ["boss_appear_probability"] = 0.5,
            ["limit_times"] = 3,
            ["big_reward_rank"] = 20
        },
        [2] =
        {
            ["id"] = 2,
            ["name"] = "EveryDayHappy",
            ["page"] = EveryDayHappyPage,
            ["need_vip"] = false,
            ["limit_vip_level"] = 1,
            ["start_time"] = "20141210",
            ["during_time"] = "17",
            ["need_level"] = true,
            ["limit_level"] = 1,
            ["icon"] = "UI/NB.jpg",
            ["sound"] = "sound/adventure.mp3",
            ["show_name"] = T(LSTR("ACTIVITY.EVERYDAYHAPPY"))
        }
    }
}