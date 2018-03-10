local list = {"github", "turtle_utils", "automine", "sorter", "startup"}

for i, name in ipairs(list) do
    shell.run("getfile", name)
end
shell.run("reboot")
