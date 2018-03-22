local _G = _G
local upper = string.upper
local lp = require("lpeg")
local P = lp.P
local S = lp.S
local R = lp.R
local B = lp.B
local C = lp.C
local Cf = lp.Cf
local Cc = lp.Cc
module(...)
local num_sign = S("+-")
local digit = R("09")
local hexLit = P("0") * S("xX") * R("09", "af", "AF") ^ 1
local octLit = P("0") * R("07") ^ 1
local floatLit = digit ^ 1 * (P(".") ^ -1 * digit ^ 0) ^ -1 * (S("eE") * num_sign ^ -1 * digit ^ 1) ^ -1
local decLit = digit ^ 1
local sdecLit = P("-") ^ -1 * decLit
local AZ = R("az", "AZ")
local AlphaNum = AZ + R("09")
local identChar = AlphaNum + P("_")
local not_identChar = -identChar
local ident = (AZ + P("_")) * identChar ^ 0
local quote = P("\"")
local line_accum = function(t, v)
  return t + v
end
local line_count = Cf((Cc(1) * P("\n") + 1) ^ 0, line_accum)
function lines(subject)
  return line_count:match(subject) + 1
end
function error(msg)
  return function(subject, i)
    local line = lines(subject:sub(1, i))
    _G.error("Lexical error in line " .. line .. ", near \"" .. subject:sub(i - 10, i):gsub("\n", "EOL") .. "\": " .. msg, 0)
  end
end
local function literals(tab, term)
  local ret = P(false)
  for i = 1, #tab do
    local lit = tab[i]
    tab[i] = nil
    local pat = P(lit)
    if term then
      pat = pat * term
    end
    tab[upper(lit)] = pat
    ret = pat + ret
  end
  return ret
end
keywords = {
  "package",
  "import",
  "message",
  "extend",
  "enum",
  "option",
  "required",
  "optional",
  "repeated",
  "extensions",
  "to",
  "max",
  "group",
  "service",
  "rpc",
  "returns",
  "double",
  "float",
  "int32",
  "int64",
  "uint32",
  "uint64",
  "sint32",
  "sint64",
  "fixed32",
  "fixed64",
  "sfixed32",
  "sfixed64",
  "bool",
  "string",
  "bytes",
  "true",
  "false"
}
KEYWORD = literals(keywords, not_identChar)
symbols = {
  "=",
  ";",
  ".",
  ",",
  "{",
  "}",
  "(",
  ")",
  "[",
  "]"
}
SYMBOL = literals(symbols)
INTEGER = hexLit + octLit + decLit
SINTEGER = hexLit + octLit + sdecLit
NUMERIC = hexLit + octLit + floatLit + decLit
SNUMERIC = hexLit + octLit + floatLit + sdecLit
IDENTIFIER = ident
STRING = quote * (1 - S("\"\n\r\\") + P("\\") * 1) ^ 0 * (quote + error("unfinished string"))
COMMENT = P("//") * (1 - P("\n")) ^ 0 + P("/*") * (1 - P("*/")) ^ 0 * P("*/")
SPACE = S(" \t\n\r")
IGNORED = (SPACE + COMMENT) ^ 0
TOKEN = IDENTIFIER + KEYWORD + SYMBOL + SNUMERIC + STRING
ANY = TOKEN + COMMENT + SPACE
BOF = P(function(s, i)
  return i == 1 and i
end)
EOF = P(-1)
