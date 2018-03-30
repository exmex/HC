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
			UInt32 _job;

			Up_JobRewards()
			{
				MessageType = 21;
			}

			Up_JobRewards(const up::job_rewards* job) : Up_JobRewards()
			{
				_job = Convert::ToUInt32(job->_job());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}