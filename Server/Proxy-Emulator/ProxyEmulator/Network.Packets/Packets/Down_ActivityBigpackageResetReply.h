#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _activity_bigpackage_reset_reply, 64
		public ref struct Down_ActivityBigpackageResetReply : Up_UpMsg
		{
			Down_ActivityBigpackageResetReply()
			{
				MessageType = 64;
			}

			Down_ActivityBigpackageResetReply(const down::activity_bigpackage_reset_reply* activity) : Down_ActivityBigpackageResetReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}