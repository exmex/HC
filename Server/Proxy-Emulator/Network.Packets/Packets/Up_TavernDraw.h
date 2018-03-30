#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _tavern_draw, 26
		public ref struct Up_TavernDraw : Up_UpMsg
		{
			Up_TavernDraw()
			{
				MessageType = 26;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}