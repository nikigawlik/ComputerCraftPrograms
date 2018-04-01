for d=0,15 do 
  local data = turtle.getItemDetail()
  if data then
    print("slot " .. turtle.getSelectedSlot() .. ": " .. data.name .. " " .. data.damage)
  end
  turtle.select(turtle.getSelectedSlot() % 16 + 1)
end