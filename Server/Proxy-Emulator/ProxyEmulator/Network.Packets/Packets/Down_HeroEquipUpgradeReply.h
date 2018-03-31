#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _hero_equip_upgrade_reply, 14
		public ref struct Down_HeroEquipUpgradeReply : Up_UpMsg
		{
			Down_HeroEquipUpgradeReply()
			{
				MessageType = 14;
			}

			Down_HeroEquipUpgradeReply(const down::hero_equip_upgrade_reply* hero) : Down_HeroEquipUpgradeReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}