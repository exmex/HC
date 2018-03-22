local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.ui.popwindow
setmetatable(class, base.mt)
ed.ui.popherotask = class
local lsr = ed.ui.popherocardlsr.create()
local lsra = ed.ui.awakelsr.create()
local function doClickClose(self)
  lsr:report("clickCloseLoots")
  if self.handler then
    self.handler()
  end
  local container = self.mainLayer
  local s = CCScaleTo:create(0.1, 0)
  s = CCSequence:createWithTwoActions(s, CCCallFunc:create(function()
    self:destroy()
  end))
  container:runAction(s)
end
class.doClickClose = doClickClose
local function doClickTrigNewTask(self)
  self:doClickClose()
  lsra:report("showHeroTask")
  local taskLayer = ed.ui.task.create(function()
    local hdwindow = ed.getPopWindow("herodetail")
    local refreshUI = (hdwindow or {}).mainLayer
    if not tolua.isnull(refreshUI) then
      hdwindow.craftSlot = 1
      hdwindow:wearEquip()
      hdwindow:refreshEquipTag()
    end
    EDLog("#chain activited over ")
  end)
  self.scene:addChild(taskLayer.mainLayer, 120)
  local chainId = 0
  local heroTaskTable = ed.getDataTable("HeroTask")
  for k, v in pairs(heroTaskTable) do
    if k ~= "name" then
      for m, n in pairs(v) do
        if v[m]["Hero ID"] == self.hid then
          chainId = k
          break
        end
      end
    end
  end
  if chainId > 0 then
    local msgList = {}
    table.insert(msgList, {
      id = 1,
      chain = chainId,
      isFinished = false,
      count = 0,
      noTrigger = true
    })
    ed.netdata.triggerTask = msgList
    ed.netreply.triggerTask = taskLayer:triggerTaskReply(msgList)
    local msg = ed.upmsg.trigger_task()
    local ts = {}
    table.insert(ts, ed.makebits(16, chainId, 16, 1))
    msg._task = ts
    ed.send(msg, "trigger_task")
  end
end
class.doClickTrigNewTask = doClickTrigNewTask
local registerTouchHandler = function(self)
  local mainLayer = self.mainLayer
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.ok,
    press = ui.ok_press,
    key = "ok_button",
    clickHandler = function()
      self:doClickTrigNewTask()
    end
  })
  self:btRegisterButtonClick({
    button = ui.cancel,
    press = ui.cancel_press,
    key = "cancel_button",
    clickHandler = function()
      self:doClickClose()
    end
  })
