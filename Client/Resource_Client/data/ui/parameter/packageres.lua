local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.packageres = class
local base = ed.ui.baseres
setmetatable(class, base.mt)
class.package = {
  list_key = {
    {
      key = "all",
      name = T(LSTR("BATTLEPREPARE.WHOLE"))
    },
    {
      key = "equip",
      name = T(LSTR("EQUIPCRAFT.GEAR"))
    },
    {
      key = "scroll",
      name = T(LSTR("EQUIP.REEL"))
    },
    {
      key = "stone",
      name = T(LSTR("EQUIP.SOUL_STONE"))
    },
    {
      key = "consume",
      name = T(LSTR("EQUIP.CONSUMABLES"))
    }
  }
}
class.fragment = {
  list_key = {
    {
      key = "all",
      name = T(LSTR("BATTLEPREPARE.WHOLE"))
    },
    {
      key = "equip",
      name = T(LSTR("EQUIPCRAFT.GEAR"))
    },
    {
      key = "scroll",
      name = T(LSTR("EQUIP.REEL"))
    }
  }
}
