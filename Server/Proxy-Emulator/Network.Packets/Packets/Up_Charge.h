#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _charge, 37
		public ref struct Up_Charge : Up_UpMsg
		{
			Up_Charge()
			{
				MessageType = 37;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}