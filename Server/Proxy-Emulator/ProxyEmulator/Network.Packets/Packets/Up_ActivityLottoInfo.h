#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _activity_lotto_info, 70
		public ref struct Up_ActivityLottoInfo : Up_UpMsg
		{
			String^_group_id;
			UInt32 _activity_id;

			Up_ActivityLottoInfo()
			{
				MessageType = 70;
			}

			Up_ActivityLottoInfo(const up::activity_lotto_info* activity) : Up_ActivityLottoInfo()
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