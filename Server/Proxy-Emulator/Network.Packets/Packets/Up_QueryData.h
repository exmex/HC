#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _query_data, 27
		public ref struct Up_QueryData : Up_UpMsg
		{
			Up_QueryData()
			{
				MessageType = 27;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}