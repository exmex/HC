local pattern =  "[%z\1-\194-\244][\128-\191]*"
local posrelat = function(pos, len)
  if pos < 0 then
    pos = len + pos + 1
  end
  return pos
end
utf8 = {}
function utf8.map(s, f, no_subs)
  local i = 0
  if no_subs then
    for b, e in s:gmatch("()" .. pattern .. "()") do
      i = i + 1
      local c = e - b
      f(i, c, b)
    end
  else
    for b, c in s:gmatch("()(" .. pattern .. ")") do
      i = i + 1
      f(i, c, b)
    end
  end
end
function utf8.chars(s, no_subs)
  return coroutine.wrap(function()
    return utf8.map(s, coroutine.yield, no_subs)
  end)
end
function utf8.len(s)
  return select(2, s:gsub("[^\128-\193]", ""))
end
function utf8.replace(s, map, ascii_too)
  return s:gsub(pattern, map)
end
function utf8.reverse(s)
  s = s:gsub(pattern, function(c)
    return #c > 1 and c:reverse()
  end)
  return s:reverse()
end
function utf8.strip(s)
  return s:gsub(pattern, function(c)
    return #c > 1 and ""
  end)
end
function utf8.sub(s, i, j)
  local l = utf8.len(s)
  i = posrelat(i, l)
  j = j and posrelat(j, l) or l
  if i < 1 then
    i = 1
  end
  if l < j then
    j = l
  end
  if i > j then
    return ""
  end
  local diff = j - i
  local iter = utf8.chars(s, true)
  for _ = 1, i - 1 do
    iter()
  end
  local c, b = select(2, iter())
  if diff == 0 then
    return string.sub(s, b, b + c - 1)
  end
  i = b
  for _ = 1, diff - 1 do
    iter()
  end
  c, b = select(2, iter())
  return string.sub(s, i, b + c - 1)
end
return utf8
