#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _activity_info, 69
		public ref struct Up_ActivityInfo : Up_UpMsg
		{
			String^ _player_name;
			UInt32 _version;

			Up_ActivityInfo()
			{
				MessageType = 69;
			}

			Up_ActivityInfo(const up::activity_info* activity) : Up_ActivityInfo()
			{
				_player_name = gcnew String(activity->_player_name().c_str());
				_version = Convert::ToUInt32(activity->_version());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}