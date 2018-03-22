local ed = ed
local class = {
	mt = {}
}
class.mt.__index = class
ed.ui.gm = class

require("gmtools/addequip")

local normal_button_color = ccc3(255, 213, 16)
local special_button_color = ccc3(128, 230, 15)
local press_button_color = ccc3(255, 255, 255)
local max_column = 1
local element_pos_col_row = {}

local function getElementPos(col, row, offset)
	for k, v in pairs(element_pos_col_row) do
		local c = v.c
		local r = v.r
		if col == c and r == row then
			print("column:", c, " and row:", r, " has been set repeated!")
		end
	end
	table.insert(element_pos_col_row, {c = col, r = row})
	local mx = 6 * math.ceil(col / 6) + 2
	max_column = math.max(mx, max_column)
	offset = offset or ccp(0, 0)
	local ox, oy = 600, 360
	local pos = ccp(ox + 200 * (col - 1), oy - 60 * (row - 1))
	return ccpAdd(pos, offset)
end

local getInput = function(self, number)
	return tonumber(self.number:getText()) or number
end
class.getInput = getInput

local toast_pos = ccp(400, 430)
local button_config = {
	{
		label = "Console",
		pos = getElementPos(1, 6),
		size = CCSizeMake(200, 60),
		inWidth = 135,
		handler = function()
			print([[

			****************************************************
			1. Get equipments:
			>>> addEquip([equip ID], [count])

			2. Sync hero info to server:
			>>> syncHero([ID or name])

			3. Exit console and resume the game:
			>>> cont
			****************************************************

			]])
			function addEquip(id, count)
				ed.player:gmAddEquip(id, count)
			end
			EDDebug()
		end
	},
	{
		label = LSTR("GM.OPEN_TO_ALL_LEVELS"),
		pos = getElementPos(0, 1),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function(self)
			local msg = ed.upmsg.gm_cmd()
			msg._unlock_all_stages = 65536
			ed.send(msg, "gm_cmd")
			ed.showToast(LSTR("GM.OPEN_TO_ALL_LEVELS"), toast_pos)
		end
	},
	{
		label = LSTR("GM.OPEN_GAME_POINTS"),
		pos = getElementPos(0, 2),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function(self)
			local num = self:getInput(65536)
			local msg = ed.upmsg.gm_cmd()
			msg._unlock_all_stages = num
			ed.send(msg, "gm_cmd")
			if num == 65536 then
				ed.showToast(LSTR("GM.OPEN_TO_ALL_LEVELS"), toast_pos)
			else
				ed.showToast(LSTR("GM.OPEN_TO") .. num .. LSTR("GM.GAME_POINTS"), toast_pos)
			end
		end
	},
	{
		label = LSTR("GM.ENTER_GAME_POINTS"),
		pos = getElementPos(0, 3),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function(self)
			local number = tonumber(self.number:getText())
			if not number then
				ed.showToast(LSTR("GM.PLEASE_ENTER_THE_GAME_POINTS_ID"), toast_pos)
				return
			end
			local id = number
			ed.pushScene(ed.ui.battleprepare.create({stage_id = id}))
		end
	},
	{
		label = LSTR("GM.GET_MONEY"),
		pos = getElementPos(0, 4),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function(self)
			local number = self:getInput(9999999)
			local msg = ed.upmsg.gm_cmd()
			msg._set_money = ed.upmsg.set_money()
			msg._set_money._type = "gold"
			msg._set_money._amount = number
			ed.send(msg, "gm_cmd")
			ed.showToast(T(LSTR("EQUIPINFO.MONEY_GAINED")) .. number, toast_pos)
		end
	},
	{
		label = LSTR("GM.GET_DIAMONDS"),
		pos = getElementPos(0, 5),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function(self)
			local number = self:getInput(9999999)
			local msg = ed.upmsg.gm_cmd()
			msg._set_money = ed.upmsg.set_money()
			msg._set_money._type = "diamond"
			msg._set_money._amount = number
			ed.send(msg, "gm_cmd")
			ed.showToast(T(LSTR("GM.GET_DIAMONDS") .. number, msg._set_recharge_sum), toast_pos)
		end
	},
	{
		label = LSTR("GM.GET_ALL_HEROES"),
		pos = getElementPos(-1, 5),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function()
			local msg = ed.upmsg.gm_cmd()
			msg._get_all_heroes = 1
			ed.send(msg, "gm_cmd")
			ed.showToast(LSTR("GM.GET_ALL_HEROES"), toast_pos)
		end
	},
	{
		label = LSTR("GM.RESTORE_FULL_STRENGTH_"),
		pos = getElementPos(-1, 4),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function()
			local msg = ed.upmsg.gm_cmd()
			msg._set_vitality = 120
			ed.send(msg, "gm_cmd")
			ed.showToast(LSTR("GM.RESTORE_FULL_STRENGTH_"), toast_pos)
		end
	},
	{
		label = LSTR("GM.DELETE_YOUR_ACCOUNT_AND_RESET"),
		pos = getElementPos(-1, 2),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function()
			local msg = ed.upmsg.gm_cmd()
			msg._reset_device = 1
			ed.send(msg, "gm_cmd")
			ed.showToast(LSTR("GM.DELETE_YOUR_ACCOUNT_AND_RESET"), toast_pos)
		end
	},
	{
		label = LSTR("GM.GET_ALL_THE_EQUIPMENT"),
		pos = getElementPos(2, 4),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function()
			local msg = ed.upmsg.gm_cmd()
			msg._set_items = {}
			local dt = ed.getDataTable("equip")
			for id, item in pairs(dt) do
				if type(id) == "number" then
					local amount = 99
					local bits = ed.makebits(11, amount, 10, id)
					table.insert(msg._set_items, bits)
				end
			end
			ed.send(msg, "gm_cmd")
			ed.showToast(LSTR("GM.GET_ALL_THE_EQUIPMENT"), toast_pos)
		end
	},
	{
		label = T(LSTR("GM.ADD_ITEMS")),
		pos = getElementPos(2, 5),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function()
			CCDirector:sharedDirector():pushScene(ed.ui.addequip.create().scene)
		end
	},
	{
		label = T(LSTR("GM.HERO_SKILL_REACHES_FULL_LEVEL")),
		pos = getElementPos(3, 3),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function()
			for id, hero in pairs(ed.player.heroes) do
				local level = hero._level
				hero._skill_levels = {
					level,
					level,
					level,
					level
				}
			end
			class.syncHero()
			ed.showToast(T(LSTR("GM.HERO_SKILL_REACHES_FULL_LEVEL")), toast_pos)
		end
	},
	{
		label = LSTR("GM.OPEN_THE_MYSTERY_SHOP"),
		pos = getElementPos(-1, 6),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function()
			local msg = ed.upmsg.gm_cmd()
			msg._open_mystery_shop = 1
			ed.send(msg, "gm_cmd")
			ed.showToast(LSTR("GM.OPEN_THE_MYSTERY_SHOP"), toast_pos)
		end
	},
	{
		label = T(LSTR("GM.HEROES_UPGRADED_TO")),
		pos = getElementPos(2, 1),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function(self)
			local num = tonumber(self.number:getText()) or 1
			num = math.min(math.max(num, 1), 99)
			for id, hero in pairs(ed.player.heroes) do
				hero._level = num
				hero._rank = math.ceil(num / 10)
				for i, item in ipairs(hero._items) do
					item._item_id = 0
					item._exp = 0
				end
			end
			class.syncHero()
			ed.showToast(LSTR("GM.ALL_HEROES_UPGRADED_TO") .. num .. LSTR("GM.LEVEL"), toast_pos)
		end
	},
	{
		label = T(LSTR("GM.ADVANCE_TO")),
		pos = getElementPos(2, 2),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function(self)
			local num = tonumber(self.number:getText()) or 1
			num = math.min(math.max(num, 1), 5)
			for id, hero in pairs(ed.player.heroes) do
				hero._stars = num
			end
			class.syncHero()
			ed.showToast(LSTR("GM.ALL_HEROES_ADVANCE_TO") .. num .. LSTR("GM.STAR"), toast_pos)
		end
	},
	{
		label = LSTR("GM.SAVE_TO"),
		pos = getElementPos(2, 6, ccp(-50, 0)),
		size = CCSizeMake(95, 60),
		inWidth = 160,
		color = special_button_color,
		handler = function(self)
			local id = tonumber(self.number:getText())
			local msg = ed.upmsg.gm_cmd()
			msg._archive_id = id
			ed.send(msg, "gm_cmd")
			ed.showToast(LSTR("GM.SAVE_SUCCESSFULLY") .. id, toast_pos)
		end
	},
	{
		label = LSTR("GM.READ_FILE_TO"),
		pos = getElementPos(2, 6, ccp(45, 0)),
		size = CCSizeMake(95, 60),
		inWidth = 160,
		color = special_button_color,
		handler = function(self)
			local id = tonumber(self.number:getText())
			local msg = ed.upmsg.gm_cmd()
			msg._restore_id = id
			ed.send(msg, "gm_cmd")
			ed.showToast(LSTR("GM.READING_FILE_SUCCESSFULLY_") .. id, toast_pos)
		end
	},
	{
		label = LSTR("GM.UPGRADE_CLAN_TO"),
		pos = getElementPos(2, 3),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function(self)
			local msg = ed.upmsg.gm_cmd()
			local num = tonumber(self.number:getText()) or 1
			num = math.min(num, 99)
			num = math.max(num, 1)
			msg._set_player_level = num
			ed.send(msg, "gm_cmd")
			ed.showToast(LSTR("GM.UPGRADE_CLAN_TO") .. num .. LSTR("GM.LEVEL"), toast_pos)
		end
	},
	{
		label = "<-",
		pos = getElementPos(1, 1, ccp(75, 0)),
		size = CCSizeMake(50, 50),
		inWidth = 30,
		color = special_button_color,
		handler = function(self)
			local num = tonumber(self.number:getText()) or 0
			if num == 0 then
				self.number:setText("")
			else
				self.number:setText(math.floor(num / 10))
			end
		end
	},
	{
		label = T(LSTR("RECHARGE.CHARGE")),
		pos = getElementPos(0, 6),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function(self)
			local msg = ed.upmsg.gm_cmd()
			local rn = tonumber(self.number:getText()) or 9999999
			msg._set_money = ed.upmsg.set_money()
			msg._set_money._type = "diamond"
			msg._set_money._amount = rn + ed.player._rmb
			msg._set_recharge_sum = ed.player._recharge_sum + rn
			ed.send(msg, "gm_cmd")
			ed.showToast(T(LSTR("GM.RECHARGE_D_DIAMOND"), rn), toast_pos)
		end
	},
	{
		label = T(LSTR("GM.RECHARGE_CLEARED")),
		pos = getElementPos(3, 4),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function(self)
			local msg = ed.upmsg.gm_cmd()
			msg._set_recharge_sum = 0
			ed.send(msg, "gm_cmd")
			ed.showToast(T(LSTR("GM.RECHARGE_CLEARED")), toast_pos)
		end
	},
	{
		label = LSTR("GM.SET_FREE_RAID_TIMES"),
		pos = getElementPos(3, 2),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function(self)
			local msg = ed.upmsg.gm_cmd()
			msg._reset_sweep = tonumber(self.number:getText()) or 0
			ed.send(msg, "gm_cmd")
			ed.showToast(T(LSTR("GM.SET_FREE_RAIDS_TO__D_TIMES"), msg._reset_sweep), toast_pos)
		end
	},
	{
		label = LSTR("GM.CLEAR_DIAMOND"),
		pos = getElementPos(3, 5),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function(self)
			local msg = ed.upmsg.gm_cmd()
			local rn = 0
			msg._set_money = ed.upmsg.set_money()
			msg._set_money._type = "diamond"
			msg._set_money._amount = rn
			ed.send(msg, "gm_cmd")
			ed.showToast(T(LSTR("GM.CLEAR_DIAMOND")), toast_pos)
		end
	},
	{
		label = LSTR("GM.CLEAR_MONEY"),
		pos = getElementPos(3, 6),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function()
			local msg = ed.upmsg.gm_cmd()
			msg._set_money = ed.upmsg.set_money()
			msg._set_money._type = "gold"
			msg._set_money._amount = 0
			ed.send(msg, "gm_cmd")
			ed.showToast(LSTR("GM.CLEAR_MONEY"), toast_pos)
		end
	},
	{
		label = LSTR("GM.ONCE_KEY_DUST_CLEARANCE"),
		pos = getElementPos(-1, 3),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function()
			for k, v in pairs(ed.tutorialres.t_key) do
				local id = v.id
				ed.player:setTutorialRecord(id, 10)
			end
			local msg = ed.upmsg.tutorial()
			msg._record = ed.player._tutorial
			ed.delaySend(msg, "tutorial")
			ed.send(msg, "tutorial")
			ed.tutorial.clear()
			ed.showToast(LSTR("GM.ALL_BEGINNERS_GUIDE_HAS_BEEN_REMOVED"), toast_pos)
		end
	},
	{
		label = LSTR("GM.I_AM_A_TYRANT"),
		pos = getElementPos(-1, 1),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function(self)
			local msg = ed.upmsg.gm_cmd()
			msg._unlock_all_stages = 1
			msg._get_all_heroes = 1
			msg._set_recharge_sum = 999999
			msg._set_player_level = 80
			msg._set_money = ed.upmsg.set_money()
			msg._set_money._type = "gold"
			msg._set_money._amount = 99999999
			msg._set_items = {}
			for id, item in pairs(ed.getDataTable("equip")) do
				if type(id) == "number" then
					local amount = 99
					local bits = ed.makebits(11, amount, 10, id)
					table.insert(msg._set_items, bits)
				end
			end
			ed.send(msg, "gm_cmd")
			ed.showAlertDialog({
				text = LSTR("GM.TYRANT_LET_US_BE_FRIENDS"),
				buttonText = LSTR("GM.WELL"),
				handler = function()
					local msg = ed.upmsg.gm_cmd()
					msg._set_money = ed.upmsg.set_money()
					msg._set_money._type = "diamond"
					msg._set_money._amount = 9999999
					msg._set_hero_info = {}
					for id, hero in pairs(ed.player.heroes) do
						local h = ed.upmsg.hero()
						h._tid = hero._tid
						h._level = 80
						h._stars = 5
						h._rank = 10
						h._exp = 0
						h._gs = 5000
						h._state = "idle"
						h._items = {}
						for i = 1, 6 do
							local item = ed.upmsg.hero_equip()
							item._index = i
							item._item_id = ed.lookupDataTable("hero_equip", "Equip" .. i .. " ID", h._tid, h._rank)
							item._exp = 2000
							h._items[i] = item
						end
						h._skill_levels = {
							80,
							80,
							80,
							80
						}
						table.insert(msg._set_hero_info, h)
					end
					ed.send(msg, "gm_cmd")
				end
			})
		end
	},
	{
		label = LSTR("GM.SET_THE_NUMBER_OF_DAYS_FOR_CONTINUOUS_LANDING"),
		pos = getElementPos(3, 1),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function(self)
			local msg = ed.upmsg.gm_cmd()
			msg._set_dailylogin_days = tonumber(self.number:getText()) or 0
			ed.send(msg, "gm_cmd")
		end
	},
	{
		label = LSTR("GM.RELOAD_GM_SCENE"),
		pos = getElementPos(1, 5),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function()
			LegendClearLoaded("gmtools/gm")
			ed.popScene()
			ed.gggggm()
		end
	},
	{
		label = T(LSTR("GM.HERO_SKILL_RESET")),
		pos = getElementPos(4, 1),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function()
			for id, hero in pairs(ed.player.heroes) do
				hero._skill_levels = {
					1,
					1,
					21,
					41
				}
			end
			class.syncHero()
			ed.showToast(T(LSTR("GM.HERO_SKILL_RESET")), toast_pos)
		end
	},
	{
		label = LSTR("GM.GET_EXPEDITION_COINS"),
		pos = getElementPos(4, 2),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function(self)
			local number = self:getInput(9999999)
			local msg = ed.upmsg.gm_cmd()
			msg._set_money = ed.upmsg.set_money()
			msg._set_money._type = "crusadepoint"
			msg._set_money._amount = number
			ed.send(msg, "gm_cmd")
			ed.showToast(LSTR("GM.GET_INTERFAX_COINS_") .. number, toast_pos)
		end
	},
	{
		label = LSTR("GM.GET_ARENA_COINS"),
		pos = getElementPos(4, 3),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function(self)
			local number = self:getInput(9999999)
			local msg = ed.upmsg.gm_cmd()
			msg._set_money = ed.upmsg.set_money()
			msg._set_money._type = "arenapoint"
			msg._set_money._amount = number
			ed.send(msg, "gm_cmd")
			ed.showToast(LSTR("GM.GET_GLADIATOR_COINS") .. number, toast_pos)
		end
	},
	{
		label = LSTR("GM.CLEAR_EXPEDITION_COINS"),
		pos = getElementPos(4, 4),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function(self)
			local number = 0
			local msg = ed.upmsg.gm_cmd()
			msg._set_money = ed.upmsg.set_money()
			msg._set_money._type = "crusadepoint"
			msg._set_money._amount = number
			ed.send(msg, "gm_cmd")
			ed.showToast(LSTR("GM.CLEAR_INTERFAX_COINS_"), toast_pos)
		end
	},
	{
		label = LSTR("GM.CLEAR_ARENA_COINS"),
		pos = getElementPos(4, 5),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function(self)
			local number = 0
			local msg = ed.upmsg.gm_cmd()
			msg._set_money = ed.upmsg.set_money()
			msg._set_money._type = "arenapoint"
			msg._set_money._amount = number
			ed.send(msg, "gm_cmd")
			ed.showToast(LSTR("GM.CLEAR_GLADIATOR_COINS"), toast_pos)
		end
	},
	{
		label = "2048",
		pos = getElementPos(4, 6),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function(self)
			ed.pushScene(ed.fruit.banana.create())
		end
	},
	{
		label = LSTR("GM.OPEN_STAR_STORE_"),
		pos = getElementPos(5, 1),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function()
			local msg = ed.upmsg.gm_cmd()
			msg._open_mystery_shop = 6
			ed.send(msg, "gm_cmd")
			ed.showToast(LSTR("GM.OPEN_STAR_STORE_"), toast_pos)
		end
	},
	{
		label = LSTR("GM.TO_ENTER_THE_MAIN_INTERFACE_"),
		pos = getElementPos(5, 2),
		size = CCSizeMake(200, 60),
		inWidth = 160,
		handler = function()
			ed.popScene()
			ed.replaceScene(ed.ui.main.create())
		end
	}
}

