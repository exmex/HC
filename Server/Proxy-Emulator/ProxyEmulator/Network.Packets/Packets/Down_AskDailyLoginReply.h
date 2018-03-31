#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _ask_daily_login_reply, 37
		public ref struct Down_AskDailyLoginReply : Up_UpMsg
		{
			Down_AskDailyLoginReply()
			{
				MessageType = 37;
			}

			Down_AskDailyLoginReply(const down::ask_daily_login_reply* ask) : Down_AskDailyLoginReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}