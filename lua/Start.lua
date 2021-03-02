local x, y, z = gps.locate(5)
local Config = {
    SessionKey = nil,
    UserName = nil,
    Rank = nil,
    Money = nil,
    IsTablat = false
}
local Internet = false
local id = os.getComputerID()
local IsTablet=false

    os.loadAPI("json")

    request = http.get("https://raw.githubusercontent.com/LichtMarv/Britannia/master/lua/Installer.lua")
    data = request.readAll()

    if fs.exists("Installer") then
        fs.delete("Installer")
    end
    file = fs.open("Installer", "w")
    file.write(data)
    file.close()

if (fs.exists("saves/.config")) then
    local file = fs.open("saves/.config", "r") -- Open the file we used before, ready for reading.
    Config = file.readAll()
    file.close()
else
    fs.makeDir("saves")
end

if not x then
    print("GPS Fehlgeschlagen ... Fehlt ein Wireless Modem?")
else
    local yfloor = math.floor( y )
    IsTablet = not (y==yfloor)
        
end

Internet = http.checkURL("http://purplepenguin.ddns.net:8500/")

if not Config.SessionKey then
    local input = ""
    term.setTextColor(colors.lightBlue)
    print("Gehe auf \"http://purplepenguin.ddns.net:8500/\" um den PC zu registrieren")
    while (input == "") do
        
        input = read()

        if input == "" then

            term.setTextColor(colors.red)
            print("Fehlgeschlagen - Kein Schlüssel eigegeben")

        end

    end
    term.setTextColor(colors.white)
    print("")
    input = input:gsub(" ", "")
    input = input:gsub("-", "")
    input = input:gsub("_", "")
    print("Abgleichung mit Server ...")

    local ServerContent = {
        Key = input,
        ComputerID = id
    }
    print("")

    local response = http.post("http://purplepenguin.ddns.net:8500/cct/verify", textutils.serializeJSON(ServerContent))
    local worked = response.readAll()
    if (worked == "true") then
        term.setTextColor(colors.lime)
        print("Registrierung des Computers Erfolgreich!")
        os.sleep(1)
        Config.SessionKey = tostring(tonumber(input) * tonumber(id))
        print(Config.SessionKey)
        local file = fs.open("saves/.config","w")
        file.write(Config)
        file.close()
        print(textutils.serialiseJSON(Config))
        os.sleep(4)

    else
        term.setTextColor(colors.red)
        print("Registrierung des Computers Fehlgeschladen!")
        print("Bitte probiere es in ein paar Minuen noch mal")
        --fs.delete("saves")
        os.sleep(3)
        os.reboot()
    end
    print("")
end
term.setTextColor(colors.lightBlue)
print("Aktualisierun der Nutzerdaten")
local response = http.get("http://purplepenguin.ddns.net:8500/cct/info/"..Config.SessionKey.."/")
local content = response.readAll()
if (content=="USER DOESNT EXIST!") then
    --Config.SessionKey=nil
    term.setTextColor(colors.red)
    print("Benutzer Existiert nicht - Wurde er gelöscht?")
    os.sleep(5)
    --fs.delete("saves")
    os.reboot()
end

content=json.decode(content)
if  not (content.username==nil) then
    local deviceName = "Computer"
    if (IsTablet) then
        deviceName = "Tablet"
    end
    os.setComputerLabel(deviceName.." von "..content.username)
end


local file = fs.open("saves/.config","w")
Config.UserName=content.username
Config.Rank=content.rank
Config.Money=Money
Config.IsTablat = IsTablat
file.write(Config)
file.close()

local width, height = term.getSize()
term.clear()
paintutils.drawFilledBox(0, 0, width, height, colors.blue)


--Coords
while (true) do
local Cords = {
    
    SessionKey=Config.SessionKey,
    x = x, 
    y = y,
    z = z
}
local response = http.post("http://purplepenguin.ddns.net:8500/cct/cords", textutils.serializeJSON(Cords))
os.sleep(0.5)
end
