#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _set_name, 34
		public ref struct Up_SetName : Up_UpMsg
		{
			Up_SetName()
			{
				MessageType = 34;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}