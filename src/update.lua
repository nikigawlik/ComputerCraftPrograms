local list = {"github", "turtle_utils", "automine", "sorter"}

for i, name in ipairs(list) do
    shell.run("getfile", name)
end
