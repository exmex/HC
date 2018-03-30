#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _query_act_stage, 67
		public ref struct Up_QueryActStage : Up_UpMsg
		{
			Up_QueryActStage()
			{
				MessageType = 67;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}