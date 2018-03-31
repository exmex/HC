#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _query_split_data_reply, 50
		public ref struct Down_QuerySplitDataReply : Up_UpMsg
		{
			Down_QuerySplitDataReply()
			{
				MessageType = 50;
			}

			Down_QuerySplitDataReply(const down::query_split_data_reply* query) : Down_QuerySplitDataReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}