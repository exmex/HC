#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _push_notify, 53
		public ref struct Up_PushNotify : Up_UpMsg
		{
			String^ _client_id;

			Up_PushNotify()
			{
				MessageType = 53;
			}

			Up_PushNotify(const up::push_notify* push) : Up_PushNotify()
			{
				_client_id = gcnew String(push->_client_id().c_str());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}