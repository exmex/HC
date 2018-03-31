#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		public ref struct TbcHero
		{
			UInt32 _heroid;
			UInt32 _hp_perc;
			UInt32 _mp_perc;
			UInt32 _custom_data;

			TbcHero(const up::tbc_hero* tbc)
			{
				_heroid = Convert::ToUInt32(tbc->_heroid());
				_hp_perc = Convert::ToUInt32(tbc->_hp_perc());
				_mp_perc = Convert::ToUInt32(tbc->_mp_perc());
				_custom_data = Convert::ToUInt32(tbc->_custom_data());
			}
		};

		public ref struct TbcOpenPanel
		{
			TbcOpenPanel(const up::tbc_open_panel* tbc)
			{
				
			}
		};

		public ref struct TbcQueryOppo
		{
			UInt32 _stage_id;

			TbcQueryOppo(const up::tbc_query_oppo* tbc)
			{
				_stage_id = Convert::ToUInt32(tbc->_stage_id());
			}
		};

		public ref struct TbcStartBattle
		{
			List<UInt32> _heroids;
			UInt32 _use_hire;

			TbcStartBattle(const up::tbc_start_battle* tbc)
			{
				auto heroidsList = tbc->_heroids();
				for (int i = 0; i < heroidsList.size(); i++)
					_heroids.Add(Convert::ToUInt32(heroidsList.Get(i)));
				_use_hire = Convert::ToUInt32(tbc->_use_hire());
			}
		};

		public ref struct TbcEndBattle
		{				   
			Up_UpMsg::BattleResult _result; //[default = victory];
			List<TbcHero^> _self_heroes;
			List<TbcHero^> _oppo_heroes;

			// <<replacement:8, op:2, wave_idx:3, tick:10, hero_pos:3>>
			// op = 0: cast skill
			// op = 1: revive hero
			List<UInt32>   _operations;

			TbcEndBattle()
			{
				_result = Up_UpMsg::BattleResult::victory;
			}

			TbcEndBattle(const up::tbc_end_battle* tbc) : TbcEndBattle()
			{
				if (tbc->has__result())
					_result = (Up_UpMsg::BattleResult)Convert::ToInt32(tbc->_result());

				auto selfHeroesList = tbc->_self_heroes();
				for (int i = 0; i < selfHeroesList.size(); i++)
					_self_heroes.Add(gcnew TbcHero(&selfHeroesList.Get(i)));

				auto oppoHeroesList = tbc->_oppo_heroes();
				for (int i = 0; i < oppoHeroesList.size(); i++)
					_oppo_heroes.Add(gcnew TbcHero(&oppoHeroesList.Get(i)));

				auto operationsList = tbc->_oprations();
				for (int i = 0; i < operationsList.size(); i++)
					_operations.Add(Convert::ToUInt32(operationsList.Get(i)));
			}
		};

		public ref struct TbcReset
		{
			TbcReset(const up::tbc_reset* tbc)
			{

			}
			
		};

		public ref struct TbcDrawReward
		{
			UInt32 _stage_id;

			TbcDrawReward(const up::tbc_draw_reward* tbc)
			{
				_stage_id = Convert::ToUInt32(tbc->_stage_id());
			}
		};

		// _tbc, 41
		public ref struct Up_Tbc : Up_UpMsg
		{
			TbcOpenPanel^ _open_panel;
			TbcQueryOppo^ _query_oppo;
			TbcStartBattle^ _start_bat;
			TbcEndBattle^ _end_bat;
			TbcReset^ _reset;
			TbcDrawReward^ _draw_reward;

			Up_Tbc()
			{
				MessageType = 41;
			}

			Up_Tbc(const up::tbc* tbc) : Up_Tbc()
			{
				_open_panel = gcnew TbcOpenPanel(&tbc->_open_panel());
				_query_oppo = gcnew TbcQueryOppo(&tbc->_query_oppo());
				_start_bat = gcnew TbcStartBattle(&tbc->_start_bat());
				_end_bat = gcnew TbcEndBattle(&tbc->_end_bat());
				_reset = gcnew TbcReset(&tbc->_reset());
				_draw_reward = gcnew TbcDrawReward(&tbc->_draw_reward());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}