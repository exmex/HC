#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _reset, 2
		public ref struct Down_Reset : Up_UpMsg
		{
			Down_Reset()
			{
				MessageType = 2;
			}

			Down_Reset(const down::reset* reset) : Down_Reset()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}