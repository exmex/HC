#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _exit_stage_reply, 4
		public ref struct Down_ExitStageReply : Up_UpMsg
		{
			Down_ExitStageReply()
			{
				MessageType = 4;
			}

			Down_ExitStageReply(const down::exit_stage_reply* exit) : Down_ExitStageReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}