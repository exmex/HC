#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _activity_bigpackage_reset, 74
		public ref struct Up_ActivityBigpackageReset : Up_UpMsg
		{
			String^ _group_id;
			UInt32 _activity_id;

			Up_ActivityBigpackageReset()
			{
				MessageType = 74;
			}

			Up_ActivityBigpackageReset(const up::activity_bigpackage_reset* activity) : Up_ActivityBigpackageReset()
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