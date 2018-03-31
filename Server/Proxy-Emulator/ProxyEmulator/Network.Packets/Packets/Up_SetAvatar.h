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
			UInt32^ _avatar;

			Up_SetAvatar()
			{
				MessageType = 39;
			}

			Up_SetAvatar(const up::set_avatar* set) : Up_SetAvatar()
			{
				_avatar = Convert::ToUInt32(set->_avatar());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}