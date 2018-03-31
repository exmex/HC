#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _change_server_reply, 58
		public ref struct Down_ChangeServerReply : Up_UpMsg
		{
			Down_ChangeServerReply()
			{
				MessageType = 58;
			}

			Down_ChangeServerReply(const down::change_server_reply* change) : Down_ChangeServerReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}