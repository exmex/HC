// Network.h

#include "pb\up.pb.h"
#include "Packets\Up_UpMsg.h"
#include "Packets\Up_Login.h"
#include "Packets\Up_SdkLogin.h"
#include "Packets\Up_SystemSettingChange.h"

#include "Packets\Up_ActivityBigpackageInfo.h"
#include "Packets\Up_ActivityBigpackageReset.h"
#include "Packets\Up_ActivityBigpackageRewardInfo.h"
#include "Packets\Up_ActivityInfo.h"
#include "Packets\Up_ActivityLottoInfo.h"
#include "Packets\Up_ActivityLottoReward.h"
#include "Packets\Up_AskActivityInfo.h"
#include "Packets\Up_AskDailyLogin.h"
#include "Packets\Up_AskMagicsoul.h"
#include "Packets\Up_BuySkillStrenPoint.h"
#include "Packets\Up_BuyVitality.h"
#include "Packets\Up_CdkeyGift.h"
#include "Packets\Up_ChangeServer.h"
#include "Packets\Up_ChangeTaskStatus.h"
#include "Packets\Up_Charge.h"
#include "Packets\Up_Chat.h"
#include "Packets\Up_ConsumeItem.h"
#include "Packets\Up_ContinuePay.h"
#include "Packets\Up_DotInfo.h"
#include "Packets\Up_EnterActStage.h"
#include "Packets\Up_EnterStage.h"
#include "Packets\Up_EquipSynthesis.h"
#include "Packets\Up_EveryDayHappy.h"
#include "Packets\Up_Excavate.h"
#include "Packets\Up_ExitStage.h"
#include "Packets\Up_FbAttention.h"
#include "Packets\Up_FragmentCompose.h"
#include "Packets\Up_GetMaillist.h"
#include "Packets\Up_GetSvrTime.h"
#include "Packets\Up_GetVipGift.h"
#include "Packets\Up_GmCmd.h"
#include "Packets\Up_Guild.h"
#include "Packets\Up_HeroEquipUpgrade.h"
#include "Packets\Up_HeroEvolve.h"
#include "Packets\Up_HeroUpgrade.h"
#include "Packets\Up_JobRewards.h"
#include "Packets\Up_Ladder.h"
#include "Packets\Up_Midas.h"
#include "Packets\Up_OpenShop.h"
#include "Packets\Up_PushNotify.h"
#include "Packets\Up_QueryActStage.h"
#include "Packets\Up_QueryData.h"
#include "Packets\Up_QueryRanklist.h"
#include "Packets\Up_QueryReplay.h"
#include "Packets\Up_QuerySplitData.h"
#include "Packets\Up_QuerySplitReturn.h"
#include "Packets\Up_ReadMail.h"
#include "Packets\Up_RechargeRebate.h"
#include "Packets\Up_ReportBattle.h"
#include "Packets\Up_RequestGuildLog.h"
#include "Packets\Up_RequestUpgradeArousalLevel.h"
#include "Packets\Up_RequestUserinfo.h"
#include "Packets\Up_RequireArousal.h"
#include "Packets\Up_RequireRewards.h"
#include "Packets\Up_ResetElite.h"
#include "Packets\Up_SellItem.h"
#include "Packets\Up_SetAvatar.h"
#include "Packets\Up_SetName.h"
#include "Packets\Up_ShopConsume.h"
#include "Packets\Up_ShopRefresh.h"
#include "Packets\Up_SkillLevelup.h"
#include "Packets\Up_SplitHero.h"
#include "Packets\Up_String.h"
#include "Packets\Up_SuspendReport.h"
#include "Packets\Up_SweepStage.h"
#include "Packets\Up_SyncSkillStren.h"
#include "Packets\Up_SyncVitality.h"
#include "Packets\Up_TavernDraw.h"
#include "Packets\Up_Tbc.h"
#include "Packets\Up_TriggerJob.h"
#include "Packets\Up_TriggerTask.h"
#include "Packets\Up_Tutorial.h"
#include "Packets\Up_WearEquip.h"
#include "Packets\Up_Worldcup.h"

#include "pb\down.pb.h"

