#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _ladder_reply, 29
		public ref struct Down_LadderReply : Up_UpMsg
		{
			Down_LadderReply()
			{
				MessageType = 29;
			}

			Down_LadderReply(const down::ladder_reply* ladder) : Down_LadderReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}