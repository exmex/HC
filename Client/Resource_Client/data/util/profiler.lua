_profiler = {}
function newProfiler(variant, sampledelay)
  if _profiler.running then
    print("Profiler already running.")
    return
  end
  variant = variant or "time"
  if variant ~= "time" and variant ~= "call" then
    print("Profiler method must be 'time' or 'call'.")
    return
  end
  local newprof = {}
  for k, v in pairs(_profiler) do
    newprof[k] = v
  end
  newprof.variant = variant
  newprof.sampledelay = sampledelay or 100000
  return newprof
end
function _profiler:start()
  if _profiler.running then
    return
  end
  _profiler.running = self
  self.rawstats = {}
  self.callstack = {}
  if self.variant == "time" then
    self.lastclock = os.clock()
    debug.sethook(_profiler_hook_wrapper_by_time, "", self.sampledelay)
  elseif self.variant == "call" then
    debug.sethook(_profiler_hook_wrapper_by_call, "cr")
  else
    print("Profiler method must be 'time' or 'call'.")
    sys.exit(1)
  end
end
function _profiler:stop()
  if _profiler.running ~= self then
    return
  end
  debug.sethook(nil)
  _profiler.running = nil
end
function _profiler_hook_wrapper_by_call(action)
  if _profiler.running == nil then
    debug.sethook(nil)
  end
  _profiler.running:_internal_profile_by_call(action)
end
function _profiler_hook_wrapper_by_time(action)
  if _profiler.running == nil then
    debug.sethook(nil)
  end
  _profiler.running:_internal_profile_by_time(action)
end
function _profiler:_internal_profile_by_call(action)
  local caller_info = debug.getinfo(3)
  if caller_info == nil then
    print("No caller_info")
    return
  end
  local latest_ar
  if table.getn(self.callstack) > 0 then
    latest_ar = self.callstack[table.getn(self.callstack)]
  end
  local should_not_profile = 0
  for k, v in pairs(self.prevented_functions) do
    if k == caller_info.func then
      should_not_profile = v
    end
  end
  if latest_ar and latest_ar.should_not_profile == 2 then
    should_not_profile = 2
  end
  if action == "call" then
    local this_ar = {}
    this_ar.should_not_profile = should_not_profile
    this_ar.parent_ar = latest_ar
    this_ar.anon_child = 0
    this_ar.name_child = 0
    this_ar.children = {}
    this_ar.children_time = {}
    this_ar.clock_start = os.clock()
    table.insert(self.callstack, this_ar)
  else
    local this_ar = latest_ar
    if this_ar == nil then
      return
    end
    this_ar.clock_end = os.clock()
    this_ar.this_time = this_ar.clock_end - this_ar.clock_start
    if this_ar.parent_ar then
      this_ar.parent_ar.children[caller_info.func] = (this_ar.parent_ar.children[caller_info.func] or 0) + 1
      this_ar.parent_ar.children_time[caller_info.func] = (this_ar.parent_ar.children_time[caller_info.func] or 0) + this_ar.this_time
      if caller_info.name == nil then
        this_ar.parent_ar.anon_child = this_ar.parent_ar.anon_child + this_ar.this_time
      else
        this_ar.parent_ar.name_child = this_ar.parent_ar.name_child + this_ar.this_time
      end
    end
    if this_ar.should_not_profile == 0 then
      local inforec = self:_get_func_rec(caller_info.func, 1)
      inforec.count = inforec.count + 1
      inforec.time = inforec.time + this_ar.this_time
      inforec.anon_child_time = inforec.anon_child_time + this_ar.anon_child
      inforec.name_child_time = inforec.name_child_time + this_ar.name_child
      inforec.func_info = caller_info
      for k, v in pairs(this_ar.children) do
        inforec.children[k] = (inforec.children[k] or 0) + v
        inforec.children_time[k] = (inforec.children_time[k] or 0) + this_ar.children_time[k]
      end
    end
    table.remove(self.callstack, table.getn(self.callstack))
  end
