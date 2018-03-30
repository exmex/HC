#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _dot_info, 301
		public ref struct Up_DotInfo : Up_UpMsg
		{
			Up_DotInfo()
			{
				MessageType = 301;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}