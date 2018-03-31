#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _require_rewards_reply, 16
		public ref struct Down_RequireRewardsReply : Up_UpMsg
		{
			Down_RequireRewardsReply()
			{
				MessageType = 16;
			}

			Down_RequireRewardsReply(const down::require_rewards_reply* require) : Down_RequireRewardsReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}