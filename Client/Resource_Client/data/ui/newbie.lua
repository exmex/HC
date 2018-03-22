local ed = ed
local class = {
  mt = {}
}
class.mt.__index = class
local base = ed.ui.basescene
setmetatable(class, base.mt)
ed.ui.newbie = class
local ui
local connect = socket.connect
local connection
local connect_succ = false
local close
local bSendblock = false
local currentMsg, currentMsgType, currentUi
local up = pb_loader("loginup")()
local down = pb_loader("logindown")()
local insert = table.insert
local ipairs = ipairs
local up_code
class.upmsg = up
class.downmsg = down
local cryptkey = "182173559"
local login_game_server_ip = "dgamelogin.lilith.sh"
local login_game_server_port = "20000"
local fadinlength = 0.2
local loadLayer = {}
local loadFunc = {}
local doTouchLoad = function()
  return true
end
local function load(noflower, bReSend)
  local count = 0
  local countRotate = 0
  local count_gap = 0.1
  local resend = true
  if bReSend ~= nil then
    resend = bReSend
  end
  local isLoading
  local function createFlower(scene)
    if not tolua.isnull(loadLayer.layer) then
      return
    end
    local layer = CCLayerColor:create(ccc4(0, 0, 0, 0))
    layer:setTouchEnabled(true)
    layer:registerScriptTouchHandler(doTouchLoad, false, -240, true)
    scene:addChild(layer, 600)
    loadLayer.layer = layer
    if not tolua.isnull(loadLayer.flower) then
      return true
    end
    local flower = ed.createSprite("installer/load_flower.png")
    layer:addChild(flower, 10)
    flower:setPosition(ccp(340, 240))
    loadLayer.flower = flower
    local text = ed.createttf(T(LSTR("NETWORK.CONNECTING")), 20)
    layer:addChild(text, 10)
    text:setPosition(ccp(410, 240))
    local bg = ed.createScale9Sprite("UI/alpha/HVGA/main_vit_tips.png", CCRectMake(15, 20, 45, 15))
    layer:addChild(bg, 9)
    bg:setPosition(ccp(393, 238))
    bg:setContentSize(CCSizeMake(180, 60))
  end
  local function handler(dt)
    dt = dt or 0
    count = count + dt
    countRotate = countRotate + dt
    if count > 8 and resend then
      loadFunc.loadEnd()
      close()
      if currentUi ~= nil then
        currentUi:setVisible(true)
        local action = CCFadeIn:create(fadinlength)
        currentUi:runAction(action)
      end
      FireEvent("SendMsgFail")
    end
    if noflower then
      return
    end
    local scene = CCDirector:sharedDirector():getRunningScene()
    if isLoading and tolua.isnull(loadLayer.layer) then
      return
    end
    if count > 0.5 then
      createFlower(scene)
      isLoading = true
    end
    if countRotate > count_gap then
      local flower = loadLayer.flower
      if not tolua.isnull(flower) then
        flower:setRotation((flower:getRotation() + 30) % 360)
      end
      countRotate = countRotate - count_gap
    end
  end
  return handler
end
local function loadBegin(noflower, bReSend)
  loadFunc.loadEnd()
  if not loadLayer.id then
    local loading = load(noflower, bReSend)
    local scene = CCDirector:sharedDirector():getRunningScene()
    if not tolua.isnull(scene) then
      loadLayer.scheduler = scene:getScheduler()
      loadLayer.id = loadLayer.scheduler:scheduleScriptFunc(loading, 0, false)
    end
  end
end
loadFunc.loadBegin = loadBegin
class.loadBegin = loadBegin
local function loadEnd()
  if loadLayer.id then
    loadLayer.scheduler:unscheduleScriptEntry(loadLayer.id)
    loadLayer.id = nil
  end
  if not tolua.isnull(loadLayer.layer) then
    loadLayer.layer:removeFromParentAndCleanup(true)
  end
  loadLayer = {}
end
loadFunc.loadEnd = loadEnd
class.loadEnd = loadEnd
local function jumpToGame()
  class.checkLoadToken(true)
  currentUi = nil
  LegendLog("login ok,jump to game!")
  ed.ui.serverlogin.enterContainer:setVisible(true)
  ed.ui.serverlogin.SetLogined(T(LSTR("newbie.1.10.1.001")) .. ed.ui.newbie.username)
  ed.setDeviceId(ed.ui.newbie.uin)
  ed.setUserid(ed.ui.newbie.uin)
  ui.registerpanel:setVisible(false)
  ui.newbiebg:setVisible(false)
  ui.forgetpass:setVisible(false)
  ui.updatepass:setVisible(false)
  class.doDeviceInfo()
