names = {"automine", "turtle_utils", "chunk_mine" }

for i, name in ipairs(names) do
  shell.run("delete", name)
  shell.run("github", "nilsgawlik/ComputerCraftPrograms/master/src/" .. name .. ".lua", name)
end