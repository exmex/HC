#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _fb_attention, 300
		public ref struct Up_FbAttention : Up_UpMsg
		{
			UInt32 _fb_attention;

			Up_FbAttention()
			{
				MessageType = 300;
			}

			Up_FbAttention(const up::fb_attention* fb) : Up_FbAttention()
			{
				_fb_attention = Convert::ToUInt32(fb->_fb_attention());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}