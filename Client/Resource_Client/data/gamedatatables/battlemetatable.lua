DefineDataTableMetaTable("Battle")
function getStageTotalPercent(self, stageId)
  local percent = 0
  for wave = 1, 3 do
    local battle = ed.lookupDataTable("Battle", nil, stageId, wave)
    local weight = battle["Raid Wave Weight"] or 0
    percent = percent + weight
  end
  return percent
end
