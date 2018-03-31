#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		public ref struct ChatAcc
		{
			enum class ChatAccT
			{
				binary = 1,
				pvp_replay = 2,
			};

			ChatAccT _type; // default binary
			String^ _binary;
			UInt32 _record_id;

			ChatAcc()
			{
				_type = ChatAccT::binary;
			}

			ChatAcc(const up::chat_acc* chat) : ChatAcc()
			{
				if (chat->has__type())
					_type = (ChatAccT)Convert::ToInt32(chat->_type());
				_binary = gcnew String(chat->_binary().c_str());
				_record_id = Convert::ToUInt32(chat->_record_id());
			}
		};

		public ref struct ChatBroadSay
		{
			Up_UpMsg::ChatChannel^ _channel;
			List<UInt32> _target_ids;
			UInt32 _content_type;
			String^ _content;
			ChatAcc^ _accessory;

			ChatBroadSay(const up::chat_broad_say* chat)
			{
				_channel = (Up_UpMsg::ChatChannel)Convert::ToInt32(chat->_channel());
				
				auto targetIdsList = chat->_target_ids();
				for (int i = 0; i < targetIdsList.size(); i++)
					_target_ids.Add(targetIdsList.Get(i));

				_content_type = Convert::ToUInt32(chat->_content_type());
				_content = gcnew String(chat->_content().c_str());
				_accessory = gcnew ChatAcc(&chat->_accessory());
			}
		};

		public ref struct ChatFetchBl
		{
			ChatFetchBl(const up::chat_fetch_bl* chat)
			{
				
			}
		};

		public ref struct ChatSay
		{
			Up_UpMsg::ChatChannel^ _channel; // default world_channel
			UInt32 _target_id;
			UInt32 _content_type;
			String^ _content;
			ChatAcc^ _accessory;

			ChatSay(const up::chat_say* chat)
			{
				_channel = (Up_UpMsg::ChatChannel)Convert::ToInt32(chat->_channel());
				_target_id = Convert::ToUInt32(chat->_target_id());
				_content_type = Convert::ToUInt32(chat->_content_type());
				_content = gcnew String(chat->_content().c_str());
				_accessory = gcnew ChatAcc(&chat->_accessory());
			}			
		};
		
		public ref struct ChatFresh
		{
			Up_UpMsg::ChatChannel^ _channel;

			ChatFresh()
			{
				_channel = Up_UpMsg::ChatChannel::world_channel;
			}

			ChatFresh(const up::chat_fresh* chat) : ChatFresh()
			{
				_channel = (Up_UpMsg::ChatChannel)Convert::ToInt32(chat->_channel());
			}
		};
		
		public ref struct ChatFetch
		{
			Up_UpMsg::ChatChannel^ _channel;
			UInt32 _chat_id;

			ChatFetch()
			{
				_channel = Up_UpMsg::ChatChannel::world_channel;
			}

			ChatFetch(const up::chat_fetch* chat) : ChatFetch()
			{
				_channel = (Up_UpMsg::ChatChannel)Convert::ToInt32(chat->_channel());
				_chat_id = Convert::ToUInt32(chat->_chat_id());
			}
		};

		public ref struct ChatAddBl
		{
			UInt32 _uid;

			ChatAddBl(const up::chat_add_bl* chat)
			{
				_uid = Convert::ToUInt32(chat->_uid());
			}
		};

		public ref struct ChatDelBl
		{
			UInt32 _uid;

			ChatDelBl(const up::chat_del_bl* chat)
			{
				_uid = Convert::ToUInt32(chat->_uid());
			}			
		};

		// _chat, 47
		public ref struct Up_Chat : Up_UpMsg
		{
			ChatSay^ _say;
			ChatFresh^ _fresh;
			ChatFetch^ _fetch;
			ChatAddBl^ _chat_add_bl;
			ChatDelBl^ _chat_del_bl;
			ChatFetchBl^ _chat_fetch_bl;
			ChatBroadSay^ _chat_broad_say;

			Up_Chat()
			{
				MessageType = 47;
			}

			Up_Chat(const up::chat* chat) : Up_Chat()
			{
				_say = gcnew ChatSay(&chat->_say());
				_fresh = gcnew ChatFresh(&chat->_fresh());
				_fetch = gcnew ChatFetch(&chat->_fetch());
				_chat_add_bl = gcnew ChatAddBl(&chat->_chat_add_bl());
				_chat_del_bl = gcnew ChatDelBl(&chat->_chat_del_bl());
				_chat_fetch_bl = gcnew ChatFetchBl(&chat->_chat_fetch_bl());
				_chat_broad_say = gcnew ChatBroadSay(&chat->_chat_broad_say());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}