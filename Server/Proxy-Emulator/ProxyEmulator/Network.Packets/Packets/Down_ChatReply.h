#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _chat_reply, 43
		public ref struct Down_ChatReply : Up_UpMsg
		{
			Down_ChatReply()
			{
				MessageType = 43;
			}

			Down_ChatReply(const down::chat_reply* chat) : Down_ChatReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}