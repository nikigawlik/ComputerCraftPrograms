h = 3
up = false

function pillar()
  for i=1,(h-1) do
    turtle.carefulDig()
    if up then
      turtle.down()
    else
      turtle.up()
    end
  end
  turtle.carefulDig()
  up = not up
end

function layer()
  pillar()
  turtle.forward()
  turtle.turnLeft()
  pillar()
  turtle.turnRight()
  turtle.turnRight()
  pillar()
  turtle.turnLeft()
end

args = { ... }

for i=1,args[1] do
  layer()
end