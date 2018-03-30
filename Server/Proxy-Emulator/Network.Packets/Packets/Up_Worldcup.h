#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _worldcup, 58
		public ref struct Up_Worldcup : Up_UpMsg
		{
			Up_Worldcup()
			{
				MessageType = 58;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}