#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _enter_stage_reply, 3
		public ref struct Down_EnterStageReply : Up_UpMsg
		{
			Down_EnterStageReply()
			{
				MessageType = 3;
			}

			Down_EnterStageReply(const down::enter_stage_reply* enter) : Down_EnterStageReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}