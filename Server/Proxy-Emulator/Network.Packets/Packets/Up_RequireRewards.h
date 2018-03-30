#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _require_rewards, 19
		public ref struct Up_RequireRewards : Up_UpMsg
		{
			Up_RequireRewards()
			{
				MessageType = 19;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}