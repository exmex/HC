#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _cdkey_gift, 48
		public ref struct Up_CdkeyGift : Up_UpMsg
		{
			Up_CdkeyGift()
			{
				MessageType = 48;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}