end
function _profiler:_internal_profile_by_time(action)
  local timetaken = os.clock() - self.lastclock
  local depth = 3
  local at_top = true
  local last_caller
  local caller = debug.getinfo(depth)
  while caller do
    if not caller.func then
      caller.func = "(tail call)"
    end
    if self.prevented_functions[caller.func] == nil then
      local info = self:_get_func_rec(caller.func, 1, caller)
      info.count = info.count + 1
      info.time = info.time + timetaken
      if last_caller then
        if last_caller.name then
          info.name_child_time = info.name_child_time + timetaken
        else
          info.anon_child_time = info.anon_child_time + timetaken
        end
        info.children[last_caller.func] = (info.children[last_caller.func] or 0) + 1
        info.children_time[last_caller.func] = (info.children_time[last_caller.func] or 0) + timetaken
      end
    end
    depth = depth + 1
    last_caller = caller
    caller = debug.getinfo(depth)
  end
  self.lastclock = os.clock()
end
function _profiler:_get_func_rec(func, force, info)
  local ret = self.rawstats[func]
  if ret == nil and force ~= 1 then
    return nil
  end
  if ret == nil then
    ret = {}
    ret.func = func
    ret.count = 0
    ret.time = 0
    ret.anon_child_time = 0
    ret.name_child_time = 0
    ret.children = {}
    ret.children_time = {}
    ret.func_info = info
    self.rawstats[func] = ret
  end
  return ret
end
function _profiler:report(outfile, sort_by_total_time)
  outfile:write("Lua Profile output created by profiler.lua.\n")
  local terms = {}
  if self.variant == "time" then
    terms.capitalized = "Sample"
    terms.single = "sample"
    terms.pastverb = "sampled"
  elseif self.variant == "call" then
    terms.capitalized = "Call"
    terms.single = "call"
    terms.pastverb = "called"
  else
    assert(false)
  end
  local total_time = 0
  local ordering = {}
  for func, record in pairs(self.rawstats) do
    table.insert(ordering, func)
  end
  if sort_by_total_time then
    table.sort(ordering, function(a, b)
      return self.rawstats[a].time > self.rawstats[b].time
    end)
  else
    table.sort(ordering, function(a, b)
      local arec = self.rawstats[a]
      local brec = self.rawstats[b]
      local atime = arec.time - (arec.anon_child_time + arec.name_child_time)
      local btime = brec.time - (brec.anon_child_time + brec.name_child_time)
      return atime > btime
    end)
  end
  for i = 1, table.getn(ordering) do
    local func = ordering[i]
    local record = self.rawstats[func]
    local thisfuncname = " " .. self:_pretty_name(func) .. " "
    if string.len(thisfuncname) < 42 then
      thisfuncname = string.rep("-", (42 - string.len(thisfuncname)) / 2) .. thisfuncname
      thisfuncname = thisfuncname .. string.rep("-", 42 - string.len(thisfuncname))
    end
    total_time = total_time + (record.time - (record.anon_child_time + record.name_child_time))
    outfile:write(string.rep("-", 19) .. thisfuncname .. string.rep("-", 19) .. "\n")
    outfile:write(terms.capitalized .. " count:         " .. string.format("%4d", record.count) .. "\n")
    outfile:write("Time spend total:       " .. string.format("%4.3f", record.time) .. "s\n")
    outfile:write("Time spent in children: " .. string.format("%4.3f", record.anon_child_time + record.name_child_time) .. "s\n")
    local timeinself = record.time - (record.anon_child_time + record.name_child_time)
    outfile:write("Time spent in self:     " .. string.format("%4.3f", timeinself) .. "s\n")
    outfile:write("Time spent per " .. terms.single .. ":  " .. string.format("%4.5f", record.time / record.count) .. "s/" .. terms.single .. "\n")
    outfile:write("Time spent in self per " .. terms.single .. ": " .. string.format("%4.5f", timeinself / record.count) .. "s/" .. terms.single .. "\n")
    local added_blank = 0
    for k, v in pairs(record.children) do
      if self.prevented_functions[k] == nil or self.prevented_functions[k] == 0 then
        if added_blank == 0 then
          outfile:write("\n")
          added_blank = 1
        end
        outfile:write("Child " .. self:_pretty_name(k) .. string.rep(" ", 41 - string.len(self:_pretty_name(k))) .. " " .. terms.pastverb .. " " .. string.format("%6d", v))
        outfile:write(" times. Took " .. string.format("%4.2f", record.children_time[k]) .. "s\n")
      end
    end
    outfile:write("\n")
    outfile:flush()
  end
  outfile:write([[


]])
  outfile:write("Total time spent in profiled functions: " .. string.format("%5.3g", total_time) .. "s\n")
  outfile:write([[
END
	]])
  outfile:flush()
