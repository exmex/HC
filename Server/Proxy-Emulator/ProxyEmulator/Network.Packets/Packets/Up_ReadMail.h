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
			UInt32 _id;

			Up_ReadMail()
			{
				MessageType = 43;
			}

			Up_ReadMail(const up::read_mail* read) : Up_ReadMail()
			{
				_id = Convert::ToUInt32(read->_id());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}