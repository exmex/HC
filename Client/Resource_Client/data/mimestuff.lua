local base = _G
local ltn12 = require("ltn12")
local mime = require("mime")
local io = require("io")
local string = require("string")
module("mimestuff")
encodet = {}
decodet = {}
wrapt = {}
local function choose(table)
  return function(name, opt1, opt2)
    if base.type(name) ~= "string" then
      name, opt1, opt2 = "default", name, opt1
    end
    local f = table[name or "nil"]
    if not f then
      base.error("unknown key (" .. base.tostring(name) .. ")", 3)
    else
      return f(opt1, opt2)
    end
  end
end
function encodet.base64()
  return ltn12.filter.cycle(mime.b64, "")
end
encodet["quoted-printable"] = function(mode)
  return ltn12.filter.cycle(mime.qp, "", mode == "binary" and "=0D=0A" or "\r\n")
end
function decodet.base64()
  return ltn12.filter.cycle(mime.unb64, "")
end
decodet["quoted-printable"] = function()
  return ltn12.filter.cycle(mime.unqp, "")
end
local function format(chunk)
  if chunk then
    if chunk == "" then
      return "''"
    else
      return string.len(chunk)
    end
  else
    return "nil"
  end
end
function wrapt.text(length)
  length = length or 76
  return ltn12.filter.cycle(mime.wrp, length, length)
end
wrapt.base64 = wrapt.text
wrapt.default = wrapt.text
wrapt["quoted-printable"] = function()
  return ltn12.filter.cycle(mime.qpwrp, 76, 76)
end
encode = choose(encodet)
decode = choose(decodet)
wrap = choose(wrapt)
function normalize(marker)
  return ltn12.filter.cycle(mime.eol, 0, marker)
end
function stuff()
  return ltn12.filter.cycle(mime.dot, 2)
end
