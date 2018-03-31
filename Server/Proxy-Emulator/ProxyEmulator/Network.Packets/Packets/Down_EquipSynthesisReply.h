#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _equip_synthesis_reply, 6
		public ref struct Down_EquipSynthesisReply : Up_UpMsg
		{
			Down_EquipSynthesisReply()
			{
				MessageType = 6;
			}

			Down_EquipSynthesisReply(const down::equip_synthesis_reply* equip) : Down_EquipSynthesisReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}