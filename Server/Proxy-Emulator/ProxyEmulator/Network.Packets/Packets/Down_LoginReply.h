#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _login_reply, 1
		public ref struct Down_LoginReply : Up_UpMsg
		{
			Down_LoginReply()
			{
				MessageType = 1;
			}

			Down_LoginReply(const down::login_reply* login) : Down_LoginReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}