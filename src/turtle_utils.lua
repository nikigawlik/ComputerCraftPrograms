---- navigation system ----
-- right handed coordinate system
-- x is to the right
-- y is the direction the turtle is facing at start
-- z is up
-- facing (from 0 to 3): 0 is +y, 1 is +x, ...
turtle.x = 0
turtle.y = 0
turtle.z = 0
turtle.facing = 1

function turtle.fToX(f) 
  f = f % 4
  if f == 0 then 
    return 1
  elseif f == 2 then
    return -1
  end 
  return 0
end

function turtle.fToY(f)
  f = f % 4
  if f == 1 then
    return 1
  elseif f == 3 then 
    return -1
  end
  return 0
end

function turtle.checkAndRefuel(level, slot)
  if turtle.getFuelLevel() < level then
    if slot then
      turtle.select(slot)
      if turtle.refuel(0)  then
        repeat until turtle.getFuelLevel() >= level or not turtle.refuel(1)
      end
    end
    
    for i=1,16 do
      turtle.select(i)
      if turtle.refuel(0)  then
        repeat until turtle.getFuelLevel() >= level or not turtle.refuel(1)
      end
    end
  end
  return turtle.getFuelLevel() >= level
end


function turtle.dump(from, to)
  from = from or 1
  to = to or 16

  for i=from,to do 
    turtle.select(i)
    turtle.drop()
  end
end

function turtle.dumpDown(from, to)
  from = from or 1
  to = to or 16

  for i=from,to do 
    turtle.select(i)
    turtle.dropDown()
  end
end

function turtle.dumpUp(from, to)
  from = from or 1
  to = to or 16
  
  for i=from,to do 
    turtle.select(i)
    turtle.dropUp()
  end
end

function turtle.carefulDig()
    repeat until not turtle.dig()
    return true
end
function turtle.carefulDigUp()
    repeat until not turtle.digUp()
    return true
end
function turtle.carefulDigDown()
    turtle.digDown()
    return true
end

-- movement --

function turtle.resetPosition() 
  turtle.x = 0
  turtle.y = 0
  turtle.z = 0
  turtle.facing = 1
end

-- override
local turnLeftOld = turtle.turnLeft
function turtle.turnLeft() 
  turnLeftOld()
  turtle.facing = (turtle.facing + 1) % 4
end

-- override
local turnRightOld = turtle.turnRight
function turtle.turnRight()
  turnRightOld()
  turtle.facing = (turtle.facing + 3) % 4
end

function turtle.reverse()
  turtle.turnLeft()
  turtle.turnLeft()
end

function turtle.turnTo(targetF) 
  local dif = (targetF - turtle.facing) % 4
  if dif == 2 then
    turtle.reverse()
  elseif dif == 1 then
    turtle.turnLeft()
  elseif dif == 3 then
    turtle.turnRight()
  end
end

function turtle.carefulForward() 
  local timeout = 0
  while not turtle.forward() do 
    timeout = timeout + 1
    if timeout > 32 then
      return false
    end
    turtle.attack()
    turtle.dig()
  end

  turtle.x = turtle.x + turtle.fToX(turtle.facing)
  turtle.y = turtle.y + turtle.fToY(turtle.facing)
  return true
end

function turtle.carefulBack() 
  if turtle.back() then
    turtle.x = turtle.x - turtle.fToX(turtle.facing)
    turtle.y = turtle.y - turtle.fToY(turtle.facing)
    return true
  else 
    turtle.reverse()
    local sucess = turtle.carefulForward()
    turtle.reverse()
    return sucess
  end
end

function turtle.carefulUp() 
  local timeout = 0
  while not turtle.up() do 
    timeout = timeout + 1
    if timeout > 32 then
      return false
    end
    turtle.attackUp()
    turtle.digUp()
  end

  turtle.z = turtle.z + 1
  return true
end

function turtle.carefulDown() 
  local timeout = 0
  while not turtle.down() do 
    timeout = timeout + 1
    if timeout > 32 then
      return false
    end
    turtle.attackDown()
    turtle.digDown()
  end

  turtle.z = turtle.z - 1
  return true
end

function turtle.mF(steps) 
  for i=1,steps do
    turtle.carefulForward()
  end
end
function turtle.mD(steps) 
  for i=1,steps do
    turtle.carefulDown()
  end
end
function turtle.mU(steps) 
  for i=1,steps do
    turtle.carefulUp()
  end
end

function turtle.selectItem(name)
  if turtle.isItemSelected(name) then
    return true
  end
  local startslot = turtle.getSelectedSlot()
  for i = 0,15 do
    turtle.select(((startslot+i - 1) % 16 + 1))
    if turtle.isItemSelected(name) then
      return true
    end
  end
  return false
end 

function turtle.isItemSelected(name)
  item = turtle.getItemDetail()
  if item then
    if item.name == name or "minecraft:" .. name == item.name then
      return true
    end
  end
  return false
end

function turtle.carefulPlaceDown() 
  while not turtle.placeDown() do
    turtle.digDown()
  end
end
function turtle.carefulPlaceUp() 
  while not turtle.placeUp() do
    turtle.digUp()
  end
end
function turtle.carefulPlace() 
  while not turtle.place() do
    turtle.dig()
  end
end

function turtle.isFull()
  for i=1,16 do
    if turtle.getItemCount(i) == 0 then
      return false
    end
  end
  return true
end