local t_number = {
	1,
	2,
	3,
	4,
	5,
	6,
	7,
	8,
	9,
	"C",
	0,
	"M"
}

local getNumberPos = function(i)
	local ox, oy = 550, 312
	local dx, dy = 45, 42
	return ccp(ox + dx * ((i - 1) % 3), oy - dy * math.floor((i - 1) / 3))
end

for i = 1, #t_number do
	do
		local b = {
			label = t_number[i],
			pos = getNumberPos(i),
			size = CCSizeMake(50, 50),
			inWidth = 30,
			color = special_button_color,
			handler = function(self)
				local n = t_number[i]
				local nt = type(n)
				if nt == "number" then
					local num = tonumber(self.number:getText()) or 0
					if num < 1000000 then
						self.number:setText(num * 10 + t_number[i])
					end
				elseif nt == "string" then
					if n == "M" then
						self.number:setText(9999999)
					elseif n == "C" then
						self.number:setText("")
					end
				end
			end
		}
		table.insert(button_config, b)
	end
end

local function createNumber(self)
	local button = ed.createScale9Sprite("UI/alpha/HVGA/herodetail-detail-n.png", CCRectMake(10, 10, 148, 29))
	local pos = getElementPos(1, 1, ccp(-25, 0))
	local size = CCSizeMake(150, 50)
	local inSize = CCSizeMake(120, 60)
	local color = special_button_color
	local edit = CCEditBox:create(size, button, nil, nil, true)
	edit:setPlaceHolder(LSTR("GM.PLEASE_ENTER_"))
	edit:setFontColor(normal_button_color)
	edit:setFont(ed.font, 16)
	edit:setPosition(pos)
	self.draglist.listLayer:addChild(edit)
	self.number = edit
