#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _worldcup, 58
		public ref struct WorldcupQuery : Up_UpMsg
		{
			WorldcupQuery(const up::worldcup_query* worldcup)
			{
				
			}
		};

		public ref struct WorldcupSubmit : Up_UpMsg
		{
			UInt32 _guess1;
			UInt32 _guess2;

			WorldcupSubmit(const up::worldcup_submit* worldcup)
			{
				_guess1 = Convert::ToUInt32(worldcup->_guess1());
				_guess2 = Convert::ToUInt32(worldcup->_guess2());
			}
		};

		public ref struct Up_Worldcup : Up_UpMsg
		{
			WorldcupQuery^ _worldcup_query;
			WorldcupSubmit^ _worldcup_submit;

			Up_Worldcup()
			{
				MessageType = 58;
			}

			Up_Worldcup(const up::worldcup* worldcup) : Up_Worldcup()
			{
				_worldcup_query = gcnew WorldcupQuery(&worldcup->_worldcup_query());
				_worldcup_submit = gcnew WorldcupSubmit(&worldcup->_worldcup_submit());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}