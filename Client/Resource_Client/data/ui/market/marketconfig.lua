local class = newclass("g")
ed.ui.marketconfig = class
setfenv(1, class)
scaleIcon = "UI/alpha/HVGA/shop_sale_6.png"
type_config = {
  [1] = {
    name = "common",
    goods_type = "coin",
    buy_type = "coin",
    canRefresh = function()
      if ed.player._rmb < ed.player:getShopRefreshCost(1) then
        ed.showHandyDialog("toRecharge")
        return false
      end
      return true
    end,
    refresh_coin_type = "diamond",
    refresh_coin_name = T(LSTR("RECHARGE.DIAMOND")),
    show_hot_tag = false,
    will_auto_exit = false,
    need_open = false,
    need_enter_refresh = true,
    do_fast_sell = true,
    level_explaination = nil,
    ui_config = {
      frameRes = "UI/alpha/HVGA/shop_bg.png",
      titleBgRes = "UI/alpha/HVGA/map-title-bg.png",
      titleRes = "UI/alpha/HVGA/shop_title_1.png",
      productBgRes = "UI/alpha/HVGA/shop_product_bg.png",
      headRes = "UI/alpha/HVGA/shop_head.png",
      talkBgRes = "UI/alpha/HVGA/shop_talk_bg.png",
      noneTagRes = "UI/alpha/HVGA/shop_none_tag.png",
      titlePos = ccp(400, 405),
      headPos = ccp(142, 400),
      framePos = ccp(400, 225),
      costLabelColor = ccc3(255, 255, 255)
    }
  },
  [2] = {
    name = "special",
    goods_type = "coin",
    buy_type = "coin",
    canRefresh = function()
      if ed.player._rmb < ed.player:getShopRefreshCost(2) then
        ed.showHandyDialog("toRecharge")
        return false
      end
      return true
    end,
    refresh_coin_type = "diamond",
    refresh_coin_name = T(LSTR("RECHARGE.DIAMOND")),
    show_hot_tag = false,
    will_auto_exit = false,
    need_open = false,
    need_enter_refresh = true,
    do_fast_sell = true,
    level_explaination = T(LSTR("SHOP.THE_MYSTERIOUS_BUSINESSMAN_HAS_DRIFTED_AWAY_PLEASE_BE_QUICK_NEXT_TIME")),
    ui_config = {
      frameRes = "UI/alpha/HVGA/shop_bg.png",
      titleBgRes = "UI/alpha/HVGA/shop_title_bg_2.png",
      productBgRes = "UI/alpha/HVGA/shop_product_bg_2.png",
      headRes = "UI/alpha/HVGA/shop_head_2.png",
      titleRes = "UI/alpha/HVGA/shop_title_2.png",
      talkBgRes = "UI/alpha/HVGA/shop_talk_bg.png",
      noneTagRes = "UI/alpha/HVGA/shop_none_tag.png",
      titlePos = ccp(400, 405),
      headPos = ccp(140, 388),
      framePos = ccp(400, 225),
      costLabelColor = ccc3(255, 255, 255)
    }
  },
  [3] = {
    name = "soSpecial",
    goods_type = "coin",
    buy_type = "coin",
    canRefresh = function()
      if ed.player._rmb < ed.player:getShopRefreshCost(3) then
        ed.showHandyDialog("toRecharge")
        return false
      end
      return true
    end,
    refresh_coin_type = "diamond",
    refresh_coin_name = T(LSTR("RECHARGE.DIAMOND")),
    show_hot_tag = false,
    will_auto_exit = false,
    need_open = false,
    need_enter_refresh = true,
    do_fast_sell = true,
    level_explaination = T(LSTR("SHOP.THE_MYSTERIOUS_BUSINESSMAN_HAS_DRIFTED_AWAY_PLEASE_BE_QUICK_NEXT_TIME")),
    ui_config = {
      frameRes = "UI/alpha/HVGA/shop_bg.png",
      titleBgRes = "UI/alpha/HVGA/shop_title_bg_2.png",
      productBgRes = "UI/alpha/HVGA/shop_product_bg_2.png",
      headRes = "UI/alpha/HVGA/shop_head_3.png",
      titleRes = "UI/alpha/HVGA/shop_title_3.png",
      talkBgRes = "UI/alpha/HVGA/shop_talk_bg.png",
      noneTagRes = "UI/alpha/HVGA/shop_none_tag.png",
      titlePos = ccp(400, 405),
      headPos = ccp(148, 398),
      framePos = ccp(400, 225),
      costLabelColor = ccc3(255, 255, 255)
    }
  },
  [4] = {
    name = "crusade",
    goods_type = "coin",
    buy_type = "coin",
    canRefresh = function()
      if ed.player:getCrusadeMoney() < ed.player:getShopRefreshCost(4) then
        ed.showToast(T(LSTR("SHOP.INSUFFIENT_INTERFAX_COINS_THUS_YOU_CAN_NOT_REFRESH")))
        return false
      end
      return true
    end,
    refresh_coin_type = "crusadepoint",
    refresh_coin_name = T(LSTR("SHOP.INTERFAX_COINS")),
    show_hot_tag = true,
    will_auto_exit = false,
    need_open = true,
    need_enter_refresh = true,
    do_fast_sell = false,
    level_explaination = nil,
    ui_config = {
      frameRes = "UI/alpha/HVGA/shop_bg.png",
      titleBgRes = "UI/alpha/HVGA/shop_title_bg_purple.png",
      productBgRes = "UI/alpha/HVGA/shop_product_bg_2.png",
      headRes = "UI/alpha/HVGA/shop_head_tb.png",
      titleRes = "UI/alpha/HVGA/shop_title_crusade.png",
      talkBgRes = "UI/alpha/HVGA/shop_talk_bg.png",
      noneTagRes = "UI/alpha/HVGA/shop_none_tag.png",
      titlePos = ccp(400, 405),
      headPos = ccp(152, 380),
      framePos = ccp(400, 225),
      costLabelColor = ccc3(255, 255, 255)
    }
  },
  [5] = {
    name = "pvp",
    goods_type = "coin",
    buy_type = "coin",
    canRefresh = function()
      if ed.player:getPvpMoney() < ed.player:getShopRefreshCost(5) then
        ed.showToast(T(LSTR("SHOP.INSUFFIENT_GLADIATOR_COINS_THUS_YOU_CAN_NOT_REFRESH")))
        return false
      end
      return true
    end,
    refresh_coin_type = "arenapoint",
    refresh_coin_name = T(LSTR("SHOP.GLADIATOR_COINS")),
    show_hot_tag = true,
    will_auto_exit = false,
    need_open = true,
    need_enter_refresh = true,
    do_fast_sell = false,
    level_explaination = nil,
    ui_config = {
      frameRes = "UI/alpha/HVGA/shop_bg.png",
      titleBgRes = "UI/alpha/HVGA/shop_title_bg_2.png",
      productBgRes = "UI/alpha/HVGA/shop_product_bg_2.png",
      headRes = "UI/alpha/HVGA/shop_head_panda.png",
      titleRes = "UI/alpha/HVGA/shop_title_arena.png",
      talkBgRes = "UI/alpha/HVGA/shop_talk_bg.png",
      noneTagRes = "UI/alpha/HVGA/shop_none_tag.png",
      titlePos = ccp(400, 405),
      headPos = ccp(148, 400),
      framePos = ccp(400, 225),
      costLabelColor = ccc3(255, 255, 255)
    }
  },
  [7] = {
    name = "guild",
    goods_type = "coin",
    buy_type = "coin",
    canRefresh = function()
      if ed.player:getGuildMoney() < ed.player:getShopRefreshCost(7) then
        ed.showToast(T(LSTR("marketconfig.1.10.1.001")))
        return false
      end
      return true
    end,
    refresh_coin_type = "guildpoint",
    refresh_coin_name = T(LSTR("marketconfig.1.10.1.002")),
    show_hot_tag = true,
    will_auto_exit = false,
    need_open = true,
    need_enter_refresh = true,
    do_fast_sell = false,
    level_explaination = nil,
    ui_config = {
      frameRes = "UI/alpha/HVGA/shop_bg.png",
      titleBgRes = "UI/alpha/HVGA/shop_title_bg_guild.png",
      productBgRes = "UI/alpha/HVGA/shop_product_bg_2.png",
      headRes = "UI/alpha/HVGA/shop_head_guild.png",
      titleRes = "UI/alpha/HVGA/shop_title_guild.png",
      talkBgRes = "UI/alpha/HVGA/shop_talk_bg.png",
      noneTagRes = "UI/alpha/HVGA/shop_none_tag.png",
      titlePos = ccp(400, 394),
      headPos = ccp(139, 421),
      framePos = ccp(400, 225),
      costLabelColor = ccc3(255, 255, 255)
    }
  },
  ["starshop"] = {
    name = "star",
    goods_type = "stone",
    buy_type = "stone",
    canRefresh = nil,
    refresh_coin_type = nil,
    refresh_coin_name = nil,
    show_hot_tag = nil,
    will_auto_exit = true,
    need_open = false,
    need_enter_refresh = false,
    do_fast_sell = false,
    level_explaination = T(LSTR("SHOP.STAR_TRADERS_HAD_ALREADY_LEFT_NEXT_TIME_MOVE_FASTER_")),
    ui_config = {
      frameRes = "UI/alpha/HVGA/shop_star_frame.png",
      titleBgRes = nil,
      productBgRes = "UI/alpha/HVGA/shop_star_item_bg.png",
      headRes = nil,
      titleRes = "UI/alpha/HVGA/shop_star_title.png",
      talkBgRes = "UI/alpha/HVGA/shop_star_talk_bg_frame.png",
      noneTagRes = "UI/alpha/HVGA/shop_star_none_tag.png",
      titlePos = ccp(403, 382),
      headPos = nil,
      framePos = ccp(400, 220),
      costLabelColor = ccc3(150, 236, 255)
    }
  }
}
function getBuyType(id)
  return type_config[id].buy_type
