-- usage: getfile name

-- run this line fo initial setup: 
-- local file = fs.open("getfile","w") file.write(http.get("http://192.168.1.112:8000/getfile.lua").readAll()) file.close()

local args = { ... }

local host = "http://192.168.1.112:8000/" -- dont forget final backslash
local path = args[1] .. ".lua"

print("fetching " .. path)

if not http then
    print("ERR: http not available!")
    return
end

local response = http.get(host .. path)

if not response then
    print("ERR: http request failed!")
end

local file = fs.open(args[1],"w")
file.write(response.readAll())
file.close()