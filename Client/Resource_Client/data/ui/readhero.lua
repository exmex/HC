local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.readhero = class
local function getHero(hid)
  return ed.player.heroes[hid]
end
class.getHero = getHero
local function getHeroAttByHero(hero)
  if nil == hero then
    return
  end
  local attInfo = {}
  local unit = ed.UnitCreate(hero)
  local att = unit.attribs
  local oriAtt = unit.orig_attribs
  for k, v in pairs(att) do
    if v ~= 0 then
      local base = math.floor(oriAtt[k] + 0.5)
      local add = math.floor(v + 0.5) - base
      attInfo[k] = {
        base = base,
        add = add,
        all = v
      }
    end
  end
  return attInfo
end
class.getHeroAttByHero = getHeroAttByHero
local function getHeroAtt(hid)
  local hero = getHero(hid)
  return getHeroAttByHero(hero)
end
class.getHeroAtt = getHeroAtt
local function getHeroInitStars(hid)
  local row = ed.getDataTable("Unit")[hid] or {}
  local stars = row["Initial Stars"] or 0
  return stars
end
class.getHeroInitStars = getHeroInitStars
local function getHeroEquipgs(hid)
  local hero = getHero(hid)
  local equips = hero._items
  local gs = 0
  for i = 1, #equips do
    local equip = equips[i]
    local slot = equip._index
    local id = equip._item_id
    local row = ed.getDataTable("equip")[id]
    if row then
      gs = gs + (row["+GS"] or 0) * ed.readequip.getEquipLevel(hid, slot)
    end
  end
  return gs
end
class.getHeroEquipgs = getHeroEquipgs
local function getHeroEquiphp(hid)
  local hero = getHero(hid)
  local equips = hero._items
  local hp = 0
  local ratio = ed.parameter.stren_health_ratio
  for i = 1, #equips do
    local equip = equips[i]
    local slot = equip._index
    local id = equip._item_id
    local row = ed.getDataTable("equip")[id]
    local level = ed.readequip.getEquipLevel(hid, slot)
    if row then
      local sa = row["+STR"]
      local ha = row["+HP"]
      hp = hp + ratio * sa * level + ha * level
    end
  end
  return hp
end
class.getHeroEquiphp = getHeroEquiphp
local function getHeroUpgradeInfo(hid)
  local hero = ed.readhero.getHero(hid)
  local unit = ed.UnitCreate(hero)
  local att = unit.attribs
  local oriAtt = unit.orig_attribs
  local gsAdded = ed.readhero.getHeroEquipgs(hid)
  local hpAdded = ed.readhero.getHeroEquiphp(hid)
  gsAdded = math.floor(gsAdded)
  hpAdded = math.floor(hpAdded)
  local rank = hero._rank
  local gs = hero._gs - gsAdded
  local hp = unit.attribs.HP - hpAdded
  gs = math.floor(gs)
  hp = math.floor(hp)
  return {
    rank = rank,
    gs = gs,
    hp = hp,
    gsAdded = 0,
    hpAdded = 0,
    unit = unit
  }
end
class.getHeroUpgradeInfo = getHeroUpgradeInfo
local function getGrowthByHero(hero, star)
  if nil == hero then
    return {}
  end
  if not hero then
    return {}
  end
  local row = ed.getDataTable("Unit")[hero._tid]
  if not star then
    star = hero._stars
  elseif star < 0 then
    star = hero._stars + star
  end
  if star <= 0 then
    return {}
  end
  local growth = {}
  local keys = {
    STR = "+STR",
    AGI = "+AGI",
    INT = "+INT"
  }
  for k, v in pairs(keys) do
    v = v .. (star or 1)
    growth[k] = row[v]
  end
  return growth
end
class.getGrowthByHero = getGrowthByHero
local function getGrowth(hid, star)
  local hero = ed.player.heroes[hid]
  return getGrowthByHero(hero, star)
end
class.getGrowth = getGrowth
local function addHeroStateText(self, state)
  if self == nil or state == nil then
    return
  end
  if state == "mercenary" then
    local s = ed.createSprite("UI/alpha/HVGA/herostatus_text_hire.png")
    s:setPosition(ccp(40, 65))
    self.icon:addChild(s, 5)
    local shade = CCLayerColor:create(ccc4(0, 0, 0, 150))
    shade:setContentSize(self.icon:getContentSize())
    self.icon:addChild(shade)
  end
  if self.hpNode then
    self.hpNode:setVisible(false)
  end
