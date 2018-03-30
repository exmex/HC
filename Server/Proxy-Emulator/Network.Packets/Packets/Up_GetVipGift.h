#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _get_vip_gift, 45
		public ref struct Up_GetVipGift : Up_UpMsg
		{
			Up_GetVipGift()
			{
				MessageType = 45;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}