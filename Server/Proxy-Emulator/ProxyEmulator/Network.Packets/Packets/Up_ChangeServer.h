#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _change_server, 63
		public ref struct Up_ChangeServer : Up_UpMsg
		{
			enum class ServerOptType {
				//get list
				get = 0,
				//change server
				change = 1,
			};

			ServerOptType _op_type;
			UInt32 _server_id;

			Up_ChangeServer()
			{
				MessageType = 63;
			}

			Up_ChangeServer(const up::change_server* change) : Up_ChangeServer()
			{
				_op_type = (ServerOptType)Convert::ToInt32(change->_op_type());
				_server_id = Convert::ToUInt32(change->_server_id());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}