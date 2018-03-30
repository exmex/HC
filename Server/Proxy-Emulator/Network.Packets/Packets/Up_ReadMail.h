#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _read_mail, 43
		public ref struct Up_ReadMail : Up_UpMsg
		{
			Up_ReadMail()
			{
				MessageType = 43;
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}