EDFLAGSVR = true
package.path = package.path .. ";./lib/?.lua;./lua/?.lua"
require("socket")
require("edebug")
require("tools")
require("stringbuffer")
require("debug.serialize")
require("debug.dump")
function ccc3()
end
require("../btcheck-config")
os.execute("mkdir bclog")
local host = check_server_ip
local port = check_server_port
local memmoey_limit = 30720
local insert = table.insert
local ipairs = ipairs
local class = {
  mt = {}
}
local Queue = class
class.mt.__index = class
function Queue.create(capcity)
  local self = {
    capcity = capcity,
    head = 1,
    size = 0
  }
  setmetatable(self, class.mt)
  return self
end
function Queue:full()
  return self.size >= self.capcity
end
function Queue:push(obj)
  local size = self.size
  local capcity = self.capcity
  if size >= capcity then
    EDDebug("Push to full queue!")
    return false
  end
  self[(self.head + size) % capcity] = obj
  size = size + 1
  self.size = size
  return size
end
function Queue:get()
  if self.size == 0 then
    return false
  end
  return self[self.head]
end
function Queue:pull()
  if self.size == 0 then
    EDDebug("Pull from empty queue!")
    return false
  end
  local head = self.head
  local capcity = self.capcity
  local ret = self[head]
  self[head] = nil
  self.head = (head + 1) % capcity
  self.size = self.size - 1
  return ret
