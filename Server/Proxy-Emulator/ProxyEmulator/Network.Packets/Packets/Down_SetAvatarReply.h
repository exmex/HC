#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _set_avatar_reply, 35
		public ref struct Down_SetAvatarReply : Up_UpMsg
		{
			Down_SetAvatarReply()
			{
				MessageType = 35;
			}

			Down_SetAvatarReply(const down::set_avatar_reply* set) : Down_SetAvatarReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}