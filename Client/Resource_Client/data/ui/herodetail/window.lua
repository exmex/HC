local herodetail = ed.ui.herodetail
local res = herodetail.res
local lsr = herodetail.listener.create()
local base = ed.ui.popwindow
local class = newclass(base.mt)
herodetail.window = class
local herofca
class.stone_bar_len = 180
local ettres = res.equip_tag_text
local etires = res.equip_tag_icon
local function createHeroFca(self)
  local puppet = herofca.create(self.hid)
  puppet:setPosition(ccp(400, 265))
  self.container:addChild(puppet,12)
  self:addFca(puppet)
end
class.createHeroFca = createHeroFca
local function changeFca(self, name)
  local fca, duration = herofca.change(name)
  lsr:report("clickHeroFca", {
    hid = self.hid,
    fca = fca
  })
  self:registerUpdateHandler("checkFcaHandler", self:checkFcaHandler(fca, duration))
end
class.changeFca = changeFca
local playHeroCheer = function(self, param)
  param = param or {}
  local hasEffect = param.hasEffect
  self:changeFca("Cheer")
  if hasEffect then
    local hid = self.hid
    local effect = ed.getDataTable("Unit")[hid]["Voice Upgrade"]
    if effect then
      ed.playEffect(effect)
    end
  end
end
class.playHeroCheer = playHeroCheer
local function checkFcaHandler(self, fca, duration)
  local count = 0
  local function handler(dt)
    count = count + dt
    if fca ~= "Move" and count > duration then
      herofca.playIdle()
      self:removeUpdateHandler("checkFcaHandler")
    end
  end
  return handler
end
class.checkFcaHandler = checkFcaHandler
local function getAttChanged(self)
  local att = ed.readhero.getHeroAtt(self.hid)
  local patt = self.attInfo
  local clist = {}
  for i = 1, #res.att_name do
    local k = res.att_name[i]
    if not att[k] then
      att[k] = {}
    end
    if not patt[k] then
      patt[k] = {}
    end
    local v = att[k]
    local pv = patt[k]
    local badd = (v.base or 0) - (pv.base or 0)
    local aadd = (v.add or 0) - (pv.add or 0)
    local add = badd + aadd
    if add > 0 then
      clist[k] = add
    end
  end
  self.attInfo = att
  return clist
end
class.getAttChanged = getAttChanged
local function playAttAdditionAnim(self, list)
  lsr:report("heroAttAnim")
  if not tolua.isnull(self.attListContainer) then
    self.attListContainer:removeFromParentAndCleanup(true)
  end
  local container = ed.createNode({t = "Sprite"}, self.container, 200)
  self.attListContainer = container
  local w, h = 160, 160
  local index = 0
  for i = 1, #res.att_name do
    local k = res.att_name[i]
    local v = list[k]
    if 0 < (v or 0) then
      do
        local label = ed.createNode({
          t = "Label",
          base = {
            text = res.att_anim_name[k] .. "+" .. v,
            size = 20
          },
          layout = {
            position = ccp(395, 390)
          },
          config = {
            color = ccc3(0, 255, 0),
            stroke = {
              color = ccc3(0, 0, 0),
              size = 2
            },
            visible = false
          }
        }, container)
        local delay = CCDelayTime:create(0.4 * index)
        local func = CCCallFunc:create(function()
          xpcall(function()
            label:setVisible(true)
          end, EDDebug)
        end)
        local fade = CCFadeOut:create(0.8)
        local move = CCMoveTo:create(0.8, ccp(395, 440))
        label:runAction(ed.readaction.create({
          t = "seq",
          delay,
          func,
          {
            t = "sp",
            fade,
            move
          }
        }))
        index = index + 1
      end
    end
  end
end
class.playAttAdditionAnim = playAttAdditionAnim
local function getAttAddition(self, e1, e2)
  local info = ed.getDataTable("equip")
  local info1 = info[e1]
  local info2
  if e2 then
    info2 = info[e2]
  else
    info2 = {}
  end
  local list = {}
  for i = 1, #res.att_name do
    local k = res.att_name[i]
    if 0 < (info1[k] or 0) then
      list[k] = info1[k] - (info2[k] or 0)
    end
  end
  return list
end
class.getAttAddition = getAttAddition
local craftCallBack = function(self)
  local function handler(instruction)
    xpcall(function()
      if instruction == "equip" then
        self:wearEquip()
        self:refreshEquipTag()
        ed.tutorial.tell("equipSuccess", self.pageLayer)
        ed.endTeach("equipSuccess")
      elseif instruction == "update" then
        self:refreshEquipTag()
      end
    end, EDDebug)
  end
  return handler
end
class.craftCallBack = craftCallBack
local refreshgsAfterWear = function(self)
  local gs = self.hero._gs
  if gs ~= self.pregs then
    ed.setString(self.ui.gs, gs)
    ed.setNodeAnchor(self.ui.gs, ccp(0.5, 0.5))
    self.pregs = gs
    local s1 = CCEaseBackOut:create(CCScaleTo:create(0.2, 1.2))
    local s2 = CCEaseBackOut:create(CCScaleTo:create(0.2, 1))
    local f = CCCallFunc:create(function()
      xpcall(function()
        ed.setNodeAnchor(self.ui.gs, ccp(0, 0.5))
      end, EDDebug)
    end)
    self.ui.gs:runAction(ed.readaction.create({
      t = "seq",
      s1,
      s2,
      f
    }))
  end
end
class.refreshgsAfterWear = refreshgsAfterWear
local function wearEquip(self)
  lsr:report("equippingAnim")
  local id = self.craftSlot
  self:refreshgsAfterWear()
  self:createEquipIcon(id)
  local frame = self.equips[id].frame
  local spr = ed.createFcaNode("eff_UI_equipping")
  self:addFca(spr, {isOnce = true})
  spr:setPosition(ed.getCenterPos(frame))
  frame:addChild(spr)
  if self.attLayer then
    self.attLayer:refreshAttLabel()
  end
  if self.skillLayer then
    self.skillLayer:refreshSkillAdd()
  end
  self:playAttAdditionAnim(self:getAttChanged())
  self:playHeroCheer()
  ed.teach("closeHeroDetail", self.ui.close, self.ui.bg)
end
class.wearEquip = wearEquip
local createUpgradeButtonLight = function(self)
  local ui = self.ui
  if not tolua.isnull(ui.upgrade_button_light) then
    return
  end
  local upgrade = ui.upgrade
  local light = ed.createNode({
    t = "Sprite",
    base = {
      res = "UI/alpha/HVGA/hero_upgrade_button_light.png"
    },
    layout = {
      position = ed.getCenterPos(upgrade)
    }
  }, upgrade)
  ui.upgrade_button_light = light
  local f1 = CCFadeOut:create(1)
  local f2 = CCFadeIn:create(1)
  light:runAction(ed.readaction.create({
    t = "seq",
    isRepeat = true,
    f1,
    f2
  }))
end
class.createUpgradeButtonLight = createUpgradeButtonLight
local refreshEquipTag = function(self)
  self:createEquipTags()
  if self:canHeroUpgrade() then
    self:createUpgradeButtonLight()
    ed.teach("heroUpgrade", self.ui.upgrade, self.ui.bg)
  end
end
class.refreshEquipTag = refreshEquipTag
local function doClickEquip(self, id)
  lsr:report("clickEquip")
  if self.equipTutorialID and self.equipTutorialKey and id == self.equipTutorialID then
    --add by xinghui
    if --[[ed.tutorial.checkDone("canEquipProp")== false--]] ed.tutorial.isShowTutorial then
        ed.sendDotInfoToServer(ed.tutorialres.t_key["canEquipProp"].id)
    end
    --.
    ed.endTeach(self.equipTutorialKey)
    if self.equipTutorialKey == "canEquipProp" then
      ed.endTeach("gotoHeroDetailToEquip")
    end
    self.equipTutorialID = nil
    self.equipTutorialKey = nil
  end
  self.craftSlot = id
  local config = {
    context = "heroDetail",
    eid = self.equips[id].id,
    level = self.equips[id].level,
    hid = self.hid,
    sid = id,
    isEquiped = self.equips[id].isEquiped,
    callback = self:craftCallBack()
  }
  local craftLayer = ed.ui.equipcraft.create(config)
  self.craftLayer = craftLayer
  self.animLayer:addChild(craftLayer.mainLayer, 50)
