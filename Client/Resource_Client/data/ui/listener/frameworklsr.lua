local base = ed.ui.baselsr
local class = newclass(base.mt)
ed.ui.frameworklsr = class
local function create()
  local self = base.create("framework")
  setmetatable(self, class.mt)
  return self
end
class.create = create
local openShortcut = function(self)
  ed.playEffect(ed.sound.common.popShortcut)
end
class.openShortcut = openShortcut
local closeShortcut = function(self)
  ed.playEffect(ed.sound.common.pushShortcut)
end
class.closeShortcut = closeShortcut
local clickMoney = function(self)
  ed.playEffect(ed.sound.main.clickMoney)
end
class.clickMoney = clickMoney
local clickrmb = function(self)
  ed.playEffect(ed.sound.main.clickRecharge)
end
class.clickrmb = clickrmb
local clickHeroPackage = function(self)
  ed.playEffect(ed.sound.main.clickHeroPackage)
end
class.clickHeroPackage = clickHeroPackage
local clickPackage = function(self)
  ed.playEffect(ed.sound.main.clickPackage)
end
class.clickPackage = clickPackage
local clickFragment = function(self)
  ed.playEffect(ed.sound.main.clickFragment)
end
class.clickFragment = clickFragment
local clickTask = function(self)
  ed.playEffect(ed.sound.main.clickTask)
end
class.clickTask = clickTask
local clickRecharge = function(self)
  ed.playEffect(ed.sound.main.clickRecharge)
end
class.clickRecharge = clickRecharge
local clickBack = function(self)
  ed.playEffect(ed.sound.common.back)
end
class.clickBack = clickBack
