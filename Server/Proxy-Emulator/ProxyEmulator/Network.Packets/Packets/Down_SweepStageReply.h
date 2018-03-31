#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _sweep_stage_reply, 20
		public ref struct Down_SweepStageReply : Up_UpMsg
		{
			Down_SweepStageReply()
			{
				MessageType = 20;
			}

			Down_SweepStageReply(const down::sweep_stage_reply* sweep) : Down_SweepStageReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}