end
class.registerTouchHandler = registerTouchHandler
local function create(param)
  param = param or {}
  param.noShade = true
  local self = base.create("popherotask", param)
  setmetatable(self, class.mt)
  self.baseScene = ed.getCurrentScene()
  self.hid = param.id
  self.eid = ed.getDataTable("HeroTask"):getHeroTaskCsvEquipid(self.hid)
  self.star = ed.getDataTable("Unit")[self.hid]["Initial Stars"]
  self.amount = param.amount or 0
  self.handler = param.handler
  self.index = param.index
  local mainLayer = self.mainLayer
  local ui = self.ui
  local readnode = ed.readnode.create(mainLayer, ui)
  local tipsstr = string.format(T(LSTR("popherotask.2.0.1.001")), ed.lookupDataTable("Unit", "Display Name", self.hid))
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "windowbg",
        res = "UI/alpha/HVGA/awake/hero_task_bg.png"
      },
      layout = {
        position = ccp(400, 250)
      },
      config = {scale = 0.9}
    },
    {
      t = "Sprite",
      base = {
        name = "light",
        res = "UI/alpha/HVGA/shine.png"
      },
      layout = {
        position = ccp(400, 265)
      },
      config = {opacity = 0, scale = 1.5}
    },
    {
      t = "FcaEffect",
      base = {
        name = "taskshine",
        res = "eff_UI_hero_task_shine"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(400, 265)
      },
      config = {scale = 0.8}
    },
    {
      t = "Label",
      base = {
        name = "tips",
        text = tipsstr,
        size = 18
      },
      layout = {
        position = ccp(400, 330)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "sp_line",
        res = "UI/alpha/HVGA/awake/separate_line.png"
      },
      layout = {
        position = ccp(400, 208)
      },
      config = {scale = 0.95}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "ok",
        res = "UI/alpha/HVGA/tavern_button_normal_1.png",
        capInsets = CCRectMake(20, 15, 90, 15)
      },
      layout = {
        position = ccp(480, 180)
      },
      config = {
        scaleSize = CCSizeMake(100, 45)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "ok_press",
        res = "UI/alpha/HVGA/tavern_button_normal_2.png",
        capInsets = CCRectMake(20, 15, 90, 15),
        parent = "ok"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        visible = false,
        scaleSize = CCSizeMake(100, 45)
      }
    },
    {
      t = "Label",
      base = {
        name = "ok_label",
        text = T(LSTR("popherotask.2.0.1.002")),
        size = 23,
        parent = "ok"
      },
      layout = {
        position = ccp(50, 23)
      },
      config = {
        color = ccc3(234, 225, 205)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "cancel",
        res = "UI/alpha/HVGA/tavern_button_normal_1.png",
        capInsets = CCRectMake(20, 15, 90, 15)
      },
      layout = {
        position = ccp(315, 180)
      },
      config = {
        scaleSize = CCSizeMake(100, 45)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "cancel_press",
        res = "UI/alpha/HVGA/tavern_button_normal_2.png",
        capInsets = CCRectMake(20, 15, 90, 15),
        parent = "cancel"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        visible = false,
        scaleSize = CCSizeMake(100, 45)
      }
    },
    {
      t = "Label",
      base = {
        name = "cancel_label",
        text = T(LSTR("popherotask.2.0.1.003")),
        size = 23,
        parent = "cancel"
      },
      layout = {
        position = ccp(50, 23)
      },
      config = {
        color = ccc3(234, 225, 205)
      }
    }
  }
  readnode:addNode(ui_info)
  local container = mainLayer
  container:setScale(0)
  local s1 = CCScaleTo:create(0.2, 1)
  container:runAction(CCEaseBackOut:create(s1))
  if self.eid and self.eid > 0 then
    local equipbg = ed.readequip.createIcon(self.eid)
    equipbg:setPosition(ccp(400, 265))
    equipbg:setScale(60 / equipbg:getContentSize().width)
    local name = ed.createttf(ed.getDataTable("equip")[self.eid].Name, 20)
    name:setAnchorPoint(ccp(0.5, 0.5))
    name:setPosition(ccp(equipbg:getContentSize().width * 0.5, equipbg:getContentSize().height * 0.5 - 55))
    ed.setLabelColor(name, ccc3(255, 255, 255))
    ed.setLabelShadow(name, ccc3(0, 0, 0), ccp(0, 2))
    equipbg:addChild(name)
    container:addChild(equipbg)
  end
  local fi = CCFadeIn:create(0.4)
  local light = ui.light
  fi = CCFadeIn:create(0.4)
  local s = CCSequence:createWithTwoActions(fi, CCCallFunc:create(function()
    xpcall(function()
      local r = CCRotateBy:create(5, 360)
      r = CCRepeatForever:create(r)
      light:runAction(r)
    end, EDDebug)
  end))
  light:runAction(s)
  self.baseScene:addFca(ui.taskshine)
  self:registerTouchHandler()
  self:show()
  
  ed.pop_popherotask=self
  
  return self
end
class.create = create
local function show(self)
  lsr:report("createCardLayer")
end
class.show = show
local function destroy(self)
  lsr:report("closeCardLayer")
  self.mainLayer:removeFromParentAndCleanup(true)
end
class.destroy = destroy
