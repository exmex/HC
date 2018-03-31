#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _dot_info, 301
		public ref struct Up_DotInfo : Up_UpMsg
		{
			UInt32 _dot_id;

			Up_DotInfo()
			{
				MessageType = 301;
			}

			Up_DotInfo(const up::dot_info* dot) : Up_DotInfo()
			{
				_dot_id = Convert::ToUInt32(dot->_dot_id());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}