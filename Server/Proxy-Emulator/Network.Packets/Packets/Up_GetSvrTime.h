#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _get_svr_time, 44
		public ref struct Up_GetSvrTime : Up_UpMsg
		{
			Up_GetSvrTime()
			{
				MessageType = 44;
			}

			Up_GetSvrTime(const up::get_svr_time* get) : Up_GetSvrTime()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}