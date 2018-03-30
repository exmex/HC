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
			Up_ActivityLottoInfo()
			{
				MessageType = 70;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}