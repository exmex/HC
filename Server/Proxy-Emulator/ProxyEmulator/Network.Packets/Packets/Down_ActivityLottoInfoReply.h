#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _activity_lotto_info_reply, 60
		public ref struct Down_ActivityLottoInfoReply : Up_UpMsg
		{
			Down_ActivityLottoInfoReply()
			{
				MessageType = 60;
			}

			Down_ActivityLottoInfoReply(const down::activity_lotto_info_reply* activity) : Down_ActivityLottoInfoReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}