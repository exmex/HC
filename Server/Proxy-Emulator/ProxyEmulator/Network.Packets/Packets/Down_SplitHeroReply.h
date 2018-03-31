#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _split_hero_reply, 52
		public ref struct Down_SplitHeroReply : Up_UpMsg
		{
			Down_SplitHeroReply()
			{
				MessageType = 52;
			}

			Down_SplitHeroReply(const down::split_hero_reply* split) : Down_SplitHeroReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}