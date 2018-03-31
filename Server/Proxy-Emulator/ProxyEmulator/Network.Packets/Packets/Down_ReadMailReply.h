#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _read_mail_reply, 40
		public ref struct Down_ReadMailReply : Up_UpMsg
		{
			Down_ReadMailReply()
			{
				MessageType = 40;
			}

			Down_ReadMailReply(const down::read_mail_reply* read) : Down_ReadMailReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}