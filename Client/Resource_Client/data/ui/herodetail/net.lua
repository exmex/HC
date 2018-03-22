local class = ed.ui.herodetail.controller
setfenv(1, class)
function dealSkillLevelup(reply)
  local result = reply._result == "success"
  local gs = reply._gs
  resetSkilllvupCache()
  local handler, data = ed.getNetReply("skill_level_up")
  if data then
    local id = data.hid
    local order = data.order
    local point = data.point
    ed.player:addSkillPoint(-point)
    for k, v in pairs(order) do
      ed.player:strenHeroSkill(id, k, v)
    end
    if result then
      ed.player.heroes[id]:resetgs(gs)
    end
  end
  if handler then
    handler(result)
  end
  if result and data then
    ed.record:refreshCommonRecord("skillUpgradeSuccess", data.point)
  end
end
