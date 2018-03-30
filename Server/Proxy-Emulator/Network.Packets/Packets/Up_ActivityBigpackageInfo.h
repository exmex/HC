#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _activity_bigpackage_info, 72
		public ref struct Up_ActivityBigpackageInfo : Up_UpMsg
		{
			Up_ActivityBigpackageInfo()
			{
				MessageType = 72;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}