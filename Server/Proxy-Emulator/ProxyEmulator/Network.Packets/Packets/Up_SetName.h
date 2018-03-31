#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _set_name, 34
		public ref struct Up_SetName : Up_UpMsg
		{
			enum class SetType
			{
				free = 0,
				rmb = 1
			};

			SetType _type;
			String^ _name;

			Up_SetName()
			{
				MessageType = 34;
			}

			Up_SetName(const up::set_name* set) : Up_SetName()
			{
				_type = (SetType)Convert::ToUInt32(set->_type());
				_name = gcnew String(set->_name().c_str());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}