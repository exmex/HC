#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network {
	namespace Packets {
		public ref struct Up_SdkLogin : Up_UpMsg
		{
			String^ _session_key;
			PlatformType^ _plat_id;

			Up_SdkLogin()
			{
				MessageType = 38;
			}

			Up_SdkLogin(const up::sdk_login* login) : Up_SdkLogin()
			{
				_session_key = gcnew String(login->_session_key().c_str());
				_plat_id = (PlatformType)Convert::ToInt32(login->_plat_id());
			}

			virtual String^ ToString() override
			{
				return "Up_SdkLogin {\n" +
					"\t1: _session_key = > '" + _session_key + "'\n" +
					"\t2: _plat_id = > " + _plat_id + "\n" +
					"}";
			}
		};
	}
}