end
class.doClickEquip = doClickEquip
local isMoving = function(self)
  if self.skillLayer then
    return self.skillLayer.container:numberOfRunningActions() > 0
  end
  if self.attLayer then
    return 0 < self.attLayer.container:numberOfRunningActions()
  end
  if self.cardLayer then
    return 0 < self.cardLayer.container:numberOfRunningActions()
  end
end
class.isMoving = isMoving
local doMoveBack = function(self, skipAnim)
  if skipAnim then
    self.container:setPosition(ccp(0, 0))
  else
    local move = CCMoveTo:create(0.2, ccp(0, 0))
    self.container:runAction(move)
  end
end
class.doMoveBack = doMoveBack
local doMove = function(self, skipAnim)
  if skipAnim then
    self.container:setPosition(ccp(140, 0))
  else
    local move = CCMoveTo:create(0.2, ccp(140, 0))
    self.container:runAction(move)
  end
end
class.doMove = doMove
local function destroySkillLayer(self, callback)
  if not self.skillLayer then
    return
  end
  lsr:report("closeSkillLayer")
  self.skillLayer:popBack({
    endPos = ccp(48, 0),
    callback = callback
  })
end
class.destroySkillLayer = destroySkillLayer
local setOpenMode = function(self, mode, param)
  param = param or {}
  local ui = self.ui
  ui.skill_select:setVisible(false)
  ui.detail_select:setVisible(false)
  ui.card_select:setVisible(false)
  if not param.force then
    local preMode = self.openMode
    if preMode == mode then
      return
    end
    if preMode == "att" then
      self:destroyAttLayer(function()
        self.attLayer = nil
      end)
    elseif preMode == "skill" then
      self:destroySkillLayer(function()
        self.skillLayer = nil
      end)
    elseif preMode == "card" then
      self:destroyCardLayer(function()
        self.cardLayer = nil
      end)
    elseif preMode == "equip" then
      self:destroyEquipLayer(function()
        self.equipLayer = nil
      end)
    end
  else
    self.skillLayer = nil
    self.attLayer = nil
    self.cardLayer = nil
    self.equipLayer = nil
  end
  self.openMode = mode
  if mode == "att" then
    self:doOpenDetail(param)
    ui.detail_select:setVisible(true)
  elseif mode == "skill" then
    self:doOpenSkill(param)
    ui.skill_select:setVisible(true)
  elseif mode == "card" then
    self:doOpenCard(param)
    ui.card_select:setVisible(true)
  elseif mode == "equip" then
    self:doOpenEquip(param)
  else
    self:doMoveBack()
  end
end
class.setOpenMode = setOpenMode
local function doOpenSkill(self, param)
  if self.skillLayer then
    return
  end
  lsr:report("createSkillLayer")
  self.skillLayer = herodetail.skill.create(self.hero, {
    heroDetail = self,
    from = (param or {}).from,
    closeHandler = function()
      self:destroySkillLayer()
      self:doMoveBack()
    end,
    parent = self.animLayer
  })
  self.skillLayer:pop({
    skipAnim = param.skipAnim,
    oriPos = ccp(self.container:getPosition()),
    endPos = ccp(-200, 0)
  })
  self:doMove(param.skipAnim)
end
class.doOpenSkill = doOpenSkill
local function doClickSkill(self)
  lsr:report("clickSkillButton")
  ed.endTeach("SUclickSkillButton")
  if self:isMoving() then
    return
  end
  if self.skillLayer then
    self:setOpenMode(nil)
  else
    self:setOpenMode("skill", {from = "create"})
  end
end
class.doClickSkill = doClickSkill
local function destroyAttLayer(self, callback)
  if not self.attLayer then
    return
  end
  lsr:report("closeAttLayer")
  self.attLayer:popBack({
    endPos = ccp(48, 0),
    callback = callback
  })
end
class.destroyAttLayer = destroyAttLayer
local function doOpenDetail(self, param)
  if self.attLayer then
    return
  end
  lsr:report("createAttLayer")
  self.attLayer = herodetail.att.create(self.hero, {
    parent = self.animLayer,
    closeHandler = function()
      self:destroyAttLayer()
      self:doMoveBack()
    end
  })
  self.attLayer:pop({
    skipAnim = param.skipAnim,
    oriPos = ccp(self.container:getPosition()),
    endPos = ccp(-200, 0)
  })
  self:doMove(param.skipAnim)
end
class.doOpenDetail = doOpenDetail
function class:doOpenEquip(param)
  if self.equipLayer then
    return
  end
  lsr:report("createAttLayer")
  self.equipLayer = herodetail.equip.create(self.hero, {
    parent = self.animLayer,
    closeHandler = function()
      self:destroyAttLayer()
      self:doMoveBack()
    end
  })
  self.equipLayer:pop({
    skipAnim = param.skipAnim,
    oriPos = ccp(self.container:getPosition()),
    endPos = ccp(-200, 0)
  })
  self:doMove(param.skipAnim)
end
local function doClickDetail(self)
  lsr:report("clickAttButton")
  if self:isMoving() then
    return
  end
  if self.attLayer then
    self:setOpenMode(nil)
  else
    self:setOpenMode("att")
  end
end
class.doClickDetail = doClickDetail
local doClickEvolveEquip = function(self)
  lsr:report("clickEvolveEquip")
  if self:isMoving() then
    return
  end
  if self.equipLayer then
    self:setOpenMode(nil)
  else
    self:setOpenMode("equip")
  end
end
class.doClickEvolveEquip = doClickEvolveEquip
local function destroyCardLayer(self, callback)
  if not self.cardLayer then
    return
  end
  lsr:report("closeCardLayer")
  self.cardLayer:popBack({
    endPos = ccp(48, 0),
    callback = callback
  })
end
class.destroyCardLayer = destroyCardLayer
function class:destroyEquipLayer(callback)
  if not self.equipLayer then
    return
  end
  self.equipLayer:popBack({
    endPos = ccp(48, 0),
    callback = callback
  })
end
local function doOpenCard(self, param)
  if self.cardLayer then
    return
  end
  lsr:report("createCardLayer")
  self.cardLayer = herodetail.card.create(self.hero, {
    clickHandler = function()
      self:destroyCardLayer()
      self:doMoveBack()
    end,
    parent = self.animLayer
  })
  self.cardLayer:pop({
    skipAnim = param.skipAnim,
    oriPos = ccp(self.container:getPosition()),
    endPos = ccp(-200, 0)
  })
  self:setOpenMode("card")
  self:doMove(param.skipAnim)
end
class.doOpenCard = doOpenCard
local function doClickCard(self, skipAnim)
  lsr:report("clickCardButton")
  if self:isMoving() then
    return
  end
  if self.cardLayer then
    self:setOpenMode(nil)
  else
    self:setOpenMode("card")
  end
end
class.doClickCard = doClickCard
local registerEvolveAnim = function(self, node)
  self.baseScene:registerUpdateHandler("refreshEvolveAnim", self:refreshEvolveAnimHandler(node))
end
class.registerEvolveAnim = registerEvolveAnim
local refreshEvolveAnimHandler = function(self, node)
  local id = self.hid
  local function handler()
    local function showAnnounce()
      ed.announce({
        type = "heroEvolve",
        param = {
          id = id,
          preAtt = self.attBeforeEvolve
        }
      })
      self.baseScene:removeUpdateHandler("refreshEvolveAnim")
    end
    if tolua.isnull(self.mainLayer) then
      showAnnounce()
      return
    end
    if tolua.isnull(node) then
      showAnnounce()
      return
    end
    if node:isTerminated() then
      showAnnounce()
    end
  end
  return handler
