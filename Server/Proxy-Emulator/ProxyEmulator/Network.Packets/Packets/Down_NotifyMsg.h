#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _notify_msg, 36
		public ref struct Down_NotifyMsg : Up_UpMsg
		{
			Down_NotifyMsg()
			{
				MessageType = 36;
			}

			Down_NotifyMsg(const down::notify_msg* notify) : Down_NotifyMsg()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}