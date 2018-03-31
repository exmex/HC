#include "pb\up.pb.h"
#include <iostream>

#include "Up_QueryReplay.h"
#include "Up_SyncSkillStren.h"

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		public ref struct OpenPanel
		{
			OpenPanel(const up::open_panel* open)
			{

			}
		};

		public ref struct ApplyOpponent
		{
			ApplyOpponent(const up::apply_opponent* apply)
			{

			}
		};

		public ref struct StartBattle
		{
			UInt32 _oppo_user_id;
			List<UInt32> _attack_lineup;

			StartBattle(const up::start_battle* start)
			{
				_oppo_user_id = Convert::ToUInt32(start->_oppo_user_id());
				auto attackLineupList = start->_attack_lineup();
				for(int i = 0; i < attackLineupList.size(); i++)
					_attack_lineup.Add(Convert::ToUInt32(attackLineupList.Get(i)));

			}
		};

		public ref struct EndBattle
		{
			Up_UpMsg::BattleResult _result;

			EndBattle(const up::end_battle* end)
			{
				_result = (Up_UpMsg::BattleResult)Convert::ToInt32(end->_result());
			}
		};

		public ref struct SetLineup
		{
			List<UInt32> _lineup;

			SetLineup(const up::set_lineup* set)
			{
				auto lineupList = set->_lineup();
				for (int i = 0; i < lineupList.size(); i++)
					_lineup.Add(Convert::ToUInt32(lineupList.Get(i)));
			}
		};

		public ref struct QueryRecords
		{
			QueryRecords(const up::query_records* query)
			{

			}
		};

		public ref struct QueryRankboard
		{
			enum class RankboardType
			{
				static_c = 0,
				dynamic = 1,
			};

			RankboardType _type;

			QueryRankboard(const up::query_rankboard* query)
			{
				_type = (RankboardType)Convert::ToInt32(query->_type());
			}
		};

		public ref struct QueryOppoInfo
		{
			UInt32 _oppo_user_id;

			QueryOppoInfo(const up::query_oppo_info* query)
			{
				_oppo_user_id = Convert::ToUInt32(query->_oppo_user_id());
			}
		};

		public ref struct ClearBattleCd
		{
			ClearBattleCd(const up::clear_battle_cd* clear)
			{

			}
		};

		public ref struct DrawRankReward
		{
			DrawRankReward(const up::draw_rank_reward* draw)
			{

			}
		};

		public ref struct BuyBattleChance
		{
			BuyBattleChance(const up::buy_battle_chance* buy)
			{
				
			}
		};

		// _ladder, 33
		public ref struct Up_Ladder : Up_UpMsg
		{
			OpenPanel^ _open_panel;
			ApplyOpponent^ _apply_opponent;
			StartBattle^ _start_battle;
			EndBattle^ _end_battle;
			SetLineup^ _set_lineup;
			QueryRecords^ _query_records;
			Up_QueryReplay^ _query_replay;
			QueryRankboard^ _query_rankboard;
			QueryOppoInfo^ _query_oppo;
			ClearBattleCd^ _clear_battle_cd;
			DrawRankReward^ _draw_rank_reward;
			BuyBattleChance^ _buy_battle_chance;

			Up_Ladder()
			{
				MessageType = 33;
			}

			Up_Ladder(const up::ladder* ladder) : Up_Ladder()
			{
				_open_panel = gcnew OpenPanel(&ladder->_open_panel());
				_apply_opponent = gcnew ApplyOpponent(&ladder->_apply_opponent());
				_start_battle = gcnew StartBattle(&ladder->_start_battle());
				_end_battle = gcnew EndBattle(&ladder->_end_battle());
				_set_lineup = gcnew SetLineup(&ladder->_set_lineup());
				_query_records = gcnew QueryRecords(&ladder->_query_records());
				_query_replay = gcnew Up_QueryReplay(&ladder->_query_replay());
				_query_rankboard = gcnew QueryRankboard(&ladder->_query_rankboard());
				_query_oppo = gcnew QueryOppoInfo(&ladder->_query_oppo());
				_clear_battle_cd = gcnew ClearBattleCd(&ladder->_clear_battle_cd());
				_draw_rank_reward = gcnew DrawRankReward(&ladder->_draw_rank_reward());
				_buy_battle_chance = gcnew BuyBattleChance(&ladder->_buy_battle_chance());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}