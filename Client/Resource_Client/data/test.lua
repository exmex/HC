local time = os.time()
for i = 1, 100000 do
  for j = 1, 10000 do
    local a = i * j
  end
end
print("Time: " .. os.time() - time)
