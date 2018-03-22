local hero_mark_res = {
  STR = "UI/alpha/HVGA/icon_str.png",
  AGI = "UI/alpha/HVGA/icon_agi.png",
  INT = "UI/alpha/HVGA/icon_int.png"
}
local class = newclass()
ed.ui.baseheroitem = class
local function create(tid)
  local self = {}
  setmetatable(self, class.mt)
  local bg = ed.createSprite("UI/alpha/HVGA/package_hero_bg.png")
  bg:setCascadeOpacityEnabled(true)
  local unit = ed.getDataTable("Unit")[tid]
  local miss
  if ed.player.heroes[tid] then
    miss = false
  else
    miss = true
  end
  local head, heroIcon
  if miss then
    head = ed.readhero.createIcon({id = tid, rank = 1})
  else
    head = ed.readhero.createIconByID(tid, {state = "idle"})
  end
  head.icon:setAnchorPoint(ccp(0, 0))
  head.icon:setPosition(ccp(7, 9))
  bg:addChild(head.icon, 1)
  local ow = 100
  local name = unit["Display Name"]
  local rank = miss and 1 or ed.player.heroes[tid]._rank
  local nameLabel, w = ed.readhero.createHeroNameByInfo({name = name, rank = rank, shadow = { color = ccc3(0, 0, 0), offset = ccp(0, 2) }})
  if ow < w then
    nameLabel:setScale(ow / w)
  end
  nameLabel:setPosition(ccp(177 - math.min(w, ow) / 2, 72))
  bg:addChild(nameLabel)
  local mark = hero_mark_res[unit["Main Attrib"]]
  local markIcon = ed.createSprite(mark)
  markIcon:setPosition(ccp(110, 72))
  markIcon:setScale(0.8)
  bg:addChild(markIcon)
  local hero
  if not miss then
    hero = ed.player.heroes[tid]
  else
    hero = {_tid = tid, miss = true}
  end
  self = {
    tid = tid,
    name = name,
    hero = hero,
    rank = rank,
    bg = bg,
    head = head,
    nameLabel = nameLabel,
    markIcon = markIcon
  }
  return self
end
class.create = create
local show = function(self, opacity)
  opacity = opacity or self.bg:getOpacity()
  self.bg:setVisible(true)
  self.bg:setOpacity(opacity)
end
class.show = show
local hide = function(self)
  self.bg:setVisible(false)
end
class.hide = hide
local fadeIn = function(self)
  self:show(0)
  local fade = CCFadeIn:create(0.2)
  self.bg:runAction(fade)
end
class.fadeIn = fadeIn
local fadeOut = function(self)
  self:show()
  local fade = CCFadeTo:create(0.2, 0)
  self.bg:runAction(fade)
end
class.fadeOut = fadeOut
local refreshHead = function(self)
  local tid = self.tid
  self.head.icon:removeFromParentAndCleanup(true)
  self.head = nil
  local head = ed.readhero.createIconByID(tid, {state = "idle"})
  head.icon:setAnchorPoint(ccp(0, 0))
  head.icon:setPosition(ccp(7, 9))
  self.bg:addChild(head.icon, 1)
  self.head = head
  self.nameLabel:removeFromParentAndCleanup(true)
  self.nameLabel = nil
  local ow = 100
  local nameLabel, w = ed.readhero.createHeroNameByInfo({
    name = self.name,
    rank = ed.player.heroes[self.tid]._rank,
    shadow = { color = ccc3(0, 0, 0), offset = ccp(0, 2) }
  })
  if ow < w then
    nameLabel:setScale(ow / w)
  end
  nameLabel:setPosition(ccp(177 - math.min(w, ow) / 2, 72))
  self.bg:addChild(nameLabel)
  self.nameLabel = nameLabel
end
class.refreshHead = refreshHead
local base = class
local class = newclass(base.mt)
ed.ui.packageheroitem = class
local function create(tid)
  local self = base.create(tid)
  setmetatable(self, class.mt)
  local miss = self.hero.miss
  if not miss then
    local equips = self:createHeroEquips(self.hero, self.bg)
    self.equips = equips
  else
    ed.setSpriteGray(self.head.ori_icon)
    local stone = self:createHeroStone(tid, self.bg)
  end
  return self
end
class.create = create
local createHeroStone = function(self, tid, bg)
  if self.stone and not tolua.isnull(self.stone.container) then
    self.stone.container:removeFromParentAndCleanup(true)
    self.stone.container = nil
  end
  local stone = {}
  local container = CCSprite:create()
  container:setCascadeOpacityEnabled(true)
  container:setAnchorPoint(ccp(0, 0))
  container:setPosition(ccp(0, 0))
  bg:addChild(container)
  stone.container = container
  local sa = ed.readhero.getStoneAmount(tid)
  local sn = ed.readhero.getStoneNeed(tid)
  local barBg = ed.createSprite("UI/alpha/HVGA/heropackage_soulstone_progress_bg.png")
  barBg:setAnchorPoint(ccp(0, 0.5))
  barBg:setPosition(ccp(90, 22))
  barBg:setScaleX(0.93)
  container:addChild(barBg)
  local bar = ed.createSprite("UI/alpha/HVGA/heropackage_soulstone_progress.png")
  bar:setAnchorPoint(ccp(0, 0))
  bar:setPosition(ccp(0, 0))
  barBg:addChild(bar)
  bar:setTextureRect(CCRectMake(0, 0, 150 * sa / sn, 26))
  local text = sa >= sn and T(LSTR("PRIVILEGE.SUMMONABLE")) or string.format("%d/%d", sa, sn)
  local label = ed.createttf(text, 18)
  label:setPosition(ccp(80, 13))
  barBg:addChild(label)
  local summonLight
  if sa >= sn then
    summonLight = ed.createSprite("UI/alpha/HVGA/heropackage_available.png")
    local size = bg:getContentSize()
    summonLight:setPosition(ccp(size.width / 2, size.height / 2 + 1))
    bg:addChild(summonLight)
    summonLight:setOpacity(150)
    local fo = CCFadeTo:create(0.5, 0)
    local fi = CCFadeTo:create(0.5, 150)
    local s = CCSequence:createWithTwoActions(fo, fi)
    s = CCRepeatForever:create(s)
    summonLight:runAction(s)
    local ss = summonLight:getContentSize()
  end
  stone = {
    container = container,
    barBg = barBg,
    bar = bar,
    label = label,
    summonLight = summonLight,
    enougth = sa >= sn
  }
  self.stone = stone
  return stone
