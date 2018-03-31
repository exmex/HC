#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _activity_lotto_reward, 71
		public ref struct Up_ActivityLottoReward : Up_UpMsg
		{
			String^ _group_id;
			UInt32 _activity_id;

			Up_ActivityLottoReward()
			{
				MessageType = 71;
			}

			Up_ActivityLottoReward(const up::activity_lotto_reward* activity) : Up_ActivityLottoReward()
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