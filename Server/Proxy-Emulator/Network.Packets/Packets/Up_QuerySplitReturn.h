#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _query_split_return, 56
		public ref struct Up_QuerySplitReturn : Up_UpMsg
		{
			UInt32 _tid;

			Up_QuerySplitReturn()
			{
				MessageType = 56;
			}

			Up_QuerySplitReturn(const up::query_split_return* query) : Up_QuerySplitReturn()
			{
				_tid = Convert::ToUInt32(query->_tid());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}