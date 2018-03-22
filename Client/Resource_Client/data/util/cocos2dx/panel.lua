local functions = require("util.functions")
PanelExtend = functions.class("PanelExtend")
function PanelExtend.create(target)
  assert(not tolua.isnull(target), "PanelExtend.create() - target is not CCNode")
  functions.extend(target, PanelExtend)
  return target
end
return PanelExtend
