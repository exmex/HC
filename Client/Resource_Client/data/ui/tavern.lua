local ed = ed
local lsr = ed.ui.tavernlsr.create()
local res = ed.ui.tavernres
local class = {
  mt = {}
}
class.mt.__index = class
ed.ui.tavern = class
local base = ed.ui.framework
setmetatable(class, base.mt)
local parameters = ed.parameter
local box_key = {
  "bronze",
  "gold",
  "silver",
  "magic"
}
class.box_key = box_key
local box_cd = {
  bronze = parameters.tavern_bronze_cd,
  silver = parameters.tavern_silver_cd,
  gold = parameters.tavern_gold_cd,
  magic = parameters.tavern_magic_cd,
}
local box_chance = {
  bronze = parameters.tavern_bronze_chance,
  silver = parameters.tavern_silver_chance,
  gold = parameters.tavern_gold_chance,
  magic = parameters.tavern_magic_chance,
}

--品级关键词
local ex_rank_key = {
  bronze = "Bronze",
  silver = "Silver",
  gold = "Gold",
  magic = "MagicSoul"
}

local doTavernHandler = function(self, box, times)
  local function handler()
    self:doTavern(box, times)
  end
  return handler
end
class.doTavernHandler = doTavernHandler


local function doTavern(self, box, times)
  if self.isTaverning then
    return
  end

  --检查神秘魂匣的开启条件
  if box == "magic" then
    local ulv = ed.playerlimit.getAreaUnlockvip("Magic Soul Box")
    if ulv > ed.player:getvip() then
      ed.showHandyDialog("toRecharge", {
        explaination = T(LSTR("TAVERN.VIP_LEVEL_TO_D_LEVELS_TO_UNLOCK_THIS_FEATURE_NEED_CHARGE"), ulv)
      })
      return
    end
  end

  local isFree = self:isShowFree(box) and times == "one"
  if box == "magic" then
      isFree = self:isShowFree(box)
  end

  local cost = times == "one" and (isFree and 0 or self:getCost(box, times)) or self:getCost(box, times)
  if box == "magic" then
      cost = (isFree and 0 or self:getCost(box, times)) or self:getC6ost(box, times)
  end

  if (times ~= "one" and box ~= "magic") or not isFree then
    local pay = cost.pay
    local number = cost.number
    if pay == "Gold" then
      if number > ed.player._money then
        ed.showHandyDialog("useMidas")
        return
      end
    elseif pay == "Diamond" and number > ed.player._rmb then
      ed.showHandyDialog("toRecharge")
      return
    end
  end

  if box == "bronze" and times == "one" then
    ed.endTeach("FTBronzeOne")
  elseif box == "gold" and times == "one" then
  --add by xinghui
     if --[[ed.tutorial.checkDone("FTBronzeOne") == false--]] ed.tutorial.isShowTutorial then
        ed.sendDotInfoToServer(ed.tutorialres.t_key["FTGoldOne"].id)
     end
          --
    ed.endTeach("FTGoldOne")
  end

  local box_index = {
    bronze = 1,
    silver = 2,
    gold = 3,
    magic = 4
  }
  ed.netdata.tavern = {
    isFree = isFree,
    cost = cost,
    type = box,
    times = times
  }
  ed.netreply.tavern = self:doTavernReply(box, times, isFree, {
    cost = self:getCost(box, times)
  })
  local drawType = 0
  if times == "ten" then
    drawType = 1
  end
  local msg = ed.upmsg.tavern_draw()
  msg._draw_type = drawType
  msg._box_type = box_index[box]
  ed.send(msg, "tavern_draw")
  self.isTaverning = true
end
class.doTavern = doTavern


local function refreshFirstDrawAd(self, box, times)
  local adRes = res.common_ad_res
  if times == "one" and self:isFirstOneDraw(box) then
    local ui = self.ui[box]
    local ad = ui.ad
    local parent = ad:getParent()
    local pos = ccp(ad:getPosition())
    ad:removeFromParentAndCleanup(true)
    local ad = ed.createSprite(adRes[box])
    ad:setPosition(pos)
    parent:addChild(ad)
    ui.ad = ad
  end
end
class.refreshFirstDrawAd = refreshFirstDrawAd


local refreshBoard = function(self, box, isFree)
  if isFree then
    self:createCountdown(box)
  end
end
class.refreshBoard = refreshBoard


--生成抽取物品后的回调
local function doTavernReply(self, box, times, isFree, addition)
  local function handler(loots)
    self.isTaverning = nil
    local destroyHandler
    local tks = self.teachLimitKeys
    local function doTeach(k)
      self.teachLimitType = k
      ed.teach(k, tks[k], {
        tks[k]:getParent(),
        self.mainLayer
      })
    end
    if box == "bronze" and times == "one" and self.teachLimitType == "FTBronzeOne" then
      function destroyHandler()
        doTeach("FTGoldOpen")
      end
    end
    if box == "gold" and times == "one" and self.teachLimitType == "FTGoldOne" then
      function destroyHandler()
        local bb = self.sb_ui.back
        ed.teach("FTbackToMain", bb, {
          bb:getParent(),
          self.mainLayer
        })
        --ed.endTeach("FTbackToMain")

        ed.endTeach("FTintoMain")
      end
      self.teachLimitType = nil
      if not tolua.isnull(self.teachLayer) then
        self.teachLayer:removeFromParentAndCleanup(true)
      end
    end

    self:refreshFirstDrawAd(box, times) --
    self:refreshBoard(box, isFree)  --免费的时候才重新开始CD倒计时,花钱的不会更新倒计时
    addition.destroyHandler = destroyHandler
    local popWindow = ed.ui.poptavernloot.create({
      type = box,
      times = times,
      loots = loots,
      addition = addition
    })
    popWindow.tavernHandler = self:doTavernHandler(box, times)
    if not tolua.isnull(self.mainLayer) then
      self.mainLayer:addChild(popWindow.mainLayer, 150)
    end
  end
  return handler
