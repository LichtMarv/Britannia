-- Update and Installer script
-- Automatically downloads ComputerCraft programs to a computer

urls = {
    {"Start",         "https://raw.githubusercontent.com/LichtMarv/Britannia/main/lua/Start.lua"}--,
    {"Installer",     "https://raw.githubusercontent.com/???/???.lua"}
}
if not(fs.exists("Start")) then
  file = fs.open("startup.lua", "w")
    file.write("shell.run(\"Installer\")")
    file.write("shell.run(\"Start\")")
    file.close()
end

function download(name, url)
  print("Updating " .. name)
 
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
 
  print("Successfully downloaded " .. name .. "\n")
end

for key, value in ipairs(urls) do
    download(unpack(value))
end