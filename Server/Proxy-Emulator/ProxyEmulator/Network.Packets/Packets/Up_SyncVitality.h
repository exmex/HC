#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _sync_vitality, 30
		public ref struct Up_SyncVitality : Up_UpMsg
		{
			Up_SyncVitality()
			{
				MessageType = 30;
			}

			Up_SyncVitality(const up::sync_vitality* sync) : Up_SyncVitality()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}