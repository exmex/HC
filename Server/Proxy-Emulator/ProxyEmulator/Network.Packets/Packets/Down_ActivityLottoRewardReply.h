#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _activity_lotto_reward_reply, 61
		public ref struct Down_ActivityLottoRewardReply : Up_UpMsg
		{
			Down_ActivityLottoRewardReply()
			{
				MessageType = 61;
			}

			Down_ActivityLottoRewardReply(const down::activity_lotto_reward_reply* activity) : Down_ActivityLottoRewardReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}