local _tostring = tostring
local _print = print
function tostring(o, limit)
  if limit and limit < 0 then
    return ""
  end
  if type(o) == "userdata" then
    local mt = getmetatable(o)
    if mt then
      if mt == CCPoint then
        return "ccp(" .. o.x .. ", " .. o.y .. ")"
      elseif mt == ccColor3B then
        return "ccc3(" .. o.r .. ", " .. o.g .. ", " .. o.b .. ")"
      elseif mt == ccColor4B then
        return "ccc4(" .. o.r .. ", " .. o.g .. ", " .. o.b .. ", " .. o.a .. ")"
      elseif mt == CCSize then
        return "size(" .. o.width .. ", " .. o.height .. ")"
      elseif mt == CCRect then
        return "[" .. tostring(o.origin) .. ", " .. tostring(o.size) .. "]"
      end
    end
  elseif type(o) == "table" then
    local mt = getmetatable(o)
    if not mt or not mt.__tostring then
      local s = ""
      if not limit then
        s = _tostring(o)
        limit = 40
      end
      s = s .. "["
      for k, v in pairs(o) do
        local sk = tostring(k, limit)
        limit = limit - string.len(sk) - 1
        local sv = tostring(v, limit)
        limit = limit - string.len(sv) - 1
        s = s .. sk .. "=" .. sv .. ","
        if limit < 0 then
          break
        end
      end
      if limit < 0 then
        s = string.sub(s, 1, limit - 1) .. "..."
      end
      s = s .. "]"
      return s
    end
  end
  return _tostring(o)
end
function p(o, raw)
  if type(o) == "table" then
    local mt = getmetatable(o)
    if not raw and (mt or mt == nil) and o.__p then
      o:__p()
      return
    end
    local fields = {}
    for k, v in pairs(o) do
      local what = type(v)
      table.insert(fields, {
        what,
        k,
        v
      })
    end
    table.sort(fields, function(a, b)
      local ta = type(a[2])
      local tb = type(b[2])
      if ta ~= tb then
        return ta < tb
      elseif ta == "table" then
        return tostring(a[2]) < tostring(b[2])
      else
        return a[2] < b[2]
      end
    end)
    for i, v in ipairs(fields) do
      print("\t", v[1], v[2], "\t", v[3])
    end
  else
    print(o)
  end
end
pp = p
function praw(o)
  p(o, true)
end
local descFrame = function(info)
  local funcname = info.name or "?"
  local short_src = info.short_src or "nil"
  local linedefined = info.linedefined or -1
  local currentline = info.currentline or -1
  if funcname ~= "?" then
    funcname = "'" .. funcname .. "'"
  else
    funcname = string.format("<%s:%i>", short_src, linedefined)
  end
  return string.format("%s:%i: in function %s", short_src, currentline, funcname)
end
function l(level)
  level = level or 0
  level = level + 5
  local info = debug.getinfo(level)
  print(descFrame(info))
  print("local values:")
  local i = 1
  local n, v
  repeat
    n, v = debug.getlocal(level, i)
    if n then
      _G[n] = v
      xpcall(function()
        print("\t", n, "\t", v)
      end, function(msg)
        print(msg)
      end)
    end
    i = i + 1
  until n == nil
  print("up values:")
  local i = 1
  local n, v
  repeat
    n, v = debug.getupvalue(info.func, i)
    if n then
      _G[n] = v
      xpcall(function()
        print("\t", n, "\t", v)
      end, function(msg)
        print(msg)
      end)
    end
    i = i + 1
  until n == nil
end
enable_dump = false
if LegendPlatformFLAG==ed.PlatformCode.CC_PLATFORM_IOS then
	enable_dump=true
end
function EDDebug(msg)
  print = _print
  if enable_dump then
    if senddumpfile then
      local text = _tostring(msg) .. "\n" .. debug.traceback()
      senddumpfile(text)
    end
    enable_dump = false
  end
  local p = LegendLog and LegendLog or print
  if ed.debug_mode and not EDFLAGWIN32 and not EDFLAGSVR then
    do
      local _p = p
      function p(msg)
        _p(msg)
        debugError.showError(msg)
      end
    end
  end
  p("[EDDebug.lua|EDDebug]--------------------start--------------------edebug")
  if msg then
    p("LUA ERROR: " .. tostring(msg))
  end
  local i = 2
  local info = debug.getinfo(i)
  p("Stack traceback:")
  repeat
    p(string.format("[%i]\t%s", i - 2, descFrame(info)))
    i = i + 1
    info = debug.getinfo(i)
  until not info
  p("[EDDebug.lua|EDDebug]--------------------end--------------------edebug")
  if EDFLAGWIN32 then
    EDConsoleEnable(0)
    debug.debug()
    EDConsoleEnable(1)
  elseif EDFLAGSVR then
    debug.debug()
  end
end
