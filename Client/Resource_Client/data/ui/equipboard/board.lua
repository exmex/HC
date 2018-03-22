local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.equipboard = class
local doFadeOut = function(self, callback)
  local fo = CCFadeOut:create(0.5)
  local func = CCCallFunc:create(function()
    xpcall(function()
      if callback then
        callback()
      end
    end, EDDebug)
  end)
  if not tolua.isnull(self.ui.frame) then
    self.ui.frame:runAction(ed.readaction.create({
      t = "seq",
      fo,
      func
    }))
  end
end
class.doFadeOut = doFadeOut
local refreshAmount = function(self)
  local ui = self.ui
  local label = ui.amount_label
  local amount = ed.player.equip_qunty[self.param.id]
  ed.setLabelString(label, amount)
  if amount == 0 then
    ed.setLabelColor(label, ccc3(255, 0, 0))
  else
    ed.setLabelColor(label, ccc3(0, 71, 188))
  end
  if not tolua.isnull(ui.fragment_amount) then
    ed.setString(ui.fragment_amount, string.format("%d/%d", amount, self.uinfo.need))
  end
  return amount
end
class.refreshAmount = refreshAmount
local initAmount = function(self, addition)
  addition = addition or {}
  if not addition.forceShow and self.param.level then
    return
  end
  local id = self.param.id
  local amount = ed.player.equip_qunty[id] or 0
  local amountColor = ccc3(0, 71, 188)
  if amount == 0 then
    amountColor = ccc3(255, 0, 0)
  end
  local ui = self.ui
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "amount_title",
        text = T(LSTR("EQUIPINFO.HAVE"), tostring(amount)),
        size = 20
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(90, 310)
      },
      config = {
        color = ccc3(67, 59, 56)
      }
    },
    {
      t = "Label",
      base = {
        name = "amount_label",
        text = amount,
        size = 18
      },
      layout = {
        position = ccp(180, 309)
      },
      config = {color = amountColor, visible = false}
    },
    {
      t = "Label",
      base = {
        name = "amount_title_suffix",
        text = T(LSTR("EQUIPINFO.ITEM")),
        size = 20
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(195, 310)
      },
      config = {
        color = ccc3(67, 59, 56),
        visible = false
      }
    }
  }
  local readNode = ed.readnode.create(ui.frame, ui)
  readNode:addNode(ui_info)
end
class.initAmount = initAmount
local initAtt = function(self, addition)
  addition = addition or {}
  local param = self.param
  local ui = self.ui
  local container = ui.container
  if not tolua.isnull(ui.att_bg) and not addition.isFadeContainer then
    ui.att_bg:removeFromParentAndCleanup(true)
  end
  ui.att_bg = ed.createNode({
    t = "Scale9Sprite",
    base = {
      res = "UI/alpha/HVGA/package_detail_bg_2.png",
      capInsets = CCRectMake(10, 10, 230, 120)
    },
    layout = {
      anchor = ccp(0.5, 1),
      position = ccp(143, 287)
    },
    config = {isCascadeOpacity = true}
  }, container)
  local id = self.param.id
  local amount = ed.player.equip_qunty[id] or 0
  local desc, add, suffix = ed.readequip.getDescription(id, param.level)
  local uinfo = {}
  local isEquipDesc
  local equipDesc = ed.readequip.value(id, "Description")
  if equipDesc then
    isEquipDesc = true
    desc = {equipDesc}
    uinfo = ed.readequip.getFragmentAmount(id)
    self.uinfo = uinfo
  end
  local lineCount = #desc
  local ui_info = {}
  for i = 1, #desc do
    local list = {}
    table.insert(list, {
      t = "Label",
      base = {
        name = "att_" .. i,
        text = desc[i],
        size = 18
      },
      config = {
        color = ccc3(64, 63, 63),
        horizontalAlignment = kCCTextAlignmentLeft,
        verticalAlignment = kCCVerticalTextAlignmentTop,
        dimensions = isEquipDesc and CCSizeMake(252, 0) or nil,
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    })
    if add[i] then
      table.insert(list, {
        t = "Label",
        base = {
          name = "add_att_" .. i,
          text = add[i],
          size = 18,
          offset = 5
        },
        config = {
          color = ccc3(0, 255, 0),
          shadow = {
            color = ccc3(0, 0, 0),
            offset = ccp(0, 2)
          }
        }
      })
    end
    if suffix[i] then
      table.insert(list, {
        t = "Label",
        base = {
          name = "suffix_att" .. i,
          text = suffix[i],
          size = 18
        },
        config = {
          color = ccc3(255, 238, 210),
          shadow = {
            color = ccc3(0, 0, 0),
            offset = ccp(0, 2)
          }
        }
      })
    end
    table.insert(ui_info, list)
  end
  if uinfo.isFragment then
    table.insert(ui_info, {
      {
        t = "Label",
        base = {text = " ", size = 18},
        config = {}
      }
    })
    lineCount = lineCount + 1
    if not addition.ignoreComposeDesc then
      table.insert(ui_info, {
        {
          t = "Label",
          base = {
            name = "fragment_title",
            text = T(LSTR("EQUIPINFO.SYNTHESIS_REQUIRES_FRAGMENT_")),
            size = 18
          },
          config = {
            color = ccc3(66,45,28),
            shadow = {
              color = ccc3(0, 0, 0),
              offset = ccp(0, 2)
            }
          }
        },
        {
          t = "Label",
          base = {
            name = "fragment_amount",
            text = string.format("%d/%d", amount, uinfo.need),
            size = 18
          },
          config = {
            color = ccc3(66,45,28),
            shadow = {
              color = ccc3(0, 0, 0),
              offset = ccp(0, 2)
            }
          }
        }
      })
      lineCount = lineCount + 1
    end
  elseif lineCount < 5 then
    table.insert(ui_info, {
      {
        t = "Label",
        base = {text = " ", size = 18},
        config = {}
      }
    })
  end
  local ui_param = {
    t = "ChaosNode",
    base = {nodeArray = ui, offset = 2},
    layout = {
      anchor = ccp(0, 1),
      position = ccp(22, 282)
    },
    ui = ui_info
  }
  ui.att_list = ed.createNode(ui_param, container)
  local bSize = ui.att_bg:getContentSize()
  local bw, bh = bSize.width, bSize.height
  local attListHeight = ui.att_list:getContentSize().height
  ui.att_bg:setContentSize(CCSizeMake(bw, attListHeight + 12))
  local detailText = ed.readequip.value(self.param.id, "Comment")
  detailText = detailText or " "
  --[[
  ui.detail = ed.createNode({
    t = "Label",
    base = {text = detailText, size = 18},
    layout = {
      anchor = ccp(0, 1),
      position = ccp(20, 282 - attListHeight - 12)
    },
    config = {
      dimensions = CCSizeMake(252, 0),
      horizontalAlignment = kCCTextAlignmentLeft,
      verticalAlignment = kCCVerticalTextAlignmentTop,
      color = ccc3(67, 59, 56)
    }
  }, container)]]--
end
class.initAtt = initAtt
local initTitle = function(self, addition)
  addition = addition or {}
  local ui = self.ui
  local container = ui.container
  local titleContainer = ui.title_container
  if not tolua.isnull(titleContainer) and not addition.isFadeContainer then
    titleContainer:removeFromParentAndCleanup(true)
  end
  local titleContainer = ed.createNode({
    t = "Sprite",
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    },
    config = {isCascadeOpacity = true}
  }, container)
  ui.title_container = titleContainer
  local param = self.param
  local id = param.id
  local level = param.level or 0
  if level > 0 then
    ui.icon = ed.readequip.createIconWithLevel(id, level)
  else
    ui.icon = ed.readequip.createIcon(id)
  end
  ui.icon:setPosition(ccp(50, 328))
  titleContainer:addChild(ui.icon)
  local name = ed.readequip.value(id, "Name")
  ui.name = ed.createNode({
    t = "Label",
    base = {text = name, size = 24},
    layout = {
      anchor = ccp(0, 0.5),
      position = ccp(92, 345)
    },
    config = {
	  color = ccc3(66,45,28),
      shadow = {
        color = ccc3(0, 0, 0),
        offset = ccp(0, 2)
      }
    }
  }, titleContainer)
  local w = ui.name:getContentSize().width
  if w > 160 then
    ui.name:setScale(160 / w)
  end
  if param.level then
    local level_des = ed.ui.baseres.enhance_level_res
    local text = ""
    if ed.readequip.getMaxLevel(id) > 1 then
      text = T(LSTR("EQUIPINFO.UNENCHANTED"))
    end
    if level >= 1 then
      text = level_des[level] or ""
    end
    ui.level = ed.createNode({
      t = "Label",
      base = {text = text, size = 16},
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(90, 309)
      },
      config = {
        color = ccc3(237, 218, 136),
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    }, titleContainer)
  end
