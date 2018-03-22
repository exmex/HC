local ed = ed
local csvLineSplit = function(s)
  s = s .. ","
  local t = {}
  local fieldstart = 1
  repeat
    if string.find(s, "^\"", fieldstart) then
      local a, c
      local i = fieldstart
      repeat
        a, i, c = string.find(s, "\"(\"?)", i + 1)
      until c ~= "\""
      if not i then
        error("unmatched \"")
      end
      local f = string.sub(s, fieldstart + 1, i - 1)
      table.insert(t, (string.gsub(f, "\"\"", "\"")))
      fieldstart = string.find(s, ",", i) + 1
    else
      local nexti = string.find(s, ",", fieldstart)
      table.insert(t, string.sub(s, fieldstart, nexti - 1))
      fieldstart = nexti + 1
    end
  until fieldstart > string.len(s)
  return t
end
local sub = string.sub
local gmatch = string.gmatch
local insert = table.insert
local tonumber = tonumber
local toboolean = ed.toboolean
local lower = string.lower
local function parseValue(v, t)
  local char = sub(t, 1, 1)
  t = sub(t, 2)
  local iskey = false
  local isString = false
  if char == "K" then
    iskey = true
    char = sub(t, 1, 1)
    t = sub(t, 2)
  end
  if char == "A" then
    local ret = {}
    for token in gmatch(v, "[^;]*") do
      local e = parseValue(token, t)
      insert(ret, e)
    end
    v = ret
  elseif char == "S" then
    isString = true
    if v == "" or not v then
      v = nil
    end
  elseif char == "N" then
    v = tonumber(v) or 0
  elseif char == "B" then
    v = toboolean(lower(v))
  elseif char == "O" then
    return parseValue(v, t)
  end
  return v, iskey, isString
end
local function setValueForKeyChain(t, chain, v, table_name)
  if #chain == 0 then
    EDDebug("Primary key not found on table: " .. table_name)
  end
  local k = chain[1]
  if #chain == 1 then
    if t[k] then
      EDDebug("Primary key '" .. (k or "nil") .. "' duplicated on table: " .. table_name)
    end
    t[k] = v
  else
    if not t[k] then
      t[k] = {}
    end
    table.remove(chain, 1)
    setValueForKeyChain(t[k], chain, v, table_name)
  end
end
local datatable_cache = {}
local insert = table.insert
local gmatch = string.gmatch
local function loadCSV(path)
  local ret = {}
  local file_content = LegendGetFileData(path)
  local column_list, type_list
  if not file_content then
    print(path)
  end
  for line in gmatch(file_content, "[^\r\n]*") do
    if line ~= "" then
      local value_list = csvLineSplit(line)
      if not type_list then
        type_list = value_list
      elseif not column_list then
        column_list = value_list
      else
        local line_table = {}
        local key = {}
        for i = 1, #column_list do
          local t = type_list[i]
          if t and #t > 0 then
            local k = column_list[i]
            local v = value_list[i]
            local vv, iskey, isString = parseValue(v, t)
            if vv and isString then
              vv = T(vv)
            end
            line_table[k] = vv
            if iskey then
              key[#key + 1] = vv
            end
          end
        end
        setValueForKeyChain(ret, key, line_table, path)
        local name = line_table.Name
        if name then
          ret[name] = line_table
        end
      end
    end
  end
  return ret
end
ed.loadCSV = loadCSV
local function getDataTable(table_name)

 -- LegendLog("loading table ".. table_name)

  local ret = datatable_cache[table_name]
  if ret then
    return ret
  end
  pcall(function()
	--add by xinghui:not perfect todo:...	
	package.loaded[table_name] = false
	--
    ret = require(table_name)	
  end)
  if not ret then
    local path = "csv/" .. table_name .. ".csv"
    ret = loadCSV(path)
  end
  local meta = dataTableMetaTables[table_name]
  if meta then
    setmetatable(ret, meta)
  end
  ret.name = table_name
  datatable_cache[table_name] = ret
  return ret
end
ed.getDataTable = getDataTable

local function clearDataTable()
	for k, v in pairs(datatable_cache) do
		datatable_cache[k] = nil
	end
	datatable_cache = {}
end
ed.clearDataTable = clearDataTable
	
local select = select
local function lookupDataTable(table_name, column_name, ...)
  local dt = getDataTable(table_name)
  for i = 1, select("#", ...) do
    local key = select(i, ...)
    dt = dt[key]
    if not dt then
      return
    end
  end
  if column_name then
    return dt[column_name]
  else
    return dt
  end
end
ed.lookupDataTable = lookupDataTable
