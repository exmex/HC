#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _activity_bigpackage_reset, 74
		public ref struct Up_ActivityBigpackageReset : Up_UpMsg
		{
			Up_ActivityBigpackageReset()
			{
				MessageType = 74;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}