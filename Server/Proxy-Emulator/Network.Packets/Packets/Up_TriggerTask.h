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
			Up_TriggerTask()
			{
				MessageType = 18;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}