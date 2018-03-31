#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _wear_equip_reply, 7
		public ref struct Down_WearEquipReply : Up_UpMsg
		{
			Down_WearEquipReply()
			{
				MessageType = 7;
			}

			Down_WearEquipReply(const down::wear_equip_reply* wear) : Down_WearEquipReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}