end
class.doTavernReply = doTavernReply

local function getTable(self)
  return ed.getDataTable("TavernType")
end
class.getTable = getTable

--获取酒馆付费信息
local function getCost(self, box, times)
  local tn = ex_rank_key
  local isten = times == "ten"
  isten = tostring(isten)
  local tt = self:getTable()
  local row = tt[tn[box]][isten]['false'][0]
  return {
    pay = row["Cost Type"],
    number = row.Cost
  }
end
class.getCost = getCost

--
local function getExRank(self, box)
  local tn = ex_rank_key
  local tt = self:getTable()
  return tt[tn[box]]['true']['false'][0]["Exhibition Rank"]
end
class.getExRank = getExRank

--获取剩余的免费次数
local function getLeftTimes(box)
  return ed.player:getTavernLeftTimes(box)
end
class.getLeftTimes = getLeftTimes

--获取抽取的CD倒计时
local function getCountdown(box)
  if not box_cd[box] then
    return nil
  end
  local record = ed.player:getTavernRecord(box)
  local lgt = record._last_get_time
  local stime = ed.getServerTime()
  local dt = stime - lgt
  if dt > box_cd[box] then
    return nil
  else
    return box_cd[box] - dt
  end
end
class.getCountdown = getCountdown


local function getCountdownText(self, box)
  local tl = box_chance
  local count = getCountdown(box)
  if (count or 0) <= 0 then
    local text = ""
    if box == "bronze" then
      local times = getLeftTimes(box)
      if times > 0 then
        text = T(LSTR("TAVERN.FREE_TIMES__D_D"), times, tl[box])
      else
        text = T(LSTR("TAVERN.FREE_TIMES_RUNS_OUT_FOR_TODAY"))
      end
    end
    return false, text
  else
    return true, ed.gethmsNString(count)
  end
end
class.getCountdownText = getCountdownText


local function isFirstDraw(self, box)
  local record = ed.player:getTavernRecord(box)
  local ifd = record._has_first_draw
  return {
    ed.bits(ifd, 16, 16) == 0,
    ed.bits(ifd, 0, 16) == 0
  }
end
class.isFirstDraw = isFirstDraw
local isFirstOneDraw = function(self, box)
  local ifd = self:isFirstDraw(box)
  return ifd[1]
end
class.isFirstOneDraw = isFirstOneDraw
local isFirstTenDraw = function(self, box)
  local ifd = self:isFirstDraw(box)
  return ifd[2]
end
class.isFirstTenDraw = isFirstTenDraw

local function isShowFree(self, box)
  --[[if box == "magic" then
    return false
  end]]

  local count = getCountdown(box)
  local ccc = getLeftTimes(box)
  if not count and getLeftTimes(box) > 0 then
    return true
  end
  return false
end
class.isShowFree = isShowFree

local function refreshCost(self, type)
  local ui = self.ui[type]
  local layer = ui.scroll_board
  local isFree = self:isShowFree(type)
  local iconres = {
    bronze = "UI/alpha/HVGA/task_gold_icon_2.png",
    silver = "UI/alpha/HVGA/task_rmb_icon_2.png",
    gold = "UI/alpha/HVGA/task_rmb_icon_2.png",
    magic = "UI/alpha/HVGA/task_rmb_icon_2.png",
  }

  --判空
  if not tolua.isnull(layer) then
      if isFree then
          if not tolua.isnull(ui.cost_icon) then
              ui.cost_icon:removeFromParentAndCleanup(true)
              ui.cost:removeFromParentAndCleanup(true)
              ui.cost_icon = nil
              ui.cost = nil
          end
          if tolua.isnull(ui.cost_label) then
              local cost_label = ed.createttf(T(LSTR("GUILDCONFIG.FREE")), 18)
              cost_label:setPosition(ccp(103, 105))
              layer:addChild(cost_label)
              ui.cost_label = cost_label
          end
          ed.setString(ui.one_cost, T(LSTR("GUILDCONFIG.FREE")))
          if type == "magic" then
              ed.setString(ui.ten_cost, T(LSTR("GUILDCONFIG.FREE")))
          end
      else
          if not tolua.isnull(ui.cost_label) then
              ui.cost_label:removeFromParentAndCleanup(true)
              ui.cost_label = nil
          end
          if tolua.isnull(ui.cost_icon) then
              local icon = ed.createSprite(iconres[type])
              icon:setPosition(ccp(65, 103))
              layer:addChild(icon)
              ui.cost_icon = icon
          end
          if tolua.isnull(ui.cost) then
              local cost = {}
              if type == "magic" then
                  cost = ed.createttf(self:getCost(type, "ten").number, 18)
              else
                  cost = ed.createttf(self:getCost(type, "one").number, 18)
              end

              cost:setAnchorPoint(ccp(1, 0.5))
              cost:setPosition(ccp(155, 105))
              layer:addChild(cost)
              ui.cost = cost
          end

          if type == "magic" then
              ed.setString(ui.one_cost, self:getCost(type, "ten").number)
              ed.setString(ui.ten_cost, self:getCost(type, "ten").number)
          else
              ed.setString(ui.one_cost, self:getCost(type, "one").number)
          end
      end
  end