end
class.addHeroStateText = addHeroStateText
local function addMercenaryInfo(self, mercenaryInfo)
  if self == nil or mercenaryInfo == nil then
    return
  end
  local icon = self.icon
  if nil == icon then
    return
  end
  local mercenaryIcon = ed.createSprite("UI/alpha/HVGA/heroselect_tag_hire.png")
  mercenaryIcon:setPosition(ccp(4, 75))
  icon:addChild(mercenaryIcon, 18)
  if mercenaryInfo.owner then
    local bg = ed.createScale9Sprite("UI/alpha/HVGA/herodetail_skill_bg_1.png", CCRectMake(15, 15, 15, 15))
    bg:setContentSize(CCSizeMake(146, 155))
    bg:setPosition(ccp(40, 38))
    icon:addChild(bg, -1)
    local levelBg = ed.createSprite("UI/alpha/HVGA/guild/guild_hire_name_bg.png")
    levelBg:setAnchorPoint(ccp(0.5, 0.5))
    levelBg:setPosition(ccp(40, 101))
    icon:addChild(levelBg)
    local nameLabel = ed.createttf(mercenaryInfo.owner, 18)
    nameLabel:setAnchorPoint(ccp(0.5, 0.5))
    nameLabel:setPosition(ccp(40, 101))
	if nameLabel:getContentSize().width > 110 then
		nameLabel:setScale(110 / nameLabel:getContentSize().width)
	end
    icon:addChild(nameLabel)
  end
  if mercenaryInfo.cost then
    local levelBg = ed.createSprite("UI/alpha/HVGA/guild/guild_hire_price_bg.png")
    levelBg:setAnchorPoint(ccp(0.5, 0.5))
    levelBg:setPosition(ccp(40, -23))
    icon:addChild(levelBg)
    if mercenaryInfo.cost > 0 then
      local goldIcon = ed.createSprite("UI/alpha/HVGA/goldicon_small.png")
      goldIcon:setAnchorPoint(ccp(0.5, 0.5))
      goldIcon:setPosition(ccp(11, -23))
      goldIcon:setScale(0.8)
      icon:addChild(goldIcon)
      local fontInfo = ed.player._money >= mercenaryInfo.cost and "normal_button" or "normal_red"
      local costLabel = ed.createLabelWithFontInfo(mercenaryInfo.cost, fontInfo)
      costLabel:setAnchorPoint(ccp(0.5, 0.5))
      costLabel:setPosition(ccp(50, -23))
      icon:addChild(costLabel)
      self.costLabel = costLabel
    else
      local costLabel = ed.createLabelWithFontInfo("Ãâ·Ñ", "normal_button")
      costLabel:setAnchorPoint(ccp(0.5, 0.5))
      costLabel:setPosition(ccp(40, -23))
      icon:addChild(costLabel)
      self.costLabel = costLabel
    end
  end
  if mercenaryInfo.sort == "bLevel" or mercenaryInfo.sort == "bHired" then
    local unMercenaryIcon = ed.createSprite("UI/alpha/HVGA/guild/herostatus_text_unavailable.png")
    unMercenaryIcon:setAnchorPoint(ccp(0.5, 0.5))
    unMercenaryIcon:setPosition(ccp(40, 66))
    icon:addChild(unMercenaryIcon, 20)
    local shade1 = CCLayerColor:create(ccc4(0, 0, 0, 150))
    shade1:setContentSize(icon:getContentSize())
    icon:addChild(shade1, 3)
  end
end
local function addMonsterHpInfo(self, info)
  if nil == info then
    return
  end
  local icon = self.icon
  if nil ~= info.hp then
    local hpNode = CCNode:create()
    if info.hp <= 0 then
      local die = ed.createSprite("UI/alpha/HVGA/crusade/crusade_text_dead.png")
      die:setPosition(44, 65)
      hpNode:addChild(die, 10)
      local shade = CCLayerColor:create(ccc4(0, 0, 0, 150))
      shade:setContentSize(icon:getContentSize())
      hpNode:addChild(shade)
    else
      local hpbg = ed.createSprite("UI/alpha/HVGA/guild/guildraid_stagedetail_enemy_hp_bg.png")
      local hp = ed.createSprite("UI/alpha/HVGA/guild/guildraid_stagedetail_enemy_hp.png")
      hpbg:setAnchorPoint(ccp(0, 0.5))
      hp:setAnchorPoint(ccp(0, 0.5))
      hpbg:setPosition(ccp(10, 68))
      hp:setPosition(10, 68)
      hpNode:addChild(hpbg)
      hpNode:addChild(hp)
      local pecent = info.hp / 10000
      hp:setScaleX(pecent)
      local textLabel = ed.createLabelTTF(string.format("%.1d%%", pecent * 100), 18)
      textLabel:setAnchorPoint(ccp(0.5, 0.5))
      textLabel:setPosition(ccp(41, 67))
      hpNode:addChild(textLabel)
      self.hpLabel = textLabel
    end
    icon:addChild(hpNode)
    self.hpNode = hpNode
  end