end
class.createNumber = createNumber

function syncHero(IDorName)
	local msg = ed.upmsg.gm_cmd()
	msg._set_hero_info = {}
	for id, hero in pairs(ed.player.heroes) do
		local name = ed.lookupDataTable("Unit", "Unit Name", hero._tid)
		if name == IDorName or hero._tid == IDorName then
			local h = ed.upmsg.hero()
			h._tid = hero._tid
			h._level = hero._level
			h._stars = hero._stars
			h._rank = hero._rank
			h._exp = hero._exp
			h._state = "idle"
			h._gs = 0
			h._items = hero._items
			h._skill_levels = hero._skill_levels
			table.insert(msg._set_hero_info, h)
		end
	end
	ed.send(msg, "gm_cmd")
end
class.syncHero = syncHero

local function setAllHeroLevel(level)
	local msg = ed.upmsg.gm_cmd()
	msg._set_hero_info = {}
	for id, hero in pairs(ed.player.heroes) do
		hero.data._level = level
		local h = ed.upmsg.hero()
		h._tid = hero._tid
		h._level = hero._level
		h._rank = math.ceil(level / 10)
		h._exp = hero._exp
		h._gs = 0
		h._state = "idle"
		h._stars = ed.lookupDataTable("Unit", "Initial Stars", h._tid)
		h._items = {}
		for i = 1, 6 do
			local item = ed.upmsg.hero_equip()
			item._index = i
			item._item_id = 0
			item._exp = 0
			h._items[i] = item
		end
		h._skill_levels = {
			level,
			level,
			level,
			level
		}
		table.insert(msg._set_hero_info, h)
	end
	ed.send(msg, "gm_cmd")
