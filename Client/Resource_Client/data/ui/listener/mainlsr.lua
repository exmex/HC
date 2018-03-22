local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.mainlsr = class
local base = ed.ui.baselsr
setmetatable(class, base.mt)
local function create()
  local self = base.create("main")
  setmetatable(self, class.mt)
  return self
end
class.create = create
local function enterScene(self, param)
  ed.playMusic(ed.music.map)
  self:teachOpenModule()
end
class.enterScene = enterScene
local exitScene = function(self, param)
  self.refresh_dailyjob_callback = nil
end
class.exitScene = exitScene
local function clickcot(self)
  ed.playEffect(ed.sound.main.clickcot)
end
class.clickcot = clickcot
local function clickpve(self)
  ed.playEffect(ed.sound.main.clickPVE)
end
class.clickpve = clickpve
local function clickpvp(self)
  ed.playEffect(ed.sound.main.clickPVP)
end
class.clickpvp = clickpvp
local function clickshop(self)
  ed.playEffect(ed.sound.main.clickShop)
end
class.clickshop = clickshop
local function clicksshop(self)
  ed.playEffect(ed.sound.main.clickSpecialShop)
end
class.clicksshop = clicksshop
local function clickssshop(self)
  ed.playEffect(ed.sound.main.clickSoSpecialShop)
end
class.clickssshop = clickssshop
local function clickstarshop(self)
  ed.playEffect(ed.sound.main.clickStarshop)
end
class.clickstarshop = clickstarshop
local function clickhandbook(self)
  ed.playEffect(ed.sound.main.clickHandbook)
end
class.clickhandbook = clickhandbook
local function clickestren(self)
  ed.playEffect(ed.sound.main.clickEstrenUpgrade)
end
class.clickestren = clickestren
local function clicktavern(self)
  ed.playEffect(ed.sound.main.clickTarvern)
end
class.clicktavern = clicktavern
local function clickexercise(self)
  ed.playEffect(ed.sound.main.clickexercise)
end
class.clickexercise = clickexercise
local function clickMailbox(self)
  ed.playEffect(ed.sound.main.clickMailbox)
end
class.clickMailbox = clickMailbox
local function clickgm(self)
  ed.playEffect(ed.sound.main.clickGM)
end
class.clickgm = clickgm
local function clickMainButton(self, param)
  local key = param.key
  local keys = {
    shop = {t = "openShop", k = "shop"},
    pvp = {t = "openpvp", k = "PVP"},
    defence = {t = "opencot", k = "COT"},
    estren = {
      t = "openEnhance",
      k = "Enhance"
    },
    exercise = {
      t = "openExercise",
      k = "Exercise"
    }
  }
  local d = keys[key]
  if not d then
    return
  end
  if ed.playerlimit.checkAreaUnlock(d.k) then
    ed.endTeach(d.t)
  end
end
class.clickMainButton = clickMainButton
local function teachOpenModule(self)
  local scene = ed.getCurrentScene() or {}
  if scene.identity ~= "main" then
    return
  end
  local res = ed.ui.mainres
  local topContainer = scene.topContainer
  local mainLayer = scene.mainLayer
  local keys = {
    shop = {t = "openShop", k = "shop"},
    PVP = {t = "openpvp", k = "pvp"},
    COT = {t = "opencot", k = "defence"},
    Enhance = {
      t = "openEnhance",
      k = "estren"
    },
    Exercise = {
      t = "openExercise",
      k = "exercise"
    },
--[[    Excavate = {
      t = "openExcavate",
      k = "excavate"
    }]]--
  }
  for k, v in pairs(keys) do
    if ed.playerlimit.checkAreaUnlock(k) then
      local tk = v.t
      local rk = v.k
      local r = res.res_pos[rk]
      local ist = ed.teach(tk, ccpAdd(r.touchCenter, r.pos), r.touchRadius, topContainer, {topContainer, mainLayer})
      if ist then
        scene:bgHorizontalScroll(400 - r.pos.x)
      end
    end
  end
  if ed.player:checkShopTimeType(2) == "expire" then
    if 0 < (ed.player:getShopExpireTime(2) or 0) then
      local tk = "openSpecialShop"
      local rk = "sshop"
      local r = res.res_pos[rk]
      local ist = ed.teach(tk, ccpAdd(r.touchCenter, r.pos), r.touchRadius, topContainer, {topContainer, mainLayer})
      if ist then
        scene:bgHorizontalScroll(400 - r.pos.x)
      end
    end
  end
  if ed.player:checkShopTimeType(3) == "expire" then
    if 0 < (ed.player:getShopExpireTime(3) or 0) then
      local tk = "openSoSpecialShop"
      local rk = "ssshop"
      local r = res.res_pos[rk]
      local ist = ed.teach(tk, ccpAdd(r.touchCenter, r.pos), r.touchRadius, topContainer, {topContainer, mainLayer})
      if ist then
        scene:bgHorizontalScroll(400 - r.pos.x)
      end
    end
  end
  if ed.player:checkShopTimeType("starshop") == "expire" then
    if 0 < (ed.player:getShopExpireTime("starshop") or 0) and not ed.player:checkShopGoodsEmpty("starshop") then
      local tk = "openStarshop"
      local rk = "starshop"
      local r = res.res_pos[rk]
      local list = ed.teach(tk, ccpAdd(r.touchCenter, r.pos), r.touchRadius, topContainer, {topContainer, mainLayer})
      if ist then
        scene:bgHorizontalScroll(400 - r.pos.x)
      end
    end
  end
end
class.teachOpenModule = teachOpenModule
