#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _get_vip_gift_reply, 42
		public ref struct Down_GetVipGiftReply : Up_UpMsg
		{
			Down_GetVipGiftReply()
			{
				MessageType = 42;
			}

			Down_GetVipGiftReply(const down::get_vip_gift_reply* get) : Down_GetVipGiftReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}