#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _every_day_happy, 304
		public ref struct Up_EveryDayHappy : Up_UpMsg
		{
			Up_EveryDayHappy()
			{
				MessageType = 304;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}