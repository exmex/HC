local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.fbattention = class
local function sendmsg()
	 local msg = ed.upmsg.fb_attention()
     msg._fb_attention = 1
     ed.send(msg, "fb_attention")
end
local registerTouchHandler = function(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.ok_button,
    press = ui.ok_button_press,
    key = "ok_button",
    clickHandler = function()
      self:destroy()
	  sendmsg()
    end
  })
 self:btRegisterButtonClick({
    button = ui.cancel_button,
    press = ui.cancel_button_press,
    key = "cancel_button",
    clickHandler = function()
      self:destroy()
    end
  })
end
class.registerTouchHandler = registerTouchHandler

local function create()
  local self = base.create("fbattention")
  setmetatable(self, class.mt)
  local container
  container, self.ui = ed.editorui(ed.uieditor.fbattinfo)
  self:setContainer(container)
  self:registerTouchHandler()
  return self
end
class.create = create

