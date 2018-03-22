local list = {
  "GrayScalingShader",
  "FrozenShader",
  "StoneShader",
  "PoisonShader",
  "BanishShader",
  "InvisibleShader",
  "Blur",
  "MirrorShader"
}
if ed.run_with_scene then
  for i = 1, #list do
    LegendLoadShader(list[i])
  end
end
local victory = 0
local defeat = 1
local canceled = 2
local timeout = 3
local cheat_table = function(args)
  return {
    _checkid = args[1],
    _userid = args[2],
    _stageid = args[3],
    _result = args[4],
    _stars = args[5],
    _heroes = args[6],
    _oprations = args[7],
    _rseed = args[8],
    _cli_battle_time = args[9]
  }
end
local pve_check_msg = cheat_table
local hero = function(args)
  return {
    _tid = args[1],
    _rank = args[2],
    _level = args[3],
    _stars = args[4],
    _exp = args[5],
    _gs = args[6],
    _skill_levels = args[7],
    _items = args[8]
  }
end
local hero_equip = function(args)
  return {
    _index = args[1],
    _item_id = args[2],
    _exp = args[3]
  }
end
local data = pve_check_msg({
  388193,
  11224,
  57,
  victory,
  2,
  {
    hero({
      15,
      3,
      17,
      1,
      108,
      324,
      {
        1,
        1,
        21,
        41
      },
      {
        hero_equip({
          1,
          0,
          0
        }),
        hero_equip({
          2,
          0,
          0
        }),
        hero_equip({
          3,
          0,
          0
        }),
        hero_equip({
          4,
          0,
          0
        }),
        hero_equip({
          5,
          171,
          0
        }),
        hero_equip({
          6,
          112,
          0
        })
      }
    }),
    hero({
      4,
      3,
      18,
      1,
      232,
      343,
      {
        5,
        4,
        21,
        41
      },
      {
        hero_equip({
          1,
          0,
          0
        }),
        hero_equip({
          2,
          0,
          0
        }),
        hero_equip({
          3,
          197,
          0
        }),
        hero_equip({
          4,
          0,
          0
        }),
        hero_equip({
          5,
          0,
          0
        }),
        hero_equip({
          6,
          0,
          0
        })
      }
    }),
    hero({
      31,
      3,
      20,
      3,
      238,
      610,
      {
        10,
        7,
        21,
        41
      },
      {
        hero_equip({
          1,
          0,
          0
        }),
        hero_equip({
          2,
          172,
          0
        }),
        hero_equip({
          3,
          211,
          0
        }),
        hero_equip({
          4,
          201,
          20
        }),
        hero_equip({
          5,
          119,
          0
        }),
        hero_equip({
          6,
          112,
          0
        })
      }
    }),
    hero({
      3,
      3,
      19,
      1,
      208,
      362,
      {
        3,
        6,
        21,
        41
      },
      {
        hero_equip({
          1,
          0,
          0
        }),
        hero_equip({
          2,
          0,
          0
        }),
        hero_equip({
          3,
          0,
          0
        }),
        hero_equip({
          4,
          120,
          0
        }),
        hero_equip({
          5,
          110,
          0
        }),
        hero_equip({
          6,
          112,
          0
        })
      }
    }),
    hero({
      45,
      3,
      18,
      1,
      23,
      367,
      {
        7,
        1,
        21,
        41
      },
      {
        hero_equip({
          1,
          0,
          0
        }),
        hero_equip({
          2,
          0,
          0
        }),
        hero_equip({
          3,
          196,
          0
        }),
        hero_equip({
          4,
          173,
          0
        }),
        hero_equip({
          5,
          110,
          0
        }),
        hero_equip({
          6,
          112,
          0
        })
      }
    })
  },
  {
    1914,
    2017,
    2245,
    2564,
    2859,
    4211,
    4258,
    4433,
    4477,
    4804,
    5411,
    5612
  },
  440,
  97
})
do_battle_log = true
print = log
local run_with_scene = ed.run_with_scene
if not run_with_scene then
  logfile = io.open("log_bc.log", "w")
  ed.run_with_scene = false
  ed.srand(data._rseed)
  local stage = ed.lookupDataTable("Stage", nil, data._stageid)
  local battle = ed.lookupDataTable("Battle", nil, data._stageid, 1)
  ed.engine:enterStage(stage, data._heroes)
  ed.engine:setOperationList(data._oprations)
end
if run_with_scene then
  logfile = io.open("log_client.log", "w")
  ed.run_with_scene = true
  ed.srand(data._rseed)
  local stage = ed.lookupDataTable("Stage", nil, data._stageid)
  local battle = ed.lookupDataTable("Battle", nil, data._stageid, 1)
  ed.engine:enterStage(stage, data._heroes)
  ed.engine:setOperationList(data._oprations)
  ed.scene:reset(stage, battle, {})
  ed.pushScene(ed.scene)
end
return data
