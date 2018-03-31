#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _consume_item_reply, 8
		public ref struct Down_ConsumeItemReply : Up_UpMsg
		{
			Down_ConsumeItemReply()
			{
				MessageType = 8;
			}

			Down_ConsumeItemReply(const down::consume_item_reply* consume) : Down_ConsumeItemReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}