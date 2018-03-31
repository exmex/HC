#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _require_arousal, 64
		public ref struct Up_RequireArousal : Up_UpMsg
		{
			enum class ArousalType
			{
				require_arousal = 0,
				apply_arousal = 1,
			};

			UInt32 _hid;
			ArousalType _arousal_type;
			UInt32 _aid;

			Up_RequireArousal()
			{
				MessageType = 64;
			}

			Up_RequireArousal(const up::require_arousal* require) : Up_RequireArousal()
			{
				_hid = Convert::ToUInt32(require->_hid());
				_arousal_type = (ArousalType)Convert::ToInt32(require->_arousal_type());
				_aid = Convert::ToUInt32(require->_aid());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}