end
class.refreshEvolveAnimHandler = refreshEvolveAnimHandler
local registerUpgradeAnim = function(self, node, items)
  self.baseScene:registerUpdateHandler("refreshUpgradeAnim", self:refreshUpgradeAnimHandler(node, items))
end
class.registerUpgradeAnim = registerUpgradeAnim
local refreshUpgradeAnimHandler = function(self, node, items)
  local id = self.hid
  local function handler()
    local function showAnnounce()
      ed.announce({
        type = "heroUpgrade",
        param = {
          id = id,
          preHero = self.heroBeforeUpgrade,
          handler = function()
            xpcall(function()
              if #(items or {}) > 0 then
                ed.announce({
                  type = "getProp",
                  priority = -1,
                  param = {
                    title = T(LSTR("HERODETAIL.EQUIPMENT_ENCHANTING_RETURN")),
                    items = items
                  }
                })
              end
            end, EDDebug)
          end
        }
      })
      self.baseScene:removeUpdateHandler("refreshUpgradeAnim")
    end
    if tolua.isnull(self.mainLayer) then
      showAnnounce()
      return
    end
    if tolua.isnull(node) then
      showAnnounce()
      return
    end
    if node:isTerminated() then
      showAnnounce()
    end
  end
  return handler
end
class.refreshUpgradeAnimHandler = refreshUpgradeAnimHandler
local function upgradeReply(self)
  local function playEquipAnim()
    for i = 1, 6 do
      do
        local x, y = self:getEquipIconPos(i)
        local id = herodetail.getHerocsvEquipid(self.hid, i, self.hero._rank - 1)
        local icon = ed.readequip.createIcon(id)
        icon:setPosition(ccp(x, y))
        local a1 = CCArray:create()
        local delay = CCDelayTime:create(0.1 * (i - 1))
        local a2 = CCArray:create()
        local epos = ccp(395, 350)
        local move = CCMoveTo:create(0.5, epos)
        move = CCEaseSineOut:create(move)
        local fade = CCFadeTo:create(0.5, 50)
        local scale = CCScaleTo:create(0.5, 0.5)
        a2:addObject(move)
        a2:addObject(fade)
        a2:addObject(scale)
        local s = CCSpawn:create(a2)
        local func = CCCallFunc:create(function()
          xpcall(function()
            if not tolua.isnull(icon) then
              icon:removeFromParentAndCleanup(true)
            end
          end, EDDebug)
        end)
        a1:addObject(delay)
        a1:addObject(s)
        a1:addObject(func)
        s = CCSequence:create(a1)
        icon:runAction(s)
        self.container:addChild(icon, 115)
      end
    end
  end
  local function handler(result, items)
    if not self then
      return
    end
    if not result then
      ed.showToast(T(LSTR("HERODETAIL.ADVANCE_FAILED")))
    else
      lsr:report("upgradeReply")
      self:createInfoBoard()
      self:createEquipIcons()
      self:createHeroName()
      self:createHeroStars()
      self:refreshUpgradeButton()
      playEquipAnim()
      if self.attLayer then
        self.attLayer:refreshAttLabel()
      end
      if self.cardLayer then
        self.cardLayer:refreshCard()
      end
      if self.skillLayer then
        self.skillLayer:heroUpgradeCallback(self.hero._rank)
      end
      local list = self:getAttChanged()
      self:playAttAdditionAnim(list)
      self:playHeroCheer({hasEffect = true})
      local rootPos = ccp(460, 220)
      lsr:report("upgradeAnim")
      local sprBehind = ed.createFcaNode("eff_UI_hero_upgrade_1")
      sprBehind:setPosition(rootPos)
      self.baseScene:addFcaOnce(sprBehind)
      self.container:addChild(sprBehind)
      local sprFront = ed.createFcaNode("eff_UI_hero_upgrade_2")
      sprFront:setPosition(rootPos)
      self.baseScene:addFcaOnce(sprFront)
      self.container:addChild(sprFront, 115)
      self:registerUpgradeAnim(sprBehind, items)
    end
  end
  return handler
end
class.upgradeReply = upgradeReply
local function canHeroUpgrade(self)
  local canUpgrade = true
  for i = 1, 6 do
    if herodetail.getHeroEquipid(self.hid, i) == 0 then
      canUpgrade = false
      break
    end
  end
  if self.hero._rank >= ed.parameter.unit_max_rank then
    canUpgrade = false
  end
  return canUpgrade
end
class.canHeroUpgrade = canHeroUpgrade
local function doClickUpgrade(self)
  local text
  local canUpgrade = true
  for i = 1, 6 do
    if herodetail.getHeroEquipid(self.hid, i) == 0 then
      canUpgrade = false
      text = T(LSTR("HERODETAIL.HERO_NEEDS_TO_WEAR_COMPLETE_EQUIPMENTS_FOR_ADVANCE"))
      break
    end
  end
  if self.hero._rank >= 12 then
    canUpgrade = false
    text = T(LSTR("HERODETAIL.THIS_HER_HAS_ENHANCED_TO_THE_TOP_LEVEL"))
  end
  if not canUpgrade then
    lsr:report("clickDisabledUpgrade")
    ed.showToast(text)
  else
    lsr:report("clickUpgrade")
    if not tolua.isnull(self.ui.upgrade_button_light) then
      self.ui.upgrade_button_light:removeFromParentAndCleanup(true)
    end
    ed.endTeach("heroUpgrade")
    ed.netreply.heroUpgradeReply = self:upgradeReply()
    self.heroBeforeUpgrade = ed.readhero.getHeroUpgradeInfo(self.hid)
    local msg = ed.upmsg.hero_upgrade()
    msg._hero_id = self.hid
    ed.send(msg, "hero_upgrade")
  end
end
class.doClickUpgrade = doClickUpgrade
local doClickClose = function(self)
  self:destroy()
end
class.doClickClose = doClickClose
local doHeroTouch = function(self)
end
class.doHeroTouch = doHeroTouch
local doEvolveHandler = function(self, cost, stoneAmount)
  local function handler()
    if cost > ed.player._money then
      ed.showHandyDialog("useMidas")
      return
    end
    ed.netdata.evolve = {
      hid = self.hid,
      id = ed.readhero.getStoneid(self.hid),
      amount = stoneAmount,
      cost = cost
    }
    ed.netreply.evolve = self:doEvolveReply()
    self.attBeforeEvolve = ed.readhero.getHeroAtt(self.hid)
    local msg = ed.upmsg.hero_evolve()
    msg._heroid = self.hid
    ed.send(msg, "hero_evolve")
  end
  return handler
end
class.doEvolveHandler = doEvolveHandler
local function doEvolveReply(self)
  local function handler(result)
    if not result then
      ed.showToast(T(LSTR("HERODETAIL.HEROES_EVOLUTION_FAILED")))
    else
      lsr:report("evolveReply")
      self:createInfoBoard()
      self:doEvolveRefresh()
      if self.attLayer then
        self.attLayer:refreshAttLabel()
        self.attLayer:refreshGrowth()
      end
      if self.cardLayer then
        self.cardLayer:refreshCard()
      end
      local list = self:getAttChanged()
      self:playAttAdditionAnim(list)
      self:playHeroCheer()
      local rootPos = ccp(395, 255)
      lsr:report("evolveAnim")
      local sprBehind = ed.createFcaNode("eff_UI_herodetail_evolution_back")
      sprBehind:setPosition(rootPos)
      self.baseScene:addFca(sprBehind)
      self.container:addChild(sprBehind)
      local sprFront = ed.createFcaNode("eff_UI_herodetail_evolution_front")
      sprFront:setPosition(rootPos)
      self.baseScene:addFcaOnce(sprFront)
      self.container:addChild(sprFront, 115)
      self:registerEvolveAnim(sprBehind)
    end
  end
  return handler
