#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _request_guild_log, 66
		public ref struct Up_RequestGuildLog : Up_UpMsg
		{
			Up_RequestGuildLog()
			{
				MessageType = 66;
			}
			
			Up_RequestGuildLog(const up::request_guild_log* request) : Up_RequestGuildLog()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}