#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _set_avatar, 39
		public ref struct Up_SetAvatar : Up_UpMsg
		{
			Up_SetAvatar()
			{
				MessageType = 39;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}