end
class.doEvolveReply = doEvolveReply
local function doClickEvolve(self)
  lsr:report("clickEvolve")
  local sa, sn = ed.readhero.getStoneAmount(self.hid), herodetail.getHeroEvolveStoneNeed(self.hid)
  if sa < sn then
    ed.showToast(T(LSTR("HERODETAIL.INSUFFICIENT_SOUL_STONE_YOU_CAN_NOT_EVOLUTES_IT")))
    return
  end
  local cost = herodetail.getHeroEvolveCost(self.hid)
  local info = {
    text = T(LSTR("HERODETAIL.EVOLUTION_TAKES_D_GOLD_CONTINUE"), cost),
    rightHandler = self:doEvolveHandler(cost, sn)
  }
  ed.showConfirmDialog(info)
end
class.doClickEvolve = doClickEvolve
--add by xinghui
local function doClickOneKey(self)
	lsr:report("clickonekey")
	
end
--
local registerTouchHandler = function(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.close,
    press = ui.close_press,
    key = "close_button",
    clickHandler = function()
      self:doClickClose()
    end,
    clickInterval = 0.5,
    force = true
  })
  self:btRegisterButtonClick({
    --button = ui.upgrade,
    --press = ui.upgrade_press,
  	buttons = {
	  ui.upgrade,
	  ui.upgrade_select
  	},
  	presses = {
	  ui.upgrade_press,
	  ui.upgrade_select_press
  	},
    key = "upgrade_button",
    clickHandler = function()
      self:doClickUpgrade()
    end,
    clickInterval = 0.5,
    force = true
  })
  self:btRegisterOutClick({
    area = ui.bg,
    extraCheckHandler = function()
      if self.openMode then
        return false
      end
      return true
    end,
    key = "out_frame",
    clickHandler = function()
      self:doClickClose()
    end,
    clickInterval = 0.5,
    force = true,
    priority = 5
  })
  self:btRegisterButtonClick({
    buttons = {
      ui.detail,
      ui.detail_select
    },
    presses = {
      ui.detail_press,
      ui.detail_select_press
    },
    keys = {
      "detail_button",
      "detail_select_button"
    },
    clickHandler = function()
      self:doClickDetail()
    end,
    clickInterval = 0.2,
    force = true
  })
  self:btRegisterButtonClick({
    buttons = {
      ui.equip
    },
    presses = {
      ui.equip_press
    },
    keys = {
      "equip_button"
    },
    clickHandler = function()
      self:doClickEvolveEquip()
    end,
    clickInterval = 0.2,
    force = true
  })
  self:btRegisterButtonClick({
    buttons = {
      ui.card,
      ui.card_select
    },
    presses = {
      ui.card_press,
      ui.card_select_press
    },
    keys = {
      "card_button",
      "card_select_press"
    },
    clickHandler = function()
      self:doClickCard()
    end,
    clickInterval = 0.2,
    force = true
  })
  self:btRegisterButtonClick({
    buttons = {
      ui.skill,
      ui.skill_select
    },
    presses = {
      ui.skill_press,
      ui.skill_select_press
    },
    keys = {
      "skill_button",
      "skill_select_button"
    },
    clickHandler = function()
      self:doClickSkill()
    end,
    clickInterval = 0.2,
    force = true
  })
  self:btRegisterRectClick({
    rect = CCRectMake(100, 220, 200, 195),
    parent = ui.bg,
    key = "hero_touch",
    clickHandler = function()
      self:changeFca()
    end,
    force = true
  })
  self:btRegisterButtonClick({
    --button = ui.evolve,
    --press = ui.evolve_press,
  	buttons = {
	  ui.evolve,
	  ui.evolve_select
  	},
  	presses = {
	  ui.evolve_press,
	  ui.evolve_select_press
  	},
    key = "evolve_button",
    clickHandler = function()
      self:doClickEvolve()
    end,
    clickInterval = 0.5,
    force = true
  })
--add by xinghui
  self:btRegisterButtonClick({
	buttons = {
		ui.onekey,
	},
	presses = {
		ui.onekey_press,
	},
	key = "onekey_button",
	clickHandler = function()
		self:doClickOneKey()
	end,
	clickInterval = 0.5,
	force = true
  })
--
  self:btRegisterRectClick({
    rect = CCRectMake(-240, -10, 270, 50),
    parent = ui.get_stone,
    press = ui.get_stone_press,
    key = "get_stone_button",
    clickHandler = function()
      self.animLayer:addChild(ed.ui.stonedetail.create({
        id = self.hid,
        callback = function()
          self:refreshStone()
        end
      }).mainLayer, 50)
    end,
    force = true
  })
end
class.registerTouchHandler = registerTouchHandler
local function createEquipTag(self, i)
  if self.otherPlayerInfo then
    return
  end
  local eui = self.equips[i]
  if not tolua.isnull(eui.tagText) then
    eui.tagText:removeFromParentAndCleanup(true)
  end
  if not tolua.isnull(eui.tagIcon) then
    eui.tagIcon:removeFromParentAndCleanup(true)
  end
  local ett, eti = herodetail.getHeroEquipState(self.hid, i)
  if ett and ett ~= "isEquiped" and ett ~= "ignore" then
    eui.tagText = ed.createNode({
      t = "Sprite",
      base = {
        res = ettres[ett]
      },
      layout = {
        position = ccp(36, 22)
      }
    }, eui.frame)
    if not ed.tutorial.checkDone("canEquipProp") and ett == "canWear" and not self.equipTutorialID then
      local key = "canEquipProp"
      self.equipTutorialID = i
      self.equipTutorialKey = key
    end
    if not ed.tutorial.getRecord("canCraftProp") and ett == "canCraft" and not self.equipTutorialID then
      local key = "canCraftProp"
      self.equipTutorialID = i
      self.equipTutorialKey = key
    end
    if self.equipTutorialID and self.equipTutorialKey then
      local delay = CCDelayTime:create(0.2)
      local func = CCCallFunc:create(function()
        xpcall(function()
          if not self then
            return
          end
          if tolua.isnull(self.container) then
            return
          end
          if self.equipTutorialKey then
            ed.teach(self.equipTutorialKey, self.equips[self.equipTutorialID].frame, self.container)
          end
        end, EDDebug)
      end)
      if self.equips[self.equipTutorialID] then
        self.equips[self.equipTutorialID].frame:runAction(ed.readaction.create({
          t = "seq",
          delay,
          func
        }))
      end
    end
  end
  if eti then
    eui.tagIcon = ed.createNode({
      t = "Sprite",
      base = {
        res = etires[eti]
      },
      layout = {
        position = ccp(50, 52)
      }
    }, eui.frame)
  end
  self.equips[i].isEquiped = ett == "isEquiped"
end
class.createEquipTag = createEquipTag
local createEquipTags = function(self)
  for i = 1, 6 do
    self:createEquipTag(i)
  end
end
class.createEquipTags = createEquipTags
local createEquipIcons = function(self)
  local board
  if not tolua.isnull(self.equipBoard) then
    board = self.equipBoard
  end
  self.equipBoard = CCSprite:create()
  self.equipBoard:setCascadeOpacityEnabled(true)
  self.container:addChild(self.equipBoard, 9)
  self.equips = {}
  for i = 1, 6 do
    self:createEquipIcon(i)
  end
  if board then
    self.equipBoard:setOpacity(0)
    local fadeout = CCFadeOut:create(0.2)
    local func = CCCallFunc:create(function()
      xpcall(function()
        if not tolua.isnull(board) then
          board:removeFromParentAndCleanup(true)
        end
      end, EDDebug)
    end)
    local sequence = CCSequence:createWithTwoActions(fadeout, func)
    board:runAction(sequence)
    local fadein = CCFadeIn:create(0.2)
    self.equipBoard:runAction(fadein)
  end
