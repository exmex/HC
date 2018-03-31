#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _charge_reply, 33
		public ref struct Down_ChargeReply : Up_UpMsg
		{
			Down_ChargeReply()
			{
				MessageType = 33;
			}

			Down_ChargeReply(const down::charge_reply* charge) : Down_ChargeReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}