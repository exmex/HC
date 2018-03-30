#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _query_ranklist, 62
		public ref struct Up_QueryRanklist : Up_UpMsg
		{
			Up_QueryRanklist()
			{
				MessageType = 62;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}