end
class.addMonsterHpInfo = addMonsterHpInfo
local function addHpInfo(self, info)
  if nil == info then
    return
  end
  local icon = self.icon
  if nil ~= info.hp then
    local hpNode = CCNode:create()
    if info.hp <= 0 then
      local die = ed.createSprite("UI/alpha/HVGA/crusade/crusade_text_dead.png")
      die:setPosition(44, 65)
      hpNode:addChild(die, 10)
      local shade = CCLayerColor:create(ccc4(0, 0, 0, 150))
      shade:setContentSize(icon:getContentSize())
      hpNode:addChild(shade)
    else
      local hpbg = ed.createSprite("UI/alpha/HVGA/crusade/crusade_hp_bar_bg.png")
      local hp = ed.createSprite("UI/alpha/HVGA/crusade/crusade_hp_bar.png")
      hpbg:setAnchorPoint(ccp(0, 0.5))
      hp:setAnchorPoint(ccp(0, 0.5))
      hpbg:setPosition(ccp(11, 71))
      hp:setPosition(11, 71)
      hpNode:addChild(hpbg)
      hpNode:addChild(hp)
      hp:setScaleX(info.hp / 10000)
      if nil ~= info.mp then
        local mpbg = ed.createSprite("UI/alpha/HVGA/crusade/crusade_mp_bar_bg.png")
        local mp = ed.createSprite("UI/alpha/HVGA/crusade/crusade_mp_bar.png")
        mpbg:setAnchorPoint(ccp(0, 0.5))
        mp:setAnchorPoint(ccp(0, 0.5))
        mpbg:setPosition(ccp(11, 64))
        mp:setPosition(11, 64)
        hpNode:addChild(mpbg)
        hpNode:addChild(mp)
        mp:setScaleX(info.mp / 10000)
      end
    end
    icon:addChild(hpNode)
    self.hpNode = hpNode
  end
end
class.addHpInfo = addHpInfo
local function createIcon(info)
  local self = {}
  setmetatable(self, class.mt)
  info = info or {}
  self.info = info
  local id = info.id
  local rank = info.rank or 1
  local level = info.level
  local stars = info.stars
  local length = info.length
  local isHideFrame = info.isHideFrame
  local withShade = info.withShade
  local state = info.state
  local text = info.text
  local textColor = info.textColor
  local unitInfo = ed.getDataTable("Unit")[id]
  local icon

  local container = CCSprite:create()
  container:setContentSize(ed.DGSizeMake(104, 104))
  container:setCascadeOpacityEnabled(true)
  local size

  if id==0 or id==nil then
    icon = CCSprite:create()
    icon:setContentSize(ed.DGSizeMake(104, 104))
    icon:setCascadeOpacityEnabled(true)
    local cm = CCLayerColor:create(ccc4(0, 0, 0, 255))
    cm:setContentSize(ed.DGSizeMake(104, 104))
    icon:addChild(cm)
    local qm = ed.createSprite("UI/alpha/HVGA/hero_icon_unknow.png")
    qm:setPosition(ed.getCenterPos(icon))
    icon:addChild(qm)
    size = icon:getContentSize()
    self.ori_icon = icon
  else
    icon = CCSprite:create()
    local res = ed.getDataTable("Unit")[id].Portrait
    --icon = ed.createSprite(res)
    icon, enode = ed.createClippingNode(res, "UI/alpha/HVGA/equip_stencil.png", 0.02)
    size = enode:getContentSize()
    self.ori_icon = enode
  end
  icon:setCascadeOpacityEnabled(true)
  icon:setPosition(ccp(size.width / 2,  size.height / 2))
  container:addChild(icon)
  self.icon = container
  addMercenaryInfo(self, info.mercenary)
  if level then
    local levelBg = ed.createSprite("UI/alpha/HVGA/heropackage_level_bg.png")
    levelBg:setAnchorPoint(ccp(0, 0))
    levelBg:setPosition(ccp(2, 15))
    container:addChild(levelBg)
    self.levelBg = levelBg
    local levelLabel = ed.createttf(level or 1, 14)
    levelLabel:setAnchorPoint(ccp(0.5, 0.5))
    levelLabel:setPosition(ccp(18, 26))
    container:addChild(levelLabel, 25)
    self.levelLabel = levelLabel
  end
  local frame = ed.createSprite(ed.Hero.getIconFrameByRank(rank))
  frame:setScale((size.width + 5) / frame:getContentSize().width)
  frame:setPosition(ccp(size.width / 2, size.height / 2))
  container:addChild(frame)
  self.frame = frame
  if isHideFrame then
    frame:setVisible(false)
  end
  if text then
    local textLabel = ed.createttf(text, 24)
    textLabel:setAnchorPoint(ccp(0.5, 0))
    textLabel:setPosition(ccp(size.width * 0.5, size.height * 0.12))
    ed.setLabelColor(textLabel, textColor)
    ed.setLabelStroke(textLabel, ccc3(0, 0, 0), 2)
    container:addChild(textLabel)
    self.textLabel = textLabel
  end
  local function getStarPos(i, max)
    local dx = 12
    local x, y = size.width / 2 - 5, 6
    local ci = stars / 2
    x = x + dx * (i - ci)
    return ccp(x, y)
  end
  self.stars = {}
  for i = stars or 0, 1, -1 do
    local s = ed.createSprite("UI/alpha/HVGA/heroselect_evolution_star.png")
    local pos = getStarPos(i, stars)
    s:setPosition(pos)
    container:addChild(s, 5)
    self.stars[i] = s
  end
  if state then
    local stateRes = {
      hire = "UI/alpha/HVGA/herostatus_text_hire.png",
      mining = "UI/alpha/HVGA/herostatus_text_mining.png",
      splited = {
        t = "heroSplit",
        text = T(LSTR("readhero.1.10.1.001"))
      }
    }
    local res = stateRes[state]
    if res then
      info.hp = nil
      withShade = true
      local stateLabel
      if type(res) == "table" then
        stateLabel = ed.createttf(res.text, 20)
        ed.setLabelColor(stateLabel, ccc3(240, 220, 188))
      else
        stateLabel = ed.createSprite(res)
      end
      stateLabel:setPosition(40, 65)
      container:addChild(stateLabel, 10)
      self.stateLabel = stateLabel
    end
  end
  if withShade then
    local shade = CCLayerColor:create(ccc4(0, 0, 0, 150))
    shade:setContentSize(icon:getContentSize())
    icon:addChild(shade)
    self.stateShade = shade
  end
  addHpInfo(self, info)
  if length then
    container:setScale(length / size.width)
  end
  return self
