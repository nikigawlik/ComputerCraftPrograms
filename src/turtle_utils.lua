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

function turtle.reverse()
  turtle.turnLeft()
  turtle.turnLeft()
end

function turtle.carefulDig()
    repeat until not turtle.dig()
end
function turtle.carefulDigUp()
    repeat until not turtle.digUp()
end
function turtle.carefulDigDown()
    turtle.digDown()
end

function turtle.carefulForward() 
  while not turtle.forward() do 
    turtle.attack()
    turtle.dig()
  end
end

function turtle.carefulBack() 
  if not turtle.back() then
    turtle.reverse()
    turtle.carefulForward()
    turtle.reverse()
  end
end

function turtle.carefulUp() 
  while not turtle.up() do 
    turtle.attackUp()
    turtle.digUp()
  end
end

function turtle.carefulDown() 
  while not turtle.down() do 
    turtle.attackDown()
    turtle.digDown()
  end
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