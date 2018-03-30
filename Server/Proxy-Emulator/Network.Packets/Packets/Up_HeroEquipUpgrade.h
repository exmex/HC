#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _hero_equip_upgrade, 17
		public ref struct Up_HeroEquipUpgrade : Up_UpMsg
		{
			Up_HeroEquipUpgrade()
			{
				MessageType = 17;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}