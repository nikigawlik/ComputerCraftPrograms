local RESETTING = 0
local WAITING = 1
local DISTRIBUTING = 2
local REFUELING = 3

local marker = "minecraft:cobblestone" -- marker below the 0, 0, 0 position
local waitingSleepDelay = 1 -- seconds
local registryFile = "itemDict"
local overflowX = 2 -- TODO make setting
local overflowZ = 0

local fuelReserve = 100
local chestDistance = 2 -- TODO make setting

local state = RESETTING
local destinations = {} -- array of current destinations, contains objects with chestID and slot fields

local destinationRules = {}

function step() 
  if state == RESETTING then
    stepResetting()
  elseif state == WAITING then
    -- redstone abort
    if rs.getInput("back") then
      print("redstone shutoff.")
      return true
    end
    stepWaiting()
  elseif state == DISTRIBUTING then
    stepDistributing()
  elseif state == REFUELING then
    stepRefueling()
  end
end

function stepResetting()
  local blockDown, data = turtle.inspectDown()

  if not blockDown then 
    turtle.carefulDown()
  elseif turtle.detect() then
    turtle.turnRight()
  elseif blockDown and data.name == marker then
    turtle.turnLeft()
    turtle.resetPosition()
    state = WAITING
  else 
    turtle.carefulForward()
  end
end

function stepWaiting()
  -- ensure fuel
  if turtle.getFuelLevel() < fuelReserve then
    turtle.turnLeft()
    print("Refueling...")
    state = REFUELING
    return
  end
  -- get items
  local sucess = turtle.suck()
  if not sucess then
    if not turtle.isEmpty() then
      prepDistributing()
      state = DISTRIBUTING
    else
      sleep(waitingSleepDelay)
    end
  end
end

function prepDistributing() 
  destinations = {}
  for i=1,16 do
    local item = turtle.getItemDetail(i)
    if item then
      -- find first matching rule for destination
      for j, rule in ipairs(destinationRules) do
        local item_name = string.lower(item.name)
        if item_name:match(rule.name) then
          local obj = {}
          obj.chestID = rule.chestID
          obj.slot = i
          table.insert(destinations, obj)
          break
        end
      end
    end
  end
  table.sort(destinations, function(a, b) return a.chestID < b.chestID end)
end

function stepDistributing() 
  print("Distribute items...")
  for i, d in ipairs(destinations) do
    local x = (tonumber(d.chestID:match("%d+")) - 1) * chestDistance
    local z = string.byte(d.chestID:match("%a"), 1) - string.byte("a")
    repeat until not stepTowards(x, z)
    turtle.turnTo(1)
    turtle.select(d.slot)
    turtle.drop() 
  end
  destinations = {}
  repeat until not stepTowards(overflowX, overflowZ)
  turtle.turnTo(1)
  turtle.dump()
  repeat until not stepTowards(0, 0)
  turtle.turnTo(1)
  state = WAITING
end

function stepTowards(x, z)
  if turtle.x < x then
    turtle.turnTo(0)
    turtle.carefulForward()
  elseif turtle.x > x then
    turtle.turnTo(2)
    turtle.carefulForward()
  elseif turtle.z < z then
    turtle.carefulUp()
  elseif turtle.z > z then
    turtle.carefulDown()
  else
    return false
  end
  return true
end

function stepRefueling() 
  turtle.select(1) -- just because
  if turtle.suck() then 
    turtle.refuel()
    turtle.drop()
    if turtle.getFuelLevel() >= fuelReserve then
      turtle.turnRight()
      print("Done refueling.")
      state = WAITING
    end
  else
    sleep(1) -- wait if fuel is empty
  end
end

function loadRegistry() 
  print("Load registry...")
  local f = fs.open(registryFile, "r")
  if not f then 
    print("No registry file found: " .. registryFile)
    return false
  end

  local line = 0
  while true do
    line = line + 1
    local str = f.readLine()
    if str then
      if not parseRegLine(str) then
        print("--> Could not parse dictionary line " .. line .. ". Continuing...")
      end
    else
      break
    end
  end
  f.close()

  print("Registry loaded, rules: ")
  for i, rule in ipairs(destinationRules) do
    print(rule.name .. "->" .. rule.chestID)
  end

  return true
end

function parseRegLine(line) 
  line = string.lower(line)
  -- ignore comments
  if line:find("%s*#") then
    return true
  end
  -- get an iterator of all "words". 
  local iterator = line:gmatch("[%w:_]+");
  local chestID = iterator()
  if not chestID:match("%d%a+") then
    print("Not a valid chest id: " .. chestID)
    return false
  end
  for str in iterator do
    addRule(str, chestID)
  end
  return true
end

function addRule(name, chestID) 
  local rule = {}
  rule.name = name
  rule.chestID = chestID
  table.insert(destinationRules, rule)
end

turtle.setDestructive(false)
loadRegistry()

while true do 
  if step() then
    break
  end
end