#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _buy_vitality, 24
		public ref struct Up_BuyVitality : Up_UpMsg
		{
			Up_BuyVitality()
			{
				MessageType = 24;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}