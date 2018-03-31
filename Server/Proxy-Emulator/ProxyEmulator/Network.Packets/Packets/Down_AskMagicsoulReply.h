#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _ask_magicsoul_reply, 46
		public ref struct Down_AskMagicsoulReply : Up_UpMsg
		{
			Down_AskMagicsoulReply()
			{
				MessageType = 46;
			}

			Down_AskMagicsoulReply(const down::ask_magicsoul_reply* ask) : Down_AskMagicsoulReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}