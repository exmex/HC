#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _shop_consume, 13
		public ref struct Up_ShopConsume : Up_UpMsg
		{
			Up_ShopConsume()
			{
				MessageType = 13;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}