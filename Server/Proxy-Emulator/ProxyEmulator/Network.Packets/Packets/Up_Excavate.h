#include "pb\up.pb.h"
#include <iostream>

#include "Up_QueryReplay.h"

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		public ref struct ExcavateHero
		{
			UInt32 _heroid;
			UInt32 _hp_perc;
			UInt32 _mp_perc;
			UInt32 _custom_data;

			ExcavateHero(const up::excavate_hero* excavate)
			{
				_heroid = Convert::ToUInt32(excavate->_heroid());
				_hp_perc = Convert::ToUInt32(excavate->_hp_perc());
				_mp_perc = Convert::ToUInt32(excavate->_mp_perc());
				_custom_data = Convert::ToUInt32(excavate->_custom_data());
			}
		};

		public ref struct SearchExcavate
		{
			SearchExcavate(const up::search_excavate* search)
			{

			}

		};

		public ref struct QueryExcavateData
		{
			QueryExcavateData(const up::query_excavate_data* query)
			{

			}

		};

		public ref struct QueryExcavateHistory
		{
			QueryExcavateHistory(const up::query_excavate_history* query)
			{

			}

		};

		public ref struct QueryExcavateBattle
		{
			String^ _id;

			QueryExcavateBattle(const up::query_excavate_battle* query)
			{
				_id = gcnew String(query->_id().c_str());
			}

		};

		public ref struct SetExcavateTeam
		{
			UInt32 _excavate_id;
			List<UInt32> _tid;

			SetExcavateTeam(const up::set_excavate_team* set)
			{
				_excavate_id = Convert::ToUInt32(set->_excavate_id());
				auto tidList = set->_tid();
				for (int i = 0; i < tidList.size(); i++)
					_tid.Add(Convert::ToUInt32(tidList.Get(i)));
			}

		};

		public ref struct ExcavateStartBattle
		{
			List<UInt32> _heroids;
			UInt32 _excavate_id;
			UInt32 _team_id;
			UInt32 _team_svr_id;
			UInt32 _use_hire;

			ExcavateStartBattle(const up::excavate_start_battle* excavate)
			{
				auto heroList = excavate->_heroids();
				for (int i = 0; i < heroList.size(); i++)
					_heroids.Add(Convert::ToUInt32(heroList.Get(i)));
				_excavate_id = Convert::ToUInt32(excavate->_excavate_id());
				_team_id = Convert::ToUInt32(excavate->_team_id());
				_team_svr_id = Convert::ToUInt32(excavate->_team_svr_id());
				_use_hire = Convert::ToUInt32(excavate->_use_hire());
			}

		};

		public ref struct ExcavateEndBattle
		{
			Up_UpMsg::BattleResult _result; // default victory
			List<ExcavateHero^> _self_heroes;
			List<ExcavateHero^> _oppo_heroes;
			List<UInt32> _operations;
			UInt32 _type_id;

			ExcavateEndBattle()
			{
				_result = Up_UpMsg::BattleResult::victory;
			}

			ExcavateEndBattle(const up::excavate_end_battle* excavate) : ExcavateEndBattle()
			{
				if (excavate->has__result())
					_result = (Up_UpMsg::BattleResult)Convert::ToInt32(excavate->_result());

				auto selfHeroList = excavate->_self_heroes();
				for (int i = 0; i < selfHeroList.size(); i++)
					_self_heroes.Add(gcnew ExcavateHero(&selfHeroList.Get(i)));

				auto oppoHeroList = excavate->_oppo_heroes();
				for (int i = 0; i < oppoHeroList.size(); i++)
					_oppo_heroes.Add(gcnew ExcavateHero(&oppoHeroList.Get(i)));

				auto operationList = excavate->_oprations();
				for (int i = 0; i < operationList.size(); i++)
					_operations.Add(Convert::ToUInt32(operationList.Get(i)));

				_type_id = Convert::ToUInt32(excavate->_type_id());
			}

		};

		public ref struct QueryExcavateDef
		{
			UInt32 _mine_id;
			UInt32 _applier_uid;

			QueryExcavateDef(const up::query_excavate_def* query)
			{
				_mine_id = Convert::ToUInt32(query->_mine_id());
				_applier_uid = Convert::ToUInt32(query->_applier_uid());
			}

		};

		public ref struct ClearExcavateBattle
		{
			ClearExcavateBattle(const up::clear_excavate_battle* clear)
			{

			}

		};

		public ref struct WithdrawExcavateHero
		{
			UInt32 _hero_id;

			WithdrawExcavateHero(const up::withdraw_excavate_hero* withdraw)
			{
				_hero_id = Convert::ToUInt32(withdraw->_hero_id());
			}

		};

		public ref struct DrawExcavateDefRwd
		{
			String^ _id;

			DrawExcavateDefRwd(const up::draw_excavate_def_rwd* draw)
			{
				_id = gcnew String(draw->_id().c_str());
			}

		};

		public ref struct DropExcavate
		{
			UInt32 _mine_id;

			DropExcavate(const up::drop_excavate* drop)
			{
				_mine_id = Convert::ToUInt32(drop->_mine_id());
			}

		};

		// _excavate, 52
		public ref struct Up_Excavate : Up_UpMsg
		{
			SearchExcavate^ _search_excavate;
			QueryExcavateData^ _query_excavate_data;
			QueryExcavateHistory^ _query_excavate_history;
			QueryExcavateBattle^ _query_excavate_battle;
			SetExcavateTeam^ _set_excavate_team;
			ExcavateStartBattle^ _excavate_start_battle;
			ExcavateEndBattle^ _excavate_end_battle;
			QueryExcavateDef^ _query_excavate_def;
			ClearExcavateBattle^ _clear_excavate_battle;
			WithdrawExcavateHero^ _withdraw_excavate_hero;
			DrawExcavateDefRwd^ _draw_excavate_def_rwd;
			DropExcavate^ _drop_excavate;
			Up_QueryReplay^ _query_replay;

			Up_Excavate()
			{
				MessageType = 52;
			}

			Up_Excavate(const up::excavate* excavate) : Up_Excavate()
			{
				_search_excavate = gcnew SearchExcavate(&excavate->_search_excavate());
				_query_excavate_data = gcnew	QueryExcavateData(&excavate->_query_excavate_data());
				_query_excavate_history = gcnew QueryExcavateHistory(&excavate->_query_excavate_history());
				_query_excavate_battle = gcnew QueryExcavateBattle(&excavate->_query_excavate_battle());
				_set_excavate_team = gcnew SetExcavateTeam(&excavate->_set_excavate_team());
				_excavate_start_battle = gcnew ExcavateStartBattle(&excavate->_excavate_start_battle());
				_excavate_end_battle = gcnew ExcavateEndBattle(&excavate->_excavate_end_battle());
				_query_excavate_def = gcnew QueryExcavateDef(&excavate->_query_excavate_def());
				_clear_excavate_battle = gcnew ClearExcavateBattle(&excavate->_clear_excavate_battle());
				_withdraw_excavate_hero = gcnew WithdrawExcavateHero(&excavate->_withdraw_excavate_hero());
				_draw_excavate_def_rwd = gcnew DrawExcavateDefRwd(&excavate->_draw_excavate_def_rwd());
				_drop_excavate = gcnew DropExcavate(&excavate->_drop_excavate());
				_query_replay = gcnew Up_QueryReplay(&excavate->_query_replay());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}