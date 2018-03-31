#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _activity_bigpackage_reward_info, 73
		public ref struct Up_ActivityBigpackageRewardInfo : Up_UpMsg
		{
			String^ _group_id;
			UInt32 _activity_id;
			UInt32 _box_id;

			Up_ActivityBigpackageRewardInfo()
			{
				MessageType = 73;
			}

			Up_ActivityBigpackageRewardInfo(const up::activity_bigpackage_reward_info* activity) : Up_ActivityBigpackageRewardInfo()
			{
				_group_id = gcnew String(activity->_group_id().c_str());
				_activity_id = Convert::ToUInt32(activity->_activity_id());
				_box_id = Convert::ToUInt32(activity->_box_id());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}