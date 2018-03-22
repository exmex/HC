local class = newclass({__index = _G})
ed.stringutil = class
setfenv(1, class)
function sub(str, begin, last)
  local charArray = toCharArray(str)
  begin = math.max(math.min(begin, #charArray), 1)
  last = math.min(math.max(1, last), #charArray)
  local res = ""
  for i = begin, last do
    res = res .. charArray[i]
  end
  return res
end
function len(str)
  if not str then
    return 0
  end
  local array = toCharArray(str)
  return #array
end
function toCharArray(str)
  local array = {}
  local index = 1
  while index <= #str do
    local char = string.sub(str, index, index)
    if string.byte(char) > 127 then
      table.insert(array, string.sub(str, index, index + 2))
      index = index + 3
    else
      table.insert(array, string.sub(str, index, index))
      index = index + 1
    end
  end
  return array
end
function charArray2String(array)
   local str
  for i, v in ipairs(array) do
	    str = str or ""
    str = str .. v
  end
  return str
end
function splitCharArray(array, amount)
  local array_1, array_2 = {}, {}
  for i, v in ipairs(array) do
    if i <= amount then
      table.insert(array_1, v)
    else
      table.insert(array_2, v)
    end
  end
  return array_1, array_2
end
function splitString(str, amount)
  local array = toCharArray(str)
  local a1, a2 = splitCharArray(array, amount)
  return charArray2String(a1), charArray2String(a2)
end
function checkChinese(str)
  for i = 1, #str do
    local char = string.sub(str, i, i)
    if string.byte(char) > 127 then
      return true
    end
  end
  return false
end
function getTextureLen(str, fontSize)
  if not str then
    return 0
  end
  local array = toCharArray(str)
  local len = 0
  for i, v in ipairs(array) do
    if checkChinese(v) then
      len = len + fontSize
    else
      len = len + fontSize * 0.507
    end
  end
  return len
end
function getSplitPoint(str, fontSize, widthLimit)
  local array = toCharArray(str)
  if widthLimit < getTextureLen(splitString(str, 1), fontSize) then
    return 0
  end
  if widthLimit > getTextureLen(str, fontSize) then
    return #array
  end
  for i = 1, #array - 1 do
    local dx_p = getTextureLen(splitString(str, i), fontSize) - widthLimit
    local dx_n = getTextureLen(splitString(str, i + 1), fontSize) - widthLimit
    if dx_p <= 0 and dx_n > 0 then
      return math.abs(dx_p) > math.abs(dx_n) and i + 1 or i
    end
  end
  return 0
end
