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

			Up_SystemSettingChange(std::string key, std::string value)
			{
				_key = gcnew String(key.c_str());
				_value = gcnew String(value.c_str());
			}

			static operator Up_SystemSettingChange ^ (const up::system_setting_change* change)
			{
				return gcnew Up_SystemSettingChange(change->key().c_str(), change->value().c_str());
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
			static operator Up_SystemSettingRequest ^ (const up::system_setting_request* request)
			{
				return gcnew Up_SystemSettingRequest();
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

			Up_SystemSetting(const up::system_setting_request* request, const up::system_setting_change* change)
			{
				MessageType = 54;

				_request = request;
				_change = change;
				//_change = gcnew Up_SystemSettingChange(change.key(), change.value());
				//_change->_key = gcnew String(change.key().c_str());
				//_change->_value = gcnew String(change.value().c_str());
			}

			static operator Up_SystemSetting ^ (const up::system_setting* setting)
			{
				return gcnew Up_SystemSetting(&setting->_request(), &setting->_change());
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