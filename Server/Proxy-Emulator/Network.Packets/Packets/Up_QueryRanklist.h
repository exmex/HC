#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _query_ranklist, 62
		public ref struct Up_QueryRanklist : Up_UpMsg
		{
			enum class RankType
			{
				guildliveness = 1,
				excavate_rob = 2,
				excavate_gold = 3,
				excavate_exp = 4,
				top_gs = 5,
				full_hero_gs = 6,
				hero_team_gs = 7,
				hero_evo_star = 8,
				hero_arousal = 9,
				top_arena = 10
			};

			RankType _rank_type;

			Up_QueryRanklist()
			{
				MessageType = 62;
			}

			Up_QueryRanklist(const up::query_ranklist* query) : Up_QueryRanklist()
			{
				_rank_type = (RankType)Convert::ToInt32(query->_rank_type());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}