end
class.jumpToGame = jumpToGame
local function dispatch(msg)
  for k, v in pairs(msg[".data"]) do
    LegendLog(">>> down msg: " .. k)
  end
  if msg.login_reply then
    if msg.login_reply.error_code == 0 then
      ed.ui.newbie.uin = msg.login_reply.uin
      ed.config.tokendata = msg.login_reply.token
      LegendLog("ed.ui.newbie.uin:" .. ed.ui.newbie.uin)
      LegendLog("ed.config.tokendata:" .. ed.config.tokendata)
      EDMicroSoftIapSwitch(msg.login_reply.open_pay)
      jumpToGame()
      return
    elseif msg.login_reply.error_code == 1 then
      ed.showToast(T(LSTR("newbie.1.10.1.002")))
    elseif msg.login_reply.error_code == 2 then
      ed.showToast(T(LSTR("newbie.1.10.1.003")))
    elseif msg.login_reply.error_code == 4 then
      ed.showToast(T(LSTR("newbie.1.10.1.004")))
    elseif msg.login_reply.error_code == 5 then
      ed.showToast(T(LSTR("newbie.1.10.1.005")))
    elseif msg.login_reply.error_code == 6 then
      ed.showToast(T(LSTR("newbie.1.10.1.005")))
    elseif msg.login_reply.error_code == 10 then
      ed.showToast(T(LSTR("newbie.1.10.1.006")))
    else
      ed.showToast("login errcode:" .. tostring(msg.login_reply.error_code))
    end
    LegendLog("login errcode:" .. tostring(msg.login_reply.error_code))
    if currentUi ~= nil then
      currentUi:setVisible(true)
      local action = CCFadeIn:create(fadinlength)
      currentUi:runAction(action)
    end
  end
  if msg.create_user_reply then
    if msg.create_user_reply.error_code == 0 then
      ed.ui.newbie.uin = msg.create_user_reply.uin
      ed.config.tokendata = msg.create_user_reply.token
      LegendLog("ed.ui.newbie.uin:" .. ed.ui.newbie.uin)
      LegendLog("ed.config.tokendata:" .. ed.config.tokendata)
      EDMicroSoftIapSwitch(msg.create_user_reply.open_pay)
      jumpToGame()
      return
    elseif msg.create_user_reply.error_code == 3 then
      ed.showToast(T(LSTR("newbie.1.10.1.007")))
    else
      if msg.create_user_reply.error_code == 8 then
        ed.showToast(T(LSTR("newbie.1.10.1.008")))
      else
      end
    end
    LegendLog("create_user_reply errcode:" .. tostring(msg.create_user_reply.error_code))
    if currentUi ~= nil then
      currentUi:setVisible(true)
      local action = CCFadeIn:create(fadinlength)
      currentUi:runAction(action)
    end
  end
  if msg.logout_reply and msg.logout_reply.error_code == 0 then
    ed.ui.newbie.uin = nil
    ed.config.tokendata = nil
    ed.ui.newbie.resetTokenFile()
    LegendLog("logout errcode:" .. tostring(msg.logout_reply.error_code))
    ed.showAlertDialog({
      text = T(LSTR("newbie.1.10.1.009")),
      buttonText = T(LSTR("NETWORK.QUIT")),
      handler = function()
        os.exit()
      end
    })
  end
  if msg.reset_passwd_reply then
    if msg.reset_passwd_reply.error_code == 0 then
      ed.showToast(T(LSTR("newbie.1.10.1.010")))
    elseif msg.reset_passwd_reply.error_code == 2 then
      ed.showToast(T(LSTR("newbie.1.10.1.011")))
    else
      ed.showToast(T(LSTR("newbie.1.10.1.012")))
      LegendLog("reset_passwd_reply errcode:" .. tostring(msg.reset_passwd_reply.error_code))
    end
  end
  if msg.update_passwd_reply then
    if msg.update_passwd_reply.error_code == 0 then
      ed.showToast(T(LSTR("newbie.1.10.1.013")))
    elseif msg.update_passwd_reply.error_code == 1 then
      ed.showToast(T(LSTR("newbie.1.10.1.014")))
    elseif msg.update_passwd_reply.error_code == 7 then
      ed.showToast(T(LSTR("newbie.1.10.1.015")))
    else
      ed.showToast(T(LSTR("newbie.1.10.1.016")))
      LegendLog("update_passwd_reply errcode:" .. tostring(msg.update_passwd_reply.error_code))
    end
  end
  if msg.deviceinfo_reply and msg.deviceinfo_reply.error_code == 0 then
    LegendLog("deviceinfo_reply errcode:" .. tostring(msg.deviceinfo_reply.error_code))
  end