end
class.createEquipIcons = createEquipIcons
local getEquipIconPos = function(self, i)
  local equip_icon_pos_x = 255
  local equip_icon_pos_y = 385
  local equip_icon_x_gap = 289
  local equip_icon_y_gap = 70
  local x = equip_icon_pos_x + equip_icon_x_gap * ((i - 1) % 2)
  local y = equip_icon_pos_y - equip_icon_y_gap * math.floor((i - 1) / 2)
  return x, y
end
class.getEquipIconPos = getEquipIconPos
local function createEquipIcon(self, i)
  local x, y = self:getEquipIconPos(i)
  if not tolua.isnull((self.equips[i] or {}).frame) then
    self.equips[i].frame:removeFromParentAndCleanup(true)
  end
  local ceid = herodetail.getHeroEquipid(self.hid, i)
  local eid = herodetail.getHerocsvEquipid(self.hid, i)
  local frame, icon, level
  if ceid > 0 then
    frame, icon = ed.readequip.createHeroItem(self.hid, i, nil, self.hero)
    level = ed.readequip.getEquipLevel(self.hid, i)
  elseif eid == 0 then
    frame, icon = ed.readequip.getUnknownIcon()
  else
    frame, icon = ed.readequip.createIcon(eid, nil, 1)
    ed.setSpriteGray(icon)
  end
  frame:setPosition(x, y)
  self.equipBoard:addChild(frame)
  self.equips[i] = {
    id = 0 < (ceid or 0) and ceid or eid,
    frame = frame,
    icon = icon,
    level = level
  }
  self:createEquipTag(i)
  self:btRegisterButtonClick({
    button = icon,
    pressScale = 0.95,
    extraCheckHandler = function()
      if self.otherPlayerInfo then
        return false
      end
      return true
    end,
    key = "equip_" .. i,
    clickHandler = function()
      if eid == 0 then
        ed.showToast(T(LSTR("window.1.10.1.001")))
      else
        self:doClickEquip(i)
      end
    end,
    clickInterval = 0.5,
    force = true
  })
end
class.createEquipIcon = createEquipIcon
local refreshgsLabel = function(self)
  local label = self.ui.gs
  if not tolua.isnull(label) then
    local f = CCFadeOut:create(0.2)
    local func = CCCallFunc:create(function()
      xpcall(function()
        if not tolua.isnull(label) then
          label:removeFromParentAndCleanup(true)
        end
      end, EDDebug)
    end)
    label:runAction(ed.readaction.create({
      t = "seq",
      f,
      func
    }))
  end
  local gs = self.hero._gs
  local container = self.ui.info_board
  if tolua.isnull(container) then
    return
  end
  local ui_info = {
    {
      t = "Label",
      base = {
        name = "gs",
        text = self.hero._gs,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(195, 168)
      },
      config = {
        color = ccc3(146, 0, 4)
      }
    }
  }
  local readnode = ed.readnode.create(container, self.ui)
  readnode:addNode(ui_info)
  local label = self.ui.gs
  label:setOpacity(0)
  local d = CCDelayTime:create(0.2)
  local f = CCFadeIn:create(0.2)
  label:runAction(ed.readaction.create({
    t = "seq",
    d,
    f
  }))
end
class.refreshgsLabel = refreshgsLabel
local function createInfoBoard(self)
  local ui = self.ui
  local board
  if not tolua.isnull(ui.info_board) then
    board = ui.info_board
  end
  local newBoard = ed.createNode({
    t = "Sprite",
    config = {isCascadeOpacity = true}
  }, ui.bg, 5)
  ui.info_board = newBoard

  if tolua.isnull(ui.name_bg) then
    return
  end
  local nbx, nby = ui.name_bg:getPosition()
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "name_frame",
        res = ed.Hero.getIconNameFrameByRank(self.hero._rank)
      },
      layout = {
        position = ccp(nbx, nby)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "level",
        text = self.hero._level,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(72, 168)
      },
      config = {
        color = ccc3(146, 0, 4)
      }
    },
    {
      t = "Label",
      base = {
        name = "gs",
        text = self.hero._gs,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(195, 168)
      },
      config = {
        color = ccc3(146, 0, 4)
      }
    },
    {
      t = "Label",
      base = {
        name = "exp",
        text = string.format("%d / %d", herodetail.getHeroExp(self.hid), herodetail.getHeroMaxExp(self.hid)),
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(75, 140)
      },
      config = {
        color = ccc3(146, 0, 4)
      }
    }
  }
  local readNode = ed.readnode.create(newBoard, ui)
  readNode:addNode(ui_info)
  self.prehp = math.floor(ed.UnitCreate(self.hero).attribs.HP)
  self.pregs = self.hero._gs
  if not tolua.isnull(board) then
    newBoard:setOpacity(0)
    local fadeout = CCFadeOut:create(0.2)
    local func = CCCallFunc:create(function()
      xpcall(function()
        if not tolua.isnull(board) then
          board:removeFromParentAndCleanup(true)
        end
        if not tolua.isnull(newBoard) then
          newBoard:runAction(CCFadeIn:create(0.2))
        end
      end, EDDebug)
    end)
    board:runAction(ed.readaction.create({
      t = "seq",
      fadeout,
      func
    }))
  end
end
class.createInfoBoard = createInfoBoard
local function createHeroName(self)
  local ui = self.ui
  if not tolua.isnull(ui.name) then
    ui.name:removeFromParentAndCleanup(true)
  end
  local nbx, nby = ui.name_bg:getPosition()
  local name, w, h = ed.readhero.createHeroNameByInfo({
    name = herodetail.getUnitRow(self.hid)["Display Name"],
    rank = self.hero._rank
  })
  ui.name = name
  if w > 130 then
    name:setScale(130 / w)
  end
  name:setPosition(ccp(nbx - math.min(w, 130) / 2, nby))
  ui.bg:addChild(name)
end
class.createHeroName = createHeroName
local function createHeroStars(self, isEvolve)
  local ui = self.ui
  if not tolua.isnull(ui.hero_stars) then
    ui.hero_stars:removeFromParentAndCleanup(true)
  end
  --local container = ed.createNode({t = "Sprite",base = {z = 210}}, self.container)
  --ui.hero_stars = container

  local container = CCSprite:create()
  self.ui.heroStars = container

  local stars = {}
  local amount = self.hero._stars
  for i = 1, res.hero_max_star do
    local star = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/HVGA/herodetail_star_grey.png"
      },
      layout = {
        position = ccp(364 + 20 * (i - 1), 258)
      }
    }, container)
  end
  for i = 1, amount do
    local star = ed.createNode({
      t = "Sprite",
      base = {
        res = "UI/alpha/HVGA/herodetail_star_yellow.png"
      },
      layout = {
        position = ccp(364 + 20 * (i - 1), 258)
      }
    }, container)
    stars[i] = star
  end
  if isEvolve then
    local star = stars[amount]
    star:setScale(2)
    star:setOpacity(0)
    local d = CCDelayTime:create(0.5)
    local f = CCFadeIn:create(0.2)
    local s = CCScaleTo:create(0.2, 1)
    s = CCEaseBackIn:create(s)
    star:runAction(ed.readaction.create({
      t = "seq",
      d,
      f,
      s
    }))
  end
  self.container:addChild(container,203)
