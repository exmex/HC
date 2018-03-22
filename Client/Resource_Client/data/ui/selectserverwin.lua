local selectserverwin = {}
selectserverwin.__index = selectserverwin
local base = ed.ui.basescene
setmetatable(selectserverwin, base.mt)
ed.ui.selectserverwin = selectserverwin
local SelectServerId = ""
local SelectServerName = ""
local SelectServerPlayerName = ""
local stateColor = {
  [T(LSTR("SERVERLOGIN.MAINTAINENACE"))] = ccc3(183, 183, 183),
  [T(LSTR("SERVERLOGIN.FULL"))] = ccc3(255, 81, 20),
  [T(LSTR("SERVERLOGIN.BUSY"))] = ccc3(255, 225, 20),
  [T(LSTR("SERVERLOGIN.RECOMMEND"))] = ccc3(20, 255, 59)
}
local maxServerId = 0
local clientVersion = ""
local sessionId = ""
local user_id = ""
local initServerEvent, redoInitServerEvent
local serverListData = {}
local isOpen = false
local function getServerName(index)
  if serverListData[index] ~= nil then
    return serverListData[index]._server_name
  end
  return ""
end
local function getServerNameById(id)
  for i, v in ipairs(serverListData) do
    if v._server_id == tonumber(id) then
      return v._server_name
    end
  end
end
local serverList = {}
local buttonHandle = {
  entergame = "enterGame",
  backbtn = "backbtn",
  selectserver = "selectServer",
  selectlastserve = "selectLastServer"
}
local panelui = {}
local buttonList = {}
local selectServerContainer, enterContainer
local function getServerInfo(name)
  for i, v in ipairs(serverListData) do
    if v._server_name == name then
      return v
    end
  end
end
local function getServerInfoById(id)
  for i, v in ipairs(serverListData) do
    if v._server_id == id then
      return v
    end
  end
end
--add by xinghui
local function getServerInfoByIdNew(id)
	for i, v in ipairs(ed.serverListData) do
	  if v.id == id then
        return v
      end
	end
end
--
function selectserverwin.refreshCurrentServerInfo(name)
  local serverInfo = getServerInfo(name)
  if serverInfo then
    ed.setString(panelui.servername, name)
    if panelui.servername.width > 140 then
      panelui.servername:setScale(140 / panelui.servername:getContentSize().width)
    end
    selectServerContainer:setVisible(true)
    --local info = {id = game_server_id}
    --LegendAndroidExtra("setGameData", ed.getJson(info))
  end
end
function selectserverwin.selectLastServer()
  selectserverwin.refreshCurrentServerInfo(game_server_id)
end
local function doEnterGameTouch(self, event, x, y)
  local button = buttonList.entergame
  local press = self.buttonPress.entergame
  if event == "began" then
    if ed.containsPoint(button, x, y) then
      self.isPressEnterGame = true
      press:setVisible(true)
    end
  elseif event == "ended" then
    local k = self.isPressEnterGame
    self.isPressEnterGame = nil
    if k then
      press:setVisible(false)
      if ed.containsPoint(button, x, y) then
        if SelectServerId == "" then
          local text = T(LSTR("SELECT.SERVER.EMPTY"))
          local info = {
            text = text,
          }
          ed.showAlertDialog(info)
          return 
        end
		CCUserDefault:sharedUserDefault():setStringForKey("lastservername",SelectServerName)
        if SelectServerPlayerName then
            isOpen = false
            local changeServer = ed.upmsg.change_server()
            changeServer._op_type = 1
            changeServer._server_id = tonumber(SelectServerId)
            ed.send(changeServer, "change_server")
        else
            local info = {
            text = T(LSTR("SELECT.SERVER.OK"),currentServerName),
            rightText = rightText,
            rightHandler = rightHandler,
            textSize = 17,
			textColor = ccc3(255, 255, 255),
            rightDestroyHandler = function()
              isOpen = false
              local changeServer = ed.upmsg.change_server()
              changeServer._op_type = 1
              changeServer._server_id = tonumber(SelectServerId)
              ed.send(changeServer, "change_server")
            end
          }
          ed.showConfirmDialog(info)
        end

      end
    end
  end
end
selectserverwin.doEnterGameTouch = doEnterGameTouch
local function doBackGameTouch(self, event, x, y)
  local button = buttonList.backbtn
  local press = self.buttonPress.backbtn
  if event == "began" then
    if ed.containsPoint(button, x, y) then
      press:setVisible(true)
    end
  elseif event == "ended" then
    press:setVisible(false)
    if ed.containsPoint(button, x, y) then
      isOpen = false
      ed.popScene()
    end
  end
