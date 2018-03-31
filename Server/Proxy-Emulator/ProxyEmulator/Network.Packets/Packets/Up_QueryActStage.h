#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _query_act_stage, 67
		public ref struct Up_QueryActStage : Up_UpMsg
		{
			List<UInt32> _act_stage_groups;

			Up_QueryActStage()
			{
				MessageType = 67;
			}

			Up_QueryActStage(const up::query_act_stage* query) : Up_QueryActStage()
			{
				auto groupsList = query->_act_stage_groups();
				for (int i = 0; i < groupsList.size(); i++)
					_act_stage_groups.Add(Convert::ToUInt32(groupsList.Get(i)));
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}