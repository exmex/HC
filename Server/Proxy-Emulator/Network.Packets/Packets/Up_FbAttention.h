#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _fb_attention, 300
		public ref struct Up_FbAttention : Up_UpMsg
		{
			Up_FbAttention()
			{
				MessageType = 300;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}