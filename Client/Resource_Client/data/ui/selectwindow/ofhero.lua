local base = ed.ui.selectwindow.base
local class = newclass(base.mt)
ed.ui.selectwindow.ofhero = class
local function create(param)
  local self = base.create(param)
  setmetatable(self, class.mt)
  self.item_len = 80
  self.item_offset_x = 0
  self.item_offset_y = 0
  self.colume_count = 5
  if self.param.signName == "herosplit" then
    self.item_offset_y = 30
  end
  self.heroes = {}
  self:createHeroList()
  return self
end
class.create = create
local createHeroList = function(self)
  local dl = self.draglist
  dl.doPressIn = self:doPressInList()
  dl.cancelPressIn = self:cancelPressInList()
  dl.doClickIn = self:doClickInList()
  dl.cancelClickIn = self:cancelClickInList()
  self:getScene():registerUpdateHandler("asyncLoadHero", self:asyncLoadHero())
  self.draglist:initListHeight(self:getListHeight())
end
class.createHeroList = createHeroList
local asyncLoadHero = function(self)
  local index = 1
  local function handler()
    local list = self:getList()
    for i = math.max(1, 5 * (index - 1)), math.min(#list, 5 * index) do
      self:createHero(i)
    end
    if 5 * index > #list then
      self:getScene():removeUpdateHandler("asyncLoadHero")
    end
    index = index + 1
  end
  return handler
end
class.asyncLoadHero = asyncLoadHero
local getList = function(self)
  if not self.currentHeroList then
    local list = {}
    local heroAddition = {}
    local heroList = self.param.heroList
    if heroList then
      if type(heroList[1]) == "table" then
        for i, v in ipairs(heroList) do
          table.insert(list, v.id)
          heroAddition[v.id] = v
        end
      else
        list = self.param.heroList
      end
    else
      local hl = ed.orderHeroes() or {}
      for i, v in ipairs(hl) do
        table.insert(list, v._tid)
      end
    end
    local clist = {}
    for i, v in ipairs(list) do
      if not ed.isElementInTable(v, self.param.noShowList) then
        table.insert(clist, v)
      end
    end
    self.currentHeroList = clist
    self.heroAddition = heroAddition
  end
  return self.currentHeroList
end
class.getList = getList
local getHeroIconPos = function(self, i)
  local ox, oy = self.left_top_x + self.item_len / 2, self.left_top_y - self.item_len / 2
  local en = self.ui.explain
  if not tolua.isnull(en) then
    oy = oy - en:getContentSize().height - self.explain_offset_y
  end
  local x = ox + (self.item_len + 20 + self.item_offset_x) * ((i - 1) % self.colume_count)
  local y = oy - (self.item_len + 10 + self.item_offset_y) * math.floor((i - 1) / self.colume_count)
  return ccp(x, y)
end
class.getHeroIconPos = getHeroIconPos
local getListHeight = function(self)
  local list = self:getList()
  local h = (self.item_len + 10 + self.item_offset_y) * math.ceil(#list / self.colume_count) + 20
  local en = self.ui.explain
  if not tolua.isnull(en) then
    h = h + en:getContentSize().height
    h = h + self.explain_offset_y
  end
  return h
end
class.getListHeight = getListHeight
local getSplitHeroState = function(self, tid)
  if self.param.signName ~= "herosplit" then
    return nil
  end
  local splitTimes = self.heroAddition[tid].splitTimes or 0
  if splitTimes > 0 then
    return "splited"
  end
  return nil
end
class.getSplitHeroState = getSplitHeroState
local createHeroSplit = function(self, tid, pos)
  if self.param.signName ~= "herosplit" then
    return
  end
  local endPoint = self.heroAddition[tid].endPoint
  local dt = endPoint - ed.getServerTime()
  dt = math.max(dt, 0)
  local d = math.floor(dt / 86400)
  local h = math.floor((dt - 86400 * d) / 3600)
  if not (d > 0) or not T(LSTR("TIME.DAY")) then
  end
  local param = {
    t = "HorizontalNode",
    base = {},
    layout = {
      position = ccpAdd(pos, ccp(0, -58))
    },
    ui = {
      {
        t = "Label",
        base = {
          text = T(LSTR("ofhero.1.10.1.001")),
          size = 20
        },
        config = {
          color = ccc3(255, 218, 128)
        }
      },
      {
        t = "Label",
        base = {
          text = tostring(d > 0 and d or h),
          size = 20
        },
        config = {}
      },
      {
        t = "Label",
        base = {
          text = T(LSTR("ofhero.1.10.1.002")),
          size = 20
        },
        config = {
          color = ccc3(255, 218, 128)
        }
      }
    }
  }
  local node = ed.createNode(param)
  self.draglist:addItem(node)
end
class.createHeroSplit = createHeroSplit
local createHero = function(self, index)
  local list = self:getList()
  local tid = list[index]
  local state = self:getSplitHeroState(tid)
  self.heroes[tid] = ed.readhero.createIconByID(tid, {
    state = state or not self.param.withState and "idle" or nil
  })
  local icon = self.heroes[tid].icon
  local pos = self:getHeroIconPos(index)
  icon:setPosition(pos)
  self.draglist:addItem(icon)
  self:createHeroSplit(tid, pos)
  if ed.readequip.canHeroItemsEnhance(tid) then
    ed.teach("EEselectHero", icon, self.draglist.listLayer)
    self.EEselectHeroid = tid
  end
end
class.createHero = createHero
local doPressInList = function(self)
  local function handler(x, y)
    local list = self.heroes
    for k, v in pairs(list or {}) do
      if ed.containsPoint(v.icon, x, y) then
        v.icon:setScale(0.95)
        return k
      end
    end
  end
  return handler
end
class.doPressInList = doPressInList
local cancelPressInList = function(self)
  local function handler(x, y, id)
    self.heroes[id].icon:setScale(1)
  end
  return handler
end
class.cancelPressInList = cancelPressInList
local doClickInList = function(self)
  local function handler(x, y, id)
    local icon = self.heroes[id].icon
    icon:setScale(1)
    if ed.containsPoint(icon, x, y) then
      ed.endTeach("EEselectHero")
      if not ed.player.heroes[id] then
        ed.showToast(T(LSTR("ofhero.1.10.1.003")))
        return
      end
      if self.param.withState then
        local state = ed.player.heroes[id]._state
        if state == "hire" then
          ed.showToast(T(LSTR("HEROSELECT.THE_HERO_HAS_SENT_TO_GUARD_A_CAMP_")))
          return
        elseif state == "mining" then
          local info = {
            text = T(LSTR("BATTLEPREPARE.THE_HEROES_ARE_MINING_THE_TREASURE_DO_YOU_WANT_TO_RECALL_NOW_")),
            rightHandler = function()
              ed.ui.excavate.doWithDrawHero(id, function()
                self.heroes[id]:setStateVisible(false)
              end)
            end
          }
          ed.showConfirmDialog(info)
          return
        end
      end
      if self.param.signName == "herosplit" then
        if self:getSplitHeroState(id) == "splited" then
          ed.showToast(T(LSTR("ofhero.1.10.1.004")))
          return
        elseif not ed.ui.herosplit.canSplit(id) then
          ed.showToast(T(LSTR("ofhero.1.10.1.005")))
          return
        end
      end
      if self.param.callback then
        self.param.callback(id)
      end
      self:destroy({skipAnim = true})
    end
  end
  return handler
end
class.doClickInList = doClickInList
local cancelClickInList = function(self)
  local function handler(x, y, id)
    self.heroes[id].icon:setScale(1)
  end
  return handler
end
class.cancelClickInList = cancelClickInList
