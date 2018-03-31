#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _suspend_report, 31
		public ref struct Up_SuspendReport : Up_UpMsg
		{
			// game time
			UInt32 _gametime;
			
			Up_SuspendReport()
			{
				MessageType = 31;
			}

			Up_SuspendReport(const up::suspend_report* suspend) : Up_SuspendReport()
			{
				_gametime = Convert::ToUInt32(suspend->_gametime());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}