end
class.setAllHeroLevel = setAllHeroLevel

local function setAllHeroToAlmostRanking()
	local msg = ed.upmsg.gm_cmd()
	msg._set_hero_info = {}
	for id, hero in pairs(ed.player.heroes) do
		local h = ed.upmsg.hero()
		h._tid = hero._tid
		h._rank = hero._rank
		if hero._rank == 10 then
			h._level = 99
		else
			h._level = hero._rank * 10
		end
		local level = h._level
		h._exp = 0
		h._gs = 0
		h._state = "idle"
		h._items = hero._items
		h._skill_levels = {
			level,
			level,
			level,
			level
		}
		table.insert(msg._set_hero_info, h)
	end
	ed.send(msg, "gm_cmd")
end
class.setAllHeroToAlmostRanking = setAllHeroToAlmostRanking

local function doButtonTouch(self)
	local function handler(event, x, y)
		if event == "began" then
			for k, v in pairs(self.button) do
				if ed.containsPoint(v, x, y) then
					self.pressButtonID = k
					self.buttonPress[k]:setVisible(true)
					break
				end
			end
		elseif event == "ended" then
			local k = self.pressButtonID
			self.pressButtonID = nil
			local dm = self.draglist:getDragMode()
			if k then
				self.buttonPress[k]:setVisible(false)
				if ed.containsPoint(self.button[k], x, y) and not dm and self.buttonHandler[k] then
					self.buttonHandler[k](self)
				end
			end
		end
	end
	return handler
