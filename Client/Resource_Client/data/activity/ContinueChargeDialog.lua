local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.continuechargedialog = class
local registerTouchHandler = function(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.ok_button,
    press = ui.ok_button_press,
    key = "ok_button",
    clickHandler = function()
      self:destroy()
    end
  })
end
class.registerTouchHandler = registerTouchHandler
local initWindow = function(self)
  local ui = self.ui
  local param = self.param
  local titleText = param.title or T(LSTR("scrolldialog.1.10.1.001"))
  local title = ed.createNode({
    t = "Label",
    base = {text = titleText, size = 20},
    layout = {
      position = ed.DGccp(372, 482)
    },
    config = {
      color = ccc3(255, 208, 18)
    }
  }, ui.frame, 10)
  local info = {
    cliprect = ed.DGRectMake(188, 150, 648, 340),
    noshade = true,
    container = self.mainLayer,
    priority = self.mainTouchPriority - 5,
    zorder = 10,		
    bar = {
      bglen = ed.DGLen(335),
      bgpos = ed.DGccp(170, 315)
    }
  }
  local draglist = ed.draglist.create(info)
  self.draglist = draglist
  local content = ed.createNode({
	t = "HtmlLabel",
    base = {
	  name = "htmlLabelTest",
	  file = "html/html.htm",
      text = param.content or "",	
      size = CCSize(485, 200)
    },
    layout = {
      anchor = ccp(0, 1),
      position = ed.DGccp(192, 485)
    }
  }	
  , draglist.listLayer)
  draglist:initListHeight(content:getContentSize().height)
end
class.initWindow = initWindow
local function create(param)
  param = param or {}
  local self = base.create("continuechargedialog")
  setmetatable(self, class.mt)
  self.param = param
  local container
  container, self.ui = ed.editorui(ed.uieditor.continuechargedialogui)
  self:setContainer(container)
  self:initWindow()
  self.isSkipTransAnim = true
  self:registerTouchHandler()
  return self
end
class.create = create
