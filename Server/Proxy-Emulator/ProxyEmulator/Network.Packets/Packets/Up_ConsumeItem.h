#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _consume_item, 11
		// Eat experience Dan, first add this agreement
		// Later, if there are other prop consumption methods, you need to modify/consolidate this protocol.
		public ref struct Up_ConsumeItem : Up_UpMsg
		{
			// Want to eat experience hero hero typeid
			UInt32 _hero_id;

			// To eat the id and number of experience sheets <<amount:11, id:10>>
			UInt32 _item_id;

			Up_ConsumeItem()
			{
				MessageType = 11;
			}

			Up_ConsumeItem(const up::consume_item* item) : Up_ConsumeItem()
			{
				_hero_id = Convert::ToUInt32(item->_hero_id());
				_item_id = Convert::ToUInt32(item->_item_id());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}