local getTime = function()
  local year, month, day, hour, minute, second, time, million = LegendTime()
  return {
    year = year,
    month = month,
    day = day,
    hour = hour,
    minute = minute,
    second = second,
    time = time,
    million = million
  }
end
ed.getTime = getTime
local systemTime2hms = function()
  local time = ed.getTime()
  return string.format("%02d:%02d:%02d", time.hour, time.minute, time.second)
end
ed.systemTime2hms = systemTime2hms
local getSystemTime = function()
  local time = ed.getTime()
  return time.time
end
ed.getSystemTime = getSystemTime
local getMillionTime = function()
  local time = ed.getTime()
  return time.million
end
ed.getMillionTime = getMillionTime
local getServerTime = function()
  local diff = ed.player.time_diff
  local time = ed.getSystemTime() + diff
  return time, ed.time2YMD(time)
end
ed.getServerTime = getServerTime
local serverTime2HMS = function()
  local h, m, s = ed.time2HMS()
  return string.format("%02d:%02d:%02d", h, m, s)
end
ed.serverTime2HMS = serverTime2HMS
local getTodayOriginTime = function()
  local st = ed.getServerTime()
  local h, m, s = ed.time2HMS()
  return st - (3600 * h + 60 * m + s)
end
ed.getTodayOriginTime = getTodayOriginTime
local getTimeByTodayHMS = function(t)
  local ot = ed.getTodayOriginTime()
  local h, m, s = 0, 0, 0
  if type(t) == "table" then
    h, m, s = t.h, t.m, t.s
  elseif type(t) == "string" then
    h, m, s = ed.hmsNString2HMS(t)
  end
  return ot + (3600 * h + 60 * m + s)
end
ed.getTimeByTodayHMS = getTimeByTodayHMS
local hmsNString2HMS = function(s)
  local t = {}
  for k in string.gfind(s, "%d+") do
    table.insert(t, k)
  end
  local h = tonumber(t[1]) or 0
  local m = tonumber(t[2]) or 0
  local s = tonumber(t[3]) or 0
  return h, m, s
end
ed.hmsNString2HMS = hmsNString2HMS
local getLocalDate = function(time)
  local date = os.date("*t", os.time())
  return date
end
ed.getLocalDate = getLocalDate
local getUTCDate = function(time)
  local date = os.date("!*t", os.time())
  return date
end
ed.getUTCDate = getUTCDate

local getEightZoneDiff = function()
  local timeDiff = ed.serverTimeZone or 0
  return timeDiff
end
ed.getEightZoneDiff = getEightZoneDiff
local getCurrentZoneDiff = function()
  local utcdate = ed.getUTCDate()
  local localdate = ed.getLocalDate()
  local localtime = os.time(localdate)
  local utctime = os.time(utcdate)
  local diff = localtime - utctime
  if localdate.isdst then
    diff = diff + 3600
  end
  return diff
end
ed.getCurrentZoneDiff = getCurrentZoneDiff
local getDiff2China = function()
  local nowDiff = ed.getCurrentZoneDiff()
  local chinaDiff = ed.getEightZoneDiff()
  local diff = chinaDiff - nowDiff
  return diff
  --return 0
end
ed.getDiff2China = getDiff2China
local serverTime2China = function()
  local diff = ed.getDiff2China()
  return ed.getServerTime() + diff
end
ed.serverTime2China = serverTime2China
local time2China = function(time)
  time = time or ed.getServerTime()
  local diff = ed.getDiff2China()
  return time + diff
end
ed.time2China = time2China
local time2YMDHMS = function(time)
  time = time or ed.serverTime2China()
  return os.date("%Y", time), os.date("%m", time), os.date("%d", time), os.date("%H", time), os.date("%M", time), os.date("%S", time)
end
ed.time2YMDHMS = time2YMDHMS
local function time2YMD(time)
  local y, m, d, h, min, sec = time2YMDHMS(time)
  return y, m, d
end
ed.time2YMD = time2YMD
local function time2HMS(time)
  local y, m, d, h, min, sec = time2YMDHMS(time)
  return h, min, sec
end
ed.time2HMS = time2HMS
local getWeekdayIndex = function()
  local index = {
    Monday = 1,
    Tuesday = 2,
    Wednesday = 3,
    Thursday = 4,
    Friday = 5,
    Saturday = 6,
    Sunday = 7
  }
  local name = ed.getWeekdayName()
  return index[name]
