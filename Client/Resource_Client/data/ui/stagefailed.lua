local ed = ed
local class = {
  mt = {}
}
ed.ui.stagefailed = class
local base = ed.ui.basescene
setmetatable(class, base.mt)
class.mt.__index = class
local lsr = ed.ui.stagefailedlsr.create()
local number_jump_gap = 0.8
local number_jump_delay = 0
local function hasPropToEquip(self)
  for k, v in pairs(ed.player.heroes) do
    local hero = v
    for i = 1, 6 do
      if hero:hasEquipment(i) then
      else
        local hid = hero._tid
        local rank = hero._rank
        local equipId = ed.getDataTable("hero_equip")[hid][rank]["Equip" .. i .. " ID"]
        if ed.isEquipCraftable(equipId) then
          return true
        end
      end
    end
  end
  return false
end
class.hasPropToEquip = hasPropToEquip
local function doClickMenu(self)
  lsr:report("clickMenu")
  ed.popScene()
  if ed.stageType(self.param.stage_id) == "act" then
    local scene = ed.ui.exercise.create(self.param.actType)
    ed.replaceScene(scene)
  end
  ed.playMusic(ed.music.map)
end
class.doClickMenu = doClickMenu
local function doClickBack(self)
  lsr:report("clickBack")
  if ed.stageType(self.param.stage_id) == "act" then
    local scene = ed.ui.stagedetail.createForExercise(self.param.stage_id, {
      heroLimit = self.param.heroLimit,
      actType = self.param.actType
    })
    ed.replaceScene(scene)
  else
    ed.replaceScene(ed.ui.stagedetail.create(self.param.stage_id, {
      isGetWay = self.param.gwMode
    }))
  end
  ed.playMusic(ed.music.map)
end
class.doClickBack = doClickBack
local function registerTouchHandler(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.menu,
    press = ui.menu_press,
    key = "menu_button",
    clickHandler = function()
      self:doClickMenu()
    end
  })
  self:btRegisterButtonClick({
    button = ui.back,
    press = ui.back_press,
    key = "back_button",
    clickHandler = function()
      self:doClickBack()
    end
  })
  self:btRegisterButtonClick({
    button = ui.battleStatist,
    press = ui.battleStatist_press,
    key = "account_button",
    clickHandler = function()
      ed.ui.battleStatist.create(ed.engine.unit_list)
    end
  })
end
class.registerTouchHandler = registerTouchHandler
local function createPrompt(self)
  local pl = {}
  local rh = ed.readhero
  local config = {
    {
      res = "UI/alpha/HVGA/battledone_failed_evolve.png",
      handler = rh.canHeroEvolve
    },
    {
      res = "UI/alpha/HVGA/battledone_failed_heroupgrade.png",
      handler = rh.canUpgradeHero
    },
    {
      res = "UI/alpha/HVGA/battledone_failed_skillupgrade.png",
      handler = rh.canHeroSkillLevelup
    },
    {
      res = "UI/alpha/HVGA/battledone_failed_equip.png",
      handler = rh.canHeroWearEquip,
      param = self.heroes
    },
    {
      res = "UI/alpha/HVGA/battledone_failed_herolevelup.png",
      handler = function()
        return true
      end
    },
    {
      res = "UI/alpha/HVGA/battledone_failed_enhance.png",
      handler = rh.canHeroEnhanceEquip,
      param = self.heroes
    }
  }
  for i = 1, 6 do
    local element = config[i]
    local res = element.res
    local handler = element.handler
    local param = element.param
    if #pl < 2 and handler(param) then
      table.insert(pl, res)
    end
  end
  local ph = 165
  if self.param.excavate_mode then
    ph = 150
  end
  local pos = {
    ccp(205, ph),
    ccp(445, ph)
  }
  for i = 1, #pl do
    local ps = ed.createSprite(pl[i])
    ps:setPosition(pos[i])
    self.mainLayer:addChild(ps)
  end
end
class.createPrompt = createPrompt
local function onExitWork()
  ed.player.loots = {}
