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
			Up_EnterActStage()
			{
				MessageType = 29;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}