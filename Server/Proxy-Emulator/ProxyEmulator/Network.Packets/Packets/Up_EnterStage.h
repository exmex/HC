#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _enter_stage, 5
		public ref struct Up_EnterStage : Up_UpMsg
		{
			UInt32^ _stage_id;

			Up_EnterStage()
			{
				MessageType = 5;
			}

			Up_EnterStage(const up::enter_stage* stage)
			{
				_stage_id = stage->_stage_id();
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}