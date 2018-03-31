#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _enter_act_stage, 29
		public ref struct Up_EnterActStage : Up_UpMsg
		{
			UInt32 _stage_group;
			UInt32 _stage;

			Up_EnterActStage()
			{
				MessageType = 29;
			}

			Up_EnterActStage(const up::enter_act_stage* enter) : Up_EnterActStage()
			{
				_stage_group = Convert::ToUInt32(enter->_stage_group());
				_stage = Convert::ToUInt32(enter->_stage());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}