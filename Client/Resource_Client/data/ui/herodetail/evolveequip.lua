local herodetail = ed.ui.herodetail
local res = herodetail.res
local base = ed.ui.popwindow
local class = newclass(base.mt)
herodetail.equip = class
local itemHeight = 200
local getHero = function(self)
  return self.hero
end
class.getHero = getHero
local getAllEquip = function(self)
  local equip = {}
  local heroId = self:getHero()._tid
  local heroRank = self:getHero()._rank
  local heroEquips = ed.getDataTable("hero_equip")
  for rank = heroRank, 12 do
    local temp = {}
    for index = 1, 6 do
      local eid = ed.getDataTable("hero_equip")[heroId][rank]["Equip" .. index .. " ID"]
      table.insert(temp, eid)
    end
    table.insert(equip, temp)
  end
  return equip
end
class.getAllEquip = getAllEquip
local function createEquipInfo(self, data, rank)
  local equipInfo = {}
  equipInfo.equip = data
  equipInfo.rank = rank
  local board = {}
  local bg = CCSprite:create()
  board.bg = bg
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "iconBg",
        res = "UI/alpha/HVGA/herodetail_skill_bg_1.png",
        capInsets = CCRectMake(15, 15, 15, 15)
      },
      layout = {
        position = ccp(2, -100)
      },
      config = {
        scaleSize = CCSizeMake(254, 200)
      }
    },
    {
      t = "Label",
      base = {
        name = "rank",
        text = "",
        size = 20
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(10, -20)
      },
      config = {
        color = ccc3(255, 255, 255)
      }
    }
  }
  local readNode = ed.readnode.create(bg, board)
  readNode:addNode(ui_info)
  for i = 0, 1 do
    for j = 1, 3 do
      do
        local equipId = data[i * 3 + j]
        if equipId ~= 0 then
          local icon = ed.readequip.createIcon(equipId)
          icon:setPosition(ccp(50 + (j - 1) * 80, 126 - i * 80))
          board.iconBg:addChild(icon)
          self:btRegisterButtonClick({
            button = icon,
            key = "equip" .. tostring(rank) .. tostring(i * 3 + j),
            clickHandler = function()
              self.craftLayer = ed.ui.equipcraft.create({context = "handbook", eid = equipId})
              local currentScene = CCDirector:sharedDirector():getRunningScene()
              if currentScene then
                currentScene:addChild(self.craftLayer.mainLayer, 300)
              end
            end,
            force = true,
            clickInterval = 0.3,
            mcpMode = true
          })
        else
          local icon = ed.readequip.getUnknownIcon()
          icon:setPosition(ccp(50 + (j - 1) * 80, 123 - i * 80))
          board.iconBg:addChild(icon)
        end
      end
    end
  end
  ed.setLabelFontInfo(board.rank, res.equip_rank_info[rank].font)
  ed.setLabelString(board.rank, res.equip_rank_info[rank].name)
  board.info = equipInfo
  self.draglist.listLayer:addChild(bg)
  table.insert(self.draglist.listData, board)
end
class.createEquipInfo = createEquipInfo
local function createEquipList(self)
  self.draglist:clearList()
  self.draglist.listData = {}
  local equips = self:getAllEquip()
  local heroRank = self:getHero()._rank
  for i, v in ipairs(equips) do
	--add by xinghui:avoid 'purple+4 and orange' temporary
	if (heroRank + i - 1) < 11 then
		self:createEquipInfo(v, heroRank + i - 1)
	end
	--	
  end
  local totoalLayer = #self.draglist.listData
  for i = 1, totoalLayer do
    self.draglist.listData[i].bg:setPosition(ccp(142, 395 - (itemHeight + 8) * (i - 1)))
  end
  local totalHeight = (itemHeight + 8) * totoalLayer
  self.draglist:initListHeight(totalHeight)
end
class.createEquipList = createEquipList
local function create(hero, param)
  param = param or {}
  local self = base.create("evolveequip")
  setmetatable(self, class.mt)
  self.closeHandler = param.closeHandler
  self.parent = param.parent
  self.hero = hero
  local mainLayer = self.mainLayer
  local container = self.container
  container:setPosition(ccp(48, 0))
  self.ui = {}
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "bg",
        res = "UI/alpha/HVGA/herodetail-detail-popup.png"
      },
      layout = {
        position = ccp(400, 240)
      },
      config = {isCascadeOpacity = true}
    },
    {
      t = "Sprite",
      base = {
        name = "des_title_bg",
        res = "UI/alpha/HVGA/herodetail-title-mark.png"
      },
      layout = {
        position = ccp(400, 440)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "des_title",
        text = T(LSTR("EQUIP.EVOLUTION")),
        size = 20
      },
      layout = {
        position = ccp(400, 440)
      },
      config = {
        color = ccc3(251, 206, 16)
      },
      offsetY = 4,
      addHeight = 4
    }
  }
  local readNode = ed.readnode.create(self.container, self.ui)
  readNode:addNode(ui_info)
  local info = {
    cliprect = CCRectMake(17, 15, 255, 395),
    container = self.ui.bg,
    zorder = 10,
    priority = -136
  }
  self.draglist = ed.draglist.create(info)
  self:createEquipList()
  self.parent:addChild(self.mainLayer)
  return self
end
class.create = create
local popBack = function(self, param)
  if tolua.isnull(self.mainLayer) then
    return
  end
  if self.container:numberOfRunningActions() > 0 then
    return
  end
  self.mainLayer:setTouchEnabled(false)
  self.mainLayer:setZOrder(0)
  local move = CCMoveTo:create(0.2, param.endPos)
  local func = CCCallFunc:create(function()
    xpcall(function()
      if not tolua.isnull(self.mainLayer) then
        self.mainLayer:removeFromParentAndCleanup(true)
      end
      if param.callback then
        param.callback()
      end
    end, EDDebug)
  end)
  self.container:runAction(ed.readaction.create({
    t = "seq",
    move,
    func
  }))
end
class.popBack = popBack
local pop = function(self, param)
  self.mainLayer:setTouchEnabled(false)
  if not param.skipAnim then
    self.container:setPosition(param.oriPos)
    local move = CCMoveTo:create(0.2, param.endPos)
    local func = CCCallFunc:create(function()
      xpcall(function()
        self.mainLayer:setTouchEnabled(true)
      end, EDDebug)
    end)
    self.container:runAction(ed.readaction.create({
      t = "seq",
      move,
      func
    }))
  else
    self.container:setPosition(param.endPos)
    self.mainLayer:setTouchEnabled(true)
  end
end
class.pop = pop