#include "Packets\Down_LoginReply.h"
#include "Packets\Down_Reset.h"
#include "Packets\Down_EnterStageReply.h"
#include "Packets\Down_ExitStageReply.h"
#include "Packets\Down_HeroUpgradeReply.h"
#include "Packets\Down_EquipSynthesisReply.h"
#include "Packets\Down_WearEquipReply.h"
#include "Packets\Down_ConsumeItemReply.h"
#include "Packets\Down_UserShop.h"
#include "Packets\Down_ShopConsumeReply.h"
#include "Packets\Down_SkillLevelupReply.h"
#include "Packets\Down_SellItemReply.h"
#include "Packets\Down_FragmentComposeReply.h"
#include "Packets\Down_HeroEquipUpgradeReply.h"
#include "Packets\Down_TriggerTaskReply.h"
#include "Packets\Down_RequireRewardsReply.h"
#include "Packets\Down_TriggerJobReply.h"
#include "Packets\Down_JobRewardsReply.h"
#include "Packets\Down_ResetEliteReply.h"
#include "Packets\Down_SweepStageReply.h"
#include "Packets\Down_TavernDrawReply.h"
#include "Packets\Down_SyncSkillStrenReply.h"
#include "Packets\Down_QueryDataReply.h"
#include "Packets\Down_HeroEvolveReply.h"
#include "Packets\Down_SyncVitalityReply.h"
#include "Packets\Down_UserCheck.h"
#include "Packets\Down_TutorialReply.h"
#include "Packets\Down_ErrorInfo.h"
#include "Packets\Down_LadderReply.h"
#include "Packets\Down_SetNameReply.h"
#include "Packets\Down_MidasReply.h"
#include "Packets\Down_OpenShopReply.h"
#include "Packets\Down_ChargeReply.h"
#include "Packets\Down_SdkLoginReply.h"
#include "Packets\Down_SetAvatarReply.h"
#include "Packets\Down_NotifyMsg.h"
#include "Packets\Down_AskDailyLoginReply.h"
#include "Packets\Down_TbcReply.h"
#include "Packets\Down_GetMaillistReply.h"
#include "Packets\Down_ReadMailReply.h"
#include "Packets\Down_GetVipGiftReply.h"
#include "Packets\Down_ChatReply.h"
#include "Packets\Down_CdkeyGiftReply.h"
#include "Packets\Down_GuildReply.h"
#include "Packets\Down_AskMagicsoulReply.h"
#include "Packets\Down_ActivityInfos.h"
#include "Packets\Down_ExcavateReply.h"
#include "Packets\Down_SystemSettingReply.h"
#include "Packets\Down_QuerySplitDataReply.h"
#include "Packets\Down_QuerySplitReturnReply.h"
#include "Packets\Down_SplitHeroReply.h"
#include "Packets\Down_WorldcupReply.h"
#include "Packets\Down_BattleCheckFail.h"
#include "Packets\Down_QueryReplay.h"
#include "Packets\Down_SuperLink.h"
#include "Packets\Down_QueryRanklistReply.h"
#include "Packets\Down_ChangeServerReply.h"
#include "Packets\Down_ActivityInfoReply.h"
#include "Packets\Down_ActivityLottoInfoReply.h"
#include "Packets\Down_ActivityLottoRewardReply.h"
#include "Packets\Down_ActivityBigpackageInfoReply.h"
#include "Packets\Down_ActivityBigpackageRewardReply.h"
#include "Packets\Down_ActivityBigpackageResetReply.h"
#include "Packets\Down_FbAttentionReply.h"
#include "Packets\Down_ContinuePayReply.h"
#include "Packets\Down_RechargeRebateReply.h"
#include "Packets\Down_EveryDayHappyReply.h"

#include <iostream>
#pragma once

#define ARRAY_LENGTH(array) (sizeof(array)*sizeof((array)[0]))

using namespace System;
using namespace System::Collections::Generic;

namespace Network {
	namespace Packets {

