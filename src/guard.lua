
running = true

function checkAndRefuel()
  if turtle.getFuelLevel() < 10 then
    print("searching for fuel...")
    local i = 1
    while true do
      turtle.select(i)
      if turtle.refuel(0) then
        turtle.refuel(32)
        break
      end
      i = i + 1
      if i > 16 then 
        i = 1
      end
    end
    print("done.")
  end
end

function analyzeAndAct()
  local success, item = turtle.inspectDown()
  if success then
    if item.name == "ExtraUtilities:color_stonebrick" then
      if item.metadata == 13 then
        turtle.turnRight()
      elseif item.metadata == 14 then
        turtle.turnLeft()
      elseif item.metadata == 15 then
        running = false
      end
    end
  end
end

function move()
  while not turtle.detectDown() and not turtle.detect() do
    turtle.down()
  end
  while turtle.detect() do
    turtle.up()
  end
  while not turtle.forward() do
    turtle.attack()
  end
end


while running do
  turtle.attack()
  move()
  checkAndRefuel()
  analyzeAndAct()
end