end
class.doButtonTouch = doButtonTouch

local function doBackTouch(self)
	local function handler(event, x, y)
		if event == "began" then
			if ed.containsPoint(self.ui.back, x, y) then
				self.isPressBack = true
				self.ui.back_press:setVisible(true)
			end
		elseif event == "ended" then
			local k = self.isPressBack
			self.isPressBack = nil
			if k then
				self.ui.back_press:setVisible(false)
				if ed.containsPoint(self.ui.back, x, y) then
					ed.popScene()
				end
			end
		end
	end
	return handler
end
class.doBackTouch = doBackTouch

local doMainLayerTouch = function(self)
	local function handler(event, x, y)
		xpcall(function()
			self:doBackTouch()(event, x, y)
			self:doButtonTouch()(event, x, y)
		end, EDDebug)
		return true
	end
	return handler
end
class.doMainLayerTouch = doMainLayerTouch

local function createButton(self, info)
	local label = info.label
	local pos = info.pos
	local handler = info.handler
	local size = info.size
	local inWidth = info.inWidth
	local color = info.color or normal_button_color
	if not self.button then
		self.button = {}
		self.buttonPress = {}
		self.buttonLabel = {}
		self.buttonHandler = {}
	end
	local button = ed.createScale9Sprite("UI/alpha/HVGA/herodetail-detail-n.png", CCRectMake(10, 10, 148, 29))
	local buttonPress = ed.createScale9Sprite("UI/alpha/HVGA/herodetail-detail-pressed-n.png", CCRectMake(10, 10, 148, 29))
	buttonPress:setVisible(false)
	local buttonLabel = ed.createttf(label or "", 20)
	ed.setLabelColor(buttonLabel, color)
	local labelSize = buttonLabel:getContentSize()
	button:setContentSize(size)
	buttonPress:setContentSize(size)
	if inWidth < labelSize.width then
		buttonLabel:setScale(inWidth / labelSize.width)
	end
	buttonPress:setPosition(ccp(size.width / 2, size.height / 2))
	buttonLabel:setPosition(ccp(size.width / 2, size.height / 2))
	button:addChild(buttonPress)
	button:addChild(buttonLabel)
	button:setPosition(pos)
	self.draglist.listLayer:addChild(button)
	self.button[label] = button
	self.buttonPress[label] = buttonPress
	self.buttonLabel[label] = buttonLabel
	self.buttonHandler[label] = handler
