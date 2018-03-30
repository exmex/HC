#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _charge, 37
		public ref struct Up_Charge : Up_UpMsg
		{
			Up_UpMsg::PlatformType _platid; // default = self
			UInt32 _chargeid;
			String^ _extradata;

			Up_Charge()
			{
				MessageType = 37;

				_platid = Up_UpMsg::PlatformType::self;
			}

			Up_Charge(const up::charge* charge) : Up_Charge()
			{
				if(charge->has__platid())
					_platid = (Up_UpMsg::PlatformType)Convert::ToInt32(charge->_platid());
				_chargeid = Convert::ToUInt32(charge->_chargeid());
				_extradata = gcnew String(charge->_extradata().c_str());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}