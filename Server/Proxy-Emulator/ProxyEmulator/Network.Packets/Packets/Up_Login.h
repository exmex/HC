#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network {
	namespace Packets {
		public ref struct Up_Login : Up_UpMsg
		{
			Int32^ _active_code;
			String^ _old_deviceid;
			String^ _version;
			Int32^ _languageid;

			Up_Login()
			{
				MessageType = 3;
			}

			Up_Login(const up::login* login) : Up_Login()
			{
				_active_code = Convert::ToInt32(login->_active_code());
				_old_deviceid = gcnew String(login->_old_deviceid().c_str());
				_version = gcnew String(login->_version().c_str());
				_languageid = Convert::ToInt32(login->_languageid());				
			}

			virtual String^ ToString() override
			{
				return "Up_Login {\n" +
					"\t1: _active_code = > " + _active_code + "\n" +
					"\t2: _old_deviceid = > '" + _old_deviceid + "'\n" +
					"\t3: _version = > '" + _version + "'\n" +
					"\t4: _languageid = > " + _languageid + "\n" +
					"}";
			}
		};
	}
}