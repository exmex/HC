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
			Up_TriggerJob()
			{
				MessageType = 20;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}