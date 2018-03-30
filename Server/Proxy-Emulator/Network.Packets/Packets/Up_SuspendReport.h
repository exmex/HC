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
			Up_SuspendReport()
			{
				MessageType = 31;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}