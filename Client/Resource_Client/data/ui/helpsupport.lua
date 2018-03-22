local helpsupport = {
}

ed.ui.helpsupport = helpsupport
local rulePanel
local ruleIssuePanel
local initsuccess = false
local UIRes = {
{
	layerName = "ruleLayer",
	    layerColor = ccc4(0, 0, 0, 190),
	    layerOrder = 100,
	    touchInfo = {
	      iPriority = -200,
	      bSwallowsTouches = true,
	      alert = true
	    },
	    uiRes = 
	    {
	      {
	        t = "Scale9Sprite",
	        base = {
	          name = "ruleInfo",
	          res = "UI/alpha/HVGA/main_vit_tips.png",
	          capInsets = CCRectMake(15, 20, 45, 15)
	        },
	        layout = {
	          anchor = ccp(0.5, 0.5),
	          position = ccp(400, 240)
	        },
	        config = {
	          scaleSize = CCSizeMake(600, 410)
	        }
	      },
	      {
	        t = "Label",
	        base = {
	          name = "ui",
	          text = T(LSTR("HERO.FAQ.INFO.TITLE")),
	          size = 22,
	          parent = "ruleInfo"
	        },
	        layout = {
	          anchor = ccp(0.5, 0.5),
	          position = ccp(300, 370)
	        },
	        config = {
	          color = ccc3(251, 206, 16)
	        }
	      },
	      {
	        t = "Sprite",
	        base = {
	          name = "heroInfo",
	          parent = "ruleInfo",
	          res = "UI/alpha/HVGA/pvp/pvp_tip_title_bg.png"
	        },
	        layout = {
	          anchor = ccp(0.5, 0.5),
	          position = ccp(300, 370)
	        },
	        config = {
	          scalexy = {x = 1.3, y = 1.1}
	        }
	      },
	      {
	        t = "SpriteButton",
	        base = {
	          name = "closeRuleInfo",
	          res = {
	            normal = "UI/alpha/HVGA/common/common_tips_button_close_1.png"
	          },
	          parent = "ruleInfo",
	          handleName = "closeRuleInfo"
	        },
	        layout = {
	          anchor = ccp(0.5, 0.5),
	          position = ccp(580, 390)
	        }
	      },
	      {
	        t = "ListView",
	        base = {
	          name = "listview",
	          cliprect = CCRectMake(120, 115, 560, 250),
	          priority = -200
	        },
	        itemConfig = {
	          {
	            t = "RichText",
	            base = {name = "name", text = ""},
	            layout = {
	              anchor = ccp(0, 1),
	              position = ccp(5, 0)
	            },
	            listData = true
	          }
	        }
	      },
	      {
	        t = "Scale9Button",
	        base = {
	          name = "formusbtn",
	          buttonName = {
	            text = T(LSTR("HERO.FAQ.INFO.FORUMS")),
	            fontInfo = "ui_normal_button"
	          },

	          res = {
	            normal = "UI/alpha/HVGA/sell_number_button.png",
	            press = "UI/alpha/HVGA/sell_number_button_down.png"
	          },
	          capInsets = CCRectMake(15, 22, 15, 25),
	          parent = "ruleInfo",
	          handleName = "formusDown"
	        },
	        layout = {
	          anchor = ccp(0.5, 0.5),
	          position = ccp(170, 38)
	        },
	        config = {
	          scaleSize = CCSizeMake(180, 49)
	        }
	      },
	      {
		        t = "Scale9Button",
		        base = {
		          name = "ReportIssue",
		          buttonName = {
		            text = T(LSTR("HERO.FAQ.INFO.REPORTANISSUE")),
		            fontInfo = "ui_normal_button"
		          },
		          res = {
		            normal = "UI/alpha/HVGA/sell_number_button.png",
		            press = "UI/alpha/HVGA/sell_number_button_down.png"
		          },
		          capInsets = CCRectMake(15, 22, 15, 25),
		          parent = "ruleInfo",
		          handleName = "ReportIssue"
		        },
		        layout = {
		          anchor = ccp(0.5, 0.5),
		          position = ccp(430, 38)
		        },
		        config = {
		          scaleSize = CCSizeMake(180, 49)
		        }
		      },
	    }
	  }
}