end
ed.getWeekdayIndex = getWeekdayIndex
local getWeekdayName = function()
  local time = ed.serverTime2China()
  return os.date("%A", time)
end
ed.getWeekdayName = getWeekdayName
local getNextWeekdayName = function()
  local time = ed.serverTime2China() + 86400
  return os.date("%A", time)
end
ed.getNextWeekdayName = getNextWeekdayName
local getPreWeekdayName = function()
  local time = ed.serverTime2China() - 86400
  return os.date("%A", time)
end
ed.getPreWeekdayName = getPreWeekdayName
local getMDYTime = function(time)
  time = time or ed.serverTime2China()
  local y, mon, d, h, m, s = ed.time2YMDHMS(time)
  return string.format("%d-%d-%d", mon, d, y)
end
ed.getMDYTime = getMDYTime
local getYMDTime = function(time)
  time = time or ed.serverTime2China()
  local y, mon, d, h, m, s = ed.time2YMDHMS(time)
  return string.format("%d-%d-%d", y, mon, d)
end
ed.getYMDTime = getYMDTime
local second2hms = function(second)
  local h, m, s = 0, 0, 0
  h = math.floor(second / 3600)
  m = math.floor(second % 3600 / 60)
  s = second % 3600 % 60
  return h, m, s
end
ed.second2hms = second2hms
local getYMDHMS = function(time)
  time = time or ed.serverTime2China()
  local y, mon, d, h, m, s = ed.time2YMDHMS(time)
  local t = {
    year = y,
    month = mon,
    day = d,
    hour = h,
    minute = m,
    second = s
  }
  return t
end
ed.getYMDHMS = getYMDHMS
local getYMDHMSTime = function(time)
  time = time or ed.getYMDHMS()
  return string.format("%d-%d-%d %d:%d:%d", time.year, time.month, time.day, time.hour, time.minute, time.second)
end
ed.getYMDHMSTime = getYMDHMSTime
local getCurrentHMS = function()
  local time = ed.serverTime2China()
  local h, m, s = os.date("%H", time), os.date("%M", time), os.date("%S", time)
  return h, m, s
end
ed.getCurrentHMS = getCurrentHMS
local hms2Second = function(h, m, s)
  return 3600 * h + 60 * m + s
end
ed.hms2Second = hms2Second
local isTimeAfter = function(front)
  local now = ed.hms2Second(ed.getCurrentHMS())
  return front < now
end
ed.isTimeAfter = isTimeAfter
local isTimeBefore = function(after)
  local now = ed.hms2Second(ed.getCurrentHMS())
  return after > now
end
ed.isTimeBefore = isTimeBefore
local function isTimeBetween(front, back)
  return isTimeAfter(front) and isTimeBefore(back)
end
ed.isTimeBetween = isTimeBetween
local getdhmsCString = function(second)
  local h, m, s = ed.second2hms(second)
  local d = math.floor(h / 24)
  local h = h % 24
  local time = ""
  if d > 0 then
    time = time .. d .. T(LSTR("TIME.DAY"))
  end
  if h > 0 then
    time = time .. h .. T(LSTR("TIME.HOUR"))
  end
  if m > 0 then
    time = time .. m .. T(LSTR("TIME.MINUTE"))
  end
  if time == "" then
    time = time .. s .. T(LSTR("TIME.SECOND"))
  end
  return time
end
ed.getdhmsCString = getdhmsCString
--add by xinghui
local getdhmsCString2 = function(second)
  local h, m, s = ed.second2hms(second)
  local d = math.floor(h / 24)
  local h = h % 24
  local time = ""
  if d > 0 then
    time = time .. d .. T(LSTR("TIME.DAY")) .. " "
  end
  if h > 0 then
    time = time .. h .. ":"
  end
  if m > 0 then
    time = time .. m .. ":"
  end
  if s > 0 then
    time = time .. s
  end
  return time
end
ed.getdhmsCString2 = getdhmsCString2

local getDateByStr = function(dateStr)--"20141216"
    local year = string.sub(dateStr, 1, 4)
    local month = string.sub(dateStr, 5, 6)
    local day = string.sub(dateStr, 7, 8)

    return year, month, day
