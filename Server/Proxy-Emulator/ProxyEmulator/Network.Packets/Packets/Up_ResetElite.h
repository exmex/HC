#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _reset_elite, 22
		public ref struct Up_ResetElite : Up_UpMsg
		{
			enum class ResetType
			{
				// Automatic reset at 0 daily
				daily_free = 0,
				// VIP reset
				vip_reset = 1,
			};

			// Automatic reset
			ResetType _type; // default daily_free

			// EliteID，E.g：10001
			UInt32 _stageid;			
			
			Up_ResetElite()
			{
				MessageType = 22;
				_type = ResetType::daily_free;
			}

			Up_ResetElite(const up::reset_elite* reset) : Up_ResetElite()
			{
				if(reset->has__type())
					_type = (ResetType)Convert::ToInt32(reset->_type());
				_stageid = Convert::ToUInt32(reset->_stageid());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}