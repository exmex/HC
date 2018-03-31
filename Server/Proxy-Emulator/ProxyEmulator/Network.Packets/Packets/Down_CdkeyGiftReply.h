#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _cdkey_gift_reply, 44
		public ref struct Down_CdkeyGiftReply : Up_UpMsg
		{
			Down_CdkeyGiftReply()
			{
				MessageType = 44;
			}

			Down_CdkeyGiftReply(const down::cdkey_gift_reply* cdkey) : Down_CdkeyGiftReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}