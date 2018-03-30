#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _tutorial, 32
		public ref struct Up_Tutorial : Up_UpMsg
		{
			Up_Tutorial()
			{
				MessageType = 32;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}