end
class.refreshCost = refreshCost


local function refreshCountdownHandler(self, type, ui)
  local count = 0
  local countDownType = {}
  local function handler(dt)
    count = count + dt
    if count > 1 then
      count = count - 1
    end
    local countdown = getCountdown(type)
    if (countdown or 0) <= 0 then
      countdown = 0
      self:createCountdown(type)
      if getLeftTimes(type) > 0 then
        ed.setString(ui.cost_label, T(LSTR("GUILDCONFIG.FREE")))
        ed.setString(ui.one_cost, T(LSTR("GUILDCONFIG.FREE")))
      end
    else
      self:createCountdown(type)
      ed.setString(ui.countLabel, ed.gethmsNString(countdown))
      ed.setString(ui.oneCountLabel, ed.gethmsNString(countdown))

      if type == "magic" then
          ed.setString(ui.cost_label, self:getCost(type, "ten").number)
          ed.setString(ui.one_cost, self:getCost(type, "ten").number)
      else
          ed.setString(ui.cost_label, self:getCost(type, "one").number)
          ed.setString(ui.one_cost, self:getCost(type, "one").number)
      end


    end
  end
  return handler
end
class.refreshCountdownHandler = refreshCountdownHandler


local function createCountdown(self, type)
  self.countType = self.countType or {}
  local ui = self.ui[type]
  local layer = ui.scroll_board
  local isCount, text = self:getCountdownText(type)
  if not isCount then
    if self.countType[type] == "free" then
      return
    end
    self.countType[type] = "free"
    local check_node = {
      ui.countLabel,
      ui.countSuffix,
      ui.oneCountLabel,
      ui.oneCountSuffix
    }
    for i = 1, #check_node do
      local node = check_node[i]
      if not tolua.isnull(node) then
        node:removeFromParentAndCleanup(true)
      end
    end
    local ui_info = {
      {
        t = "Label",
        base = {
          name = "countLabel",
          text = text,
          size = 18
        },
        layout = {
          position = ccp(103, 135)
        }
      },

    }

    if type ~= "magic" then
        table.insert(ui_info, {
            t = "Label",
            base = {
                name = "oneCountLabel",
                text = text,
                size = 18
            },
            layout = {
                position = ccp(103, -53)
            }
        })
    end

    local readnode = ed.readnode.create(layer, ui)
    readnode:addNode(ui_info)
    self:refreshCost(type)
  else
    if self.countType[type] == "count" then
      return
    end
    self.countType[type] = "count"
    local check_node = {
      ui.countLabel,
      ui.oneCountLabel
    }
    for i = 1, #check_node do
      local node = check_node[i]
      if not tolua.isnull(node) then
        node:removeFromParentAndCleanup(true)
      end
    end
    local ui_info = {
      {
        t = "Label",
        base = {
          name = "countLabel",
          text = text,
          size = 18
        },
        layout = {
          anchor = ccp(1, 0.5),
          position = ccp(175, 135)
        },
        config = {
          color = ccc3(231, 206, 19)
        }
      },
      {
        t = "Label",
        base = {
          name = "countSuffix",
          text = T(LSTR("TAVERN.WILL_BE_FREE")),
          size = 18
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(35, 135)
        },
        config = {}
      },


    }

    if type ~= "magic" then
        table.insert(ui_info, {
            t = "Label",
            base = {
                name = "oneCountLabel",
                text = text,
                size = 18
            },
            layout = {
                anchor = ccp(1, 0.5),
                position = ccp(175, -50)
            },
            config = {
                color = ccc3(231, 206, 19)
            }
        })

        table.insert(ui_info, {
            t = "Label",
            base = {
                name = "oneCountSuffix",
                text = T(LSTR("TAVERN.WILL_BE_FREE")),
                size = 18
            },
            layout = {
                anchor = ccp(0, 0.5),
                position = ccp(35, -50)
            },
            config = {}
        })
    end

    local readnode = ed.readnode.create(layer, ui)
    readnode:addNode(ui_info)
    self:refreshCost(type)
  end
end
class.createCountdown = createCountdown


local getArrowudAnim = function(self)
  local d = CCMoveBy:create(1, ccp(0, -5))
  d = CCEaseSineInOut:create(d)
  local u = d:reverse()
  local s = CCSequence:createWithTwoActions(d, u)
  s = CCRepeatForever:create(s)
  return s
end
class.getArrowudAnim = getArrowudAnim


local function playLightAnim(self)
  local keys = box_key or {}
  for k, v in pairs(keys) do
    local ui = self.ui[v]
    if ui then
      local light = ui.light
      if not tolua.isnull(light) and ed.isElementInTable(v, {"gold", "magic"}) then
        local r = CCRotateBy:create(5, 360)
        r = CCRepeatForever:create(r)
        light:runAction(r)
      end
    end
  end
end
class.playLightAnim = playLightAnim


