#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _consume_item, 11
		public ref struct Up_ConsumeItem : Up_UpMsg
		{
			Up_ConsumeItem()
			{
				MessageType = 11;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}