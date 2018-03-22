local class = ed.ui.excavate
setfenv(1, class)
function dealQueryExcavate(data)
  if not data then
    return
  end
  local handler = ed.netreply.queryExcavateData
  if handler then
    handler(data)
    ed.netreply.queryExcavateData = nil
  end
end
function dealSearchExcavate(data)
  if not data then
    return
  end
  local handler = ed.netreply.searchExcavate
  if handler then
    handler(data._result, data._excavate)
    ed.netreply.searchExcavate = nil
  end
end
function dealStartBattle(data)
  if not data then
    return
  end
  local result = data._result
  local rseed = data._rseed
  local heroes = data._hero_bases
  local dynas = data._hero_dynas
  local handler = ed.netreply.gotoExcavateBattleReply
  if result == "success" then
    if handler then
      handler(heroes, dynas)
    end
  else
    ed.showToast(LSTR("EXCAVATENET.FAILED_TO_ENTER_BATTLE"))
  end
  ed.srand(rseed)
  ed.netreply.gotoExcavateBattleReply = nil
end
function dealEndBattle(data)
  if not data then
    return
  end
  local result = data._result
  local excavate = data._excavate
  battleReward = data._reward
  if battleReward then
    local bt = battleReward._type
    local p1 = battleReward._param1
    local p2 = battleReward._param2
    if bt == "gold" then
      ed.player:addMoney(p1)
    elseif bt == "diamond" then
      ed.player:addrmb(p1)
    elseif bt == "item" then
      ed.player:addEquip(p1, p2)
    end
  end
  if excavate then
    occupyExcavate(excavate)
    battleReward = battleReward or {}
    ed.mercenary.clearExcavateMercenary()
  end
  if ed.netreply.exitStageReply then
    ed.netreply.exitStageReply(result)
    ed.netreply.exitStageReply = nil
  end
end
function dealSetTeam(data)
  if not data then
    return
  end
  local result = data._result
  handler = ed.netreply.setExcavateTeam
  if handler then
    handler(result)
    ed.netreply.setExcavateTeam = nil
  end
end
function dealQueryHistory(data)
  if not data then
    return
  end
  local data = data._excavate_history
  local handler = ed.netreply.queryExcavateHistory
  if handler then
    handler(data)
    ed.netreply.queryExcavateHistory = nil
  end
end
function dealQueryBattle(data)
  if not data then
    return
  end
  local data = data._battles
  local handler = ed.netreply.queryExcavateBattle
  if handler then
    handler(data)
    ed.netreply.queryExcavateBattle = nil
  end
end
function dealQueryDef(data)
  if not data then
    return
  end
  local excavate = data._excavate
  if not excavate then
    ed.showToast(T(LSTR("EXCAVATE.INVITATION_INFORMATION_IS_INVALID_")))
  else
    excavate._owner = "mine"
    ed.player.excavate_data = {}
    refreshData(excavate)
    entry({type = "defend"})
  end
end
function dealClearBattle(data)
  if not data then
    return
  end
  local result = data._result
  local handler = ed.netreply.clearExcavateBattle
  if handler then
    handler(result)
    ed.netreply.clearExcavateBattle = nil
  end
end
function dealWithDraw(data)
  if not data then
    return
  end
  local result = data._result == "success"
  local wdData = ed.netdata.withDrawExcavateHero
  if wdData then
    if result then
      local hid = wdData.heroid
      ed.player:releaseHeroes({hid})
      ed.ui.excavate.releaseHeroes({hid})
    end
    ed.netdata.withDrawExcavateHero = nil
  end
  local handler = ed.netreply.withDrawExcavateHero
  if handler then
    handler(result)
    ed.netreply.withDrawExcavateHero = nil
  end
end
function dealDrawDefReward(data)
  if not data then
    return
  end
  local result = data._result == "success"
  local vit = data._draw_vitality
  local handler = ed.netreply.drawExcavateDefReward
  if result then
    ed.player:addVitality(vit)
  end
  if handler then
    handler(result, vit)
    ed.netreply.drawExcavateDefReward = nil
  end
end
function dealDropExcavate(data)
  if not data then
    return
  end
  local result = data._result == "success"
  local handler, nData = ed.getNetReply("drop_excavate")
  local id = nData.id
  if result then
    removeExcavate(id)
  end
  if handler then
    if result then
      handler()
    else
      ed.showToast(T(LSTR("excavatenet.1.10.1.001")))
    end
  end
  local reward = data._reward
  if reward then
    do
      local tl = {
        gold = "Gold",
        diamond = "Diamond",
        item = "Item"
      }
      local t = reward._type
      local id, amount
      if t == "item" then
        id = reward._param1
        amount = reward._param2
        ed.player:addEquip(id, amount)
      else
        amount = reward._param1
        if t == "gold" then
          ed.player:addMoney(amount)
        elseif t == "diamond" then
          ed.player:addrmb(amount)
        end
      end
      ListenTimer(Timer:Once(0.2), function()
        ed.announce({
          type = "getProp",
          param = {
            title = T(LSTR("excavatenet.1.10.1.002")),
            items = {
              {
                type = tl[t],
                id = id,
                amount = amount
              }
            }
          }
        })
      end)
    end
  end
end
function dealReply(reply)
  dealQueryExcavate(reply._query_excavate_data_reply)
  dealSearchExcavate(reply._search_excavate_reply)
  dealStartBattle(reply._excavate_start_battle_reply)
  dealEndBattle(reply._excavate_end_battle_reply)
  dealSetTeam(reply._set_excavate_team_reply)
  dealQueryHistory(reply._query_excavate_history_reply)
  dealQueryBattle(reply._query_excavate_battle_reply)
  dealQueryDef(reply._query_excavate_def_reply)
  dealClearBattle(reply._clear_excavate_battle_reply)
  dealWithDraw(reply._withdraw_excavate_hero_reply)
  dealDrawDefReward(reply._draw_excavate_def_rwd_reply)
  dealDropExcavate(reply._drop_excavate_reply)
end