end
class.createHeroStars = createHeroStars
local createBottomButtons = function(self)
  local ui = self.ui
  local container = CCSprite:create()
  self.bbContainer = container
  ui.bg:addChild(container)
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "detail",
        res = "UI/alpha/HVGA/herodetail-detail-n.png",
        capInsets = CCRectMake(15, 15, 138, 19)
      },
      layout = {
        position = ccp(75, 42)
      },
      config = {
        scaleSize = CCSizeMake(120, 49)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "detail_press",
        res = "UI/alpha/HVGA/herodetail-detail-pressed-n.png",
        capInsets = CCRectMake(15, 15, 138, 19),
        parent = "detail"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(120, 49),
        visible = false
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "detail_select",
        res = "UI/alpha/HVGA/herodetail-detail-a.png",
        capInsets = CCRectMake(15, 15, 138, 19)
      },
      layout = {
        position = ccp(75, 42.5)
      },
      config = {
        scaleSize = CCSizeMake(124, 50),
        visible = false
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "detail_select_press",
        res = "UI/alpha/HVGA/herodetail-detail-pressed-a.png",
        capInsets = CCRectMake(15, 15, 138, 19),
        parent = "detail_select"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(124, 50),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "detail_label",
        text = T(LSTR("HERODETAIL.DETAILED_PROPERTIES")),
        size = 20,
        z = 1,
		fontinfo = "ui_normal_button"
      },
      layout = {
        position = ccp(75, 41)
      },
      config = {}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "card",
        res = "UI/alpha/HVGA/herodetail-detail-n.png",
        capInsets = CCRectMake(15, 15, 138, 19)
      },
      layout = {
        position = ccp(200, 42)
      },
      config = {
        scaleSize = CCSizeMake(120, 49)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "card_press",
        res = "UI/alpha/HVGA/herodetail-detail-pressed-n.png",
        capInsets = CCRectMake(15, 15, 138, 19),
        parent = "card"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(120, 49),
        visible = false
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "card_select",
        res = "UI/alpha/HVGA/herodetail-detail-a.png",
        capInsets = CCRectMake(15, 15, 138, 19)
      },
      layout = {
        position = ccp(200, 42.5)
      },
      config = {
        scaleSize = CCSizeMake(124, 50),
        visible = false
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "card_select_press",
        res = "UI/alpha/HVGA/herodetail-detail-pressed-a.png",
        capInsets = CCRectMake(15, 15, 138, 19),
        parent = "card_select"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(124, 50),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "card_label",
        text = T(LSTR("HERODETAIL.ILLUSTRATIONS")),
        size = 20,
        z = 1,
		    fontinfo = "ui_normal_button"
      },
      layout = {
        position = ccp(200, 41)
      },
      config = {}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "skill",
        res = "UI/alpha/HVGA/herodetail-detail-n.png",
        capInsets = CCRectMake(15, 15, 138, 19)
      },
      layout = {
        position = ccp(326, 42)
      },
      config = {
        scaleSize = CCSizeMake(120, 49)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "skill_press",
        res = "UI/alpha/HVGA/herodetail-detail-pressed-n.png",
        capInsets = CCRectMake(15, 15, 138, 19),
        parent = "skill"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(120, 49),
        visible = false
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "skill_select",
        res = "UI/alpha/HVGA/herodetail-detail-a.png",
        capInsets = CCRectMake(15, 15, 138, 19)
      },
      layout = {
        position = ccp(326, 42.5)
      },
      config = {
        scaleSize = CCSizeMake(124, 50),
        visible = false
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "skill_select_press",
        res = "UI/alpha/HVGA/herodetail-detail-pressed-a.png",
        capInsets = CCRectMake(15, 15, 138, 19),
        parent = "skill_select"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {
        scaleSize = CCSizeMake(124, 50),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "skill_label",
        text = T(LSTR("TODOLIST.SKILLS_UPGRADING")),
        size = 20,
        z = 1,
		fontinfo = "ui_normal_button"
      },
      layout = {
        position = ccp(326, 41)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "equip",
        res = "UI/alpha/HVGA/equip_advance_bg.png"
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(100, 410)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "equip_press",
        res = "UI/alpha/HVGA/equip_advance_bg2.png"
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(100, 410)
      },
      config = {visible = false}
    }
  }
  local readNode = ed.readnode.create(container, ui)
  readNode:addNode(ui_info)
  ed.teach("SUclickSkillButton", ui.skill, {
    container,
    self.pageLayer
  })
end
class.createBottomButtons = createBottomButtons
local function refreshStone(self)
  local ui = self.ui
  local isMaxStar = herodetail.checkHeroMaxStar(self.hid)
  local text = isMaxStar and T(LSTR("HERODETAIL.HAVE_EVOLVED_TO_TOP")) or string.format("%d/%d", ed.readhero.getStoneAmount(self.hid), herodetail.getHeroEvolveStoneNeed(self.hid))
  ed.setString(ui.stone_bar_label, text)
  ui.evolve:setVisible(not isMaxStar)
  local a, ta = ed.readhero.getStoneAmount(self.hid), herodetail.getHeroEvolveStoneNeed(self.hid)
  if isMaxStar then
    a, ta = 1, 1
  end
  self.sbContainer:setClipRect(CCRectMake(0, 0, math.min(a / ta, 1) * self.stone_bar_len, 26))
end
class.refreshStone = refreshStone
local doEvolveRefresh = function(self)
  self:createHeroStars(true)
  self:refreshStone()
end
class.doEvolveRefresh = doEvolveRefresh
local function createStoneBar(self)
  local ui = self.ui
  local sbContainer = CCLayer:create()
  self.sbContainer = sbContainer
  local parent = ui.stone_bar_bg
  sbContainer:setAnchorPoint(ccp(0, 0))
  parent:addChild(sbContainer)
  local stoneBar = ed.createNode({
    t = "Scale9Sprite",
    base = {
      res = "UI/alpha/HVGA/heropackage_soulstone_progress.png",
      capInsets = CCRectMake(20, 1, 102, 24)
    },
    layout = {
      anchor = ccp(0, 0)
    },
    config = {
      scaleSize = CCSizeMake(self.stone_bar_len, 26)
    }
  }, sbContainer)
  local a, ta = ed.readhero.getStoneAmount(self.hid), herodetail.getHeroEvolveStoneNeed(self.hid)
  if herodetail.checkHeroMaxStar(self.hid) then
    a, ta = 1, 1
  end
  sbContainer:setClipRect(CCRectMake(0, 0, math.min(a / ta, 1) * self.stone_bar_len, 26))
