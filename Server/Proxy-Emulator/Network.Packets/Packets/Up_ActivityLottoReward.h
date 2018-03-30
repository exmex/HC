#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _activity_lotto_reward, 71
		public ref struct Up_ActivityLottoReward : Up_UpMsg
		{
			Up_ActivityLottoReward()
			{
				MessageType = 71;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}