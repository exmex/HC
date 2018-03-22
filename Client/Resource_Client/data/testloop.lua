
local a = {[1]=2,[2]=4,[3]=8} 
local b = {}
local c
for i,v in pairs(a) do
  
  b[i] = function() return v end
  foo:bar(b[i]())
end
print(b[1](), b[2](), b[3]())
