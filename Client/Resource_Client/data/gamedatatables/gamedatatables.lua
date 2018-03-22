dataTableMetaTables = {}
function _G.DefineDataTableMetaTable(tablename)
  local newTable = dataTableMetaTables[tablename]
  if nil == newTable then
    newTable = {}
    dataTableMetaTables[tablename] = newTable
  else
    print("DefineDataTableMetaTable already exist table!!!!")
  end
  package.seeall(newTable)
  newTable.__index = newTable
  setfenv(2, newTable)
end
