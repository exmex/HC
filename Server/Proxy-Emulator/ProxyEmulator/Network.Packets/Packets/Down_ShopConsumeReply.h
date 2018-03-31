#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _shop_consume_reply, 10
		public ref struct Down_ShopConsumeReply : Up_UpMsg
		{
			Down_ShopConsumeReply()
			{
				MessageType = 10;
			}

			Down_ShopConsumeReply(const down::shop_consume_reply* shop) : Down_ShopConsumeReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}