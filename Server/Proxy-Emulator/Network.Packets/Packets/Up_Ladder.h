#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _ladder, 33
		public ref struct Up_Ladder : Up_UpMsg
		{
			Up_Ladder()
			{
				MessageType = 33;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}