end
function getGoodsType(id)
  return type_config[id].goods_type
end
function canRefresh(id)
  local handler = type_config[id].canRefresh
  return handler()
end
function getRefreshCoinName(id)
  return type_config[id].refresh_coin_name
end
function getRefreshCoinType(id)
  return type_config[id].refresh_coin_type
end
function getLevelExplaination(id)
  return type_config[id].level_explaination
end
function isShowHotTag(id)
  return type_config[id].show_hot_tag
end
function willAutoExit(id)
  return type_config[id].will_auto_exit
end
function needOpen(id)
  return type_config[id].need_open
end
function needEnterRefresh(id)
  return type_config[id].need_enter_refresh
end
function needFastSell(id)
  return type_config[id].do_fast_sell
end
function getuiConfig(id)
  return type_config[id].ui_config
end
function hasRefreshButton(id)
  if type_config[id].canRefresh ~= nil then
    return true
  end
  return false
end
function getShopName(id)
  return type_config[id].name
end
function getCoinRes(pt)
  local coinRes = {
    gold = "UI/alpha/HVGA/shop_gold_icon.png",
    diamond = "UI/alpha/HVGA/shop_token_icon.png",
    crusadepoint = "UI/alpha/HVGA/money_dragonscale_small.png",
    arenapoint = "UI/alpha/HVGA/money_arenatoken_small.png",
    guildpoint = "UI/alpha/HVGA/money_guildtoken_small.png"
  }
  return coinRes[pt]
