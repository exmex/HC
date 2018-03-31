#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _request_upgrade_arousal_level, 68
		public ref struct Up_RequestUpgradeArousalLevel : Up_UpMsg
		{
			Up_RequestUpgradeArousalLevel()
			{
				MessageType = 68;
			}

			Up_RequestUpgradeArousalLevel(const up::request_upgrade_arousal_level* request) : Up_RequestUpgradeArousalLevel()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}