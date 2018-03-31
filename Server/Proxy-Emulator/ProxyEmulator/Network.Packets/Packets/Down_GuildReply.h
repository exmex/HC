#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _guild_reply, 45
		public ref struct Down_GuildReply : Up_UpMsg
		{
			Down_GuildReply()
			{
				MessageType = 45;
			}

			Down_GuildReply(const down::guild_reply* guild) : Down_GuildReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}