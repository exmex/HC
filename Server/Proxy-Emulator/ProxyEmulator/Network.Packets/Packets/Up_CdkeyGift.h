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
			String^ _cdkey;

			Up_CdkeyGift()
			{
				MessageType = 48;
			}

			Up_CdkeyGift(const up::cdkey_gift* cdkey) : Up_CdkeyGift()
			{
				_cdkey = gcnew String(cdkey->_cdkey().c_str());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}