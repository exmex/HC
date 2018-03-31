#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _job_rewards_reply, 18
		public ref struct Down_JobRewardsReply : Up_UpMsg
		{
			Down_JobRewardsReply()
			{
				MessageType = 18;
			}

			Down_JobRewardsReply(const down::job_rewards_reply* job) : Down_JobRewardsReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}