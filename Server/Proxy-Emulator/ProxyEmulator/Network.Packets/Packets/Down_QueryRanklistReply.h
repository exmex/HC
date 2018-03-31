#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _query_ranklist_reply, 57
		public ref struct Down_QueryRanklistReply : Up_UpMsg
		{
			Down_QueryRanklistReply()
			{
				MessageType = 57;
			}

			Down_QueryRanklistReply(const down::query_ranklist_reply* query) : Down_QueryRanklistReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}