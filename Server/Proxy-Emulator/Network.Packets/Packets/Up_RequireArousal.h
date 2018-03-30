#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _require_arousal, 64
		public ref struct Up_RequireArousal : Up_UpMsg
		{
			Up_RequireArousal()
			{
				MessageType = 64;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}