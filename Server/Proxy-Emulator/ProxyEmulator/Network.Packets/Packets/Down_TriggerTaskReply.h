#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _trigger_task_reply, 15
		public ref struct Down_TriggerTaskReply : Up_UpMsg
		{
			Down_TriggerTaskReply()
			{
				MessageType = 15;
			}

			Down_TriggerTaskReply(const down::trigger_task_reply* trigger) : Down_TriggerTaskReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}