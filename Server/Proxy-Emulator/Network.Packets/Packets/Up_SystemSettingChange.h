#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network {
	namespace Packets {

		public ref struct Up_SystemSettingChange : Up_UpMsg
		{
			String^ _key;
			String^ _value;

			Up_SystemSettingChange()
			{

			}

			Up_SystemSettingChange(const up::system_setting_change* change)
			{
				_key = gcnew String(change->key().c_str());
				_value = gcnew String(change->value().c_str());
			}

			virtual String^ ToString() override
			{
				return "Up_SystemSettingChange {\n" +
					"\t1: _key = > '" + _key + "'\n" +
					"\t2: _value = > '" + _value + "'\n" +
					"}";
			}
		};

		public ref struct Up_SystemSettingRequest : Up_UpMsg
		{
			Up_SystemSettingRequest(const up::system_setting_request* request)
			{
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};

		public ref struct Up_SystemSetting : Up_UpMsg
		{
			Up_SystemSettingRequest^ _request;
			Up_SystemSettingChange^ _change;

			Up_SystemSetting()
			{
				MessageType = 54;				
			}

			Up_SystemSetting(const up::system_setting* system) : Up_SystemSetting()
			{
				_request = gcnew Up_SystemSettingRequest(&system->_request());
				_change = gcnew Up_SystemSettingChange(&system->_change());
			}

			virtual String^ ToString() override
			{
				return "Up_SystemSetting {\n" +
					"\t1: _request = > " + _request + "\n" +
					"\t2: _change = > " + _change + "\n" +
					"}";
			}
		};
	}
}