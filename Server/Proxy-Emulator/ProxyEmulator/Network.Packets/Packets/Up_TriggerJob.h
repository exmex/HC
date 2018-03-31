#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _trigger_job, 20
		public ref struct Up_TriggerJob : Up_UpMsg
		{

			List<UInt32> _jobs;

			Up_TriggerJob()
			{
				MessageType = 20;
			}

			Up_TriggerJob(const up::trigger_job* trigger) : Up_TriggerJob()
			{
				auto jobsList = trigger->_jobs();
				for (int i = 0; i < jobsList.size(); i++)
					_jobs.Add(Convert::ToUInt32(jobsList.Get(i)));
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}