end
ed.getDateByStr = getDateByStr
--
local gethmsCString = function(second)
  local h, m, s = ed.second2hms(second)
  local time = ""
  if h > 0 then
    time = time .. h .. T(LSTR("TIME.HOUR"))
  end
  if h > 0 or m > 0 then
    time = time .. m .. T(LSTR("TIME.MINUTE"))
  end
  if h <= 0 then
    time = time .. s .. T(LSTR("TIME.SECOND"))
  end
  return time
end
ed.gethmsCString = gethmsCString
local gethmsNString = function(second)
  local h, m, s = ed.second2hms(second)
  return string.format("%02d:%02d:%02d", h, m, s)
end
ed.gethmsNString = gethmsNString
local getmsNString = function(second)
  local h, m, s = ed.second2hms(second)
  return string.format("%02d:%02d", m, s)
end
ed.getmsNString = getmsNString
local reset_time = {h = 5, m = 0}
local checkTwoDateom = function(lt, nt)
  lt = ed.time2China(lt)
  nt = ed.time2China(nt)
  local d1 = ed.getYMDHMS(lt)
  local y1 = tonumber(d1.year)
  local m1 = tonumber(d1.month)
  local d2 = ed.getYMDHMS(nt)
  local y2 = tonumber(d2.year)
  local m2 = tonumber(d2.month)
  local t = math.max(lt, nt)
  local d = ed.getYMDHMS(t)
  local day = tonumber(d.day)
  if day == 1 and ed.checkTwoDateod(lt, nt) then
    return true
  end
end
ed.checkTwoDateom = checkTwoDateom
local function checkTodayom()
  local nt = ed.getServerTime()
  local lt = nt - 86400
  return checkTwoDateom(lt, nt)
end
ed.checkTodayom = checkTodayom
local function checkTwoDateod(lt, nt)
  local record = ed.record
  record.lastResetTime = record.lastResetTime or ed.player._last_login
  local lt = lt or record.lastResetTime
  local nt = nt or ed.getServerTime()
  lt = ed.time2China(lt)
  nt = ed.time2China(nt)
  if math.abs(nt - lt) > 86400 then
    return true
  end
  local rt = reset_time
  local y, m, d, h, mi, s = ed.time2YMDHMS(lt)
  local ltt = {
    y = tonumber(y),
    mon = tonumber(m),
    d = tonumber(d),
    h = tonumber(h),
    m = tonumber(mi),
    s = tonumber(s),
    t = lt
  }
  y, m, d, h, mi, s = ed.time2YMDHMS(nt)
  local ntt = {
    y = tonumber(y),
    mon = tonumber(m),
    d = tonumber(d),
    h = tonumber(h),
    m = tonumber(mi),
    s = tonumber(s),
    t = nt
  }
  local nttboa = ed.checkBOA(ntt)
  local lttboa = ed.checkBOA(ltt)
  if ltt.d == ntt.d then
    if nttboa ~= lttboa then
      return true
    end
  elseif nttboa == lttboa then
    return true
  end
  return false
end
ed.checkTwoDateod = checkTwoDateod
local function checkBOA(t, refer)
  local rt = refer or reset_time
  local h, m
  if t then
    h = tonumber(t.h)
    m = tonumber(t.m)
  else
    h, m = ed.getCurrentHMS()
  end
  local rh = rt.h
  local rm = rt.m
  if 60 * h + m >= 60 * rh + rm then
    return "after"
  end
  return "before"
end
ed.checkBOA = checkBOA
local checkTimeBetween = function(param)
  local nt = param.time or ed.serverTime2China()
  local rangeString = param.rangeString
  if rangeString then
    for k, v in pairs(rangeString) do
      local tt = {}
      for s in string.gfind(v, "%d+:%d+") do
        local ctt = {}
        for cs in string.gfind(s, "%d+") do
          table.insert(ctt, cs)
        end
        table.insert(tt, {
          h = ctt[1],
          m = ctt[2]
        })
      end
      if ed.checkBOA(nil, tt[1]) == "after" and ed.checkBOA(nil, tt[2]) == "before" then
        return true
      end
    end
  end
  return false
end
ed.checkTimeBetween = checkTimeBetween
local function getGameTime(t)
  local nt = t or ed.serverTime2China()
  local rt = reset_time
  return nt - rt.h * 3600 - rt.m * 60
end
ed.getGameTime = getGameTime
local function getGameDayKey(t)
  local tt = ed.getGameTime(t)
  local y,m,d =  ed.time2YMD(tt)
  return string.format("%04d%02d%02d", y,m,d)
end
ed.getGameDayKey = getGameDayKey