end
class.createHeroStone = createHeroStone
local createHeroEquips = function(self, hero, bg)
  if self.equips and not tolua.isnull(self.equips.container) then
    self.equips.container:removeFromParentAndCleanup(true)
    self.equips.container = nil
  end
  if self.stone then
    if not tolua.isnull(self.stone.container) then
      self.stone.container:removeFromParentAndCleanup(true)
    end
    if not tolua.isnull(self.stone.summonLight) then
      self.stone.summonLight:removeFromParentAndCleanup(true)
    end
    self.stone = nil
  end
  local equips = {}
  local container = CCSprite:create()
  container:setCascadeOpacityEnabled(true)
  container:setAnchorPoint(ccp(0, 0))
  container:setPosition(ccp(0, 0))
  bg:addChild(container)
  equips.container = container
  local isShowTag
  for i = 1, 6 do
    equips[i] = {}
    local equipBg = ed.createSprite("UI/alpha/HVGA/gocha.png")
    equipBg:setPosition(105 + 22 * (i - 1), 18)
    equipBg:setScale(22 / equipBg:getContentSize().width)
    container:addChild(equipBg)
    equips[i].bg = equipBg
    if hero:hasEquipment(i) then
      local grade = hero._rank
      local eid = ed.readequip.getHeroItem(hero._tid, i)
      local res = ed.getDataTable("equip")[eid].Icon
      local equip = ed.createSprite(res)
      equip:setPosition(105 + 22 * (i - 1), 18)
      equip:setScale(16 / equip:getContentSize().width)
      container:addChild(equip)
      equips[i].equip = equip
    else
      local grade = hero._rank
      local eid = ed.getDataTable("hero_equip")[hero._tid][grade]["Equip" .. i .. " ID"]
      if ed.isEquipCraftable(eid) then
        local sr = "UI/alpha/HVGA/herodetail-equipadd.png"
        if not ed.canWearEquip(hero._tid, eid) then
          sr = "UI/alpha/HVGA/herodetail_icon_plus_yellow.png"
        else
          isShowTag = true
        end
        local plusSign = ed.createSprite(sr)
        plusSign:setPosition(105 + 22 * (i - 1), 18)
        plusSign:setScale(24 / plusSign:getContentSize().width)
        container:addChild(plusSign)
        equips[i].plusSign = plusSign
        equipBg:setOpacity(100)
        self.equipCraftable = true
      else
        equipBg:setOpacity(100)
      end
    end
  end
  if isShowTag then
    local tag = ed.createSprite("UI/alpha/HVGA/main_deal_tag.png")
    tag:setPosition(ccp(240, 90))
    container:addChild(tag)
    self.canDealTag = tag
  end
  return equips
end
class.createHeroEquips = createHeroEquips
local refreshEquips = function(self)
  local tid = self.tid
  local hero = ed.player.heroes[tid]
  if not hero then
    return
  end
  self.hero = hero
  ed.resetSpriteShader(self.head.icon)
  local equips = self:createHeroEquips(self.hero, self.bg)
  self.equips = equips
end
class.refreshEquips = refreshEquips
local refreshStone = function(self)
  return self:createHeroStone(self.hero._tid, self.bg)
end
class.refreshStone = refreshStone
local class = newclass(base.mt)
ed.ui.skillheroitem = class
local function create(tid)
  local self = base.create(tid)
  setmetatable(self, class.mt)
  local skills = self:createHeroSkills(self.hero, self.bg)
  self.skills = skills
  return self
end
class.create = create
local createHeroSkills = function(self, hero, bg)
  local skills = {}
  for i = 1, 4 do
    skills[i] = {}
    local skillBg = ed.createSprite("UI/alpha/HVGA/gocha.png")
    skillBg:setPosition(108 + 35 * (i - 1), 28)
    skillBg:setScale(36 / skillBg:getContentSize().width)
    bg:addChild(skillBg)
    skills[i].bg = skillBg
    local skillInfo = ed.getDataTable("SkillGroup")[hero._tid][i]
    local res
    if skillInfo then
      res = skillInfo.Icon
    end
    if res then
      local icon = ed.createSprite(res)
      icon:setPosition(108 + 35 * (i - 1), 29)
      icon:setScale(28 / icon:getContentSize().width)
      bg:addChild(icon)
      if skillInfo.Unlock > hero._rank then
        ed.setSpriteGray(icon)
      end
    end
  end
  return skills
end
class.createHeroSkills = createHeroSkills
