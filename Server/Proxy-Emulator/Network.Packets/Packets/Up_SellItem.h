#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _sell_item, 15
		public ref struct Up_SellItem : Up_UpMsg
		{
			Up_SellItem()
			{
				MessageType = 15;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}