end
class.dispatch = dispatch
function close()
  if connection then
    connection:close()
  end
  connection = nil
  connect_succ = false
  up_code = nil
end
local function connect(block)
  connection, err = socket.tcp()
  if not connection then
    LegendLog(string.format("ERROR | Connect failed when creating socket | %s", err))
    return false
  end
  connection:settimeout(block and 5 or 0)
  local err
  connect_succ, err = connection:connect(login_game_server_ip, login_game_server_port)
  if connect_succ then
    LegendLog("    connect succ")
    connection:settimeout(0)
    local r1, r2 = connection:send(up_code)
    if r1 then
      LegendLog("<<< Message Sent  @ " .. ed.getYMDTime())
    else
      LegendLog(string.format("ERROR | connection:send failed | %s", err))
    end
    close()
  elseif block then
    LegendLog(string.format("ERROR | Blocked Connect failed | %s", err))
    return false
  else
    LegendLog("    connect start")
    local notShowFlower = true
    if not ed.isElementInTable(currentMsgType, {
      "reset_elite",
      "query_data"
    }) then
      notShowFlower = nil
    end
    loadBegin(notShowFlower)
    return true
  end
end
local function connect_resume()
  if connect_succ or not connection then
    return
  end
  local r, w, e = socket.select({connection}, {connection}, 0.02)
  if not w or e == "timeout" then
    return
  end
  local ret, errstr = connection:connect(login_game_server_ip, login_game_server_port)
  if errstr ~= "already connected" then
    return
  end
  connect_succ = true
  LegendLog("    connect succ")
  local r1, r2 = connection:send(up_code)
  if not r1 then
    EDlog("send error check network setting")
    if currentUi ~= nil then
      currentUi:setVisible(true)
      local action = CCFadeIn:create(fadinlength)
      currentUi:runAction(action)
    end
    ed.showToast(T(LSTR("NETWORK.SENDING_FAILED_PLEASE_CHECK_THE_NETWORK_SETTING")))
    close()
    return
  end
  LegendLog("<<< Message Sent  @ " .. ed.getYMDTime())
