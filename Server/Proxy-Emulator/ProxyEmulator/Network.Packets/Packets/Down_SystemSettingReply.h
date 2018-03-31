#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _system_setting_reply, 49
		public ref struct Down_SystemSettingReply : Up_UpMsg
		{
			Down_SystemSettingReply()
			{
				MessageType = 49;
			}

			Down_SystemSettingReply(const down::system_setting_reply* system) : Down_SystemSettingReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}