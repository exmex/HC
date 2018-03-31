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
			enum class Status
			{
				all = 1,
				common = 2,
				vip = 3,
			};

			Status _status;

			Up_AskDailyLogin()
			{
				MessageType = 40;
			}

			Up_AskDailyLogin(const up::ask_daily_login* ask) : Up_AskDailyLogin()
			{
				_status = (Status)Convert::ToInt32(ask->_status());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}