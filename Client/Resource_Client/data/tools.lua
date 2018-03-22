require("bit")
ed = {
	epsilon = 1.0E-6,
	emCampPlayer = 1,
	emCampEnemy = -1,
	emCampBoth = 0,
	emUnitStateBase = -1,
	emUnitState_Idle = 0,
	emUnitState_Walk = 1,
	emUnitState_Attack = 2,
	emUnitState_Hurt = 3,
	emUnitState_Dead = 4,
	emUnitState_Birth = 5,
	emUnitState_Dying = 6,
	emUnitStateCount = 7,
	deepProjectionX = math.cos(math.rad(90)),
	deepProjectionY = math.sin(math.rad(90)),
	ccp = ccp,
	ccpAdd = ccpAdd,
	ccpSub = ccpSub,
	ccpMult = ccpMult,
	ccpCompMult = ccpCompMult,
	ccpLengthSQ = ccpLengthSQ,
	ccpDistanceSQ = ccpDistanceSQ,
	ccpNormalize = ccpNormalize,
	CCRectGetMaxX = function(rect)
	return rect.origin.x + rect.size.width
	end,
	CCRectGetMaxY = function(rect)
	return rect.origin.y + rect.size.height
	end,
	CCRectIntersect = function(rectA, rectB)
	local max, min = math.max, math.min
	local intersection = CCRectMake(max(rectA.origin.x, rectB.origin.x), max(rectA.origin.y, rectB.origin.y), 0, 0)
	intersection.size.width = min(ed.CCRectGetMaxX(rectA), ed.CCRectGetMaxX(rectB)) - intersection.origin.x
	intersection.size.height = min(ed.CCRectGetMaxY(rectA), ed.CCRectGetMaxY(rectB)) - intersection.origin.y
	return intersection
	end,
	ui = {},
    dot_id = 500,--add by cooper.x for send dot info
    activitys = {},--add by cooper.x for activity
	--平台相关的信息
	PlatformCode=
	{
		CC_PLATFORM_UNKNOWN       =     0,
		CC_PLATFORM_IOS           =     1,
		CC_PLATFORM_ANDROID       =     2,
		CC_PLATFORM_WIN32         =     3,
		CC_PLATFORM_MARMALADE     =     4,
		CC_PLATFORM_LINUX         =     5,
		CC_PLATFORM_BADA          =     6,
		CC_PLATFORM_BLACKBERRY    =     7,
		CC_PLATFORM_MAC           =     8,
		CC_PLATFORM_NACL          =     9,
		CC_PLATFORM_EMSCRIPTEN    =    10,
		CC_PLATFORM_TIZEN         =    11,
		CC_PLATFORM_WINRT         =    12,
		CC_PLATFORM_WP8           =    13
	}
}
local ed = ed
require("time")
local rshift = bit.rshift
local lshift = bit.lshift
local band = bit.band
local function bits(num, low, count)
  return band(rshift(num, low), 2 ^ count - 1)
end
ed.bits = bits
local select = select
local function makebits(...)
  local value = 0
  local b0 = 0
  for i = select("#", ...), 1, -2 do
    local b = select(i - 1, ...)
    local v = select(i, ...)
    local v2 = bits(v, 0, b)
    if v ~= v2 then
      EDDebug("value out of bit boundry")
    end
    v = lshift(v, b0)
    value = value + v
    b0 = b0 + b
  end
  return value
