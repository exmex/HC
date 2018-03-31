#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _fb_attention_reply, 300
		public ref struct Down_FbAttentionReply : Up_UpMsg
		{
			Down_FbAttentionReply()
			{
				MessageType = 300;
			}

			Down_FbAttentionReply(const down::fb_attention_reply* fb) : Down_FbAttentionReply()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}