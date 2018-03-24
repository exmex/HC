local ed = ed
local class = {
  mt = {}
}
ed.Dump = class
class.mt.__index = class
local function DumpCreate(maxLv)
  local self = {
    what = "dump",
    tables = {},
    stack = {},
    maxLv = maxLv or math.huge,
    nextTableID = 1,
    tableIDs = {},
    encodeLv = 0
  }
  setmetatable(self, class.mt)
  local i = 2
  local info = debug.getinfo(i)
  repeat
    local frame = ed.DumpFrameCreate(self, i, info.func)
    table.insert(self.stack, frame)
    i = i + 1
    info = debug.getinfo(i)
  until not info
  return self
end
ed.DumpCreate = DumpCreate
class.create = DumpCreate
local function write(self, file)
  local obj = {
    what = self.what,
    tables = self.tables,
    stack = self.stack,
    maxLv = self.maxLv
  }
  require("debug.serialize")
  ed.exportLuaModule(file, obj)
end
class.write = write
local function assemble(self, value)
  local t = type(value)
  if t == "string" then
    local index = string.match(value, "#table: (%d+)") or string.match(value, "#function: (%d+)")
    if index then
      index = tonumber(index)
      local dumpinfo = self.tables[index]
      if dumpinfo.what == "table" then
        if type(dumpinfo.mt) == "table" then
          setmetatable(dumpinfo.content, dumpinfo.mt)
        end
        return dumpinfo.content
      elseif dumpinfo.what == "func" then
        setmetatable(dumpinfo, ed.DumpFunc.mt)
        return dumpinfo
      else
        EDDebug()
      end
    end
  end
  if t == "table" then
    local copy = {}
    for k, v in pairs(value) do
      local kk = self:assemble(k)
      local vv = self:assemble(v)
      copy[kk] = vv
    end
    for k, v in pairs(value) do
      value[k] = nil
    end
    for k, v in pairs(copy) do
      value[k] = v
    end
    if value.what == "frame" then
      setmetatable(value, ed.DumpFrame.mt)
    end
  end
  return value
end
class.assemble = assemble
local function fromFile(src)
  local self = loadfile(src)()
  setmetatable(self, class.mt)
  self.stack = self:assemble(self.stack)
  self.tables = self:assemble(self.tables)
  return self
end
class.fromFile = fromFile
local function encode(self, v)
  local t = type(v)
  if t == "boolean" or t == "number" or t == "string" or t == "nil" or t == "userdata" then
    return v
  end
  self.encodeLv = self.encodeLv + 1
  local ret = "#no_data"
  while self.encodeLv <= self.maxLv do
    if t == "table" or t == "function" then
      if not self.tableIDs[v] then
        self.tableIDs[v] = self.nextTableID
        local dumpinfo = {
          index = self.nextTableID
        }
        self.tables[self.nextTableID] = dumpinfo
        self.nextTableID = self.nextTableID + 1
        if t == "table" then
          ed.DumpTableCreate(dumpinfo, self, v)
        else
          ed.DumpFuncCreate(dumpinfo, self, v)
        end
      end
      ret = string.format("#%s: %i", t, self.tableIDs[v])
      break
    end
    ret = tostring(v)
    break
  end
  self.encodeLv = self.encodeLv - 1
  return ret
end
class.encode = encode
function class:__p()
  print("-----------------------------------")
  print("Stack traceback:")
  for i, frame in ipairs(self.stack) do
    print(string.format("[%i]\t%s", i, tostring(frame)))
    self[i] = frame
  end
  print("-----------------------------------")
end
local class = {
  mt = {}
}
ed.DumpFrame = class
class.mt.__index = class
local function DumpFrameCreate(dump, level)
  local info = debug.getinfo(level + 1)
  local frame = {
    what = "frame",
    func = dump:encode(info.func),
    currentline = info.currentline,
    locals = {}
  }
  setmetatable(frame, class.mt)
  dump.tables[dump.tableIDs[info.func]].info = info
  local i = 1
  local n, v
  repeat
    n, v = debug.getlocal(level + 1, i)
    if n then
      frame.locals[i] = {
        dump:encode(n),
        dump:encode(v)
      }
    end
    i = i + 1
  until n == nil
  return frame
end
ed.DumpFrameCreate = DumpFrameCreate
class.create = DumpFrameCreate
function class.mt:__tostring()
  return string.format(":%i\t@ %s", self.currentline, tostring(self.func))
end
function class:__p()
  print(tostring(self))
  print("local varibles:")
  for i, v in ipairs(self.locals) do
    print("\t", v[1], "\t", v[2])
  end
  print("up values:")
  for k, v in pairs(self.func.ups) do
    print("\t", k, "\t", v)
  end
  self.ups = self.func.ups
end
local class = {
  mt = {}
}
ed.DumpFunc = class
class.mt.__index = class
local function DumpFuncCreate(self, dump, func)
  self.what = "func"
  self.index = dump.tableIDs[func]
  self.info = debug.getinfo(func)
  self.ups = {}
  setmetatable(self, class.mt)
  local i = 1
  local n, v
  repeat
    n, v = debug.getupvalue(func, i)
    if n then
      self.ups[dump:encode(n)] = dump:encode(v)
    end
    i = i + 1
  until n == nil
  self.info.func = nil
  return self
end
ed.DumpFuncCreate = DumpFuncCreate
class.create = DumpFuncCreate
function class.mt:__tostring()
  local info = self.info
  local funcname = info.name or "?"
  local short_src = info.short_src or "nil"
  local linedefined = info.linedefined or -1
  return string.format("func#%i:%s <%s:%i>", self.index, funcname, short_src, linedefined)
end
local class = {
  mt = {}
}
ed.DumpTable = class
class.mt.__index = class
local function DumpTableCreate(self, dump, table)
  local mt = getmetatable(table)
  self.what = "table"
  self.index = dump.tableIDs[table]
  self.mt = dump:encode(mt)
  self.content = {}
  setmetatable(self, class.mt)
  for k, v in pairs(table) do
    self.content[dump:encode(k)] = dump:encode(v)
  end
  return self
end
ed.DumpTableCreate = DumpTableCreate
class.create = DumpTableCreate
if not eddebug then
  eddebug = {}
end
function eddebug.dump(folder)
  local d = ed.DumpCreate()
  folder = folder or CCFileUtils:sharedFileUtils():getWritablePath()
  local path = string.format("%s/dump_%s.lua", folder, os.date("%Y-%m-%d %H-%M-%S"))
  d:write(path)
end
eddebug.loaddump = ed.Dump.fromFile
