#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _sync_vitality_reply, 25
		public ref struct Down_SyncVitalityReply : Up_UpMsg
		{
			Down_SyncVitalityReply()
			{
				MessageType = 25;
			}

			Down_SyncVitalityReply(const down::sync_vitality_reply* sync) : Down_SyncVitalityReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}