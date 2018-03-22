local ed = ed
local threshold = 0.15
local function update(basefunc, self, dt)
  basefunc(self, dt)
  local cur_hp = self.hp
  local last_hp = self.last_hp
  if cur_hp >= last_hp then
    self.last_hp = cur_hp
    return
  end
  local hp_max = self.attribs.HP
  if last_hp - cur_hp >= hp_max * self.awake_threshold then
    local list = self.buff_list
    local debuff_list = {}
    local my_camp = self.camp
    for i = 1, #list do
      local buff = list[i]
      if buff and (not buff.caster or buff.caster.camp ~= my_camp) then
        debuff_list[#debuff_list + 1] = buff
      end
    end
    for i = 1, #debuff_list do
      self:removeBuff(debuff_list[i])
    end
    self:skillult_waterEffect()
    local bid = 145
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local owner = self
    local buff = ed.BuffCreate(binfo, owner, owner)
    owner:addBuff(buff, owner)
    self.last_hp = cur_hp
  end
end
local function skillult_waterEffect(self)
  if ed.run_with_scene then
    local info = self.skills.TH_awake.info
    local effect_name = info["Point Effect"]
    if effect_name then
      local effect_z = info["Point Zorder"] or 0
      local pos = self.position
      ed.scene:playEffectOnScene(effect_name, {
        pos[1],
        pos[2] - 1
      }, {
        self.direction,
        1
      }, nil, effect_z)
    end
  end
end
local function init_hero(hero)
  if ed.protoAwake(hero.proto) then
    hero.last_hp = hero.hp
    hero.update = override(hero.update, update)
    hero.skillult_waterEffect = skillult_waterEffect
    hero.awake_threshold = threshold
  end
  return hero
end
return init_hero
