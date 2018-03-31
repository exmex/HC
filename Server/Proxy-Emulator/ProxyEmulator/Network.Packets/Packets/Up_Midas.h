#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _midas, 35
		public ref struct Up_Midas : Up_UpMsg
		{
			UInt32 _times;

			Up_Midas()
			{
				MessageType = 35;
			}

			Up_Midas(const up::midas* midas) : Up_Midas()
			{
				_times = Convert::ToUInt32(midas->_times());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}