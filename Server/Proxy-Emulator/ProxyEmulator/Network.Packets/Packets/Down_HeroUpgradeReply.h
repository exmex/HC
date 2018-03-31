#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _hero_upgrade_reply, 5
		public ref struct Down_HeroUpgradeReply : Up_UpMsg
		{
			Down_HeroUpgradeReply()
			{
				MessageType = 5;
			}

			Down_HeroUpgradeReply(const down::hero_upgrade_reply* hero) : Down_HeroUpgradeReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}