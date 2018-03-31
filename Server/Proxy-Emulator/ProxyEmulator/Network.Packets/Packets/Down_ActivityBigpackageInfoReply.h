#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _activity_bigpackage_info_reply, 62
		public ref struct Down_ActivityBigpackageInfoReply : Up_UpMsg
		{
			Down_ActivityBigpackageInfoReply()
			{
				MessageType = 62;
			}

			Down_ActivityBigpackageInfoReply(const down::activity_bigpackage_info_reply* activity) : Down_ActivityBigpackageInfoReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}