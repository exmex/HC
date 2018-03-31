#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _every_day_happy_reply, 304
		public ref struct Down_EveryDayHappyReply : Up_UpMsg
		{
			Down_EveryDayHappyReply()
			{
				MessageType = 304;
			}

			Down_EveryDayHappyReply(const down::every_day_happy_reply* every) : Down_EveryDayHappyReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}