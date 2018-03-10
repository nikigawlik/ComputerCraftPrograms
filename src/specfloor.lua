local args = {...}
local w = tonumber(args[1])
local h = tonumber(args[2])
local floors = tonumber(args[3])
local block = "cobblestone"
local floorDif = args [4] or 4
local floorFuel = w * h * 2

local inverse = false

function dofloor()
  turtle.checkAndRefuel(floorFuel)

  for x=1,w do
    for y=1,h do
      turtle.selectItem(block)
      turtle.placeDown()
      if y ~= h then
        turtle.carefulForward()
      end
    end
    
    if x ~= w then
      if x % 2 == 1 then
        turtle.turnRight()
      else
        turtle.turnLeft()
      end
      turtle.carefulForward()
      if x % 2 == 1 then
        turtle.turnRight()
      else
        turtle.turnLeft()
      end
    end
  end
end

for i=1,floors do
  dofloor()
  turtle.mU(floorDif)
  if w % 2 == 0 then
    turtle.turnRight()
  else
    turtle.reverse()
  end
end



