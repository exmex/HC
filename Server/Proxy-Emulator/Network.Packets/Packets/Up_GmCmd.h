#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		public ref struct HeroArousal
		{
			UInt32 _status;
			UInt32 _str;
			UInt32 _agi;
			UInt32 _int;
			Int32 _str_var;
			Int32 _agi_var;
			Int32 _int_var;
			UInt32 _cost_gold;
			UInt32 _cost_diamond;
			UInt32 _aro_exp;

			HeroArousal(const up::hero_arousal* arousal)
			{
				_status = Convert::ToUInt32(arousal->_status());
				_str = Convert::ToUInt32(arousal->_str());
				_agi = Convert::ToUInt32(arousal->_agi());
				_int = Convert::ToUInt32(arousal->_int());
				_str_var = Convert::ToInt32(arousal->_str_var());
				_agi_var = Convert::ToInt32(arousal->_agi_var());
				_int_var = Convert::ToInt32(arousal->_int_var());
				_cost_gold = Convert::ToUInt32(arousal->_cost_gold());
				_cost_diamond = Convert::ToUInt32(arousal->_cost_diamond());
				_aro_exp = Convert::ToUInt32(arousal->_aro_exp());
			}
		};

		public ref struct HeroEquip
		{
			UInt32 _index;
			UInt32 _item_id;
			UInt32 _exp;

			HeroEquip(const up::hero_equip* equip)
			{
				_index = Convert::ToUInt32(equip->_index());
				_item_id = Convert::ToUInt32(equip->_item_id());
				_exp = Convert::ToUInt32(equip->_exp());
			}
		};

		public ref struct Hero
		{
			UInt32 _tid;
			UInt32 _rank;
			UInt32 _level;
			UInt32 _stars;
			UInt32 _exp;
			UInt32 _gs;
			Up_UpMsg::HeroStatus^ _state;
			List<UInt32> _skill_levels;
			List<HeroEquip^> _items;
			HeroArousal^ _arousal;

			Hero(const up::hero* hero)
			{
				_tid = Convert::ToInt32(hero->_tid());
				_rank = Convert::ToInt32(hero->_rank());
				_level = Convert::ToInt32(hero->_level());
				_stars = Convert::ToInt32(hero->_stars());
				_exp = Convert::ToInt32(hero->_exp());
				_gs = Convert::ToInt32(hero->_gs());
				_state = (Up_UpMsg::HeroStatus)hero->_state();

				auto skillLevelsList = hero->_skill_levels();
				for (int i = 0; i < skillLevelsList.size(); i++)
				{
					_skill_levels.Add(skillLevelsList.Get(i));
				}

				auto itemsList = hero->_items();
				for (int i = 0; i < itemsList.size(); i++)
				{
					_items.Add(gcnew HeroEquip(&itemsList.Get(i)));
				}

				_arousal = gcnew HeroArousal(&hero->_arousal());
			}
		};

		public ref struct SetMoney
		{
			enum class price_type
			{
				gold = 0,
				diamond,
				crusadepoint,
				arenapoint,
				guildpoint
			};

			price_type^ _type;
			UInt32 _amount;

			SetMoney(const up::set_money* money)
			{
				_type = (price_type)Convert::ToInt32(money->_type());
				_amount = Convert::ToInt32(money->_amount());
			}
		};

		public ref struct OpenAllGuildStage
		{
			OpenAllGuildStage(const up::open_all_guild_stage* stage)
			{
				
			}
		};

		// _gm_cmd, 7
		public ref struct Up_GmCmd : Up_UpMsg
		{
			Int32 _unlock_all_stages;
			Int32 _get_all_heroes;
			List<Hero^> _set_hero_info;
			Int32 _set_vitality;
			SetMoney^ _set_money;
			Int32 _set_recharge_sum;
			Int32 _set_player_level;
			Int32 _set_player_exp;
			List<UInt32> _set_items;// <<amount:11, id:10>>
			UInt32 _reset_device;
			UInt32 _open_mystery_shop;
			UInt32 _archive_id;
			UInt32 _restore_id;
			Int32 _reset_sweep;
			UInt32 _set_dailylogin_days;
			OpenAllGuildStage^ _open_guild_stage;

			Up_GmCmd()
			{
				MessageType = 7;
			}

			Up_GmCmd(const up::gm_cmd* cmd) : Up_GmCmd()
			{
				_unlock_all_stages = Convert::ToInt32(cmd->_unlock_all_stages());
				_get_all_heroes = Convert::ToInt32(cmd->_get_all_heroes());

				auto heroInfoList = cmd->_set_hero_info();
				for(int i = 0; i < heroInfoList.size(); i++)
					_set_hero_info.Add(gcnew Hero(&heroInfoList.Get(i)));

				_set_vitality = Convert::ToInt32(cmd->_set_vitality());
				_set_money = gcnew SetMoney(&cmd->_set_money());
				_set_recharge_sum = Convert::ToInt32(cmd->_set_recharge_sum());
				_set_player_level = Convert::ToInt32(cmd->_set_player_level());
				_set_player_exp = Convert::ToInt32(cmd->_set_player_exp());

				auto setItemsList = cmd->_set_items();
				for (int i = 0; i < setItemsList.size(); i++)
					_set_items.Add(Convert::ToInt32(setItemsList.Get(i)));

				_reset_device = Convert::ToUInt32(cmd->_reset_device());
				_open_mystery_shop = Convert::ToUInt32(cmd->_open_mystery_shop());
				_archive_id = Convert::ToUInt32(cmd->_archive_id());
				_restore_id = Convert::ToUInt32(cmd->_restore_id());
				_reset_sweep = Convert::ToInt32(cmd->_reset_sweep());
				_set_dailylogin_days = Convert::ToUInt32(cmd->_set_dailylogin_days());
				_open_guild_stage = gcnew OpenAllGuildStage(&cmd->_open_guild_stage());
			}

			static operator Up_GmCmd^(const up::gm_cmd* cmd)
			{
				Up_GmCmd^ _cmd = gcnew Up_GmCmd();
				_cmd->_unlock_all_stages = Convert::ToInt32(cmd->_unlock_all_stages());
				_cmd->_get_all_heroes = Convert::ToInt32(cmd->_get_all_heroes());

				auto heroInfoList = cmd->_set_hero_info();
				for(int i = 0; i < heroInfoList.size(); i++)
					_cmd->_set_hero_info.Add(gcnew Hero(&heroInfoList.Get(i)));

				_cmd->_set_vitality = Convert::ToInt32(cmd->_set_vitality());
				_cmd->_set_money = gcnew SetMoney(&cmd->_set_money());
				_cmd->_set_recharge_sum = Convert::ToInt32(cmd->_set_recharge_sum());
				_cmd->_set_player_level = Convert::ToInt32(cmd->_set_player_level());
				_cmd->_set_player_exp = Convert::ToInt32(cmd->_set_player_exp());

				auto setItemsList = cmd->_set_items();
				for (int i = 0; i < setItemsList.size(); i++)
				{
					_cmd->_set_items.Add(Convert::ToInt32(setItemsList.Get(i)));
				}
				_cmd->_reset_device = Convert::ToUInt32(cmd->_reset_device());
				_cmd->_open_mystery_shop = Convert::ToUInt32(cmd->_open_mystery_shop());
				_cmd->_archive_id = Convert::ToUInt32(cmd->_archive_id());
				_cmd->_restore_id = Convert::ToUInt32(cmd->_restore_id());
				_cmd->_reset_sweep = Convert::ToInt32(cmd->_reset_sweep());
				_cmd->_set_dailylogin_days = Convert::ToUInt32(cmd->_set_dailylogin_days());
				_cmd->_open_guild_stage = gcnew OpenAllGuildStage(&cmd->_open_guild_stage());

				return _cmd;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}