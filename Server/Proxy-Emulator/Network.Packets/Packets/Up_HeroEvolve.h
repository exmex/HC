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
			// Hero ID to be evolved
			UInt32 _heroid;

			Up_HeroEvolve()
			{
				MessageType = 28;
			}

			Up_HeroEvolve(const up::hero_evolve* hero) : Up_HeroEvolve()
			{
				_heroid = Convert::ToUInt32(hero->_heroid());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}