end
selectserverwin.doBackGameTouch = doBackGameTouch
function selectserverwin:doMainLayerTouch()
  local function handler(event, x, y)
      self:doEnterGameTouch(event, x, y)
      self:doBackGameTouch(event, x, y)
      return true
  end
  return handler
end
function selectserverwin:doPressInList()
  local function handler(x, y)
    local tindex = 1;
    for i = 1, #serverList do
      if ed.containsPoint(serverList[i].highlightbg, x, y) and selectServerContainer and selectServerContainer:isVisible() then
        serverList[i].highlightbg:setVisible(true)
        tindex = i
        SelectServerId = serverList[i].info._server_id
        SelectServerName = serverList[i].info._server_name
        SelectServerPlayerName = serverList[i].info._player_name
      else
        serverList[i].highlightbg:setVisible(false)
      end
    end
  end
  return handler
end
function selectserverwin:doClickInServerHandler(clickHandler)
  local function handler(id)
    if serverListData[id] then
      self.refreshCurrentServerInfo(serverListData[id]._server_id)
    end
  end
  return handler
end
function selectserverwin:doClickInList(clickHandler)
  local function handler(x, y, id)
    if serverList[id] then
      if not ed.containsPoint(serverList[id].highlightbg, x, y) then
        return
      end
      if clickHandler then
        clickHandler(id)
      end
    end
  end
  return handler
end
function selectserverwin:cancelPressInList()
  local function handler(x, y, id)
    serverList[id].highlightbg:setVisible(true)
  end
  return handler
end
function selectserverwin:cancelClickInList()
  local function handler(x, y, id)
    serverList[id].bg:setScale(1)
    serverList[id].highlightbg:setVisible(true)
  end
  return handler
end
function selectserverwin:createServer(info)
  if info._server_name == nil or info._server_name == "" then
    return
  end
  local progressColor = {
    ccc3(70, 114, 0),
    ccc3(138, 56, 1)
  }
  local board = {}
  local bg = CCSprite:create()
  board.bg = bg
  --local color = info.color and ed.toccc3(info.color) or stateColor[info.state]
  local serverState = LSTR("SERVERLOGIN.RECOMMEND")
--modify by xinghui
  local serverInfo = getServerInfoByIdNew(info._server_id)
  if serverInfo then
	if serverInfo.state == 0 then
	  serverState = LSTR("SERVERLOGIN.BUSY")
	elseif serverInfo.state == 1 then
	  serverState = LSTR("SERVERLOGIN.RECOMMEND")
	elseif serverInfo.state == 2 then
	  serverState = LSTR("SERVERLOGIN.FULL")
	end
  end
--
  --[[if info._server_id == maxServerId then
    --modify by xinghui
	serverState = LSTR("SERVERLOGIN.RECOMMEND")
    --serverState = "Recommend"
  end--]]

  local color = stateColor[serverState]
  local ui_info = {
    {
      t = "Scale9Sprite",
      base = {
        name = "highlightbg",
        res = "installer/serverselect_highlight_bg.png",
        capInsets = CCRectMake(80, 10, 190, 12)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(250, 71)
      },
      config = {
        scaleSize = CCSizeMake(554, 42),
        visible = false
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "lineinfo",
        res = "installer/serverselect_delimiter.png",
        capInsets = CCRectMake(80, 0, 190, 2)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(250, 50)
      },
      config = {
        scaleSize = CCSizeMake(560, 2)
      }
    },
    {
      t = "Label",
      base = {
        name = "serverid",
        text = "",
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(0, 71)
      },
      config = {color = color}
    },
    {
      t = "Label",
      base = {
        name = "servername",
        text = info._server_name,
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(30, 71)
      },
      config = {color = color}
    },
    {
      t = "Label",
      base = {
        name = "serverstate",
        text = serverState,
        size = 18
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(240, 71)
      },
      config = {color = color}
    },
    {
      t = "Label",
      base = {
        name = "playername",
        text = (info._player_name or ""),
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(310, 71)
      },
      config = {color = color}
    },
    {
      t = "Label",
      base = {
        name = "playerlevel",
        text = "",
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(460, 71)
      },
      config = {color = color}
    }
  }
  local readNode = ed.readnode.create(bg, board)
  readNode:addNode(ui_info)
  board.info = info
  if info._player_level then
    ed.setString(board.playerlevel, T(LSTR("SELECT.SERVER.LEVEL"),info._player_level))
  end
  
  if board.servername:getContentSize().width > 140 then
      board.servername:setScale(140 / board.servername:getContentSize().width)
  end
  if board.playername:getContentSize().width > 140 then
      board.playername:setScale(140 / board.playername:getContentSize().width)
  end
  self.draglist:addItem(bg)
  return board
