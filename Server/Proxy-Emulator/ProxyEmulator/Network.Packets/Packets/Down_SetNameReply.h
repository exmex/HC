#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _set_name_reply, 30
		public ref struct Down_SetNameReply : Up_UpMsg
		{
			Down_SetNameReply()
			{
				MessageType = 30;
			}

			Down_SetNameReply(const down::set_name_reply* set) : Down_SetNameReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}