local equipBoard = ed.ui.equipboard
local base = equipBoard
local class = newclass(base.mt)
equipBoard.ofpackage = class
local registerTouchHandler = function(self)
  local ui = self.ui
  local param = self.param
  self:btRegisterButtonClick({
    button = ui.left_button,
    press = ui.left_button_press,
    key = "sell_button",
    clickHandler = function()
      if param.doSell then
        param.doSell()
      end
    end,
    force = true,
    clickInterval = 0.5
  })
  self:btRegisterButtonClick({
    button = ui.right_button,
    press = ui.right_button_press,
    key = "right_button",
    clickHandler = function()
      if param.propType == "prop" then
        if param.doCheck then
          param.doCheck()
        end
      elseif param.propType == "consume" then
        if param.doUse then
          param.doUse()
        end
      elseif param.propType == "fragment" and param.doCompose then
        param.doCompose()
      end
    end,
    force = true,
    clickInterval = 0.5
  })
end
class.registerTouchHandler = registerTouchHandler
local initWindow = function(self)
  local ui = self.ui
  local container = CCSprite:create()
  container:setAnchorPoint(ccp(0, 0))
  container:setCascadeOpacityEnabled(true)
  ui.bContainer = container
  ui.frame:addChild(container)
  local ui = self.ui
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "money_board",
        res = "UI/alpha/HVGA/money_board.png"
      },
      layout = {
        position = ccp(144, 100)
      },
      config = {isCascadeOpacity = true}
    },
    {
      t = "Label",
      base = {
        name = "sell_title",
        text = T(LSTR("EQUIPINFO.UNIT_SALE_COST")),
        size = 20,
        parent = "money_board"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(10, 24)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "sell_icon",
        res = "UI/alpha/HVGA/goldicon.png",
        parent = "money_board"
      },
      layout = {
        position = ccp(123, 23)
      },
      config = {scale = 0.75}
    },
    {
      t = "Label",
      base = {
        name = "sell_number",
        text = "",
        size = 18,
        parent = "money_board"
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(150, 25)
      },
      config = {
        color = ccc3(155, 34, 14)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "left_button",
        res = "UI/alpha/HVGA/package_button.png",
        capInsets = CCRectMake(10, 10, 236, 29),
        z = 10
      },
      layout = {
        position = ccp(82, 40)
      },
      config = {
        scaleSize = CCSizeMake(125, 49),
        isCascadeOpacity = true
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "left_button_press",
        res = "UI/alpha/HVGA/package_button_down.png",
        capInsets = CCRectMake(10, 10, 236, 29),
        parent = "left_button"
      },
      layout = {mediate = true},
      config = {
        scaleSize = CCSizeMake(125, 49),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "left_button_label",
        text = T(LSTR("PACKAGE.SELL")),
        fontinfo = "ui_normal_button",
        z = 1,
        parent = "left_button"
      },
      layout = {mediate = true},
      config = {
        shadow = {
          color = ccc3(42, 31, 22),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "right_button",
        res = "UI/alpha/HVGA/package_button.png",
        capInsets = CCRectMake(10, 10, 236, 29),
        z = 10
      },
      layout = {
        position = ccp(212, 40)
      },
      config = {
        scaleSize = CCSizeMake(125, 49),
        isCascadeOpacity = true
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "right_button_press",
        res = "UI/alpha/HVGA/package_button_down.png",
        capInsets = CCRectMake(10, 10, 236, 29),
        parent = "right_button"
      },
      layout = {mediate = true},
      config = {
        scaleSize = CCSizeMake(125, 49),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "right_button_label",
        text = "",
        fontinfo = "ui_normal_button",
        z = 1,
        parent = "right_button"
      },
      layout = {mediate = true},
      config = {
        shadow = {
          color = ccc3(42, 31, 22),
          offset = ccp(0, 2)
        }
      }
    }
  }
  local readNode = ed.readnode.create(container, ui)
  readNode:addNode(ui_info)
  self:refreshPrice()
  self:refreshButton()
end
class.initWindow = initWindow
local refreshPrice = function(self)
  local ui = self.ui
  local id = self.param.id
  local price = ed.getDataTable("equip")[id]["Sell Price"]
  if price > 0 then
    ui.money_board:setVisible(true)
    ed.setString(ui.sell_number, tostring(price))
  else
    ui.money_board:setVisible(false)
  end
end
class.refreshPrice = refreshPrice
local refreshButton = function(self)
  local param = self.param
  local id = param.id
  local propType = param.propType
  local buttonLabel = self.ui.right_button_label
  if propType == "prop" then
    ed.setString(buttonLabel, T(LSTR("PACKAGE.DETAIL")))
  elseif propType == "consume" then
    ed.setString(buttonLabel, T(LSTR("MIDAS.USE")))
  elseif propType == "fragment" then
    ed.setString(buttonLabel,T(LSTR("EQUIPCRAFT.SYNTHESIS")))
  end
end
class.refreshButton = refreshButton
local refreshPropType = function(self)
  local id = self.param.id
  local propType = "prop"
  local row = ed.getDataTable("equip")[id]
  local category = row.Category
  if category == T(LSTR("EQUIP.FRAGMENT")) then
    propType = "fragment"
    if row.Name == T(LSTR("EQUIP.UNIVERSAL_DEBRIS")) then
      self.propType = "prop"
    end
  elseif category == T(LSTR("EQUIP.CONSUMABLES"))  then
    local consumeType = row["Consume Type"]
    if ed.isElementInTable(consumeType, {
      T(LSTR("EQUIP.EXPERIENCE_PILL"))
    }) then
      propType = "consume"
    end
  end
  self.param.propType = propType
end
class.refreshPropType = refreshPropType
local refresh = function(self, id)
  self.param.id = id
  self:refreshPropType()
  self:initContainer({isFade = true})
  self:refreshAmount()
  self.ui.frame:setOpacity(255)
  self:refreshPrice()
  self:refreshButton()
end
class.refresh = refresh
local function create(param)
  param = param or {}
  local self = base.create("equipboardofpackage")
  setmetatable(self, class.mt)
  self.param = param
  self:refreshPropType()
  local ui = self.ui
  self:initFrame()
  self:setCloseVisible(false)
  self:initAmount()
  ui.frame:setPosition(ed.getCenterPos(ui.frame))
  self:initWindow()
  self:registerTouchHandler()
  return self
end
class.create = create
local popout = function(self, callback)
  local frame = self.ui.frame
  self:doFadeOut(function()
    if not tolua.isnull(self.mainLayer) then
      self.mainLayer:removeFromParentAndCleanup(true)
    end
    if callback then
      callback()
    end
  end)
end
class.popout = popout
local popin = function(self)
  local frame = self.ui.frame
  frame:setPosition(ccp(-142, 213))
  frame:setOpacity(255)
  local move = CCEaseOut:create(CCMoveTo:create(0.2, ccp(182, 213)), 5)
  frame:runAction(move)
end
class.popin = popin
