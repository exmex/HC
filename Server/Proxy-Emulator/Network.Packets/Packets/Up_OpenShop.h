#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _open_shop, 36
		public ref struct Up_OpenShop : Up_UpMsg
		{
			UInt32 _shopid;

			Up_OpenShop()
			{
				MessageType = 36;
			}

			Up_OpenShop(const up::open_shop* open) : Up_OpenShop()
			{
				_shopid = Convert::ToUInt32(open->_shopid());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}