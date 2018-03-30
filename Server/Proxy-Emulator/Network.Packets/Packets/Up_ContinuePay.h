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
			Up_ContinuePay()
			{
				MessageType = 302;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}