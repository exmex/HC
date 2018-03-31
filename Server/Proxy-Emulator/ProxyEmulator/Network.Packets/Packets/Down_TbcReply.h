#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _tbc_reply, 38
		public ref struct Down_TbcReply : Up_UpMsg
		{
			Down_TbcReply()
			{
				MessageType = 38;
			}

			Down_TbcReply(const down::tbc_reply* tbc) : Down_TbcReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}