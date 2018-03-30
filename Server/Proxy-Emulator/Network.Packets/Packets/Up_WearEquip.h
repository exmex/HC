#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _wear_equip, 10
		public ref struct Up_WearEquip : Up_UpMsg
		{
			Up_WearEquip()
			{
				MessageType = 10;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}