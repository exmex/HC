#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _change_task_status, 65
		public ref struct Up_ChangeTaskStatus : Up_UpMsg
		{
			Up_ChangeTaskStatus()
			{
				MessageType = 65;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}