end
class.createIcon = createIcon
local setLevelVisible = function(self, isVisible)
  if isVisible == nil then
    isVisible = true
  end
  if not tolua.isnull(self.levelBg) then
    self.levelBg:setVisible(isVisible)
  end
  if not tolua.isnull(self.levelLabel) then
    self.levelLabel:setVisible(isVisible)
  end
end
class.setLevelVisible = setLevelVisible
local setStateVisible = function(self, visible)
  self.stateShade:setVisible(visible)
  self.stateLabel:setVisible(visible)
end
class.setStateVisible = setStateVisible
local function getIcon(info)
  local self = createIcon(info)
  return self.icon
end
class.getIcon = getIcon
local function getHeroMaxRange(hid)
  local basicSkill = ed.getDataTable("Unit")[hid]["Basic Skill"]
  local maxRange = ed.getDataTable("Skill")[basicSkill][0]["Max Range"]
  return maxRange
end
class.getHeroMaxRange = getHeroMaxRange
local function createIconByHero(hero, addition)
  if nil == hero then
    return
  end
  addition = addition or {}
  local hmMode = addition.hmMode
  local state = addition.state
  local stateIgnoreList = addition.stateIgnoreList
  if ed.isElementInTable(hero._tid, stateIgnoreList) then
    state = "idle"
  end
  local length = addition.len
  local addStar = addition.addStar or 0
  local maxRange = getHeroMaxRange(hero._tid)
  local icon = createIcon({
    id = hero._tid,
    rank = hero._rank,
    level = hero._level,
    maxRange = maxRange,
    stars = hero._stars + addStar,
    length = length,
    hp = hero:hp_perc(hmMode),
    mp = hero:mp_perc(hmMode),
    state = state or hero._state
  })
  return icon
end
class.createIconByHero = createIconByHero
local function createIconByID(id, addition)
  local hero = ed.player.heroes[id]
  if hero then
    return createIconByHero(hero, addition)
  else
    return createIcon({
      id = id,
      rank = 1,
      length = addition.len,
      withShade = true
    })
  end
end
class.createIconByID = createIconByID
local function getIconByID(id, length)
  local self = createIconByID(id, {len = length})
  return self.icon
end
class.getIconByID = getIconByID
local function getNoLevelIconByID(id, length)
  local hero = ed.player.heroes[id]
  local self = createIcon({
    id = id,
    rank = hero._rank,
    length = length
  })
  return self.icon
end
class.getNoLevelIconByID = getNoLevelIconByID
local function getLevelupEffect(noCleanup)
  local list = {}
  for i = 2, 25 do
    table.insert(list, string.format("UI/alpha/HVGA/level up/level up%04i.png", i))
  end
  local spr, anim = ed.createFrameAnim(list)
  if noCleanup then
    return spr, anim
  end
  local action = CCSequence:createWithTwoActions(anim, CCCallFunc:create(function()
    spr:removeFromParentAndCleanup(true)
  end))
  spr:runAction(action)
  return spr
end
class.getLevelupEffect = getLevelupEffect
local function showSelectTag(self)
  self.isSelected = true
  if self.shade and not tolua.isnull(self.shade) then
    self.shade:removeFromParentAndCleanup(true)
  end
  if self.tag and not tolua.isnull(self.tag) then
    self.tag:removeFromParentAndCleanup(true)
  end
  local shade = CCLayerColor:create(ccc4(0, 0, 0, 150))
  shade:setContentSize(self.ori_icon:getContentSize())
  self.ori_icon:addChild(shade, 10)
  self.shade = shade
  local tag = ed.createSprite("UI/alpha/HVGA/tick.png")
  tag:setAnchorPoint(ccp(1, 0))
  tag:setPosition(ccp(self.ori_icon:getContentSize().width, 0))
  self.icon:addChild(tag, 12)
  self.tag = tag
end
class.showSelectTag = showSelectTag
local function showAddTag(self, id)
  if self.addTag and not tolua.isnull(self.addTag) then
    self.addTag:removeFromParentAndCleanup(true)
  end
  local hid, eid = self.info.id, id
  local sr = "UI/alpha/HVGA/herodetail-equipadd.png"
  if not ed.canWearEquip(hid, eid) then
    sr = "UI/alpha/HVGA/herodetail_icon_plus_yellow.png"
  end
  local add = ed.createSprite(sr)
  local size = self.icon:getContentSize()
  local pos = ccp(size.width - 15, size.height - 15)
  add:setPosition(pos)
  self.icon:addChild(add)
  self.addTag = add
