#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _fragment_compose, 16
		public ref struct Up_FragmentCompose : Up_UpMsg
		{
			Up_FragmentCompose()
			{
				MessageType = 16;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}