#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _excavate, 52
		public ref struct Up_Excavate : Up_UpMsg
		{
			Up_Excavate()
			{
				MessageType = 52;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}