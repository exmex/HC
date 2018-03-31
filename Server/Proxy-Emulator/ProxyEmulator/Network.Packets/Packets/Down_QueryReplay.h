#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _query_replay, 55
		public ref struct Down_QueryReplay : Up_UpMsg
		{
			Down_QueryReplay()
			{
				MessageType = 55;
			}

			Down_QueryReplay(const down::query_replay* query) : Down_QueryReplay()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}