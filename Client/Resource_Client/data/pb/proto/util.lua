local assert = assert
local pairs = pairs
local type = type
local lpeg = require("lpeg")
local P, V = lpeg.P, lpeg.V
module(...)
function listOf(patt, sep)
  patt, sep = P(patt), P(sep)
  return patt * (sep * patt) ^ 0
end
function complete(dest, orig)
  for rule, patt in pairs(orig) do
    if not dest[rule] then
      dest[rule] = patt
    end
  end
  return dest
end
function apply(grammar, rules, captures)
  if rules == nil then
    rules = {}
  elseif type(rules) ~= "table" then
    rules = {rules}
  end
  complete(rules, grammar)
  if type(grammar[1]) == "string" then
    rules[1] = V(grammar[1])
  end
  if captures ~= nil then
    assert(type(captures) == "table", "captures must be a table")
    for rule, cap in pairs(captures) do
      rules[rule] = rules[rule] / cap
    end
  end
  return rules
end
