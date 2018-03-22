local base = ed.ui.basetouchnode
local class = newclass(base)
ed.ui.basenode = class

local function create(nodeIdentity, param)
	local self = {}
	setmetatable(self, class.mt)
	self.nodeIdentity = nodeIdentity
	return self
end
class.create = create
