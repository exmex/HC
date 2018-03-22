local base = ed.ui.popwindow
local class = newclass(base.mt)
ed.ui.buyconfirm = class
local registerTouchHandler = function(self)
  local ui = self.ui
  self:btRegisterButtonClick({
    button = ui.ok_button,
    press = ui.ok_button_press,
    key = "ok_button",
    clickHandler = function()
      self:destroy()
	--去购买啊
	 --支付
	local productCount = 1
	local info=self.param
	LegendBuyDiamond(1, productCount, info.title, info.id, ed.getUserid(), info.cost, tonumber(game_server_id)) --购买数量,默认1---购买商品名称如钻石150(配置在Recharge.lua)---商品id---userid---商品价格---ServerID（需要参数后面可以加）
    end
  })
 self:btRegisterButtonClick({
    button = ui.cancel_button,
    press = ui.cancel_button_press,
    key = "cancel_button",
    clickHandler = function()
      self:destroy()
    end
  })
end
class.registerTouchHandler = registerTouchHandler

local function create(param)
  param = param or {}
  local self = base.create("buyconfirm")
  setmetatable(self, class.mt)
  self.param = param
  local container
  container, self.ui = ed.editorui(ed.uieditor.buydialog)
  self:setContainer(container)
--先判断是不是月卡
	if param==nil then
		return
	end
	 local rt = ed.getDataTable("Recharge")
	local tableValue=rt[param.id]
	if param.type=="MonthlyCard" then
		ed.setString(self.ui.titlebonus,T(LSTR("BUYCONFIRM.MONTHLYCARDTITLE")))
		ed.setString(self.ui.basicgem,tostring(tableValue["Basic"]))
		ed.setString(self.ui.bonusgem,tostring(tableValue["DailyReward"]))
		ed.setString(self.ui.totalgem,tostring(tableValue["DailyReward"]*tableValue["Days"]+tableValue["Basic"]))
		ed.setString(self.ui.vippoint,tableValue["VIP Exp"])
	else
		ed.setString(self.ui.basicgem,tostring(tableValue["Basic"]))
		ed.setString(self.ui.bonusgem,tostring(tableValue["Get Diamond"]-tableValue["Basic"]))
		ed.setString(self.ui.totalgem,tostring(tableValue["Get Diamond"]))
		ed.setString(self.ui.vippoint,tostring(tableValue["VIP Exp"]))
		ed.setString(self.ui.titlebonus,T(LSTR("BUYCONFIRM.BONUS")))
	end


  self.isSkipTransAnim = true
  self:registerTouchHandler()
  return self
end
class.create = create