end
function getHotTagRes(tt)
  local tag_res = {
    hot = "UI/alpha/HVGA/shop_new.png",
    old = "UI/alpha/HVGA/shop_hot.png"
  }
  return tag_res[tt]
end
function checkPackageFull(eid, amount)
  if (ed.player.equip_qunty[eid] or 0) + amount > ed.parameter.max_item_amount then
    return true
  end
  return false
end
function checkMoneyEnough(pt, cost, id)
  cost = cost or 0
  if pt == "gold" then
    return cost <= ed.player._money
  elseif pt == "diamond" then
    return cost <= ed.player._rmb
  elseif pt == "crusadepoint" then
    return cost <= ed.player:getCrusadeMoney()
  elseif pt == "arenapoint" then
    return cost <= ed.player:getPvpMoney()
  elseif pt == "guildpoint" then
    return cost <= ed.player:getGuildMoney()
  elseif pt == "stone" then
    return cost <= (ed.player.equip_qunty[id] or 0)
  end
  return false
end
function getStarGoodsRes(st)
  local goods_res = {
    stone_green = "UI/alpha/HVGA/shop_star_box_1.png",
    stone_blue = "UI/alpha/HVGA/shop_star_box_2.png",
    stone_purple = "UI/alpha/HVGA/shop_star_box_3.png"
  }
  return goods_res[st]
end
function getStarGoodsName(st)
  local goods_name = {
    stone_green = ed.parameter.starshop_goodsname_small,
    stone_blue = ed.parameter.starshop_goodsname_middle,
    stone_purple = ed.parameter.starshop_goodsname_large
  }
  return goods_name[st]
end
