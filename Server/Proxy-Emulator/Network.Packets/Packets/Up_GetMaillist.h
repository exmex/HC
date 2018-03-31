#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _get_maillist, 42
		public ref struct Up_GetMaillist : Up_UpMsg
		{
			Up_GetMaillist()
			{
				MessageType = 42;
			}

			Up_GetMaillist(const up::get_maillist* get) : Up_GetMaillist()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}