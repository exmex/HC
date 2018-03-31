#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		public ref struct GuildCreate
		{
			String^ _name;
			UInt32 _avatar;

			GuildCreate(const up::guild_create* guild)
			{
				_name = gcnew String(guild->_name().c_str());
				_avatar = Convert::ToUInt32(guild->_avatar());
			}

		};

		public ref struct GuildDismiss
		{
			GuildDismiss(const up::guild_dismiss* guild)
			{

			}

		};

		public ref struct GuildList
		{
			GuildList(const up::guild_list* guild)
			{

			}

		};

		public ref struct GuildSearch
		{
			UInt32 _guild_id;

			GuildSearch(const up::guild_search* guild)
			{
				_guild_id = Convert::ToUInt32(guild->_guild_id());
			}

		};

		public ref struct GuildJoin
		{
			UInt32 _guild_id;

			GuildJoin(const up::guild_join* guild)
			{
				_guild_id = Convert::ToUInt32(guild->_guild_id());
			}

		};

		public ref struct GuildJoinConfirm
		{
			enum class ConfirmType
			{
				accept = 1,
				reject = 2,
			};

			UInt32 _uid;
			ConfirmType _type; // default = accept

			GuildJoinConfirm()
			{
				_type = ConfirmType::accept;
			}

			GuildJoinConfirm(const up::guild_join_confirm* guild) : GuildJoinConfirm()
			{
				_uid = Convert::ToUInt32(guild->_uid());
				_type = (ConfirmType)Convert::ToInt32(guild->_type());
			}

		};

		public ref struct GuildLeave
		{
			GuildLeave(const up::guild_leave* guild)
			{

			}

		};

		public ref struct GuildKick
		{
			UInt32 _uid;

			GuildKick(const up::guild_kick* guild)
			{
				_uid = Convert::ToUInt32(guild->_uid());
			}

		};

		public ref struct GuildSet
		{
			enum class GuildJoinT
			{
				no_verify = 1,
				verify = 2,
				closed = 3,
			};

			UInt32 _avatar;
			GuildJoinT _join_type;
			UInt32 _join_limit;
			String^ _slogan;
			UInt32 _can_jump;

			GuildSet(const up::guild_set* guild)
			{
				_avatar = Convert::ToUInt32(guild->_avatar());
				_join_type = (GuildJoinT)Convert::ToInt32(guild->_join_type());
				_join_limit = Convert::ToUInt32(guild->_join_limit());
				_slogan = gcnew String(guild->_slogan().c_str());
				_can_jump = Convert::ToUInt32(guild->_can_jump());
			}

		};

		public ref struct GuildQuery
		{
			GuildQuery(const up::guild_query* guild)
			{

			}

		};

		public ref struct GuildOpenPanel
		{
			GuildOpenPanel(const up::guild_open_pannel* guild)
			{

			}

		};

		public ref struct GuildSetJob
		{
			UInt32 _uid;
			Up_UpMsg::GuildJobT _job;

			GuildSetJob(const up::guild_set_job* guild)
			{
				_uid = Convert::ToUInt32(guild->_uid());
				_job = (Up_UpMsg::GuildJobT)Convert::ToInt32(guild->_job());
			}

		};

		public ref struct GuildAddHire
		{
			UInt32 _heroid;
			
			GuildAddHire(const up::guild_add_hire* guild)
			{
				_heroid = Convert::ToUInt32(guild->_heroid());
			}

		};

		public ref struct GuildDelHire
		{
			UInt32 _heroid;

			GuildDelHire(const up::guild_del_hire* guild)
			{
				_heroid = Convert::ToUInt32(guild->_heroid());
			}

		};

		public ref struct GuildQueryHires
		{
			Up_UpMsg::HireFrom _from;

			GuildQueryHires(const up::guild_query_hires* guild)
			{
				_from = (Up_UpMsg::HireFrom)Convert::ToInt32(guild->_from());
			}

		};

		public ref struct GuildHireHero
		{
			UInt32 _uid;
			UInt32 _heroid;
			Up_UpMsg::HireFrom _from;
			UInt32 _stage_id;

			GuildHireHero(const up::guild_hire_hero* guild)
			{
				_uid = Convert::ToUInt32(guild->_uid());
				_heroid = Convert::ToUInt32(guild->_heroid());
				_from = (Up_UpMsg::HireFrom)Convert::ToInt32(guild->_from());
				_stage_id = Convert::ToUInt32(guild->_stage_id());
			}

		};

		public ref struct GuildWorshipReq
		{
			UInt32 _uid;
			UInt32 _id;

			GuildWorshipReq(const up::guild_worship_req* guild)
			{
				_id = Convert::ToUInt32(guild->_id());
				_uid = Convert::ToUInt32(guild->_uid());

			}

		};

		public ref struct GuildWorshipWithdraw
		{
			GuildWorshipWithdraw(const up::guild_worship_withdraw* guild)
			{

			}

		};

		public ref struct GuildQureyHhDetail
		{
			UInt32 _uid;
			UInt32 _heroid;

			GuildQureyHhDetail(const up::guild_qurey_hh_detail* guild)
			{
				_uid = Convert::ToUInt32(guild->_uid());
				_heroid = Convert::ToUInt32(guild->_heroid());
			}

		};

		public ref struct GuildInstanceQuery
		{
			GuildInstanceQuery(const up::guild_instance_query* guild)
			{

			}

		};

		public ref struct GuildInstanceDetail
		{
			UInt32 _stage_id;

			GuildInstanceDetail(const up::guild_instance_detail* guild)
			{
				_stage_id = Convert::ToUInt32(guild->_stage_id());
			}

		};

		public ref struct GuildInstanceStart
		{
			UInt32 _stage_id;

			GuildInstanceStart(const up::guild_instance_start* guild)
			{
				_stage_id = Convert::ToUInt32(guild->_stage_id());
			}

		};

		public ref struct GuildInstanceEnd
		{
			Up_UpMsg::BattleResult _result;
			List<UInt32> _hp_info;
			UInt32 _wave;
			UInt32 _damage;
			UInt32 _progress;
			UInt32 _stage_progress;

			// <<replacement:8, op:2, wave_idx:3, tick:10, hero_pos:3>>
			// op = 0: cast skill
			// op = 1: revive hero
			List<UInt32> _operations;

			// hero type id
			List<UInt32> _heroes;

			GuildInstanceEnd(const up::guild_instance_end* guild)
			{
				_result = (Up_UpMsg::BattleResult)Convert::ToInt32(guild->_result());
				auto hpInfoList = guild->_hp_info();
				for (int i = 0; i < hpInfoList.size(); i++)
					_hp_info.Add(Convert::ToUInt32(hpInfoList.Get(i)));
				_wave = Convert::ToUInt32(guild->_wave());
				_damage = Convert::ToUInt32(guild->_damage());
				_progress = Convert::ToUInt32(guild->_progress());
				_stage_progress = Convert::ToUInt32(guild->_stage_progress());

				auto operationsList = guild->_oprations();
				for (int i = 0; i < operationsList.size(); i++)
					_operations.Add(Convert::ToUInt32(operationsList.Get(i)));
				auto heroesList = guild->_heroes();
				for (int i = 0; i < heroesList.size(); i++)
					_heroes.Add(Convert::ToUInt32(heroesList.Get(i)));
			}

		};

		public ref struct GuildInstanceDrop
		{
			UInt32 _raid_id;

			GuildInstanceDrop(const up::guild_instance_drop* guild)
			{
				_raid_id = Convert::ToUInt32(guild->_raid_id());
			}

		};

		public ref struct GuildInstanceOpen
		{
			UInt32 _raid_id;

			GuildInstanceOpen(const up::guild_instance_open* guild)
			{
				_raid_id = Convert::ToUInt32(guild->_raid_id());
			}

		};

		public ref struct GuildInstanceApply
		{
			UInt32 _raid_id;
			UInt32 _item_id;

			GuildInstanceApply(const up::guild_instance_apply* guild)
			{
				_raid_id = Convert::ToUInt32(guild->_raid_id());
				_item_id = Convert::ToUInt32(guild->_item_id());
			}

		};

		public ref struct GuildDropInfo
		{
			GuildDropInfo(const up::guild_drop_info* guild)
			{

			}

		};

		public ref struct GuildDropGive
		{
			UInt32 _item_id;
			UInt32 _raid_id;
			UInt32 _user_id;
			UInt32 _time_out_end;

			GuildDropGive(const up::guild_drop_give* guild)
			{
				_item_id = Convert::ToUInt32(guild->_item_id());
				_raid_id = Convert::ToUInt32(guild->_raid_id());
				_user_id = Convert::ToUInt32(guild->_user_id());
				_time_out_end = Convert::ToUInt32(guild->_time_out_end());
			}

		};

		public ref struct GuildInstanceDamage
		{
			UInt32 _raid_id;

			GuildInstanceDamage(const up::guild_instance_damage* guild)
			{
				_raid_id = Convert::ToUInt32(guild->_raid_id());
			}

		};

		public ref struct GuildItemsHistory
		{
			GuildItemsHistory(const up::guild_items_history* guild)
			{

			}

		};

		public ref struct GuildJump
		{
			GuildJump(const up::guild_jump* guild)
			{

			}

		};

		public ref struct GuildAppQueue
		{
			UInt32 _item_id;

			GuildAppQueue(const up::guild_app_queue* guild)
			{
				_item_id = Convert::ToUInt32(guild->_item_id());
			}

		};

		public ref struct GuildPrepareInstance
		{
			UInt32 _stage_id;

			GuildPrepareInstance(const up::guild_prepare_instance* guild)
			{
				_stage_id = Convert::ToUInt32(guild->_stage_id());
			}

		};

		public ref struct GuildQueryMember
		{
			GuildQueryMember(const up::guild_query_member* guild)
			{

			}

		};

		public ref struct GuildStageRank
		{
			UInt32 _stage_id;

			GuildStageRank(const up::guild_stage_rank* guild)
			{
				_stage_id = Convert::ToUInt32(guild->_stage_id());
			}

		};

		public ref struct GuildSetJump
		{
			enum class IsCanJump
			{
				no = 1,
				yes = 2,
			};

			IsCanJump _is_can_jump;

			GuildSetJump(const up::guild_set_jump* guild)
			{
				_is_can_jump = (IsCanJump)Convert::ToInt32(guild->_is_can_jump());
			}

		};

		// _guild, 49
		public ref struct Up_Guild : Up_UpMsg
		{
			GuildCreate^ _create;
			GuildDismiss^ _dismiss;
			GuildList^ _list;
			GuildSearch^ _search;
			GuildJoin^ _join;
			GuildJoinConfirm^ _join_confirm;
			GuildLeave^ _guild_leave;
			GuildKick^ _kick;
			GuildSet^ _set;
			GuildQuery^ _query;
			GuildOpenPanel^ _open_panel;
			GuildSetJob^ _set_job;
			GuildAddHire^ _add_hire;
			GuildDelHire^ _del_hire;
			GuildQueryHires^ _query_hires;
			GuildHireHero^ _hire_hero;
			GuildWorshipReq^ _worship_req;
			GuildWorshipWithdraw^ _worship_withdraw;
			GuildQureyHhDetail^ _query_hh_detail;
			GuildInstanceQuery^ _instance_query;
			GuildInstanceDetail^ _instance_detail;
			GuildInstanceStart^ _instance_start;
			GuildInstanceEnd^ _instance_end;
			GuildInstanceDrop^ _instance_drop;
			GuildInstanceOpen^ _instance_open;
			GuildInstanceApply^ _instance_apply;
			GuildDropInfo^ _drop_info;
			GuildDropGive^ _drop_give;
			GuildInstanceDamage^ _instance_damage;
			GuildItemsHistory^ _items_history;
			GuildJump^ _guild_jump;
			GuildAppQueue^ _guild_app_queue;
			GuildPrepareInstance^ _instance_prepare;
			GuildQueryMember^ _guild_query_member;
			GuildStageRank^ _guild_stage_rank;
			GuildSetJump^ _set_jump;

			Up_Guild()
			{
				MessageType = 49;
			}

			Up_Guild(const up::guild* guild) : Up_Guild()
			{
				_create = gcnew GuildCreate(&guild->_create());
				_dismiss = gcnew GuildDismiss(&guild->_dismiss());
				_list = gcnew GuildList(&guild->_list());
				_search = gcnew GuildSearch(&guild->_search());
				_join = gcnew GuildJoin(&guild->_join());
				_join_confirm = gcnew GuildJoinConfirm(&guild->_join_confirm());
				_guild_leave = gcnew GuildLeave(&guild->_guild_leave());
				_kick = gcnew GuildKick(&guild->_kick());
				_set = gcnew GuildSet(&guild->_set());
				_query = gcnew GuildQuery(&guild->_query());
				_open_panel = gcnew GuildOpenPanel(&guild->_open_pannel());
				_set_job = gcnew GuildSetJob(&guild->_set_job());
				_add_hire = gcnew GuildAddHire(&guild->_add_hire());
				_del_hire = gcnew GuildDelHire(&guild->_del_hire());
				_query_hires = gcnew GuildQueryHires(&guild->_query_hires());
				_hire_hero = gcnew GuildHireHero(&guild->_hire_hero());
				_worship_req = gcnew GuildWorshipReq(&guild->_worship_req());
				_worship_withdraw = gcnew GuildWorshipWithdraw(&guild->_worship_withdraw());
				_query_hh_detail = gcnew GuildQureyHhDetail(&guild->_query_hh_detail());
				_instance_query = gcnew GuildInstanceQuery(&guild->_instance_query());
				_instance_detail = gcnew GuildInstanceDetail(&guild->_instance_detail());
				_instance_start = gcnew GuildInstanceStart(&guild->_instance_start());
				_instance_end = gcnew GuildInstanceEnd(&guild->_instance_end());
				_instance_drop = gcnew GuildInstanceDrop(&guild->_instance_drop());
				_instance_open = gcnew GuildInstanceOpen(&guild->_instance_open());
				_instance_apply = gcnew GuildInstanceApply(&guild->_instance_apply());
				_drop_info = gcnew GuildDropInfo(&guild->_drop_info());
				_drop_give = gcnew GuildDropGive(&guild->_drop_give());
				_instance_damage = gcnew GuildInstanceDamage(&guild->_instance_damage());
				_items_history = gcnew GuildItemsHistory(&guild->_items_history());
				_guild_jump = gcnew GuildJump(&guild->_guild_jump());
				_guild_app_queue = gcnew GuildAppQueue(&guild->_guild_app_queue());
				_instance_prepare = gcnew GuildPrepareInstance(&guild->_instance_prepare());
				_guild_query_member = gcnew GuildQueryMember(&guild->_guild_query_member());
				_guild_stage_rank = gcnew GuildStageRank(&guild->_guild_stage_rank());
				_set_jump = gcnew GuildSetJump(&guild->_set_jump());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}