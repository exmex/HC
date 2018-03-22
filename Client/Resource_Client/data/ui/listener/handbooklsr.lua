local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.handbooklsr = class
local base = ed.ui.baselsr
setmetatable(class, base.mt)
local function create()
  local self = base.create("handbook")
  setmetatable(self, class.mt)
  return self
end
class.create = create
local function clickTag(self)
  ed.playEffect(ed.sound.handbook.clickTag)
end
class.clickTag = clickTag
local function clickElement(self)
  ed.playEffect(ed.sound.handbook.clickElement)
end
class.clickElement = clickElement
local function clickBack(self)
  ed.playEffect(ed.sound.handbook.clickBack)
end
class.clickBack = clickBack
local function clickArrow(self)
  ed.playEffect(ed.sound.handbook.clickLeftArrow)
end
class.clickArrow = clickArrow
local function tuenPageFailed(self)
  ed.playEffect(ed.sound.handbook.turnPageFailed)
end
class.tuenPageFailed = tuenPageFailed
local function turnPage(self)
  ed.playEffect(ed.sound.handbook.turnPage)
end
class.turnPage = turnPage
