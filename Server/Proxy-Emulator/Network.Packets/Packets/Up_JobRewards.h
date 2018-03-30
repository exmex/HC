#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _job_rewards, 21
		public ref struct Up_JobRewards : Up_UpMsg
		{
			Up_JobRewards()
			{
				MessageType = 21;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}