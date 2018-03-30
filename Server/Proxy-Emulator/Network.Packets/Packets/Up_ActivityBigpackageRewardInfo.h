#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _activity_bigpackage_reward_info, 73
		public ref struct Up_ActivityBigpackageRewardInfo : Up_UpMsg
		{
			Up_ActivityBigpackageRewardInfo()
			{
				MessageType = 73;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}