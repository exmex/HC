#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _request_userinfo, 4
		public ref struct Up_RequestUserinfo : Up_UpMsg
		{
			Up_RequestUserinfo()
			{
				MessageType = 4;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}