end
class.initTitle = initTitle
local initContainer = function(self, addition)
  local fade_gap = 0.1
  addition = addition or {}
  local ui = self.ui
  local frame = ui.frame
  local container = ui.container
  if not tolua.isnull(container) then
    if addition.isFade then
      local fo = CCFadeOut:create(fade_gap)
      local callback = CCCallFunc:create(function()
        container:removeFromParentAndCleanup(true)
      end)
      container:runAction(ed.readaction.create({
        t = "seq",
        fo,
        callback
      }))
    else
      container:removeFromParentAndCleanup(true)
    end
  end
  local container = ed.createNode({
    t = "Sprite",
    layout = {
      anchor = ccp(0, 0),
      position = ccp(0, 0)
    },
    config = {isCascadeOpacity = true}
  }, frame)
  ui.container = container
  addition.isFadeContainer = addition.isFade
  if not addition.ignoreTitle then
    self:initTitle(addition)
  end
  if not addition.ignoreAtt then
    self:initAtt(addition)
  end
  if addition.isFade then
    container:setOpacity(0)
    container:runAction(ed.readaction.create({
      t = "seq",
      CCDelayTime:create(0),
      CCFadeIn:create(fade_gap)
    }))
  end
end
class.initContainer = initContainer
local setCloseVisible = function(self, isVisible)
  self.ui.close:setVisible(isVisible)
end
class.setCloseVisible = setCloseVisible
local initFrame = function(self, addition)
  addition = addition or {}
  local ui = self.ui
  local frame = ed.createSprite("UI/alpha/HVGA/package_detail_bg.png")
  ui.frame = frame
  frame:setCascadeOpacityEnabled(true)
  frame:setPosition(ccp(400, 240))
  if not addition.isFeralFrame then
    self.container:addChild(frame)
  end
  if not addition.ignoreClose then
    local readnode = ed.readnode.create(frame, ui)
    readnode:addNode({
      {
        t = "DGButton",
        base = {
          name = "close",
          normal = "UI/alpha/HVGA/herodetail-detail-close.png",
          press = "UI/alpha/HVGA/herodetail-detail-close-p.png"
        },
        layout = {
          position = ccp(286, 358)
        },
        config = {}
      }
    })
  end
  if not addition.ignoreContainer then
    self:initContainer(addition)
  end
end
class.initFrame = initFrame
local function init(t, param)
  if not class[t] then
    print("Invalid identity of equipboard!")
    return
  end
  return class[t].create(param)
end
class.init = init
