#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _skill_levelup, 14
		public ref struct Up_SkillLevelup : Up_UpMsg
		{
			Up_SkillLevelup()
			{
				MessageType = 14;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}