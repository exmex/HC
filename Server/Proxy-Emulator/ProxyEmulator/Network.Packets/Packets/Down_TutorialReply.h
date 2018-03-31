#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _tutorial_reply, 27
		public ref struct Down_TutorialReply : Up_UpMsg
		{
			Down_TutorialReply()
			{
				MessageType = 27;
			}

			Down_TutorialReply(const down::tutorial_reply* tutorial) : Down_TutorialReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}