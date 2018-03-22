local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.exerciselsr = class
local base = ed.ui.baselsr
setmetatable(class, base.mt)
local function create()
  local self = base.create("exercise")
  setmetatable(self, class.mt)
  return self
end
class.create = create
local function clickDegreeButton(self)
  ed.playEffect(ed.sound.exercise.clickDegree)
end
class.clickDegreeButton = clickDegreeButton
local function clickActButton(self)
  ed.playEffect(ed.sound.exercise.clickExercise)
end
class.clickActButton = clickActButton
