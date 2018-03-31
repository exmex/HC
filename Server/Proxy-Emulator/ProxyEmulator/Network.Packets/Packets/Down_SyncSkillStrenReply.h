#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _sync_skill_stren_reply, 22
		public ref struct Down_SyncSkillStrenReply : Up_UpMsg
		{
			Down_SyncSkillStrenReply()
			{
				MessageType = 22;
			}

			Down_SyncSkillStrenReply(const down::sync_skill_stren_reply* sync) : Down_SyncSkillStrenReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}