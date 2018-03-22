local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.stageselectres = class
local function getStageIcon(id)
  local isElite = ed.stageType(id) == "elite"
  local st = ed.getDataTable("Stage")
  local row = st[id]
  local cid = row["Chapter ID"]
  local sid = isElite and row["Stage Group"] or id
  local sres = class.map["chapter" .. cid].stage
  for i = 1, #sres do
    local v = sres[i]
    if v.id == sid then
      sid = v.resid or v.id
      break
    end
  end
  local res = string.format("UI/alpha/HVGA/key_stages/stage-%d.png", sid)
  return res
end
class.getStageIcon = getStageIcon
local stageRes = {}
stageRes = {
  locked = "UI/alpha/HVGA/stagecircle_skeleton%d.png",
  passed = "UI/alpha/HVGA/stagecircle_elite.png",
  current = "UI/alpha/HVGA/stagecircle_current.png",
  elite = "UI/alpha/HVGA/stagecircle_elite.png"
}
class.stageRes = stageRes
local keyStageRes = {}
keyStageRes = {
  icon = {
    locked = "UI/alpha/HVGA/key_stages/stage-%d-locked.png",
    passed = "UI/alpha/HVGA/key_stages/stage-%d.png",
    current = "UI/alpha/HVGA/key_stages/stage-%d.png"
  },
  mask = {
    passed = "UI/alpha/HVGA/key_stages/stage-passed.png",
    current = "UI/alpha/HVGA/key_stages/stage-current.png"
  }
}
class.keyStageRes = keyStageRes
local map = {}
map.chapter1 = {
  tag = 1,
  bg = {
    res = "UI/alpha/HVGA/stageselect_map_bg_1.jpg",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map1.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(172, 284),
      id = 1,
      eid = 10001
    },
    {
      pos = ccp(217, 200),
      id = 2
    },
    {
      pos = ccp(137, 170),
      id = 3
    },
    {
      pos = ccp(160, 98),
      id = 4,
      eid = 10002
    },
    {
      pos = ccp(245, 78),
      id = 5
    },
    {
      pos = ccp(295, 78),
      id = 6
    },
    {
      pos = ccp(332, 161),
      id = 7,
      eid = 10003
    },
    {
      pos = ccp(400, 180),
      id = 8
    },
    {
      pos = ccp(385, 240),
      id = 9
    },
    {
      pos = ccp(425, 270),
      id = 10
    },
    {
      pos = ccp(510, 270),
      id = 11,
      eid = 10004
    },
    {
      pos = ccp(590, 285),
      id = 12
    },
    {
      pos = ccp(640, 275),
      id = 13
    },
    {
      pos = ccp(690, 235),
      id = 14
    },
    {
      pos = ccp(648, 160),
      id = 15,
      eid = 10005
    },
    {
      pos = ccp(560, 160),
      id = 16
    },
    {
      pos = ccp(590, 98),
      id = 17
    },
    {
      pos = ccp(480, 106),
      id = 18,
      eid = 10006
    }
  }
}
map.chapter2 = {
  tag = 1,
  bg = {
    res = "UI/alpha/HVGA/stageselect_map_bg_2.jpg",
    pos = ccp(402, 210)
  },
  route = {
    res = "UI/alpha/HVGA/map2.png",
    pos = ccp(402, 210)
  },
  stage = {
    {
      pos = ccp(155, 250),
      id = 19
    },
    {
      pos = ccp(230, 275),
      id = 20,
      eid = 10007
    },
    {
      pos = ccp(200, 190),
      id = 21
    },
    {
      pos = ccp(145, 180),
      id = 22
    },
    {
      pos = ccp(143, 95),
      id = 23,
      eid = 10008,
      resid = 7
    },
    {
      pos = ccp(225, 105),
      id = 24
    },
    {
      pos = ccp(270, 105),
      id = 25
    },
    {
      pos = ccp(310, 85),
      id = 26
    },
    {
      pos = ccp(384, 105),
      id = 27,
      eid = 10009
    },
    {
      pos = ccp(333, 196),
      id = 28
    },
    {
      pos = ccp(350, 246),
      id = 29
    },
    {
      pos = ccp(430, 245),
      id = 30,
      eid = 10010
    },
    {
      pos = ccp(490, 165),
      id = 31
    },
    {
      pos = ccp(455, 110),
      id = 32
    },
    {
      pos = ccp(540, 120),
      id = 33,
      eid = 10011
    },
    {
	  pos = ccp(632, 119),
      id = 34
    },
    {
	  pos = ccp(670, 140),
      id = 35
    },
    {
      pos = ccp(664, 221),
      id = 36,
      eid = 10012
    },
    {
	  pos = ccp(640, 286),
      id = 37
    },
    {
	  pos = ccp(602, 302),
      id = 38
    },
    {
      pos = ccp(527, 275),
      id = 39,
      eid = 10013
    }
  }
}
map.chapter3 = {
  tag = 3,
  bg = {
    res = "UI/alpha/HVGA/stageselect_map_bg_3.jpg",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map3.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(90, 268),
      id = 40
    },
    {
      pos = ccp(143, 270),
      id = 41
    },
    {
      pos = ccp(217, 244),
      id = 42,
      eid = 10014
    },
    {
      pos = ccp(180, 130),
      id = 43
    },
    {
      pos = ccp(230, 110),
      id = 44
    },
    {
      pos = ccp(330, 98),
      id = 45,
      eid = 10015
    },
    {
      pos = ccp(420, 100),
      id = 46
    },
    {
      pos = ccp(380, 154),
      id = 47
    },
    {
      pos = ccp(342, 252),
      id = 48,
      eid = 10016
    },
    {
      pos = ccp(426, 232),
      id = 49
    },
    {
      pos = ccp(463, 280),
      id = 50
    },
    {
      pos = ccp(551, 287),
      id = 51,
      eid = 10017
    },
    {
      pos = ccp(640, 270),
      id = 52
    },
    {
      pos = ccp(643, 196),
      id = 53,
      eid = 10018
    },
    {
	  pos = ccp(500, 125),
      id = 54
    },
    {
	  pos = ccp(582, 85),
      id = 55,
      eid = 10019
    }
  }
}
map.chapter4 = {
  tag = 4,
  bg = {
    res = "UI/alpha/HVGA/stageselect_map_bg_4.jpg",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map4.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(99, 300),
      id = 56
    },
    {
      pos = ccp(145, 285),
      id = 57
    },
    {
      pos = ccp(148, 181),
      id = 58,
      eid = 10020
    },
    {
      pos = ccp(195, 100),
      id = 59
    },
    {
      pos = ccp(311, 111),
      id = 60,
      eid = 10021
    },
    {
      pos = ccp(295, 160),
      id = 61
    },
    {
      pos = ccp(240, 180),
      id = 62
    },
    {
      pos = ccp(250, 265),
      id = 63,
      eid = 10022,
      resid = 7
    },
    {
      pos = ccp(345, 266),
      id = 64
    },
    {
      pos = ccp(397, 226),
      id = 65
    },
    {
      pos = ccp(485, 275),
      id = 66,
      eid = 10023
    },
    {
      pos = ccp(580, 270),
      id = 67
    },
    {
      pos = ccp(640, 270),
      id = 68
    },
    {
      pos = ccp(570, 200),
      id = 69,
      eid = 10024,
      resid = 20
    },
    {
      pos = ccp(440, 168),
      id = 70
    },
    {
      pos = ccp(473, 110),
      id = 71,
      eid = 10025
    },
    {
      pos = ccp(655, 150),
      id = 72
    },
    {
      pos = ccp(690, 119),
      id = 73
    },
    {
      pos = ccp(606, 90),
      id = 74,
      eid = 10026
    }
  }
}
map.chapter5 = {
  tag = 5,
  bg = {
    res = "UI/alpha/HVGA/stageselect_map_bg_5.jpg",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map5.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(85, 297),
      id = 75
    },
    {
	  pos = ccp(173, 286),
      id = 76,
      eid = 10027
    },
    {
      pos = ccp(175, 182),
      id = 77
    },
    {
      pos = ccp(120, 132),
      id = 78
    },
    {
	  pos = ccp(208, 107),
      id = 79,
      eid = 10028
    },
    {
      pos = ccp(295, 115),
      id = 80
    },
    {
      pos = ccp(345, 93),
      id = 81
    },
    {
      pos = ccp(425, 138),
      id = 82,
      eid = 10029
    },
    {
      pos = ccp(328, 204),
      id = 83
    },
    {
      pos = ccp(348, 285),
      id = 84
    },
    {
      pos = ccp(442, 270),
      id = 85,
      eid = 10030
    },
    {
      pos = ccp(520, 245),
      id = 86
    },
    {
      pos = ccp(560, 270),
      id = 87
    },
    {
      pos = ccp(650, 320),
      id = 88,
      eid = 10031
    },
    {
      pos = ccp(617, 225),
      id = 89
    },
    {
      pos = ccp(580, 195),
      id = 90
    },
    {
      pos = ccp(671, 182),
      id = 91,
      eid = 10032
    },
    {
      pos = ccp(660, 94),
      id = 92
    },
    {
      pos = ccp(603, 83),
      id = 93
    },
    {
      pos = ccp(519, 101),
      id = 94,
      eid = 10033
    }
  }
}
map.chapter6 = {
  tag = 6,
  bg = {
    res = "UI/alpha/HVGA/stageselect_map_bg_6.jpg",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map6.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(142, 85),
      id = 95,
      eid = 10034
    },
    {
      pos = ccp(122, 155),
      id = 96
    },
    {
      pos = ccp(130, 205),
      id = 97
    },
    {
      pos = ccp(147, 285),
      id = 98,
      eid = 10035
    },
    {
      pos = ccp(275, 270),
      id = 99
    },
    {
      pos = ccp(260, 205),
      id = 100
    },
    {
      pos = ccp(247, 135),
      id = 101,
      eid = 10036
    },
    {
      pos = ccp(324, 125),
      id = 102
    },
    {
      pos = ccp(370, 135),
      id = 103
    },
    {
      pos = ccp(448, 166),
      id = 104,
      eid = 10037
    },
    {
      pos = ccp(375, 185),
      id = 105
    },
    {
      pos = ccp(330, 229),
      id = 106
    },
    {
      pos = ccp(400, 275),
      id = 107,
      eid = 10038
    },
    {
      pos = ccp(490, 225),
      id = 108
    },
    {
      pos = ccp(555, 280),
      id = 109,
      eid = 10039
    },
    {
      pos = ccp(634, 270),
      id = 110
    },
    {
      pos = ccp(684, 258),
      id = 111
    },
    {
      pos = ccp(638, 179),
      id = 112,
      eid = 10040
    },
    {
      pos = ccp(615, 81),
      id = 113
    },
    {
      pos = ccp(532, 88),
      id = 114,
      eid = 10041
    }
  }
}
map.chapter7 = {
  tag = 4,
  bg = {
    res = "UI/alpha/HVGA/stageselect_map_bg_7.jpg",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map7.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(85, 280),
      id = 115
    },
    {
      pos = ccp(145, 270),
      id = 116
    },
    {
      pos = ccp(225, 270),
      id = 117,
      eid = 10042,
      guildInstanceId = 40001
    },
    {
      pos = ccp(175, 185),
      id = 118
    },
    {
      pos = ccp(117, 165),
      id = 119
    },
    {
      pos = ccp(202, 95),
      id = 120,
      eid = 10043,
      guildInstanceId = 40002
    },
    {
      pos = ccp(280, 75),
      id = 121
    },
    {
      pos = ccp(325, 95),
      id = 122
    },
    {
      pos = ccp(350, 165),
      id = 123,
      eid = 10044,
      guildInstanceId = 40003
    },
    {
      pos = ccp(295, 210),
      id = 124
    },
    {
      pos = ccp(325, 280),
      id = 125
    },
    {
      pos = ccp(451, 273),
      id = 126,
      eid = 10045,
      guildInstanceId = 40004
    },
    {
      pos = ccp(426, 165),
      id = 127
    },
    {
      pos = ccp(405, 85),
      id = 128
    },
    {
      pos = ccp(495, 115),
      id = 129,
      eid = 10046,
      guildInstanceId = 40005
    },
    {
      pos = ccp(550, 145),
      id = 130
    },
    {
      pos = ccp(645, 80),
      id = 131
    },
    {
      pos = ccp(621, 179),
      id = 132,
      eid = 10047,
      guildInstanceId = 40006
    },
    {
      pos = ccp(670, 245),
      id = 133
    },
    {
      pos = ccp(585, 285),
      id = 134,
      eid = 10048,
      guildInstanceId = 40007
    }
  },
  guildInstance = true
}
map.chapter8 = {
  tag = 3,
  bg = {
    res = "UI/alpha/HVGA/stageselect_map_bg_8.jpg",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map8.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(145, 70),
      id = 135
    },
    {
      pos = ccp(185, 95),
      id = 136
    },
    {
      pos = ccp(180, 165),
      id = 137,
      eid = 10049,
      guildInstanceId = 40008
    },
    {
      pos = ccp(115, 225),
      id = 138
    },
    {
      pos = ccp(135, 290),
      id = 139
    },
    {
      pos = ccp(225, 265),
      id = 140,
      eid = 10050,
      guildInstanceId = 40009
    },
    {
      pos = ccp(315, 295),
      id = 141
    },
    {
      pos = ccp(365, 255),
      id = 142
    },
    {
      pos = ccp(450, 265),
      id = 143,
      eid = 10051,
      guildInstanceId = 40010
    },
    {
      pos = ccp(570, 285),
      id = 144
    },
    {
      pos = ccp(630, 280),
      id = 145
    },
    {
      pos = ccp(650, 205),
      id = 146,
      eid = 10052,
      guildInstanceId = 40011
    },
    {
      pos = ccp(540, 225),
      id = 147
    },
    {
      pos = ccp(405, 175),
      id = 148
    },
    {
      pos = ccp(315, 205),
      id = 149,
      eid = 10053,
      guildInstanceId = 40012
    },
    {
      pos = ccp(295, 95),
      id = 150
    },
    {
      pos = ccp(345, 65),
      id = 151
    },
    {
      pos = ccp(485, 115),
      id = 152,
      eid = 10054,
      guildInstanceId = 40013
    },
    {
      pos = ccp(575, 115),
      id = 153
    },
    {
      pos = ccp(678, 85),
      id = 154,
      eid = 10055,
      guildInstanceId = 40014
    }
  },
  guildInstance = true
}
map.chapter9 = {
  tag = 1,
  bg = {
    res = "UI/alpha/HVGA/stageselect_map_bg_9.jpg",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map9.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(110, 275),
      id = 155
    },
    {
      pos = ccp(169, 290),
      id = 156
    },
    {
      pos = ccp(223, 255),
      id = 157,
      eid = 10056,
      guildInstanceId = 40015
    },
    {
      pos = ccp(155, 185),
      id = 158
    },
    {
      pos = ccp(110, 160),
      id = 159
    },
    {
      pos = ccp(171, 85),
      id = 160,
      eid = 10057,
      guildInstanceId = 40016
    },
    {
      pos = ccp(245, 110),
      id = 161
    },
    {

	  pos = ccp(357, 120),
      id = 162,
      eid = 10058,
      guildInstanceId = 40017
    },
    {
      pos = ccp(295, 202),
      id = 163
    },
    {
      pos = ccp(322, 260),
      id = 164
    },
    {
	  pos = ccp(420, 260),
      id = 165,
      eid = 10059,
      guildInstanceId = 40018
    },
    {
	  pos = ccp(490, 175),
      id = 166
    },
    {
      pos = ccp(480, 100),
      id = 167,
      eid = 10060,
      guildInstanceId = 40019
    },
    {
	  pos = ccp(545, 123),
      id = 168
    },
    {
      pos = ccp(590, 125),
      id = 169
    },
    {

	  pos = ccp(668, 166),
      id = 170,
      eid = 10061,
      guildInstanceId = 40020
    },
    {
      pos = ccp(619, 205),
      id = 171
    },
    {
	  pos = ccp(672, 262),
      id = 172
    },
    {
	  pos = ccp(619, 295),
      id = 173
    },
    {
	  pos = ccp(540, 275),
      id = 174,
      eid = 10062,
      guildInstanceId = 40021
    }
  },
  guildInstance = true
}
map.chapter10 = {
  tag = 1,
  bg = {
    res = "UI/alpha/HVGA/stageselect_map_bg_10.jpg",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map10.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(135, 55),
      id = 175
    },
    {
      pos = ccp(146, 145),
      id = 176,
      eid = 10063,
      guildInstanceId = 40022
    },
    {
      pos = ccp(145, 225),
      id = 177
    },
    {
      pos = ccp(170, 265),
      id = 178
    },
    {
      pos = ccp(256, 279),
      id = 179,
      eid = 10064,
      guildInstanceId = 40023
    },
    {
      pos = ccp(356, 275),
      id = 180
    },
    {
      pos = ccp(265, 135),
      id = 181,
      eid = 10065,
      guildInstanceId = 40024
    },
    {
      pos = ccp(350, 105),
      id = 182
    },
    {
      pos = ccp(406, 135),
      id = 183
    },
    {
      pos = ccp(510, 110),
      id = 184,
      eid = 10066,
      guildInstanceId = 40025
    },
    {
      pos = ccp(585, 115),
      id = 185
    },
    {
      pos = ccp(625, 125),
      id = 186
    },
    {
      pos = ccp(675, 185),
      id = 187,
      eid = 10067,
      guildInstanceId = 40026
    },
    {
      pos = ccp(595, 195),
      id = 188
    },
    {
      pos = ccp(535, 195),
      id = 189
    },
    {
      pos = ccp(435, 230),
      id = 190,
      eid = 10068,
      guildInstanceId = 40027
    },
    {
      pos = ccp(495, 275),
      id = 191
    },
    {
      pos = ccp(535, 275),
      id = 192
    },
    {
      pos = ccp(575, 265),
      id = 193
    },
    {
      pos = ccp(665, 295),
      id = 194,
      eid = 10069,
      guildInstanceId = 40028
    }
  },
  guildInstance = true
}
map.chapter11 = {
  tag = 3,
  bg = {
    res = "UI/alpha/HVGA/stageselect_map_bg_11.jpg",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map11.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(104, 284),
      id = 195
    },
    {
      pos = ccp(149, 280),
      id = 196
    },
    {
      pos = ccp(227, 281),
      id = 197,
      eid = 10070,
      guildInstanceId = 40029
    },
    {
      pos = ccp(173, 203),
      id = 198
    },
    {
      pos = ccp(125, 177),
      id = 199
    },
    {
      pos = ccp(160, 130),
      id = 200,
      eid = 10071,
      guildInstanceId = 40030
    },
    {
      pos = ccp(245, 110),
      id = 201
    },
    {
      pos = ccp(280, 91),
      id = 202
    },
    {
      pos = ccp(375, 120),
      id = 203,
      eid = 10072,
      guildInstanceId = 40031
    },
    {
      pos = ccp(305, 215),
      id = 204
    },
    {
      pos = ccp(365, 275),
      id = 205
    },
    {
      pos = ccp(488, 271),
      id = 206,
      eid = 10073,
      guildInstanceId = 40032
    },
    {
      pos = ccp(428, 190),
      id = 207
    },
    {
      pos = ccp(468, 155),
      id = 208
    },
    {
	  pos = ccp(511, 106),
      id = 209,
      eid = 10074,
      guildInstanceId = 40033
    },
    {
      pos = ccp(615, 110),
      id = 210
    },
    {
      pos = ccp(665, 155),
      id = 211
    },
    {
      pos = ccp(580, 205),
      id = 212,
      eid = 10075,
      guildInstanceId = 40034
    },
    {
      pos = ccp(584, 260),
      id = 213
    },
    {
	  pos = ccp(665, 295),
      id = 214,
      eid = 10076,
      guildInstanceId = 40035
    }
  },
  guildInstance = true
}
map.chapter12 = {
  tag = 4,
  bg = {
    res = "UI/alpha/HVGA/stageselect_map_bg_12.jpg",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map12.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(78, 98),
      id = 215
    },
    {
      pos = ccp(183, 133),
      id = 216,
      eid = 10077,
      guildInstanceId = 40036
    },
    {
      pos = ccp(165, 195),
      id = 217
    },
    {
      pos = ccp(133, 289),
      id = 218,
      eid = 10078,
      guildInstanceId = 40037
    },
    {
      pos = ccp(221, 245),
      id = 219
    },
    {
      pos = ccp(260, 235),
      id = 220
    },
    {
      pos = ccp(350, 275),
      id = 221,
      eid = 10079,
      guildInstanceId = 40038
    },
    {
      pos = ccp(315, 180),
      id = 222
    },
    {
      pos = ccp(320, 132),
      id = 223
    },
    {
      pos = ccp(390, 105),
      id = 224,
      eid = 10080,
      guildInstanceId = 40039
    },
    {
      pos = ccp(441, 156),
      id = 225
    },
    {
      pos = ccp(510, 215),
      id = 226,
      eid = 10081,
      guildInstanceId = 40040
    },
    {
      pos = ccp(437, 262),
      id = 227
    },
    {
      pos = ccp(487, 282),
      id = 228
    },
    {
      pos = ccp(591, 294),
      id = 229,
      eid = 10082,
      guildInstanceId = 40041
    },
    {
      pos = ccp(605, 185),
      id = 230
    },
    {
      pos = ccp(685, 199),
      id = 231,
      eid = 10083,
      guildInstanceId = 40042
    },
    {
      pos = ccp(624, 135),
      id = 232
    },
    {
      pos = ccp(575, 125),
      id = 233
    },
    {
      pos = ccp(505, 105),
      id = 234,
      eid = 10084,
      guildInstanceId = 40043
    }
  },
  guildInstance = true
}
map.chapter13 = {
  tag = 6,
  bg = {
    res = "UI/alpha/HVGA/stageselect_map_bg_13.jpg",
    pos = ccp(400, 212-20)
  },
  route = {
    res = "UI/alpha/HVGA/map13.png",
    pos = ccp(400, 212-20)
  },
  stage = {
    {
      pos = ccp(89, 317-20),
      id = 235
    },
    {
      pos = ccp(135, 334-20),
      id = 236
    },
    {
      pos = ccp(202, 279-20),
      id = 237,
      eid = 10085,
      guildInstanceId = 40044
    },
    {
      pos = ccp(111, 188-20),
      id = 238
    },
    {
      pos = ccp(121, 148-20),
      id = 239
    },
    {
      pos = ccp(203, 122-20),
      id = 240,
      eid = 10086,
      guildInstanceId = 40045
    },
    {
      pos = ccp(317, 135-20),
      id = 241
    },
    {
      pos = ccp(357, 162-20),
      id = 242
    },
    {
      pos = ccp(376, 236-20),
      id = 243,
      eid = 10087,
      guildInstanceId = 40046
    },
    {
      pos = ccp(423, 329-20),
      id = 244
    },
    {
      pos = ccp(460, 338-20),
      id = 245
    },
    {
      pos = ccp(538, 321-20),
      id = 246,
      eid = 10088,
      guildInstanceId = 40047
    },
    {
      pos = ccp(676, 278-20),
      id = 247
    },
    {
      pos = ccp(641, 207-20),
      id = 248,
      eid = 10089,
      guildInstanceId = 40048
    },
    {
      pos = ccp(579, 121-20),
      id = 249
    },
    {
      pos = ccp(496, 141-20),
      id = 250,
      eid = 10090,
      guildInstanceId = 40049
    }
  },
  guildInstance = true
}
map.chapter14 = {
  tag = 3,
  bg = {
    res = "UI/alpha/HVGA/stageselect_map_bg_14.jpg",
    pos = ccp(400, 212)
  },
  route = {
    res = "UI/alpha/HVGA/map14.png",
    pos = ccp(400, 212)
  },
  stage = {
    {
      pos = ccp(186, 138),
      id = 251,
      eid = 10091,
      guildInstanceId = 40050
    },
    {
      pos = ccp(133, 191),
      id = 252
    },
    {
      pos = ccp(121, 232),
      id = 253
    },
    {
      pos = ccp(189, 295),
      id = 254,
      eid = 10092,
      guildInstanceId = 40051
    },
    {
      pos = ccp(272, 303),
      id = 255
    },
    {
      pos = ccp(317, 287),
      id = 256
    },
    {
      pos = ccp(321, 209),
      id = 257,
      eid = 10093,
      guildInstanceId = 40052
    },
    {
      pos = ccp(384, 154),
      id = 258
    },
    {
      pos = ccp(422, 120),
      id = 259
    },
    {
      pos = ccp(475, 112),
      id = 260
    },
    {
      pos = ccp(572, 132),
      id = 261,
      eid = 10094,
      guildInstanceId = 40053
    },
    {
      pos = ccp(649, 135),
      id = 262
    },
    {
      pos = ccp(686, 165),
      id = 263
    },
    {
      pos = ccp(660, 203),
      id = 264
    },
    {
      pos = ccp(637, 280),
      id = 265,
      eid = 10095,
      guildInstanceId = 40054
    },
    {
      pos = ccp(576, 340),
      id = 266
    },
    {
      pos = ccp(528, 309),
      id = 267
    },
    {
      pos = ccp(454, 292),
      id = 268,
      eid = 10096,
      guildInstanceId = 40055
    }
  },
  guildInstance = true
}
map.chapter102 = {
  bg = {
    res = "UI/alpha/HVGA/stageselect_map_bg_1.jpg",
    pos = ccp(400, 212)
  },
  route = {
    res = nil,
    pos = ccp(0, 0)
  },
  stage = {}
}
map.chapter103 = {
  bg = {
    res = "UI/alpha/HVGA/stageselect_map_bg_1.jpg",
    pos = ccp(400, 212)
  },
  route = {
    res = nil,
    pos = ccp(0, 0)
  },
  stage = {}
}
class.map = map
local dotRes = {
  normal = "UI/alpha/HVGA/stageselect_chapter_dot.png",
  current = "UI/alpha/HVGA/stageselect_chapter_cursor.png"
}
class.dotRes = dotRes
class.chapter_dot_gap_x = 20
class.normal_chapter_dot_y = 40
class.elite_chapter_dot_y = 45
