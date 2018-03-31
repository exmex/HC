#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _skill_levelup_reply, 11
		public ref struct Down_SkillLevelupReply : Up_UpMsg
		{
			Down_SkillLevelupReply()
			{
				MessageType = 11;
			}

			Down_SkillLevelupReply(const down::skill_levelup_reply* skill) : Down_SkillLevelupReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}