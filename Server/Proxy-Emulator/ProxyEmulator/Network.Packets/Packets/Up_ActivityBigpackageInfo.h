#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _activity_bigpackage_info, 72
		public ref struct Up_ActivityBigpackageInfo : Up_UpMsg
		{
			String^ _group_id;
			UInt32 _activity_id;

			Up_ActivityBigpackageInfo()
			{
				MessageType = 72;
			}

			Up_ActivityBigpackageInfo(const up::activity_bigpackage_info* activity) : Up_ActivityBigpackageInfo()
			{
				_group_id = gcnew String(activity->_group_id().c_str());
				_activity_id = Convert::ToUInt32(activity->_activity_id());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}