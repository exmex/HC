#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _hero_evolve, 28
		public ref struct Up_HeroEvolve : Up_UpMsg
		{
			Up_HeroEvolve()
			{
				MessageType = 28;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}