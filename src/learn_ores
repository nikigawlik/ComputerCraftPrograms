
function save(string)
  local file = fs.open("ore_list","a")
  file.write(string)
  file.close()
end

while true do
  if turtle.getItemCount() > 0 then
  	data = turtle.getItemDetail()
	save(data.name .. "\n")
    turtle.drop()
  end
end
  
