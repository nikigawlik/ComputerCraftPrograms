-- this program has no automatic refuel

local leftMarker = "minecraft:gravel"
local rightMarker = "minecraft:sand"
local reverseMarker = "minecraft:planks"
local dropoffMarker = "minecraft:log"
local pickupMarker = "minecraft:sandstone"
local upMarker = "minecraft:stonebrick"
local downMarker = "minecraft:stone"
local abortMarker = "minecraft:dirt"

local isForw, dataForw, isUp, dataUp, isDown, dataDown

function step()
  isForw, dataForw = turtle.inspect()
  isUp, dataUp = turtle.inspectUp()
  isDown, dataDown = turtle.inspectDown()

  -- inventory
  if checkFor(dropoffMarker) then
    turtle.dump()
  end
  if checkFor(pickupMarker) then
    repeat until not turtle.suck()
  end

  -- rotations
  if checkFor(leftMarker) then
    turtle.turnLeft()
  end
  if checkFor(rightMarker) then
    turtle.turnRight()
  end
  if checkFor(reverseMarker) then
    turtle.reverse()
  end

  -- movement
  if checkFor(upMarker) then
    turtle.carefulUp()
  elseif checkFor(downMarker) then
    turtle.carefulDown()
  elseif not turtle.detect() then
    turtle.carefulForward()
  end

  -- exit
  if checkFor(abortMarker) then
    return false
  end

  return true
end

function checkFor(name) 
  return (isForw and dataForw.name == name) 
    or (isDown and dataDown.name == name) 
    or (isUp and dataUp.name == name)
end

args = {...}

turtle.setDestructive(false)

if args[1] == "info" then
  print("leftMarker: " .. leftMarker)
  print("rightMarker: " .. rightMarker)
  print("dropoffMarker: " .. dropoffMarker)
  print("upMarker: " .. upMarker)
  print("downMarker: " .. downMarker)
else
  repeat until not step()
end 