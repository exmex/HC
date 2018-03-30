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
			Up_HeroUpgrade()
			{
				MessageType = 8;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}