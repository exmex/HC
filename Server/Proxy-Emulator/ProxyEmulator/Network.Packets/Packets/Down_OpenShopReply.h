#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _open_shop_reply, 32
		public ref struct Down_OpenShopReply : Up_UpMsg
		{
			Down_OpenShopReply()
			{
				MessageType = 32;
			}

			Down_OpenShopReply(const down::open_shop_reply* open) : Down_OpenShopReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}