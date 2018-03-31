#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _require_rewards, 19
		public ref struct Up_RequireRewards : Up_UpMsg
		{			
			// Task line ID
			UInt32 _line;

			// task ID
			UInt32 _id;

			Up_RequireRewards()
			{
				MessageType = 19;
			}

			Up_RequireRewards(const up::require_rewards* req) : Up_RequireRewards()
			{
				_line = Convert::ToUInt32(req->_line());
				_id = Convert::ToUInt32(req->_id());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}