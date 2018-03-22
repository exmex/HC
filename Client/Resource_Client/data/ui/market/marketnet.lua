local class = ed.ui.market
local config = ed.ui.marketconfig
setfenv(1, class)
function dealRefresh(reply)
  if not reply then
    return
  end
  local handler, data = ed.getNetReply("refresh_shop")
  if data then
    local sid = data.id
    if data.type == 2 then
      local cost = ed.player:getShopRefreshCost(reply._id)
      local ct = config.getRefreshCoinType(reply._id)
      ed.player:addPoint(ct, -cost)
    end
  end
  ed.player:refreshShopData(reply)
  if handler then
    handler()
  end
end
function dealConsume(reply)
  if not reply then
    return
  end
  local result = reply._result == "success"
  local handler, data = ed.getNetReply("shop_consume")
  if handler then
    handler(result, data)
  end
end
