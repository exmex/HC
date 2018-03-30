#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _query_data, 27
		public ref struct Up_QueryData : Up_UpMsg
		{
			enum class QueryType
			{
				rmb = 1,
				hero = 2,
				recharge = 3,
				monthcard = 4
			};

			List<QueryType> _type;
			List<UInt32> _query_heroes;
			List<UInt32> _month_card_id;

			Up_QueryData()
			{
				MessageType = 27;
			}

			Up_QueryData(const up::query_data* query) : Up_QueryData()
			{
				auto typeList = query->_type();
				for (int i = 0; i < typeList.size(); i++)
					_type.Add((QueryType)Convert::ToInt32(typeList.Get(i)));

				auto queryHeroesList = query->_query_heroes();
				for (int i = 0; i < queryHeroesList.size(); i++)
					_query_heroes.Add(queryHeroesList.Get(i));

				auto monthCardIdList = query->_month_card_id();
				for (int i = 0; i < monthCardIdList.size(); i++)
					_month_card_id.Add(monthCardIdList.Get(i));
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}