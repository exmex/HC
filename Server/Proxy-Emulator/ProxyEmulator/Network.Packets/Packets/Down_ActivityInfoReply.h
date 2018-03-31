#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _activity_info_reply, 59
		public ref struct Down_ActivityInfoReply : Up_UpMsg
		{
			Down_ActivityInfoReply()
			{
				MessageType = 59;
			}

			Down_ActivityInfoReply(const down::activity_info_reply* optionalactivity) : Down_ActivityInfoReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}