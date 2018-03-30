#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _query_replay, 60
		public ref struct Up_QueryReplay : Up_UpMsg
		{
			UInt32 _record_index;
			UInt32 _record_svrid;
			
			Up_QueryReplay()
			{
				MessageType = 60;
			}

			Up_QueryReplay(const up::query_replay* query) : Up_QueryReplay()
			{
				_record_index = Convert::ToUInt32(query->_record_index());
				_record_svrid = Convert::ToUInt32(query->_record_svrid());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}