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
			Up_OpenShop()
			{
				MessageType = 36;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}