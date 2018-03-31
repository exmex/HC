#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _tavern_draw_reply, 21
		public ref struct Down_TavernDrawReply : Up_UpMsg
		{
			Down_TavernDrawReply()
			{
				MessageType = 21;
			}

			Down_TavernDrawReply(const down::tavern_draw_reply* tavern) : Down_TavernDrawReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}