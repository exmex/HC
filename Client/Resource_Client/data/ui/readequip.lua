local class = newclass()
ed.readequip = class
local frame_res = {
  "white",
  "green",
  "blue",
  "purple",
  "purple",
  "orange"
}
local isEquipOpen = function(id)
  local banList = ((ed.player.global_config or {})._module_switch or {})._ban_item or {}
  if ed.isElementInTable(id, banList) then
    return false
  end
  return true
end
class.isEquipOpen = isEquipOpen

local canDisplay = function(lv)
	return (lv or 1) <= ed.parameter.team_level_max;
end
class.canDisplay = canDisplay;

local getAttRes = function()
  local res = ed.ui.baseres
  return res.att_name, res.att_pre, res.att_suffix, res.att_cn_name
end
class.getAttRes = getAttRes
local info = function()
  return ed.getDataTable("equip")
end
class.info = info
local function row(id)
  local info = info() or {}
  return info[id] or {}
end
class.row = row
local function value(id, name)
  local row = row(id) or {}
  return row[name]
end
class.value = value
local function quality(id)
  return row(id).Quality
end
class.quality = quality
local function getAttList(id)
  local att = {}
  local name, pre, suffix = getAttRes()
  for i = 1, #name do
    local attNumber = row(id)[name[i]] or 0
    if attNumber ~= 0 then
      local nm = name[i]
      att[nm] = attNumber
    end
  end
  return att
end
class.getAttList = getAttList
local function getAddAttList(id, level)
  local att = {}
  local name, pre, suffix = getAttRes()
  for i = 1, #name do
    local attNumber = (row(id)["+" .. name[i]] or 0) * level
    if attNumber > 0 then
      local nm = name[i]
      att[nm] = attNumber
    end
  end
  return att
