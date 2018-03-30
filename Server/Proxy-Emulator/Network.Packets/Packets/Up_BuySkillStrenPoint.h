#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _buy_skill_stren_point, 25
		public ref struct Up_BuySkillStrenPoint : Up_UpMsg
		{
			Up_BuySkillStrenPoint()
			{
				MessageType = 25;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}