#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _important_data_md5, 46
		public ref struct Up_String : Up_UpMsg
		{
			Up_String()
			{
				MessageType = 46;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}