#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _tutorial, 32
		public ref struct Up_Tutorial : Up_UpMsg
		{
			List<UInt32> _record;

			Up_Tutorial()
			{
				MessageType = 32;
			}

			Up_Tutorial(const up::tutorial* tutorial) : Up_Tutorial()
			{
				auto recordList = tutorial->_record();
				for (int i = 0; i < recordList.size(); i++)
					_record.Add(Convert::ToUInt32(recordList.Get(i)));
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}