end
class.showAddTag = showAddTag
local removeAddTag = function(self)
  if self.addTag and not tolua.isnull(self.addTag) then
    self.addTag:removeFromParentAndCleanup(true)
  end
  self.addTag = nil
end
class.removeAddTag = removeAddTag
local deleteSelectTag = function(self)
  self.isSelected = false
  if self.shade then
    self.shade:removeFromParentAndCleanup(true)
    self.tag:removeFromParentAndCleanup(true)
    self.shade = nil
    self.tag = nil
  end
end
class.deleteSelectTag = deleteSelectTag
local function refreshLevel(self, level)
  ed.setString(self.levelLabel, level)
end
class.refreshLevel = refreshLevel
local hide = function(self)
  self.icon:stopAllActions()
  self.icon:setVisible(false)
end
class.hide = hide
local show = function(self, opacity)
  opacity = opacity or 255
  self.icon:setVisible(true)
  self.icon:setOpacity(opacity)
  if self.shade then
    self.shade:setOpacity(150 * opacity / 255)
  end
end
class.show = show
local fadeOut = function(self, gap)
  gap = gap or 0.2
  local fade = CCFadeOut:create(gap)
  self.icon:runAction(fade)
  if self.shade then
    fade = CCFadeTo:create(gap, 0)
    self.shade:runAction(fade)
  end
end
class.fadeOut = fadeOut
local fadeIn = function(self, gap)
  gap = gap or 0.2
  self.icon:setOpacity(0)
  local fade = CCFadeIn:create(gap)
  self.icon:runAction(fade)
  if self.shade then
    self.shade:setOpacity(0)
    fade = CCFadeTo:create(gap, 150)
    self.shade:runAction(fade)
  end
end
class.fadeIn = fadeIn
local function getMakeid(stoneid)
  local id = stoneid
  local ft = ed.getDataTable("fragment")
  for k, v in pairs(ft) do
    if type(k) == "number" and v["Fragment ID"] == id then
      return k
    end
  end
  return nil
end
class.getMakeid = getMakeid
local function getStoneid(hid)
  local ft = ed.getDataTable("fragment")
  local fid = (ft[hid] or {})["Fragment ID"]
  fid = fid or 335
  return fid
end
class.getStoneid = getStoneid
local function getStoneAmount(id)
  local sid = getStoneid(id)
  return ed.player.equip_qunty[sid] or 0
end
class.getStoneAmount = getStoneAmount
local function getStoneNeed(id)
  local sa
  if not ed.player.heroes[id] then
    local initStar = ed.getDataTable("Unit")[id]["Initial Stars"]
    sa = ed.getDataTable("HeroStars")[initStar]["Summon Fragments"]
  else
    local hero = ed.player.heroes[id]
    local s = hero._stars + 1
    local row = ed.getDataTable("HeroStars")[s]
    if not row then
      return
    else
      sa = row["Upgrade Fragments"]
    end
  end
  return sa
end
class.getStoneNeed = getStoneNeed
local function getStoneLack(id)
  local need = getStoneNeed(id)
  local amount = getStoneAmount(id)
  return math.max(need - amount, 0)
end
class.getStoneLack = getStoneLack
local function getSummonCost(id)
  local initStar = ed.getDataTable("Unit")[id]["Initial Stars"]
  local cost = ed.getDataTable("HeroStars")[initStar]["Summon Price"]
  return cost
end
class.getSummonCost = getSummonCost
local function checkStoneEnough(id)
  local sa = getStoneAmount(id)
  local sn = getStoneNeed(id)
  if sa >= sn then
    return true
  else
    return false
  end
end
class.checkStoneEnough = checkStoneEnough
local function getMissList()
  local list = {}
  local ht = ed.getDataTable("Unit")
  for k, v in pairs(ht) do
    if type(k) == "number" and ed.unitType(k) == "hero" and not ed.player.heroes[k] then
      if v.Enable or ((ed.player.equip_qunty[getStoneid(k)] or 0)>0) then
        table.insert(list, k)
      end
    end
  end
  for i = 1, #list do
    for j = i, 2, -1 do
      if list[j] < list[j - 1] then
        local t = list[j]
        list[j] = list[j - 1]
        list[j - 1] = t
      end
    end
  end
  return list
end
class.getMissList = getMissList
local function orderMissListByLack(list)
  for i = 1, #list do
    for j = i, 2, -1 do
      local id = list[j]
      local pid = list[j - 1]
      local pc = getStoneAmount(id) / getStoneNeed(id)
      local ppc = getStoneAmount(pid) / getStoneNeed(pid)
      if pc > ppc then
        local temp = list[j]
        list[j] = list[j - 1]
        list[j - 1] = temp
      end
    end
  end
end
class.orderMissListByLack = orderMissListByLack
local function checkEquipableProp(list)
  for k, v in pairs(list or ed.player.heroes) do
    local id = v._tid
    local rank = v._rank
    for i = 1, 6 do
      local eid = ed.getDataTable("hero_equip")[id][rank]["Equip" .. i .. " ID"]
      if not v:hasEquipment(i) and ed.isEquipCraftable(eid) and ed.canWearEquip(id, eid) then
        return true
      end
    end
  end
  return false
