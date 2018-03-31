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
			UInt32 _vip;

			Up_GetVipGift()
			{
				MessageType = 45;
			}

			Up_GetVipGift(const up::get_vip_gift* get) : Up_GetVipGift()
			{
				_vip = Convert::ToUInt32(get->_vip());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}