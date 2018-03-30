#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _shop_refresh, 12
		public ref struct Up_ShopRefresh : Up_UpMsg
		{
			Up_ShopRefresh()
			{
				MessageType = 12;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}