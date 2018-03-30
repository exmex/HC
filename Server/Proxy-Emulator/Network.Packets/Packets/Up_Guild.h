#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _guild, 49
		public ref struct Up_Guild : Up_UpMsg
		{
			Up_Guild()
			{
				MessageType = 49;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}