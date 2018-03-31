#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _worldcup_reply, 53
		public ref struct Down_WorldcupReply : Up_UpMsg
		{
			Down_WorldcupReply()
			{
				MessageType = 53;
			}

			Down_WorldcupReply(const down::worldcup_reply* worldcup) : Down_WorldcupReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}