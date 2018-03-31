#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _query_data_reply, 23
		public ref struct Down_QueryDataReply : Up_UpMsg
		{
			Down_QueryDataReply()
			{
				MessageType = 23;
			}

			Down_QueryDataReply(const down::query_data_reply* query) : Down_QueryDataReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}