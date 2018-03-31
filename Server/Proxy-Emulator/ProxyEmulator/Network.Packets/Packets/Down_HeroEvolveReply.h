#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _hero_evolve_reply, 24
		public ref struct Down_HeroEvolveReply : Up_UpMsg
		{
			Down_HeroEvolveReply()
			{
				MessageType = 24;
			}

			Down_HeroEvolveReply(const down::hero_evolve_reply* hero) : Down_HeroEvolveReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}