end
class.checkEquipableProp = checkEquipableProp
local function canSummonHero()
  local ml = getMissList()
  for i = 1, #ml do
    if checkStoneEnough(ml[i]) then
      return true
    end
  end
end
class.canSummonHero = canSummonHero
local function canEvolve(id)
  local amount = class.getStoneAmount(id)
  local hst = ed.getDataTable("HeroStars")
  local hero = ed.player.heroes[id]
  local s = hero._stars
  local row = hst[s + 1]
  local need
  if not row then
    need = 1000
  else
    need = row["Upgrade Fragments"]
  end
  return amount >= need
end
class.canEvolve = canEvolve
local function canHeroEvolve()
  for k, v in pairs(ed.player.heroes) do
    local id = v._tid
    if canEvolve(id) then
      return true
    end
  end
end
class.canHeroEvolve = canHeroEvolve
local function canUpgradeHero()
  for k, v in pairs(ed.player.heroes) do
    local canUpgrade
    local items = v._items
    for i = 1, 6 do
      if (items[i] or 0) == 0 then
        canUpgrade = false
      end
    end
    if canUpgrade then
      return true
    end
  end
end
class.canUpgradeHero = canUpgradeHero
local function canHeroSkillLevelup()
  if not ed.playerlimit.checkAreaUnlock("SkillUpgrade") then
    return false
  end
  for k, v in pairs(ed.player.heroes) do
    local sl = v._skill_levels
    for i = 1, 4 do
      if sl[i] < v._level then
        return true
      end
    end
  end
  return false
end
class.canHeroSkillLevelup = canHeroSkillLevelup
local function canHeroWearEquip(list)
  return checkEquipableProp(list)
end
class.canHeroWearEquip = canHeroWearEquip
local function canHeroEnhanceEquip(list)
  list = list or ed.player.heroes
  for i = 1, #list do
    local hero = list[i]
    local id = hero._tid
    if ed.readequip.canHeroItemsEnhance(id) then
      return true
    end
  end
  return false
end
class.canHeroEnhanceEquip = canHeroEnhanceEquip
local function getAllList()
  local listAll = {}
  local all = ed.orderHeroes()
  for i = 1, #all do
    listAll[i] = all[i]
  end
  return listAll
end
class.getAllList = getAllList
local function getAllListWithMiss()
  local al = getAllList()
  local ml = getMissList()
  class.orderMissListByLack(ml)
  local index = 1
  for i = 1, #ml do
    local id = ml[i]
    local h = {_tid = id}
    if checkStoneEnough(id) then
      table.insert(al, index, h)
      index = index + 1
    else
      table.insert(al, h)
    end
  end
  return al
end
class.getAllListWithMiss = getAllListWithMiss
local function getAllListForPrepare()
  local listAll = {}
  local all = ed.orderHeroes()
  for i = 1, #all do
    listAll[i] = all[i]
    listAll[i].maxRange = getHeroMaxRange(all[i]._tid)
  end
  return listAll
end
class.getAllListForPrepare = getAllListForPrepare
local function getAllListWithLimit(limit, heros)
  limit = limit or {}
  local type = limit.type
  local detail = limit.detail
  local list = {}
  local all = heros and ed.orderHeroFunction(heros) or ed.orderHeroes()
  for i = 1, #all do
    local unit = ed.getDataTable("Unit")
    local tl = unit[all[i]._tid][type]
    if tl == detail or type == "level" and detail <= all[i]._level then
      table.insert(list, all[i])
      all[i].maxRange = getHeroMaxRange(all[i]._tid)
    end
  end
  return list
end
class.getAllListWithLimit = getAllListWithLimit
local function classifyByPos(all)
  local front = {}
  local middle = {}
  local back = {}
  local unit = ed.getDataTable("Unit")
  for i = 1, #all do
    local pos = unit[all[i]._tid]["Position Type"]
    if pos == T(LSTR("UNIT.FRONT_ROW")) then
      table.insert(front, all[i])
    elseif pos == T(LSTR("UNIT.MIDDLE_ROW")) then
      table.insert(middle, all[i])
    elseif pos == T(LSTR("UNIT.REAR_ROW")) then
      table.insert(back, all[i])
    end
  end
  return all, front, middle, back
end
class.classifyByPos = classifyByPos
local function classifyByType(all)
  local str = {}
  local agi = {}
  local int = {}
  local unit = ed.getDataTable("Unit")
  for i = 1, #all do
    local type = unit[all[i]._tid]["Hero Type"]
    if type == T(LSTR("HERO_EQUIP.STRENGTH")) then
      table.insert(str, all[i])
    elseif type == T(LSTR("HERO_EQUIP.AGILITY")) then
      table.insert(agi, all[i])
    elseif type == T(LSTR("HERO_EQUIP.INTELLIGENCE")) then
      table.insert(int, all[i])
    end
  end
  return all, str, agi, int