end
local function create(param)
  local self = base.create("stageFailed")
  setmetatable(self, class.mt)
  self.param = param
  local list = param.heroes
  local hl = {}
  for k, v in pairs(list or {}) do
    table.insert(hl, ed.player.heroes[v])
  end
  self.heroes = hl
  local scene = self.scene
  local mainLayer = self.mainLayer
  local titlePos = ccp(325, 350)
  if self.param.excavate_mode then
    titlePos = ccp(325, 380)
  end
  self.ui = {}
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "bg",
        res = ed.ui.stageaccount.getBattleBgRes(self.param.stage_id)
      },
      layout = {
        position = ccp(400, 240)
      },
      config = {}
    },
    {
      t = "ColorLayer",
      base = {
        name = "shelter",
        color = ccc4(0, 0, 0, 200)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "light",
        res = "UI/alpha/HVGA/failed_light.png"
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(325, 480)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "title",
        res = ed.ui.stageaccount.getLoseTitleRes(self.param.loseType)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = titlePos
      }
    },
    {
      t = "Sprite",
      base = {
        name = "back",
        res = "UI/alpha/HVGA/replaybtn.png"
      },
      layout = {
        position = ccp(680, 315)
      },
      config = {
        visible = self.arena_mode == false
      }
    },
    {
      t = "Sprite",
      base = {
        name = "back_press",
        res = "UI/alpha/HVGA/replaybtn-disabled.png"
      },
      layout = {
        position = ccp(680, 315)
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "menu",
        res = "UI/alpha/HVGA/back2mapbtn.png"
      },
      layout = {
        position = ccp(680, 130)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "menu_press",
        res = "UI/alpha/HVGA/back2mapbtn-disabled.png"
      },
      layout = {
        position = ccp(680, 130)
      },
      config = {visible = false}
    }
  }
  local readNode = ed.readnode.create(mainLayer, self.ui)
  readNode:addNode(ui_info)
  if self.param.excavate_mode then
    ui_info = {
      {
        t = "Sprite",
        base = {
          name = "info_bg",
          res = "UI/alpha/HVGA/bigyellowbar.png",
          z = 1
        },
        layout = {
          position = ccp(335, 398)
        },
        config = {isCascadeOpacity = true}
	  },
      {
        t = "Label",
        base = {
          name = "lv_title",
          text = "LV:",
          size = 18,
          parent = "info_bg"
        },
        layout = {
          position = ccp(41, 35)
        },
        config = {
          color = ccc3(169, 70, 6)
        }
      },
      {
        t = "Label",
        base = {
          name = "lv",
          text = self.param.playerInfo.oriLevel,
          size = 18,
          parent = "info_bg"
        },
        layout = {
          position = ccp(71, 35)
        },
        config = {
          color = ccc3(169, 70, 6)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "battleStatist",
          res = "UI/alpha/HVGA/herodetail-upgrade.png",
          capInsets = CCRectMake(20, 20, 20, 20),
          parent = "info_bg"
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(351, 40)
        },
        config = {
          scaleSize = CCSizeMake(70, 50)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "battleStatist_press",
          res = "UI/alpha/HVGA/herodetail-upgrade-mask.png",
          capInsets = CCRectMake(20, 20, 20, 20),
          parent = "battleStatist"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(0, 0)
        },
        config = {
          scaleSize = CCSizeMake(70, 50),
          visible = false
        }
      },
      {
        t = "Label",
        base = {
          name = "battleCount",
          text = T(LSTR("STAGEDONE.DATA")),
          fontinfo = "ui_normal_button",
          parent = "battleStatist"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(35, 26)
        }
      }
    }
    readNode:addNode(ui_info)
    self:createTeamExpBar()
  else
    ui_info = {
      {
        t = "Scale9Sprite",
        base = {
          name = "battleStatist",
          res = "UI/alpha/HVGA/herodetail-upgrade.png",
          capInsets = CCRectMake(20, 20, 20, 20)
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(500, 335)
        },
        config = {
          scaleSize = CCSizeMake(70, 50)
        }
      },
      {
        t = "Scale9Sprite",
        base = {
          name = "battleStatist_press",
          res = "UI/alpha/HVGA/herodetail-upgrade-mask.png",
          capInsets = CCRectMake(20, 20, 20, 20),
          parent = "battleStatist"
        },
        layout = {
          anchor = ccp(0, 0),
          position = ccp(0, 0)
        },
        config = {
          scaleSize = CCSizeMake(70, 50),
          visible = false
        }
      },
      {
        t = "Label",
        base = {
          name = "battleCount",
          text = T(LSTR("STAGEDONE.DATA")),
          fontinfo = "ui_normal_button",
          parent = "battleStatist"
        },
        layout = {
          anchor = ccp(0.5, 0.5),
          position = ccp(35, 26)
        }
      }
    }
    readNode:addNode(ui_info)
  end
  local lightAction = CCRotateBy:create(5, 360)
  self.ui.light:runAction(CCRepeatForever:create(lightAction))
  self:createPrompt()
  self:registerOnExitHandler("onExitwork", onExitWork)
  self:registerTouchHandler()
  return self
end
class.create = create
local function createTeamExpBar(self)
  local layer = self.mainLayer
  local ui = self.ui
  local readnode
  local ui_info = {}
  local isml = ed.player:checkLevelMax(self.param.playerInfo.oriLevel)
  local mlContainer = CCSprite:create()
  mlContainer:setCascadeOpacityEnabled(true)
  self.mlContainer = mlContainer
  self.ui.info_bg:addChild(mlContainer)
  readnode = ed.readnode.create(mlContainer, ui)
  ui_info = {
    {
      t = "Label",
      base = {
        name = "max_level_prompt",
        text = T(LSTR("STAGEDONE.HAS_REACHED_THE_LEVEL_CAP")),
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(90, 35)
      },
      config = {
        color = ccc3(169, 70, 6)
      }
    }
  }
  readnode:addNode(ui_info)
  if not isml then
    local lbContainer = CCSprite:create()
    lbContainer:setCascadeOpacityEnabled(true)
    self.lbContainer = lbContainer
    self.ui.info_bg:addChild(lbContainer)
    readnode = ed.readnode.create(lbContainer, ui)
    ui_info = {
      {
        t = "Sprite",
        base = {
          name = "exp_title",
          res = "UI/alpha/HVGA/xpicon.png"
        },
        layout = {
          position = ccp(116, 35),
          visible = true
        }
      },
      {
        t = "Label",
        base = {
          name = "exp_label",
          text = "+" .. (self.param.exp or 0),
          size = 19
        },
        layout = {
          anchor = ccp(0, 0.5),
          position = ccp(155, 35)
        },
        config = {
          color = ccc3(169, 70, 6)
        }
      }
    }
    readnode:addNode(ui_info)
    mlContainer:setVisible(false)
  end
end
class.createTeamExpBar = createTeamExpBar
local function playLevelAnim(self)
  local info = self.param.playerInfo
  local animList = info.animList
  if #animList > 1 then
    local level = ed.player:getLevel()
    ed.setString(self.ui.lv, level)
    self:showTeamLevelMax(level)
    for i, v in ipairs(animList) do
      if i == #animList then
        ed.announce({
          type = "playerLevelup"
        })
      end
    end
  end
end
class.playLevelAnim = playLevelAnim
