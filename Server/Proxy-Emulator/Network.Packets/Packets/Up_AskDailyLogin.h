#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _ask_daily_login, 40
		public ref struct Up_AskDailyLogin : Up_UpMsg
		{
			Up_AskDailyLogin()
			{
				MessageType = 40;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}