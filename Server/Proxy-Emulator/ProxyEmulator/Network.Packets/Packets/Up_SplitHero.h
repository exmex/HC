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
			UInt32 _tid;
			UInt32 _stone_id;

			Up_SplitHero()
			{
				MessageType = 57;
			}

			Up_SplitHero(const up::split_hero* split) : Up_SplitHero()
			{
				_tid = Convert::ToUInt32(split->_tid());
				_stone_id = Convert::ToUInt32(split->_stone_id());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}