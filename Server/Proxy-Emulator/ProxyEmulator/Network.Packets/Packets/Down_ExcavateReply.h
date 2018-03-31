#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _excavate_reply, 48
		public ref struct Down_ExcavateReply : Up_UpMsg
		{
			Down_ExcavateReply()
			{
				MessageType = 48;
			}

			Down_ExcavateReply(const down::excavate_reply* excavate) : Down_ExcavateReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}