end
class.getAddAttList = getAddAttList
local function getDescription(id, level)
  local formatList = function(list)
    local str = list.STR or 0
    local int = list.INT or 0
    local agi = list.AGI or 0
    if str == int and str == agi then
      list.ALL_ATT = str
      list.STR = 0
      list.INT = 0
      list.AGI = 0
    end
  end
  level = level or 0
  local res = ed.ui.baseres
  local name, pre, suffix, cn = getAttRes()
  local attList = {}
  local addList = {}
  local sufList = {}
  local att = getAttList(id)
  local add = getAddAttList(id, level)
  formatList(att)
  formatList(add)
  if 0 < (att.ALL_ATT or 0) then
    local element = ""
    element = cn.ALL_ATT .. " +"
    element = element .. att.ALL_ATT
    table.insert(attList, element)
    if 0 < (add.ALL_ATT or 0) then
      element = "+" .. add.ALL_ATT
      addList[#attList] = element
    else
      addList[#attList] = nil
    end
  end
  for k, v in pairs(name) do
    if (att[v] or 0) ~= 0 then
      local element = ""
      if cn[v] ~= "" then
        element = element .. cn[v]
        element = element .. (att[v] > 0 and " +" or "")
        element = element .. att[v]
      elseif att[v] > 0 or add[v] > 0 then
        element = element .. att[v]
      end
      table.insert(attList, element)
      if (add[v] or 0) ~= 0 then
        element = " +" .. add[v]
        addList[#attList] = element
        sufList[#attList] = suffix[v]
      else
        addList[#attList] = nil
        attList[#attList] = attList[#attList] .. (suffix[v] or "")
      end
    end
  end
  return attList, addList, sufList
end
class.getDescription = getDescription
local function getAttDesc(id)
  local res = ed.ui.baseres
  local name, pre, suffix, cn = getAttRes()
  local number = {}
  local attList = {}
  number = getAttList(id)
  for k, v in pairs(name) do
    if (number[v] or 0) ~= 0 then
      local element = ""
      element = element .. cn[v]
      if cn[v] ~= "" then
        element = element .. (number[v] > 0 and " +" or "")
      end
      element = element .. number[v]
      element = element .. (suffix[v] or "")
      table.insert(attList, element)
    end
  end
  return attList
end
class.getAttDesc = getAttDesc
local function isUniversalFragment(id)
  if value(id, "Name") == T(LSTR("EQUIP.UNIVERSAL_DEBRIS")) then
    return true
  end
  return false
end
class.isUniversalFragment = isUniversalFragment
local getFragmentAmount = function(id)
  local ufcan, uftotal = 0, nil
  local need, ufneed = 0, 0
  local isFragment = false
  local it = ed.itemType(id)
  if it == "equip" and ed.readequip.value(id, "Category") == T(LSTR("EQUIP.FRAGMENT")) then
    isFragment = true
    for k, v in pairs(ed.getDataTable("fragment")) do
      if v["Fragment ID"] == id then
        local ufid = v["Universal Fragment ID"]
        uftotal = ed.player.equip_qunty[ufid] or 0
        need = v["Fragment Count"]
        ufneed = v["Universal Fragment Count"]
        if uftotal > ufneed then
          ufcan = ufneed
        else
          ufcan = uftotal
        end
      end
    end
  end
  return {
    isFragment = isFragment,
    need = need,
    ufcan = ufcan,
    uftotal = uftotal,
    ufneed = ufneed
  }
end
class.getFragmentAmount = getFragmentAmount
local getHeroItems = function(hid, hero)
  local hero = hero and hero or ed.player.heroes[hid]
  if not hero then
    return {}
  else
    return hero._items
  end
end
class.getHeroItems = getHeroItems
local function getHeroItem(hid, slot, hero)
  local items = getHeroItems(hid, hero)
  local item = items[slot]
  if not item then
    return nil
  else
    return item._item_id, item._exp
  end
end
class.getHeroItem = getHeroItem
local function canHeroItemsEnhance(hid)
  local items = getHeroItems(hid)
  if not items then
    return false
  end
  local mq = 0
  local ml = true
  for i = 1, 6 do
    local id = getHeroItem(hid, i)
    if 0 < (id or 0) then
      mq = math.max(mq, ed.readequip.quality(id))
    end
    ml = ml and class.checkMaxLevel(hid, i)
  end
  return mq > 1 and not ml
end
class.canHeroItemsEnhance = canHeroItemsEnhance
local getEquipExp = function(hid, slot, hero)
  local hero = hero and hero or ed.player.heroes[hid]
  local exp = hero._items[slot]._exp
  return exp
end
class.getEquipExp = getEquipExp
local function getMaxLevel(id)
  local row = row(id)
  local quality = row.Quality
  local ehc = ed.getDataTable("enhancement")
  local erow = ehc[quality]
  local ml = 1
  if erow then
    ml = erow["Max Level"]
  end
  return ml
end
class.getMaxLevel = getMaxLevel
local function getEquipLevelExp(hid, slot, hero)
  local hero = hero and hero or ed.player.heroes[hid]
  if nil == hero then
    return
  end
  local id = hero._items[slot]._item_id
  local row = row(id)
  local quality = row.Quality
  local ehc = ed.getDataTable("enhancement")
  local erow = ehc[quality]
  local ml = erow["Max Level"]
  local le = {}
  for i = 1, ml do
    table.insert(le, erow["Price " .. i])
  end
  return le, ml
end
class.getEquipLevelExp = getEquipLevelExp
local function getEquipLevel(hid, slot, exp, hero)
  local eid = getHeroItem(hid, slot, hero)
  if (eid or 0) <= 0 then
    return 0, 0, 0, 0
  end
  exp = exp or getEquipExp(hid, slot, hero)
  local le, ml = getEquipLevelExp(hid, slot, hero)
  local te = 0
  for i = 1, #le do
    local pte = te + le[i]
    if exp < pte then
      return i - 1, exp - te, ml, le[i]
    end
    te = pte
  end
  return ml, le[ml], ml, le[ml]
end
class.getEquipLevel = getEquipLevel
local function checkEquipEnchant(hid)
  local maxSlot = 6
  for i = 1, maxSlot do
    local level, exp = getEquipLevel(hid, i)
    if level and exp and level + exp > 0 then
      return true
    end
  end
  return false
end
class.checkEquipEnchant = checkEquipEnchant
local function checkMaxLevel(hid, slot, exp)
  local l, e, ml, me = getEquipLevel(hid, slot, exp)
  if l == ml and e == me then
    return true
  end
  return false
end
class.checkMaxLevel = checkMaxLevel
local getComposedID = function(id)
  for k, v in pairs(ed.getDataTable("fragment")) do
    if v["Fragment ID"] == id then
      return k
    end
  end
  return nil
end
class.getComposedID = getComposedID
local getComponents = function(id)
  local row = ed.getDataTable("equipcraft")[id]
  if row then
    return row.Components
  else
    return 0
  end
end
class.getComponents = getComponents
local function orderEquips(list, key)
  if type(key) == "string" then
    for i = 1, #list do
      for j = i, 2, -1 do
        if (list[j][key] or 0) < (list[j - 1][key] or 0) then
          local temp = list[j - 1]
          list[j - 1] = list[j]
          list[j] = temp
        end
      end
    end
  elseif type(key) == "table" then
    if key[1] then
      orderEquips(list, key[1])
    end
    for m = 2, #key do
      for i = 1, #list do
        for j = i, 2, -1 do
          if (list[j][key[m]] or 0) < (list[j - 1][key[m]] or 0) and list[j][key[m - 1]] == list[j - 1][key[m - 1]] then
            local temp = list[j - 1]
            list[j - 1] = list[j]
            list[j] = temp
          end
        end
      end
    end
  end
end
class.orderEquips = orderEquips
local function getMaterialList()
  local list = {}
  for k, v in ipairs(ed.player.equip_order) do
    local id = v
    local amount = ed.player.equip_qunty[v]
    local category = value(v, "Category")
    local rlevel = value(v, "Level Requirement")
    local ehc = value(v, "Enhance Value") or 0
    local ct = value(v, "Consume Type")
    local name = value(v, "Name")
      local invisible = value(v, "Invisible")
      local function checkValid()
        if category == T(LSTR("EQUIP.SOUL_STONE")) then
          return false
        end
        if category == T(LSTR("EQUIP.CONSUMABLES")) and ct ~= T(LSTR("EQUIP.ENCHANTING")) then
          return false
        end
        if category == T(LSTR("EQUIP.FRAGMENT")) and name == T(LSTR("EQUIP.UNIVERSAL_DEBRIS")) then
          return false
        end
        if invisible then
          return false
        end
        if not ed.readequip.isEquipOpen(id) then
          return false
        end
        return true
      end
      if checkValid() then
      table.insert(list, {
        id = id,
        amount = amount,
        ehc = ehc,
        category = category,
        ct = ct
      })
    end
  end
  table.sort(list, function(a, b)
    local ap = a.ct == T(LSTR("EQUIP.ENCHANTING")) and 1 or 0
    local bp = b.ct == T(LSTR("EQUIP.ENCHANTING")) and 1 or 0
    if ap > bp or ap == bp and a.ehc < b.ehc then
      return true
    else
      return false
    end
  end)
  return list
end
class.getMaterialList = getMaterialList
local orderFragmentList = function(list)
  for k, v in pairs(list) do
    for i = 1, #(v or {}) do
      for j = i, 2, -1 do
        local e, pe = v[j], v[j - 1]
        local id, pid = e.id, pe.id
        if e.needAmount and pe.needAmount then
          local en, pen = ed.player:getEquipAmount(pid) >= pe.needAmount, true
          if en and not pen then
            local t = v[j]
            v[j] = v[j - 1]
            v[j - 1] = t
          end
        end
      end
    end
  end
end
class.orderFragmentList = orderFragmentList
local function classify(list)
  local list, flist = {}, {}
  for k, v in ipairs(ed.player.equip_order) do
    list[k] = {}
    list[k].id = v
    list[k].makeId = v
    list[k].amount = ed.player.equip_qunty[v]
    list[k].category = value(v, "Category")
    if list[k].category == T(LSTR("EQUIP.FRAGMENT")) then
      list[k].type = 2
      flist = flist or {}
      flist[v] = k
    else
      list[k].type = 1
    end
  end
  local cinfo = ed.getDataTable("fragment")
  for k, v in pairs(cinfo) do
    local fid = v["Fragment ID"]
    local kid = flist[fid]
    if kid then
      list[kid].needAmount = v["Fragment Count"]
      list[kid].makeId = k
      if ed.itemType(k) == "equip" then
        list[kid].category = value(k, "Category")
      elseif ed.itemType(k) == "hero" then
        list[kid].category = T(LSTR("BATTLE.HERO"))
      end
    end
  end
  local prop = {
    all = {},
    equip = {},
    scroll = {},
    stone = {},
    consume = {}
  }
  
  local fragment = {
    all = {},
    equip = {},
    scroll = {},
    hero = {}
  }
  local both = {prop, fragment}
  for k, v in ipairs(list) do
    if isEquipOpen(v.id) and not value(v.id, "Invisible") and v.amount > 0 then
      if v.category == T(LSTR("EQUIP.REEL")) then
        table.insert(both[v.type].scroll, v)
      elseif v.category == T(LSTR("EQUIP.CONSUMABLES")) then
        table.insert(both[v.type].consume, v)
      elseif v.category == T(LSTR("BATTLE.HERO")) then
        table.insert(both[v.type].hero, v)
      elseif v.category == T(LSTR("EQUIP.SOUL_STONE")) then
        table.insert(both[v.type].stone, v)
      else
        table.insert(both[v.type].equip, v)
      end
      table.insert(both[v.type].all, v)
    end
  end
  orderFragmentList(fragment)
  return prop, fragment
end
class.classify = classify
local function classifyEquip()
  local equip = {
    ALL = {},
    STR = {},
    AGI = {},
    INT = {},
    HP = {},
    AD = {},
    AP = {},
    ARM = {},
    CRIT = {},
    HPS = {},
    MPS = {},
    HEAL = {}
  }
  for k, v in pairs(info()) do
    if type(k) == "number" and isEquipOpen(k) and canDisplay(v['Display Level']) then
      local category = v.Category
      local isHide = v.Hide
      if not isHide and (category == T(LSTR("EQUIP.PARTS")) or category == T(LSTR("EQUIP.SYNTHETICS"))) then
        for tk, tv in pairs(equip) do
          if tk == "CRIT" then
            if 0 < (v[tk] or 0) then
              table.insert(equip[tk], {
                id = k,
                name = v.Name,
                lr = v["Display Level"]
              })
            elseif 0 < (v.MCRIT or 0) then
              table.insert(equip[tk], {
                id = k,
                name = v.Name,
                lr = v["Display Level"]
              })
            end
          elseif 0 < (v[tk] or 0) then
            table.insert(equip[tk], {
              id = k,
              name = v.Name,
              lr = v["Display Level"]
            })
          end
        end
        table.insert(equip.ALL, {
          id = k,
          name = v.Name,
          lr = v["Display Level"]
        })
      end
    end
  end
  for k, v in pairs(equip) do
    orderEquips(equip[k], {"lr", "id"})
  end
  return equip
end
class.classifyEquip = classifyEquip
local function createFragment(id, length, quality, addition)
  addition = addition or {}
  local fres = addition.fres
  quality = quality or value(id, "Quality") or 1
  local bg = ed.createSprite("UI/alpha/HVGA/fragment_frame_" .. frame_res[quality] .. ".png")
  bg:setCascadeOpacityEnabled(true)
  local equipBg = ed.createSprite("UI/alpha/HVGA/fragment_bg.png")
  equipBg:setAnchorPoint(ccp(0, 0))
  equipBg:setPosition(ccp(0, 0))
  bg:addChild(equipBg, -2)
  local res = fres or value(id, "Icon")
  local result = string.find(res, ".png") or string.find(res, ".jpg")
  local fragment, fragmentIcon
  if result then
    fragment, fragmentIcon = ed.createClippingNode(res, "UI/alpha/HVGA/fragment_stencil.png")
  else
    print("< " .. "Fragment ID : " .. id .. " > < Illegal Icon : " .. res .. " >")
    fragment, fragmentIcon = CCSprite:create(), CCSprite:create()
  end
  fragment:setPosition(36, 38)
  bg:addChild(fragment, -1)
  local tag = ed.createSprite("UI/alpha/HVGA/fragment_tag.png")
  tag:setPosition(ccp(15, 60))
  bg:addChild(tag)
  local s2 = (bg:getContentSize().width - 12) / fragmentIcon:getContentSize().width
  fragment:setScale(s2)
  if length then
    local s1 = length / bg:getContentSize().width
    bg:setScale(s1)
  end
  return bg, fragment
end
class.createFragment = createFragment
local function createHeroStone(id, length, quality, addition)
  addition = addition or {}
  local fres = addition.fres
  quality = quality or value(id, "Quality") or 1
  local bg = ed.createSprite("UI/alpha/HVGA/fragment_frame_" .. frame_res[quality] .. ".png")
  bg:setCascadeOpacityEnabled(true)
  local equipBg = ed.createSprite("UI/alpha/HVGA/fragment_bg.png")
  equipBg:setAnchorPoint(ccp(0, 0))
  equipBg:setPosition(ccp(0, 0))
  bg:addChild(equipBg, -2)
  local res = fres or value(id, "Icon")
  local result = string.find(res, ".png") or string.find(res, ".jpg")
  local stone, stoneIcon
  if result then
    stone, stoneIcon = ed.createClippingNode(res, "UI/alpha/HVGA/fragment_stencil.png")
  else
    print("< " .. "Fragment ID : " .. id .. " > < Illegal Icon : " .. res .. " >")
    stone, stoneIcon = CCSprite:create(), CCSprite:create()
  end
  stone:setPosition(36, 38.5)
  bg:addChild(stone, -1)
  local tag = ed.createSprite("UI/alpha/HVGA/equip_soulstone_tag.png")
  tag:setPosition(ccp(15, 60))
  bg:addChild(tag)
  local s2 = (bg:getContentSize().width - 9) / stoneIcon:getContentSize().width
  stone:setScale(s2)
  if length then
    local s1 = length / bg:getContentSize().width
    bg:setScale(s1)
  end
  return bg, stone
end
class.createHeroStone = createHeroStone
local getUnknownIcon = function(quality, length)
  local node, icon = ed.readequip.createIcon(nil, length, quality or 1, {
    fres = "UI/alpha/HVGA/handbook_icon_lock.png",
    offset = ccp(0, 2)
  })
  icon:setScale(1.005)
  local light = ed.createNode({
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/hero_equip_button_light.png"
    },
    layout = {
      position = ed.getCenterPos(node)
    }
  }, node)
  local f1 = CCFadeOut:create(1)
  local f2 = CCFadeIn:create(1)
  light:runAction(ed.readaction.create({
    t = "seq",
    isRepeat = true,
    f1,
    f2
  }))
  light:setVisible(false)
  return node, icon, light
end
class.getUnknownIcon = getUnknownIcon
local getUnknownIconYellow = function(quality, length)
  local node, icon = ed.readequip.createIcon(nil, length, quality or 1, {
    fres = "UI/alpha/HVGA/herodetail_icon_question_yellow.png",
    offset = ccp(0, 2)
  })
  icon:setScale(1.5)
  local light = ed.createNode({
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/hero_equip_button_light.png"
    },
    layout = {
      position = ed.getCenterPos(node)
    }
  }, node)
  local f1 = CCFadeOut:create(1)
  local f2 = CCFadeIn:create(1)
  light:runAction(ed.readaction.create({
    t = "seq",
    isRepeat = true,
    f1,
    f2
  }))
  light:setVisible(false)
  return node, icon, light
end
class.getUnknownIconYellow = getUnknownIconYellow
local getUnknownHeroStone = function()
  local node, icon = ed.readequip.createHeroStone(nil, nil, 1, {
    fres = "UI/alpha/HVGA/handbook_icon_lock.png"
  })
  icon:setScale(1.005)
  return node, icon
end
class.getUnknownHeroStone = getUnknownHeroStone
local function createSmallFragment(id, quality)
  local bg, fragment = createFragment(id, 38, quality)
  return bg, fragment
end
class.createSmallFragment = createSmallFragment
local function createIcon(id, length, quality, addition)
  local function getFrameRes(quality)
    quality = quality or 1
    return "UI/alpha/HVGA/equip_frame_" .. frame_res[quality] .. ".png"
  end
  local bg, equip, enode, itemType
  addition = addition or {}
  local fres = addition.fres
  if fres then
    equip = ed.createSprite(fres)
    bg = ed.createSprite(getFrameRes(quality))
    equip:setPosition(ccpAdd(ed.getCenterPos(bg), addition.offset or ccp(0, 0)))
    bg:addChild(equip, -1)
    local equipBg = ed.createSprite("UI/alpha/HVGA/gocha.png")
    equipBg:setAnchorPoint(ccp(0, 0))
    equipBg:setPosition(ccp(0, 0))
    bg:addChild(equipBg, -2)
  elseif type(id) == "string" then
    local icon_res = {
      Gold = "UI/alpha/HVGA/task_gold_icon.png",
      Diamond = "UI/alpha/HVGA/task_rmb_icon.png",
      Vitality = "UI/alpha/HVGA/task_vit_icon.png"
    }
    equip = ed.createSprite(icon_res[id])
    bg = ed.createSprite(getFrameRes(quality))
    equip:setPosition(ed.getCenterPos(bg))
    bg:addChild(equip, -1)
  elseif type(id) == "number" then
    local type = ed.itemType(id)
    itemType = type
    local res
    if type == "equip" then
      res = value(id, "Icon")
      quality = quality or value(id, "Quality")
      local category = value(id, "Category")
      if category == T(LSTR("EQUIP.FRAGMENT")) then
        return createFragment(id, length, quality)
      end
      if category == T(LSTR("EQUIP.SOUL_STONE")) then
        return createHeroStone(id, length, quality)
      end
    elseif type == "hero" then
      local unitData = ed.getDataTable("Unit")[id]
      if unitData ~= nil then
        res = unitData.Portrait
      end
      --[[开放觉醒后使用
      res = ed.getDataTable("Unit")[id][ed.getPortraitSwitchRowName({
        _tid = id,
        _arousal = {
          _status = ed.awakeUnlockedNumber(id),
          0
        }
      })]
      ]]
    end
    quality = quality or 1
    bg = ed.createSprite(getFrameRes(quality))
    bg:setCascadeOpacityEnabled(true)
    local equipBg = ed.createSprite("UI/alpha/HVGA/gocha.png")
    equipBg:setAnchorPoint(ccp(0, 0))
    equipBg:setPosition(ccp(0, 0))
    bg:addChild(equipBg, -2)
    if type ~= "hero" then
      equip = ed.createSprite(res)
      equip:setPosition(ccp(36, 39))
      bg:addChild(equip, -1)
    else
      equip, enode = ed.createClippingNode(res, "UI/alpha/HVGA/equip_stencil.png", 0.02)
      equip:setPosition(ccp(36, 39))
      bg:addChild(equip, -1)
    end
  end
  if not tolua.isnull(equip) then
    if type(id) == "string" then
      local s2 = (bg:getContentSize().width - 9) / equip:getContentSize().width
      equip:setScale(s2)
    end
    if value(id, "Category") == T(LSTR("EQUIP.SOUL_STONE")) then
      local s2 = (bg:getContentSize().width - 9) / equip:getContentSize().width
      equip:setScale(s2)
    end
    if itemType == "hero" then
      local s2 = (bg:getContentSize().width - 9) / enode:getContentSize().width
      equip:setScale(s2)
    end
  end
  if length then
    local s1 = length / bg:getContentSize().width
    bg:setScale(s1)
  end
  return bg, equip
end
class.createIcon = createIcon
local createUnitIcon = function(id, length, quality)
  if (quality or 0) <= 1 then
    quality = 1
  end
  local bg = ed.createSprite(ed.Hero.getIconFrameByRank(quality))
  bg:setCascadeOpacityEnabled(true)
  local unit = ed.createSprite(ed.getDataTable("Unit")[id].Portrait)
  --[[开放觉醒后开启
  local unit = ed.createSprite(ed.getDataTable("Unit")[id][ed.getPortraitSwitchRowName({
    _tid = id,
    _arousal = {
      _status = ed.awakeUnlockedNumber(id),
      0
    }
  })])]]
  unit:setAnchorPoint(ccp(0, 0))
  unit:setPosition(ccp(3, 5))
  bg:addChild(unit, -1)
  local s2 = (bg:getContentSize().width - 6) / unit:getContentSize().width
  unit:setScale(s2)
  if length then
    local s1 = length / bg:getContentSize().width
    bg:setScale(s1)
  end
  return bg
end
class.createUnitIcon = createUnitIcon
local function createIconWithAmount(id, length, amount, quality)
  local bg, equip = createIcon(id, length, quality)
  amount = amount or ed.player.equip_qunty[id] or 0
  local amountLabel
  if amount > 1 then
    amountLabel = ed.getNumberNode({
      text = "" .. amount,
      folder = "prop_amount",
      padding = -1
    })
    local alNode = amountLabel.node
    alNode:setAnchorPoint(ccp(1, 0.5))
    alNode:setPosition(ccp(68, 18))
    bg:addChild(alNode)
  end
  return bg, equip, amountLabel
end
class.createIconWithAmount = createIconWithAmount
local isFragmentEnough = function(id)
  if not id then
    return false
  end
  if not ed.getDataTable("equip")[id] then
    return false
  end
  local category = ed.getDataTable("equip")[id].Category
  if category ~= T(LSTR("EQUIP.FRAGMENT")) then
    return
  end
  local info = ed.getDataTable("fragment")
  local makeId
  local needAmount = 0
  for k, v in pairs(info) do
    if v["Fragment ID"] == id then
      needAmount = v["Fragment Count"]
      makeId = k
      break
    end
  end
  if needAmount > ed.player.equip_qunty[id] then
    return false
  else
    if ed.itemType(makeId) == "hero" and ed.player.heroes[makeId] then
      return false
    end
    return true
  end
end
class.isFragmentEnough = isFragmentEnough
local function createIconWithTag(id, length, amount, quality)
  local info = ed.getDataTable("fragment")[id]
  local fid, needAmount, universalId, needUniversalAmount
  if not info then
    fid = id
    needAmount = 999999
    universalId = 0
    needUniversalAmount = 99999
  else
    fid = info["Fragment ID"]
    needAmount = info["Fragment Count"]
    universalId = info["Universal Fragment ID"]
    needUniversalAmount = info["Universal Fragment Count"]
  end
  local canCompose
  local lack = needAmount - (ed.player.equip_qunty[fid] or 0)
  if lack <= 0 then
    canCompose = true
  else
    canCompose = false
  end
  local bg, fragment, amountLabel = createIconWithAmount(fid, length, amount, quality)
  local isOwnedHero
  if ed.itemType(id) == "hero" and ed.player.heroes[id] then
    isOwnedHero = true
  end
  local tag
  if canCompose and not isOwnedHero then
    tag = ed.createSprite("UI/alpha/HVGA/fragment_tick.png")
    tag:setAnchorPoint(ccp(0, 0))
    tag:setPosition(ccp(4, 4))
    bg:addChild(tag)
  end
  return bg, fragment, amountLabel, tag
end
class.createIconWithTag = createIconWithTag
local function createSmallIcon(id, quality)
  local bg, equip = createIcon(id, 38, quality)
  return bg, equip
end
class.createSmallIcon = createSmallIcon
local getNameCard = function(name)
  local namePanel = ed.createSprite("UI/alpha/HVGA/craft_promt_bg.png")
  namePanel:setAnchorPoint(ccp(0.5, 0))
  namePanel:setCascadeOpacityEnabled(true)
  local label = ed.createttf(name, 20)
  label:setPosition(ccp(namePanel:getContentSize().width / 2, namePanel:getContentSize().height / 2 + 5))
  namePanel:addChild(label)
  if label:getContentSize().width > namePanel:getContentSize().width then
    namePanel:setScaleX(label:getContentSize().width / namePanel:getContentSize().width * 1.06)
    label:setScaleX(namePanel:getContentSize().width / label:getContentSize().width / 1.06)
  end
  return namePanel
end
class.getNameCard = getNameCard
local function getDetailCard(id, info, config)
  config = config or {}
  local ow, oh = config.ow, config.oh
  local anchor = config.anchor or ccp(0.5, 0)
  local noArrow = config.noArrow or true
  oh = oh or 0
  local pw, ph = ow or 280, 70
  local lh = 0
  local function createLabel(text)
    local label = ed.createttf(text, 16)
    label:setHorizontalAlignment(kCCTextAlignmentLeft)
    label:setVerticalAlignment(kCCVerticalTextAlignmentTop)
    ed.setLabelDimensions(label, CCSizeMake(pw - 40, 0))
    label:setAnchorPoint(ccp(0, 0))
    return label
  end
  info = info or {}
  local basey = 30
  local panel
  if noArrow then
    panel = ed.createScale9Sprite("UI/alpha/HVGA/main_vit_tips.png", CCRectMake(10, 10, 58, 26))
  else
    panel = ed.createScale9Sprite("UI/alpha/HVGA/craft_promt_bg.png", CCRectMake(15, 15, 114, 15))
  end
  panel:setAnchorPoint(anchor)
  local scItemHeight = 15
  if info.ps then
    local ps = ed.createttf(info.ps, 16)
    ed.setLabelShadow(ps, ccc3(0, 0, 0), ccp(0, 2))
    ed.setLabelDimensions(ps, CCSizeMake(pw - 40, 0))
    local size = ps:getContentSize()
    local psh = size.height
    ps:setHorizontalAlignment(kCCTextAlignmentLeft)
    ps:setAnchorPoint(ccp(0, 0.5))
    ps:setPosition(ccp(20, 10 + psh / 2))
    ed.setLabelColor(ps, ccc3(238, 204, 119))
    panel:addChild(ps)
    oh = psh + oh - 10
    scItemHeight = 30
  end
  if type(id) == "string" then
    local s_des = {
      Gold = T(LSTR("READEQUIP.GOLD_IS_GENERALLY_CURRENCIES")),
      Diamond = T(LSTR("READEQUIP.DIAMOND_IS_THE_WORLDS_MOST_COMMON_CURRENCY")),
      rand_soul = T(LSTR("READEQUIP.IT_COULD_BE_ANY_HEROS_SOUL_STONE_"))
    }
    local ds = s_des[id]
    if ds then
      local descLabel = createLabel(ds)
      descLabel:setPosition(ccp(20, scItemHeight + lh + oh))
      panel:addChild(descLabel, 5)
      lh = lh + descLabel:getContentSize().height
      ed.setLabelColor(descLabel, ccc3(241, 193, 113))
      lh = lh + 10
    end
    panel:setContentSize(CCSizeMake(pw, scItemHeight + lh + oh))
    return panel
  end
  local level, levelText, category
  local description = {}
  local detail
  local descLabel = {}
  local detailLabel, row
  if ed.itemType(id) == "hero" or info.isUnit then
    row = ed.getDataTable("Unit")[id]
    level = info.level or 1
    levelText = "LV." .. level
    description = row.Description
    if description then
      descLabel = createLabel(description)
      descLabel:setPosition(ccp(20, basey + lh + oh))
      panel:addChild(descLabel, 5)
      lh = lh + descLabel:getContentSize().height
      ed.setLabelColor(descLabel, ccc3(241, 193, 113))
      lh = lh + 10
    end
  elseif ed.itemType(id) == "equip" then
    row = ed.getDataTable("equip")[id]
    category = row.Category
    if not ed.isElementInTable(category, {
      T(LSTR("EQUIP.CONSUMABLES"))
    }) then
      level = row["Level Requirement"] or 1
      levelText = T(LSTR("READEQUIP.REQUIRED_LEVEL_")) .. level
    end
    if category == T(LSTR("EQUIP.PARTS")) or category == T(LSTR("EQUIP.SYNTHETICS")) then
      detail = row.Description
      if detail then
        detailLabel = createLabel(detail)
        detailLabel:setPosition(ccp(20, basey + lh + oh))
        panel:addChild(detailLabel, 5)
        lh = lh + detailLabel:getContentSize().height
        ed.setLabelColor(detailLabel, ccc3(241, 193, 113))
        lh = lh + 10
      end
      local dss = getAttDesc(id)
      for i = #dss, 1, -1 do
        description[#dss + 1 - i] = dss[i]
      end
      local makeGap
      for k, v in pairs(description or {}) do
        if not makeGap and lh > 0 then
          lh = lh + 10
        end
        makeGap = true
        local label = createLabel(v)
        label:setPosition(ccp(20, basey + lh + oh))
        ed.setLabelColor(label, ccc3(241, 193, 113))
        lh = lh + label:getContentSize().height
        panel:addChild(label, 5)
      end
      if makeGap then
        lh = lh + 10
      end
    else
      detail = row.Comment
      if detail then
        detailLabel = createLabel(detail)
        detailLabel:setPosition(ccp(20, basey + lh + oh))
        ed.setLabelColor(detailLabel, ccc3(241, 193, 113))
        panel:addChild(detailLabel, 5)
        lh = lh + detailLabel:getContentSize().height
        lh = lh + 10
      end
      description = row.Description
      if description then
        if lh > 0 then
          lh = lh + 10
        end
        descLabel = createLabel(description)
        descLabel:setPosition(ccp(20, basey + lh + oh))
        ed.setLabelColor(descLabel, ccc3(241, 193, 113))
        panel:addChild(descLabel, 5)
        lh = lh + descLabel:getContentSize().height
        lh = lh + 10
      end
    end
  end
  local detailBg = ed.createSprite("UI/alpha/HVGA/tip_detail_bg.png")
  detailBg:setAnchorPoint(ccp(0, 0))
  detailBg:setPosition(ccp(0, basey - 5 + oh))
  panel:addChild(detailBg)
  local s = detailBg:getContentSize()
  detailBg:setScaleX(pw / s.width)
  detailBg:setScaleY(lh / s.height)
  lh = lh + 10
  local level = ed.createttf(levelText, 15)
  level:setAnchorPoint(ccp(0, 0))
  level:setPosition(ccp(70, lh + 20 + oh))
  ed.setLabelColor(level, ccc3(255, 234, 198))
  panel:addChild(level)
  if ed.itemType(id) == "hero" or info.isUnit then
    local hr = ed.heroLevel2Rank(info.level)
    local icon = createUnitIcon(id, 40, hr)
    icon:setAnchorPoint(ccp(0, 0))
    icon:setPosition(20, lh + 20 + oh)
    panel:addChild(icon)
    local name, w, h = ed.readhero.createHeroNameByInfo({
      name = row["Display Name"],
      rank = hr,
      shadow = { color = ccc3(0, 0, 0), offset = ccp(0, 2) }
    })
    name:setScale(0.75)
    name:setPosition(ccp(70, lh + 40 + oh + h / 2 * 0.75))
    panel:addChild(name)
    if info.isBoss then
      local bossLabel = ed.createttf("BOSS", 15)
      bossLabel:setAnchorPoint(ccp(0, 0))
      bossLabel:setPosition(ccp(120, lh + 20 + oh))
      ed.setLabelColor(bossLabel, ccc3(255, 102, 49))
      panel:addChild(bossLabel)
    end
  elseif ed.itemType(id) == "equip" then
    local icon = createIcon(id, 40)
    icon:setAnchorPoint(ccp(0, 0))
    icon:setPosition(20, lh + 20 + oh)
    panel:addChild(icon)
    local name = ed.createttf(row.Name, 15)
    local w = name:getContentSize().width
    if 160 < w then
      name:setScale(160 / w)
    end
    name:setAnchorPoint(ccp(0, 0))
    name:setPosition(ccp(70, lh + 40 + oh))
    panel:addChild(name)
    if ed.isElementInTable(row.Category, {
      T(LSTR("EQUIP.FRAGMENT")),
      T(LSTR("EQUIP.SOUL_STONE"))
    }) then
      local amount, need = 0, 0
      if row.Category == T(LSTR("EQUIP.FRAGMENT")) then
        amount = ed.player.equip_qunty[id] or 0
        need = getFragmentAmount(id).need or 999
      else
        local makeid = getComposedID(id)
        if ed.itemType(makeid) == "hero" then
          amount = ed.readhero.getStoneAmount(makeid)
          need = ed.readhero.getStoneNeed(makeid)
        end
      end
      if need then
        local lb1 = ed.createttf("(", 15)
        lb1:setPosition(ed.getRightSidePos(name, 5))
        lb1:setAnchorPoint(ccp(0, 0))
        ed.setLabelColor(lb1, ed.toccc3(16114110))
        panel:addChild(lb1)
        local lb2 = ed.createttf(amount, 15)
        lb2:setPosition(ed.getRightSidePos(lb1))
        lb2:setAnchorPoint(ccp(0, 0))
        ed.setLabelColor(lb2, (amount < need and ed.toccc3(16737841) or ed.toccc3(16114110)))
        panel:addChild(lb2)
        local lb3 = ed.createttf(string.format("/%d)", need), 15)
        lb3:setPosition(ed.getRightSidePos(lb2))
        lb3:setAnchorPoint(ccp(0, 0))
        ed.setLabelColor(lb3, ed.toccc3(16114110))
        panel:addChild(lb3)
      end
    end
    local goldLabel = ed.createttf(math.floor(row["Buy Price"]), 15)
    goldLabel:setAnchorPoint(ccp(1, 0))
    goldLabel:setPosition(ccp(pw - 20, lh + 20 + oh))
    ed.setLabelColor(goldLabel, ccc3(251, 206, 16))
    panel:addChild(goldLabel)
    local goldIcon = ed.createSprite("UI/alpha/HVGA/goldicon_small.png")
    goldIcon:setScale(0.5)
    goldIcon:setAnchorPoint(ccp(1, 0))
    goldIcon:setPosition(ccp(pw - 20 - goldLabel:getContentSize().width - 5, lh + 20 + oh))
    panel:addChild(goldIcon)
  end
  panel:setContentSize(CCSizeMake(pw, ph + lh + oh))
  return panel
end
class.getDetailCard = getDetailCard
local getEquipableHeroList = function(id)
  local hList = {}
  local eid = id
  local row = ed.getDataTable("equip")[id]
  if not row then
    return {}
  end
  local category = row.Category
  if category == T(LSTR("EQUIP.FRAGMENT")) then
    local ft = ed.getDataTable("fragment")
    for k, v in pairs(ft) do
      if v["Fragment ID"] == id then
        eid = k
        break
      end
    end
  end
  for k, v in pairs(ed.player.heroes) do
    local hero = v
    local tid = hero._tid
    local rank = hero._rank
    for i = 1, 6 do
      local equip = ed.getDataTable("hero_equip")[tid][rank]["Equip" .. i .. " ID"]
      if equip == eid and hero:getEquipid(i) == 0 then
        table.insert(hList, hero)
        break
      end
    end
  end
  return hList
end
class.getEquipableHeroList = getEquipableHeroList
local function createStagedoneLootIcon(id, length, amount, quality)
  local bg, equip, amountLabel = createIconWithAmount(id, length, amount, quality)
  local tag
  if ed.isPropEquipable(id) then
    tag = ed.createSprite("UI/alpha/HVGA/can_deal_tag.png")
    local size = bg:getContentSize()
    local px = length and length - 8 or size.width - 8
    local py = px
    tag:setPosition(ccp(px, py))
    bg:addChild(tag)
  end
  return bg, equip, amountLabel, tag
end
class.createStagedoneLootIcon = createStagedoneLootIcon
local function getShapeFrameRes(id)
  local fres
  if 0 < (id or 0) then
    local fm
    local it = ed.itemType(id)
    if it == "equip" then
      local category = ed.readequip.value(id, "Category")
      if category == T(LSTR("EQUIP.FRAGMENT")) or category == T(LSTR("EQUIP.SOUL_STONE")) then
        fm = true
      end
    end
    if fm then
      fres = "UI/alpha/HVGA/task_fragment_icon_bg.png"
    else
      fres = "UI/alpha/HVGA/task_icon_bg.png"
    end
  else
    fres = "UI/alpha/HVGA/task_icon_bg.png"
  end
  return fres
end
class.getShapeFrameRes = getShapeFrameRes
local function createIconWithLevel(id, level, showGray)
  local ox, oy = 58, 18
  local dx, dy = 0, 10
  local bg, equip = createIcon(id)
  local star = {}
  local ml = getMaxLevel(id)
  if (showGray or level > 0) and ml >= 1 then
    local starBg = ed.createSprite("UI/alpha/HVGA/equipupgrade/equipupgrade_equip_bg.png")
    starBg:setAnchorPoint(ccp(0, 0))
    starBg:setPosition(ccp(0, 0))
    bg:addChild(starBg)
  end
  for i = 1, level do
    local goldStar = ed.createSprite("UI/alpha/HVGA/equipupgrade/equipupgrade_star_blue.png")
    goldStar:setScale(0.9)
    goldStar:setPosition(ccp(ox, oy + dy * (i - 1)))
    bg:addChild(goldStar)
    star[i] = {type = "y", icon = goldStar}
  end
  if showGray then
    for i = level + 1, ml do
      local grayStar = ed.createSprite("UI/alpha/HVGA/equipupgrade/equipupgrade_star_grey.png")
      grayStar:setScale(0.9)
      grayStar:setPosition(ccp(ox, oy + dy * (i - 1)))
      bg:addChild(grayStar)
      star[i] = {type = "n", icon = grayStar}
    end
  end
  return bg, equip, star
end
class.createIconWithLevel = createIconWithLevel
local function createHeroItem(hid, slot, showGray, hero)
  local id = getHeroItem(hid, slot, hero)
  local l, e, ml, me = getEquipLevel(hid, slot, nil, hero)
  return createIconWithLevel(id, l, showGray)
end
class.createHeroItem = createHeroItem
local function createESHeroItem(hid, slot)
  return createHeroItem(hid, slot, true)
end
class.createESHeroItem = createESHeroItem
local function refreshHeroItemStar(hid, slot, stars)
  local l, e, ml, me = getEquipLevel(hid, slot)
  for i = 1, l do
    if stars[i].type == "n" then
      local parent = stars[i].icon:getParent()
      local pos = ccp(stars[i].icon:getPosition())
      local goldStar = ed.createSprite("UI/alpha/HVGA/equipupgrade/equipupgrade_star_blue.png")
      goldStar:setScale(0.9)
      goldStar:setPosition(pos)
      parent:addChild(goldStar)
      stars[i].icon = goldStar
    end
  end
end
class.refreshHeroItemStar = refreshHeroItemStar
