#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _continue_pay, 302
		public ref struct Up_ContinuePay : Up_UpMsg
		{
			UInt32 _continue_pay;

			Up_ContinuePay()
			{
				MessageType = 302;
			}

			Up_ContinuePay(const up::continue_pay* pay) : Up_ContinuePay()
			{
				_continue_pay = Convert::ToUInt32(pay->_continue_pay());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}