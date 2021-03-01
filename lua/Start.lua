local x, y, z = gps.locate(5)
local Internet = false
local SessionKey = nil
local id = os.getComputerID()
local IsTablet=false
local configIns
os.loadAPI("json")

    request = http.get("https://raw.githubusercontent.com/LichtMarv/Britannia/master/lua/Installer.lua")
    data = request.readAll()

    if fs.exists("Installer") then
        fs.delete("Installer")
    end
    file = fs.open("Installer", "w")
    file.write(data)
    file.close()
 

if (fs.exists("saves")) then
    local file = fs.open("saves/config", "r") -- Open the file we used before, ready for reading.
    local fileData = {} -- Declare a table to use to hold data.s
    local line = file.readLine() -- This function reads the next line in the file, until the end.
    repeat -- Start a loop which will read lines into a table until no lines are left.
        table.insert(fileData, line) -- Puts the value of the current line into the table we have.
        line = file.readLine() -- read the next line
    until line == nil -- readLine() returns nil when the end of the file is reached.
    file.close() -- Close up the file ready for use again.
    config = fileData
    SessionKey = fileData[1]
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

if not SessionKey then
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

        SessionKey = tonumber(input) * tonumber(id)
        SessionKey= tostring(SessionKey)
        local file = fs.open("saves/config","a") -- This opens the file "config" in the folder "saves" for appending.
        file.writeLine(SessionKey) -- Put the Sessionkey in the file.
        file.close() -- Allows the file to be opened again by something else, and stops any corruption.

    else
        term.setTextColor(colors.red)
        print("Registrierung des Computers Fehlgeschladen!")
        print("Bitte probiere es in ein paar Minuen noch mal")
        fs.delete("saves")
        os.reboot()
    end
    print("")
end
term.setTextColor(colors.lightBlue)
print("Aktualisierun der Nutzerdaten")
local response = http.get("http://purplepenguin.ddns.net:8500/cct/info/"..SessionKey.."/")
local content = response.readAll()
print(content)
if (content=="USER DOESNT EXIST! Was the user deleted?") then
    SessionKey=nil
    os.sleep(5)
    fs.delete("saves")
    os.reboot()
end
content=json.decode(content)
if  not (content.username==nil) then
    os.setComputerLabel("Computer von "..content.username)
end
term.clear()
term.setBackgroundColor(colours.blue)
term.setCursorPos(1,1)
term.setTextColor(colors.white)
print("Setup Done!")

--Coords
while (true) do
local Cords = {
    
    SessionKey=SessionKey,
    x = x, 
    y = y,
    z = z
}
local response = http.post("http://purplepenguin.ddns.net:8500/cct/cords", textutils.serializeJSON(Cords))
os.sleep(0.5)
end
