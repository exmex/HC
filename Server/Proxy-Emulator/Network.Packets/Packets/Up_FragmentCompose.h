#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _fragment_compose, 16
		public ref struct Up_FragmentCompose : Up_UpMsg
		{
			// Synthetic items ID
			UInt32 _fragment;

			// Corresponding to the number of fragments, the server will automatically complete the required universal debris
			UInt32 _frag_amount;

			Up_FragmentCompose()
			{
				MessageType = 16;
			}

			Up_FragmentCompose(const up::fragment_compose* fragment) : Up_FragmentCompose()
			{
				_fragment = Convert::ToUInt32(fragment->_fragment());
				_frag_amount = Convert::ToUInt32(fragment->_frag_amount());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}