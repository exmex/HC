#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _sell_item, 15
		public ref struct Up_SellItem : Up_UpMsg
		{
			// <<amount:11, id:10>>
			List<UInt32> _item;

			Up_SellItem()
			{
				MessageType = 15;
			}

			Up_SellItem(const up::sell_item* sell) : Up_SellItem()
			{
				auto itemList = sell->_item();
				for (int i = 0; i < itemList.size(); i++)
					_item.Add(itemList.Get(i));
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}