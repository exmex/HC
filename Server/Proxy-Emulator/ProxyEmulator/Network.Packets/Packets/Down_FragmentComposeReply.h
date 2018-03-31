#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _fragment_compose_reply, 13
		public ref struct Down_FragmentComposeReply : Up_UpMsg
		{
			Down_FragmentComposeReply()
			{
				MessageType = 13;
			}

			Down_FragmentComposeReply(const down::fragment_compose_reply* fragment) : Down_FragmentComposeReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}