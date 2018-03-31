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
			UInt32 _recharge_rebate;

			Up_RechargeRebate()
			{
				MessageType = 303;
			}

			Up_RechargeRebate(const up::recharge_rebate* recharge) : Up_RechargeRebate()
			{
				_recharge_rebate = Convert::ToUInt32(recharge->_recharge_rebate());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}