end
class.classifyByType = classifyByType
local function classify(target, mode, addition)
  local all
  if target == "prepare" then
    all = getAllListForPrepare()
  elseif target == "exercise" then
    all = getAllListWithLimit(addition.limit)
  elseif target == "handbook" then
    all = getAllListWithMiss()
  else
    all = getAllList()
  end
  mode = mode or "type"
  if mode == "type" then
    return classifyByType(all)
  elseif mode == "position" then
    return classifyByPos(all)
  end
end
class.classify = classify
local function createHeroNameByInfo(info)
  local name = info.name
  local rank = info.rank
  local nameColor = info.nameColor
  local shadow = info.shadow
  local width = info.width
  local w, h
  local sprite = CCSprite:create()
  local name = ed.createttf(name, 20)
  name:setAnchorPoint(ccp(0, 0.5))
  local ns = name:getContentSize()
  local nw, nh = ns.width, ns.height
  name:setPosition(ccp(0, 0))
  if nameColor then
    ed.setLabelColor(name, nameColor)
  end
  if shadow then
    ed.setLabelShadow(name, shadow.color, shadow.offset)
  end
  sprite:addChild(name)
  w = nw
  h = nh
  local heroStar = ed.Hero.getHeroStarByRank(rank) or 0
  if heroStar > 0 then
    heroStar = "+" .. heroStar
    local suffix = ed.createttf(heroStar, 20)
    suffix:setAnchorPoint(ccp(0, 0.5))
    suffix:setPosition(ccp(nw, 0))
    sprite:addChild(suffix)
    local color = ed.Hero.getHeroNameColorByRank(rank)
    ed.setLabelColor(suffix, color)
    ed.setLabelShadow(suffix, ccc3(0, 0, 0), ccp(0, 2))
    local ss = suffix:getContentSize()
    local sw, sh = ss.width, ss.height
    w = w + sw
    h = math.max(h, sh)
  end

  if width then
    if sprite:getContentSize().width > width then
      sprite:setScale(width / sprite:getContentSize().width)
    end
  end

  return sprite, w, h
end
class.createHeroNameByInfo = createHeroNameByInfo
local function createHeroName(tid)
  local name = ed.getDataTable("Unit")[tid]["Display Name"]
  local rank = ed.player.heroes[tid]._rank
  return createHeroNameByInfo({name = name, rank = rank, shadow = { color = ccc3(0, 0, 0), offset = ccp(0, 2) }})
end
class.createHeroName = createHeroName
local card_type_icon = {
  STR = "UI/alpha/HVGA/card/card_att_str_big.png",
  AGI = "UI/alpha/HVGA/card/card_att_agi_big.png",
  INT = "UI/alpha/HVGA/card/card_att_int_big.png"
}
local card_frame = {
  "UI/alpha/HVGA/card/card_bg_white.png",
  "UI/alpha/HVGA/card/card_bg_green.png",
  "UI/alpha/HVGA/card/card_bg_green.png",
  "UI/alpha/HVGA/card/card_bg_blue.png",
  "UI/alpha/HVGA/card/card_bg_blue.png",
  "UI/alpha/HVGA/card/card_bg_blue.png",
  "UI/alpha/HVGA/card/card_bg_purple.png",
  "UI/alpha/HVGA/card/card_bg_purple.png",
  "UI/alpha/HVGA/card/card_bg_purple.png",
  "UI/alpha/HVGA/card/card_bg_purple.png",
  "UI/alpha/HVGA/card/card_bg_purple.png",
  "UI/alpha/HVGA/card/card_bg_orange.png"
}
local function createSkillIcon(hid, slot)
  local sgt = ed.getDataTable("SkillGroup")[hid]
  local res = sgt[slot].Icon
  local fres = "UI/alpha/HVGA/equip_frame_white.png"
  local icon = ed.createSprite(res)
  local bg = ed.createSprite(fres)
  bg:setPosition(ccp(30, 29))
  icon:addChild(bg)
  icon:setCascadeOpacityEnabled(true)
  return icon, bg