local function createBaseBoard(self, param)
  param = param or {}
  local key = param.key
  local pos = param.pos or ccp(0, 0)
  local ui = {}
  self.ui[key] = ui
  local container = CCLayer:create()
  ui.container = container
  container:setPosition(pos)
  self.dragLayer:addChild(container)
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "board_bg",
        res = res.board_bg[key]
      },
      layout = {
        position = ccp(160, 205)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "board_title_bg",
        res = "UI/alpha/HVGA/tavern_title_bg.png"
      },
      layout = {
        position = ccp(160, 340)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "board_title",
        res = res.board_title[key]
      },
      layout = {
        position = ccp(160, 355)
      },
      config = {}
    }
  }
  local readnode = ed.readnode.create(container, ui)
  readnode:addNode(ui_info)
  local clipLayer = CCLayer:create()
  ui.board_bg:addChild(clipLayer)
  clipLayer:setClipRect(CCRectMake(0, 25, 206, 320))
  local board = CCLayer:create()
  ui.scroll_board = board
  clipLayer:addChild(board)
end
class.createBaseBoard = createBaseBoard
local function createCommonLayer(self, param)
  param = param or {}
  local key = param.key
  if not key then
    return
  end
  self:createBaseBoard(param)
  local ui = self.ui[key]
  local board = ui.scroll_board
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "light",
        res = res.light_res[key]
      },
      layout = {
        position = ccp(109, 270)
      },
      config = {
        visible = res.is_light_visible[key]
      }
    },
    {
      t = "Sprite",
      base = {
        name = "box",
        res = res.box_res[key]
      },
      layout = {
        position = ccp(109, 270)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "ad",
        res = self:isFirstOneDraw(key) and res.first_ad_res[key] or res.common_ad_res[key]
      },
      layout = {
        position = ccp(109, 175)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "cost_bg",
        res = "UI/alpha/HVGA/tavern_cost_bg.png"
      },
      layout = {
        position = ccp(109, 105)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "check",
        res = "UI/alpha/HVGA/tavern_button_1.png"
      },
      layout = {
        position = ccp(109, 60)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "check_press",
        res = "UI/alpha/HVGA/tavern_button_2.png",
        parent = "check"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "check_label",
        text = T(LSTR("RECHARGE.VIEW")),
        fontinfo = "ui_normal_button",
        size = 20,
        parent = "check"
      },
      layout = {
        position = ccp(64, 24)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "arrow",
        res = "UI/alpha/HVGA/tavern_up.png"
      },
      layout = {
        position = ccp(109, 0)
      },
      config = {}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "one_bg",
        res = "UI/alpha/HVGA/tavern_cost_frame.png",
        capInsets = CCRectMake(40, 0, 57, 32)
      },
      layout = {
        position = ccp(109, -87)
      },
      config = {
        scaleSize = CCSizeMake(100, 32)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "one_Icon",
        res = self:getCost(key, "one").pay == "Gold" and "UI/alpha/HVGA/task_gold_icon_2.png" or "UI/alpha/HVGA/task_rmb_icon_2.png"
      },
      layout = {
        position = ccp(64, -87)
      },
      config = {
        scale = self:getCost(key, "one").pay == "Gold" and 1.0 or 1.2
      }
    },
    {
      t = "Label",
      base = {
        name = "one_cost",
        text = self:getCost(key, "one").number,
        size = 18
      },
      layout = {
        anchor = ccp(1, 0.5),
        position = ccp(144, -87)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "one_buy",
        res = "UI/alpha/HVGA/tavern_button_normal_1.png"
      },
      layout = {
        position = ccp(109, -130)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "one_buy_press",
        res = "UI/alpha/HVGA/tavern_button_normal_2.png",
        parent = "one_buy"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "one_buy_label",
        text = T(LSTR("TAVERN.BUY__D"), 1),
        fontinfo = "ui_normal_button",
        size = 20,
        parent = "one_buy"
      },
      layout = {
        position = ccp(64, 24)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "ten_bg",
        res = "UI/alpha/HVGA/tavern_cost_frame.png",
        capInsets = CCRectMake(40, 0, 57, 32)
      },
      layout = {
        position = ccp(109, -212)
      },
      config = {
        scaleSize = CCSizeMake(100, 32)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "ten_Icon",
        res = self:getCost(key, "ten").pay == "Gold" and "UI/alpha/HVGA/task_gold_icon_2.png" or "UI/alpha/HVGA/task_rmb_icon_2.png"
      },
      layout = {
        position = ccp(64, -213)
      },
      config = {
        scale = self:getCost(key, "ten").pay == "Gold" and 1.0 or 1.2
      }
    },
    {
      t = "Label",
      base = {
        name = "ten_cost",
        text = self:getCost(key, "ten").number,
        size = 18
      },
      layout = {
        anchor = ccp(1, 0.5),
        position = ccp(144, -212)
      }
    },
    {
      t = "Label",
      base = {
        name = "ten_prompt",
        text = res.ten_prompt[key],
        size = 18
      },
      layout = {
        position = ccp(108, -180)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "ten_buy",
        res = "UI/alpha/HVGA/tavern_button_1.png"
      },
      layout = {
        position = ccp(109, -260)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "ten_buy_press",
        res = "UI/alpha/HVGA/tavern_button_2.png",
        parent = "ten_buy"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "ten_buy_label",
        text = T(LSTR("TAVERN.BUY__D"), 10),
        fontinfo = "ui_normal_button",
        size = 20,
        parent = "ten_buy"
      },
      layout = {
        position = ccp(75, 24)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "ad_discount",
        res = "UI/alpha/HVGA/tavern_ad_discount.png",
        parent = "ten_buy"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(1, 2)
      },
      config = {}
    }
  }
  local readNode = ed.readnode.create(board, ui)
  readNode:addNode(ui_info)
  local aa = self:getArrowudAnim()
  ui.arrow:runAction(aa)
