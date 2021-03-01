-- Update and Installer script
-- Automatically downloads ComputerCraft programs to a computer

urls = {
    {"Start",         "https://raw.githubusercontent.com/LichtMarv/Britannia/master/lua/Start.lua"}
}
if not(fs.exists("Start")) then
  file = fs.open("startup.lua", "w")
    file.write("shell.run(\"Installer\") \n")
    file.write("shell.run(\"Start\")")
    file.close()
    shell.run("pastebin get 4nRg9CHU json")
end

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