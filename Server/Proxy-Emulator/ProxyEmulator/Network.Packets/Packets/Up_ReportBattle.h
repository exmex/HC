#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _report_battle, 59
		public ref struct Up_ReportBattle : Up_UpMsg
		{
			UInt32 _id;
			array<Byte>^ _data;

			Up_ReportBattle()
			{
				MessageType = 59;
			}

			Up_ReportBattle(const up::report_battle* report) : Up_ReportBattle()
			{
				_id = Convert::ToUInt32(report->_id());

				std::string datastr = report->_data();
				_data = gcnew array<Byte>(datastr.size());
				System::Runtime::InteropServices::Marshal::Copy(IntPtr(&datastr[0]), _data, 0, datastr.size());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}