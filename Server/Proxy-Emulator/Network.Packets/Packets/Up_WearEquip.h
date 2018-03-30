#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _wear_equip, 10
		public ref struct Up_WearEquip : Up_UpMsg
		{
			// The hero to wear equipment type id
			UInt32 _hero_id;

			// Equipment to wear: 1 - 6
			UInt32 _item_pos;

			Up_WearEquip()
			{
				MessageType = 10;
			}

			Up_WearEquip(const up::wear_equip* equip) : Up_WearEquip()
			{
				_hero_id = Convert::ToUInt32(equip->_hero_id());
				_item_pos = Convert::ToUInt32(equip->_item_pos());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}