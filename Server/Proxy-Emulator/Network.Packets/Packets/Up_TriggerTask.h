#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _trigger_task, 18
		public ref struct Up_TriggerTask : Up_UpMsg
		{
			// <<LINE:16, ID:16>>
			List<UInt32> _task;

			Up_TriggerTask()
			{
				MessageType = 18;
			}

			Up_TriggerTask(const up::trigger_task* trigger) : Up_TriggerTask()
			{
				auto taskList = trigger->_task();
				for (int i = 0; i < taskList.size(); i++)
					_task.Add(taskList.Get(i));
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}