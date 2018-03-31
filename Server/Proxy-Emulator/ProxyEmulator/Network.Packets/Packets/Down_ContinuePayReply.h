#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _continue_pay_reply, 302
		public ref struct Down_ContinuePayReply : Up_UpMsg
		{
			Down_ContinuePayReply()
			{
				MessageType = 302;
			}

			Down_ContinuePayReply(const down::continue_pay_reply* _continue) : Down_ContinuePayReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}