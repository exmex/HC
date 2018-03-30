#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _activity_info, 69
		public ref struct Up_ActivityInfo : Up_UpMsg
		{
			Up_ActivityInfo()
			{
				MessageType = 69;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}