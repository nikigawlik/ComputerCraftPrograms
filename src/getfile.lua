-- usage: getfile name

-- run this line fo initial setup: 
-- local file = fs.open("getfile","w") file.write(http.get("http://localhost:8000/getfile.lua").readAll()) file.close()

local args = { ... }

local host = "http://localhost:8000/" -- dont forget final backslash
local ext = args[2] or "lua"
local path = args[1] .. "." .. ext

print("fetching " .. path)

if not http then
    print("ERR: http not available!")
    return
end

local response = http.get(host .. path)

if not response then
    print("ERR: http request failed!")
    return
end

local file = fs.open(args[1],"w")
file.write(response.readAll())
file.close()