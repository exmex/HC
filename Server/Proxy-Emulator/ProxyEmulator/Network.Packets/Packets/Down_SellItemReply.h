#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _sell_item_reply, 12
		public ref struct Down_SellItemReply : Up_UpMsg
		{
			Down_SellItemReply()
			{
				MessageType = 12;
			}

			Down_SellItemReply(const down::sell_item_reply* sell) : Down_SellItemReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}