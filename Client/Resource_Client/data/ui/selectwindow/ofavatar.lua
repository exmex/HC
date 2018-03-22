local base = ed.ui.selectwindow.base
local class = newclass(base.mt)
ed.ui.selectwindow.ofavatar = class
class.type_priority = {
  "free",
  "hero",
  "worldcup"
}
class.type_title = {
  worldcup = T(LSTR("ofavatar.1.10.1.001")),
  free = T(LSTR("HEROSELECT.BASIC_AVATAR")),
  hero = T(LSTR("HEROSELECT.HERO_AVATAR"))
}
local initListHeight = function(self)
  self.listHeight = self.listHeight or {}
  local ph = 0
  for i, v in ipairs(self.type_priority) do
    if self.resList[v] then
      local amount = #self.resList[v]
      local titleHeight = 40
      local height = 90 * math.ceil(amount / 5)
      if v == "free" then
        additionHeight = 40
      else
        additionHeight = 0
      end
      self.listHeight[v] = {
        preHeight = ph,
        titleHeight = titleHeight,
        height = height,
        additionHeight = additionHeight
      }
      ph = ph + titleHeight + height + additionHeight
    end
  end
  self.totalListHeight = ph
end
class.initListHeight = initListHeight
local initListData = function(self)
  local list = {}
  local at = ed.getDataTable("Avatar")
  for k, v in pairs(at) do
    if type(k) == "number" then
      local requirement = v["Requirement Type"]
      local actType = v["Act Type"]
      local ut = ed.unitType(k)
      if actType == "WorldCup" then
        ut = "worldcup"
      elseif ut == "monster" then
        ut = "free"
      elseif ut == "hero" then
        if ed.isElementInTable(k, {1}) then
          ut = "free"
        else
          ut = "hero"
        end
      end
      if ut then
        list[ut] = list[ut] or {}
        if not requirement then
          table.insert(list[ut], {
            key = k,
            res = v.Picture,
            type = ut
          })
        elseif requirement == "HeroRank" then
          local id = v["Requirement ID"]
          local tg = v["Requirement Target"]
          local hero = ed.player.heroes[id]
          local rank = (hero or {})._rank or 0
          if tg <= rank then
            table.insert(list[ut], {
              key = k,
              hero = hero,
              res = v.Picture,
              type = ut
            })
          end
        elseif requirement == "PlayerLevel" then
          local tg = v["Requirement Target"]
          if tg <= ed.player:getLevel() then
            table.insert(list[ut], {
              key = k,
              res = v.Picture,
              type = ut
            })
          end
        end
      end
    end
  end
  self.resList = list
  self.avatarAmount = avatarAmount
  self:initListHeight()
end
class.initListData = initListData
local getListPos = function(self, index)
  for i, v in ipairs(self.type_priority) do
    if self.resList[v] then
      if index <= #self.resList[v] then
        return v, index
      else
        index = index - #self.resList[v]
      end
    end
  end
end
class.getListPos = getListPos
local createSubhead = function(self, text)
  local container = CCSprite:create()
  container:setContentSize(CCSizeMake(300, 20))
  local bg = ed.createScale9Sprite("UI/alpha/HVGA/detail_title_bg.png", CCRectMake(100, 0, 304, 12))
  bg:setContentSize(CCSizeMake(300, 12))
  bg:setPosition(ccp(150, 10))
  container:addChild(bg)
  local label = ed.createttf(text or "", 18)
  ed.setLabelColor(label, ccc3(231, 206, 19))
  label:setPosition(ccp(150, 10))
  container:addChild(label)
  return container
end
class.createSubhead = createSubhead
local createUnlockPrompt = function(self)
  local ps = ed.createttf(T(LSTR("HEROSELECT.TIPS__HERO_ADVANCED_TO_PURPLE_CAN_BE_SET_TO_AVATAR")), 18)
  ed.setLabelColor(ps, ccc3(231, 206, 19))
  return ps
