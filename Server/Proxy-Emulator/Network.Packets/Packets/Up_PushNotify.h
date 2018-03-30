#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _push_notify, 53
		public ref struct Up_PushNotify : Up_UpMsg
		{
			Up_PushNotify()
			{
				MessageType = 53;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}