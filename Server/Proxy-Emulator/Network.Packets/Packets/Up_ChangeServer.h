#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _change_server, 63
		public ref struct Up_ChangeServer : Up_UpMsg
		{
			Up_ChangeServer()
			{
				MessageType = 63;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}