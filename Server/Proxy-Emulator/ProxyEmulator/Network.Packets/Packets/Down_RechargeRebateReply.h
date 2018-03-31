#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _recharge_rebate_reply, 303
		public ref struct Down_RechargeRebateReply : Up_UpMsg
		{
			Down_RechargeRebateReply()
			{
				MessageType = 303;
			}

			Down_RechargeRebateReply(const down::recharge_rebate_reply* recharge) : Down_RechargeRebateReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}