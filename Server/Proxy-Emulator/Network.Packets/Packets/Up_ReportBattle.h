#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _report_battle, 59
		public ref struct Up_ReportBattle : Up_UpMsg
		{
			Up_ReportBattle()
			{
				MessageType = 59;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}