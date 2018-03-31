#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _get_maillist_reply, 39
		public ref struct Down_GetMaillistReply : Up_UpMsg
		{
			Down_GetMaillistReply()
			{
				MessageType = 39;
			}

			Down_GetMaillistReply(const down::get_maillist_reply* get) : Down_GetMaillistReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}