args = {...}

if #args ~= 3 then
  print("please provide three arguments")
  return
end

ores = {}
length = args[1]-- 50
sep = args[2] -- 4
times = args[3] -- 5

time = os.clock()

function save(string)
  local file = fs.open("automine_save","w")
  file.write(string)
  file.close()
end
function load()
  local file = fs.open("automine_save", "r")
  local cont = file.readAll()
  file.close()
  return cont
end

function addOre(blockname)
  ores[blockname] = true
end

function isOre(blockname)
  if blockname == nil then 
    return false
  end
  if ores[blockname] ~= nil then
    return true
  end
  if string.find(blockname, "ore") ~= nil or string.find(blockname, "Ore") ~= nil then
    return true
  end
  return false
end

addOre("minecraft:iron_ore")
addOre("minecraft:coal_ore")
addOre("minecraft:lapis_ore")
addOre("minecraft:diamond_ore")
addOre("minecraft:gold_ore")
addOre("minecraft:redstone_ore")
addOre("minecraft:emerald_ore")

function oreFront()
  -- print("checking front")
  local success, data = turtle.inspect()
  return isOre(data.name)
end
function oreUp()
  -- print("checking up")
  local success, data = turtle.inspectUp()
  return isOre(data.name)
end
function oreDown()
  -- print("checking down")
  local success, data = turtle.inspectDown()
  return isOre(data.name)
end

function recMine()
  for i=1,4 do 
    if oreFront() then
      turtle.carefulDig()
      turtle.carefulForward()
      recMine()
      turtle.carefulBack()
    end
    turtle.turnLeft() 
  end
  if oreUp() then
    turtle.carefulDigUp()
    turtle.carefulUp()
    recMine()
    turtle.down()
  end
  if oreDown() then
    turtle.carefulDigDown()
    turtle.down()
    recMine()
    turtle.carefulUp()
  end
end

function mineLoop(length, seperation)
  print("check fuel level...")

  repeat until turtle.checkAndRefuel(length * 12, 2)
  
  print("fuel level OK: " .. turtle.getFuelLevel())
  
  for i=1,length do 
    turtle.carefulDig()
    turtle.carefulForward()
    turtle.carefulDigUp()
    recMine()
  end
  turtle.turnRight()
  for i=1,seperation do
    turtle.carefulDig()
    turtle.carefulForward()
    turtle.carefulDigUp()
    recMine()
  end
  turtle.turnRight()
  for i=1,length do
    turtle.carefulDig()
    turtle.carefulForward()
    turtle.carefulDigUp()
    recMine()
  end
end 

function dump()
  local success, data = turtle.inspectDown()
  if data.name == "minecraft:chest" then
    turtle.dumpDown(3, 16)
  else
    print("looking for chest")
    while true do
      if turtle.selectItem("chest") then
        turtle.carefulDigDown()
        turtle.placeDown()
        turtle.dumpDown(3, 16)
        break
      end
    end
  end
end

function printTime()
  print("seconds: " .. (os.clock()-time))
  time = os.clock()
end

for i=1,times do 
  dump()
  mineLoop(length, sep)  
  turtle.turnLeft()
  for i= 1,sep do 
    turtle.carefulForward()
    turtle.carefulDigUp()
  end
  turtle.turnLeft()
  printTime()
end
dump()
