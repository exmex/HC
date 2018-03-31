#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _change_task_status, 65
		public ref struct Up_ChangeTaskStatus : Up_UpMsg
		{
			UInt32 _line;
			UInt32 _id;
			UInt32 _operation;

			Up_ChangeTaskStatus()
			{
				MessageType = 65;
			}

			Up_ChangeTaskStatus(const up::change_task_status* change) : Up_ChangeTaskStatus()
			{
				_line = Convert::ToUInt32(change->_line());
				_id = Convert::ToUInt32(change->_id());
				_operation = Convert::ToUInt32(change->_operation());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}