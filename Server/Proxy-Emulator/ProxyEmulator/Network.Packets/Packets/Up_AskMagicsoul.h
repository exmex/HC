#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _ask_magicsoul, 50
		public ref struct Up_AskMagicsoul : Up_UpMsg
		{
			Up_AskMagicsoul()
			{
				MessageType = 50;
			}

			Up_AskMagicsoul(const up::ask_magicsoul* ask) : Up_AskMagicsoul()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}