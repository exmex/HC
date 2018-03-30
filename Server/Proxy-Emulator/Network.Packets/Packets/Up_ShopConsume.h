#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _shop_consume, 13
		public ref struct Up_ShopConsume : Up_UpMsg
		{
			// Shop Id
			UInt32 _sid;

			// Slot Id
			UInt32 _slotid;

			// The number of items to buy
			UInt32 _amount;

			Up_ShopConsume()
			{
				MessageType = 13;
			}

			Up_ShopConsume(const up::shop_consume* consume) : Up_ShopConsume()
			{
				_sid = Convert::ToUInt32(consume->_sid());
				_slotid = Convert::ToUInt32(consume->_slotid());
				_amount = Convert::ToUInt32(consume->_amount());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}