#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _reset_elite_reply, 19
		public ref struct Down_ResetEliteReply : Up_UpMsg
		{
			Down_ResetEliteReply()
			{
				MessageType = 19;
			}

			Down_ResetEliteReply(const down::reset_elite_reply* reset) : Down_ResetEliteReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}