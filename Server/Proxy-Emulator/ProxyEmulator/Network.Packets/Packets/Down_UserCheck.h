#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _user_check, 26
		public ref struct Down_UserCheck : Up_UpMsg
		{
			Down_UserCheck()
			{
				MessageType = 26;
			}

			Down_UserCheck(const down::user_check* user) : Down_UserCheck()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}