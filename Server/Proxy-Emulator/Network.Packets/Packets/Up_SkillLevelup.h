#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _skill_levelup, 14
		public ref struct Up_SkillLevelup : Up_UpMsg
		{
			UInt32 _heroid;
			List<UInt32> _order; // <<amount:11, slot:4>>

			Up_SkillLevelup()
			{
				MessageType = 14;
			}

			Up_SkillLevelup(const up::skill_levelup* levelup) : Up_SkillLevelup()
			{
				_heroid = levelup->_heroid();

				auto orderList = levelup->_order();
				for (int i = 0; i < orderList.size(); i++)
					_order.Add(orderList.Get(i));
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}
