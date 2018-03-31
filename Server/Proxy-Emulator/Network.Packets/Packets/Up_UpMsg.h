#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network {
	namespace Packets {
		public ref class Up_UpMsg
		{
		public:

			enum class ChatChannel {
				world_channel = 1,
				guild_channel = 2,
				personal_channel = 3
			};

			enum class BattleResult
			{
				victory = 0,
				defeat = 1,
				canceled = 2,
				timeout = 3,
			};

			enum class HeroStatus
			{
				idle = 0,
				hire = 1,
				mining = 2
			};

			enum class PlatformType
			{
				self = 0,
				s91 = 1,
				tbt = 2,
				pp = 3,
				lemon = 4,
				itools = 5,
				kuaiyong = 6,
				tuyoo = 7,
				lemonyueyu = 8,
				ky_android = 101,
				xm_android = 102,
				lemon_android = 103,
				s360_android = 104,
				uc_android = 105,
				duoku_android = 106,
				s91_android = 107,
				wandoujia_android = 108,
				pps_android = 109,
				dangle_android = 110,
				oppo_android = 111,
				anzhi_android = 112,
				s37wan_android = 113,
				huawei_android = 114,
				lianxiang_android = 115,
				pptv_android = 116,
				vivo_android = 117,
			};

			enum class GuildJobT {
				chairman = 1,
				member = 2,
				elder = 3,
			};

			enum class HireFrom {
				hire_from_guild = 0,
				hire_from_tbc = 1,
				stage = 2,
				excav = 3,
			};

			Int32 ^ UserId;
			Int32 ^ Repeat;
			Int32 ^ MessageType;

			String^ _important_data_md5;

			Up_UpMsg()
			{
				
			}

			Up_UpMsg(const up::up_msg* msg)
			{
				if (msg->has__repeat())
					Repeat = Convert::ToInt32(msg->_repeat());

				if (msg->has__user_id())
					UserId = Convert::ToInt32(msg->_user_id());

				if (msg->has__important_data_md5())
					_important_data_md5 = gcnew String(msg->_important_data_md5().c_str());
			}

			virtual String^ ToString() override
			{
				return "Up_UpMsg {\n" +
					"\t1: _repeat = > " + Repeat + "\n"
					"\t2: _user_id = > " + UserId + "\n" +
					"}";
			}
		};
	}
}