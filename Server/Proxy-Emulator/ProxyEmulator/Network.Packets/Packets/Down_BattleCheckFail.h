#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _battle_check_fail, 54
		public ref struct Down_BattleCheckFail : Up_UpMsg
		{
			Down_BattleCheckFail()
			{
				MessageType = 54;
			}

			Down_BattleCheckFail(const down::battle_check_fail* battle) : Down_BattleCheckFail()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}