end
class.createCommonLayer = createCommonLayer

--刷新各箱子的CD显示
local refreshBoxCountdown = function(self, key)
  self:refreshCost(key)
  self:createCountdown(key)
  self:registerUpdateHandler("countdown" .. key, self:refreshCountdownHandler(key, self.ui[key]))
end
class.refreshBoxCountdown = refreshBoxCountdown


local function createMagicLayer(self)
  local param = {
    key = "magic",
    pos = ccp(480, 0)
  }
  local key = param.key
  if not key then
    return
  end
  self:createBaseBoard(param)
  local ui = self.ui[key]
  local board = ui.scroll_board
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "light",
        res = res.light_res[key]
      },
      layout = {
        position = ccp(110, 250)
      },
      config = {
        visible = res.is_light_visible[key]
      }
    },
    {
      t = "Sprite",
      base = {
        name = "box_bg",
        res = "UI/alpha/HVGA/tavern_magicsoul_mark1.png"
      },
      layout = {
        position = ccp(110, 250)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "box",
        res = res.box_res[key]
      },
      layout = {
        position = ccp(110, 280)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "ad",
        res = self:isFirstOneDraw(key) and res.first_ad_res[key] or res.common_ad_res[key]
      },
      layout = {
        position = ccp(110, 230)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "cost_bg",
        res = "UI/alpha/HVGA/tavern_cost_bg.png"
      },
      layout = {
        position = ccp(110, 105)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "arrow",
        res = "UI/alpha/HVGA/tavern_up.png"
      },
      layout = {
        position = ccp(110, 0)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "check",
        res = "UI/alpha/HVGA/tavern_button_1.png"
      },
      layout = {
        position = ccp(110, 60)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "check_press",
        res = "UI/alpha/HVGA/tavern_button_2.png",
        parent = "check"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "check_label",
        text = T(LSTR("RECHARGE.VIEW")),
        fontinfo = "ui_normal_button",
        size = 20,
        parent = "check"
      },
      layout = {
        position = ccp(64, 24)
      },
      config = {}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "drop_bg_left",
        res = "UI/alpha/HVGA/tavern_magicsoul_hero_bg.png",
        capInsets = CCRectMake(10, 10, 20, 20)
      },
      layout = {
        position = ccp(82, 175)
      },
      config = {
        scaleSize = CCSizeMake(130, 50)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "drop_bg_right",
        res = "UI/alpha/HVGA/tavern_magicsoul_hero_bg.png",
        capInsets = CCRectMake(10, 10, 20, 20)
      },
      layout = {
        position = ccp(175, 175)
      },
      config = {
        scaleSize = CCSizeMake(50, 50)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "drop_bg_day",
        res = "UI/alpha/HVGA/tavern_magicsoul_hero_bg.png",
        capInsets = CCRectMake(10, 10, 20, 20)
      },
      layout = {
        position = ccp(107, -130)
      },
      config = {
        scaleSize = CCSizeMake(150, 75)
      }
    },
    {
      t = "Label",
      base = {
        name = "drop_day_title",
        text = T(LSTR("TAVERN.TODAYS_HIGHLIGHT")),
        size = 18
      },
      layout = {
        position = ccp(107, -106)
      },
      config = {}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "drop_bg_month",
        res = "UI/alpha/HVGA/tavern_magicsoul_hero_bg.png",
        capInsets = CCRectMake(10, 10, 20, 20)
      },
      layout = {
        position = ccp(107, -52)
      },
      config = {
        scaleSize = CCSizeMake(150, 75)
      }
    },
    {
      t = "Label",
      base = {
        name = "drop_month_title",
        text = T(LSTR("TAVERN.HOT_IN_THIS_WEEK")),
        size = 18
      },
      layout = {
        position = ccp(107, -30)
      },
      config = {}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "ten_bg",
        res = "UI/alpha/HVGA/tavern_cost_frame.png",
        capInsets = CCRectMake(40, 0, 57, 32)
      },
      layout = {
        position = ccp(110, -212)
      },
      config = {
        scaleSize = CCSizeMake(100, 32)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "ten_Icon",
        res = self:getCost(key, "ten").pay == "Gold" and "UI/alpha/HVGA/task_gold_icon_2.png" or "UI/alpha/HVGA/task_rmb_icon_2.png"
      },
      layout = {
        position = ccp(64, -213)
      },
      config = {
        scale = self:getCost(key, "ten").pay == "Gold" and 1.0 or 1.2
      }
    },
    {
      t = "Label",
      base = {
        name = "ten_cost",
        text = self:getCost(key, "ten").number,
        size = 18
      },
      layout = {
        anchor = ccp(1, 0.5),
        position = ccp(144, -212)
      }
    },
    {
      t = "Label",
      base = {
        name = "combo_prompt",
        text = res.ten_prompt[key],
        size = 18
      },
      layout = {
        position = ccp(110, -183)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "ten_buy",
        res = "UI/alpha/HVGA/tavern_button_1.png"
      },
      layout = {
        position = ccp(110, -260)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "ten_buy_press",
        res = "UI/alpha/HVGA/tavern_button_2.png",
        parent = "ten_buy"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    },
    {
      t = "Label",
      base = {
        name = "ten_buy_label",
        text = T(LSTR("TAVERN.BUY__D"),1),
        fontinfo = "ui_normal_button",
        size = 20,
        parent = "ten_buy"
      },
      layout = {
        position = ccp(68, 24)
      }
    }
  }
  local readnode = ed.readnode.create(board, ui)
  readnode:addNode(ui_info)
