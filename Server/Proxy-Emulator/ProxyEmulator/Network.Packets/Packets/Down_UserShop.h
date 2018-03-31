#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _shop_refresh_reply, 9
		public ref struct Down_UserShop : Up_UpMsg
		{
			Down_UserShop()
			{
				MessageType = 9;
			}

			Down_UserShop(const down::user_shop* user) : Down_UserShop()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}