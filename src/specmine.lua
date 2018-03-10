args = {...}
local depth = args[1]

function digpil()
  turtle.carefulDig()
  turtle.carefulForward()
  turtle.digUp()
  turtle.digDown()
end

function layer()
  for i=1,7 do
    digpil()
  end
  turtle.carefulDown()
  turtle.digDown()
  turtle.carefulDown()
  turtle.digDown()
  turtle.carefulDown()
  turtle.digDown()
  turtle.reverse()
end

for i=1,depth/3 do
  layer()
end