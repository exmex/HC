local startCustomBattle = function()
  local list = {
    "GrayScalingShader",
    "FrozenShader",
    "StoneShader",
    "PoisonShader",
    "BanishShader",
    "InvisibleShader",
    "Blur",
    "IceShader",
    "MirrorShader"
  }
  for i = 1, #list do
    LegendLoadShader(list[i])
  end
  local left = {
    {_tid = "KOTL", _level = 80},
    {_tid = "TB", _level = 80},
    {_tid = "CM", _level = 80},
    {_tid = "Sil", _level = 80},
    {_tid = "Panda", _level = 80}
  }
  local right = {
    {_tid = "TH", _level = 80},
    {_tid = "WR", _level = 80},
    {_tid = "Med", _level = 80},
    {_tid = "SF", _level = 80},
    {_tid = "POM", _level = 80}
  }
  local stage = ed.lookupDataTable("Stage", nil, -1)
  local battle = ed.lookupDataTable("Battle", nil, -1, 1)
  ed.engine:enterArena(left, right, true, true)
  ed.scene:reset(stage, battle)
  ed.pushScene(ed.scene)
end
startCustomBattle()
