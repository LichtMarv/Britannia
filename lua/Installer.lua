-- Update and Installer script
-- Automatically downloads ComputerCraft programs to a computer

urls = {
    {"Start","https://raw.githubusercontent.com/LichtMarv/Britannia/master/lua/Start.lua"}
}
local RAM

if (fs.exists("saves/.config")) then
  local file = fs.open("saves/.config", "r")
  RAM = file.readAll()
  file.close()
else


    local file = fs.open("saves/.config","w")
    if(fs.exists("startup"))then 
    fs.delete("startup")
    end

    file = fs.open("startup", "w")
    file.writeLine("shell.run(\"Installer\")")
    file.writeLine("shell.run(\"Start\")")
    if not(RAM==nil) then
      if not (RAM.Rank=="admin") then
        file.write("os.reboot()")
      end
    end
    file.close()

function download(name, url)
 
  request = http.get(url)
  data = request.readAll()
 
  if fs.exists(name) then
    fs.delete(name)
    file = fs.open(name, "w")
    file.write(data)
    file.close()
  else
    file = fs.open(name, "w")
    file.write(data)
    file.close()
  end
end

for key, value in ipairs(urls) do
    download(unpack(value))
end
if not(fs.exists("Installer")) then
  shell.run("Start")
end