args = {...}

local fuelReserve = 0  -- set later
local w = 0 -- set later
local h = 0  -- set later

local MINING = 0
local RETURNING = 1
local UNLOADING = 2
local CONTINUING = 3
local FINISHING = 4
local DONE = 5
local state = MINING 

local locX = 0
local locY = 0
local locZ = 0
local locFacing = 1
turtle.resetPosition()

function step()
  if state == MINING then
    stepMining()
  elseif state == UNLOADING then
    stepUnloading()
  elseif state == RETURNING then
    stepReturning()
  elseif state == CONTINUING then
    stepContinuing()
  elseif state == FINISHING then
    stepFinishing()
  elseif state == DONE then
    return false
  end
  return true
end

function stepMining() 
  -- always save at beginning of mining step
  save()

  local bok = true -- control variable for bedrock, will be set tot false if bedrock is encountered

  if not turtle.checkAndRefuel(fuelReserve) then
    print("Not enought fuel. Returning...")
    setReturning()
  elseif turtle.isFull() then
    print("Inventory full. Returning...")
    setReturning()
  else
    -- execute this at very first block
    if turtle.x == 0 and turtle.y == 0 and turtle.z == 0 then
      bok = turtle.carefulDown() and bok
      bok = turtle.carefulDigDown() and bok
      bok = turtle.carefulDigUp() and bok
    end
    -- check if we are at the end of a row
    local nextY = turtle.y + turtle.fToY(turtle.facing)
    if nextY >= h or nextY < 0 then
      -- progress +x for even and -x for uneven layers
      local evenLayer = turtle.z % 2 == 1 -- counterintuitively, we have an even layer when z is odd
      if evenLayer then
        turtle.turnTo(0)
      else
        turtle.turnTo(2)
      end

      -- check if we are at end of current layer
      if (evenLayer and turtle.x < w-1) or (not evenLayer and turtle.x > 0) then
        -- progress to next row
        bok = pillarForward() and bok
      else
        -- go down to next layer
        bok = turtle.carefulDigUp() and bok
        for i=1,3 do
          bok = turtle.carefulDown() and bok
        end
        bok = turtle.carefulDigDown() and bok
      end
      
      -- face inwards
      if turtle.y == 0 then
        turtle.turnTo(1)
      else 
        turtle.turnTo(3)
      end
    else
      -- normal row digging
      bok = pillarForward() and bok
    end
  end

  if not bok then 
    state = FINISHING
  end
end

-- moves and digs a 1x1x3 pillar of blocks
function pillarForward()
  local sucess = true

  sucess = turtle.carefulForward() and sucess
  sucess = turtle.carefulDigUp() and sucess
  sucess = turtle.carefulDigDown() and sucess

  return sucess
end

function setReturning()
  state = RETURNING
  locX = turtle.x 
  locY = turtle.y 
  locZ = turtle.z 
  locFacing = turtle.facing 
end

-- steps towards position specified
-- returns true if a step was made
-- and false if destination is reached
function stepTowards(x, y, z)
  if turtle.z < z then
    turtle.carefulUp()
  elseif turtle.z > z then
    turtle.carefulDown()
  elseif turtle.y < y then
    turtle.turnTo(1)
    turtle.carefulForward()
  elseif turtle.y > y then
    turtle.turnTo(3)
    turtle.carefulForward()
  elseif turtle.x < x then
    turtle.turnTo(0)
    turtle.carefulForward()
  elseif turtle.x > x then
    turtle.turnTo(2)
    turtle.carefulForward()
  else
    return false
  end
  return true
end

-- takes a step in order to return to 0, 0, 0
function stepReturning()
  if not stepTowards(0, 0, 0) then
    turtle.turnTo(3)
    state = UNLOADING
  end
end

function stepContinuing() 
  if not stepTowards(locX, locY, locZ) then
    turtle.turnTo(locFacing)
    state = MINING
  end
end

function stepFinishing()
  if not stepTowards(0, 0, 0) then
    turtle.turnTo(3)
    turtle.dump()
    turtle.reverse()
    print("Done. It was a pleasure digging for you.")
    state = DONE
  end
end

function stepUnloading()
  turtle.dump(2)
  if not turtle.checkAndRefuel(fuelReserve) then
    turtle.select(1)
    print("please insert fuel")
    repeat sleep(1) until turtle.checkAndRefuel(fuelReserve)
    print("thanks")
  end
  state = CONTINUING
end

function save()
  local f = fs.open("sav_superexcavate", "w")
  f.writeLine(tostring(w))
  f.writeLine(tostring(h))
  f.writeLine(tostring(turtle.x))
  f.writeLine(tostring(turtle.y))
  f.writeLine(tostring(turtle.z))
  f.writeLine(tostring(turtle.facing))
  f.close()
end

function load()
  local f = fs.open("sav_superexcavate", "r")
  if not f then
    print("no save file available.")
    return false
  end

  w = tonumber(f.readLine())
  h = tonumber(f.readLine())
  locX = tonumber(f.readLine())
  locY = tonumber(f.readLine())
  locZ = tonumber(f.readLine())
  locFacing = tonumber(f.readLine())
  f.close()

  return true
end

-- main code

if #args ~= 1 then
  print("please provide one argument. Possible formats:")
  print("superexcavate <width>")
  print("superexcavate continue")
  return
end

if args[1] == "continue" then
  if not load() then
    return
  end
  print("continuing from saved position.")
  state = CONTINUING 
else
  w = tonumber(args[1])
  h = w
end

fuelReserve = 300 + w + h -- make sure we are always be able to return

-- perform steps until it returns false
repeat until not step()