end
class.createMagicLayer = createMagicLayer
local function getMagicHeroRow(self)
  local nt = ed.serverTime2China()
  local y, mon, d, h, m, s = ed.time2YMDHMS(nt)
  local boa = ed.checkBOA({
    h = h,
    m = m,
    s = s
  })
  local y, m, d
  if boa == "after" then
    y, m, d = ed.time2YMD(nt)
  else
    y, m, d = ed.time2YMD(nt - 86400)
  end
  y = tonumber(y)
  m = tonumber(m)
  d = tonumber(d)
  local tdh = ed.getDataTable("TavernDailyHero")
  local row = tdh[y][m][d]
  return row
end
class.getMagicHeroRow = getMagicHeroRow

local function getMagicHero(self)
  local hids = self.magicsoulList
  local ids = {}
  for i = 1, 3 do
    local sid = hids[i + 1]
    local ht = ed.itemType(sid)
    if ht == "equip" then
      ids[i] = ed.readequip.getComposedID(sid)
    elseif ht == "hero" then
      ids[i] = sid
    end
  end
  return ids
end
class.getMagicHero = getMagicHero

local function getMagicExtraHero(self)
  local hids = self.magicsoulList
  local id = hids[1]
  local ht = ed.itemType(id)
  if ht == "equip" then
    return ed.readequip.getComposedID(id)
  elseif ht == "hero" then
    return id
  end
end
class.getMagicExtraHero = getMagicExtraHero

local function doRefrehMagicHeroIcon(self)
  if not self.magicsoulList then
    LegendLog("Can not get the hero list.")
    return
  end
  local ui = self.ui.magic
  local board = ui.scroll_board
  ui.heroIcons = {}

  --UI界面的上半截开始
  local left = {}
  ui.heroIcons.left = left
  local hids = self:getMagicHero()
  local ox, oy = 42, 175
  local dx = 40
  for i = 1, 3 do
    local id = hids[i]
    local icon = ed.readhero.createIcon({id = id, length = 38}).icon
    icon:setPosition(ccp(ox + dx * (i - 1), oy))
    if not tolua.isnull(board) then
      board:addChild(icon)
    end
    left[i] = {icon = icon, id = id}
  end

  local right = {}
  ui.heroIcons.right = right
  local id = self:getMagicExtraHero()
  local icon = ed.readhero.createIcon({id = id, length = 38}).icon
  icon:setPosition(ccp(175, 175))
  if not tolua.isnull(board) then
      board:addChild(icon)
  end
  right[1] = {icon = icon, id = id }

  --每天的三个灵魂石   UI界面的下半截
  local day = {}
  ui.heroIcons.day = day
  local ox, oy = 66, -140
  local dx = 42
  for i = 1, 3 do
    local id = hids[i]
    local icon = ed.readhero.createIcon({id = id, length = 38}).icon
    icon:setPosition(ccp(ox + dx * (i - 1), oy))
    if not tolua.isnull(board) then
        board:addChild(icon)
    end
    day[i] = {icon = icon, id = id}
  end

  --月度灵魂石
  local month = {}
  ui.heroIcons.month = month
  local id = self:getMagicExtraHero()
  local icon = ed.readhero.createIcon({id = id, length = 38}).icon
  icon:setPosition(ccp(107, -63))
  if not tolua.isnull(board) then
      board:addChild(icon)
  end
  month[1] = {icon = icon, id = id }

end
class.doRefrehMagicHeroIcon = doRefrehMagicHeroIcon


local function refreshMagicHeroIcon(self)
  function ed.netreply.askMagicsoul(ids)
    xpcall(function()
      self.magicsoulList = ids
      self:doRefrehMagicHeroIcon()
      if self.createBoxCountdown then
        self.createBoxCountdown()
      end
    end, EDDebug)
  end
  local msg = ed.upmsg.ask_magicsoul()
  ed.send(msg, "ask_magicsoul")
end
class.refreshMagicHeroIcon = refreshMagicHeroIcon


local createItemLayer = function(self)
  local ui = self.ui
  local params = {
    {key = "bronze"},
    {
      key = "gold",
      pos = ccp(240, 0)
    }
  }
  for i = 1, #params do
    self:createCommonLayer(params[i])
  end

  self:createMagicLayer()

  table.insert(params, {key = "magic"})

  --刷新CD
  function self.createBoxCountdown()
      for k, v in pairs(params) do
          local key = v.key
          self:refreshBoxCountdown(key)
      end
  end

  self:refreshItemLayer()
  self:playLightAnim()
end
class.createItemLayer = createItemLayer


local function refreshItemLayer(self)
  local showvip = ed.playerlimit.getAreaShowvip("Magic Soul Box")
  local vip = ed.player:getvip()
  local bronzeLayer = self.ui.bronze.container
  local goldLayer = self.ui.gold.container
  local magicLayer = self.ui.magic.container
  if showvip > vip then
    magicLayer:setVisible(false)
    bronzeLayer:setPosition(ccp(95, 0))
    goldLayer:setPosition(ccp(400, 0))
  else
    magicLayer:setVisible(true)
    bronzeLayer:setPosition(ccp(0, 0))
    goldLayer:setPosition(ccp(240, 0))
  end
