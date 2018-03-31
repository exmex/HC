#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _exit_stage, 6
		public ref struct Up_ExitStage : Up_UpMsg
		{
			BattleResult _result = BattleResult::victory;
			UInt32 _stars;
			List<UInt32> _heroes; // Hero Type Id
			List<UInt32> _operations; // <<replacement:8, op:2, wave_idx:3, tick:10, hero_pos:3>> (op = 0: cast skill, op = 1: revive hero)
			String^ _md5;
			List<UInt32> _self_data; // self hp

			Up_ExitStage()
			{
				MessageType = 6;
			}

			Up_ExitStage(const up::exit_stage* stage) : Up_ExitStage()
			{
				_result = (BattleResult)Convert::ToInt32(stage->_result());
				_stars = Convert::ToUInt32(stage->_stars());

				auto heroList = stage->_heroes();
				for (int i = 0; i < heroList.size(); ++i) {
					_heroes.Add(Convert::ToUInt32(heroList.Get(i)));
				}

				auto operationsList = stage->_oprations();
				for (int i = 0; i < operationsList.size(); ++i) {
					_operations.Add(Convert::ToUInt32(operationsList.Get(i)));
				}

				_md5 = gcnew String(stage->_md5().c_str());

				auto selfDataList = stage->_self_data();
				for (int i = 0; i < selfDataList.size(); ++i) {
					_self_data.Add(Convert::ToUInt32(selfDataList.Get(i)));
				}
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}