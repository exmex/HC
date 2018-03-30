#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _chat, 47
		public ref struct Up_Chat : Up_UpMsg
		{
			Up_Chat()
			{
				MessageType = 47;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}