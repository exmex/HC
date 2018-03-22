local widget = ed.widget
local base = widget.base
local class = newclass(base.mt)
widget.complexlabel = class
local checkValid = function(text)
  if not text then
    return false
  end
  if string.match(text, "<icon:.*>") then
    return true
  end
  if string.match(text, "<label:*>") then
    return true
  end
  return false
end
class.checkValid = checkValid
ed.isComplexText = checkValid
local splitText = function(text)
  local list = {}
  for str in string.gmatch(text, "[^<>]*") do
    if str ~= "" then
      table.insert(list, str)
    end
  end
  text = string.gsub(text, "<", "@leftbracket")
  text = string.gsub(text, ">", "@rightbracket")
  for i, v in ipairs(list) do
    text = string.gsub(text, string.format("@leftbracket%s@rightbracket", v), string.format("<%s>", v))
  end
  local list = {}
  for str in string.gmatch(text, "[^<>]*") do
    if str ~= "" then
      str = string.gsub(str, "@leftbracket", "<")
      str = string.gsub(str, "@rightbracket", ">")
      if string.match(text, string.format("<%s>", str)) then
        table.insert(list, string.format("<%s>", str))
      else
        table.insert(list, str)
      end
    end
  end
  return list
end
class.splitText = splitText
local function getNode(str, param)
  local t, res, node
  if class.checkValid(str) then
    if string.match(str, "<label:.*>") then
      t = "label"
    elseif string.match(str, "<icon:.*>") then
      t = "sprite"
      local name = string.match(str, "<icon:(.*)>")
      if name == "stone" then
        res = "UI/alpha/HVGA/equip_soulstone_tag.png"
      elseif name == "fragment" then
        res = "UI/alpha/HVGA/fragment_tag.png"
      elseif name == "scroll" then
        res = "UI/alpha/HVGA/equip_scroll_tag.png"
      elseif name == "diamond" then
        res = "UI/alpha/HVGA/shop_token_icon.png"
      end
      node = ed.createSprite(res)
      ed.fixNodeSize(node, CCSizeMake(param.size, param.size))
    end
  else
    t = "label"
    node = ed.createttf(str, param.size, param.font)
  end
  return {t = t, node = node}
end
class.getNode = getNode
local function analize(param)
  local text = param.text
  local size = param.size
  local font = param.font
  if not class.checkValid(text) then
    return nil
  end
  local list = class.splitText(text)
  local ui = {}
  local ui_param = {}
  for i, v in ipairs(list) do
    local item = class.getNode(v, param)
    table.insert(ui, item)
    table.insert(ui_param, {
      t = "CCNode",
      base = {
        node = item.node
      }
    })
    table.insert(ui, item)
  end
  local node = ed.readnode.getFeralNode({
    t = "HorizontalNode",
    ui = ui_param
  })
  return node, ui
end
class.analize = analize
local function create(param)
  local self = base.create("complexlabel")
  setmetatable(self, class.mt)
  self.param = param
  param.size = param.size or 20
  param.shadow = param.shadow or {}
  param.stroke = param.stroke or {}
  self.node, self.ui = class.analize(param)
  if not self.node then
    return nil
  end
  self:setColor(param.color)
  self:setShadow(param.shadow.color, param.shadow.offset)
  self:setStroke(param.stroke.color, param.stroke.size)
  return self
end
class.create = create
local function setString(self, text)
  local param = self.param
  param.text = text
  local node = self.node
  self.node, self.ui = class.analize(param)
  ed.replaceNode(node, self.node)
end
class.setString = setString
local setShadow = function(self, color, offset)
  if not color then
    return
  end
  for k, v in pairs(self.ui) do
    if v.t == "label" then
      ed.setLabelShadow(v, color, offset)
    end
  end
end
class.setShadow = setShadow
local setStroke = function(self, color, size)
  if not color then
    return
  end
  for k, v in pairs(self.ui) do
    if v.t == "label" then
      ed.selfetLabelStroke(v, color, size)
    end
  end
end
class.setStroke = setStroke
local setDimensions = function(self, dimensions)
end
class.setDimensions = setDimensions
local setColor = function(self, color)
  if not color then
    return
  end
  for k, v in pairs(self.ui) do
    if v.t == "label" then
      ed.setLabelColor(v.node, color)
    end
  end
end
class.setColor = setColor
local getString = function(self)
  return self.param.text
end
class.getString = getString
