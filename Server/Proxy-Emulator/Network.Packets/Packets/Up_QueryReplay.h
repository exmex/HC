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
			Up_QueryReplay()
			{
				MessageType = 60;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}