end
ed.makebits = makebits
local function splitbits(value, ...)
  local list = {}
  local b0 = 0
  for i = select("#", ...), 1, -1 do
    local b = select(i, ...)
    table.insert(list, bits(value, b0, b))
    b0 = b0 + b
  end
  local l2 = {}
  for i, v in ipairs(list) do
    l2[#list - i + 1] = v
  end
  return unpack(l2)
end
ed.splitbits = splitbits
if ccp then
  ed.ccpZero = ccp(0, 0)
  do
    local ccpWinSize = CCDirector:sharedDirector():getWinSize()
    ed.ccpWinSize = ccp(ccpWinSize.width, ccpWinSize.height)
    ed.winSize = {
      ccpWinSize.width,
      ccpWinSize.height
    }
    local function winPosition(x, y)
      return ed.edpCompMult(ed.winSize, ccp(x, y))
    end
    ed.winPosition = winPosition
    local function ccpWinPosition(x, y)
      return ed.ccpCompMult(ed.ccpWinSize, ccp(x, y))
    end
    ed.ccpWinPosition = ccpWinPosition
    local ccc3 = ccc3
    local function toccc3(hex)
      return ccc3(hex / 65536, hex / 256 % 256, hex % 256)
    end
    ed.toccc3 = toccc3
  end
end
function log(...)
  if logfile then
    logfile:write(...)
    logfile:write("\n")
    logfile:flush()
  else
    print(...)
  end
end
ed.log = log
local multiplier = 3125
local moder = 34359738337
local random_seed = 1
local function rand()
  local next_seed = random_seed * multiplier % moder
  local ret = next_seed / moder
  random_seed = next_seed
  if do_battle_log then
    btlog("Rand:" .. ret)
  end
  return ret
end
ed.rand = rand
local function srand(seed)
  if seed == 0 then
    print("Error:srand(0)")
    seed = 1
  elseif do_battle_log then
    btlog("srand(" .. seed .. ")")
  end
  random_seed = seed
end
ed.srand = srand
local toboolean = function(var)
  if var == nil or var == false then
    return false
  end
  if type(var) == "string" then
    local lower = string.lower(var)
    return lower == "yes" or lower == "true" or lower == "y"
  elseif type(var) == "number" then
    return var ~= 0
  else
    return true
  end
end
ed.toboolean = toboolean
function override(basefunc, derivedfunc)
  assert(basefunc)
  assert(derivedfunc)
  return function(...)
    return derivedfunc(basefunc, ...)
  end
end
ed.override = override
local wraptable = function(table, patch)
  setmetatable(patch, {__index = table})
  return patch
end
ed.wraptable = wraptable
function ccArrayMake(...)
  local arg = ed.pack(...)
  if #arg == 1 and type(arg[1]) == "table" then
    arg = arg[1]
  end
  local ret = CCArray:createWithCapacity(#arg)
  for k = 1, #arg do
    ret:addObject(arg[k])
  end
  return ret
end
ed.ccArrayMake = ccArrayMake
if not LegendGetFileData then
  function LegendGetFileData(file)
    local file = io.open(file)
    local content = file:read("*a")
    file:close()
    return content
  end
end
function multiinher(class, parents)
  setmetatable(class, {
    __index = function(t, key)
      for k, v in pairs(parents) do
        if v[key] then
          return v[key]
        end
      end
      return nil
    end
  })
end
function setimplements(class, ...)
  class = class or {}
  local amount = select("#", ...)
  for i = 1, amount do
    local tar = select(i, ...)
    interface = tar.interface
    for k, v in pairs(interface or {}) do
      if class[k] then
        print("--<<setimplements>>-- Dumlicated key : ", k)
      else
        class[k] = interface[k]
      end
    end
  end
end
function newclass(superclass)
  local class = {
    mt = {}
  }
  class.mt.__index = class
  if superclass then
    if type(superclass) == "table" then
      setmetatable(class, superclass)
    elseif type(superclass) == "string" and superclass == "g" then
      setmetatable(class, {__index = _G})
    end
    -- if type(superclass) == "table" then
    --   setmetatable(class, superclass)
    -- elseif type(superclass) == "string" and superclass == "g" then
    --   setmetatable(class, {__index = _G})
    -- end
  end
  return class
end
local math = math
local min = math.min
local max = math.max
local function allocPosition(full, left, right, len, auto_len, stretch)
  if left and right and len then
    if math.abs(full - (left + right + len)) < ed.epsilon then
    else
      EDDebug()
      return
    end
  elseif left and right then
    if stretch then
      len = full - left - right
    elseif auto_len then
      len = auto_len()
      if len then
        left = left + (full - left - right - len) / 2
      else
        len = full - left - right
      end
    else
      len = full - left - right
    end
  elseif left and len then
    right = full - left - len
  elseif right and len then
    left = full - len - right
  elseif len then
    left = (full - len) / 2
  else
    if auto_len then
      return allocPosition(full, left, right, auto_len(), nil, stretch)
    else
    end
  end
  if len < 0 then
    EDDebug("WARNING: UI panel size < 0")
  end
  return left, len
end
ed.allocPosition = allocPosition
local function castLayout2BottomLeftRect(layout, width, height)
  local x, w = allocPosition(width, layout.left, layout.right, layout.fix_width)
  local y, h = allocPosition(height, layout.bottom, layout.top, layout.fix_height)
  return CCRectMake(x, y, w, h)
end
ed.castLayout2BottomLeftRect = castLayout2BottomLeftRect
local function castLayout2TopLeftRect(layout, width, height)
  local x, w = allocPosition(width, layout.left, layout.right, layout.fix_width)
  local y, h = allocPosition(height, layout.top, layout.bottom, layout.fix_height)
  return CCRectMake(x, y, w, h)
end
ed.castLayout2TopLeftRect = castLayout2TopLeftRect
function ed.getRelativePosition(sprite, pos, offset)
  local x, y = 0, 0
  if offset then
    x, y = offset.x, offset.y
  end
  local size = sprite:getContentSize()
  return ccp(pos.x * size.width + x, pos.y * size.height + y)
end
local function checkVisible(node)
  local parent = node:getParent()
  if tolua.isnull(parent) then
    return node:isVisible()
  end
  return node:isVisible() and checkVisible(parent)
end
ed.checkVisible = checkVisible
local format = string.format
local sub = string.sub
local gsub = string.gsub
local rankRecource = {
  "UI/alpha/HVGA/pvp/pvp_rank_1st.png",
  "UI/alpha/HVGA/pvp/pvp_rank_2nd.png",
  "UI/alpha/HVGA/pvp/pvp_rank_3rd.png"
}
local function createNumbers(node, str, padding, rightAlignment, colorStr, addition)
  addition = addition or {}
  local oripath = addition.path
  local suffix = addition.suffix
  colorStr = colorStr or "white"
  padding = padding or -2
  node:removeAllChildrenWithCleanup(true)
  local length = 0
  local height = 0
  for index = 1, #str do
    local i = index
    if rightAlignment then
      i = #str - i + 1
    end
    local c = sub(str, i, i)
    if c == ":" then
      c = "colon"
    end
    if c == "," then
      c = "comma"
    end
    if c == "/" then
      c = "slash"
    end
	local path = ""
	local language = CCUserDefault:sharedUserDefault():getStringForKey("client_language")
	if colorStr == "big_pvp1" then  --
		if tonumber(str) < 4 then
			path = "multilanguage/"..language.."/"..rankRecource[tonumber(str)]
		elseif tonumber(str) >= 4 and tonumber(str) < 11 then
			path = "UI/alpha/HVGA/digits/big_pvp/" .. c .. (suffix or ".png")
		else
			path = "UI/alpha/HVGA/digits/small_pvp/" .. c .. (suffix or ".png")
		end
	else
		path = (oripath or "UI/alpha/HVGA/digits/" .. colorStr) .. "/" .. c .. (suffix or ".png")
	end

    local spr = ed.createSprite(path)
    local w = spr:getContentSize().width + padding
    height = spr:getContentSize().height
    local relativeX = length + w * 0.5
    if rightAlignment then
      relativeX = -relativeX
    end
    spr:setPosition(ccp(relativeX, 0))
    length = length + w
    node:addChild(spr)
  end
  return length, height
end
ed.createNumbers = createNumbers
local function getNumberNode(param)
  param = param or {}
  local text = tostring(param.text)
  local padding = param.padding or 0
  local path = param.path
  local folder = param.folder or "white"
  local suffix = param.suffix
  if not text then
    return
  end
  local node = CCSprite:create()
  node:setCascadeOpacityEnabled(true)
  node:setContentSize(CCSizeMake(0, 0))
  local w, h = 0, 0
  for i = 1, #text do
    local char = string.sub(text, i, i)
    local ct = {
      [":"] = "colon",
      [","] = "comma",
      ["/"] = "slash"
    }
    char = ct[char] or char
    local epath = (path or "UI/alpha/HVGA/digits/" .. folder) .. "/" .. char .. (suffix or ".png")
    local enode = ed.createSprite(epath)
    local esize = enode:getContentSize()
    local ew, eh = esize.width, esize.height
    h = math.max(eh, h)
    w = w + ew + padding
    local nsize = node:getContentSize()
    local nw, nh = nsize.width, nsize.height
    enode:setAnchorPoint(ccp(0, 0.5))
    enode:setPosition(ccp(nw, h / 2))
    node:addChild(enode)
    node:setContentSize(CCSizeMake(w, h))
  end
  return {node = node, param = param}
end
ed.getNumberNode = getNumberNode
local function refreshNumberNode(numberNode, text, newParam)
  if type(numberNode) ~= "table" or not text then
    return
  end
  local node = numberNode.node
  local param = numberNode.param
  if tolua.isnull(node) then
    return
  end
  text = tostring(text)
  param.text = text
  if newParam then
    param = newParam
  end
  local anchor = node:getAnchorPoint()
  local pos = ccp(node:getPosition())
  local parent = node:getParent()
  node:removeFromParentAndCleanup(true)
  local nnode = ed.getNumberNode(param)
  local nn = nnode.node
  nn:setAnchorPoint(anchor)
  nn:setPosition(pos)
  parent:addChild(nn)
  numberNode.node = nn
  numberNode.param = param
end
ed.refreshNumberNode = refreshNumberNode
local function formatNumWithComma(amount)
  local formatted = format("%i", amount)
  local k
  while true do
    formatted, k = gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
    if k == 0 then
      break
    end
  end
  return formatted
end
ed.formatNumWithComma = formatNumWithComma
local cascadeSpriteFrame = function(target, frame)
  assert(not tolua.isnull(target), "ed.cascadeSpriteFrame() - target is not CCNode")
  if not tolua.isnull(frame) then
    local maskSprite = CCSprite:createWithSpriteFrame(frame)
    maskSprite:setAnchorPoint(ccp(0, 0))
    target:addChild(maskSprite)
  end
  return target
end
ed.cascadeSpriteFrame = cascadeSpriteFrame
local function loadHeroExpRequirement(heroId)
  local heroExpRequired = {}
  local lvl = 1
  local expRequired = ed.lookupDataTable("Levels", "Exp", lvl)
  while expRequired do
    heroExpRequired[lvl] = expRequired
    lvl = lvl + 1
    expRequired = ed.lookupDataTable("Levels", "Exp", lvl)
  end
  return heroExpRequired
end
ed.loadHeroExpRequirement = loadHeroExpRequirement
local formulaLength = 4
local function loadFormula(id)
  local craft = ed.lookupDataTable("equipcraft", nil, id)
  local formula = {}
  for i = 1, formulaLength do
    local component
    if craft then
      component = craft["Component" .. i]
    else
      component = id
    end
    if component == id then
      return nil
    end
    if component and component ~= 0 then
      table.insert(formula, component)
    end
  end
  return formula
end
local callingLevel = 0
local function debugCrafting(str)
  print(string.rep("  ", callingLevel - 1) .. str)
end
local function enableCallingLevel(func)
  return function(...)
    callingLevel = callingLevel + 1
    local result = func(...)
    callingLevel = callingLevel - 1
    return result
  end
end
local consume = function(pack, id)
  if pack[id] and pack[id] > 0 then
    pack[id] = pack[id] - 1
    return true
  end
  return false
end
local function tryCraft(pack, id)
  if consume(pack, id) then
    return true
  end
  local formula = loadFormula(id)
  if not formula then
    return false
  end
  for _, component in ipairs(formula) do
    if not tryCraft(pack, component) then
      return false
    end
  end
  return true
end
local function isCraftable(id)
  local pack = utils.functions.clone(ed.player.equip_qunty)
  return tryCraft(pack, id)
end
ed.isCraftable = isCraftable
local function isOwned(id)
  return ed.player.equip_qunty[id] and ed.player.equip_qunty[id] > 0
end
ed.isOwned = isOwned
local function getMaterials(cs, mt, id)
  local ect = ed.getDataTable("equipcraft")
  local row = ect[id]
  local components = 0
  components = row and (row.Components or 0)
  for i = 1, components do
    local cid = row["Component" .. i]
    local need = math.max(row[string.format("Component%d Count", i)] or 1, 1)
    if ect[cid] then
      if 0 < (ect[cid].Components or 0) then
        local use = 0
        for k, v in pairs(cs) do
          if k == cid then
            use = v
          end
        end
        if use >= (ed.player.equip_qunty[cid] or 0) then
          getMaterials(cs, mt, cid)
        else
          cs[cid] = (cs[cid] or 0) + need
        end
      end
    else
      mt[cid] = (mt[cid] or 0) + need
    end
  end
end
local function isEquipCraftable(id)
  local ect = ed.getDataTable("equipcraft")
  local row = ect[id]
  local has = 0 < (ed.player.equip_qunty[id] or 0)
  if has then
    return true
  end
  if not row then
    return has
  end
  if (row.Components or 0) < 1 then
    return has
  end
  local consume = {}
  local materials = {}
  getMaterials(consume, materials, id)
  for k, v in pairs(materials) do
    if v > (ed.player.equip_qunty[k] or 0) then
      return false
    end
  end
  return true
end
ed.isEquipCraftable = isEquipCraftable
local function isPropEquipable(id)
  if ed.itemType(id) == "hero" then
    return false
  end
  local equipTable = ed.getDataTable("equip")
  local row = equipTable[id]
  if not row then
    return
  end
  local category = row.Category
  if category ~= T(LSTR("EQUIP.PARTS")) and category ~= T(LSTR("EQUIP.SYNTHETICS")) then
    return
  end
  local heroEquips = ed.getDataTable("hero_equip")
  for k, v in pairs(ed.player.heroes) do
    local hero = v
    local tid = hero._tid
    local rank = hero._rank
    local level = hero._level
    for i = 1, 6 do
      local eid = ed.getDataTable("hero_equip")[tid][rank]["Equip" .. i .. " ID"]
      local erow = ed.getDataTable("equip")[eid]
      if erow then
        local rl = erow["Level Requirement"]
        if ((hero._items or {})[i]._item_id or 0) == 0 and eid == id and level >= rl then
          return true
        end
      end
    end
  end
  return false
end
ed.isPropEquipable = isPropEquipable
local function setKeyBack(node, func)
  local keypadLayer = CCLayer:create()
  keypadLayer:setKeypadEnabled(true)
  
  LegendLog("[tools|setKeyBack] --- registerScriptKeypadHandler setKeyBack tools")
 
  if func then
    keypadLayer:registerScriptKeypadHandler(func)
  else
    keypadLayer:registerScriptKeypadHandler(function(event)
      if event == "backClicked" then
      	LegendLog("[tools|setKeyBack] --- registerScriptKeypadHandler")
        ed.popScene()
      end
    end)
  end
  node:addChild(keypadLayer)
  return keypadLayer
end
ed.setKeyBack = setKeyBack
local function unsetKeyBack()
  ed.gkeypadLayer:unregisterScriptKeypadHandler()
end
ed.unsetKeyBack = unsetKeyBack

local getNodeSize = function(node, bWithMessageRect)
  if nil == node or tolua.isnull(node) then
    return
  end
  if node.getAnchorPoint == nil then
    return
  end
  --LegendLog("getAnchorPoint node is: " .. tolua.type(node) .." dump ".. tostring(node));
  local anchor = node:getAnchorPoint()
  local posX, posY
  local pos = node:getParent():convertToWorldSpace(ccp(node:getPosition()))
  posX = pos.x
  posY = pos.y
  local size
  local messageRect = node:getMessageRect()
  if messageRect.size.width ~= 0 and messageRect.size.height ~= 0 and bWithMessageRect == true then
    size = messageRect.size
    posY = posY + messageRect.origin.y
  else
    size = node:getContentSize()
  end
  local scaleX = node:getScaleX()
  local scaleY = node:getScaleY()
  local w = size.width * scaleX
  local h = size.height * scaleY
  local x = posX + (0 - anchor.x) * w
  local y = posY + (0 - anchor.y) * h
  return CCRectMake(x, y, w, h)
end
ed.getNodeSize = getNodeSize
local function containsPoint(element, ex, ey)
  local rect = getNodeSize(element, true)
  if rect == nil then
    return false
  end
  return rect:containsPoint(ccp(ex, ey))
end
ed.containsPoint = containsPoint
local isPointInRect = function(rect, x, y, element)
  local pos = rect.origin
  local size = rect.size
  if element then
    pos = element:convertToWorldSpace(pos)
    local size = element:getContentSize()
    size = CCSizeMake(size.width * element:getScaleX(), size.height * element:getScaleY())
  end
  rect = CCRectMake(pos.x, pos.y, size.width, size.height)
  return rect:containsPoint(ccp(x, y))
end
ed.isPointInRect = isPointInRect
local function isPointInCircle(centerPos, radius, x, y, element)
  local pos = centerPos
  if element then
    pos = element:convertToWorldSpace(pos)
    local size = element:getContentSize()
    radius = radius * math.min(element:getScaleX(), element:getScaleY())
  end
  local dis = (pos.x - x) * (pos.x - x) + (pos.y - y) * (pos.y - y)
  dis = math.sqrt(dis)
  return radius >= dis
end
ed.isPointInCircle = isPointInCircle
local registerOverloadFunc = function(class, funcName, funcDetail)
  local funcList = funcName .. "Func"
  if not class[funcList] then
    class[funcList] = {}
  end
  table.insert(class[funcList], funcDetail)
end
ed.registerOverloadFunc = registerOverloadFunc
local function setOverloadFunc(class, funcName)
  local funcList = class[funcName .. "Func"]
  class[funcName] = function(...)
    local args_amount = select("#", ...)
    local args = {}
    for i = 1, args_amount do
      local arg = select(i, ...)
      table.insert(args, arg)
    end
    for k, v in pairs(funcList) do
      local isThis = true
      for i = 1, args_amount do
        if args[i] ~= nil then
          if type(v.types[i]) ~= "table" then
            if type(args[i]) ~= v.types[i] then
              isThis = false
              break
            end
          else
            isThis = false
            for k, v in pairs(v.types[i]) do
              if type(args[i]) == v then
                isThis = true
                break
              end
            end
          end
        end
      end
      if isThis then
        return v.func(...)
      end
    end
  end
end
ed.setOverloadFunc = setOverloadFunc
local function getDisplayVertex()
  local winSize = CCDirector:sharedDirector():getWinSize()
  local frameSize = CCEGLView:sharedOpenGLView():getFrameSize()
  local left, right, top, bottom = 0, 800, 480, 0
  local ratio = math.min(frameSize.height, frameSize.width) / math.max(frameSize.height, frameSize.width)
  if ratio >= 0.561875 and ratio <= 0.6699999999999999 then
    if ratio > 0.6 then
      local width = winSize.height / ratio
      left = (winSize.width - width) / 2
      right = width + left
    elseif ratio < 0.6 then
      local height = winSize.width * ratio
      bottom = (winSize.height - height) / 2
      top = height + bottom
    end
  end
  return left, right, top, bottom
end
ed.getDisplayVertex = getDisplayVertex
local isElementInTable = function(element, table)
  if nil == table then
    return false
  end
  for k, v in pairs(table) do
    if element == v then
      return true
    end
  end
  return false
end
ed.isElementInTable = isElementInTable
local function canWearEquip(hid, eid)
  local hlv = ed.player.heroes[hid]._level or 0
  local elv = ed.getDataTable("equip")[eid]["Level Requirement"] or 0
  return hlv >= elv, hlv, elv
end
ed.canWearEquip = canWearEquip
local removeElementFromTable = function(t, element)
  for k, v in pairs(t or {}) do
    if v == element then
      table.remove(t, k)
    end
  end
end
ed.removeElementFromTable = removeElementFromTable
local orderHeroFunction = function(list)
  if nil == list then
    return
  end
  local function up(j)
    if j < 2 then
      return
    end
    local temp = list[j]
    list[j] = list[j - 1]
    list[j - 1] = temp
  end
  for i = 2, #list do
    for j = i, 2, -1 do
      local h = list[j]
      local ph = list[j - 1]
      if h._level > ph._level then
        up(j)
      elseif h._level == ph._level then
        if h._stars > ph._stars then
          up(j)
        elseif h._stars == ph._stars and h._rank > ph._rank then
          up(j)
        end
      end
    end
  end
  return list
end
ed.orderHeroFunction = orderHeroFunction
local function orderHeroes()
  local heroes = ed.player.heroes
  local list = {}
  for k, v in pairs(heroes or {}) do
    table.insert(list, v)
  end
  return orderHeroFunction(list)
end
ed.orderHeroes = orderHeroes
local function equipLvFromExp(id, exp)
  local rank = ed.lookupDataTable("equip", "Quality", id)
  for i = 1, 5 do
    local price = ed.lookupDataTable("enhancement", "Price " .. i, rank)
    exp = exp - price
    if price == 0 or exp < 0 then
      return i - 1
    end
  end
  return 5
end
ed.equipLvFromExp = equipLvFromExp
local function equipExpFromLv(id, lv)
  local rank = ed.lookupDataTable("equip", "Quality", id)
  local exp = 0
  for i = 1, lv do
    local price = ed.lookupDataTable("enhancement", "Price " .. i, rank)
    exp = exp + price
  end
  return exp
end
ed.equipExpFromLv = equipExpFromLv
local swapSizewh = function(size)
  local w, h = size.width, size.height
  return CCSizeMake(h, w)
end
ed.swapSizewh = swapSizewh
local sizeAdd = function(s1, s2)
  local w1, h1 = s1.width, s1.height
  local w2, h2 = s2.width, s2.height
  return CCSizeMake(w1 + w2, h1 + h2)
end
ed.sizeAdd = sizeAdd
local select = select
local function pack(...)
  local n = select("#", ...)
  local t = {}
  for i = 1, n do
    t[i] = select(i, ...)
  end
  return t
end
ed.pack = pack
function ed.gggggm()
  require("gmtools/gm")
  ed.pushScene(ed.ui.gm.create())
end
if EDFLAGWIN32 then
  ed.gm = ed.gggggm
end
local function getJson(t, isCheckArray)
  local checkArrayct = function(tt)
    for k, v in pairs(tt) do
      if type(k) ~= "number" then
        return false
      elseif k < 1 then
        return false
      elseif k > 1 and tt[k - 1] == nil then
        return false
      end
    end
    return true
  end
  local formatValue = function(str)
    str = string.gsub(str, "\"", "<quotation>")
    str = string.gsub(str, "\\", "<slash>")
    return str
  end
  t = t or {}
  local js = ""
  local isCTT
  if isCheckArray then
    isCTT = checkArrayct(t)
    if isCTT then
      js = "["
    end
  end
  if not isCTT then
    js = "{"
  end
  local index = 0
  for k, v in pairs(t) do
    if index > 0 then
      js = js .. ","
    end
    if type(v) == "table" then
      local cjs = getJson(v, true)
      if isCTT then
        js = js .. cjs
      else
        js = js .. "\"" .. k .. "\"" .. ":" .. cjs
      end
    else
      if not isCTT then
        js = js .. "\"" .. k .. "\"" .. ":"
      end
      if ed.isElementInTable(type(v), {"number", "boolean"}) then
        js = js .. v
      else
        js = js .. "\"" .. formatValue(v) .. "\""
      end
    end
    index = index + 1
  end
  if isCTT then
    js = js .. "]"
  else
    js = js .. "}"
  end
  return js
end
ed.getJson = getJson
local getMailPoint = function(data, name)
  for k, v in pairs(data._points or {}) do
    if v._type == name then
      return v._value
    end
  end
  return 0
end
ed.getMailPoint = getMailPoint
local function analyzeItem(item)
  local id = ed.bits(item, 0, 10)
  local amount = ed.bits(item, 10, 11)
  return {id = id, amount = amount}
end
ed.analyzeItem = analyzeItem
local function packItem(id, amount)
  return ed.makebits(11, amount, 10, id)
end
ed.packItem = packItem
local function copyTable(t)
  local tar = {}
  if t then
    for k, v in pairs(t) do
      local vt = type(v)
      if vt == "table" then
        tar[k] = copyTable(v)
      else
        tar[k] = v
      end
    end
  end
  return tar
end
ed.copyTable = copyTable
local function copyProto(t)
  local function protoTrans(pt)
    if type(pt) == "table" then
      if pt[".data"] then
        pt = pt[".data"]
      end
      for k, v in pairs(pt) do
        pt[k] = protoTrans(v)
      end
    end
    return pt
  end
  local tar = ed.copyTable(t)
  tar = protoTrans(tar)
  return tar
end
ed.copyProto = copyProto
local function heroLevel2Rank(level)
  level = level or 1
  local l = math.max(1, level)
  local r = math.ceil(l / 10)
  return math.min(r, 10)
end
ed.heroLevel2Rank = heroLevel2Rank
local openAppStore = function()
  if true then return; end --Todo
  if LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_IOS then
    local addr = "itms-apps://itunes.apple.com/app/League-Of-Champions/xxx"
    if LegendFLAG_ALPHAVERSION then
        addr = "http://www.we4dota.com/ios/we4dota.html"
    end
    LegendOpenURL(addr)
  elseif LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_ANDROID then
   local addr = "https://play.google.com/store/apps/details?id=com.league.we4dota"
   if LegendFLAG_ALPHAVERSION then
        addr = "http://www.we4dota.com/android/we4dota.html"
   end
   LegendOpenURL(addr)
  end
end
ed.openAppStore = openAppStore
function ed.printTable(t, index, tableCache)
  index = index or 1
  t = t or {}
  tableCache = tableCache or {}
  local pre = ""
  for i = 1, index - 1 do
    pre = pre .. "\t"
  end
  print(pre .. "{")
  for k, v in pairs(t) do
    if type(v) == "table" then
      if ed.isElementInTable(v, tableCache) then
        print(pre .. "\t" .. k .. " = " .. "tableCache")
      else
        print(pre .. "\t" .. k .. " = ")
        table.insert(tableCache, v)
        ed.printTable(v, index + 1, tableCache)
      end
    else
      local str = pre .. "\t"
      str = str .. k .. " = " .. tostring(v)
      print(str)
    end
  end
  print(pre .. "}")
end
function ed.writeTable(input)
  local file = io.open("logtt.txt", "w")
  local function doWrite(t, index, tableCache)
    index = index or 1
    t = t or {}
    tableCache = tableCache or {}
    local pre = ""
    for i = 1, index - 1 do
      pre = pre .. "\t"
    end
    file:write(pre .. "{")
    file:write("\n")
    for k, v in pairs(t) do
      if type(v) == "table" then
        if ed.isElementInTable(v, tableCache) then
          file:write(pre .. "\t" .. k .. " = " .. "tableCache")
          file:write("\n")
        else
          file:write(pre .. "\t" .. k .. " = ")
          file:write("\n")
          table.insert(tableCache, v)
          doWrite(v, index + 1, tableCache)
        end
      else
        local str = pre .. "\t"
        str = str .. k .. " = " .. tostring(v)
        file:write(str)
        file:write("\n")
      end
    end
    file:write(pre .. "}")
    file:write("\n")
  end
  doWrite(input)
  file:close()
end
local function formatText(text)
  local checkChinese = function(text)
    text = tostring(text)
    for i = 1, #text do
      local t = string.byte(string.sub(text, i, i))
      if t > 127 then
        return true
      end
    end
    return false
  end
  if EDLanguage == "chinese" then
    if LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_ANDROID and LegendSDKType == 104 then
      local tt = ed.texttransform.s360[text]
      if tt then
        return tt
      end
    end
    return text
  end
  if not checkChinese(text) then
    return text
  end
  return text
end
ed.formatText = formatText
local function formatString(text, ...)
  text = ed.formatText(text)
  local argAmount = select("#", ...)
  if argAmount == 0 then
    return text
  else
    return string.format(text, ...)
  end
end
ed.formatString = formatString

function PushTableValue(...)
  local amount = select("#", ...)
  if amount < 2 then
    print("invalid length of args.")
    return
  end
  local value = select(amount, ...)
  local t = _G
  for i = 1, amount - 1 do
    local key = select(i, ...)
    key = tostring(key)
    if i == amount - 1 then
      t[key] = value
    else
      t[key] = t[key] or {}
    end
    t = t[key]
  end
end

local function initSeed()
  math.randomseed(ed.getMillionTime())
  math.random()
  math.random()
  math.random()
end
ed.initSeed = initSeed

function T(text, ...)
  return ed.formatString(text, ...)
end

--- @brief 调试时打印变量的值
--- @param data 要打印的字符串
--- @param [max_level] table要展开打印的计数，默认nil表示全部展开
--- @param [prefix] 用于在递归时传递缩进，该参数不供用户使用于
--- @ref http://dearymz.blog.163.com/blog/static/205657420089251655186/
function var_dump(data, max_level)

    local str="";

    if type(data) ~= "table" then
       str = str..tostring(data)
    else
        str = str..tostring(data).."\n"
        if max_level ~= 0 then
          -- local prefix_next = prefix .. "    "
            str = str.. "{"
            for k,v in pairs(data) do
                str = str .. tostring(k) .. " = "
                if type(v) ~= "table" or (type(max_level) == "number" and max_level <= 1) then
                    str = str..tostring(v)
                else
                    if max_level == nil then
                        str = str..var_dump(v, nil)
                    else
                        str = str.. var_dump(v, max_level - 1)
                    end
                end
                str = str .."\n"
            end
            str = str .. "} \n"
        end
    end
    return str;
end

function vd(data, max_level)
    return var_dump(data, max_level or 5)
end


function print_bytes(bytes)
  local result = ""
  for b in string.gfind(bytes, ".") do
    result = result .. string.format("%02X ", string.byte(b))
  end
  return result
end

function print_Log(log,filename)
  if not filename then
    filename = "logfile.txt"
  end
  folder = CCFileUtils:sharedFileUtils():getWritablePath()
  local logf = io.open(folder.."/"..filename,"w")
  --if logf then
    --logf = io.open(folder.."/logfile.txt","w")
  --end
  if logf then
    logf:write(log)
    logf:write("\n")
    logf:flush()
    logf:close()
  end
  
end

function typeStringToBuffer(bytestring)
  local buffer = ""
  local i = 0
  while true do
      i = string.find(bytestring, "0x", i+1)  -- 查找下一行
      if i == nil then break end
      local c = string.sub(bytestring, i, i+4)
      buffer =buffer..string.char(c)
  end
  return buffer
end

function bytes_to_int(str,endian,signed) -- use length of string to determine 8,16,32,64 bits
    local t={str:byte(1,-1)}
    if endian=="big" then --reverse bytes
        local tt={}
        for k=1,#t do
            tt[#t-k+1]=t[k]
        end
        t=tt
    end
    local n=0
    for k=1,#t do
        n=n+t[k]*2^((k-1)*8)
    end
    if signed then
        n = (n > 2^(#t-1) -1) and (n - 2^#t) or n -- if last bit set, negative.
    end
    return n
end
--add by xinghui
function sendDotInfoToServer(dot_id)
    local msg = ed.upmsg.dot_info()
    msg._dot_id = dot_id or 1000
    ed.send(msg, "dot_info")
    ed.tutorial.isShowTutorial = false
end
ed.sendDotInfoToServer = sendDotInfoToServer
--
function int_to_bytes(num,endian,signed)
    if num<0 and not signed then num=-num print"warning, dropping sign from number converting to unsigned" end
    local res={}
    local n = 4 -- math.ceil(select(2,math.frexp(num))/8) -- number of bytes to be used.
    if signed and num < 0 then
        num = num + 2^n
    end
    for k=n,1,-1 do -- 256 = 2^8 bits per char.
        local mul=2^(8*(k-1))
        res[k]=math.floor(num/mul)
        num=num-res[k]*mul
    end
    assert(num==0)
    if endian == "big" then
        local t={}
        for k=1,n do
            t[k]=res[n-k+1]
        end
        res=t
    end
    local result =""
    for i,v in ipairs(res) do
      result = result..string.char(v)
    end
    return result
    --return string.char(unpack(res))
end
local function initSeed()
  math.randomseed(ed.getMillionTime())
  math.random()
  math.random()
  math.random()
end
ed.initSeed = initSeed
--分割字符串的函数
--[[ add by zhangyicheng
	用法:
	local list = SplitEx("abc,123,345", ",")
	然后list里面就是
	abc
	123
	345
	了。第二个参数可以是多个字符，但是不能是Lua正则表达式。例如. ，或者 %w 之类的。
	增强版等以后再放出来吧，这个应该大部分够用了。
--]]
function SplitEx(szFullString, szSeparator)
	local nFindStartIndex = 1
	local nSplitIndex = 1
	local nSplitArray = {}
	while true do
	   local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)
		local value = string.sub(szFullString, nFindStartIndex, string.len(szFullString))
	   if not nFindLastIndex then
		if value~=nil and value~="" then
			nSplitArray[nSplitIndex] = value
		end
		break
	   end
	   nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
	   nFindStartIndex = nFindLastIndex + string.len(szSeparator)
	   nSplitIndex = nSplitIndex + 1
	end
	return nSplitArray
end