end
class.createUnlockPrompt = createUnlockPrompt
local getIconPos = function(self, i, param)
  local x, y
  param = param or {}
  local isTitle = param.isTitle
  local isAddition = param.isAddition
  local t = param.t
  local lh = self.listHeight[t]
  local lx, cx, cy = 200, 400, 420
  if isTitle then
    if t == "hero" then
      x, y = cx, cy - lh.preHeight + 10
    else
      x, y = cx, cy - lh.preHeight - 20
    end
  elseif isAddition then
    x, y = cx, cy - lh.preHeight - lh.height - 100
  else
    x, y = lx, cy - lh.preHeight - 80
    x = x + 100 * ((i - 1) % 5)
    y = y - 90 * math.floor((i - 1) / 5)
  end
  return ccp(x, y)
end
class.getIconPos = getIconPos
local createIcon = function(self, index)
  local t, i = self:getListPos(index)
  if not i then
    return "end"
  end
  if i == 1 then
    local pos = self:getIconPos(i, {isTitle = true, t = t})
    local node = self:createSubhead(self.type_title[t])
    node:setPosition(pos)
    self.draglist:addItem(node)
  elseif t == "free" and i == #self.resList.free then
    local pos = self:getIconPos(i, {isAddition = true, t = t})
    local node = self:createUnlockPrompt()
    node:setPosition(pos)
    self.draglist:addItem(node)
  end
  local item = self.resList[t][i]
  local res = item.res
  local key = item.key
  local ut = item.type
  local frame = ed.createSprite("UI/alpha/HVGA/hero_icon_frame_1.png")
  frame:setPosition(self:getIconPos(i, {t = t}))
  self.draglist:addItem(frame)
  local size = frame:getContentSize()
  local icon = ed.createSprite(res)
  icon:setPosition(ed.getCenterPos(frame))
  ed.fixNodeSize(icon, CCSizeMake(size.width - 10, size.height - 10))
  frame:addChild(icon, -1)
  self.icons = self.icons or {}
  self.icons[index] = {
    key = key,
    icon = frame,
    head = icon,
    type = ut
  }
end
class.createIcon = createIcon
local asyncLoadIcon = function(self)
  local index = 1
  local tag
  local function handler()
    for i = index, index + 5 do
      tag = self:createIcon(i)
    end
    if tag == "end" then
      self:getScene():removeUpdateHandler("asyncLoadIcon")
    end
    index = index + 6
  end
  return handler
end
class.asyncLoadIcon = asyncLoadIcon
local createIconList = function(self)
  local dl = self.draglist
  dl.doPressIn = self:doPressIn()
  dl.cancelPressIn = self:doPressEnd()
  dl.doClickIn = self:doPressEnd(true)
  dl.cancelClickIn = self:doPressEnd()
  self:initListData()
  dl:initListHeight(self.totalListHeight)
  self:getScene():registerUpdateHandler("asyncLoadIcon", self:asyncLoadIcon())
end
class.createIconList = createIconList
local doPressIn = function(self)
  local function handler(x, y)
    for i = 1, #(self.icons or {}) do
      local item = self.icons[i]
      local icon = item.icon
      if ed.containsPoint(icon, x, y) then
        icon:setScale(0.95)
        return i
      end
    end
  end
  return handler
end
class.doPressIn = doPressIn
local doPressEnd = function(self, isClick)
  local function handler(x, y, id)
    if isClick then
      local icon = self.icons[id].icon
      if ed.containsPoint(icon, x, y) then
        self:doSendSet(self.icons[id].key)
      end
    else
      self.icons[id].icon:setScale(1)
    end
  end
  return handler
end
class.doPressEnd = doPressEnd
local doSetAvatarReply = function(self, id)
  local function handler(result)
    if not result then
      ed.showToast(T(LSTR("HEROSELECT.SET_AVATAR_FAILED")))
    else
      if self.param.callback then
        self.param.callback(id)
      end
      self:destroy({skipAnim = true})
    end
  end
  return handler
end
class.doSetAvatarReply = doSetAvatarReply
local doSendSet = function(self, key)
  ed.netdata.setAvatar = {id = key}
  ed.netreply.setAvatar = self:doSetAvatarReply(key)
  local msg = ed.upmsg.set_avatar()
  msg._avatar = key
  ed.send(msg, "set_avatar")
end
class.doSendSet = doSendSet
local function create(param)
  local self = base.create(param)
  setmetatable(self, class.mt)
  self:createIconList()
  return self
end
class.create = create
