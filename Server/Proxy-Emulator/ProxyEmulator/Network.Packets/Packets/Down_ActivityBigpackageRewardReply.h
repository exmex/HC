#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _activity_bigpackage_reward_reply, 63
		public ref struct Down_ActivityBigpackageRewardReply : Up_UpMsg
		{
			Down_ActivityBigpackageRewardReply()
			{
				MessageType = 63;
			}

			Down_ActivityBigpackageRewardReply(const down::activity_bigpackage_reward_reply* activity) : Down_ActivityBigpackageRewardReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}