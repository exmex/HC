#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _midas_reply, 31
		public ref struct Down_MidasReply : Up_UpMsg
		{
			Down_MidasReply()
			{
				MessageType = 31;
			}

			Down_MidasReply(const down::midas_reply* midas) : Down_MidasReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}