local UIIssueRes = {
{
	layerName = "ruleIssueLayer",
	    layerColor = ccc4(0, 0, 0, 190),
	    layerOrder = 100,
	    touchInfo = {
	      iPriority = -200,
	      bSwallowsTouches = true,
	      alert = true
	    },
	    uiRes = 
	    {
		      {
		        t = "Scale9Sprite",
		        base = {
		          name = "issueinfo",
		          res = "UI/alpha/HVGA/main_vit_tips.png",
		          capInsets = CCRectMake(15, 20, 45, 15),
		          --parent = "ruleInfo",
		        },
		        layout = {
		          anchor = ccp(0.5, 0.5),
		          position = ccp(400, 240)
		        },
		        config = {
		          scaleSize = CCSizeMake(300, 300),
		        }
		      },
		      {
		        t = "Scale9Button",
		        base = {
		          name = "issueinfo1",
		          buttonName = {
		            text = T(LSTR("CONFIGURE.ISSUE.PURCHASING")),
		            fontInfo = "ui_normal_button"
		          },
		          res = {
		            normal = "UI/alpha/HVGA/sell_number_button.png",
		            press = "UI/alpha/HVGA/sell_number_button_down.png"
		          },
		          capInsets = CCRectMake(15, 22, 15, 25),
		          parent = "issueinfo",
		          handleName = "ReportIssuefunc1"
		        },
		        layout = {
		          anchor = ccp(0.5, 0.5),
		          position = ccp(150, 250)
		        },
		        config = {
		          scaleSize = CCSizeMake(170, 49)
		        }
		      },
		      {
		        t = "Scale9Button",
		        base = {
		          name = "issueinfo2",
		          buttonName = {
		            text = T(LSTR("CONFIGURE.ISSUE.CONNECTION")),
		            fontInfo = "ui_normal_button"
		          },
		          res = {
		            normal = "UI/alpha/HVGA/sell_number_button.png",
		            press = "UI/alpha/HVGA/sell_number_button_down.png"
		          },
		          capInsets = CCRectMake(15, 22, 15, 25),
		          parent = "issueinfo",
		          handleName = "ReportIssuefunc2"
		        },
		        layout = {
		          anchor = ccp(0.5, 0.5),
		          position = ccp(150, 200)
		        },
		        config = {
		          scaleSize = CCSizeMake(170, 49)
		        }
		      },
		      {
		        t = "Scale9Button",
		        base = {
		          name = "issueinfo3",
		          buttonName = {
		            text = T(LSTR("CONFIGURE.ISSUE.OTHER")),
		            fontInfo = "ui_normal_button"
		          },
		          res = {
		            normal = "UI/alpha/HVGA/sell_number_button.png",
		            press = "UI/alpha/HVGA/sell_number_button_down.png"
		          },
		          capInsets = CCRectMake(15, 22, 15, 25),
		          parent = "issueinfo",
		          handleName = "ReportIssuefunc3"
		        },
		        layout = {
		          anchor = ccp(0.5, 0.5),
		          position = ccp(150, 150)
		        },
		        config = {
		          scaleSize = CCSizeMake(170, 49)
		        }
		      },
		      {
		        t = "Scale9Button",
		        base = {
		          name = "issueinfo4",
		          buttonName = {
		            text = T(LSTR("CONFIGURE.ISSUE.FEEDBACK")),
		            fontInfo = "ui_normal_button"
		          },
		          res = {
		            normal = "UI/alpha/HVGA/sell_number_button.png",
		            press = "UI/alpha/HVGA/sell_number_button_down.png"
		          },
		          capInsets = CCRectMake(15, 22, 15, 25),
		          parent = "issueinfo",
		          handleName = "ReportIssuefunc4"
		        },
		        layout = {
		          anchor = ccp(0.5, 0.5),
		          position = ccp(150, 100)
		        },
		        config = {
		          scaleSize = CCSizeMake(170, 49)
		        }
		      },
		      {
		        t = "Scale9Button",
		        base = {
		          name = "issueinfo5",
		          buttonName = {
		            text = T(LSTR("CONFIGURE.LOST.ACCOUNT")),
		            fontInfo = "ui_normal_button"
		          },
		          res = {
		            normal = "UI/alpha/HVGA/sell_number_button.png",
		            press = "UI/alpha/HVGA/sell_number_button_down.png"
		          },
		          capInsets = CCRectMake(15, 22, 15, 25),
		          parent = "issueinfo",
		          handleName = "ReportIssuefunc5"
		        },
		        layout = {
		          anchor = ccp(0.5, 0.5),
		          position = ccp(150, 50)
		        },
		        config = {
		          scaleSize = CCSizeMake(170, 49)
		        }
		      },
		      {
		        t = "SpriteButton",
		        base = {
		          name = "closeIssueInfo",
		          res = {
		            normal = "UI/alpha/HVGA/common/common_tips_button_close_1.png"
		          },
		          parent = "issueinfo",
		          handleName = "closeIssueInfo"
		        },
		        layout = {
		          anchor = ccp(0.5, 0.5),
		          position = ccp(284, 284)
		        }
		      },
	    }
	  }
}