end
xpcall(function()
  local ed = ed
  ed.run_with_scene = false
  CCNode = {}
  CCSprite = {}
  ed.HpBar = {}
  require("resource_manager")
  require("datatable")
  require("gamedatatables/gamedatatables")
  require("gamedatatables/battlemetatable")
  require("gamedatatables/herotasktable")
  require("battle/edp")
  require("battle/battle_engine")
  require("pb")
  require("battle/battle_check")
  local up = pb_loader("bcup")()
  local down = pb_loader("bcdown")()
  local upmsg = up.battlecheck_reply
  local downmsg = down.battlecheck
  local jobQueue = Queue.create(4096)
  local reportQueue = Queue.create(4096)
  local hungerSize = 3
  local connection
  local function connect()
    print("trying to connect ... ")
    connection, err = socket.connect(host, port)
    if not connection then
      print("socket.connect() failed. | " .. err)
      return
    end
    connection:settimeout(0)
    print("connectted success")
  end
  local function recv_buffer(size_left, buffer)
    if size_left <= 0 then
      return buffer
    end
    local content, err, partial = connection:receive(size_left)
    if err == "closed" then
      print("socket closed by server.")
      connection:close()
      connection = nil
      return false
    elseif err == "timeout" then
      buffer = buffer .. partial
      return recv_buffer(size_left - #partial, buffer)
    else
      buffer = buffer .. content
      return recv_buffer(size_left - #content, buffer)
    end
  end
  local function recv()
    if not connection then
      connect()
    end
    if not connection then
      return 0
    else
      local total = 0
      repeat
        if jobQueue:full() then
          break
        end
        local count = 0
        local buffer_size_str, err = connection:receive(2)
        if err == "closed" then
          print("connection closed")
          connection:close()
          connection = nil
          break
        end
        if buffer_size_str then
          local buffer_size = string.byte(buffer_size_str, 1) * 256 + string.byte(buffer_size_str, 2)
          local buffer = recv_buffer(buffer_size, "")
          if buffer then
            local msg, err = downmsg():Parse(buffer)
            if msg then
              if msg._pve_msg then
                for i = 1, #msg._pve_msg do
                  local job = {
                    msg = msg._pve_msg[i],
                    type = "stage"
                  }
                  jobQueue:push(job)
                end
                count = count + #msg._pve_msg
              end
              if msg._pvp_msg then
                for i = 1, #msg._pvp_msg do
                  local job = {
                    msg = msg._pvp_msg[i],
                    type = "arena"
                  }
                  jobQueue:push(job)
                end
                count = count + #msg._pvp_msg
              end
              if msg._tbc_msg then
                for i = 1, #msg._tbc_msg do
                  local job = {
                    msg = msg._tbc_msg[i],
                    type = "tbc"
                  }
                  jobQueue:push(job)
                end
                count = count + #msg._tbc_msg
              end
              if msg._guild_msg then
                for i = 1, #msg._guild_msg do
                  local job = {
                    msg = msg._guild_msg[i],
                    type = "guild"
                  }
                  jobQueue:push(job)
                end
                count = count + #msg._guild_msg
              end
              if msg._excav_msg then
                for i = 1, #msg._excav_msg do
                  local job = {
                    msg = msg._excav_msg[i],
                    type = "excav"
                  }
                  jobQueue:push(job)
                end
                count = count + #msg._excav_msg
              end
            else
              EDDebug("Pb parse failed. Proto mismatch?")
              connection = nil
            end
          end
        end
        total = total + count
      until count == 0
      return total
    end
  end
  local pack_size = function(code)
    local length = #code
    local second = string.char(length % 256)
    local first = string.char(math.floor(length / 256))
    return first .. second .. code
  end
  local function report(checkID, userid, _result, checktime)
    local msg = up.check_result()
    msg._checkid = checkID
    msg._userid = userid or 0
    msg._result = _result
    msg._is_plugin = checktime and 0 or 1
    reportQueue:push(msg)
  end
  local function send(count)
    count = count or reportQueue.size
    if not connection then
      connect()
    end
    if not connection then
      return
    else
      local msg = upmsg()
      msg._result = {}
      for i = 1, count do
        msg._result[i] = reportQueue:pull()
      end
      local code = pack_size(msg:Serialize())
      local r1, r2 = connection:send(code)
      if not r1 then
        print("Send report failed|" .. r2)
        for i = 1, count do
          reportQueue:push(msg._result[i])
        end
      else
      end
    end
  end
  local function team2string(team, uid)
    local format = "u%i [%s, %s, %s, %s, %s]"
    local paras = {uid}
    for i, hero in ipairs(team) do
      local name = ed.lookupDataTable("Unit", "Name", hero._tid)
      table.insert(paras, name .. " " .. hero._stars .. "-" .. hero._level)
    end
    for i = #team + 1, 5 do
      table.insert(paras, "")
    end
    return string.format(format, unpack(paras))
  end
  local function log(job, result, time)
    local msg = job.msg
    local format = "%i\t%s vs %s -> %s (%is)"
    local paras = {
      msg._checkid
    }
    if job.type == "stage" then
      table.insert(paras, team2string(msg._heroes, msg._userid))
      local s = string.format("[Stage %i] (%i ops, %i stars)", msg._stageid, #(msg._oprations or {}), msg._stars)
      table.insert(paras, s)
      table.insert(paras, result and "Pass" or "CHEAT!!")
      table.insert(paras, time)
    elseif job.type == "arena" then
      table.insert(paras, team2string(msg._self_heroes, msg._userid))
      table.insert(paras, team2string(msg._oppo_heroes, msg._oppo_userid))
      table.insert(paras, result and "victory" or "defeat")
      table.insert(paras, time)
    elseif job.type == "tbc" or job.type == "excav" then
      table.insert(paras, team2string(msg._self_heroes, msg._userid))
      table.insert(paras, team2string(msg._oppo_heroes, msg._oppo_userid))
      table.insert(paras, result and "Pass" or "CHEAT!!")
      table.insert(paras, time)
    elseif job.type == "guild" then
      table.insert(paras, team2string(msg._self_heroes, msg._userid))
      local s = string.format("[Stage %i]", msg._stageid)
      table.insert(paras, s)
      table.insert(paras, result and "Pass" or "CHEAT!!")
      table.insert(paras, time)
    end
    local s = string.format(format, unpack(paras))
    print(s)
  end
  local function checkDynaResult(msg)
    local selfHeros, enemyHeros = ed.engine:getBattleResult()
    for i = 1, #selfHeros do
      local bcData = selfHeros[i]
      local clientData = msg._self_dyna_end[i]
      if bcData._hp_perc ~= clientData._hp_perc or bcData._mp_perc ~= clientData._mp_perc or bcData._custom_data ~= clientData._custom_data then
        return false
      end
    end
    for i = 1, #enemyHeros do
      local bcData = enemyHeros[i]
      local clientData = msg._oppo_dyna_end[i]
      if bcData._hp_perc ~= clientData._hp_perc or bcData._mp_perc ~= clientData._mp_perc or bcData._custom_data ~= clientData._custom_data then
        return false
      end
    end
    return true
  end
  local function checkGuildInstanceResult(msg)
    local wave = ed.engine.wave_id
    if wave ~= msg._end_wave then
      return false
    end
    local enemyHp = ed.engine:getEnemyHpInfo()
    local totalDamage = ed.engine:getPlayerTotalDamage()
    if totalDamage ~= msg._dps then
      return false
    end
    for i = 1, #enemyHp do
      if enemyHp[i] ~= msg._hp_end[i] then
        return false
      end
    end
    return true
  end
  local function checkMemoryUsage()
    local mem = collectgarbage("count")
    if mem > memmoey_limit then
      print("memory limit exceeded")
      eddebug.dump("bclog")
      os.exit(1)
    end
    return mem
  end
  local function dojob(job)
    logfile = ed.StringBufferCreate()
    local msg = job.msg
    local mode = job.type
    battle_check.enterBattle(msg, mode)
    while ed.engine.running do
      ed.engine:tick()
      checkMemoryUsage()
    end
    local result, _result
    if job.type == "stage" then
      local stars_expected = msg._result ~= "victory" and 0 or msg._stars
      result = stars_expected == ed.engine.result_stars
      _result = result and 1 or 2
    elseif job.type == "arena" then
      result = 0 < ed.engine.result_stars
      _result = result and 3 or 4
    elseif job.type == "tbc" then
      result = checkDynaResult(msg)
      _result = result and 1 or 2
    elseif job.type == "guild" then
      result = checkGuildInstanceResult(msg)
      _result = result and 1 or 2
    elseif job.type == "excav" then
      result = checkDynaResult(msg)
      _result = result and 1 or 2
    end
    local checktime = true
    local time = math.floor(ed.engine.ticks * ed.tick_interval)
    if (job.type == "stage" or job.type == "tbc" or job.type == "guild") and msg._cli_battle_time + 3 < time * 0.5 then
      checktime = false
    end
    log(job, result, time)
    report(msg._checkid, msg._userid, _result, checktime)
    if _result == 2 then
      local file = io.open(string.format("bclog/%s_%i.bclog", job.type, msg._checkid), "w")
      if file then
        file:write(getBtlog())
        file:close()
      end
      file = io.open(string.format("bclog/%s%imsg.lua", job.type, msg._checkid), "w")
      if file then
        ed.exportLuaModule(file, msg, ".data")
      end
    end
  end
  local sleep = function(time)
    pcall(function()
      socket.select(nil, nil, time)
    end)
  end
  local function server_main()
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)
    local request_sent = false
    while true do
      if recv() > 0 then
        request_sent = false
      end
      if jobQueue.size == 0 and reportQueue.size == 0 then
        sleep(0.5)
      end
      if not reportQueue:full() and 0 < jobQueue.size then
        local job = jobQueue:pull()
        dojob(job)
        print(string.format("Memory usage: %i kb", checkMemoryUsage()))
      end
      if reportQueue:full() or jobQueue.size == 0 then
        send()
      end
      if jobQueue.size < hungerSize and not request_sent then
        send(0)
        request_sent = true
      end
    end
  end
  server_main()
end, function(msg)
  if enable_debug then
    EDDebug()
  else
    eddebug.dump("bclog")
  end
end)
