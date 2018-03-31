#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _equip_synthesis, 9
		public ref struct Up_EquipSynthesis : Up_UpMsg
		{
			UInt32 _equip_id;

			Up_EquipSynthesis()
			{
				MessageType = 9;
			}

			Up_EquipSynthesis(const up::equip_synthesis* synth) : Up_EquipSynthesis()
			{
				_equip_id = Convert::ToUInt32(synth->_equip_id());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}