local a = 1; b = "the quick brown fox\r\n"
function c() b = a a = b end
c = nil; c = -a; c = not b
for i = 1, 10 do a = a + 2 c() end
a = {}; a[1] = false; b = a[1]
a = d..c..b; a = b == c; a = {1,2,}
for i in b() do b = 1 end
return
