#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _split_hero, 57
		public ref struct Up_SplitHero : Up_UpMsg
		{
			Up_SplitHero()
			{
				MessageType = 57;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}