end
function _profiler:my_report(outfile)
  outfile:write("Name,Count,Total,Self\n")
  local summary = {}
  for func, record in pairs(self.rawstats) do
    local name = self:_pretty_name(func)
    if not summary[name] then
      summary[name] = {
        Name = name,
        Count = 0,
        Total = 0,
        Self = 0
      }
      local line = summary[name]
      line.Count = line.Count + record.count
      line.Total = line.Total + record.time
      line.Self = line.Self + (record.time - record.anon_child_time - record.name_child_time)
    end
  end
  for name, line in pairs(summary) do
    outfile:write(string.format("%s,%i,%f,%f\n", line.Name, line.Count, line.Total, line.Self))
  end
  outfile:flush()
end
function _profiler:lua_report(outfile)
  local ordering = {}
  local functonum = {}
  for func, record in pairs(self.rawstats) do
    table.insert(ordering, func)
    functonum[func] = table.getn(ordering)
  end
  outfile:write([[
-- Profile generated by profiler.lua Copyright Pepperfish 2002+

]])
  outfile:write([[
-- Function names
funcnames = {}
]])
  for i = 1, table.getn(ordering) do
    local thisfunc = ordering[i]
    outfile:write("funcnames[" .. i .. "] = " .. string.format("%q", self:_pretty_name(thisfunc)) .. "\n")
  end
  outfile:write("\n")
  outfile:write([[
-- Function times
functimes = {}
]])
  for i = 1, table.getn(ordering) do
    local thisfunc = ordering[i]
    local record = self.rawstats[thisfunc]
    outfile:write("functimes[" .. i .. "] = { ")
    outfile:write("tot=" .. record.time .. ", ")
    outfile:write("achild=" .. record.anon_child_time .. ", ")
    outfile:write("nchild=" .. record.name_child_time .. ", ")
    outfile:write("count=" .. record.count .. " }\n")
  end
  outfile:write("\n")
  outfile:write([[
-- Child links
children = {}
]])
  for i = 1, table.getn(ordering) do
    local thisfunc = ordering[i]
    local record = self.rawstats[thisfunc]
    outfile:write("children[" .. i .. "] = { ")
    for k, v in pairs(record.children) do
      if functonum[k] then
        outfile:write(functonum[k] .. ", ")
      end
    end
    outfile:write("}\n")
  end
  outfile:write("\n")
  outfile:write([[
-- Child call counts
childcounts = {}
]])
  for i = 1, table.getn(ordering) do
    local thisfunc = ordering[i]
    local record = self.rawstats[thisfunc]
    outfile:write("children[" .. i .. "] = { ")
    for k, v in ipairs(record.children) do
      if functonum[k] then
        outfile:write(v .. ", ")
      end
    end
    outfile:write("}\n")
  end
  outfile:write("\n")
  outfile:write([[
-- Child call time
childtimes = {}
]])
  for i = 1, table.getn(ordering) do
    local thisfunc = ordering[i]
    local record = self.rawstats[thisfunc]
    outfile:write("childtimes[" .. i .. "] = { ")
    for k, v in pairs(record.children) do
      if functonum[k] then
        outfile:write(record.children_time[k] .. ", ")
      end
    end
    outfile:write("}\n")
  end
  outfile:write([[


-- That is all.

]])
  outfile:flush()
end
function _profiler:_pretty_name(func)
  local info = self.rawstats[func].func_info
  local name = ""
  if info.what == "Lua" then
    name = "L:"
  end
  if info.what == "C" then
    name = "C:"
  end
  if info.what == "main" then
    name = " :"
  end
  if info.name == nil then
    name = name .. "<" .. tostring(func) .. ">"
  else
    name = name .. info.name
  end
  if info.source then
    name = name .. "@" .. info.source
  elseif info.what == "C" then
    name = name .. "@?"
  else
    name = name .. "@<string>"
  end
  name = name .. ":"
  if info.what == "C" then
    name = name .. "?"
  else
    name = name .. info.linedefined
  end
  return name
end
function _profiler:prevent(func, level)
  self.prevented_functions[func] = level or 1
end
_profiler.prevented_functions = {
  [_profiler.start] = 2,
  [_profiler.stop] = 2,
  [_profiler._internal_profile_by_time] = 2,
  [_profiler._internal_profile_by_call] = 2,
  [_profiler_hook_wrapper_by_time] = 2,
  [_profiler_hook_wrapper_by_call] = 2,
  [_profiler.prevent] = 2,
  [_profiler._get_func_rec] = 2,
  [_profiler.report] = 2,
  [_profiler.lua_report] = 2,
  [_profiler._pretty_name] = 2
}