end
class.createStoneBar = createStoneBar
local createOtherPlayerLayer = function(self)
  self.otherPlayerUI = {}
  local res = {
    {
      t = "Sprite",
      base = {
        name = "ui",
        res = "UI/alpha/HVGA/pvp/pvp_rank_name_bg.png"
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(320, 125)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "ui",
        res = "UI/alpha/HVGA/pvp/main_head_level_bg_silver.png"
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(320, 125)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {name = "icon"},
      layout = {
        anchor = ccp(0, 1),
        position = ccp(295, 110)
      }
    },
    {
      t = "Label",
      base = {
        name = "level",
        text = self.otherPlayerInfo.level,
        fontinfo = "normal_button"
      },
      layout = {
        anchor = ccp(0.5, 1),
        position = ccp(337, 120)
      }
    },
    {
      t = "Label",
      base = {
        name = "name",
        text = self.otherPlayerInfo.name,
        fontinfo = "normal_button",
        max_width = 200
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(360, 112)
      }
    },
    {
      t = "Label",
      base = {
        name = "ui",
        text = T(LSTR("HERODETAIL.FROM_")),
        fontinfo = "normal_black"
      },
      layout = {
        anchor = ccp(0, 1),
        position = ccp(227, 122)
      }
    }
  }
  local readNode = ed.readnode.create(self.container, self.otherPlayerUI)
  readNode:addNode(res)
  local param = {
    id = self.otherPlayerInfo.icon
  }
  local head = ed.getHeroIconByID(param)
  if head then
    self.otherPlayerUI.icon:removeAllChildrenWithCleanup(true)
    head:setScale(0.6)
    self.otherPlayerUI.icon:addChild(head)
  end
end
local function initUI(self)
  if self.otherPlayerInfo then
    self.ui.upgrade_label:setVisible(false)
    self.ui.upgrade:setVisible(false)
    self.ui.evolve:setVisible(false)
    self.ui.evolve_label:setVisible(false)
    self.ui.get_stone:setVisible(false)
    self.ui.stone:setVisible(false)
    self.ui.stone_bar_bg:setVisible(false)
    self.ui.stone_bar_label:setVisible(false)
    createOtherPlayerLayer(self)
  end
end
local turnPrePage = function(self)
  local index = self.index - 1
  if index < 1 then
    index = #self.herolist
  end
  local hero = self.herolist[index]
  self.hero = hero
  herodetail.setHero(hero)
  self.index = index
  self:createWindow({from = "turnPage"})
end
class.turnPrePage = turnPrePage
local turnNextPage = function(self)
  local index = self.index + 1
  if index > #self.herolist then
    index = 1
  end
  local hero = self.herolist[index]
  self.hero = hero
  herodetail.setHero(hero)
  self.index = index
  self:createWindow({from = "turnPage"})
end
class.turnNextPage = turnNextPage
local createArrowButton = function(self)
  if not self.herolist then
    return
  end
  local container = self.animLayer
  local ui = self.ui
  local readnode = ed.readnode.create(container, ui)
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "left_arrow",
        res = "UI/alpha/HVGA/herodetail_arrow_left.png",
        z = 16
      },
      layout = {
        position = ccp(58, 180)
      },
      config = {
        visible = #self.herolist > 1
      }
    },
    {
      t = "Sprite",
      base = {
        name = "right_arrow",
        res = "UI/alpha/HVGA/herodetail_arrow_right.png",
        z = 16
      },
      layout = {
        position = ccp(742, 180)
      },
      config = {
        visible = #self.herolist > 1
      }
    }
  }
  readnode:addNode(ui_info)
  for k, v in ipairs({
    ui.left_arrow,
    ui.right_arrow
  }) do
    local fo = CCFadeOut:create(1)
    local fi = CCFadeIn:create(1)
    local s = ed.readaction.create({
      t = "seq",
      fo,
      fi
    })
    v:runAction(CCRepeatForever:create(s))
  end
  if ui.left_arrow:isVisible() then
    self:btRegisterRectClick({
      rect = CCRectMake(0, 0, 75, 480),
      pressHandler = function()
        ui.left_arrow:setScale(0.95)
      end,
      cancelPressHandler = function()
        ui.left_arrow:setScale(1)
      end,
      clickHandler = function()
        self:btRemoveMainTouchHandler({
          key = "left_arrow_button"
        })
        self:btRemoveMainTouchHandler({
          key = "right_arrow_button"
        })
        self:turnPrePage()
      end,
      key = "left_arrow_button"
    })
  end
  if ui.right_arrow:isVisible() then
    self:btRegisterRectClick({
      rect = CCRectMake(725, 0, 75, 400),
      pressHandler = function()
        ui.left_arrow:setScale(0.95)
      end,
      cancelPressHandler = function()
        ui.left_arrow:setScale(1)
      end,
      clickHandler = function()
        self:btRemoveMainTouchHandler({
          key = "left_arrow_button"
        })
        self:btRemoveMainTouchHandler({
          key = "right_arrow_button"
        })
        self:turnNextPage()
      end,
      key = "right_arrow_button"
    })
  end