		public ref class Class1
		{
		public:
			static array<Byte>^ ParseDownMsg()
			{
				down::down_msg* msg = new down::down_msg();

				array<Byte>^ data = gcnew array<Byte>(msg->ByteSize());
				pin_ptr<unsigned char> data_pin = &data[0];
				unsigned char* data_ptr = data_pin;

				msg->SerializeToArray(data_ptr, data->Length);

				return data;
			}

			static List<Up_UpMsg^>^ ParseUpMsg(array<Byte>^ data)
			{
				int dataLen = data->Length;
				pin_ptr<unsigned char> data_pin = &data[0];
				unsigned char* data_ptr = data_pin;
				/*char* data_ptr = new char[74]{
					'\x08', '\x00', '\x10', '\x01', '\x1A', '\x33', '\x08', '\x00', '\x12', '\x0B', '\x77', '\x69', '\x6E', '\x33', '\x32', '\x5F', '\x61', '\x64', '\x6D', '\x69', '\x6E', '\x1A', '\x20', '\x34', '\x37', '\x62', '\x32', '\x36', '\x30', '\x37', '\x62', '\x39', '\x34', '\x31', '\x61', '\x37', '\x61', '\x62', '\x63', '\x35', '\x61', '\x63', '\x34', '\x65', '\x32', '\x30', '\x38', '\x30', '\x65', '\x38', '\x31', '\x36', '\x31', '\x32', '\x33', '\x20', '\x00', '\xB2', '\x02', '\x0E', '\x0A', '\x0A', '\x33', '\x33', '\x33', '\x33', '\x33', '\x33', '\x33', '\x33', '\x33', '\x33', '\x10', '\x00'
				};*/
				up::up_msg* msg = new up::up_msg();

				msg->ParseFromArray(data_ptr, dataLen);

				List<Up_UpMsg^>^ messages = gcnew List<Up_UpMsg^>(2);

				Up_UpMsg^ up_msg = gcnew Up_UpMsg(msg);
				messages->Add(up_msg);

				/*if (msg->has__login())
				{
					Up_Login^ login = gcnew Up_Login(&msg->_login());
					messages->Add(login);
				}

				if (msg->has__sdk_login())
				{
					Up_SdkLogin^ sdkLogin = gcnew Up_SdkLogin(&msg->_sdk_login());
					messages->Add(sdkLogin);
				}

				if (msg->has__system_setting())
				{
					Up_SystemSetting^ systemSetting = gcnew Up_SystemSetting(&msg->_system_setting());
					messages->Add(systemSetting);
				}

				if(msg->has__enter_stage())
				{
					Up_EnterStage^ enterStage = gcnew Up_EnterStage(&msg->_enter_stage());
					messages->Add(enterStage);
				}*/

				if (msg->has__login())
					messages->Add(gcnew Up_Login(&msg->_login()));

				if (msg->has__request_userinfo())
					messages->Add(gcnew Up_RequestUserinfo(&msg->_request_userinfo()));

				if (msg->has__enter_stage())
					messages->Add(gcnew Up_EnterStage(&msg->_enter_stage()));

				if (msg->has__exit_stage())
					messages->Add(gcnew Up_ExitStage(&msg->_exit_stage()));

				if (msg->has__gm_cmd())
					messages->Add(gcnew Up_GmCmd(&msg->_gm_cmd()));

				if (msg->has__hero_upgrade())
					messages->Add(gcnew Up_HeroUpgrade(&msg->_hero_upgrade()));

				if (msg->has__equip_synthesis())
					messages->Add(gcnew Up_EquipSynthesis(&msg->_equip_synthesis()));

				if (msg->has__wear_equip())
					messages->Add(gcnew Up_WearEquip(&msg->_wear_equip()));

				if (msg->has__consume_item())
					messages->Add(gcnew Up_ConsumeItem(&msg->_consume_item()));

				if (msg->has__shop_refresh())
					messages->Add(gcnew Up_ShopRefresh(&msg->_shop_refresh()));

				if (msg->has__shop_consume())
					messages->Add(gcnew Up_ShopConsume(&msg->_shop_consume()));

				if (msg->has__skill_levelup())
					messages->Add(gcnew Up_SkillLevelup(&msg->_skill_levelup()));

				if (msg->has__sell_item())
					messages->Add(gcnew Up_SellItem(&msg->_sell_item()));

				if (msg->has__fragment_compose())
					messages->Add(gcnew Up_FragmentCompose(&msg->_fragment_compose()));

				if (msg->has__hero_equip_upgrade())
					messages->Add(gcnew Up_HeroEquipUpgrade(&msg->_hero_equip_upgrade()));

				if (msg->has__trigger_task())
					messages->Add(gcnew Up_TriggerTask(&msg->_trigger_task()));

				if (msg->has__require_rewards())
					messages->Add(gcnew Up_RequireRewards(&msg->_require_rewards()));

				if (msg->has__trigger_job())
					messages->Add(gcnew Up_TriggerJob(&msg->_trigger_job()));

				if (msg->has__job_rewards())
					messages->Add(gcnew Up_JobRewards(&msg->_job_rewards()));

				if (msg->has__reset_elite())
					messages->Add(gcnew Up_ResetElite(&msg->_reset_elite()));

				if (msg->has__sweep_stage())
					messages->Add(gcnew Up_SweepStage(&msg->_sweep_stage()));

				if (msg->has__buy_vitality())
					messages->Add(gcnew Up_BuyVitality(&msg->_buy_vitality()));

				if (msg->has__buy_skill_stren_point())
					messages->Add(gcnew Up_BuySkillStrenPoint(&msg->_buy_skill_stren_point()));

				if (msg->has__tavern_draw())
					messages->Add(gcnew Up_TavernDraw(&msg->_tavern_draw()));

				if (msg->has__query_data())
					messages->Add(gcnew Up_QueryData(&msg->_query_data()));

				if (msg->has__hero_evolve())
					messages->Add(gcnew Up_HeroEvolve(&msg->_hero_evolve()));

				if (msg->has__enter_act_stage())
					messages->Add(gcnew Up_EnterActStage(&msg->_enter_act_stage()));

				if (msg->has__sync_vitality())
					messages->Add(gcnew Up_SyncVitality(&msg->_sync_vitality()));

				if (msg->has__suspend_report())
					messages->Add(gcnew Up_SuspendReport(&msg->_suspend_report()));

				if (msg->has__tutorial())
					messages->Add(gcnew Up_Tutorial(&msg->_tutorial()));

				if (msg->has__ladder())
					messages->Add(gcnew Up_Ladder(&msg->_ladder()));

				if (msg->has__set_name())
					messages->Add(gcnew Up_SetName(&msg->_set_name()));

				if (msg->has__midas())
					messages->Add(gcnew Up_Midas(&msg->_midas()));

				if (msg->has__open_shop())
					messages->Add(gcnew Up_OpenShop(&msg->_open_shop()));

				if (msg->has__charge())
					messages->Add(gcnew Up_Charge(&msg->_charge()));

				if (msg->has__sdk_login())
					messages->Add(gcnew Up_SdkLogin(&msg->_sdk_login()));

				if (msg->has__set_avatar())
					messages->Add(gcnew Up_SetAvatar(&msg->_set_avatar()));

				if (msg->has__ask_daily_login())
					messages->Add(gcnew Up_AskDailyLogin(&msg->_ask_daily_login()));

				if (msg->has__tbc())
					messages->Add(gcnew Up_Tbc(&msg->_tbc()));

				if (msg->has__get_maillist())
					messages->Add(gcnew Up_GetMaillist(&msg->_get_maillist()));

				if (msg->has__read_mail())
					messages->Add(gcnew Up_ReadMail(&msg->_read_mail()));

				if (msg->has__get_svr_time())
					messages->Add(gcnew Up_GetSvrTime(&msg->_get_svr_time()));

				if (msg->has__get_vip_gift())
					messages->Add(gcnew Up_GetVipGift(&msg->_get_vip_gift()));

				if (msg->has__chat())
					messages->Add(gcnew Up_Chat(&msg->_chat()));

				if (msg->has__cdkey_gift())
					messages->Add(gcnew Up_CdkeyGift(&msg->_cdkey_gift()));

				if (msg->has__guild())
					messages->Add(gcnew Up_Guild(&msg->_guild()));

				if (msg->has__ask_magicsoul())
					messages->Add(gcnew Up_AskMagicsoul(&msg->_ask_magicsoul()));

				if (msg->has__ask_activity_info())
					messages->Add(gcnew Up_AskActivityInfo(&msg->_ask_activity_info()));

				if (msg->has__excavate())
					messages->Add(gcnew Up_Excavate(&msg->_excavate()));

				if (msg->has__push_notify())
					messages->Add(gcnew Up_PushNotify(&msg->_push_notify()));

				if (msg->has__system_setting())
					messages->Add(gcnew Up_SystemSetting(&msg->_system_setting()));

				if (msg->has__query_split_data())
					messages->Add(gcnew Up_QuerySplitData(&msg->_query_split_data()));

				if (msg->has__query_split_return())
					messages->Add(gcnew Up_QuerySplitReturn(&msg->_query_split_return()));

				if (msg->has__split_hero())
					messages->Add(gcnew Up_SplitHero(&msg->_split_hero()));

				if (msg->has__worldcup())
					messages->Add(gcnew Up_Worldcup(&msg->_worldcup()));

				if (msg->has__report_battle())
					messages->Add(gcnew Up_ReportBattle(&msg->_report_battle()));

				if (msg->has__query_replay())
					messages->Add(gcnew Up_QueryReplay(&msg->_query_replay()));

				if (msg->has__sync_skill_stren())
					messages->Add(gcnew Up_SyncSkillStren(&msg->_sync_skill_stren()));

				if (msg->has__query_ranklist())
					messages->Add(gcnew Up_QueryRanklist(&msg->_query_ranklist()));

				if (msg->has__change_server())
					messages->Add(gcnew Up_ChangeServer(&msg->_change_server()));

				if (msg->has__require_arousal())
					messages->Add(gcnew Up_RequireArousal(&msg->_require_arousal()));

				if (msg->has__change_task_status())
					messages->Add(gcnew Up_ChangeTaskStatus(&msg->_change_task_status()));

				if (msg->has__request_guild_log())
					messages->Add(gcnew Up_RequestGuildLog(&msg->_request_guild_log()));

				if (msg->has__query_act_stage())
					messages->Add(gcnew Up_QueryActStage(&msg->_query_act_stage()));

				if (msg->has__request_upgrade_arousal_level())
					messages->Add(gcnew Up_RequestUpgradeArousalLevel(&msg->_request_upgrade_arousal_level()));

				if (msg->has__fb_attention())
					messages->Add(gcnew Up_FbAttention(&msg->_fb_attention()));

				if (msg->has__dot_info())
					messages->Add(gcnew Up_DotInfo(&msg->_dot_info()));

				if (msg->has__activity_info())
					messages->Add(gcnew Up_ActivityInfo(&msg->_activity_info()));

				if (msg->has__activity_lotto_info())
					messages->Add(gcnew Up_ActivityLottoInfo(&msg->_activity_lotto_info()));

				if (msg->has__activity_lotto_reward())
					messages->Add(gcnew Up_ActivityLottoReward(&msg->_activity_lotto_reward()));

				if (msg->has__activity_bigpackage_info())
					messages->Add(gcnew Up_ActivityBigpackageInfo(&msg->_activity_bigpackage_info()));

				if (msg->has__activity_bigpackage_reward_info())
					messages->Add(gcnew Up_ActivityBigpackageRewardInfo(&msg->_activity_bigpackage_reward_info()));

				if (msg->has__activity_bigpackage_reset())
					messages->Add(gcnew Up_ActivityBigpackageReset(&msg->_activity_bigpackage_reset()));

				if (msg->has__continue_pay())
					messages->Add(gcnew Up_ContinuePay(&msg->_continue_pay()));

				if (msg->has__recharge_rebate())
					messages->Add(gcnew Up_RechargeRebate(&msg->_recharge_rebate()));

				if (msg->has__every_day_happy())
					messages->Add(gcnew Up_EveryDayHappy(&msg->_every_day_happy()));




				return messages;
			}
		};
	}
}
