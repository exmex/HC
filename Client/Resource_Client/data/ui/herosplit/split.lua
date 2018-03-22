local class = newclass("g")
ed.ui.herosplit = class
setfenv(1, class)
function popMain(callback)
  initialize()
  splitwindow.pop(callbakc)
end
function popExplain()
  explain.pop()
end
function popConfirm(hid, sid, callback)
  splitconfirm.pop(hid, sid, callback)
end
function initialize()
  ed.player.heroSplitData = {}
  split_data = ed.player.heroSplitData
  local msg = ed.upmsg.query_split_data()
  ed.send(msg, "query_split_data")
end
function doSplit(hid, sid, callback)
  ed.registerNetReply("split_hero", callback)
  local msg = ed.upmsg.split_hero()
  msg._tid = hid
  if sid then
    msg._stone_id = sid
  end
  ed.send(msg, "split_hero")
end
function canSplit(id)
  if not id then
    return false
  end
  local hero = ed.player.heroes[id]
  if not hero then
    return false
  end
  local splitData = getSplitableHeroes()
  for i, v in ipairs(splitData) do
    if v.id == id and v.splitTimes > 0 then
      return false
    end
  end
  return true
end
function getSplitableHeroes()
  return split_data.splitable_heroes or {}
end
function getSplitReturn(hid, callback)
  split_data.split_return = split_data.split_return or {}
  if not hid then
    return split_data.split_return
  end
  if not split_data.split_return[hid] then
    ed.registerNetReply("query_split_return", callback, {id = hid})
    local msg = ed.upmsg.query_split_return()
    msg._tid = hid
    ed.send(msg, "query_split_return")
    return nil
  else
    return split_data.split_return[hid]
  end
end
function sortSplitReturn(data)
  local priority_key = {
    [T(LSTR("EQUIP.ENCHANTING"))] = 1,
    [T(LSTR("EQUIP.EXPERIENCE_PILL"))] = 2,
    [T(LSTR("EQUIP.PARTS"))] = 10,
    [T(LSTR("EQUIP.SYNTHETICS"))] = 10,
    [T(LSTR("EQUIP.FRAGMENT"))] = 10,
    [T(LSTR("EQUIP.REEL"))] = 10,
    [T(LSTR("EQUIP.CONSUMABLES"))] = 20
  }
  local items = {}
  local stones = {}
  for i, v in ipairs(data._items or {}) do
    local item = ed.analyzeItem(v)
    local id = item.id
    local it = ed.itemType(id)
    if it ~= "equip" then
      print("Invalid id : " .. id)
    else
      local row = ed.getDataTable("equip")[id]
      local category = row.Category
      local consumeType = row["Consume Type"]
      if category == T(LSTR("EQUIP.SOUL_STONE")) then
        table.insert(stones, item)
      else
        table.insert(items, item)
        local p1, p2 = 0, 0
        p1 = category and (priority_key[category] or 0)
        p2 = consumeType and (priority_key[consumeType] or 0)
        local p = p1 + p2
        items[#items].priority = p
      end
    end
  end
  table.sort(items, function(a, b)
    return a.priority > b.priority
  end)
  local list = {
    items = items,
    stones = stones,
    gold = data._gold,
    skillPoint = data._skill_point
  }
  return list
end
function dealQueryData(reply)
  if not reply then
    return
  end
  local heroes = reply._heroes or {}
  for i, v in ipairs(heroes) do
    split_data.splitable_heroes = split_data.splitable_heroes or {}
    table.insert(split_data.splitable_heroes, {
      id = v._tid,
      endPoint = v._end_point,
      splitTimes = v._split_times or 0
    })
  end
end
function dealQueryReturn(reply)
  if not reply then
    return
  end
  local handler, data = ed.getNetReply("query_split_return")
  if data then
    split_data.split_return[data.id] = sortSplitReturn(reply)
  end
  if handler then
    handler(getSplitReturn(data.id))
  end
end
function dealSplitHero(reply)
  if not reply then
    return
  end
  local result = reply._result == "success"
  local hero = reply._hero
  local handler, data = ed.getNetReply("split_hero")
  local heroes = getSplitableHeroes()
  if hero then
    ed.player:resetHero(hero)
    local sid = ed.readhero.getStoneid(hero._tid)
    ed.player.equip_qunty[sid] = 0
    local id = hero._tid
    for i, v in ipairs(heroes) do
      if v.id == id then
        v.splitTimes = v.splitTimes + 1
      end
    end
    local noSplitable = true
    for i, v in ipairs(heroes) do
      if canSplit(v.id) then
        noSplitable = nil
      end
    end
    if noSplitable then
      ed.player:resetSplitableHeroesTag()
    end
    ed.ui.baselsr.create():doHeroSplit(id)
  end
  if handler then
    handler(result)
  end
end