end
class.createArrowButton = createArrowButton
local function createWindow(self, param)
  if not tolua.isnull(self.pageLayer) then
    self.pageLayer:removeFromParentAndCleanup(true)
    self:btRemoveMainTouchHandler("main_handler")
  end
  local mainLayer = self.mainLayer
  local ui = self.ui
  local hero = self.hero
  self.hid = hero._tid
  self.attInfo = ed.readhero.getHeroAttByHero(hero)
  local pageLayer = CCLayer:create()
  mainLayer:addChild(pageLayer)
  self.pageLayer = pageLayer
  local animLayer = CCLayer:create()
  self.animLayer = animLayer
  animLayer:setAnchorPoint(ccp(0.5, 0.5))
  pageLayer:addChild(animLayer, 10)
  local container = CCSprite:create()
  container:setAnchorPoint(ccp(0, 0))
  animLayer:addChild(container, 10)
  self.container = container
  local ui_info = {
    {
      t = "Sprite",
      base = {
        name = "bg",
        res = "UI/alpha/HVGA/herodetail-bg.png"
      },
      layout = {
        position = ccp(400, 240)
      },
      config = {}
    }
  }
  local readNode = ed.readnode.create(self.container, ui)
  readNode:addNode(ui_info)
  ui_info = {
    {
      t = "Sprite",
      base = {
        name = "close",
        res = "UI/alpha/HVGA/herodetail-detail-close.png"
      },
      layout = {
        position = ccp(398, 425)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "close_press",
        res = "UI/alpha/HVGA/herodetail-detail-close-p.png",
        parent = "close"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "name_bg",
        res = "UI/alpha/HVGA/herodetail_name_bg.png"
      },
      layout = {
        position = ccp(228, 202)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "type_icon",
        res = herodetail.getHeroTypeRes(self.hid),
        z = 202
      },
      layout = {
        position = ccp(122, 204)
      },
      config = {}
    },
    {
      t = "Label",
      base = {
        name = "max_level_title",
        text = T(LSTR("HERODETAIL.LEVEL_")),
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(22, 168)
      },
      config = {
        color = ccc3(0, 0, 0)
      }
    },
    {
      t = "Label",
      base = {
        name = "gs_title",
        text = T(LSTR("HERODETAIL.POWER_")),
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(125, 168)
      },
      config = {
        color = ccc3(0, 0, 0)
      }
    },
    {
      t = "Label",
      base = {
        name = "exp_title",
        text = T(LSTR("HERODETAIL.EXPERIENCE_")),
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(22, 140)
      },
      config = {
        color = ccc3(0, 0, 0)
      }
    },
    --[[{
      t = "Sprite",
      base = {
        name = "upgrade",
        res = "UI/alpha/HVGA/herodetail-upgrade.png"
      },
      layout = {
        position = ccp(327, 155)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "upgrade_press",
        res = "UI/alpha/HVGA/herodetail-upgrade-mask.png",
        parent = "upgrade"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    },]]
	  {
		  t = "Scale9Sprite",
		  base = {
			  name = "upgrade",
			  res = "UI/alpha/HVGA/herodetail-detail-n.png",
			  capInsets = CCRectMake(15, 15, 138, 19)
		  },
		  layout = {
			  position = ccp(335, 155)
		  },
		  config = {
			  scaleSize = CCSizeMake(100, 42)
		  }
	  },
	  {
		  t = "Scale9Sprite",
		  base = {
			  name = "upgrade_press",
			  res = "UI/alpha/HVGA/herodetail-detail-pressed-n.png",
			  capInsets = CCRectMake(15, 15, 138, 19),
			  parent = "upgrade"
		  },
		  layout = {
			  anchor = ccp(0, 0),
			  position = ccp(0, 0)
		  },
		  config = {
			  scaleSize = CCSizeMake(100, 42),
			  visible = false
		  }
	  },
	  {
		  t = "Scale9Sprite",
		  base = {
			  name = "upgrade_select",
			  res = "UI/alpha/HVGA/herodetail-detail-a.png",
			  capInsets = CCRectMake(15, 15, 138, 19)
		  },
		  layout = {
			  position = ccp(335, 155)
		  },
		  config = {
			  scaleSize = CCSizeMake(100, 42),
			  visible = false
		  }
	  },
	  {
		  t = "Scale9Sprite",
		  base = {
			  name = "upgrade_select_press",
			  res = "UI/alpha/HVGA/herodetail-detail-pressed-a.png",
			  capInsets = CCRectMake(15, 15, 138, 19),
			  parent = "upgrade_select"
		  },
		  layout = {
			  anchor = ccp(0, 0),
			  position = ccp(0, 0)
		  },
		  config = {
			  scaleSize = CCSizeMake(100, 42),
			  visible = false
		  }
	  },
    {
      t = "Label",
      base = {
        name = "upgrade_label",
        text = T(LSTR("HERODETAIL.ADVANCE_")),
        --size = 18,
        z = 1,
        --parent = "upgrade",
		fontinfo = "ui_normal_button"
      },
      layout = {
		  --mediate = true,
		  position = ccp(335, 155)
	  },
      config = {scaleSize = CCSizeMake(100, 42)}
    },
    {
      t = "Sprite",
      base = {
        name = "line",
        res = "UI/alpha/HVGA/dialog_line.png"
      },
      layout = {
        position = ccp(190, 125)
	  }
	  ,config = {visible = false}
    },
    {
      t = "Sprite",
      base = {
        name = "stone",
        res = "UI/alpha/HVGA/herodetail_soulstone_icon.png"
      },
      layout = {
        position = ccp(35, 98)
      },
      config = {}
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "stone_bar_bg",
        res = "UI/alpha/HVGA/heropackage_soulstone_progress_bg.png",
        capInsets = CCRectMake(20, 1, 102, 24)
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(58, 98)
      },
      config = {
        scaleSize = CCSizeMake(180, 26)
      }
    },
    {
      t = "Label",
      base = {
        name = "stone_bar_label",
        text = herodetail.checkHeroMaxStar(self.hid) and T(LSTR("HERODETAIL.HAVE_EVOLVED_TO_TOP")) or string.format("%d/%d", ed.readhero.getStoneAmount(self.hid), herodetail.getHeroEvolveStoneNeed(self.hid)),
        size = 18
      },
      layout = {
        position = ccp(148, 98)
      },
      config = {
        shadow = {
          color = ccc3(0, 0, 0),
          offset = ccp(0, 2)
        }
      }
    },
    {
      t = "Sprite",
      base = {
        name = "get_stone",
        res = "UI/alpha/HVGA/herodetail_status_plus_icon_1.png"
      },
      layout = {
        position = ccp(263, 98)
      },
      config = {}
    },
    {
      t = "Sprite",
      base = {
        name = "get_stone_press",
        res = "UI/alpha/HVGA/herodetail_status_plus_icon_2.png",
        parent = "get_stone"
      },
      layout = {
        anchor = ccp(0, 0),
        position = ccp(0, 0)
      },
      config = {visible = false}
    },
    --[[{
      t = "Sprite",
      base = {
        name = "evolve",
        res = "UI/alpha/HVGA/herodetail-upgrade.png"
      },
      layout = {
        position = ccp(310, 95)
      },
      config = {
        visible = not herodetail.checkHeroMaxStar(self.hid)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "evolve_press",
        res = "UI/alpha/HVGA/herodetail-upgrade-mask.png",
        parent = "evolve"
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
        name = "evolve_label",
        text = T(LSTR("HERODETAIL.EVOLUTION_")),
        size = 20,
        z = 1,
        parent = "evolve",
		fontinfo = "ui_normal_button"
      },
      layout = {mediate = true}
    },]]
	  {
		  t = "Scale9Sprite",
		  base = {
			  name = "evolve",
			  res = "UI/alpha/HVGA/herodetail-detail-n.png",
			  capInsets = CCRectMake(15, 15, 138, 19)
		  },
		  layout = {
			  position = ccp(335, 98)
		  },
		  config = {
			  scaleSize = CCSizeMake(100, 42),
        visible = not herodetail.checkHeroMaxStar(self.hid)
		  }
	  },
	  {
		  t = "Scale9Sprite",
		  base = {
			  name = "evolve_press",
			  res = "UI/alpha/HVGA/herodetail-detail-pressed-n.png",
			  capInsets = CCRectMake(15, 15, 138, 19),
			  parent = "evolve"
		  },
		  layout = {
			  anchor = ccp(0, 0),
			  position = ccp(0, 0)
		  },
		  config = {
			  scaleSize = CCSizeMake(100, 42),
			  visible = false
		  }
	  },
	  {
		  t = "Label",
		  base = {
			  name = "evolve_label",
			  text = T(LSTR("HERODETAIL.EVOLUTION_")),
			  z = 1,
			  parent = "evolve",
			  fontinfo = "ui_normal_button"
		  },
		  layout = {
        anchor = ccp(0.5, 0.5),
			  position = ccp(50, 20)
		  },
		  config = {}
	  },
	  {
		  t = "Scale9Sprite",
		  base = {
			 name = "onekey",
			 res = "UI/alpha/HVGA/herodetail-detail-n.png",
			 capInsets = CCRectMake(15, 15, 138, 19)
		  },
		  layout = {
			 position = ccp(335, 150)
		  },
		  config = {
			 scaleSize = CCSizeMake(100, 42),
             visible = false
		  }
	  },
	  {
		  t = "Scale9Sprite",
		  base = {
			 name = "onekey_press",
			 res = "UI/alpha/HVGA/herodetail-detail-pressed-n.png",
			 capInsets = CCRectMake(15, 15, 138, 19),
			 parent = "onekey"
		  },
		  layout = {
			 anchor = ccp(0, 0),
			 position = ccp(0, 0)
		  },
		  config = {
			 scaleSize = CCSizeMake(100, 42),
			 visible = false
		  }
	  },
  	  {
		  t = "Label",
		  base = {
			 name = "onekey_label",
			 text = T(LSTR("EQUIP.ONEKEYEQUIP")),
			 z = 1,
			 parent = "onekey",
			 fontinfo = "ui_normal_button"
		  },
		  layout = {
			 anchor = ccp(0.5, 0.5),
			 position = ccp(50, 20)
		  },
		  config = {}
	  }
  }
  readNode = ed.readnode.create(ui.bg, ui)
  readNode:addNode(ui_info)
  self:createStoneBar()
  self:createBottomButtons()
  self:createHeroName()
  self:createHeroStars()
  self:createInfoBoard()
  self:createEquipIcons()
  self:createArrowButton()
  self:createHeroFca()
  self:refreshUpgradeButton()
  if self:canHeroUpgrade() then
    self:createUpgradeButtonLight()
    ed.teach("heroUpgrade", ui.upgrade, ui.bg)
  end
  initUI(self)
  self:setOpenMode(self.openMode, {
    skipAnim = true,
    from = (param or {}).from,
    force = true
  })
  self:registerTouchHandler()
end
class.createWindow = createWindow
local refreshUpgradeButton = function(self)
  local ui = self.ui
  if self.hero._rank >= ed.parameter.unit_max_rank then
    ui.upgrade:setVisible(false)
	ui.upgrade_label:setVisible(false)
  else
    ui.upgrade:setVisible(true)
	ui.upgrade_label:setVisible(true)
  end
end
class.refreshUpgradeButton = refreshUpgradeButton
local function create(hero, otherPlayerInfo, addition)
  addition = addition or {}
  local self = base.create("herodetail")
  setmetatable(self, class.mt)
  herofca = herodetail.herofca
  ed.ui.herodetail.init()
  self.hero = hero
  self.herolist = addition.list
  self.index = addition.index
  self.openMode = addition.openMode
  self.otherPlayerInfo = otherPlayerInfo or nil
  self.baseScene = ed.getCurrentScene()
  self:createWindow({from = "create"})
  self.isSkipTransAnim = true
  function self.showCallback()
    lsr:report("createWindow")
  end
  function self.destroyCallback()
    lsr:report("closeWindow")
    --add by xinghui
    if --[[ed.tutorial.checkDone("closeHeroDetail")==false--]] ed.tutorial.isShowTutorial then
        ed.sendDotInfoToServer(ed.tutorialres.t_key["closeHeroDetail"].id)
    end
    --
    ed.endTeach("closeHeroDetail")
    if self.destroyHandler then
      self.destroyHandler()
    end
  end
  self:show()
  return self
end
class.create = create
