#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _ask_activity_info_reply, 47
		public ref struct Down_ActivityInfos : Up_UpMsg
		{
			Down_ActivityInfos()
			{
				MessageType = 47;
			}

			Down_ActivityInfos(const down::activity_infos* activity) : Down_ActivityInfos()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}