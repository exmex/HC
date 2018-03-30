#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _shop_refresh, 12
		/*
		 * Refresh the store
		 * Exception handling:
		 * 1. When syncing, if the auto-refresh cycle arrives, swip a batch of new content back
		 * 2. When manual_refresh occurs, if the auto refresh cycle is reached, free refresh
		 */
		public ref struct Up_ShopRefresh : Up_UpMsg
		{
			enum class ShopRefresh
			{				
				// When the player newly enters the store, the synchronization shop
				Sync = 0,
				// Time is up, the client initiates a store refresh request automatically
				AutoRefresh = 1,
				// Player manually refresh the request
				ManualRefresh = 2
			};
			ShopRefresh^ _type; // default = sync
			UInt32 _shop_id;


			Up_ShopRefresh()
			{
				MessageType = 12;
			}

			Up_ShopRefresh(const up::shop_refresh* refresh) : Up_ShopRefresh()
			{
				if(refresh->has__type())
					_type = (ShopRefresh)Convert::ToInt32(refresh->_type());
				else
					_type = ShopRefresh::Sync;

				_shop_id = Convert::ToUInt32(refresh->_shop_id());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}