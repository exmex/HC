#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _midas, 35
		public ref struct Up_Midas : Up_UpMsg
		{
			Up_Midas()
			{
				MessageType = 35;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}