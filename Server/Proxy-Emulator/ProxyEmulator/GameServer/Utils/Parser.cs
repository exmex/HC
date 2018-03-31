/*
while (input.ReadTag(out tag, out field_name)) {
          if(tag == 0 && field_name != null) {
            int field_ordinal = global::System.Array.BinarySearch(_upMsgFieldNames, field_name, global::System.StringComparer.Ordinal);
            if(field_ordinal >= 0)
              tag = _upMsgFieldTags[field_ordinal];
            else {
              if (unknownFields == null) {
                unknownFields = pb::UnknownFieldSet.CreateBuilder(this.UnknownFields);
              }
              ParseUnknownField(input, unknownFields, extensionRegistry, tag, field_name);
              continue;
            }
          }
          switch (tag) {
            case 0: {
              throw pb::InvalidProtocolBufferException.InvalidTag();
            }
            default: {
              if (pb::WireFormat.IsEndGroupTag(tag)) {
                if (unknownFields != null) {
                  this.UnknownFields = unknownFields.Build();
                }
                return this;
              }
              if (unknownFields == null) {
                unknownFields = pb::UnknownFieldSet.CreateBuilder(this.UnknownFields);
              }
              ParseUnknownField(input, unknownFields, extensionRegistry, tag, field_name);
              break;
            }
            case 8: {
              result.hasRepeat = input.ReadUInt32(ref result.repeat_);
              break;
            }
            case 16: {
              result.hasUserId = input.ReadUInt32(ref result.userId_);
              break;
            }
            case 26: {
              global::up.login.Builder subBuilder = global::up.login.CreateBuilder();
              if (result.hasLogin) {
                subBuilder.MergeFrom(Login);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              Login = subBuilder.BuildPartial();
              break;
            }
            case 34: {
              global::up.request_userinfo.Builder subBuilder = global::up.request_userinfo.CreateBuilder();
              if (result.hasRequestUserinfo) {
                subBuilder.MergeFrom(RequestUserinfo);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              RequestUserinfo = subBuilder.BuildPartial();
              break;
            }
            case 42: {
              global::up.enter_stage.Builder subBuilder = global::up.enter_stage.CreateBuilder();
              if (result.hasEnterStage) {
                subBuilder.MergeFrom(EnterStage);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              EnterStage = subBuilder.BuildPartial();
              break;
            }
            case 50: {
              global::up.exit_stage.Builder subBuilder = global::up.exit_stage.CreateBuilder();
              if (result.hasExitStage) {
                subBuilder.MergeFrom(ExitStage);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              ExitStage = subBuilder.BuildPartial();
              break;
            }
            case 58: {
              global::up.gm_cmd.Builder subBuilder = global::up.gm_cmd.CreateBuilder();
              if (result.hasGmCmd) {
                subBuilder.MergeFrom(GmCmd);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              GmCmd = subBuilder.BuildPartial();
              break;
            }
            case 66: {
              global::up.hero_upgrade.Builder subBuilder = global::up.hero_upgrade.CreateBuilder();
              if (result.hasHeroUpgrade) {
                subBuilder.MergeFrom(HeroUpgrade);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              HeroUpgrade = subBuilder.BuildPartial();
              break;
            }
            case 74: {
              global::up.equip_synthesis.Builder subBuilder = global::up.equip_synthesis.CreateBuilder();
              if (result.hasEquipSynthesis) {
                subBuilder.MergeFrom(EquipSynthesis);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              EquipSynthesis = subBuilder.BuildPartial();
              break;
            }
            case 82: {
              global::up.wear_equip.Builder subBuilder = global::up.wear_equip.CreateBuilder();
              if (result.hasWearEquip) {
                subBuilder.MergeFrom(WearEquip);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              WearEquip = subBuilder.BuildPartial();
              break;
            }
            case 90: {
              global::up.consume_item.Builder subBuilder = global::up.consume_item.CreateBuilder();
              if (result.hasConsumeItem) {
                subBuilder.MergeFrom(ConsumeItem);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              ConsumeItem = subBuilder.BuildPartial();
              break;
            }
            case 98: {
              global::up.shop_refresh.Builder subBuilder = global::up.shop_refresh.CreateBuilder();
              if (result.hasShopRefresh) {
                subBuilder.MergeFrom(ShopRefresh);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              ShopRefresh = subBuilder.BuildPartial();
              break;
            }
            case 106: {
              global::up.shop_consume.Builder subBuilder = global::up.shop_consume.CreateBuilder();
              if (result.hasShopConsume) {
                subBuilder.MergeFrom(ShopConsume);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              ShopConsume = subBuilder.BuildPartial();
              break;
            }
            case 114: {
              global::up.skill_levelup.Builder subBuilder = global::up.skill_levelup.CreateBuilder();
              if (result.hasSkillLevelup) {
                subBuilder.MergeFrom(SkillLevelup);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              SkillLevelup = subBuilder.BuildPartial();
              break;
            }
            case 122: {
              global::up.sell_item.Builder subBuilder = global::up.sell_item.CreateBuilder();
              if (result.hasSellItem) {
                subBuilder.MergeFrom(SellItem);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              SellItem = subBuilder.BuildPartial();
              break;
            }
            case 130: {
              global::up.fragment_compose.Builder subBuilder = global::up.fragment_compose.CreateBuilder();
              if (result.hasFragmentCompose) {
                subBuilder.MergeFrom(FragmentCompose);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              FragmentCompose = subBuilder.BuildPartial();
              break;
            }
            case 138: {
              global::up.hero_equip_upgrade.Builder subBuilder = global::up.hero_equip_upgrade.CreateBuilder();
              if (result.hasHeroEquipUpgrade) {
                subBuilder.MergeFrom(HeroEquipUpgrade);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              HeroEquipUpgrade = subBuilder.BuildPartial();
              break;
            }
            case 146: {
              global::up.trigger_task.Builder subBuilder = global::up.trigger_task.CreateBuilder();
              if (result.hasTriggerTask) {
                subBuilder.MergeFrom(TriggerTask);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              TriggerTask = subBuilder.BuildPartial();
              break;
            }
            case 154: {
              global::up.require_rewards.Builder subBuilder = global::up.require_rewards.CreateBuilder();
              if (result.hasRequireRewards) {
                subBuilder.MergeFrom(RequireRewards);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              RequireRewards = subBuilder.BuildPartial();
              break;
            }
            case 162: {
              global::up.trigger_job.Builder subBuilder = global::up.trigger_job.CreateBuilder();
              if (result.hasTriggerJob) {
                subBuilder.MergeFrom(TriggerJob);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              TriggerJob = subBuilder.BuildPartial();
              break;
            }
            case 170: {
              global::up.job_rewards.Builder subBuilder = global::up.job_rewards.CreateBuilder();
              if (result.hasJobRewards) {
                subBuilder.MergeFrom(JobRewards);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              JobRewards = subBuilder.BuildPartial();
              break;
            }
            case 178: {
              global::up.reset_elite.Builder subBuilder = global::up.reset_elite.CreateBuilder();
              if (result.hasResetElite) {
                subBuilder.MergeFrom(ResetElite);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              ResetElite = subBuilder.BuildPartial();
              break;
            }
            case 186: {
              global::up.sweep_stage.Builder subBuilder = global::up.sweep_stage.CreateBuilder();
              if (result.hasSweepStage) {
                subBuilder.MergeFrom(SweepStage);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              SweepStage = subBuilder.BuildPartial();
              break;
            }
            case 194: {
              global::up.buy_vitality.Builder subBuilder = global::up.buy_vitality.CreateBuilder();
              if (result.hasBuyVitality) {
                subBuilder.MergeFrom(BuyVitality);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              BuyVitality = subBuilder.BuildPartial();
              break;
            }
            case 202: {
              global::up.buy_skill_stren_point.Builder subBuilder = global::up.buy_skill_stren_point.CreateBuilder();
              if (result.hasBuySkillStrenPoint) {
                subBuilder.MergeFrom(BuySkillStrenPoint);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              BuySkillStrenPoint = subBuilder.BuildPartial();
              break;
            }
            case 210: {
              global::up.tavern_draw.Builder subBuilder = global::up.tavern_draw.CreateBuilder();
              if (result.hasTavernDraw) {
                subBuilder.MergeFrom(TavernDraw);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              TavernDraw = subBuilder.BuildPartial();
              break;
            }
            case 218: {
              global::up.query_data.Builder subBuilder = global::up.query_data.CreateBuilder();
              if (result.hasQueryData) {
                subBuilder.MergeFrom(QueryData);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              QueryData = subBuilder.BuildPartial();
              break;
            }
            case 226: {
              global::up.hero_evolve.Builder subBuilder = global::up.hero_evolve.CreateBuilder();
              if (result.hasHeroEvolve) {
                subBuilder.MergeFrom(HeroEvolve);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              HeroEvolve = subBuilder.BuildPartial();
              break;
            }
            case 234: {
              global::up.enter_act_stage.Builder subBuilder = global::up.enter_act_stage.CreateBuilder();
              if (result.hasEnterActStage) {
                subBuilder.MergeFrom(EnterActStage);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              EnterActStage = subBuilder.BuildPartial();
              break;
            }
            case 242: {
              global::up.sync_vitality.Builder subBuilder = global::up.sync_vitality.CreateBuilder();
              if (result.hasSyncVitality) {
                subBuilder.MergeFrom(SyncVitality);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              SyncVitality = subBuilder.BuildPartial();
              break;
            }
            case 250: {
              global::up.suspend_report.Builder subBuilder = global::up.suspend_report.CreateBuilder();
              if (result.hasSuspendReport) {
                subBuilder.MergeFrom(SuspendReport);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              SuspendReport = subBuilder.BuildPartial();
              break;
            }
            case 258: {
              global::up.tutorial.Builder subBuilder = global::up.tutorial.CreateBuilder();
              if (result.hasTutorial) {
                subBuilder.MergeFrom(Tutorial);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              Tutorial = subBuilder.BuildPartial();
              break;
            }
            case 266: {
              global::up.ladder.Builder subBuilder = global::up.ladder.CreateBuilder();
              if (result.hasLadder) {
                subBuilder.MergeFrom(Ladder);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              Ladder = subBuilder.BuildPartial();
              break;
            }
            case 274: {
              global::up.set_name.Builder subBuilder = global::up.set_name.CreateBuilder();
              if (result.hasSetName) {
                subBuilder.MergeFrom(SetName);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              SetName = subBuilder.BuildPartial();
              break;
            }
            case 282: {
              global::up.midas.Builder subBuilder = global::up.midas.CreateBuilder();
              if (result.hasMidas) {
                subBuilder.MergeFrom(Midas);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              Midas = subBuilder.BuildPartial();
              break;
            }
            case 290: {
              global::up.open_shop.Builder subBuilder = global::up.open_shop.CreateBuilder();
              if (result.hasOpenShop) {
                subBuilder.MergeFrom(OpenShop);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              OpenShop = subBuilder.BuildPartial();
              break;
            }
            case 298: {
              global::up.charge.Builder subBuilder = global::up.charge.CreateBuilder();
              if (result.hasCharge) {
                subBuilder.MergeFrom(Charge);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              Charge = subBuilder.BuildPartial();
              break;
            }
            case 306: {
              global::up.sdk_login.Builder subBuilder = global::up.sdk_login.CreateBuilder();
              if (result.hasSdkLogin) {
                subBuilder.MergeFrom(SdkLogin);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              SdkLogin = subBuilder.BuildPartial();
              break;
            }
            case 314: {
              global::up.set_avatar.Builder subBuilder = global::up.set_avatar.CreateBuilder();
              if (result.hasSetAvatar) {
                subBuilder.MergeFrom(SetAvatar);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              SetAvatar = subBuilder.BuildPartial();
              break;
            }
            case 322: {
              global::up.ask_daily_login.Builder subBuilder = global::up.ask_daily_login.CreateBuilder();
              if (result.hasAskDailyLogin) {
                subBuilder.MergeFrom(AskDailyLogin);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              AskDailyLogin = subBuilder.BuildPartial();
              break;
            }
            case 330: {
              global::up.tbc.Builder subBuilder = global::up.tbc.CreateBuilder();
              if (result.hasTbc) {
                subBuilder.MergeFrom(Tbc);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              Tbc = subBuilder.BuildPartial();
              break;
            }
            case 338: {
              global::up.get_maillist.Builder subBuilder = global::up.get_maillist.CreateBuilder();
              if (result.hasGetMaillist) {
                subBuilder.MergeFrom(GetMaillist);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              GetMaillist = subBuilder.BuildPartial();
              break;
            }
            case 346: {
              global::up.read_mail.Builder subBuilder = global::up.read_mail.CreateBuilder();
              if (result.hasReadMail) {
                subBuilder.MergeFrom(ReadMail);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              ReadMail = subBuilder.BuildPartial();
              break;
            }
            case 354: {
              global::up.get_svr_time.Builder subBuilder = global::up.get_svr_time.CreateBuilder();
              if (result.hasGetSvrTime) {
                subBuilder.MergeFrom(GetSvrTime);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              GetSvrTime = subBuilder.BuildPartial();
              break;
            }
            case 362: {
              global::up.get_vip_gift.Builder subBuilder = global::up.get_vip_gift.CreateBuilder();
              if (result.hasGetVipGift) {
                subBuilder.MergeFrom(GetVipGift);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              GetVipGift = subBuilder.BuildPartial();
              break;
            }
            case 370: {
              result.hasImportantDataMd5 = input.ReadString(ref result.importantDataMd5_);
              break;
            }
            case 378: {
              global::up.chat.Builder subBuilder = global::up.chat.CreateBuilder();
              if (result.hasChat) {
                subBuilder.MergeFrom(Chat);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              Chat = subBuilder.BuildPartial();
              break;
            }
            case 386: {
              global::up.cdkey_gift.Builder subBuilder = global::up.cdkey_gift.CreateBuilder();
              if (result.hasCdkeyGift) {
                subBuilder.MergeFrom(CdkeyGift);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              CdkeyGift = subBuilder.BuildPartial();
              break;
            }
            case 394: {
              global::up.guild.Builder subBuilder = global::up.guild.CreateBuilder();
              if (result.hasGuild) {
                subBuilder.MergeFrom(Guild);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              Guild = subBuilder.BuildPartial();
              break;
            }
            case 402: {
              global::up.ask_magicsoul.Builder subBuilder = global::up.ask_magicsoul.CreateBuilder();
              if (result.hasAskMagicsoul) {
                subBuilder.MergeFrom(AskMagicsoul);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              AskMagicsoul = subBuilder.BuildPartial();
              break;
            }
            case 410: {
              global::up.ask_activity_info.Builder subBuilder = global::up.ask_activity_info.CreateBuilder();
              if (result.hasAskActivityInfo) {
                subBuilder.MergeFrom(AskActivityInfo);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              AskActivityInfo = subBuilder.BuildPartial();
              break;
            }
            case 418: {
              global::up.excavate.Builder subBuilder = global::up.excavate.CreateBuilder();
              if (result.hasExcavate) {
                subBuilder.MergeFrom(Excavate);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              Excavate = subBuilder.BuildPartial();
              break;
            }
            case 426: {
              global::up.push_notify.Builder subBuilder = global::up.push_notify.CreateBuilder();
              if (result.hasPushNotify) {
                subBuilder.MergeFrom(PushNotify);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              PushNotify = subBuilder.BuildPartial();
              break;
            }
            case 434: {
              global::up.system_setting.Builder subBuilder = global::up.system_setting.CreateBuilder();
              if (result.hasSystemSetting) {
                subBuilder.MergeFrom(SystemSetting);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              SystemSetting = subBuilder.BuildPartial();
              break;
            }
            case 442: {
              global::up.query_split_data.Builder subBuilder = global::up.query_split_data.CreateBuilder();
              if (result.hasQuerySplitData) {
                subBuilder.MergeFrom(QuerySplitData);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              QuerySplitData = subBuilder.BuildPartial();
              break;
            }
            case 450: {
              global::up.query_split_return.Builder subBuilder = global::up.query_split_return.CreateBuilder();
              if (result.hasQuerySplitReturn) {
                subBuilder.MergeFrom(QuerySplitReturn);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              QuerySplitReturn = subBuilder.BuildPartial();
              break;
            }
            case 458: {
              global::up.split_hero.Builder subBuilder = global::up.split_hero.CreateBuilder();
              if (result.hasSplitHero) {
                subBuilder.MergeFrom(SplitHero);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              SplitHero = subBuilder.BuildPartial();
              break;
            }
            case 466: {
              global::up.worldcup.Builder subBuilder = global::up.worldcup.CreateBuilder();
              if (result.hasWorldcup) {
                subBuilder.MergeFrom(Worldcup);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              Worldcup = subBuilder.BuildPartial();
              break;
            }
            case 474: {
              global::up.report_battle.Builder subBuilder = global::up.report_battle.CreateBuilder();
              if (result.hasReportBattle) {
                subBuilder.MergeFrom(ReportBattle);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              ReportBattle = subBuilder.BuildPartial();
              break;
            }
            case 482: {
              global::up.query_replay.Builder subBuilder = global::up.query_replay.CreateBuilder();
              if (result.hasQueryReplay) {
                subBuilder.MergeFrom(QueryReplay);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              QueryReplay = subBuilder.BuildPartial();
              break;
            }
            case 490: {
              global::up.sync_skill_stren.Builder subBuilder = global::up.sync_skill_stren.CreateBuilder();
              if (result.hasSyncSkillStren) {
                subBuilder.MergeFrom(SyncSkillStren);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              SyncSkillStren = subBuilder.BuildPartial();
              break;
            }
            case 498: {
              global::up.query_ranklist.Builder subBuilder = global::up.query_ranklist.CreateBuilder();
              if (result.hasQueryRanklist) {
                subBuilder.MergeFrom(QueryRanklist);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              QueryRanklist = subBuilder.BuildPartial();
              break;
            }
            case 506: {
              global::up.change_server.Builder subBuilder = global::up.change_server.CreateBuilder();
              if (result.hasChangeServer) {
                subBuilder.MergeFrom(ChangeServer);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              ChangeServer = subBuilder.BuildPartial();
              break;
            }
            case 514: {
              global::up.require_arousal.Builder subBuilder = global::up.require_arousal.CreateBuilder();
              if (result.hasRequireArousal) {
                subBuilder.MergeFrom(RequireArousal);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              RequireArousal = subBuilder.BuildPartial();
              break;
            }
            case 522: {
              global::up.change_task_status.Builder subBuilder = global::up.change_task_status.CreateBuilder();
              if (result.hasChangeTaskStatus) {
                subBuilder.MergeFrom(ChangeTaskStatus);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              ChangeTaskStatus = subBuilder.BuildPartial();
              break;
            }
            case 530: {
              global::up.request_guild_log.Builder subBuilder = global::up.request_guild_log.CreateBuilder();
              if (result.hasRequestGuildLog) {
                subBuilder.MergeFrom(RequestGuildLog);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              RequestGuildLog = subBuilder.BuildPartial();
              break;
            }
            case 538: {
              global::up.query_act_stage.Builder subBuilder = global::up.query_act_stage.CreateBuilder();
              if (result.hasQueryActStage) {
                subBuilder.MergeFrom(QueryActStage);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              QueryActStage = subBuilder.BuildPartial();
              break;
            }
            case 546: {
              global::up.request_upgrade_arousal_level.Builder subBuilder = global::up.request_upgrade_arousal_level.CreateBuilder();
              if (result.hasRequestUpgradeArousalLevel) {
                subBuilder.MergeFrom(RequestUpgradeArousalLevel);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              RequestUpgradeArousalLevel = subBuilder.BuildPartial();
              break;
            }
            case 554: {
              global::up.activity_info.Builder subBuilder = global::up.activity_info.CreateBuilder();
              if (result.hasActivityInfo) {
                subBuilder.MergeFrom(ActivityInfo);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              ActivityInfo = subBuilder.BuildPartial();
              break;
            }
            case 562: {
              global::up.activity_lotto_info.Builder subBuilder = global::up.activity_lotto_info.CreateBuilder();
              if (result.hasActivityLottoInfo) {
                subBuilder.MergeFrom(ActivityLottoInfo);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              ActivityLottoInfo = subBuilder.BuildPartial();
              break;
            }
            case 570: {
              global::up.activity_lotto_reward.Builder subBuilder = global::up.activity_lotto_reward.CreateBuilder();
              if (result.hasActivityLottoReward) {
                subBuilder.MergeFrom(ActivityLottoReward);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              ActivityLottoReward = subBuilder.BuildPartial();
              break;
            }
            case 578: {
              global::up.activity_bigpackage_info.Builder subBuilder = global::up.activity_bigpackage_info.CreateBuilder();
              if (result.hasActivityBigpackageInfo) {
                subBuilder.MergeFrom(ActivityBigpackageInfo);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              ActivityBigpackageInfo = subBuilder.BuildPartial();
              break;
            }
            case 586: {
              global::up.activity_bigpackage_reward_info.Builder subBuilder = global::up.activity_bigpackage_reward_info.CreateBuilder();
              if (result.hasActivityBigpackageRewardInfo) {
                subBuilder.MergeFrom(ActivityBigpackageRewardInfo);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              ActivityBigpackageRewardInfo = subBuilder.BuildPartial();
              break;
            }
            case 594: {
              global::up.activity_bigpackage_reset.Builder subBuilder = global::up.activity_bigpackage_reset.CreateBuilder();
              if (result.hasActivityBigpackageReset) {
                subBuilder.MergeFrom(ActivityBigpackageReset);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              ActivityBigpackageReset = subBuilder.BuildPartial();
              break;
            }
            case 2402: {
              global::up.fb_attention.Builder subBuilder = global::up.fb_attention.CreateBuilder();
              if (result.hasFbAttention) {
                subBuilder.MergeFrom(FbAttention);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              FbAttention = subBuilder.BuildPartial();
              break;
            }
            case 2410: {
              global::up.dot_info.Builder subBuilder = global::up.dot_info.CreateBuilder();
              if (result.hasDotInfo) {
                subBuilder.MergeFrom(DotInfo);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              DotInfo = subBuilder.BuildPartial();
              break;
            }
            case 2418: {
              global::up.continue_pay.Builder subBuilder = global::up.continue_pay.CreateBuilder();
              if (result.hasContinuePay) {
                subBuilder.MergeFrom(ContinuePay);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              ContinuePay = subBuilder.BuildPartial();
              break;
            }
            case 2426: {
              global::up.recharge_rebate.Builder subBuilder = global::up.recharge_rebate.CreateBuilder();
              if (result.hasRechargeRebate) {
                subBuilder.MergeFrom(RechargeRebate);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              RechargeRebate = subBuilder.BuildPartial();
              break;
            }
            case 2434: {
              global::up.every_day_happy.Builder subBuilder = global::up.every_day_happy.CreateBuilder();
              if (result.hasEveryDayHappy) {
                subBuilder.MergeFrom(EveryDayHappy);
              }
              input.ReadMessage(subBuilder, extensionRegistry);
              EveryDayHappy = subBuilder.BuildPartial();
              break;
            }
          }
        }
*/