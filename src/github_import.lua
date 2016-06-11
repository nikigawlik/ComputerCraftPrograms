names = {"automine", "turtle_utils" }

for i, name in ipairs(names) do
  shell.run("delete", name)
  shell.run("github", "nilsgawlik/ComputerCraftPrograms/master/src/" .. name .. ".lua", name)
end