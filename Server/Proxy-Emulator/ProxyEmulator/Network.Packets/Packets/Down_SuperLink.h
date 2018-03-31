#include "pb\down.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _super_link, 56
		public ref struct Down_SuperLink : Up_UpMsg
		{
			Down_SuperLink()
			{
				MessageType = 56;
			}

			Down_SuperLink(const down::super_link* super) : Down_SuperLink()
			{
				
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}