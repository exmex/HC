#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _recharge_rebate, 303
		public ref struct Up_RechargeRebate : Up_UpMsg
		{
			Up_RechargeRebate()
			{
				MessageType = 303;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}