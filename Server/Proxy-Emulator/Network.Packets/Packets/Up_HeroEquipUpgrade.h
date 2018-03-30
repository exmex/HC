#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _hero_equip_upgrade, 17
		public ref struct Up_HeroEquipUpgrade : Up_UpMsg
		{
			enum class OpType
			{
				//General advanced
				normal = 1,
				//One button to the top
				boss = 2
			};

			// Advanced method
			OpType _op_type; // default = normal

			// Hero ID
			UInt32 _heroid;

			// Advanced equipment
			UInt32 _slot;

			// Consumed material group<<amount:11, id:10>>
			List<UInt32> _materials;

			Up_HeroEquipUpgrade()
			{
				MessageType = 17;
				_op_type = OpType::normal;
			}

			Up_HeroEquipUpgrade(const up::hero_equip_upgrade* heroUpgrade) : Up_HeroEquipUpgrade()
			{
				if (heroUpgrade->has__op_type())
					_op_type = (OpType)Convert::ToInt32(heroUpgrade->_op_type());

				_heroid = heroUpgrade->_heroid();
				_slot = heroUpgrade->_slot();

				auto matList = heroUpgrade->_materials();
				for (int i = 0; i < matList.size(); i++)
					_materials.Add(matList.Get(i));
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}