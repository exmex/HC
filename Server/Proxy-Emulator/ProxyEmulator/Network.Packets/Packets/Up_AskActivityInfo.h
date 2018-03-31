#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _ask_activity_info, 51
		public ref struct Up_AskActivityInfo : Up_UpMsg
		{
			Up_AskActivityInfo()
			{
				MessageType = 51;
			}

			Up_AskActivityInfo(const up::ask_activity_info* ask) : Up_AskActivityInfo()
			{

			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}