local function initRuleLayer()
  local list = rulePanel.ruleLayer.listview
  local textinfo 
  for i=1,20 do
  	textinfo = T(LSTR("HERO.FAQ.INFO.TITLE."..tostring(i)))
  	textinfo = "<text|normalButton|"..textinfo..">"
  	list:addItem({textinfo})
  	textinfo = T(LSTR("HERO.FAQ.INFO.CONTENT."..tostring(i)))
  	textinfo = "<text|dark_white|"..textinfo.."\n>"
	list:addItem({textinfo})
  end
end
function helpsupport.create()
	rulePanel = panelMeta:new2(helpsupport, UIRes)
	ruleIssuePanel = panelMeta:new2(helpsupport, UIIssueRes)
	initRuleLayer()

	local currentScene = CCDirector:sharedDirector():getRunningScene()
    if currentScene then
      	currentScene:addChild(rulePanel:getRootLayer(), 500)
      	currentScene:addChild(ruleIssuePanel:getRootLayer(), 500)
      	ruleIssuePanel:setVisible(false)
      	initsuccess = true
    end
end

function helpsupport.closeRuleInfo()
  local currentScene = CCDirector:sharedDirector():getRunningScene()
  if currentScene and rulePanel then
    currentScene:removeChild(rulePanel:getRootLayer(), true)
    rulePanel = nil
    initsuccess = false
  end
end

function helpsupport.formusDown()
	if initsuccess then
		LegendOpenURL("http://www.we4dota.com")
	end
end

function helpsupport.ReportIssue()
	if initsuccess then
		ruleIssuePanel:setVisible(true)
	end
end
function helpsupport.ReportIssuefunc1()
	if initsuccess then
		LegendSendMailIssue(T(LSTR("CONFIGURE.ISSUE.PURCHASING")),ed.getUserid())
	end
end

function helpsupport.ReportIssuefunc2()
	if initsuccess then
		LegendSendMailIssue(T(LSTR("CONFIGURE.ISSUE.CONNECTION")),ed.getUserid())
	end
end
function helpsupport.ReportIssuefunc3()
	if initsuccess then
		LegendSendMailIssue(T(LSTR("CONFIGURE.ISSUE.OTHER")),ed.getUserid())
	end
end
function helpsupport.ReportIssuefunc4()
	if initsuccess then
		LegendSendMailIssue(T(LSTR("CONFIGURE.ISSUE.FEEDBACK")),ed.getUserid())
	end
end
function helpsupport.ReportIssuefunc5()
	if initsuccess then
		LegendSendMailIssue(T(LSTR("CONFIGURE.LOST.ACCOUNT")),ed.getUserid())
	end
end
function helpsupport.closeIssueInfo()
	if initsuccess then
		ruleIssuePanel:setVisible(false)
	end
end