end
class.createSkillIcon = createSkillIcon
local function getHeroCard(tid, addition)
  addition = addition or {}
  if not tid then
    return
  end
  local hero = getHero(tid) or {}
  local rank = addition.rank or hero._rank or 1
  local star = addition.stars or hero._stars or (ed.getDataTable("Unit")[tid] or {})["Initial Stars"] or 0
  local starType = addition.starType
  if starType == "init" then
    star = (ed.getDataTable("Unit")[tid] or {})["Initial Stars"] or 0
    rank = 1
  end
  local unit = ed.getDataTable("Unit")
  local type = unit[tid]["Main Attrib"]
  local row = unit[tid]
  local typeres = card_type_icon[type]
  local frameres = card_frame[rank]
  local cardres = row.Art or "UI/alpha/HVGA/card/card_bg_big_45.png"
  local disp_name = row["Display Name"]
  local art_name = row["Art Name"]
  local skillGroup = ed.getDataTable("SkillGroup")
  local group = skillGroup[tid]
  local skillres = {}
  for i = 1, 4 do
    skillres[i] = group[i].Icon
  end
  local ui = {}
  local container = CCSprite:create()
  container:setCascadeOpacityEnabled(true)
  container:setContentSize(CCSizeMake(242, 420))
  ui.container = container
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "frame",
        res = frameres,
        z = 1
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "type",
        res = typeres,
        z = 1
      },
      layout = {
        position = ccp(32, 67)
      },
      config = {
        fix_size = CCSizeMake(47, 42)
      }
    },
    {
      t = "Label",
      base = {
        name = "name",
        parent = "frame",
        text = disp_name,
        fontinfo = "ui_normal_stroke",
        max_width = 175,
        size = 24
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(55, 72)
      },
      config = {
        color = ccc3(233, 232, 213)
      }
    },
    {
      t = "Label",
      base = {
        name = "artname",
        parent = "frame",
        text = art_name,
        fontinfo = "ui_normal_stroke",
        max_width = 180,
        size = 14
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(55, 53)
      },
      config = {
        color = ccc3(233, 232, 213)
      }
    }
  }
  local readNode = ed.readnode.create(container, ui)
  readNode:addNode(ui_info)
  ui.skillIcon = {}
  for i = 1, 4 do
    local icon = createSkillIcon(tid, i)
    icon:setPosition(ccp(130.5 + 27.2 * (i - 1), 28))
    local size = icon:getContentSize()
    icon:setScale(22 / size.width)
    container:addChild(icon, 1)
    ui.skillIcon[i] = icon
  end
  local card, ci = ed.createClippingNode(cardres, "UI/alpha/HVGA/art_mask.png", nil, CCSizeMake(-20, -8))
  card:setPosition(ccp(123, 215))
  local height = ci:getContentSize().height
  card:setScale(420 / height)
  container:addChild(card)
  ui.card = card
  ed.setNodeAnchor(ui.frame, ccp(0.5, 0.5))
  local lineres
  local width = ui.name:getContentSize().width
  if width > 120 then
    lineres = "UI/alpha/HVGA/card/card_name_bg_short.png"
  else
    lineres = "UI/alpha/HVGA/card/card_name_bg_long.png"
  end
  ui.line = ed.createSprite(lineres)
  ui.line:setAnchorPoint(ccp(1, 0.5))
  ui.line:setPosition(ccp(242, 60))
  container:addChild(ui.line)
  ui.stars = {}
  local sx, sy = 25, 27
  local dx = 14
  for i = 1, star do
    local s = ed.createSprite("UI/alpha/HVGA/card/card_star_big.png")
    s:setPosition(ccp(sx + dx * (i - 1), sy))
    container:addChild(s, 6 - i)
    s:setScale(0.5)
    ui.stars[i] = s
  end
  return ui
end
class.getHeroCard = getHeroCard
local function refreshHeroCard(ui, tid, addition)
  if not ui then
    return
  end
  addition = addition or {}
  if not tid then
    return
  end
  local hero = getHero(tid) or {}
  local rank = addition.rank or hero._rank or 1
  local star = addition.stars or hero._stars or (ed.getDataTable("Unit")[tid] or {})["Initial Stars"] or 0
  ui.frame:removeFromParentAndCleanup(true)
  
  local res = card_frame[rank]
  local frame = ed.createSprite(res)
  frame:setAnchorPoint(ccp(0, 0))
  frame:setPosition(ccp(0, 0))
  ui.frame = frame
  ui.container:addChild(frame)

  --add by cooper.x
  local unit = ed.getDataTable("Unit")
  local row = unit[tid]
  local disp_name = row["Display Name"]
  local art_name = row["Art Name"]
  local ui_info = {
    {
        t = "Label",
        base = {
        name = "name",
        parent = "frame",
        text = disp_name,
        fontinfo = "ui_normal_stroke",
        max_width = 175,
        size = 24
        },
        layout = {
        anchor = ccp(0, 0.5),
        position = ccp(55, 72)
        },
        config = {
        color = ccc3(233, 232, 213)
        }
    },
    {
        t = "Label",
        base = {
        name = "artname",
        parent = "frame",
        text = art_name,
        fontinfo = "ui_normal_stroke",
        max_width = 180,
        size = 14
        },
        layout = {
        anchor = ccp(0, 0.5),
        position = ccp(55, 53)
        },
        config = {
        color = ccc3(233, 232, 213)
        }
    }
  }
  local readNode = ed.readnode.create(ui.container, ui)
  readNode:addNode(ui_info)
  --

  ui.stars = ui.stars or {}
  local sx, sy = 25, 27
  local dx = 14
  for i = 1, star do
    if tolua.isnull(ui.stars[i]) then
      local s = ed.createSprite("UI/alpha/HVGA/card/card_star_big.png")
      s:setPosition(ccp(sx + dx * (i - 1), sy))
      ui.container:addChild(s, 6 - i)
      s:setScale(0.5)
      ui.stars[i] = s
    end
  end
end
class.refreshHeroCard = refreshHeroCard
local function getActor(hid, name, notloop)
  local row = ed.getDataTable("Unit")[hid]
  local cha = row.Puppet
  local chaName = cha
  local puppetInfo = ed.lookupDataTable("Puppet", nil, chaName);
  local actor = ed.createAnimation(puppetInfo.Resource, 1.5, puppetInfo.AniType or 0);
  actor:setAction(name or "Idle")
  actor:setLoop(not notloop)
  return actor, chaName
end
class.getActor = getActor
