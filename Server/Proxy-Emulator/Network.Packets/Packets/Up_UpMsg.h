#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network {
	namespace Packets {
		public ref class Up_UpMsg
		{
		public:

			enum class BattleResult {
				victory = 0,
				defeat = 1,
				canceled = 2,
				timeout = 3,
			};

			enum class HeroStatus {
				idle = 0,
				hire = 1,
				mining = 2
			};

			Int32 ^ UserId;
			Int32 ^ Repeat;
			Int32 ^ MessageType;

			virtual String^ ToString() override
			{
				return "Up_UpMsg {\n" +
					"\t1: _repeat = > " + Repeat + "\n"
					"\t2: _user_id = > " + UserId + "\n" +
					"}";
			}
		};
	}
}