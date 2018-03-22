local class = newclass()
ed.ui.excavategiveup = class
local function pop(excavateId, callback, from)
  local self = {}
  setmetatable(self, class.mt)
  from = from or "giveup"
  local data = ed.ui.excavate.getData(excavateId)
  if not data then
    return
  end
  local typeid = data._type_id
  local rg = ed.ui.excavate.getProduced(excavateId, ed.getUserid())
  local rr = ed.ui.excavate.getRobRatio(excavateId)
  local row = ed.getDataTable("ExcavateTreasure")[typeid]
  local icon_res = {
    Diamond = "UI/alpha/HVGA/shop_token_icon.png",
    Gold = "UI/alpha/HVGA/goldicon_small.png",
    Item = "UI/alpha/HVGA/excavate/excavate_exp_icon.png"
  }
  local res = icon_res[row["Produce Type"]]
  self.ui = {}
  local row_ui_1 = {}
  local row_ui_2 = {}
  if math.floor(rg * (1 - rr)) > 0 then
    row_ui_1 = {
      {
        t = "Label",
        base = {
          name = "r11",
          text = T(LSTR("giveup.1.10.1.001")),
          size = 20
        },
        config = {
          color = ccc3(240, 192, 112)
        }
      },
      {
        t = "Sprite",
        base = {name = "r12", res = res},
        config = {
          fix_size = CCSizeMake(25, 25)
        }
      },
      {
        t = "Label",
        base = {
          name = "r13",
          text = math.floor(rg),
          size = 20
        },
        config = {
          color = ccc3(255, 242, 205)
        }
      }
    }
    row_ui_2 = {
      {
        t = "Label",
        base = {
          name = "r21",
          text = T(LSTR("giveup.1.10.1.002")),
          size = 20
        },
        config = {
          color = ccc3(240, 192, 112)
        }
      },
      {
        t = "Sprite",
        base = {name = "r22", res = res},
        config = {
          fix_size = CCSizeMake(25, 25)
        }
      },
      {
        t = "Label",
        base = {
          name = "r23",
          text = math.floor(rg * (1 - rr)),
          size = 20
        },
        config = {
          color = ccc3(255, 242, 205)
        }
      }
    }
  else
    local tt = T(LSTR("giveup.1.10.1.003"))
    if from == "setteam" then
      tt = T(LSTR("giveup.1.10.1.004"))
    end
    row_ui_1 = {
      {
        t = "Label",
        base = {
          name = "r11",
          text = tt,
          size = 20
        },
        config = {
          color = ccc3(240, 192, 112)
        }
      }
    }
  end
  local ui = {
    row_ui_1,
    row_ui_2,
    {
      {
        t = "Label",
        base = {
          name = "r21",
          text = T(LSTR("giveup.1.10.1.005")),
          size = 20
        },
        config = {
          color = ccc3(240, 192, 112)
        }
      }
    }
  }
  local param = {
    t = "ChaosNode",
    base = {
      name = "node",
      nodeArray = self.ui
    },
    ui = ui
  }
  local node = ed.readnode.getFeralNode(param)
  ed.popConfirmDialog({
    node = node,
    rightHandler = function()
      ed.ui.excavate.doGiveup(excavateId, callback)
    end
  })
end
class.pop = pop
