#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _error_info, 28
		public ref struct Down_ErrorInfo : Up_UpMsg
		{
			Down_ErrorInfo()
			{
				MessageType = 28;
			}

			Down_ErrorInfo(const down::error_info* error) : Down_ErrorInfo()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}