end
local function recv_buffer(size_left, buffer)
  if size_left <= 0 then
    return buffer
  end
  local content, err, partial = connection:receive(size_left)
  if err == "closed" then
    LegendLog("    socket closed")
    return nil
  elseif err == "timeout" then
    buffer = buffer .. partial
    return recv_buffer(size_left - #partial, buffer)
  else
    buffer = buffer .. content
    return recv_buffer(size_left - #content, buffer)
  end
end
local function recv()
  if not connection then
    return
  end
  local buffer_size_str, err = connection:receive(2)
  if not buffer_size_str then
    return
  end
  local buffer_size = string.byte(buffer_size_str, 1) * 256 + string.byte(buffer_size_str, 2)
  local buffer = recv_buffer(buffer_size, "")
  close()
  if buffer then
    LegendLog(">>> Data Received @ " .. ed.getYMDTime())
    loadEnd()
    local msg, err = down.down():Parse(buffer)
    if msg then
      dispatch(msg)
    else
      LegendLog("ERROR | Decode message failed | " .. err)
      EDDebug()
    end
  end
end
local sendCache = {}
local deleteCache = {}
local function delaySend(obj, ttype, deleteOnSent)
  LegendLog("<<< Delay send msg: " .. ttype)
  sendCache[ttype] = obj
  if deleteOnSent then
    deleteCache[ttype] = obj
  end
end
class.delaySend = delaySend
local pack_size = function(code, ttype)
  local length = #code
  LegendLog("length:" .. tostring(length))
  local second = string.char(length % 256)
  local first = string.char(math.floor(length / 256))
  return first .. second .. code
end
local function doSend(block, ttype)
  if nil == currentMsg then
    return false
  end
  local code, err = currentMsg:Serialize()
  local cipher_code
  if code then
    cipher_code = mycrypto.encrypt(code, cryptkey)
  else
    EDDebug(err)
  end
  up_code = pack_size(code, ttype)
  local r = false
  if block then
    r = connect(block)
  else
    r = connect()
    if not r then
      return r
    end
  end
  return true
end
local function reSend()
  if nil == currentMsg then
    return
  end
  doSend(bSendblock, currentMsgType)
end
local function send(obj, ttype, block)
  if connection then
    return false
  end
  LegendLog("<<< Sending msg: " .. ttype)
  currentMsg = nil
  currentMsg = up.up()
  currentMsg[ttype] = obj
  bSendblock = block or false
  currentMsgType = ttype
  for k, v in pairs(sendCache or {}) do
    currentMsg[k] = v
    if deleteCache[k] then
      sendCache[k] = nil
      deleteCache[k] = nil
    end
  end
  return doSend(block, ttype)
end
class.send = send
local function proc_net()
  connect_resume()
  recv()
end
class.proc_net = proc_net
function isRightEmail(str)
  if string.len(str or "") < 6 then
    return false
  end
  local b, e = string.find(str or "", "@")
  local bstr = ""
  local estr = ""
  if b then
    bstr = string.sub(str, 1, b - 1)
    estr = string.sub(str, e + 1, -1)
  else
    return false
  end
  local p1, p2 = string.find(bstr, "[%w_]+")
  if p1 ~= 1 or p2 ~= string.len(bstr) then
    return false
  end
  if string.find(estr, "^[%.]+") then
    return false
  end
  if string.find(estr, "%.[%.]+") then
    return false
  end
  if string.find(estr, "@") then
    return false
  end
  if string.find(estr, "[%.]+$") then
    return false
  end
  _, count = string.gsub(estr, "%.", "")
  if 1 > count or count > 3 then
    return false
  end
  return true
end
local resetTokenFile = function()
  local folder = CCFileUtils:sharedFileUtils():getWritablePath()
  local path = string.format("%s/token", folder)
  if os.rename(path, path) then
    os.remove(path)
    LegendLog("TokenRemoved:" .. path)
  else
    LegendLog("TokenNotExist:" .. path)
  end
end
class.resetTokenFile = resetTokenFile
local function checkLoadToken(save)
  local folder = CCFileUtils:sharedFileUtils():getWritablePath()
  local path = string.format("%s/token", folder)
  LegendLog("path:" .. path)
  local luaconfig
  if save then
    if ed.ui.newbie.username ~= nil and ed.ui.newbie.uin ~= nil and ed.config.tokendata ~= nil then
      luaconfig = io.open(path, "w")
      luaconfig:write(ed.ui.newbie.username .. "\n")
      luaconfig:write(ed.ui.newbie.uin .. "\n")
      luaconfig:write(ed.config.tokendata .. "\n")
      luaconfig:close()
      luaconfig = nil
      return true
    end
  else
    luaconfig = io.open(path, "r")
    if luaconfig == nil then
      ed.ui.newbie.username = nil
      ed.ui.newbie.uin = nil
      ed.config.tokendata = nil
      return false
    else
      ed.ui.newbie.username = luaconfig:read()
      ed.ui.newbie.uin = luaconfig:read()
      ed.config.tokendata = luaconfig:read()
      luaconfig:close()
      luaconfig = nil
      return true
    end
  end
end
class.checkLoadToken = checkLoadToken
local checkLoginArea = function(self)
  local username = self.edit_box1:getString()
  local password = self.edit_box2:getString()
  self.ui.newbiebg_lab_username_error:setVisible(false)
  self.ui.newbiebg_lab_password_error:setVisible(false)
  if username == nil or username == "" then
    self.ui.newbiebg_lab_username_error:setVisible(true)
    self.ui.newbiebg_lab_username_error:setString(T(LSTR("newbie.1.10.1.017")))
    return false
  elseif not isRightEmail(username) then
    self.ui.newbiebg_lab_username_error:setVisible(true)
    self.ui.newbiebg_lab_username_error:setString(T(LSTR("newbie.1.10.1.018")))
    return false
  elseif password == nil or password == "" then
    self.ui.newbiebg_lab_password_error:setVisible(true)
    self.ui.newbiebg_lab_password_error:setString(T(LSTR("newbie.1.10.1.019")))
    return false
  end
  return true
end
local checkRegeAewa = function(self)
  local username = self.edit_box3:getString()
  local password = self.edit_box4:getString()
  local password1 = self.edit_box5:getString()
  self.ui.registerpanel_lab_username_error:setVisible(false)
  self.ui.registerpanel_lab_password_error:setVisible(false)
  self.ui.registerpanel_lab_password_error1:setVisible(false)
  if username == nil or username == "" then
    self.ui.registerpanel_lab_username_error:setVisible(true)
    self.ui.registerpanel_lab_username_error:setString(T(LSTR("newbie.1.10.1.017")))
    return false
  elseif not isRightEmail(username) then
    self.ui.registerpanel_lab_username_error:setVisible(true)
    self.ui.registerpanel_lab_username_error:setString(T(LSTR("newbie.1.10.1.018")))
    return false
  elseif password == nil or password == "" then
    self.ui.registerpanel_lab_password_error:setVisible(true)
    self.ui.registerpanel_lab_password_error:setString(T(LSTR("newbie.1.10.1.019")))
    return false
  elseif password ~= password1 then
    self.ui.registerpanel_lab_password_error1:setVisible(true)
    self.ui.registerpanel_lab_password_error1:setString(T(LSTR("newbie.1.10.1.020")))
    return false
  end
  return true
end
local function doGoRegister(self)
  LegendLog("do go register")
  self.ui.registerpanel:setVisible(true)
  self.ui.newbiebg:setVisible(false)
  local action = CCFadeIn:create(fadinlength)
  self.ui.registerpanel:runAction(action)
end
class.doGoRegister = doGoRegister
local function autoLogin(self)
  LegendLog("do login")
  if ed.ui.newbie.uin == nil or ed.config.tokendata == nil then
    return
  end
  local login = up.login()
  login.email = ""
  login.passwd = ""
  login.uin = tonumber(ed.ui.newbie.uin)
  login.token = ed.config.tokendata
  self.ui.newbiebg:setVisible(false)
  currentUi = self.ui.newbiebg
  class.send(login, "login")
end
class.autoLogin = autoLogin
local function doLogin(self)
  LegendLog("do login")
  if not checkLoginArea(self) then
    return
  end
  local login = up.login()
  login.email = self.edit_box1:getString()
  login.passwd = self.edit_box2:getString()
  login.token = nil
  login.uin = 0
  self.ui.newbiebg:setVisible(false)
  currentUi = self.ui.newbiebg
  ed.ui.newbie.username = login.email
  class.send(login, "login")
end
class.doLogin = doLogin
local function doBackToLogin(self)
  LegendLog("do back to login")
  self.ui.registerpanel:setVisible(false)
  self.ui.newbiebg:setVisible(true)
  local action = CCFadeIn:create(fadinlength)
  self.ui.newbiebg:runAction(action)
end
class.doBackToLogin = doBackToLogin
local function doRegister(self)
  LegendLog("do register")
  local create_user = up.create_user()
  local ret = checkRegeAewa(self)
  if ret then
    create_user.email = self.edit_box3:getString()
    create_user.passwd = self.edit_box4:getString()
    self.ui.registerpanel:setVisible(false)
    ed.ui.newbie.username = create_user.email
    currentUi = self.ui.registerpanel
    class.send(create_user, "create_user")
  else
  end
end
class.doRegister = doRegister
local function goResetPassword(self)
  LegendLog("goResetPassword")
  self.ui.forgetpass:setVisible(true)
  self.ui.newbiebg:setVisible(false)
  local action = CCFadeIn:create(fadinlength)
  self.ui.forgetpass:runAction(action)
end
class.goResetPassword = goResetPassword
local function doForgetPassBackToLogin(self)
  LegendLog("doForgetPassBackToLogin")
  self.ui.forgetpass:setVisible(false)
  self.ui.newbiebg:setVisible(true)
  local action = CCFadeIn:create(fadinlength)
  self.ui.newbiebg:runAction(action)
end
class.doForgetPassBackToLogin = doForgetPassBackToLogin
local function doDeviceInfo(self)
  LegendLog("doDeviceInfo")
  local deviceinfo = up.deviceinfo()
  deviceinfo.uin = tonumber(ed.ui.newbie.uin)
  deviceinfo.devicename = ed.wp8deviceInfo.devicename
  deviceinfo.devicememory = ed.wp8deviceInfo.devicememory
  deviceinfo.hardwareversion = ed.wp8deviceInfo.hardwareversion
  deviceinfo.firmwareversion = ed.wp8deviceInfo.firmwareversion
  deviceinfo.manufacturer = ed.wp8deviceInfo.manufacturer
  deviceinfo.resolution = ed.wp8deviceInfo.resolution
  class.send(deviceinfo, "deviceinfo")
end
class.doDeviceInfo = doDeviceInfo
local function doResetPassword(self)
  LegendLog("doResetPassword")
  local email = self.edit_box6:getString()
  if isRightEmail(email) then
    local reset_passwd = up.reset_passwd()
    reset_passwd.email = email
    currentUi = self.ui.forgetpass
    class.send(reset_passwd, "reset_passwd")
  else
    ed.showToast(T(LSTR("newbie.1.10.1.021")))
  end
end
class.doResetPassword = doResetPassword
local function doLogout(self)
  LegendLog("doLogout")
  local logout = up.logout()
  logout.uin = tonumber(ed.ui.newbie.uin)
  logout.token = ed.config.tokendata
  class.send(logout, "logout")
end
class.doLogout = doLogout
local function doBackToServerLogin(self)
  LegendLog("doBackToServerLogin")
  ed.ui.serverlogin.enterContainer:setVisible(true)
  ed.ui.serverlogin.currentAccount:setVisible(true)
  ed.ui.serverlogin.wp8loginContainer:setVisible(true)
  local currentScene = ed.getCurrentScene()
  if currentScene.identity == "serverlogin" then
    currentScene.newbie.container:setTouchEnabled(false)
  end
  ui.registerpanel:setVisible(false)
  ui.newbiebg:setVisible(false)
  ui.forgetpass:setVisible(false)
  ui.updatepass:setVisible(false)
end
class.doBackToServerLogin = doBackToServerLogin
local function doChangePassword(self)
  LegendLog("doChangePassword")
  local oldpass = self.edit_box7:getString()
  local newpass = self.edit_box8:getString()
  local newpass1 = self.edit_box9:getString()
  self.ui.forgetpass_laberr1:setVisible(false)
  self.ui.forgetpass_laberr2:setVisible(false)
  if #newpass < 6 then
    self.ui.forgetpass_laberr1:setVisible(true)
    self.ui.forgetpass_laberr1:setString(T(LSTR("newbie.1.10.1.022")))
  elseif newpass ~= newpass1 then
    self.ui.forgetpass_laberr2:setVisible(true)
    self.ui.forgetpass_laberr2:setString(T(LSTR("newbie.1.10.1.023")))
  else
    local update_passwd = up.update_passwd()
    update_passwd.uin = ed.ui.newbie.uin
    update_passwd.token = ed.config.tokendata
    update_passwd.oldpasswd = oldpass
    update_passwd.newpasswd = newpass
    currentUi = self.ui.forgetpass
    class.send(update_passwd, "update_passwd")
  end
end
class.doChangePassword = doChangePassword
local function updateNewbie(self)
  proc_net()
end
class.updateNewbie = updateNewbie
local function create()
  local self = base.create("newbie")
  setmetatable(self, class.mt)
  local scene = self.scene
  local mainLayer = self.mainLayer
  local container
  container, ui = ed.editorui(ed.uieditor.newbie)
  self.container = container
  self.ui = ui
  local username = ui.newbiebg_img_username_bg
  local password = ui.newbiebg_img_password_bg
  local regUsername = ui.registerpanel_img_username_bg
  local regPassword = ui.registerpanel_img_password_bg
  local regPassword1 = ui.registerpanel_img_password_bg1
  local resetpass = ui.forgetpass_imgoldpass_2
  local changepassold = ui.forgetpass_imgoldpass
  local changepassnew = ui.forgetpass_imgnewpass
  local changepassnew1 = ui.forgetpass_imgnewpass1
  local fontColor = ccc3(198, 175, 126)
  local info = {
    config = {
      editSize = username:getContentSize(),
      maxLength = 60,
      fontColor,
      fontSize = 20
    }
  }
  local edit_box = editBox:new(info)
  edit_box:setPlaceHolder(T(LSTR("newbie.1.10.1.024")))
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  username:addChild(edit_box.edit)
  self.edit_box1 = edit_box
  self.edit_box1:setInputMode(kEditBoxInputModeEmailAddr)
  info = {
    config = {
      editSize = password:getContentSize(),
      maxLength = 60,
      fontColor,
      fontSize = 20
    }
  }
  edit_box = editBox:new(info)
  edit_box:setPlaceHolder(T(LSTR("newbie.1.10.1.025")))
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  password:addChild(edit_box.edit)
  self.edit_box2 = edit_box
  self.edit_box2:setInputFlag(kEditBoxInputFlagPassword)
  info = {
    config = {
      editSize = regUsername:getContentSize(),
      maxLength = 60,
      fontColor,
      fontSize = 20
    }
  }
  edit_box = editBox:new(info)
  edit_box:setPlaceHolder(T(LSTR("newbie.1.10.1.026")))
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  regUsername:addChild(edit_box.edit)
  self.edit_box3 = edit_box
  self.edit_box3:setInputMode(kEditBoxInputModeEmailAddr)
  info = {
    config = {
      editSize = regPassword:getContentSize(),
      maxLength = 60,
      fontColor,
      fontSize = 20
    }
  }
  edit_box = editBox:new(info)
  edit_box:setPlaceHolder(T(LSTR("newbie.1.10.1.027")))
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  regPassword:addChild(edit_box.edit)
  self.edit_box4 = edit_box
  self.edit_box4:setInputFlag(kEditBoxInputFlagPassword)
  info = {
    config = {
      editSize = regPassword1:getContentSize(),
      maxLength = 60,
      fontColor,
      fontSize = 20
    }
  }
  edit_box = editBox:new(info)
  edit_box:setPlaceHolder(T(LSTR("newbie.1.10.1.028")))
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  regPassword1:addChild(edit_box.edit)
  self.edit_box5 = edit_box
  self.edit_box5:setInputFlag(kEditBoxInputFlagPassword)
  info = {
    config = {
      editSize = resetpass:getContentSize(),
      maxLength = 60,
      fontColor,
      fontSize = 20
    }
  }
  edit_box = editBox:new(info)
  edit_box:setPlaceHolder(T(LSTR("newbie.1.10.1.029")))
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  resetpass:addChild(edit_box.edit)
  self.edit_box6 = edit_box
  self.edit_box6:setInputMode(kEditBoxInputModeEmailAddr)
  info = {
    config = {
      editSize = changepassold:getContentSize(),
      maxLength = 60,
      fontColor,
      fontSize = 20
    }
  }
  edit_box = editBox:new(info)
  edit_box:setPlaceHolder(T(LSTR("newbie.1.10.1.030")))
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  changepassold:addChild(edit_box.edit)
  self.edit_box7 = edit_box
  self.edit_box7:setInputFlag(kEditBoxInputFlagPassword)
  info = {
    config = {
      editSize = changepassnew:getContentSize(),
      maxLength = 60,
      fontColor,
      fontSize = 20
    }
  }
  edit_box = editBox:new(info)
  edit_box:setPlaceHolder(T(LSTR("newbie.1.10.1.027")))
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  changepassnew:addChild(edit_box.edit)
  self.edit_box8 = edit_box
  self.edit_box8:setInputFlag(kEditBoxInputFlagPassword)
  info = {
    config = {
      editSize = changepassnew1:getContentSize(),
      maxLength = 60,
      fontColor,
      fontSize = 20
    }
  }
  edit_box = editBox:new(info)
  edit_box:setPlaceHolder(T(LSTR("newbie.1.10.1.028")))
  edit_box.edit:setAnchorPoint(ccp(0, 0))
  changepassnew1:addChild(edit_box.edit)
  self.edit_box9 = edit_box
  self.edit_box9:setInputFlag(kEditBoxInputFlagPassword)
  ed.registerGameUpdateHandler("newbie", self.updateNewbie)
  checkLoadToken(false)
  self.ui.registerpanel:setCascadeOpacityEnabled(true)
  self.ui.newbiebg:setCascadeOpacityEnabled(true)
  self.ui.forgetpass:setCascadeOpacityEnabled(true)
  self.ui.updatepass:setCascadeOpacityEnabled(true)
  return self
end
class.create = create
local function RegisterHandler(self, loginScene)
  LegendLog("newbie registerHandler")
  local touchNode = ed.ui.basetouchnode.btCreate()
  self.container:setTouchEnabled(true)
  self.container:registerScriptTouchHandler(touchNode:btGetMainTouchHandler(), false, -130, true)
  local ui = self.ui
  touchNode:btRegisterButtonClick({
    button = ui.newbiebg_btn_register,
    press = ui.newbiebg_btn_register_press,
    key = "1",
    clickHandler = function()
      self:doGoRegister()
    end,
    force = true,
    mcpMode = true,
    clickInterval = 0.5
  })
  touchNode:btRegisterButtonClick({
    button = ui.newbiebg_btn_login,
    press = ui.newbiebg_btn_login_press,
    key = "2",
    clickHandler = function()
      self:doLogin()
    end,
    force = true,
    mcpMode = true,
    clickInterval = 0.5
  })
  touchNode:btRegisterButtonClick({
    button = ui.registerpanel_btn_back_reg,
    press = ui.registerpanel_btn_back_reg_press,
    key = "3",
    clickHandler = function()
      self:doBackToLogin()
    end,
    force = true,
    mcpMode = true,
    clickInterval = 0.5
  })
  touchNode:btRegisterButtonClick({
    button = ui.registerpanel_btn_register,
    press = ui.registerpanel_btn_register_press,
    key = "4",
    clickHandler = function()
      self:doRegister()
    end,
    force = true,
    mcpMode = true,
    clickInterval = 0.5
  })
  touchNode:btRegisterButtonClick({
    button = ui.forgetpass_btn_back_login,
    press = ui.forgetpass_btn_back_login_press,
    key = "5",
    clickHandler = function()
      self:doForgetPassBackToLogin()
    end,
    force = true,
    mcpMode = true,
    clickInterval = 0.5
  })
  touchNode:btRegisterButtonClick({
    button = ui.forgetpass_btn_resetpass,
    press = ui.forgetpass_btn_resetpass_press,
    key = "6",
    clickHandler = function()
      self:doResetPassword()
    end,
    force = true,
    mcpMode = true,
    clickInterval = 0.5
  })
  touchNode:btRegisterButtonClick({
    button = ui.newbiebg_labForgetPass,
    press = ui.newbiebg_labForgetPass_press,
    key = "7",
    clickHandler = function()
      self:goResetPassword()
    end,
    force = true,
    mcpMode = true,
    clickInterval = 0.5
  })
  touchNode:btRegisterButtonClick({
    button = ui.updatepass_btn_changepass,
    press = ui.updatepass_btn_changepass_press,
    key = "8",
    clickHandler = function()
      self:doChangePassword()
    end,
    force = true,
    mcpMode = true,
    clickInterval = 0.5
  })
  touchNode:btRegisterButtonClick({
    button = ui.updatepass_btn_back_login,
    press = ui.updatepass_btn_back_login_press,
    key = "9",
    clickHandler = function()
      self:doBackToServerLogin()
    end,
    force = true,
    mcpMode = true,
    clickInterval = 0.5
  })
  touchNode:btRegisterHandler({
    handler = function(event, x, y)
      self.edit_box1:touch(event, x, y)
    end,
    key = "edit_box1"
  })
  touchNode:btRegisterHandler({
    handler = function(event, x, y)
      self.edit_box2:touch(event, x, y)
    end,
    key = "edit_box2"
  })
  touchNode:btRegisterHandler({
    handler = function(event, x, y)
      self.edit_box3:touch(event, x, y)
    end,
    key = "edit_box3"
  })
  touchNode:btRegisterHandler({
    handler = function(event, x, y)
      self.edit_box4:touch(event, x, y)
    end,
    key = "edit_box4"
  })
  touchNode:btRegisterHandler({
    handler = function(event, x, y)
      self.edit_box5:touch(event, x, y)
    end,
    key = "edit_box5"
  })
  touchNode:btRegisterHandler({
    handler = function(event, x, y)
      self.edit_box6:touch(event, x, y)
    end,
    key = "edit_box6"
  })
  touchNode:btRegisterHandler({
    handler = function(event, x, y)
      self.edit_box7:touch(event, x, y)
    end,
    key = "edit_box7"
  })
  touchNode:btRegisterHandler({
    handler = function(event, x, y)
      self.edit_box8:touch(event, x, y)
    end,
    key = "edit_box8"
  })
  touchNode:btRegisterHandler({
    handler = function(event, x, y)
      self.edit_box9:touch(event, x, y)
    end,
    key = "edit_box9"
  })
end
class.RegisterHandler = RegisterHandler
