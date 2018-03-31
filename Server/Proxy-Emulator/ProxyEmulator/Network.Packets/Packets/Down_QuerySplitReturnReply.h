#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _query_split_return_reply, 51
		public ref struct Down_QuerySplitReturnReply : Up_UpMsg
		{
			Down_QuerySplitReturnReply()
			{
				MessageType = 51;
			}

			Down_QuerySplitReturnReply(const down::query_split_return_reply* query) : Down_QuerySplitReturnReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}