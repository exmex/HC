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

			Int32 ^ UserId;
			Int32 ^ Repeat;
			Int32 ^ MessageType;

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