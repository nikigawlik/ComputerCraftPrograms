ores = {}


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

function carefulDig()
    repeat until not turtle.dig()
end
function carefulDigUp()
    repeat until not turtle.digUp()
end
function carefulDigDown()
    turtle.digDown()
end

function addOre(blockname)
  ores[blockname] = true
end
function isOre(blockname)
  return ores[blockname] ~= nil
end


addOre("minecraft:obsidian")

function oreFront()
  print("checking front")
  local success, data = turtle.inspect()
  return isOre(data.name)
end
function oreUp()
  print("checking up")
  local success, data = turtle.inspectUp()
  return isOre(data.name)
end
function oreDown()
  print("checking down")
  local success, data = turtle.inspectDown()
  return isOre(data.name)
end



function recMine()
  for i=1,4 do 
    if oreFront() then
      carefulDig()
      turtle.forward()
      recMine()
      turtle.back()
    end
    turtle.turnLeft() 
  end
  if oreUp() then
    carefulDigUp()
    turtle.up()
    recMine()
    turtle.down()
  end
  if oreDown() then
    carefulDigDown()
    turtle.down()
    recMine()
    turtle.up()
  end
end

recMine()