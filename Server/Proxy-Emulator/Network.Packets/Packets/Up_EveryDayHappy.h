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
			UInt32 _every_day_happy;

			Up_EveryDayHappy()
			{
				MessageType = 304;
			}

			Up_EveryDayHappy(const up::every_day_happy* everyday) : Up_EveryDayHappy()
			{
				_every_day_happy = Convert::ToUInt32(everyday->_every_day_happy());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}