end
class.refreshItemLayer = refreshItemLayer


local function createDragLayer(self)
  local info = {
    cliprect = CCRectMake(0, 0, 800, 480),
    noshade = true,
    container = self.container,
    priority = 5,
    bar = {
      bglen = 600,
      bgpos = ccp(400, 10),
      direction = "horizontal"
    }
  }
  self.draglist = ed.draglist.create(info)
  local dragLayer = CCLayer:create()
  self.dragLayer = dragLayer
  self.draglist:addItem(self.dragLayer)
end
class.createDragLayer = createDragLayer


local function create()
  local self = base.create("tavern")
  setmetatable(self, class.mt)
  local scene = self.scene
  local mainLayer = self.mainLayer
  local container = CCLayer:create()
  self.container = container
  mainLayer:addChild(container)
  self:createDragLayer()
  self:createItemLayer()
  self:btRegisterHandler({
    handler = self:getMainTouchHandler(),
    key = "tavern_main"
  })
  if not ed.tutorial.checkDone("FTGoldOne") then
    self.teachLayer = CCLayer:create()
    self.teachLayer:setTouchEnabled(true)
    self.teachLayer:registerScriptTouchHandler(self:getMainTouchHandler(), false, -150, true)
    self.mainLayer:addChild(self.teachLayer)
  end
  self:createFirstTeach()
  self:createTavernEnchTeach()
  self:registerOnEnterHandler("enterTavern", self:enterTavern())
  return self
end
class.create = create
local enterTavern = function(self)
  local function handler()
    self:refreshMagicHeroIcon()
  end
  return handler
end
class.enterTavern = enterTavern
local function createTavernEnchTeach(self)
  local button = self.ui.bronze.check
  ed.teach("openTavernEnch", button, {
    button:getParent(),
    self.mainLayer
  })
end
class.createTavernEnchTeach = createTavernEnchTeach
local function createFirstTeach(self)
  local okeys = {
    "FTBronzeOpen",
    "FTBronzeOne",
    "FTGoldOpen",
    "FTGoldOne"
  }
  local keys = {
    FTBronzeOpen = self.ui.bronze.check,
    FTBronzeOne = self.ui.bronze.one_buy,
    FTGoldOpen = self.ui.gold.check,
    FTGoldOne = self.ui.gold.one_buy
  }
  self.teachLimitKeys = keys
  for i, v in ipairs(okeys) do
    if not ed.tutorial.checkDone(v) then
      self.teachLimitType = v
      break
    end
  end
  local sb = {
    {
      sb = "FTBronzeOne",
      psb = "FTBronzeClose",
      key = "bronze"
    },
    {
      sb = "FTGoldOne",
      psb = nil,
      key = "gold"
    }
  }
  for i = 1, #sb do
    local a = sb[i]
    if a.psb then
      ed.endTeach(a.psb)
    end
    if self.teachLimitType == a.sb then
      self:doClickCheck(a.key)
    end
  end
  if self.teachLimitType then
    local box = self.teachLimitType
    ed.teach(box, keys[box], {
      keys[box]:getParent(),
      self.mainLayer
    })
  end
end
class.createFirstTeach = createFirstTeach


local function doClickCheck(self, box)
    
  local tlt = {
    bronze = {
      t = "FTBronzeOpen",
      nt = "FTBronzeOne",
      btn = self.ui.bronze.one_buy
    },
    gold = {
      t = "FTGoldOpen",
      nt = "FTGoldOne",
      btn = self.ui.gold.one_buy
    }
  }
  local tv = tlt[box]
  if tv then
  --add by xinghui
    if --[[ed.tutorial.checkDone("FTBronzeOpen") == false--]] ed.tutorial.isShowTutorial then
        ed.sendDotInfoToServer(ed.tutorialres.t_key[tv.t].id)
    end
  --
    ed.endTeach(tv.t)
    ed.teach(tv.nt, tv.btn, {
      tv.btn:getParent(),
      self.mainLayer
    })
    if self.teachLimitType == tv.t then
      self.teachLimitType = tv.nt
    end
  end
  if box == "bronze" then
    ed.endTeach("openTavernEnch")
    local button = self.ui.bronze.one_buy
    ed.teach("tavernEnch", button, {
      button:getParent(),
      self.mainLayer
    })
  end
  local preid = self.checkid
  self.checkid = box
  local b = self.ui[box].scroll_board
  local m = CCMoveTo:create(0.2, ccp(0, 320))
  m = CCEaseSineIn:create(m)
  b:runAction(m)
  lsr:report("scrollBoardAnim")
end
class.doClickCheck = doClickCheck
local doClickArrow = function(self, key)
  local b = self.ui[key].scroll_board
  local m = CCMoveTo:create(0.2, ccp(0, 0))
  m = CCEaseSineOut:create(m)
  b:runAction(m)
end
class.doClickArrow = doClickArrow
local function doCheckTouch(self, key)
  local isPress
  local report_event = {
    bronze = "clickBronzeBuy",
    silver = "clickSilverBuy",
    gold = "clickGoldBuy"
  }
  local function handler(event, x, y)
    local ui = self.ui[key]
    local button = ui.check
    local press = ui.check_press
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        if ed.containsPoint(button, x, y) then
          lsr:report(report_event[key])
          self:doClickCheck(key)
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doCheckTouch = doCheckTouch


