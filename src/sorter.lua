print("Sorting Mode...")

length = 5

x = 0
h = 0
d = 0

index = {}

function addPos(itemname, pos, damage)
  if damage == nil then
    index[itemname] = pos
  else
    index[itemname..damage] = pos
  end
end

function getpos()
  local data = turtle.getItemDetail()
  data.name = string.gsub(data.name, "minecraft:", "")
  local n = index[data.name .. data.damage]
  if n == nil then
    n = index[data.name]
    if n == nil then
      n = 1
    end
  end
  return n
end

function turn(newd)
  local delta = (newd-d)%4
  -- print("d: " .. d .. " newd: " .. newd .. " delta: " .. delta)
  d = newd
  -- print("d: " .. d)
  if delta == 1 then
    turtle.turnLeft()
  elseif delta == 3 then
    turtle.turnRight()
  elseif delta == 2 then
    turtle.turnRight()
    turtle.turnRight()
  end
end

function goto(id)
  local tox = math.floor((id/2) % (length))
  local toh = math.floor(id / (length*2))
  local tod = (id % 2)*2
  
  --print("go to " .. id .. " (" .. tox ", " .. toh .. ", " .. tod .. ")")
  
  while tox > x do
    turn(1)
    turtle.forward()
    x = x+1
  end
  while tox < x do
    turn(1)
    turtle.back()
    x = x-1
  end
  while toh > h do
    turtle.up()
    h = h+1
  end
  while toh < h do
    turtle.down()
    h = h-1
  end
  turn(tod)
end

function main()
  addPos("dirt", 3)
  addPos("gravel", 3)
  addPos("cobblestone", 5)
  addPos("stone", 7)
  addPos("sapling", 9)
  addPos("log", 9)
  addPos("planks", 9)
  addPos("stick", 9)
  
  addPos("furnace", 13)
  addPos("birch_fence", 13)
  addPos("oak_fence", 13)
  addPos("spruce_fence", 13)
  addPos("dark_oak_fence", 13)
  addPos("jungle_fence", 13)
  addPos("trapdoor", 13)
  addPos("wooden_door", 13)
  addPos("fence_gate", 13)
  addPos("chest", 13)
  addPos("trapped_chest", 13)
  addPos("jukebox", 13)
  addPos("bed", 13)
  addPos("sign", 13)
  addPos("iron_ore", 17)
  addPos("gold_ore", 17)
  addPos("lapis_ore", 17)
  addPos("redstone_ore", 17)
  addPos("diamond_ore", 17)
  addPos("emerald_ore", 17)
  addPos("iron_ingot", 17)
  addPos("gold_ingot", 17)
  addPos("diamond", 17)
  addPos("redstone", 17)
  addPos("dye", 17, 4) -- lapis
  addPos("emerald", 17)
  addPos("coal", 19)
  addPos("charcoal", 19)
  
  while true do
    turtle.checkAndRefuel(50, 1)
    turtle.select(2)
    repeat until turtle.suck()
    for i=3,16 do 
      turtle.select(i)
      turtle.suck()
    end
    for i=2,16 do 
      turtle.select(i)
      if turtle.getItemCount() ~= 0 then
        goto(getpos())
        turtle.drop()
        if turtle.getItemCount() > 0 then
          goto(1)
          turtle.drop()
        end
      end
    end
    goto(0)
  end
end

function test()
  goto(4)
end

main()

goto(0)

