#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _tbc, 41
		public ref struct Up_Tbc : Up_UpMsg
		{
			Up_Tbc()
			{
				MessageType = 41;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}