#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _sdk_login_reply, 34
		public ref struct Down_SdkLoginReply : Up_UpMsg
		{
			Down_SdkLoginReply()
			{
				MessageType = 34;
			}

			Down_SdkLoginReply(const down::sdk_login_reply* sdk) : Down_SdkLoginReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}