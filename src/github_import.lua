names = {"automine", "turtle_utils" }

for name in names do
  shell.run("github", "nilsgawlik/ComputerCraftPrograms/master/src/" .. name .. ".lua", name)
end