local function doOneTouch(self, key)
  local isPress
  local report_event = {
    bronze = "clickBronzeOnce",
    silver = "clickSilverOnce",
    gold = "clickGoldOnce"
  }
  local function handler(event, x, y)
    local ui = self.ui[key]
    local button = ui.one_buy
    local press = ui.one_buy_press
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        if ed.containsPoint(button, x, y) then
          lsr:report(report_event[key])
          self:doTavern(key, "one")
          if key == "bronze" then
            ed.endTeach("tavernEnch")
          end
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doOneTouch = doOneTouch


local function doTenTouch(self, key)
  local isPress
  local report_event = {
    bronze = "clickBronzeTen",
    silver = "clickSilverTen",
    gold = "clickGoldTen"
  }
  local function handler(event, x, y)
    local ui = self.ui[key]
    local button = ui.ten_buy
    local press = ui.ten_buy_press
    if event == "began" then
      if ed.containsPoint(button, x, y) then
        isPress = true
        press:setVisible(true)
      end
    elseif event == "ended" then
      if isPress then
        press:setVisible(false)
        if ed.containsPoint(button, x, y) then
          lsr:report(report_event[key])
          self:doTavern(key, "ten")
        end
      end
      isPress = nil
    end
  end
  return handler
end
class.doTenTouch = doTenTouch


local function doArrowTouch(self)
  local keys = box_key
  local rect = CCRectMake(-20, -15, 60, 60)
  local key
  local function handler(event, x, y)
    if event == "began" then
      for i = 1, #keys do
        if self.ui[keys[i]] then
          local button = self.ui[keys[i]].arrow
          if tolua.isnull(button) then
            return
          end
          if ed.isPointInRect(rect, x, y, button) then
            key = keys[i]
            button:setScale(0.95)
            break
          end
        end
      end
    elseif event == "ended" then
      if key and self.ui[key] then
        local button = self.ui[key].arrow
        if tolua.isnull(button) then
          return
        end
        button:setScale(1)
        if ed.isPointInRect(rect, x, y, button) then
          self:doClickArrow(key)
        end
      end
      key = nil
    end
  end
  return handler
end
class.doArrowTouch = doArrowTouch
local function createMagicHeroDetail(self, param)
  local icon = param.icon
  local id = param.id
  local panel = ed.readequip.getDetailCard(id, nil)
  local pos = icon:getParent():convertToWorldSpace(ccp(icon:getPosition()))
  panel:setAnchorPoint(ccp(1, 0.5))
  panel:setPosition(ccpAdd(pos, ccp(-20, 0)))
  self.container:addChild(panel, 100)
  self.magicHeroCard = panel
end
class.createMagicHeroDetail = createMagicHeroDetail
local destroyMagicHeroDetail = function(self)
  if not tolua.isnull(self.magicHeroCard) then
    self.magicHeroCard:removeFromParentAndCleanup(true)
    self.magicHeroCard = nil
  end
end
class.destroyMagicHeroDetail = destroyMagicHeroDetail


local function doMagicHeroIconTouch(self)
  local function handler(event, x, y)
    if event == "began" then
      local icons = self.ui.magic.heroIcons or {}
      for k, v in pairs(icons) do
        for ck, cv in pairs(v) do
          if ed.containsPoint(cv.icon, x, y) then
            self:createMagicHeroDetail(cv)
            break
          end
        end
      end
    elseif event == "ended" then
      self:destroyMagicHeroDetail()
    end
  end
  return handler
end
class.doMagicHeroIconTouch = doMagicHeroIconTouch


local getMainTouchHandler = function(self)
  local common_keys = {
    "bronze",
    "silver",
    "gold"
  }
  local checkTouch = {}
  local oneTouch = {}
  local tenTouch = {}
  for i = 1, #common_keys do
    local key = common_keys[i]
    if self.ui[key] then
      checkTouch[key] = self:doCheckTouch(key)
      oneTouch[key] = self:doOneTouch(key)
      tenTouch[key] = self:doTenTouch(key)
    end
  end
  local arrowTouch = self:doArrowTouch()
  local magicCheckTouch = self:doCheckTouch("magic")
  local magicTenTouch = self:doTenTouch("magic")
  local magicHeroTouch = self:doMagicHeroIconTouch()
  self.teachLimit = {
    FTBronzeOpen = checkTouch.bronze,
    FTBronzeOne = oneTouch.bronze,
    FTGoldOpen = checkTouch.gold,
    FTGoldOne = oneTouch.gold
  }
  local function handler(event, x, y)
    xpcall(function()
      local type = self.teachLimitType
      if type then
        self.teachLimit[type](event, x, y)
        return
      end
      for i = 1, #common_keys do
        local key = common_keys[i]
        if checkTouch[key] then
          checkTouch[key](event, x, y)
        end
        if oneTouch[key] then
          oneTouch[key](event, x, y)
        end
        if tenTouch[key] then
          tenTouch[key](event, x, y)
        end
      end
      if self.ui.magic.container:isVisible() then
        magicCheckTouch(event, x, y)
        magicTenTouch(event, x, y)
        magicHeroTouch(event, x, y)
      end
      arrowTouch(event, x, y)
    end, EDDebug)
    return true
  end
  return handler
end
class.getMainTouchHandler = getMainTouchHandler
