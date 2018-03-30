#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _sweep_stage, 23
		public ref struct Up_SweepStage : Up_UpMsg
		{
			Up_SweepStage()
			{
				MessageType = 23;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}