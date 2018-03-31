#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _trigger_job_reply, 17
		public ref struct Down_TriggerJobReply : Up_UpMsg
		{
			Down_TriggerJobReply()
			{
				MessageType = 17;
			}

			Down_TriggerJobReply(const down::trigger_job_reply* trigger) : Down_TriggerJobReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}