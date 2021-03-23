os.loadAPI("json")
local response = http.get("https://www.thisworddoesnotexist.com/api/random_word.json")
local packet = response.readAll()
local printer = peripheral.wrap("left")
local word = ""
local definition = ""
content=json.decode(packet)


local function splitByChunk(text, chunkSize)
    local s = {}
    for i=1, #text, chunkSize do
        s[#s+1] = text:sub(i,i+chunkSize - 1)
    end
    return s
end

if  not (content.word==nil) then
    word = content.word.word
    definition = content.word.definition
    example = content.word.example
    length=definition:len()
    local pos=1
    
    local suc = printer.newPage()
    if(suc) then
        printer.setPageTitle(word)
        printer.setCursorPos(1, pos)
        pos = pos+1
        printer.write("WORD : ")
        printer.setCursorPos(1, pos)
        pos = pos+1
        printer.write(word)
        printer.setCursorPos(1, pos)
        pos = pos+1
        printer.write("DEFINITION : ")
        printer.setCursorPos(1, pos)
        pos = pos+1
        local Stings = splitByChunk(definition,24)
        for i,v in ipairs(Stings) do
            printer.write(v)
            printer.setCursorPos(1, pos)
            pos = pos+1  
        end
        printer.setCursorPos(1, pos)
            pos = pos+1  
        printer.write("EXAMPLE : ")
        printer.setCursorPos(1, pos)
            pos = pos+1  
        local Stings = splitByChunk(example,24)
        for i,v in ipairs(Stings) do
            printer.write(v)
            printer.setCursorPos(1, pos)
            pos = pos+1  
        end
        printer.endPage()
    end
end