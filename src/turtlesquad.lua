args = {...}

shell.run("turtle_utils")

-- turtle faces "negative y" at beginning 
-- in relation to x and y below

if #args ~= 5 then
  print("usage: turtlesquad w h dx dy coalAmount")
  return
end

w = args[1]
h = args[2]
dx = args[3]
dy = args[4]
coalAmount = args[5]

function placeCopyReboot()
  --  TODO
  turtle.selectItem("ComputerCraft:CC-TurtleExpanded")
  turtle.carefulPlaceDown()
  turtle.mF(1)
  turtle.selectItem("ComputerCraft:CC-Peripheral")
  turtle.carefulPlaceDown()
  turtle.selectItem("ComputerCraft:diskExpanded")
  turtle.dropDown()
  turtle.carefulBack()
  local inst = peripheral.wrap("bottom")
  inst.reboot()
  turtle.carefulForward()
  turtle.suckDown()
  turtle.digDown()
  turtle.carefulBack()
  turtle.selectItem("minecraft:coal")
  turtle.dropDown(coalAmount)
  inst.reboot()
end

goingForw = true

for y=1,w do
  for x=1,h do
    placeCopyReboot()
    turtle.mF(dx)
  end
  if goingForw then
    turtle.turnLeft()
    turtle.mF(1)
    turtle.turnLeft()
  else
    turtle.turnRight()
    turtle.mF(1)
    turtle.turnRight()
  end
end