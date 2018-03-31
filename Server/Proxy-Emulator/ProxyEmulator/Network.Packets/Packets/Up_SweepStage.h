#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _sweep_stage, 23
		public ref struct Up_SweepStage : Up_UpMsg
		{
			enum class ResetType
			{
				// Sweeping with sweeping money, naming is a problem left over by history
				sweep_with_ticket = 0,

				// Paid money
				sweep_with_rmb = 1,
			};

			// Sweeping type
			ResetType _type;

			// Level id
			UInt32 _stageid;

			// The number of sweeps, the default is 1
			UInt32 _times;

			Up_SweepStage()
			{
				MessageType = 23;
			}

			Up_SweepStage(const up::sweep_stage* sweep) : Up_SweepStage()
			{
				_type = (ResetType)Convert::ToInt32(sweep->_type());
				_stageid = Convert::ToUInt32(sweep->_stageid());
				_times = Convert::ToUInt32(sweep->_times());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}