end
function selectserverwin:refreshList()
  for i = 1, #serverList do
    serverList[i].bg:setPosition(ccp(150, 200 - 42 * (i - 1)))
  end
  self.draglist:initListHeight(42 * #serverList + 20)
end
function selectserverwin:createListLayer()
  --if self.draglist ~= nil then
  --  return
  --end
  self.draglist = nil
  local info = {
    cliprect = CCRectMake(104, 90, 610, 200),
    noshade = true,
    container = selectServerContainer,
    doPressIn = self:doPressInList(),
    doClickIn = self:doClickInList(self:doClickInServerHandler()),
    cancelPressIn = self:cancelPressInList(),
    cancelClickIn = self:cancelClickInList()
  }
  self.draglist = ed.draglist.create(info)
end
function selectserverwin:initServerList()
  for i, v in ipairs(serverListData) do
    table.insert(serverList, self:createServer(v))
  end
end
function selectserverwin.onExitFramework()
  selectServerContainer = nil
  buttonList = {}
  panelui = {}
  serverListData = {}
  EDServerList = {}
  serverList = {}
end
local function closeEvent()
  if initServerEvent then
    CloseTimer(initServerEvent.Name)
    initServerEvent = nil
  end
  if redoInitServerEvent then
    CloseTimer(redoInitServerEvent.Name)
    redoInitServerEvent = nil
  end
  ed.loadEnd()
end
function selectserverwin:initServer()
  closeEvent()
  self:createListLayer()
  self:initServerList()
  self:refreshList()
  currentServerName =getServerNameById(game_server_id)

  if currentServerName ~= "" then
    ed.setString(panelui.lastserverid, tostring(""))
    ed.setString(panelui.lastservername, currentServerName)
    ed.setString(panelui.lastserverplayername, tostring(ed.player:getName()))
    ed.setString(panelui.lastserverplayerlevel, T(LSTR("SELECT.SERVER.LEVEL"),ed.player:getLevel()))
    if panelui.lastservername:getContentSize().width > 150 then
      panelui.lastservername:setScale(150 / panelui.lastservername:getContentSize().width)
    end
    if panelui.lastserverplayername:getContentSize().width > 150 then
      panelui.lastserverplayername:setScale(150 / panelui.lastserverplayername:getContentSize().width)
    end
    ed.setString(panelui.servername, currentServerName)
  end
end
function selectserverwin:updateServerList(serverListInfo)
  if serverListInfo == nil then
    return
  end
  for i, v in ipairs(serverListInfo) do
    if v._server_id > maxServerId then
      maxServerId = v._server_id
    end
  end
  serverListData = serverListInfo
  if isOpen then
    selectserverwin:initServer()  
  end
  
end
  
function selectserverwin:doInitServer()
  closeEvent()
  if #serverListData ~= 0 then
    return
  end
  ed.loadBegin(false)
end

function selectserverwin:enterGame()
  --CCUserDefault:sharedUserDefault():setStringForKey("lastservername", lastServerName)
end

function selectserverwin:onEnterFramework()
  local function handler()
    if selectServerContainer then
      selectServerContainer:setVisible(true)
    end
  end
  return handler
end

function selectserverwin.create()
  local newscene = base.create("selectserverwin")
  setmetatable(newscene, selectserverwin)
  local scene = newscene.scene
  local mainLayer = CCLayer:create()
  newscene.mainLayer = mainLayer
  scene:addChild(mainLayer)
  mainLayer:setTouchEnabled(true)
  mainLayer:registerScriptTouchHandler(newscene:doMainLayerTouch(), false, 0, false)
  newscene.buttonPress = {}
  newscene.buttonLabel = {}
  local bg = ed.createSprite("UI/alpha/HVGA/bg.png")
  bg:setPosition(ccp(400, 240))
  mainLayer:addChild(bg)
  bg:setScale(2)
  local ui_select = {
    {
      t = "Scale9Sprite",
      base = {
        name = "selectserverbg",
        res = "installer/serverselect_serverlist_bg.png",
        capInsets = CCRectMake(15, 10, 142, 16)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(400, 200)
      },
      config = {
        scaleSize = CCSizeMake(560, 266)
      }
    },
    {
      t = "Label",
      base = {
        name = "allserver",
        text = T(LSTR("SERVERLOGIN.ALL_SERVERS")),
        size = 20
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(400, 310)
      },
      config = {
        color = ccc3(255, 255, 255)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "selectserverbg",
        res = "installer/serverselect_serverlist_bg.png",
        capInsets = CCRectMake(15, 10, 142, 16)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(400, 380)
      },
      config = {
        scaleSize = CCSizeMake(560, 90)
      }
    },
    {
      t = "Sprite",
      base = {
        name = "selectlastserve",
        array = buttonList
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(400, 362)
      },
      config = {
        messageRect = CCRectMake(0, 0, 400, 42)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "selectlastserve",
        array = newscene.buttonPress,
        res = "installer/serverselect_highlight_bg.png",
        capInsets = CCRectMake(80, 10, 190, 12)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(400, 362)
      },
      config = {
        scaleSize = CCSizeMake(400, 42),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "lastserverid",
        text = "",
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(150, 362)
      },
      config = {
        color = ccc3(251, 206, 16)
      }
    },
    {
      t = "Label",
      base = {
        name = "lastservername",
        text = "",
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(180, 362)
      },
      config = {
        color = ccc3(251, 206, 16)
      }
    },
    {
      t = "Label",
      base = {
        name = "lastserverstate",
        text = "",
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(480, 362)
      },
      config = {
        color = ccc3(251, 206, 16)
      }
    },
    {
      t = "Label",
      base = {
        name = "lastserverplayername",
        text = "name",
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(460, 362)
      },
      config = {
        color = ccc3(251, 206, 16)
      }
    },
    {
      t = "Label",
      base = {
        name = "lastserverplayerlevel",
        text = "level",
        size = 18
      },
      layout = {
        anchor = ccp(0, 0.5),
        position = ccp(610, 362)
      },
      config = {
        color = ccc3(251, 206, 16)
      }
    },
    {
      t = "Label",
      base = {
        name = "allserver",
        text = T(LSTR("SERVERLOGIN.LAST_SIGN")),
        size = 20
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(400, 403)
      },
      config = {
        color = ccc3(255, 255, 255)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "entergame",
        array = buttonList,
        res = "UI/alpha/HVGA/sell_number_button.png",
        capInsets = CCRectMake(15, 22, 15, 25)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(400, 40)
      },
      config = {
        scaleSize = CCSizeMake(170, 45)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "entergame",
        array = newscene.buttonPress,
        res = "UI/alpha/HVGA/sell_number_button_down.png",
        capInsets = CCRectMake(15, 22, 15, 25)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(400, 40)
      },
      config = {
        scaleSize = CCSizeMake(170, 45),
        visible = false
      }
    },
    {
      t = "Label",
      base = {
        name = "entergame",
        array = newscene.buttonLabel,
        text = T(LSTR("SERVERLOGIN.SELECT.SERVER.OK")),
        fontinfo = "ui_normal_button",
        size = 20,
        z = 30
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(399, 39)
      },
      config = {
        color = ccc3(235, 223, 207),
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "backbtn",
        array = buttonList,
        res = "UI/alpha/HVGA/backbtn.png",
        capInsets = CCRectMake(10, 10, 28, 29)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(80, 420)
      },
      config = {
        --scaleSize = CCSizeMake(85, 70)
      }
    },
    {
      t = "Scale9Sprite",
      base = {
        name = "backbtn",
        array = newscene.buttonPress,
        res = "UI/alpha/HVGA/backbtn-disabled.png",
        capInsets = CCRectMake(10, 10, 28, 29)
      },
      layout = {
        anchor = ccp(0.5, 0.5),
        position = ccp(80, 420)
      },
      config = {
        --scaleSize = CCSizeMake(85, 70),
        visible = false
      }
    },

  }
  selectServerContainer = CCSprite:create()
  mainLayer:addChild(selectServerContainer)
  local readNode = ed.readnode.create(selectServerContainer, panelui)
  readNode:addNode(ui_select)

  selectServerContainer:setVisible(true)

  newscene:registerOnEnterHandler("onEnterFramework", newscene:onEnterFramework())
  newscene:registerOnExitHandler("onExitFramework", newscene.onExitFramework)

  local changeServer = ed.upmsg.change_server()
  changeServer._op_type = 0
  changeServer._server_id = 0 -- tonumber(game_server_id)
  ed.send(changeServer, "change_server")

  SelectServerId = ""
  SelectServerName = ""
  selectserverwin.doInitServer()
  isOpen = true
  return newscene
end

