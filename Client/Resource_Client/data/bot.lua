package.path = package.path .. ";./lib/?.lua;./lua/?.lua"
require("edebug")
require("LocalString")
require("tools")
ed.enableBotMode = false
ed.enableMaxAttStrategy = true
xpcall(function()
  local ed = ed
  ed.run_with_scene = false
  CCNode = {}
  CCSprite = {}
  ed.HpBar = {}
  LegendLog = log
  require("resource_manager")
  require("datatable")
  require("battle/edp")
  require("battle/battle_engine")
  require("gamedatatables/gamedatatables")
  require("gamedatatables/rechargemetatable")
  local function sortHeroes(list)
    local function attackRange(hid)
      local autoAttack = ed.lookupDataTable("Unit", "Basic Skill", hid)
      return ed.lookupDataTable("Skill", "Max Range", autoAttack, 0)
    end
    table.sort(list, function(a, b)
      return attackRange(a._tid) < attackRange(b._tid)
    end)
  end
  local function test(stage_id, bot_id, lv, stars)
    local bot = ed.lookupDataTable("Bots", nil, bot_id)
    local heroes = {}
    for i = 1, 5 do
      local id = bot["Hero ID " .. i]
      local hero = {
        _tid = id,
        _level = lv,
        _stars = stars
      }
      table.insert(heroes, hero)
    end
    sortHeroes(heroes)
    local stage = ed.lookupDataTable("Stage", nil, stage_id)
    ed.engine:enterStage(stage, heroes, true)
    while ed.engine.running do
      ed.engine:tick()
    end
    local result = ed.engine.result_stars
    return result
  end
  local function grade(stage_id, bot_id, stars)
    local lvmin = 1
    local lvmax = ed.lookupDataTable("Stage", "Monster Level", stage_id) * 2
    while lvmin < lvmax do
      local lv = math.floor((lvmin + lvmax) / 2)
      local result = test(stage_id, bot_id, lv, stars)
      if result > 0 then
        lvmax = lv
      else
        lvmin = lv + 1
      end
    end
    return lvmax
  end
  local function grade_guild(stageId, waveId, botId, levelId, stars)
    local bot = ed.lookupDataTable("Bots", nil, botId)
    local heroes = {}
    for i = 1, 5 do
      local id = bot["Hero ID " .. i]
      local hero = {
        _tid = id,
        _level = levelId,
        _stars = stars
      }
      table.insert(heroes, hero)
    end
    sortHeroes(heroes)
    local stage = ed.lookupDataTable("Stage", nil, stageId)
    local guildInstanceInfo = {}
    guildInstanceInfo._wave_index = waveId
    guildInstanceInfo._hp_info = {
      10000,
      10000,
      10000,
      10000,
      10000
    }
    guildInstanceInfo._raid_id = 1
    ed.engine:enterGuildInstance(stage, heroes, guildInstanceInfo, true)
    local totalHp = ed.engine:getEnemyTotalHp()
    while ed.engine.running do
      ed.engine:tick()
    end
    local endTime = ed.engine.ticks * ed.tick_interval
    local percent, dpsHp
    if ed.engine.wave_id ~= waveId then
      percent = 1
      dpsHp = totalHp
      endTime = 90
    else
      percent, dpsHp = ed.engine:getEenemyConsumePercent()
    end
    return percent, dpsHp, endTime
  end
  local function grade_guild2(stageId, waveId, botId, levelId, stars, enemyStartHpInfo)
    local bot = ed.lookupDataTable("Bots", nil, botId)
    local heroes = {}
    for i = 1, 5 do
      local id = bot["Hero ID " .. i]
      local hero = {
        _tid = id,
        _level = levelId,
        _stars = stars
      }
      table.insert(heroes, hero)
    end
    sortHeroes(heroes)
    local stage = ed.lookupDataTable("Stage", nil, stageId)
    local guildInstanceInfo = {}
    guildInstanceInfo._wave_index = waveId
    if enemyStartHpInfo then
      guildInstanceInfo._hp_info = {}
      for i, info in ipairs(enemyStartHpInfo) do
        guildInstanceInfo._hp_info[i] = math.floor(info.HP / info.SumHP * 10000)
      end
    else
      guildInstanceInfo._hp_info = {
        10000,
        10000,
        10000,
        10000,
        10000
      }
    end
    guildInstanceInfo._raid_id = 1
    ed.engine:enterGuildInstance(stage, heroes, guildInstanceInfo, true)
    local tmpEnemyHpInfo = ed.engine:getEnemyFinalHpInfo()
    enemyStartHpInfo = enemyStartHpInfo or tmpEnemyHpInfo
    while ed.engine.running do
      ed.engine:tick()
    end
    local percent, enemyEndHpInfo
    if ed.engine.wave_id ~= waveId then
      percent = 1
      for i, info in ipairs(tmpEnemyHpInfo) do
        if info.SumHP ~= 0 then
          info.HP = 0
        end
      end
      enemyEndHpInfo = tmpEnemyHpInfo
    else
      percent = ed.engine:getEenemyConsumePercent()
      enemyEndHpInfo = ed.engine:getEnemyFinalHpInfo()
    end
    local tmp = enemyStartHpInfo
    return percent, tmp, enemyEndHpInfo
  end
  local function bot_main()
    local bots = ed.getDataTable("Bots")
    local bot_count = 100
    while true do
      print("Input stage ID: ")
      local stagebegin = io.read("*n")
      local stageend = io.read("*n")
      print("Input bot stars: ")
      local stars = io.read("*n")
      for stage = stagebegin, stageend do
        local sum = 0
        local squm = 0
        for i, bot in ipairs(bots) do
          if i > bot_count then
            break
          end
          local lv = grade(stage, i, stars)
          local log = "Bot:" .. i .. " Lv:" .. lv
          sum = sum + lv
          squm = squm + lv * lv
        end
        local avg = sum / bot_count
        local stdev = (squm / bot_count - avg * avg) ^ 0.5
        print(string.format("Diffculty factor of Stage [%i] is: %f,%f", stage, avg, stdev))
      end
    end
  end
  local function bot_guild()
    local bots = ed.getDataTable("Bots")
    local bot_count = 100
    while true do
      print("Input stage ID: ")
      local stageId = io.read("*n")
      print("Input wave ID: ")
      local waveBegin = 1
      local waveEnd = 3
      print("Input bot Level Range: ")
      local levelBegin = 80
      local levelEnd = 85
      print("Input bot stars: ")
      local stars = 5
      if stageId then
        print("StageId -> " .. stageId)
        for waveId = waveBegin, waveEnd do
          print(" waveId -> " .. waveId)
          for levelId = levelBegin, levelEnd do
            local sum = 0
            local squm = 0
            local passNum = 0
            local sumDpsHp = 0
            local i = 1
            local sumTime = 0
            for i, bot in ipairs(bots) do
              if i > bot_count then
                break
              end
              local percent, dpsHp, time = grade_guild(stageId, waveId, i, levelId, stars)
              if 1 == percent then
                passNum = passNum + 1
              end
              sum = sum + percent
              squm = squm + percent * percent
              sumDpsHp = sumDpsHp + dpsHp
              sumTime = sumTime + time
            end
            local avg = sum / bot_count
            local stdev = (squm / bot_count - avg * avg) ^ 0.5
            local dpsHpAvg = sumDpsHp / bot_count
            local avgTime = sumTime / bot_count
            print(string.format("  Diffculty factor Level [%i] is: %.2f%%,%.2f%%,%i,%.2f : Pass info is %i,%.2f%% : Time is %.2f", levelId, avg * 100, stdev * 100, math.floor(1 / avg), dpsHpAvg, passNum, passNum / bot_count * 100, avgTime))
          end
        end
      end
    end
  end
  local getDpsNum = function(sourceHpInfo, finalHpInfo)
    local sumDps = 0
    for i, info in ipairs(sourceHpInfo) do
      if info.SumHP ~= 0 then
        sumDps = sumDps + (info.HP - finalHpInfo[i].HP)
      end
    end
    return sumDps
  end
  local getEveryEnemyDpsNum = function(sourceHpInfo, finalHpInfo)
    local result = {}
    for i, info in ipairs(sourceHpInfo) do
      local dps = info.HP - finalHpInfo[i].HP
      result[i] = dps
    end
    return result
  end
  local getDpsPercent = function(sourceHpInfo, sumDpsNum)
    local sumTotalHp = 0
    for i, info in ipairs(sourceHpInfo) do
      sumTotalHp = sumTotalHp + info.SumHP
    end
    return sumDpsNum / sumTotalHp
  end
  local getLeftDpsPercent = function(finalHpInfo)
    local sumHp = 0
    local sumTotalHp = 0
    for i, info in ipairs(finalHpInfo) do
      sumHp = sumHp + info.HP
      sumTotalHp = sumTotalHp + info.SumHP
    end
    return sumHp / sumTotalHp
  end
  local function enterWave(stageId, waveId, levelId, stars, botCount, enemeyHpInfo)
    local bots = ed.getDataTable("Bots")
    local passNum = 0
    local sumDps = 0
    local sumDpsPercent = 0
    local sumLeftDpsPercent = 0
    local everyEnemyDps = {}
    local _enemySourceHpInfo
    local i = 1
    for i, bot in ipairs(bots) do
      if botCount < i then
        break
      end
      local percent, enemySourceHpInfo, enemyFinalHpInfo = grade_guild2(stageId, waveId, i, levelId, stars, enemeyHpInfo)
      _enemySourceHpInfo = _enemySourceHpInfo or enemySourceHpInfo
      local dps = getDpsNum(enemySourceHpInfo, enemyFinalHpInfo)
      sumDps = sumDps + dps
      sumDpsPercent = sumDpsPercent + getDpsPercent(enemySourceHpInfo, dps)
      sumLeftDpsPercent = sumLeftDpsPercent + getLeftDpsPercent(enemyFinalHpInfo)
      local tmpEveryEnemyDps = getEveryEnemyDpsNum(enemySourceHpInfo, enemyFinalHpInfo)
      for i, v in ipairs(tmpEveryEnemyDps) do
        if not everyEnemyDps[i] then
          everyEnemyDps[i] = v
        else
          everyEnemyDps[i] = everyEnemyDps[i] + v
        end
      end
      if 1 == percent then
        passNum = passNum + 1
      end
    end
    local avgDpsNum = sumDps / botCount
    local avgDpsPercent = sumDpsPercent / botCount
    local avgLeftDpsPercent = sumLeftDpsPercent / botCount
    local passPercent = passNum / botCount
    print(string.format("WaveId %d , dps %.2f , dpsPercent %.2f%% , leftDpsPercent %.2f%% , passPercent %.2f%%", waveId, avgDpsNum, avgDpsPercent * 100, avgLeftDpsPercent * 100, passPercent * 100))
    local nextEnemyHpInfo = {}
    for i, v in ipairs(_enemySourceHpInfo) do
      local hp = _enemySourceHpInfo[i].HP - everyEnemyDps[i] / botCount
      local sumHp = _enemySourceHpInfo[i].SumHP
      nextEnemyHpInfo[i] = {HP = 0, SumHP = 0}
      nextEnemyHpInfo[i].HP = hp
      nextEnemyHpInfo[i].SumHP = sumHp
    end
    local isPassWave = passNum >= botCount / 2
    return isPassWave, nextEnemyHpInfo
  end
  local function bot_guild2()
    while true do
      print("Input stage ID: ")
      local stageId = io.read("*n")
      print("Input wave ID: ")
      local waveId = io.read("*n")
      print("Input bot Level ID: ")
      local levelId = io.read("*n")
      print("Input bot stars: ")
      local stars = io.read("*n")
      if stageId then
        local enemeyHpInfo
        local isPassWave = false
        local bot_count = 100
        while true do
          isPassWave, enemeyHpInfo = enterWave(stageId, waveId, levelId, stars, bot_count, enemeyHpInfo)
          if waveId == 3 then
            if isPassWave then
              break
            end
          elseif isPassWave then
            waveId = waveId + 1
            enemeyHpInfo = nil
          end
        end
      end
    end
  end
  local function pvp_main(arenaLevel, generationNum)
    if not arenaLevel then
      print("Arena level = ? ")
      arenaLevel = io.read("*n")
    end
    if not generationNum then
      print("Generation Num = ? ")
      generationNum = io.read("*n")
    end
    local heroList = {}
    for id, info in pairs(ed.getDataTable("Unit")) do
      if type(id) == "number" and id < 52 then
        local hero = {
          _tid = id,
          _level = arenaLevel,
          _star = 5,
          name = ed.lookupDataTable("Unit", "Name", id)
        }
        table.insert(heroList, hero)
      end
    end
    local teams = 30
    local teamList = {}
    for i = 1, teams do
      for k = 1, #heroList do
        heroList[k].weight = math.random()
      end
      table.sort(heroList, function(a, b)
        return a.weight > b.weight
      end)
      local team = {
        heroes = {
          heroList[1],
          heroList[2],
          heroList[3],
          heroList[4],
          heroList[5]
        },
        position = i,
        score = 0
      }
      sortHeroes(team.heroes)
      table.insert(teamList, team)
    end
    for id, info in pairs(ed.getDataTable("PVPTeams")) do
      if type(id) == "number" then
        local pvpHeroes = {}
        for v = 1, 5 do
          local hero = {
            _tid = info["Hero ID " .. v],
            _level = arenaLevel,
            _star = 5,
            name = ed.lookupDataTable("Unit", "Name", info["Hero ID " .. v])
          }
          table.insert(pvpHeroes, hero)
        end
        local team = {
          heroes = {
            pvpHeroes[1],
            pvpHeroes[2],
            pvpHeroes[3],
            pvpHeroes[4],
            pvpHeroes[5]
          },
          position = teams + id,
          score = 0
        }
        sortHeroes(team.heroes)
        table.insert(teamList, team)
      end
    end
    os.execute("md arean_pvp")
    local all_out = io.open(string.format("arean_pvp/arena_Genetation.txt"), "w+")
    for g = 1, generationNum do
      for i = 1, #teamList do
        local team = teamList[i]
        team.score = 0
        local son = {
          heroes = {},
          score = 0
        }
        for j = 1, #team.heroes do
          local dice = math.random()
          if dice < 0.6 then
            local new = math.floor(math.random() * #heroList) + 1
            son.heroes[j] = heroList[new]
          else
            son.heroes[j] = team.heroes[j]
          end
        end
        sortHeroes(son.heroes)
        local check = true
        for j = 1, #son.heroes do
          for k = j + 1, #son.heroes do
            if son.heroes[j]._tid == son.heroes[k]._tid then
              check = false
            end
          end
        end
        for t = 1, #teamList do
          local sum1 = 0
          local sum2 = 0
          for tt = 1, 5 do
            sum1 = sum1 + son.heroes[tt]._tid * son.heroes[tt]._tid
            sum2 = sum2 + teamList[t].heroes[tt]._tid * teamList[t].heroes[tt]._tid
          end
          if sum1 == sum2 then
            print("remove same team")
            check = false
            break
          end
        end
        if check then
          table.insert(teamList, son)
        end
      end
      for i = 1, #teamList do
        local teamA = teamList[i]
        for j = i + 1, #teamList do
          local teamB = teamList[j]
          ed.engine:enterArena(teamB.heroes, teamA.heroes, true, true)
          while ed.engine.running do
            ed.engine:tick()
          end
          local result = ed.engine.result_stars
          local winner = result > 0 and teamB or teamA
          winner.score = winner.score + 1
        end
      end
      table.sort(teamList, function(a, b)
        return a.score > b.score
      end)
      for i = #teamList, teams + 1, -1 do
        teamList[i] = nil
      end
      local out = io.open(string.format("arean_pvp/arena_%i_Genetation_%i.txt", arenaLevel, g), "w+")
      print("[bot.lua|pvp_main]-------------------------------------------")
      print("Generation " .. g)
      for i = 1, #teamList do
        local team = teamList[i]
        local format = "%i:(%s)\t%s, %s, %s, %s, %s"
        local paras = {i}
        local s
        if not team.position then
          s = "new"
        elseif i == team.position then
          s = "="
        else
          s = string.format("%+i", team.position - i)
        end
        paras[2] = s
        team.position = i
        for _, h in ipairs(team.heroes) do
          table.insert(paras, h.name)
        end
        local str = string.format(format, unpack(paras))
        print(str .. " score: " .. team.score)
        if out then
          out:write(str .. " score: " .. team.score)
          out:write("\n")
        end
        local all_format = "%i,%i:(%s),%s,%s,%s,%s,%s,"
        local all_str = string.format(all_format, g, unpack(paras))
        if all_out then
          all_out:write(all_str .. "" .. team.score)
          all_out:write("\n")
        end
      end
      if out then
        out:flush()
        out:close()
      end
      if all_out then
        all_out:flush()
      end
    end
    if all_out then
      all_out:flush()
      all_out:close()
    end
  end
  collectgarbage("setpause", 100)
  collectgarbage("setstepmul", 5000)
  if not arg then
    arg = {"-pvp"}
  end
  if arg[1] == "-pvp" then
    local time = os.time()
    pvp_main(90, 1000)
    print("Time: " .. os.time() - time)
  elseif arg[1] == "-guild" then
    bot_guild()
  elseif arg[1] == "-guild2" then
    bot_guild2()
  else
    bot_main()
  end
end, EDDebug)
