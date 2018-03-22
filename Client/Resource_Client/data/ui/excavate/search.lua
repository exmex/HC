local base = ed.ui.basescene
local class = newclass(base.mt)
ed.ui.excavatesearch = class
local function registerSearchButton(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.search_button,
    press = ui.search_button_press,
    key = "search_button",
    clickHandler = function()
      if ed.ui.excavate.checkSearchTimeMax() then
        ed.showToast(T(LSTR("MAP.TODAY_THE_SEARCH_HAS_REACHED_THE_MAXIMUM_NUMBER_OF_TIMES_")))
        return
      end
      local cost = ed.player:getExcavateSearchCost()
      local gold = ed.player._money
      if cost > gold then
        ed.showHandyDialog("useMidas", {
          refreshHandler = function()
            self:refreshCostLabel()
          end
        })
      else
        self:btRemoveMainTouchHandler({
          key = "search_button"
        })
        class.ori_search_pos = class.ori_search_pos or ccp(ui.search_icon:getPosition())
        self:registerUpdateHandler("iconMoveCircle", ed.readaction.getMoveCircleAction({
          palstance = 180,
          node = ui.search_icon,
          center = class.ori_search_pos,
          radius = 20,
          target = 1,
          -- callback = function()
          --   self:removeUpdateHandler("iconMoveCircle")
          --   ed.ui.excavate.search(function(param)
          --     ed.replaceScene(ed.ui.excavatemap.create(param))
          --   end, function()
          --     self:registerSearchButton()
          --   end)
          -- end
        }))
      end
    end,
    clickInterval = 0.5
  })
end
class.registerSearchButton = registerSearchButton
local registerTouchHandler = function(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.back_button,
    press = ui.back_button_press,
    key = "back_button",
    clickHandler = function()
      ed.popScene()
    end
  })
  self:btRegisterButtonClick({
    button = ui.histroy_button,
    press = ui.histroy_button_press,
    key = "histroy_button",
    clickHandler = function()
      ed.ui.excavatehistory.pop()
    end,
    clickInterval = 0.5
  })
  self:btRegisterButtonClick({
    button = ui.explain_button,
    press = ui.explain_button_press,
    key = "explain_button",
    clickHandler = function()
      ed.ui.excavateexplain.pop()
    end,
    clickInterval = 0.5
  })
  self:registerSearchButton()
end
class.registerTouchHandler = registerTouchHandler
local refreshCostLabel = function(self)
  local ui = self.ui
  local cost = ed.player:getExcavateSearchCost()
  local label = ui.cost_label
  ed.setString(label, tostring(cost))
  if cost > ed.player._money then
    ed.setLabelColor(label, ccc3(255, 0, 0))
  else
    ed.setLabelColor(label, ccc3(255, 174, 53))
  end
end
class.refreshCostLabel = refreshCostLabel
local refreshHistoryTag = function(self)
  local ui = self.ui
  local tag = ui.history_red_tag
  if ed.player:checkUnreadExcavateHistory() then
    tag:setVisible(true)
  else
    tag:setVisible(false)
  end
end
class.refreshHistoryTag = refreshHistoryTag
local function create(param)
  param = param or {}
  local self = base.create("excavatesearch")
  setmetatable(self, class.mt)
  local mainLayer = self.mainLayer
  local container
  container, self.ui = ed.editorui(ed.uieditor.excavatesearch)
  local ui = self.ui
  mainLayer:addChild(container)
  self:refreshCostLabel()
  self:registerTouchHandler()
  self:refreshHistoryTag()
  if ed.player:getName() == "" then
    local bename = ed.ui.bename.create()
    function bename.destroyHandler()
      ed.popScene()
    end
    mainLayer:addChild(bename.mainLayer, 250)
  end
  if ui.history_button_label:getContentSize().width > 100 then
    ui.history_button_label:setScale(100/ui.history_button_label:getContentSize().width)
  end
  --explain_button_label
  if ui.explain_button_label:getContentSize().width > 50 then
    ui.explain_button_label:setScale(50/ui.explain_button_label:getContentSize().width)
  end
  return self
end
class.create = create
