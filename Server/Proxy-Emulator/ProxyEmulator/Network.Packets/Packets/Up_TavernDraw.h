#include "pb\up.pb.h"
#include <iostream>

#pragma once

using namespace System;
using namespace System::Collections::Generic;

namespace Network
{
	namespace Packets
	{
		// _tavern_draw, 26
		public ref struct Up_TavernDraw : Up_UpMsg
		{
			enum class DrawType
			{
				// Single pump
				single = 0,
				// Ten consecutive smoking
				combo = 1,
				// Soul Stone Draw
				stone = 3,
				// Free single pump
				free = 4,
			};

			enum class BoxType
			{
				// Green box
				green = 1,
				// Blue box
				blue = 2,
				// Purple box
				purple = 3,
				// Mysterious treasure box
				magicsoul = 4,
				//Intergalactic businessman pumping for combo
				stone_green = 5,
				//Intergalactic businessman pumping for combo
				stone_blue = 6,
				//Intergalactic businessman pumping for combo
				stone_purple = 7,
			};

			// Draw method
			DrawType _draw_type; // default = single
			// To pump the box type
			BoxType _box_type; // default = green

			Up_TavernDraw()
			{
				MessageType = 26;
				_draw_type = DrawType::single;
				_box_type = BoxType::green;
			}

			Up_TavernDraw(const up::tavern_draw* tavern) : Up_TavernDraw()
			{
				_draw_type = (DrawType)Convert::ToInt32(tavern->_draw_type());
				_box_type = (BoxType)Convert::ToInt32(tavern->_box_type());
			}

			virtual String^ ToString() override
			{
				return "";
			}
		};
	}
}