end
class.createButton = createButton

local function createListLayer(self)
	local info = {
		cliprect = CCRectMake(50, 20, 700, 440),
		noshade = true,
		container = self.mainLayer,
		zorder = 10
	}
	self.draglist = ed.draglist.create(info)
	self.draglist:initListWidth(200 * max_column)
	self.draglist:getList():setPosition(ccp(-110, 0))
end
class.createListLayer = createListLayer

local function create()
	local self = {}
	setmetatable(self, class.mt)
	local scene = CCScene:create()
	self.scene = scene
	local mainLayer = CCLayer:create()
	self.mainLayer = mainLayer
	scene:addChild(mainLayer)
	mainLayer:setTouchEnabled(true)
	mainLayer:registerScriptTouchHandler(self:doMainLayerTouch(), false, 0, false)
	self:createListLayer()
	self.ui = {}
	local ui_info = {
		{
			t = "Sprite",
			base = {
				name = "bg",
				res = "UI/alpha/HVGA/bg.jpg"
			},
			layout = {
				position = ccp(400, 240)
			},
			config = {}
		},
		{
			t = "Label",
			base = {
				name = "title",
				text = "With great power, comes great responsibility.",
				size = 26
			},
			layout = {
				position = ccp(410, 440)
			},
			config = {
				color = ccc3(255, 0, 0),
				stroke = {
					color = ccc3(255, 255, 255),
					size = 3
				}
			}
		},
		{
			t = "Sprite",
			base = {
				name = "back",
				res = "UI/alpha/HVGA/backbtn.png"
			},
			layout = {
				anchor = ccp(0.5, 0.5),
				position = ccp(70, 435)
			},
			config = {}
		},
		{
			t = "Sprite",
			base = {
				name = "back_press",
				res = "UI/alpha/HVGA/backbtn-disabled.png"
			},
			layout = {
				position = ccp(70, 435)
			},
			config = {visible = false}
		}
	}
	local readNode = ed.readnode.create(self.mainLayer, self.ui)
	readNode:addNode(ui_info)
	for i = 1, #button_config do
		self:createButton(button_config[i])
	end
	self:createNumber()
	return self
end
class.create = create

local ccScene = function(self)
	return self.scene
end
class.ccScene = ccScene
