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
			Up_EquipSynthesis()
			{
				MessageType = 9;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}