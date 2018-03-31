#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _hero_upgrade, 8
		public ref struct Up_HeroUpgrade : Up_UpMsg
		{
			UInt32 _hero_id;
			Up_HeroUpgrade()
			{
				MessageType = 8;
			}

			Up_HeroUpgrade(const up::hero_upgrade* upgrade) : Up_HeroUpgrade()
			{
				_hero_id = Convert::ToUInt32(upgrade->_hero_id());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}