local fuelHeuristic = 1000  -- maximum fuel for one tree
local fuelSlot = 1 -- if empty searches for other fuel
local saplingSlot = 2
local storageStartSlot = 3


function digTree() 
    turtle.carefulForward()
    -- turtle.carefulForward()

    local up = true;

    while up do
        local success, data = turtle.inspectUp()
        if not success then
            up = false
        elseif data.name ~= "minecraft:log" then
            up = false
        end
        turtle.dig()
        turtle.digUp()
        turtle.up()
    end

    turtle.digUp()
    turtle.carefulForward()
    turtle.digUp()
    turtle.turnRight()
    turtle.carefulForward()
    turtle.digUp()
    turtle.turnRight()
    turtle.carefulForward()
    turtle.digUp()
    turtle.reverse()

    while true do
        local success, data = turtle.inspectDown()
        if not success then
            break
        end
        if data.name ~= "minecraft:log" then
            break
        end
        turtle.dig()
        turtle.digDown()
        turtle.down()
    end

    turtle.dig()
    turtle.turnLeft()
    turtle.carefulForward()
    turtle.turnLeft()
    turtle.carefulForward()
    -- turtle.carefulForward()
    turtle.reverse()
end

function cycle()
  local success, data = turtle.inspect()

  print("checking fuel...")
  if not turtle.checkAndRefuel(fuelHeuristic, fuelSlot) then
    print("waiting for fuel...")
    repeat sleep(2) until turtle.checkAndRefuel(fuelHeuristic, fuelSlot)
  end

  print("checking for tree...")
  if data.name == "minecraft:log" then
    print("digging tree...")
    digTree()
    turtle.reverse()
    turtle.dump(storageStartSlot)

    -- get saplings
    print("looking for saplings below me...")
    while true do
      turtle.select(saplingSlot)
      local data = turtle.getItemDetail()
      local count = turtle.getItemCount()
      local isSap = count > 0 and data.name == "minecraft:sapling" and data.damage == 1
      if count > 4 and isSap then
        break
      elseif not isSap then
        turtle.drop()
        turtle.suckDown()
      else
        turtle.suckDown()
      end
    end
    turtle.reverse()

    -- plant tree
    turtle.carefulForward()
    turtle.place()
    turtle.turnRight()
    turtle.carefulForward()
    turtle.turnLeft()
    turtle.place()
    turtle.turnRight()
    turtle.back()
    turtle.place()
    turtle.turnLeft()
    turtle.back()
    turtle.place()
  end
end

while true do
  cycle()
  sleep(10)
end
