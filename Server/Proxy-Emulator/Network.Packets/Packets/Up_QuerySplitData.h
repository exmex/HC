#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _query_split_data, 55
		public ref struct Up_QuerySplitData : Up_UpMsg
		{
			Up_QuerySplitData()
			{
				MessageType = 55;
			}

			Up_QuerySplitData(const up::query_split_data* query) : Up_QuerySplitData()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}