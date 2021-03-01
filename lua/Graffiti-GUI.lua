-- Author: Encreedem
-- Link: http://www.computercraft.info/forums2/index.php?/topic/13944-161-graffiti-the-first-ide-for-guis/

-- Notes to myself: Fix this until the 1.7 update!
-- Well... at least I tried.
-- TODO: Bug: ScrollView doesn't get updated immediately when its content changes.
-- TODO: Clean up all the code below this comment.

local version = "1.7.2"

-- Used to save temporary data of objects.
ObjectData = {
  Input = {};
  List = {};
  FileSelector = {};
  Button = {};
  CheckBox = {};
  RadioButton = {};
  Slider = {};
  DropDownList = {};
}

UserData = {}

--Monitor
local monitor = nil

-- Colors
local ObjectColors = {}

-- Color Themes
local ColorThemes = {}
ColorThemes.Default = { -- Used colors: As many as I could get. (black background)
  background = colors.black;
  text = colors.white;
  disabled = colors.lightGray;
  disabledText = colors.black;
  Button = { default = colors.red; active = colors.lime; text = colors.white };
  ProgressBar = { low = colors.red; medium = colors.yellow; high = colors.lime; background = colors.gray; };
  Input = { default = colors.gray; text = colors.white; active = colors.lightBlue; };
  List = { default = colors.gray; active = colors.lightBlue; };
  FileSelector = { default = colors.red; text = colors.white; dir = colors.lime; file = colors.white; active = colors.lime; };
  CheckBox = { default = colors.white; active = colors.green; };
  RadioButton = { default = colors.white; active = colors.lime };
  Slider = { default = colors.orange; text = colors.black; active = colors.white; activeText = colors.black };
  DropDownList = { default = colors.gray; text = colors.white; active = colors.lightGray; };
  DefaultButtons = {
    default = colors.red;
    text = colors.white;
    Quit = {
      default = colors.red;
      text = colors.white;
    };
  };
  Editor = {
    new = colors.white;
    active = colors.lime;
    move = colors.magenta;
    scale = colors.pink;
    marker = colors.gray;
    textInputMarker = colors.yellow;
    editMarker = colors.lime;
    alignmentTrue = colors.lime;
    alignmentFalse = colors.red;
    selector1 = colors.gray;
    selector2 = colors.lightGray;
    selectorText = colors.white;
  };
  Container = {
    Panel = {
      border = colors.white;
    };
    ScrollView = {
      border = colors.white;
      scrollBackground = colors.lightGray;
      scrollForeground = colors.gray;
    };
  };
}

ColorThemes["Windows CC"] = { -- Used colors: none, just white, lightGray, gray and black... (white background)
  background = colors.white;
  text = colors.black;
  disabled = colors.gray;
  disabledText = colors.white;
  Button = { default = colors.lightGray; active = colors.lightBlue; text = colors.black };
  ProgressBar = { low = colors.lime; medium = colors.lime; high = colors.lime; background = colors.lightGray; };
  Input = { default = colors.lightGray; text = colors.black; active = colors.white; };
  List = { default = colors.lightGray; active = colors.lightBlue; };
  FileSelector = { default = colors.gray; text = colors.black; dir = colors.blue; file = colors.black; active = colors.lightBlue; };
  CheckBox = { default = colors.gray; active = colors.lightBlue; };
  RadioButton = { default = colors.gray; active = colors.lightBlue; };
  Slider = { default = colors.gray; text = colors.black; active = colors.white; activeText = colors.black };
  DropDownList = { default = colors.gray; text = colors.white; active = colors.lightBlue; };
  DefaultButtons = {
    default = colors.lightGray;
    text = colors.black;
    Quit = {
      default = colors.red;
      text = colors.white;
    };
  };
  Editor = {
    new = colors.lightBlue;
    active = colors.black;
    move = colors.magenta;
    scale = colors.pink;
    marker = colors.gray;
    textInputMarker = colors.black;
    editMarker = colors.lightBlue;
    alignmentTrue = colors.lime;
    alignmentFalse = colors.red;
    selector1 = colors.gray;
    selector2 = colors.lightGray;
    selectorText = colors.white;
  };
  Container = {
    Panel = {
      border = colors.lightGray;
    };
    ScrollView = {
      border = colors.lightGray;
      scrollBackground = colors.lightGray;
      scrollForeground = colors.gray;
    };
  };
}

ColorThemes.Fire = { -- Used colors: red, orange, yellow, lightGray, gray background
  background = colors.gray;
  text = colors.black;
  disabled = colors.black;
  disabledText = colors.white;
  Button = { default = colors.orange; active = colors.red; text = colors.black };
  ProgressBar = { low = colors.yellow; medium = colors.orange; high = colors.red; background = colors.lightGray; };
  Input = { default = colors.yellow; text = colors.black; active = colors.orange; };
  List = { default = colors.orange; active = colors.red; };
  FileSelector = { default = colors.orange; text = colors.black; dir = colors.lime; file = colors.white; active = colors.lime; };
  CheckBox = { default = colors.white; active = colors.red; };
  RadioButton = { default = colors.white; active = colors.red };
  Slider = { default = colors.orange; text = colors.black; active = colors.red; activeText = colors.black };
  DropDownList = { default = colors.orange; text = colors.black; active = colors.red; };
  DefaultButtons = {
    default = colors.orange;
    text = colors.black;
    Quit = {
      default = colors.red;
      text = colors.white;
    };
  };
  Editor = {
    new = colors.lightBlue;
    active = colors.white;
    move = colors.blue;
    scale = colors.lightBlue;
    marker = colors.lightGray;
    textInputMarker = colors.orange;
    editMarker = colors.red;
    alignmentTrue = colors.lime;
    alignmentFalse = colors.red;
    selector1 = colors.gray;
    selector2 = colors.lightGray;
    selectorText = colors.white;
  };
  Container = {
    Panel = {
      border = colors.lightGray;
    };
    ScrollView = {
      border = colors.lightGray;
      scrollBackground = colors.lightGray;
      scrollForeground = colors.yellow;
    };
  };
}

ObjectColors = ColorThemes.Default

-- Languages
local Languages = {
  ["en-US"] = {
    back = " < ";
    cancel = "Cancel";
    colorTheme = "Color Theme";
    done = "Done";
    editEntries = "Edit Entries";
    finish = "Finish";
    finished = "Done";
    language = "Language";
    lastWindow = "Last Window";
    moveDown = "Move Down";
    moveUp = "Move Up";
    newEntry = "New Entry";
    next = "Next";
    ok = "OK";
    options = "Options";
    quit = " X ";
    refresh = "Refresh";
    remove = "Remove";
    
    setupText1 = "It seems like you've started Graffiti for";
    setupText2 = "the first time on this computer.";
    setupText3 = "This setup will create all neccessary data that";
    setupText4 = "Graffiti needs to run and it allows you to set";
    setupText5 = "specific settings.";
    
    skipSetup = "Skip setup (use default settings)";
    chooseSettings1 = "Please specify these settings:";
    chooseSettings2 = "(You can change them later if you want)";
    showDataFolder = "Show Data folder";
    hideDataFolder = "Hide Data folder";
  };

  ["de-DE"] = {
    back = " < ";
    cancel = "Abbrechen";
    colorTheme = "Farbschema";
    done = "Fertig";
    editEntries = "Bearbeite Eingaben";
    finish = "Fertig";
    finished = "Fertig";
    language = "Sprache";
    lastWindow = "Letztes Fenster";
    moveDown = "Runter";
    moveUp = "Hoch";
    newEntry = "Neuer Eintrag";
    next = "Nächstes";
    ok = "OK";
    options = "Optionen";
    quit = " X ";
    refresh = "Neu Laden";
    remove = "Entfernen";
    
    setupText1 = "Es scheint, als hätten Sie Graffiti für";
    setupText2 = "das erste Mal auf diesem Computer.";
    setupText3 = "Dieses Setup erzeugt alle notwendigen Daten, die";
    setupText4 = "Graffiti braucht um zu laufen, und spezifische";
    setupText5 = "Einstellungen zu setzen.";
    
    skipSetup = "Überspringe die Einrichtung (-> Standard Einstellungen)";
    chooseSettings1 = "Please specify these settings:";
    chooseSettings2 = "(You can change them later if you want)";
    showDataFolder = "Zeige den Data Ordner";
    hideDataFolder = "Verstecke den Data Ordner";
  };

}

local Text = Languages["de-DE"]

-- Sizes
local maxX, maxY = 51, 19
local Size = {
  Button = { width = 10; height = 3; };
  ProgressBar = { length = 10; };
  Slider = { length = 10; };
  DropDownList = { width=10 };
  Container = { width = 20; height = 10; };
}

-- Files Info
local root = "/" -- The path where the data-folder will be created by default.
local dataFolderPath = nil
local LoadedFiles = {}
local currentProject = "Default"

-- Converter
local Converter = {}

-- API
local initDone = false
local isAPI = false -- Determines whether the program has been loaded as an API
local VariableValues = {}
local ProgressBarValues = {}

-- Editor
local currentEditorAction = nil
local editMode = false
local lastWindow = nil
local RightClickActions = {"Attributes", "Delete" }
local saveAfterQuit = true
local selectedObject = nil
local selectedObjectDragged = false

-- Custom Windows
local showCustomWindow = nil
local ListEditorList = {}
local CustomWindows = {}
local CustomFunctions = {}

-- Tables
local Args = { ... }
local Sides = rs.getSides()
local ObjectTypes = { "Button", "Text", "Variable", "ProgressBar", "Input", "List", "CheckBox", "RadioButton", "Slider", "DropDownList", "Panel", "ScrollView" }
local EventTypes = { "quit", "button_clicked", "button_toggled", "selection_changed", "text_changed", "checked", "radio_changed", "slider_changed" }
Objects = {}
Windows = { Children = {} }
local WindowBuffer = nil
local DefaultButtons = {}
local Shortcuts = {}

-- Other
local quit = false
local doLog = true -- Determines wheter a log file should be created or not.
local logFileLoaded = false
local out = term -- Output: either "term" or the monitor
local outIsTerm = false
local changeButtonColor = true
local currentWindow = "Main"

-- Settings
local Settings = {
  root = root;
  startupProject = currentProject;
  language = "en-US";
  colorTheme = "Default";
  hideDataFolder = false;
}

-- >> User Data: (This section is just for YOU! :D)

--[[ How to make your own functions:
Normal "button_clicked" or "button_toggled" function:
Note: toggleState is only needed if the buttons'
funcType-attribute is set to "toggle function"

function UserData.<objID>(toggleState)
  your code here
end

If you don't want to edit this file then you can
just load it as an API via "os.loadapi(Graffiti)"
and use "Graffiti.pullEvent()".
]]

function UserData.test()
  sleep(1)
end

function UserData.refresh()
  drawWindow()
end

function UserData.toggleTest(toggleState)
  rs.setOutput("front", toggleState)
end

--[[ "Load" function
You can specify a string in the "load" attribute
of some objects.
The function in the "UserData" folder gets called
every time the object gets drawn.
]]
function UserData.getRandomNumber()
  return math.random(100)
end

function UserData.getTime()
  return textutils.formatTime(os.time(), true)
end

--[[ WARNING!
Everything below this comment
shouldn't be edited!
If you do so and the program doesn't work anymore
then it's your fault!
]]

--[[ Displays the text, the content of a table
or a star in the upper left corner until you press
a key.]]
function dBug(text)
  out.setCursorPos(1, 1)
  
  if (text == nil) then
    out.write("*")
    getKeyInput()
    out.setCursorPos(1, 1)
    out.write(" ")
    return
  elseif (type(text) == "table") then
    for key, value in pairs(text) do
      print(key .. ": " .. tostring(value))
    end
  else
    out.write(text)
  end
  
  getKeyInput()
end

-- >> Type extensions

function string:startsWith(text)
  assert(self)
  assert(text)
  
  local substring = text:sub(1, #text)
  return (substring == text)
end

function string:endsWith(text)
  assert(self)
  assert(text)
  
  local sStart, sEnd = string.find(self, text, (#text * -1))
  return (sStart ~= nil)
end

-- Checks whether the table contains the given content-parameter.
function table:contains(content)
  if (self and type(self) == "table") then
    for _, value in pairs(self) do
      if (value == content) then
        return true
      end
    end
    
    return false
  else
    return false
  end
end

-- >> Files
local Files = {}

-- Returns whether the filename ends with the
-- given extension.
function Files.endsWith(filename, extension)
  assert(filename)
  assert(extension)
  
  local sStart, sEnd = string.find(filename, extension, (#extension * -1))
  return (sStart ~= nil)
end

-- Serializes a normal or serialized table into a
-- readable format which can be saved in a file.
function Files.serialize(toSave)
  local saveText
  local serialized = ""
  local indentation = 0
  local indent = false
  
  if (type(toSave) == "string") then
    saveText = toSave
  elseif (type(toSave) == "table") then
    saveText = textutils.serialize(toSave)
  else
    error("Can't save variable of type .. " .. type(toSave) .. "!", 1)
  end
  
  for char in saveText:gmatch(".") do
    if (char == "{") then
      indentation = indentation + 1
      
      serialized = serialized .. char
      serialized = serialized .. "\n"
      indent = true
    elseif (char == ",") then
      serialized = serialized .. char .. "\n"
      indent = true
    elseif (char == "}") then
      indentation = indentation - 1
      serialized = serialized .. string.rep("\t", indentation)
      serialized = serialized .. char
      indent = true
    else
      if indent then
        serialized = serialized .. string.rep("\t", indentation)
        indent = false
      end
      
      serialized = serialized .. char
    end
  end
  
  serialized = serialized:gsub(" ", "<SPACE>")
  return serialized
end

-- Unserializes a string that has been serialized
-- using the "Files.serialize" function into a
-- table.
function Files.unserialize(str)
  local saveText = str
  saveText = saveText:gsub("\n", "")
  saveText = saveText:gsub("\t", "")
  saveText = saveText:gsub(" ", "")
  saveText = saveText:gsub("<SPACE>", " ")
  saveText = textutils.unserialize(saveText)
  
  return saveText
end

-- Initializes the Graffiti data folder.
function Files.init()
  if (fs.exists(fs.combine(root, ".GraffitiData"))) then
    dataFolderPath = fs.combine(root, ".GraffitiData")
  elseif (fs.exists(fs.combine(root, "GraffitiData"))) then
    dataFolderPath = fs.combine(root, "GraffitiData")
  else
    runSetup()
  end
  
  for key, value in pairs(Files) do
    if (type(value) == "table") then -- If it's an actual file type instead of a function.
      if (value.autoLoad and value.load) then
        Files.load(key)
      end
    end
  end
end

-- Saves all files with enabled "autoSave"
-- attribute.
function Files.save()
  for _, file in pairs(Files) do
    if (type(file) == "table") then -- If it's an actual file type instead of a function.
      if (file.autoSave and file.save) then
        file.save()
      end
    end
  end
end

-- Loads the file and all of its required files.
function Files.load(fileType)
  if not table.contains(LoadedFiles, fileType) then
    local loadRequired = Files[fileType].loadRequired
    
    if (loadRequired) then
      for _, value in pairs(loadRequired) do
        Files.load(value)
      end
    end
    
    Files[fileType].load()
    table.insert(LoadedFiles, fileType)
  end
end

-- Saves the table into a file in Graffitis' default format.
function Files.saveTable(subDir, fileName, tbl)
  local fileHandle = Files.createDataFile(subDir, fileName, "w")
  
  for key, value in pairs(tbl) do
    fileHandle.writeLine(key .. "=" .. tostring(value))
  end
  
  if fileHandle then
    fileHandle.close()
  end
end

function Files.loadTable(subDir, fileName)
  local fileHandle = Files.getDataFileHandle(subDir, fileName, "r", false)
  local ret = {}
  
  if not fileHandle then
    log("Can't get file handle of file \"" .. fileName .. "\"! Returning nil.", "WARNING")
    return nil
  end
  
  repeat
    local line = fileHandle.readLine()
    
    if (line ~= nil and line ~= "" and string.find(line, "=")) then
      local key, value = splitAt(line, "=")
      ret[key] = value
    end
  until line == nil
  
  if fileHandle then
    fileHandle.close()
  end
  
  return ret
end

-- Removes the content of a file.
function Files.clear(subDir, fileName)
  local fileHandle = Files.getDataFileHandle(subDir, fileName, "w", false)
  
  if fileHandle then
    fileHandle.close()
  end
end

-- Returns the path to the sub-directory and
-- creates the folders if necessary.
function Files.getSubDirPath(subDir)
  assert(subDir)
  
  local subDirPath = dataFolderPath
  
  for _, dir in pairs(subDir) do
    subDirPath = fs.combine(subDirPath, dir)
  
    if (fs.exists(subDirPath)) then
      if (not fs.isDir(subDirPath)) then
        error("Can't create directory " .. dir .. "! A file with that name exists!", 2)
      end
    else
      fs.makeDir(subDirPath)
    end
  end
  
  return subDirPath
end

-- Returns the handle of an existing file or null.
-- The file will automatically be created if
-- autoCreate is true.
function Files.getDataFileHandle(subDir, filename, mode, autoCreate)
  assert(filename)
  assert(mode)
  
  local ret
  local path
  
  -- Create the path to the file if it doesn't exist.
  if subDir then
    local subDirPath
    
    if (type(subDir) == "string" and subDir ~= "") then
      subDirPath = fs.combine(dataFolderPath, subDir)
      path = fs.combine(subDirPath, filename)
      
      if (fs.exists(subDirPath)) then
        if (not fs.isDir(subDirPath)) then
          error("Can't create directory " .. subDir .. "! A file with that name exists!", 2)
        end
      else
        fs.makeDir(subDirPath)
      end
    elseif (type(subDir) == "table") then
      local subDirPath = Files.getSubDirPath(subDir)
      path = fs.combine(subDirPath, filename)
    end
  else
    path = fs.combine(dataFolderPath, filename)
  end
  
  if (fs.exists(path) and fs.isReadOnly(path)) then
    error("File " .. filePath .. " is readonly!", 2)
  end
  
  if (fs.exists(path) or mode == "w") then
    ret = fs.open(path, mode)
  elseif autoCreate then
    ret = fs.open(path, "w") or error("Can't open file " .. path, 2)
  end
  
  return ret
end

-- Creates or overrides a file and returns its handle.
function Files.createDataFile(subDir, filename)
  return Files.getDataFileHandle(subDir, filename, "w")
end

-- Renames the file to the "newName"-parameter.
-- Note to myself: Don't copy the "get the subDir"-part from this one.
function Files.rename(subDir, filename, newName)
  assert(subDir)
  assert(filename)
  assert(newName)
  
  local folderPath
  local filePath
  
  if subDir then
    local subDirPath
    
    if (type(subDir) == "string" and subDir ~= "") then
      subDirPath = fs.combine(dataFolderPath, subDir)
      folderPath = subDirPath
      filePath = fs.combine(subDirPath, filename)
      
      if (fs.exists(subDirPath)) then
        if (not fs.isDir(subDirPath)) then
          error("Can't access directory " .. subDir .. "! A file with that name exists!", 2)
        end
      else
        return
      end
    elseif (type(subDir) == "table") then
      folderPath = Files.getSubDirPath(subDir)
      filePath = fs.combine(folderPath, filename)
    end
  else
    folderPath = dataFolderPath
    filePath = fs.combine(dataFolderPath, filename)
  end
  
  fs.move(filePath, fs.combine(folderPath, newName))
  
  log("Renamed window \"" .. filename .. "\" to \"" .. newName .. "\".")
end

-- Removes the file.
-- NOTE: The path accessing is slightly different.
function Files.remove(subDir, filename)
  local path
  
  if subDir then
    local subDirPath
    
    if (type(subDir) == "string" and subDir ~= "") then
      subDirPath = fs.combine(dataFolderPath, subDir)
      path = fs.combine(subDirPath, filename)
      
      if (fs.exists(subDirPath)) then
        if (not fs.isDir(subDirPath)) then
          error("Can't access directory " .. subDir .. "! A file with that name exists!", 2)
        end
      else
        return
      end
    elseif (type(subDir) == "table") then
      local subDirPath = Files.getSubDirPath(subDir)
      path = fs.combine(subDirPath, filename)
    end
  else
    path = fs.combine(dataFolderPath, filename)
  end
  
  fs.delete(path)
  
  log("Deleted window \"" .. path .. "\".")
end

-- >> Version File
Files.Version = {
  autoSave = true;
  autoLoad = true;
  subDir = nil;
  loadRequired = { "Project" };
  name = "version"
}

function Files.Version.save()
  local fileHandle = Files.getDataFileHandle(Files.Version.subDir, Files.Version.name, "w")
  
  if fileHandle then
    fileHandle.writeLine(version)
    fileHandle.close()
  end
end

function Files.Version.load()
  local fileHandle = Files.getDataFileHandle(Files.Version.subDir, Files.Version.name, "r", false)
  
  if fileHandle then
    local fileVersion = fileHandle.readLine()
    
    if (fileVersion ~= version) then
      Converter.run(fileVersion)
    end
    
    fileHandle.close()
  else
    Converter.run()
  end
end

-- >> Project File

Files.Project = {
  autoSave = true;
  autoLoad = true;
  subDir = "Projects"; -- Has to be a string.
  loadRequired = { "Settings" };
  extension = ".window";
}

-- Saves the content of the Windows-table into the
-- save file.
function Files.Project.save()
  for name, window in pairs(Windows.Children) do
    if (type(window) == "table") then
      local saveString = Files.serialize(window)
      local fileHandle = Files.createDataFile({ Files.Project.subDir, currentProject }, name .. Files.Project.extension )
      
      fileHandle.write(saveString)
      fileHandle.close()
    end
  end
end

-- Loads the save file and puts the content into
-- the Windows-table
function Files.Project.load()
  local path = fs.combine(dataFolderPath, Files.Project.subDir)
  path = fs.combine(path, currentProject)
  
  if not path or not fs.isDir(path) then
    return
  end
  
  for _, filename in pairs(fs.list(path)) do
    local filePath = fs.combine(path, filename)
    local windowName = string.sub(filename, 1, #filename - #Files.Project.extension)
    
    if (not fs.isDir(filePath) and Files.endsWith(filename, Files.Project.extension)) then
      local fileHandle = Files.getDataFileHandle({ Files.Project.subDir, currentProject }, filename, "r", false)
      
      if fileHandle then
        local loadString = fileHandle.readAll()
        loadString = Files.unserialize(loadString)
        
        if (loadString ~= nil and loadString ~= "") then
          Windows.Children[windowName] = loadString
        end
        
        fileHandle.close()
      end
    end
  end
end

-- >> Settings File

Files.Settings = {
  autoSave = true;
  autoLoad = true;
  subDir = nil;
  name = "Graffiti.cfg";
}

function Files.Settings.init()
  if not Settings then
    return
  end
  
  for key, value in pairs(Settings) do
    if (key == "startupProject") then
      currentProject = value
    elseif (key == "language") then
      Settings.language = value
    elseif (key == "colorTheme" and ColorThemes[value]) then
      ObjectColors = ColorThemes[value]
    end
  end
end

-- Creates the settings file in the data-folder and fills it with default values.
function Files.Settings.save()
  Files.saveTable(Files.Settings.subDir, Files.Settings.name, Settings)
end

-- Loads the settings file.
function Files.Settings.load()
  local tbl = Files.loadTable(Files.Settings.subDir, Files.Settings.name)
  
  if tbl then
    for key, value in pairs(tbl) do
      Settings[key] = value
    end
  end
  
  Files.Settings.init()
end

-- >> Language File

function loadLanguage(language)
  assert(language)
  
  if not Languages[language] then
    --log("Tried to load non-existent language " .. tostring(language) .. ".", "WARNING")
    return
  end
  
  for key, value in pairs(Languages[language]) do
    Text[key] = value
  end
  
  --log("Loaded language \"" .. language .. "\".")
end

Files.Language = {
  autoSave = true;
  autoLoad = true;
  subDir = "Language";
  extension = ".lang";
  loadRequired = { "Settings" };
}

function Files.Language.save()
  local fileName = "Graffiti." .. Settings.language .. Files.Language.extension
  Files.saveTable(Files.Language.subDir, fileName, Text)
end

function Files.Language.load()
  local path = fs.combine(dataFolderPath, Files.Language.subDir)
  
  if fs.exists(path) and fs.isDir(path) then
    for _, filename in pairs(fs.list(path)) do
      local fullPath = fs.combine(path, filename)
      
      if not (fs.isDir(fullPath) and
          filename:startsWith("Graffiti.") and
          filename:endsWith(".lang")) then
        -- Gets the part between "Graffiti." and ".lang"
        -- e.g. "Graffiti.en-US.lang" -> "en-US"
        local languageDesc = filename:match("%.(.+)%.")
        local languageTable = Files.loadTable(Files.Language.subDir, filename)
        
        Languages[languageDesc] = languageTable
      end
    end
  end
  
  loadLanguage(Settings.language)
end

-- >> Log File
Files.Log = {
  autoSave = false;
  autoLoad = false;
  subDir = "Log";
  name = "Graffiti.log";
}

-- Writes the text into a logfile.
function log(text, logType)
  if not doLog or not logFileLoaded then
    return
  end
  
  local logFileHandle = Files.getDataFileHandle(Files.Log.subDir, Files.Log.name, "a", true)
  
  if (type(text) == "table") then
    local delimiter = ""
    
    logFileHandle.write((logType or "INFO") .. ": ")
    
    for key, value in pairs(text) do
      logFileHandle.write(delimiter .. key .. "=" .. tostring(value))
      delimiter = ", "
    end
    
    logFileHandle.writeLine()
  else
    logFileHandle.writeLine((logType or "INFO") .. ": " .. tostring(text))
  end
  
  logFileHandle.close()
end

-- >> Converter

function Converter.updateObject(from, to, object)
  if object.isContainer or object.children or object.Children then
    Converter.updateContainer(from, to, object)
  else
    -- Object conversion goes here.
  end
end

function Converter.updateContainer(from, to, container)
  if container.children then -- v1.7: The "children" attribute has been renamed to "Children"
    container.Children = container.children
    container.children = nil
  end
  
  for objectKey, object in pairs(container.Children) do
    Converter.updateObject(from, to, object)
  end
end

-- Checks all variables and tables for data from
-- earlier versions which could make it
-- incompatible with the newest version and
-- updates those if possible.
function Converter.run(oldVersion)
  log("Running converter...")
  log("Old version: " .. tostring(oldVersion) .. ".", "ATTR")
  log("New version: " .. tostring(version) .. ".", "ATTR")
  
  Converter.updateContainer(oldVersion, version, Windows)
end

-- >>> Shortcut functions (for key inputs)
-- Not yet implemented! WIP!
-- TODO: Fix bug where the key event won't disappear from the queue.

function callShortcut(key)
  --[[if (key and Shortcuts[key]) then
    Shortcuts[key]()
  end]]
end

-- S
Shortcuts[31] = function()
  out.clear()
  out.setCursorPos(1, 1)
  print("Saving windows...")
  
  Files.Project.save()
  
  print("Windows saved!")
  print("Press any key to continue...")
end

-- Q
Shortcuts[16] = function()
  quit = true
end

-- >>> Object helper functions

function clearScreen()
  out.setBackgroundColor(ObjectColors.background)
  out.setTextColor(ObjectColors.text)
  out.clear()
  out.setCursorPos(1, 1)
end

-- Returns whether the button with the given name
-- has been pressed.
function defaultButtonPressed(name, x, y)
  assert(name)
  assert(x)
  assert(y)
  
  local window = getCurrentWindow()
  
  if (DefaultButtons[name]) then
    local button = DefaultButtons[name]
    if (x >= button.left and x <= button.right and y >= button.top and y <= button.bottom) then
      return (button.required() or (editMode and not showCustomWindow))
    end
  else
    return false
  end
end

-- Returns the table containing the windows that
-- should be displayed.
function getWindowContainer()
  if showCustomWindow then
    return CustomWindows[showCustomWindow]
  else
    return Windows
  end
end

-- Returns the window object that is currently
-- displayed.
function getCurrentWindow()
  local windowContainer = getWindowContainer()
  
  return windowContainer.Children[currentWindow]
end

-- Used by the List and Selector objects to
-- determine how wide the list should be.
function getLongestString(strings)
  if (strings == nil or #strings == 0) then
    return 0
  end
  
  local ret = 0
  for key, value in pairs(strings) do
    length = string.len(value)
    if (length > ret) then
      ret = length
    end
  end
  
  return ret
end

-- Checks whether dir is a valid direction-string.
function isValidDirection(dir)
  if (dir ~= nil and
     (dir == "left" or 
      dir == "up" or 
      dir == "right" or 
      dir == "down")) then
    return true
  end
  
  return false
end

--[[ Returns a table containing tables for all
files and directories in the given path:
Returns: fileName, filePath, isDir
]]
function getFileList(path)
  local ret = {}
  local dirList = {}
  local fileList = {}
  
  for file in fs.list(path) do
    if (fs.isDir(file)) then
      table.insert(dirList, dirIndex, file)
      dirIndex = dirIndex + 1
    else
      table.insert(fileList, fileIndex, file)
      fileIndex = fileIndex + 1
    end
  end
  for _, file in ipairs(dirList) do
    table.insert(list, {fileName=file, filePath=fs.combine(path, file), isDir=true})
  end
  for _, file in ipairs(fileList) do
    table.insert(list, {fileName=file, filePath=fs.combine(path, file), isDir=false})
  end
  
  return ret
end

-- Returns "horizontal" or "vertical" depending on
-- the given direction.
function getOrientation(direction)
  local orientation = nil

  if (direction == "left" or direction == "right") then
    orientation = "horizontal"
  elseif (direction == "up" or direction == "down") then
    orientation = "vertical"
  end

  return orientation
end

-- Checks whether the eventTypes table contains
-- the given event type.
function eventTypeExists(eventType)
  if (eventType == nil) then
    return true
  end
  
  for _, event in pairs(EventTypes) do
    if (event == eventType) then
      return true
    end
  end
  
  return false
end

-- Returns the size that a buffer needs to have
-- to contain all children of a container.
function getNecessaryBufferSize(Children, minWidth, minHeight)
  local width, height = (minWidth or 0), (minHeight or 0)
  
  for _, child in pairs(Children) do
    local right = child.width and child.x + child.width or child.x
    local bottom = child.height and child.y + child.height or child.y
    
    width = (right > width) and right or width
    height = (bottom > height) and bottom or height
  end
  
  return width, height
end

-- Returns a table containing the position and
-- size that the scroll bar of a ScrollView object
-- should have.
function getScrollBarInfo(pos, containerSize, bufferSize)
  local ret = {}
  local maxScrollBarHeight = containerSize - 4
  
  local scrollCount = bufferSize - containerSize + 1 -- How often can the user scroll?
  if (scrollCount < 0) then
    scrollCount = 0
  end
  
  local scrollBarSize = math.ceil(maxScrollBarHeight * (1 / (scrollCount + 1)))
  local scrollBarPos
  if (scrollCount == 0) then
    scrollBarPos = 0
  --elseif (pos == scrollCount) then
    --scrollBarPos = maxScrollBarHeight - scrollBarSize
  else
    scrollBarPos = math.floor((maxScrollBarHeight / (scrollCount + 1)) * pos)
  end
  
  ret.size = scrollBarSize
  ret.pos = scrollBarPos
  
  return ret
end

-- >>> Path

Path = {}

-- Returns the container which is at the paths
-- nest level.
function Path:getContainerAt(nestLevel)
  local container = getCurrentWindow()
  
  for i = 1, nestLevel do
    if (container.Children[self[i]] and container.Children[self[i]].isContainer) then
      container = container.Children[self[i]]
    else
      return nil -- NOTE: was "break" before
    end
  end
  
  return container
end

-- Returns the object which is represented by the
-- path.
function Path:getObject()
  local container = Path.getContainerAt(self, #self - 1)
  return container.Children[self[#self]]
end

-- Returns the coordinates which are relative to
-- the last container represented by the path.
function Path:getRelativePos(x, y, checkFullPath)
  --log("Path.getRelativePos", "FUNC")
  --log("x: " .. x .. ", y: " .. y .. ", checkFullPath: " .. tostring(checkFullPath) .. ".", "ATTR")
  
  local container
  local limit = checkFullPath and #self or #self - 1
  
  for i = 1, limit do
    container = Path.getContainerAt(self, i)
    
    if container then
      x, y = Objects.Container.getRelativePos(container, x, y)
    else
      break
    end
  end
  
  return x, y
end

--[[ Generates a table of keys representing the
nesting of the containers that have been clicked.
Returns: e.g. {containeID, subContainerID}]]
Path.getContainerPath = function(x, y)
  local containerPath = {}
  local currentContainer = getCurrentWindow()
  local finished = false
  local nestLevel = 1
  
  while not finished do
    finished = true -- Set to true so that the loop stops when no container is found.
    for objectID, object in pairs(currentContainer.Children) do
      if finished and object.isContainer then
        if (Objects.Container.contentAreaClicked(object, x, y)) then
          containerPath[nestLevel] = objectID
          currentContainer = currentContainer.Children[objectID]
          x, y = Objects.Container.getRelativePos(currentContainer, x, y)
          finished = false
        end
      end
    end
    
    nestLevel = nestLevel + 1
  end
  
  return containerPath
end

-- >>> Buffer

Buffer = {
  bufferTable = {};
  width = 0;
  height = 0;
}

function Buffer.newPixel(backCol, textCol, char, path)
  local ret = {}
  ret.background = backCol or ObjectColors.background
  ret.text = textCol or ObjectColors.text
  ret.char = (type(char) == "string" and char ~= "") and char or " "
  ret.path = path or nil
  if (backCol or textCol or char ~= " " or path) then
    ret.draw = true
  else
    ret.draw = false
  end
  
  return ret;
end

function Buffer:new(object)
  object = object or {}
  setmetatable(object, self)
  self.__index = self
  return object
end

function Buffer:init(width, height, path, backCol, textCol)
  self.width = width or error("Can't initialize buffer because the width didn't get specified!")
  self.height = height or error("Can't initialize buffer because the height didn't get specified!")
  self.bufferTable = {}
  
  for col = 1, width do
    self.bufferTable[col] = {}
    for row = 1, height do
      self.bufferTable[col][row] = self.newPixel(backCol, textCol, " ", path)
    end
  end
end

function Buffer:trim(left, top, right, bottom)
  left = (left < 0) and 0 or left
  top = (top < 0) and 0 or top
  right = (right < 0) and 0 or right
  bottom = (bottom < 0) and 0 or bottom
  
  local width = self.width - left - right
  local height = self.height - top - bottom
  local trimmed = Buffer:new()
  trimmed:init(width, height)
  
  for col = 1, width do
    for row = 1, height do
      trimmed:setPixel(col, row, self.bufferTable[left + col][top + row])
    end
  end
  
  return trimmed
end

function Buffer:draw(x, y)
  x = x or 1
  y = y or 1
  local currentPixel
  
  for col = 0, self.width - 1 do
    for row = 0, self.height - 1 do
      currentPixel = self.bufferTable[col+1][row+1]
      if (currentPixel.draw) then
        out.setCursorPos(x + col, y + row)
        out.setBackgroundColor(currentPixel.background)
        out.setTextColor(currentPixel.text)
        out.write(currentPixel.char)
        currentPixel.draw = false
      end
    end
  end
end

function Buffer:setBackgroundColor(color)
  for col = 1, width do
    for row = 1, height do
      self.bufferTable[col][row].background = color
    end
  end
end

function Buffer:setTextColor(color)
  for col = 1, width do
    for row = 1, height do
      self.bufferTable[col][row].text = color
    end
  end
end

function Buffer:setPixel(x, y, pixel)
  assert(x)
  assert(y)
  assert(pixel)
  
  if (x > 0 and x <= self.width and y > 0 and y <= self.height) then
    for key, value in pairs(pixel) do
      if value then
        self.bufferTable[x][y][key] = value
      end
    end
  end
end

function Buffer:addText(x, y, text)
  assert(x)
  assert(y)
  assert(text)
  
  for char in tostring(text):gmatch(".") do
    self:setPixel(x, y, { char=char })
    x = x + 1
  end
end

function Buffer:addBuffer(x, y, buffer)
  assert(x)
  assert(y)
  assert(buffer)
  for col = 1, buffer.width do
    for row = 1, buffer.height do
      self:setPixel(x + col - 1, y + row - 1, buffer.bufferTable[col][row])
    end
  end
end

-- Adds a border to the container buffer.
function Buffer:makeBorder(path, color)
  local width, height = self.width, self.height
  
  self:addBuffer(1, 1, Objects.Line.get("horizontal", width, color, path))
  self:addBuffer(1, height, Objects.Line.get("horizontal", width, color, path))
  self:addBuffer(1, 1, Objects.Line.get("vertical", height, color, path))
  self:addBuffer(width, 1, Objects.Line.get("vertical", height, color, path))
end

-- >>> Objects

-- Returns a new object with its default attributes
-- depending on the object type.
-- Note: Don't call this function, use Objects.create!
function Objects.new(objectType, x, y)
  assert(objectType)
  assert(x)
  assert(y)
  
  log("Creating new object. Type: " .. objectType .. ", position: " .. x .. ", " .. y .. ".", "INFO")
  
  local object = {}
  local path = Path.getContainerPath(x, y)
  local relativeX, relativeY = Path.getRelativePos(path, x, y, true)
  
  object.objID = "new" .. objectType
  object.objType = objectType
  object.path = path
  local modX, modY = Objects.getPosModifier(object, true)
  object.x = relativeX + (modX * -1)
  object.y = relativeY + (modY * -1)
  object.absoluteX = x + (modX * -1)
  object.absoluteY = y + (modY * -1)
  
  local maxWidth = maxX - x
  local maxHeight = maxY - y
  
  if (Objects[objectType] and Objects[objectType].new) then
    Objects[objectType].new(object, maxWidth, maxHeight)
  elseif (Objects.Container[objectType]) then
    Objects.Container.new(object, maxWidth, maxHeight)
  else
    Objects.Unknown.new(objectType)
  end
  
  return object
end

-- Creates a new object at the given position with
-- its default attributes.
function Objects.create(objType, x, y)
  local object = Objects.new(objType, x, y)
  local container = Path.getContainerAt(object.path, #object.path)
  local key = Objects.Container.getNextFreeKey(container)
  table.insert(object.path, key)
  table.insert(container.Children, key, object)
  
  if not showCustomWindow then
    WindowBuffer:addBuffer(x, y, Objects.get(object))
    Objects.draw(object)
  end
  
  return object
end

-- Creates the default object and changes the
-- specified attributes to the given ones.
function Objects.createCustom(objType, x, y, attributes)
  local object = Objects.create(objType, x, y)
  
  for key, value in pairs(attributes) do
    object[key] = value
  end
  
  return object
end

function Objects.init()
  log("Initializing Objects...", "INFO")
  
  for _, window in pairs(Windows.Children) do
    for _, object in pairs(window.Children) do
      if (type(object) == "table") then
        local objType = object.objType
        
        if (Objects[objType] and Objects[objType].init) then
          log("Initializting " .. objType .. " " .. object.objID .. ".", "INFO")
          Objects[objType].init(object)
        elseif (object.isContainer) then
          Objects.Container.init(object)
        end
      end
    end
  end
end

-- Returns the x and y values which should be
-- added to an objects' position to match the
-- modifications of its parents (e.g. ScrollView)
function Objects.getPosModifier(self, checkFullPath)
  assert(self)
  
  local x, y = 0, 0
  local maxNestLevel = checkFullPath and #self.path or #self.path - 1
  
  if (maxNestLevel > 0) then
    for nestLevel = 1, maxNestLevel do
      local object = Path.getContainerAt(self.path, nestLevel)
      local modX, modY = Objects.Container.getPosModifier(object, x, y)
      x, y = x + modX, y + modY
    end
  end
  
  return x, y
end

-- Returns the relative position of the object
-- including the possible modifications of its
-- containers.
function Objects.getRelativePos(self)
  assert(self)
  
  local x, y = self.x, self.y
  local modX, modY = Objects.getPosModifier(self)
  
  return x + modX, y + modY
end

-- Returns the absolute position of the object
-- including the possible modifications of its
-- containers.
function Objects.getAbsolutePos(self)
  assert(self)
  
  local x, y = self.absoluteX, self.absoluteY
  local modX, modY = Objects.getPosModifier(self)
  
  return x + modX, y + modY
end

function Objects.isClicked(self, x, y)
  assert(self)
  assert(x)
  assert(y)
  
  return (x >= self.absoluteX and
      x <= self.absoluteX + self.width - 1 and
      y >= self.absoluteY and
      y <= self.absoluteY + self.height - 1)
end

-- Returns the buffer of the object.
function Objects.get(self, param)
  assert(self)
  
  --log("Getting " .. self.objType .. " object. ID: \"" .. self.objID .. "\", param: \"" .. tostring(param) .. "\"", "INFO")
  
  if (not editMode and not param and self.load) then
    if UserData[self.load] then
      param = UserData[self.load]()
      log("Loaded value of " .. self.objType .. " \"" .. self.objID .. "\":" .. param .. ".")
    end
  end
  
  local objType = self.objType or "Unknown"
  if (self.isContainer) then
    return Objects.Container.get(self, param)
  elseif (Objects[objType] and Objects[objType].get) then
    return Objects[objType].get(self, param)
  else
    error("Can't get buffer of object type \"" .. objType .. "\"!")
  end
end

--[[ Used to return the buffer of an object which
shows the user where to click to interact with
the object in a certain way.
(e.g. scrolling the ScrollView)
]]
function Objects.addMarker(self, buffer)
  assert(self)
  
  log("Objects.addMarker", "FUNC")
  log(self.objType .. " ID: \"" .. self.objID .. "\".", "ATTR")
  
  if (Objects[self.objType] and Objects[self.objType].addMarker) then
    Objects[self.objType].addMarker(self, buffer)
  elseif (Objects.Container[self.objType] and Objects.Container[self.objType].addMarker) then
    Objects.Container[self.objType].addMarker(self, buffer)
  end
end

function Objects.remove(self)
  assert(self)
  
  log("Objects.remove", "FUNC")
  log(self.objType .. " ID: \"" .. self.objID .. "\".")
  
  local path = self.path
  local objKey = path[#path]
  local container = Path.getContainerAt(self.path, #self.path - 1)
  
  container.Children[objKey] = nil
  
  for i = #path - 2, 0, -1 do
    local parentContainer = Path.getContainerAt(self.path, i)
    parentContainer.Children[path[i + 1]] = container
    container = parentContainer
  end
  
  Windows.Children[currentWindow] = container
end

-- Draws the object.
function Objects.draw(self, param, drawMarker)
  assert(self)
  
  log("Drawing " .. self.objType .. ". ID: " .. self.objID .. ", param: \"" .. tostring(param) .. "\"", "ATTR")
  
  local buffer = Objects.get(self, param)
  if drawMarker then
    Objects.addMarker(self, buffer)
  end
  
  if (#self.path > 1) then
    local container = getCurrentWindow()
    local x, y = self.absoluteX, self.absoluteY
    Objects.Container.drawBuffer(container, buffer, self.path, x, y, x, y, 0)
  else
    buffer:draw(self.x, self.y)
  end
  
  term.setBackgroundColor(ObjectColors.background)
  term.setTextColor(ObjectColors.text)
  drawDefaultButtons()
end

-- Returns the resulting event and a "params"-array.
function Objects.click(self, x, y)
  assert(self)
  
  log(self.objType .. " \"" .. self.objID .. "\" clicked at " .. x .. ", " .. y .. ".", "INFO")
  
  local objType = self.objType
  local event, params
  if Objects[objType] and Objects[objType].click then
    event, params = Objects[objType].click(self, x, y)
  elseif (self.isContainer and Objects.Container[objType] and Objects.Container[objType].click) then
    event, params = Objects.Container[objType].click(self, x, y)
  end
  
  return event, params
end

-- Returns the resulting event and a "params"-array.
function Objects.drag(self, x, y)
  assert(self)
  
  log(self.objType .. " \"" .. self.objID .. "\" dragged at " .. x .. ", " .. y .. ".", "INFO")
  
  local objType = self.objType
  local event, params
  if Objects[objType] and Objects[objType].drag then
    event, params = Objects[objType].drag(self, x, y)
  elseif (self.isContainer and Objects.Container[objType] and Objects.Container[objType].drag) then
    event, params = Objects.Container[objType].drag(self, x, y)
  end
  
  return event, params
end

-- Gets called when an object gets clicked in edit
-- mode. Returns false if the object should be
-- edited as usual (move, scale).
function Objects.editorClick(self, x, y)
  assert(self)
  assert(x)
  assert(y)
  
  log("Objects.editorClick", "FUNC")
  log(self.objType .. " ID: \"" .. self.objID .. "\", x: " .. x .. ", y: " .. y .. ".", "ATTR")
  
  if (Objects[self.objType] and Objects[self.objType].editorClick) then
    return Objects[self.objType].editorClick(self, x, y)
  elseif (Objects.Container[self.objType] and Objects.Container[self.objType].editorClick) then
    return Objects.Container[self.objType].editorClick(self, x, y)
  else
    return false
  end
end

-- Moves the object.
function Objects.move(self, addX, addY)
  assert(self)
  
  log("Objects.move", "FUNC")
  log(self.objType .. " ID: " .. self.objID .. ", x: " .. x .. ", y: " .. y .. ".", "ATTR")
  
  local objType = self.objType
  
  if (Objects[objType] and Objects[objType].move) then
    Objects[objType].move(self, addX, addY)
  elseif (self.isContainer) then
    self.x = self.x + addX
    self.y = self.y + addY
    Objects.Container.move(self, addX, addY)
  else
    self.x = self.x + addX
    self.y = self.y + addY
    self.absoluteX = self.absoluteX + addX
    self.absoluteY = self.absoluteY + addY
  end
end

-- Scales the object.
function Objects.scale(self, x, y)
  assert(self)
  
  log("Objects.scale", "FUNC")
  log(self.objType .. " ID: " .. self.objID .. ", x: " .. x .. ", y: " .. y .. ".", "ATTR")
  log("Object pos: " .. self.x .. ", " .. self.y, "DEBUG")
  
  local objType = self.objType
  
  if (Objects[objType] and Objects[objType].scale) then
    Objects[objType].scale(self, x, y)
  elseif (self.isContainer and Objects.Container[objType].scale) then
    Objects.Container[objType].scale(self, x, y)
  else
    local objX, objY = self.x, self.y
    if (x > objX and y >= objY) then
      self.width = x - objX + 1
      self.height = y - objY + 1
    end
  end
end

--[[ Returns the position of the pixel which shows
the user where to click when he wants to move the
object.]]
function Objects.getMovePos(self)
  assert(self)
  
  local objType = self.objType
  if (Objects[objType] and Objects[objType].getMovePos) then
    return Objects[objType].getMovePos(self)
  elseif (self.isContainer and Objects.Container[objType] and Objects.Container[objType].getMovePos) then
    return Objects.Container[objType].getMovePos(self)
  else
    return Objects.getAbsolutePos(self)
  end
end

--[[ Returns the position of the pixel which shows
the user where to click when he wants to scale the
object.]]
function Objects.getScalePos(self)
  if not self.canScale then
    error("Tried to get scale pos of an unscalable object!")
  end
  
  local objType = self.objType
  if (Objects[objType] and Objects[objType].getScalePos) then
    return Objects[objType].getScalePos(self)
  elseif (self.isContainer and Objects.Container[objType].getScalePos) then
    Objects.Container[objType].getScalePos(self)
  else
    local x, y = Objects.getAbsolutePos(self)
    return x + self.width - 1, y + self.height - 1
  end
end

-- Returns the left, top, right and bottom coordinates of the object.
function Objects.getDimensions(self)
  assert(self)
  
  local objType = self.objType
  if (Objects[objType] and Objects[objType].getDimensions) then
    return Objects[objType].getDimensions(self)
  elseif (self.isContainer and Objects.Container[objType] and Objects.Container[objType].getDimensions) then
    return Objects.Container[objType].getDimensions(self)
  else
    local left, top, right, bottom
    left, top = self.x, self.y
    right = left + self.width - 1
    bottom = top + self.height - 1
    return left, top, right, bottom
  end
end

function Objects.attributeChanged(self, key, oldValue, newValue)
  assert(self)
  
  local objType = self.objType
  if (Objects[objType] and Objects[objType].attributeChanged) then
    Objects[objType].attributeChanged(self, key, oldValue, newValue)
  elseif (self.isContainer and Objects.Container[objType] and Objects.Container[objType].attributeChanged) then
    Objects.Container[objType].attributeChanged(self, key, oldValue, newValue)
  end
end

function Objects.editAttributes(self)
  assert(self)
  
  log("Editing attributes of " .. self.objType .. " \"" .. self.objID .. "\".", "INFO")
  
  local objType = self.objType
  local attributes
  
  if (Objects[objType] and Objects[objType].attributes) then
    attributes = Objects[objType].attributes
  elseif (Objects.Container[objType] and Objects.Container[objType].attributes) then
    attributes = Objects.Container[objType].attributes
  else
    attributes = {}
  end
  
  local finished = false
  while not finished do
    local yPos = 2
    local top = yPos
    clearScreen()
    
    for index = 1, #attributes do
      local description = attributes[index].description
      local value = self[attributes[index].attrName]
      local required = attributes[index].required
      
      out.setCursorPos(2, yPos)
      
      local requirementMet = false
      
      if required then
        local reqAttrName = required.attrName
        local reqValue = required.value
        
        for reqAttrKey, reqAttributeValue in pairs(self) do
          if (reqAttrKey == reqAttrName and reqAttributeValue == reqValue) then
            requirementMet = true
          end
        end
      end
      
      if required and not requirementMet then
        out.setBackgroundColor(ObjectColors.disabled)
        out.setTextColor(ObjectColors.disabledText)
      end
      
      out.write(description .. ": " .. tostring(value))
      
      if required and not requirementMet then
        out.setBackgroundColor(ObjectColors.background)
        out.setTextColor(ObjectColors.text)
      end
      
      yPos = yPos + 1
    end
    
    drawSimpleButton(2, yPos + 1, Text.done)
    out.setBackgroundColor(ObjectColors.background)
    
    local bottom = yPos - 1
    local x, y, mouseButton = getCursorInput()
    
    if y >= top and y <= bottom then
      local selectedAttrIndex = y - top + 1
      local attribute = attributes[selectedAttrIndex]
      local attrName = attributes[selectedAttrIndex].attrName
      local attrType = attribute.attrType
      local attrValue = self[attrName]
      
      log("Editing \"" .. attrType .. "\" attribute \"" .. attrName .. "\".", "INFO")
      
      if not outIsTerm then
        drawPixel(1, y, colors.yellow)
      end
      
      if (attrType == "text") then
        if not outIsTerm then
          drawPixel(1, y, ObjectColors.Editor.textInputMarker)
        end
        
        local left = #attribute.description + 4
        local lineWidth = maxX - left + 1
        
        out.setCursorPos(left, y)
        out.write(string.rep(" ", lineWidth))
        out.setCursorPos(left, y)
        
        local input = readUserInput("Enter a vlaue for the \"" .. attribute.description .. "\" value.")
        
        if input then
          self[attrName] = input
        end
      elseif (attrType == "list") then
        local nextAttr = attribute.list[1]
        local selectAttribute = false
        
        for _, value in ipairs(attribute.list) do
          if (selectAttribute) then
            nextAttr = value
            break
          elseif (attrValue == value) then
            selectAttribute = true
          end
        end
        
        self[attrName] = nextAttr
      elseif (attrType == "number") then
        if not outIsTerm then
          drawPixel(1, y, ObjectColors.Editor.textInputMarker)
        end
        
        local left = #attribute.description + 4
        local lineWidth = maxX - left + 1
        
        out.setCursorPos(left, y)
        out.write(string.rep(" ", lineWidth))
        out.setCursorPos(left, y)
        
        local input = readUserInput("Enter a number for the \"" .. attribute.description .. "\" value.")
        
        if input and tonumber(input) then
          self[attrName] = tonumber(input)
        end
      elseif (attrType == "bool") then
          self[attrName] = not attrValue
      elseif (attrType == "table") then
        editMode = false
        ListEditorList = {}
        
        if self[attrName] then
          for key, value in pairs(self[attrName]) do
            ListEditorList[key] = value
          end
        else
          ListEditorList = {}
        end
        
        local result = CustomWindows.draw("ListEditor", "Main")
        
        if result then
          self[attrName] = {}
          
          for key, value in pairs(ListEditorList) do
            self[attrName][key] = value
          end
        end
        
        editMode = true
        currentWindow = lastWindow
      end
      
      Objects.attributeChanged(self, attrName, attrValue, self[attrName])
    elseif (y == yPos + 1 and x >= 2 and x <= 1 + string.len(Text.done)) then -- Done button
      finished = true
    end
  end
end

-- >> Unknown
Objects.Unknown = {}
Objects.Unknown.new = function(objType)
  objType = objType and " \"" .. objType .. "\"" or ""
  error("Tried to create new object with unknown object ID" .. objType .. "!")
end

Objects.Unknown.get = function(self)
  error("Tried to get the buffer of and unknown object!")
end

-- >> Button

Objects.Button = {}
Objects.Button.attributes = {
  { description = "Object ID", attrName = "objID", attrType = "text" };
  { description = "Text", attrName = "text", attrType = "text" };
  { description = "Function type", attrName = "funcType", attrType = "list", list = { "switch", "function", "toggle function" } };
  { description = "Window", attrName = "window", attrType = "text", required = { attrName = "funcType", value = "switch" } };
}

Objects.Button.new = function(self, maxWidth, maxHeight)
  self.width = (maxWidth < Size.Button.width) and maxWidth or Size.Button.width
  self.height = (maxHeight < Size.Button.height) and maxHeight or Size.Button.height
  self.widthPercent = maxX / self.width
  self.heightPercent = maxY / self.height
  self.text = "Button"
  self.funcType = ""
  self.window = ""
  self.canScale = true
  self.canClick = true
end

Objects.Button.get = function(self, buttonColor)
  local width = self.width
  local height = self.height
  local path = self.path
  local text = self.text
  local color
  
  if buttonColor then
    color = buttonColor
  elseif (ObjectData.Button[self.objID]) then
    color = ObjectColors.Button.active
  else
    color = ObjectColors.Button.default
  end
  
  local buffer = Buffer:new()
  local textCol = math.floor((width - string.len(text)) / 2) + 1
  local textRow = math.ceil(height / 2)
  buffer:init(width, height, path, color, ObjectColors.Button.text)
  buffer:addText(textCol, textRow, text)
  
  return buffer
end

-- Returns: "button_clicked" event, objID
Objects.Button.click = function(self, x, y)
  assert(self)
  
  local objID = self.objID
  local funcType = self.funcType
  local window = self.window
  if (funcType == "switch") then
    drawWindow(window)
    return nil, nil
  elseif (funcType == "function" or funcType == "toggle function") then
    local state = (funcType == "function" or ObjectData.Button[self.objID] == true)
    
    if (funcType == "function" and changeButtonColor) then
      Objects.draw(self, ObjectColors.Button.active)
    elseif (funcType == "toggle function") then -- Required because changeButtonColor could be false
		  state = not state
      ObjectData.Button[self.objID] = state
      Objects.draw(self)
    end
    
    if showCustomWindow and
        CustomFunctions[showCustomWindow] and
        CustomFunctions[showCustomWindow][objID] then
      CustomFunctions[showCustomWindow][objID](state)
    elseif (UserData[objID]) then
      UserData[objID](state)
    end
    
    if (funcType == "function") then
      if changeButtonColor then
        Objects.draw(self, ObjectColors.Button.default)
      else
        changeButtonColor = true
      end
    end
    
    local eventType = (funcType == "function") and "button_clicked" or "button_toggled"
    
    return eventType, {self.objID, state}
  else
    log("Unknown function type: \"" .. funcType .. "\"", "WARNING")
  end
end

-- >> Text

Objects.Text = {}
Objects.Text.attributes = {
  { description = "Text", attrName = "text", attrType = "text" };
}

Objects.Text.new = function(self)
  self.text = "newText"
  self.width = #self.text
  self.height = 1
end

Objects.Text.get = function(self)
  local width = #self.text
  local buffer = Buffer:new()
  buffer:init(width, 1, self.path)
  buffer:addText(1, 1, self.text)
  
  return buffer
end

Objects.Text.draw = function(self)
  local x = self.x
  local y = self.y
  local text = self.text
  out.setCursorPos(x, y)
  out.write(text)
end

Objects.Text.getDimensions = function(self)
  local left, top, right, bottom = self.x, self.y, 1, self.y
  right = left + string.len(self.text) - 1
  return left, top, right, bottom
end

Objects.Text.attributeChanged = function(self, key, oldValue, newValue)
  if (key == "text") then
    self.width = #newValue
  end
end

-- >> Variable

Objects.Variable = {}
Objects.Variable.attributes = {
  { description = "Object ID", attrName = "objID", attrType = "text" };
  { description = "Load Function", attrName = "load", attrType = "text" };
}

Objects.Variable.new = function(self)
  self.width = 1
  self.height = 1
end

Objects.Variable.get = function(self, value)
  local buffer = Buffer:new()
  
  if editMode and showCustomWindow ~= "Editor" then
    buffer:init(1, 1, self.path, ObjectColors.Editor.marker)
  elseif value then
    buffer:init(string.len(value), 1, self.path)
    buffer:addText(1, 1, value)
  else
    buffer:init(1, 1, self.path)
  end
  
  return buffer
end

-- >> ProgressBar

Objects.ProgressBar = {}
Objects.ProgressBar.attributes = {
  { description = "Object ID", attrName = "objID", attrType = "text" };
  { description = "Load Function", attrName = "load", attrType = "text" };
}

Objects.ProgressBar.new = function(self, maxWidth)
  self.length = (maxWidth < Size.ProgressBar.length) and maxWidth or Size.ProgressBar.length
  self.lengthPercent = maxX / self.length
  self.width = self.length
  self.height = 1
  self.direction = "right"
  self.objID = "newProgressBar"
  self.canScale = true
end

Objects.ProgressBar.get = function(self, value)
  local length = self.length
  local direction = (isValidDirection(self.direction)) and self.direction or "right"
  local orientation = getOrientation(direction) or error("Direction " .. direction .. " is invalid!")
  value = value or ProgressBarValues[self.objID]
  
  if (orientation == "horizontal") then
    width, height = length, 1
  else
    width, height = 1, length
  end
  
  local buffer = Buffer:new()
  buffer:init(width, height, self.path, ObjectColors.ProgressBar.background)
  
  if value then
    local color
    if (value < 33) then
      color = ObjectColors.ProgressBar.low
    elseif (value > 66) then
      color = ObjectColors.ProgressBar.high
    else
      color = ObjectColors.ProgressBar.medium
    end
    
    local filled = math.floor((length / 100) * value)
    local valueBuffer = Objects.Line.get(getOrientation(direction), filled, color)
    local addX, addY = 1, 1
    
    if (direction == "left") then
      addX = width - filled + 1
    elseif (direction == "up") then
      addY = height - filled + 1
    end
    
    buffer:addBuffer(addX, addY, valueBuffer)
  end
  
  return buffer
end

Objects.ProgressBar.getMovePos = function(self)
  local dir = self.direction
  local length = self.length
  local x, y = Objects.getAbsolutePos(self)
  
  if (dir == "left") then
    return x + length - 1, y
  elseif (dir == "up") then
    return x, y + length - 1
  else
    return x, y
  end
end

Objects.ProgressBar.getScalePos = function(self)
  local dir = self.direction
  local length = self.length
  local x, y = Objects.getAbsolutePos(self)
  
  if (dir == "right") then
    return x + length - 1, y
  elseif (dir == "down") then
    return x, y + length - 1
  else
    return x, y
  end
end

Objects.ProgressBar.scale = function(self, x, y)
  local moveX, moveY = Objects.getMovePos(self)
  local relMoveX, relMoveY = Path.getRelativePos(self.path, moveX, moveY)
  local length
  local direction
  local newX, newY
  local width, height
  
  if (x < relMoveX and y == relMoveY) then -- Clicked left of the progressBar.
    length = relMoveX - x + 1
    direction = "left"
    newX, newY = x, y
    width, height = length, 1
  elseif (x == relMoveX and y < relMoveY) then -- Clicked above the progressBar.
    length = relMoveY - y + 1
    direction = "up"
    newX, newY = x, y
    width, height = 1, length
  elseif (x > relMoveX and y == relMoveY) then -- Clicked right of the progressBar.
    length = x - relMoveX + 1
    direction = "right"
    newX, newY = relMoveX, relMoveY
    width, height = length, 1
  elseif (x == relMoveX and y > relMoveY) then -- Clicked below the progressBar.
    length = y - relMoveY + 1
    direction = "down"
    newX, newY = relMoveX, relMoveY
    width, height = 1, length
  else
    return
  end
  
  if (length > 2) then
    local xDiff, yDiff = newX - self.x, newY - self.y
    
    self.absoluteX, self.absoluteY = self.absoluteX + xDiff, self.absoluteY + yDiff
    self.x, self.y = newX, newY
    self.direction = direction
    self.width, self.height = width, height
    self.length = length
    self.lengthPercent = length / maxX
  end
end

-- >> Input

Objects.Input = {}
Objects.Input.attributes = {
{ description = "Object ID", attrName = "objID", attrType = "text" };
  { description = "Message", attrName = "message", attrType = "text" };
  { description = "Is password", attrName = "isPassword", attrType = "bool" };
}

Objects.Input.new = function(self)
  self.message = "Enter something."
  self.isPassword = false
  self.width = 2
  self.height = 1
  self.canClick = true
end

Objects.Input.get = function(self)
  local userInput = ObjectData.Input[self.objID] or ""
  local width, height = 2 + string.len(userInput), 1
  
  local buffer = Buffer:new()
  buffer:init(width, height, self.path, ObjectColors.Input.default)
  if userInput ~= "" then
    buffer:addText(2, 1, userInput)
  end
  
  return buffer
end

-- Returns: "text_changed" event, objID, text
Objects.Input.click = function(self)
  local x = self.absoluteX
  local y = self.absoluteY
  local objID = self.objID
  local message = self.message
  local isPassword = (self.isPassword == nil) and false or self.isPassword
  local maxLength = self.maxLength
  local existingInput = ObjectData.Input[objID]
  
  out.setBackgroundColor(ObjectColors.background)
  out.setCursorPos(x, y)
  if (existingInput ~= nil) then -- Clear the text on the input object.
    out.write(string.rep(" ", string.len(existingInput) + 2))
  else
    out.write("  ")
  end
  ObjectData.Input[objID] = nil
  
  out.setCursorPos(x, y)
  if not outIsTerm then
    -- make the input-object yellow
    out.setBackgroundColor(ObjectColors["Input"].active)
    out.write("  ")
    out.setBackgroundColor(ObjectColors.background)
  end
  
  if outIsTerm then
    out.setCursorPos(x + 1, y)
  end
  
  local userInput = readUserInput(message, isPassword)
  if (userInput ~= nil) then
    ObjectData.Input[objID] = userInput
  end
  
  out.setCursorPos(x, y)
  out.setBackgroundColor(ObjectColors.Input.default)
  out.setTextColor(ObjectColors.Input.text)
  
  out.write(" ")
  if (userInput ~= nil and userInput ~= "") then
    if isPassword then
      for i = 1, string.len(userInput) do
        out.write("*")
      end
    else
      out.write(userInput)
    end
  end
  
  out.write(" ")
  out.setBackgroundColor(ObjectColors.background)
  out.setTextColor(ObjectColors.text)
  
  return "text_changed", {self.objID, userInput}
end

-- >> List

Objects.List = {}
Objects.List.attributes = {
  { description = "Object ID", attrName = "objID", attrType = "text" };
  { description = "Items", attrName = "Items", attrType = "table" };
  { description = "Is multiselect", attrName = "isMultiselect", attrType = "bool" };
}

Objects.List.new = function(self)
  self.Items = {}
  self.objID = "testList"
  self.isMultiselect = false
  self.canClick = true
end

Objects.List.get = function(self)
  assert(self)
  
  local buffer = Buffer:new()
  
  if self.load then
    self.Items = self.load()
  end
  
  self.Items = self.Items or { "empty" }
  
  if (#self.Items == 0) then
    self.Items = { "empty" }
  end
  
  self.width = getLongestString(self.Items) + 2
  self.height = #self.Items
  
  if not ObjectData.List[self.objID] then
    ObjectData.List[self.objID] = {}
  end
  
  buffer:init(self.width, self.height, self.path, ObjectColors.List.default)
  
  local line = 1
  for key, element in pairs(self.Items) do
    if (ObjectData.List[self.objID][key]) then
      buffer:addBuffer(1, line, Objects.Line.get("horizontal", self.width, ObjectColors.List.active))
    end
    buffer:addText(2, line, self.Items[line])
    line = line + 1
  end
  
  return buffer
end

-- Returns: "selection_changed" event, objID, key, true or false
Objects.List.click = function(self, x, y)
  local objID = self.objID
  local isMultiselect = self.isMultiselect
  local itemSelected = ObjectData.List[objID][y]
  
  if (isMultiselect) then
    ObjectData.List[objID][y] = not itemSelected
  else
    ObjectData.List[objID] = {}
    ObjectData.List[objID][y] = true
  end
  
  Objects.draw(self)
  
  return "selection_changed", {self.objID, y, ObjectData.List[objID][y]}
end

-- Same as List.click
Objects.List.drag = function(self, x, y)
  return Objects.List.click(self, x, y)
end

Objects.List.getFirstSelectedKey = function(self)
  assert(self)
  
  local objID = self.objID
  
  for key, value in pairs(ObjectData.List[objID]) do
    if (value == true and self.Items[key] ~= "empty") then
      return key
    end
  end
  
  return nil
end

Objects.List.getFirstSelectedValue = function(self)
  assert(self)
  
  key = Objects.List.getFirstSelectedKey(self)
  
  if key then
    return self.Items[key]
  else
    return nil
  end
end

-- >> FileSelector

Objects.FileSelector = {}
Objects.FileSelector.attributes = {
  { description = "Object ID", attrName = "objID", attrType = "text" };
}

Objects.FileSelector.new = function(self)
  self.width = string.len(Text.fileSelector)
  self.height = 1
  self.isMultiselect = false
  self.canClick = true
end

Objects.FileSelector.get = function(self)
error("not yet implemented")
  local objectID = objectID
  local x = self.x
  local y = self.y
  local isMultiselect = self.isMultiselect
  
  out.setBackgroundColor(ObjectColors["FileSelector"].default)
  out.setTextColor(ObjectColors["FileSelector"].text)
  
  out.setCursorPos(x, y)
  out.write(Text.fileSelector)
  
  if (ObjectData.FileSelector[objectID] ~= nil) then
    out.setBackgroundColor(ObjectColors.background)
    out.setTextColor(ObjectColors.text)
    local files = ObjectData.FileSelector[objectID]
    out.write(" ")
    if (type(files) == "table") then
      local sep = ""
      for _, fileName in pairs(files) do
        term.write(sep .. fileName)
        sep = ", "
      end
    else
      out.write(files)
    end
  end
  
  out.setBackgroundColor(ObjectColors.background)
  out.setTextColor(ObjectColors.text)
end

Objects.FileSelector.click = function(self, x, y)
error("Not yet implemented")
-- TODO
  local finished = false
  local path = "/"
  local list = {}
  
  while not finished do
    clearScreen()
    out.setCursorPos(2, 1)
    out.write("Path: " .. path)
    
    list = getFileList(path)
    
    out.setTextColor(ObjectColors.FileSelector.text)
  end
end

-- >> CheckBox
Objects.CheckBox = {}
Objects.CheckBox.attributes = {
  { description = "Object ID", attrName = "objID", attrType = "text" };
  { description = "Checked by default", attrName = "defaultIsChecked", attrType = "bool" };
}

Objects.CheckBox.new = function(self)
  self.objID = "newCheckBox"
  self.canClick = true
  self.canScale = false
  self.defaultIsChecked = false
  self.text = "new CheckBox"
  self.width = #self.text + 2
  self.height = 1
end

Objects.CheckBox.init = function(self)
  if (self.defaultIsChecked == true) then
    ObjectData.CheckBox[self.objID] = true
  end
end

Objects.CheckBox.get = function(self)
  if (ObjectData.CheckBox[self.objID] == nil) then
    ObjectData.CheckBox[self.objID] = self.defaultIsChecked
  end
  
  local buffer = Buffer:new()
  local isChecked = ObjectData.CheckBox[self.objID]
  local char = isChecked and "X" or " "
  
  buffer:init(self.width, self.height, self.path)
  buffer:setPixel(1, 1,
    { background = ObjectColors.CheckBox.default,
      text = ObjectColors.CheckBox.active,
      char = char })
  buffer:addText(3, 1, self.text)
  
  return buffer
end

-- returns "checked" event, object ID, checked state
Objects.CheckBox.click = function(self)
  ObjectData.CheckBox[self.objID] = not ObjectData.CheckBox[self.objID]
  Objects.draw(self)
  
  return "checked", { self.objID, ObjectData.CheckBox[self.objID] }
end

Objects.CheckBox.attributeChanged = function(self, key, oldValue, newValue)
  if (key == "text") then
    self.width = #newValue + 2
  end
end

-- >> RadioButton

Objects.RadioButton = {}
Objects.RadioButton.attributes = {
  { description = "Object ID", attrName = "objID", attrType = "text" };
  { description = "Text", attrName = "text", attrType = "text" };
  { description = "Group", attrName = "group", attrType = "text" };
  { description = "Checked by default", attrName = "defaultIsChecked", attrType = "bool" }
}

Objects.RadioButton.new = function(self)
  self.objID = "newRadioButton1"
  self.defaultIsChecked = false
  self.group = "default"
  self.text = "new RadioButton"
  self.width = #self.text + 2
  self.height = 1
  self.canClick = true
  self.canScale = false
end

Objects.RadioButton.init = function(self)
  if (self.defaultIsChecked == true) then
    ObjectData.RadioButton[self.objID] = true
  end
end

Objects.RadioButton.get = function(self)
  local buffer = Buffer:new()
  local color
  
  if ObjectData.RadioButton[self.objID] and not editMode then
    color = ObjectColors.RadioButton.active
  else
    color = ObjectColors.RadioButton.default
  end
  
  buffer:init(#self.text + 2, 1, self.path)
  buffer:setPixel(1, 1, { background = color, char = " "})
  buffer:addText(3, 1, self.text)
  
  return buffer
end

Objects.RadioButton.update = function(container, groupName, clickedID)
  for _, object in pairs(container.Children) do
    if (type(object) == "table") then
      if (object.objType == "RadioButton" and object.group == groupName) then
        ObjectData.RadioButton[object.objID] = (clickedID == object.objID)
        Objects.draw(object)
      elseif (object.isContainer) then
        Objects.RadioButton.update(object, groupName, clickedID)
      end
    end
  end
end

-- returns "radio_changed" event, object ID
Objects.RadioButton.click = function(self)
  Objects.RadioButton.update(getCurrentWindow(), self.group, self.objID)
  
  return "selection_changed", { self.objID }
end

Objects.RadioButton.attributeChanged = function(self, key, oldValue, newValue)
  if (key == "text") then
    self.with = #newValue + 2
  end
end

-- >> Slider

Objects.Slider = {}
Objects.Slider.attributes = {
  { description = "Object ID", attrName = "objID", attrType = "text" };
  { description = "Minimum value", attrName = "minValue", attrType = "number" };
  { description = "Maximum value (affects length)", attrName = "maxValue", attrType = "number" };
}

Objects.Slider.new = function(self)
  self.objID = "newSlider"
  self.width = Size.Slider.length
  self.height = 1
  self.minValue = 0
  self.maxValue = Size.Slider.length - 1
  self.canClick = true
  self.canScale = false
end

Objects.Slider.init = function(self)
  ObjectData.Slider[self.objID] = self.minValue
end

Objects.Slider.get = function(self)
  local buffer = Buffer:new()
  
  buffer:init(self.width, self.height, self.path, ObjectColors.Slider.default, ObjectColors.Slider.text)
  buffer:addText(1, 1, "|" .. string.rep("-", self.width - 2) .. "|")
  
  if ObjectData.Slider[self.objID] and not editMode then
    local pixel = { background = ObjectColors.Slider.active, text = ObjectColors.Slider.activeText, char = "|" }
    buffer:setPixel(ObjectData.Slider[self.objID] - self.minValue + 1, 1, pixel)
  end
  
  return buffer
end

Objects.Slider.attributeChanged = function(self, key, oldValue, newValue)
  if ((key == "minValue" or key == "manValue") and newValue % 1 ~= 0) then
    self[key] = round(newValue)
  end
  
  if (key == "minValue") then
    if (newValue >= self.maxValue) then
      self[key] = oldValue
    else -- adapt slider width
      self.width = self.maxValue - self.minValue + 1
    end
  elseif (key == "maxValue") then
    if (newValue <= self.minValue) then
      self[key] = oldValue
    else -- adapt slider width
      self.width = self.maxValue - self.minValue + 1
    end
  end
end

-- returns "slider_changed" event, object ID, value
Objects.Slider.click = function(self, x, y)
  ObjectData.Slider[self.objID] = x + self.minValue - 1
  Objects.draw(self)
  
  return "slider_changed", { self.objID, ObjectData.Slider[self.objID] }
end

Objects.Slider.drag = function(self, x, y)
  return Objects.Slider.click(self, x, y)
end

-- >> DropDownList

Objects.DropDownList = {}
Objects.DropDownList.attributes = {
  { description = "Object ID", attrName = "objID", attrType = "text" };
  { description = "Items", attrName = "Items", attrType = "table" };
  { description = "Load Function", attrName = "load", attrType = "text" };
}

Objects.DropDownList.new = function(self, maxWidth)
  self.Items = { "empty" }
  self.objID = "newDropDownList"
  self.width = (Size.DropDownList.width > maxWidth) and maxWidth or Size.DropDownList.width
  self.height = 1
  self.canClick = true
  self.canScale = true
end

Objects.DropDownList.get = function(self)
  assert(self)
  
  if self.load then
    self.Items = self.load()
  elseif not self.Items then
    self.Items = { "empty" }
  end
  
  local buffer = Buffer:new()
  buffer:init(self.width, 1, self.path, ObjectColors.DropDownList.default, ObjectColors.DropDownList.text)
  
  if ObjectData.DropDownList[self.objID] then
    buffer:addText(1, 1, self.Items[ObjectData.DropDownList[self.objID]])
  elseif #self.Items > 0 then
    ObjectData.DropDownList[self.objID] = 1
    buffer:addText(1, 1, self.Items[ObjectData.DropDownList[self.objID]])
  end
  
  buffer:addText(self.width - 2, 1, " V")
  
  return buffer
end

-- Returns: "selection_changed" event, objID, key
Objects.DropDownList.click = function(self, x, y)
  assert(self)
  
  local selectedItem = ObjectData.DropDownList[self.objID]
  local drawY
  local height = #self.Items
  
  -- Determine whether the list should be displayed below or above the object.
  
  if height >= maxX then -- Not enough space vertically.
    drawY = 1
  elseif maxX - height > self.absoluteY then
    drawY = self.absoluteY + 1
  elseif self.absoluteY - height > 0 then
    drawY = self.absoluteY - height
  else
    drawY = maxY - height
  end
  
  out.setTextColor(ObjectColors.DropDownList.text)
  
  for index = 1, height do
    if (index == ObjectData.DropDownList[self.objID]) then
      out.setBackgroundColor(ObjectColors.DropDownList.active)
    else
      out.setBackgroundColor(ObjectColors.DropDownList.default)
    end
    
    out.setCursorPos(self.absoluteX, drawY + index - 1)
    out.write(self.Items[index] .. string.rep(" ", self.width - #self.Items[index] - 1))
  end
  
  out.setBackgroundColor(ObjectColors.background)
  out.setTextColor(ObjectColors.text)
  
  local x, y, mouseButton = getCursorInput()
  
  if (x >= self.absoluteX and
      x <= self.absoluteX + self.width - 1 and
      y >= self.absoluteY + 1 and
      y <= self.absoluteY + height) then
    local selectedIndex = y - self.absoluteY
    
    ObjectData.DropDownList[self.objID] = selectedIndex
  end
  
  drawWindow()
  
  return "selection_changed", { self.objID, ObjectData.DropDownList[self.objID] }
end

Objects.DropDownList.scale = function(self, x, y)
  assert(self)
  assert(x)
  assert(y)
  
  local length = x - self.x + 1
  
  if (length >= 3) then
    self.width = length
  end
end

-- >>> Containers

Objects.Container = {}

Objects.Container.getNextFreeKey = function(self)
  local nextKey = 1
  
  while self.Children[nextKey] ~= nil do
    nextKey = nextKey + 1
  end
  
  return nextKey
end

-- Returns the area of the container which stores
-- its children.
Objects.Container.getContentArea = function(self)
  assert(self)
  local objType = self.objType
  
  if (Objects.Container[objType].getContentArea) then
    return Objects.Container[objType].getContentArea(self)
  else
    local left = self.x + 1
    local top = self.y + 1
    local right = self.x + self.width - 2
    local bottom = self.y + self.height - 2
    return left, top, right, bottom
  end
end

-- Determines whether the container itself or its
-- content area is at the given position.
Objects.Container.contentAreaClicked = function(self, x, y)
  local left, top, right, bottom = Objects.Container.getContentArea(self)    
  
  return (x >= left and x <= right and y >= top and y <= bottom)
end

-- Draws the buffer and trims it before that if
-- necessary.
Objects.Container.drawBuffer = function(self, buffer, path, x, y, absoluteX, absoluteY, nestLevel)
  --log("Objects.Container.drawBuffer", "FUNC")
  local modX, modY = Objects.Container.getPosModifier(self, x, y)
  x, y = x + modX, y + modY
  
  if (self.objType ~= "Window") then
    local containerLeft, containerTop, containerRight, containerBottom = 1, 1, self.width - 1, self.height - 1
    local objLeft, objTop, objRight, objBottom = x, y, x + buffer.width - 1, y + buffer.height - 1
    
    --log("Container dimensions: left: " .. containerLeft .. ", top: " .. containerTop .. ", right: " .. containerRight .. ", bottom: " ..containerBottom .. ".", "DEBUG")
    --log("Object dimensions: left: " .. objLeft .. ", top: " .. objTop .. ", right: " .. objRight .. ", bottom: " ..objBottom .. ".", "DEBUG")
    
    if (objLeft > self.width or
        objTop > self.height or
        objRight < 0 or
        objBottom < 0) then
      return
    elseif (objLeft < containerLeft or objTop < containerTop or objRight >= containerRight or objBottom >= containerBottom) then
      -- Object goes over the border. Trim it.
      local trimLeft = (containerLeft - objLeft) > 0 and containerLeft - objLeft or 0
      local trimTop = (containerTop - objTop) > 0 and containerTop - objTop or 0
      local trimRight = (objRight - containerRight + 1) > 0 and objRight - containerRight + 1 or 0
      local trimBottom = (objBottom - containerBottom + 1) > 0 and objBottom - containerBottom + 1 or 0
      buffer = buffer:trim(trimLeft, trimTop, trimRight, trimBottom)
      
      if (trimLeft > 0) then
        x = x + trimLeft
        absoluteX = absoluteX + trimLeft
      end
      if (trimTop > 0) then
        y = y + trimTop
        absoluteY = absoluteY + trimTop
      end
    end
  end
  
  if (nestLevel < #path - 1) then
    local container = Path.getContainerAt(path, nestLevel + 1)
    local relX, relY = Objects.Container.getRelativePos(container, x, y)
    Objects.Container.drawBuffer(container, buffer, path, relX, relY, absoluteX, absoluteY, nestLevel + 1)
  else
    buffer:draw(absoluteX + modX, absoluteY + modY)
  end
end

Objects.Container.getRelativePos = function(self, x, y)
  local left, top, right, bottom = Objects.Container.getContentArea(self)
  
  --log("Objects.Container.getRelativePos", "FUNC")
  --log(self.objType .. " ID: " .. self.objID .. ", x: " .. x .. ", y: " .. y .. ".", "ATTR")
  --log("Left: " .. left .. ", top: " .. top .. ", right: " .. right .. ", bottom: " .. bottom .. ".", "DEBUG")
  
  retX = x - left + 1
  retY = y - top + 1
  
  return retX, retY
end

Objects.Container.getParentsRelativePos = function(self, x, y)
  local left, top, right, bottom = Objects.Container.getContentArea(self)
  
  return x + left - 1, y + top - 1
end

Objects.Container.new = function(self, maxWidth, maxHeight)
  --log("Objects.Container.new", "FUNC")
  local defaultWidth, defaultHeight = Size.Container.width, Size.Container.height
  
  self.isContainer = true
  self.canScale = true
  self.Children = {}
  self.width = (maxWidth < defaultWidth) and maxWidth or defaultWidth
  self.height = (maxHeight < defaultHeight) and maxHeight or defaultHeight
  
  --log("New container dimensioins: " .. self.width .. " x " .. self.height .. ".")
  
  if (Objects.Container[self.objType].new) then
    Objects.Container[self.objType].new(self)
  end
end

Objects.Container.init = function(self)
  assert(self)
  
  local objType = self.objType
  
  if (Objects.Container[objType] and Objects.Container[objType].init) then
    Objects.Container[objType].init()
  end
  
  for _, object in pairs(self.Children) do
    if (type(object) == "table") then
      local objType = object.objType
      
      if (Objects[objType] and Objects[objType].init) then
        log("Initializting " .. objType .. " " .. object.objID .. ".", "INFO")
        Objects[objType].init(object)
      elseif (object.isContainer) then
        Objects.Container.init(object)
      end
    end
  end
end

Objects.Container.get = function(self)
  assert(self)
  
  local left, top, right, bottom = Objects.Container.getContentArea(self)
  local minWidth, minHeight = right - left + 1, bottom - top + 1
  local width, height = getNecessaryBufferSize(self.Children, minWidth, minHeight)
  
  local buffer = Buffer:new()
  buffer:init(width, height, {})
  
  for objectID, object in pairs(self.Children) do
    local objectBuffer = Objects.get(object)
    buffer:addBuffer(object.x, object.y, objectBuffer)
  end
  
  return Objects.Container[self.objType].get(self, buffer)
end

Objects.Container.getPosModifier = function(self, x, y)
  assert(self)
  
  --log("Objects.Container.getPosModifier", "FUNC")
  --log("Object type: " .. tostring(self.objType) .. ", ID: " .. tostring(self.objID) .. ".", "INFO")
  --log("Position: " .. x .. ", " .. y .. ".", "INFO")
  
  local objType = self.objType
  if (Objects.Container[objType] and Objects.Container[objType].getPosModifier) then
    local newX, newY = Objects.Container[objType].getPosModifier(self, x, y)
    --log("Modifier: " .. newX .. ", " .. newY .. ".", "INFO")
    return newX, newY
  else
    --log("Position not modified.")
    return 0, 0
  end
end

Objects.Container.move = function(self, addX, addY)
  self.absoluteX = self.absoluteX + addX
  self.absoluteY = self.absoluteY + addY
  
  for _, child in pairs(self.Children) do
    if child.isContainer then
      Objects.Container.move(child, addX, addY)
    else
      child.absoluteX = child.absoluteX + addX
      child.absoluteY = child.absoluteY + addY
    end
  end
end

-- >> Window

Objects.Container.Window = {}
Objects.Container.Window.new = function(windowName)
  local object = {}
  object.objType = "Window"
  object.Children = {}
  object.width, object.height = maxX, maxY
  
  return object
end

Objects.Container.Window.create = function(windowName)
  assert(windowName)
  
  local windowContainer = getWindowContainer()
  local object = Objects.Container.Window.new(windowName)
  
  windowContainer.Children[windowName] = object
  
  log("Created window \"" .. windowName .. "\" for window container \"" .. tostring(showCustomWindow) .. "\".", "INFO")
end

Objects.Container.Window.get = function(self, contentBuffer)
  return contentBuffer
end

Objects.Container.Window.getContentArea = function(self)
  return 1, 1, maxX, maxY
end

-- >> Panel

Objects.Container.Panel = {}
Objects.Container.Panel.attributes = {}

Objects.Container.Panel.get = function(self, contentBuffer)
  --log("Objects.Container.Panel.get", "FUNC")
  local buffer = Buffer:new()
  buffer:init(self.width, self.height, self.path, ObjectColors.Container.Panel.border)
  buffer:addBuffer(2, 2, contentBuffer)
  buffer:addBuffer(self.width, 1, Objects.Line.get("vertical", self.height, ObjectColors.Container.Panel.border, self.path))
  buffer:addBuffer(1, self.height, Objects.Line.get("horizontal", self.width, ObjectColors.Container.Panel.border, self.path))
  
  return buffer
end

-- >> ScrollView

Objects.Container.ScrollView = {}
Objects.Container.ScrollView.attributes = {}

Objects.Container.ScrollView.new = function(self)
  self.scrollX = 0
  self.scrollY = 0
  self.maxScrollX = 0
  self.maxScrollY = 0
  self.scrollXEnabled = false
  self.scrollYEnabled = true
end

Objects.Container.ScrollView.get = function(self, contentBuffer)
  --log("Objects.Container.ScrollView.get", "FUNC")
  --log("ScrollView (ID: " .. tostring(self.objID) .. ")", "INFO")
  
  local buffer = Buffer:new()
  buffer:init(self.width, self.height, self.path, ObjectColors.Container.ScrollView.border)
  buffer:addBuffer(2 - self.scrollX, 2 - self.scrollY, contentBuffer)
  buffer:makeBorder(self.path, ObjectColors.Container.ScrollView.border)
  
  --local edgePixel = { background=ObjectColors.Container.ScrollView.border, path=self.path }
  --buffer:setPixel(self.width, 1, edgePixel)
  --buffer:setPixel(self.width, self.height, edgePixel)
  --buffer:setPixel(1, self.height, edgePixel)
  
  if (self.scrollXEnabled) then
    self.maxScrollX = contentBuffer.width - self.width + 1
    
    buffer:addBuffer(2, self.height, Objects.Line.get("horizontal", self.width - 2, ObjectColors.Container.ScrollView.scrollBackground))
    
    if (self.width > 4) then
      local scrollBarInfo = getScrollBarInfo(self.scrollX, self.width, contentBuffer.width)
      buffer:addBuffer(scrollBarInfo.pos + 3, self.height, Objects.Line.get("horizontal", scrollBarInfo.size, ObjectColors.Container.ScrollView.scrollForeground, self.path))
    end
    
    buffer:setPixel(2, self.height, { char="<", path=self.path })
    buffer:setPixel(self.width - 1, self.height, { char=">", path=self.path })
  else
    --buffer:addBuffer(2, self.height, Objects.Line.get("horizontal", self.width - 2, ObjectColors.Container.ScrollView.border, self.path))
  end
  
  if (self.scrollYEnabled) then
    self.maxScrollY = contentBuffer.height - self.height + 1
    buffer:addBuffer(self.width, 2, Objects.Line.get("vertical", self.height - 2, ObjectColors.Container.ScrollView.scrollBackground))
    
    if (self.height > 4) then
      local scrollBarInfo = getScrollBarInfo(self.scrollY, self.height, contentBuffer.height)
      buffer:addBuffer(self.width, scrollBarInfo.pos + 3, Objects.Line.get("vertical", scrollBarInfo.size, ObjectColors.Container.ScrollView.scrollForeground, self.path))
    end
    
    buffer:setPixel(self.width, 2, { char="^", path=self.path })
    buffer:setPixel(self.width, self.height - 1, { char="V", path=self.path })
  else
    --buffer:addBuffer(self.width, 2, Objects.Line.get("vertical", self.height - 2, ObjectColors.Container.ScrollView.border, self.path))
  end
  
  return buffer
end

Objects.Container.ScrollView.click = function(self, x, y)
  if (x == self.width and y == 2) then -- Up
    --log("Up")
    if (self.scrollY > 0) then
      self.scrollY = self.scrollY - 1
    end
  elseif (x == self.width and y == self.height - 1) then -- Down
    --log("Down")
    if (self.scrollY < self.maxScrollY) then
      self.scrollY = self.scrollY + 1
    end
  elseif (x == 2 and y == self.height) then -- Left
    --log("Left")
    if (self.scrollX > 0) then
      self.scrollX = self.scrollX - 1
    end
  elseif (x == self.width - 1 and y == self.height) then -- Right
    --log("Right")
    if (self.scrollX < self.maxScrollX) then
      self.scrollX = self.scrollX + 1
    end
  end
  
  WindowBuffer:addBuffer(self.absoluteX, self.absoluteY, Objects.get(self))
  Objects.draw(self)
end

Objects.Container.ScrollView.getPosModifier = function(self, x, y)
  return self.scrollX * -1, self.scrollY * -1
end

Objects.Container.ScrollView.addMarker = function(self, buffer)
  
  if not (self.scrollXEnabled and self.scrollYEnabled) then
    if (not self.scrollXEnabled and self.width > 2) then
      buffer:addBuffer(2, self.height, Objects.Line.get("horizontal", self.width - 2, ObjectColors.Editor.editMarker))
    end
    
    if (not self.scrollYEnabled and self.height > 2) then
      buffer:addBuffer(self.width, 2, Objects.Line.get("vertical", self.height - 2, ObjectColors.Editor.editMarker))
    end
  end
end

Objects.Container.ScrollView.editorClick = function(self, x, y)
  -- Check whether an arrow has been clicked.
  if (self.scrollYEnabled and x == self.width and y == 2) then -- Up
    --log("Up")
    if (self.scrollY > 0) then
      self.scrollY = self.scrollY - 1
    end
    
    return true
  elseif (self.scrollYEnabled and x == self.width and y == self.height - 1) then -- Down
    --log("Down")
    self.scrollY = self.scrollY + 1
    return true
  elseif (self.scrollXEnabled and x == 2 and y == self.height) then -- Left
    --log("Left")
    if (self.scrollX > 0) then
      self.scrollX = self.scrollX - 1
    end
    
    return true
  elseif (self.scrollXEnabled and x == self.width - 1 and y == self.height) then -- Right
    --log("Right")
    self.scrollX = self.scrollX + 1
    return true
  else -- Check whether the scrollBar has been clicked.
    if (x >= 1 and x <= self.width - 1 and y == self.height) then
      self.scrollXEnabled = not self.scrollXEnabled
      return true
    elseif (x == self.width and y > 1 and y < self.height - 1) then
      self.scrollYEnabled = not self.scrollYEnabled
      return true
    end
  end
  
  return false
end

-- >> Non-addable objects.

-- >> Line

Objects.Line = {}
Objects.Line.get = function(orientation, length, color, path)
  if (orientation ~= "horizontal" and orientation ~= "vertical") then
    orientation = getOrientation(orientation) or error("Orientation " .. orientation .. " is invalid!", 1)
  end
  
  assert(length)
  assert(color)
  
  local width, height
  if (orientation == "horizontal") then
    width, height = length, 1
  else
    width, height = 1, length
  end
  
  local buffer = Buffer:new()
  buffer:init(width, height, path, color)
  
  return buffer
end

-- >> Selector
Objects.Selector = {}
Objects.Selector.draw = function(x, y, items)
  assert(x)
  assert(y)
  assert(items)
  
  width = getLongestString(items) + 2
  height = #items -- Items + up and down
  itemCount = #items
  displayCount = itemCount
  
  enoughXSpace = true
  -- determine where the selector should actually be displayed
  if (width > maxX) then -- Not enough monitors horizontally?
    x = 1
    enoughXSpace = false
  elseif (maxX - x < width) then -- Not enough space to the right.
    if (x >= width) then -- Let's see if there is space to the left.
      x = x - width
    else -- No space? Check where you've got more space.
      if (maxX / 2) > x then -- More space to the left.
        x = maxX - width + 1
        enoughXSpace = false
      else -- More space to the right
        x = 1
        enoughXSpace = false
      end
    end
  else -- Enough space to the right.
    x = x + 1
  end
  
  if (height > maxY - y) then -- Not enough space from y to bottom.
    if ((maxY / 2) > y) then -- More space below y.
      if enoughXSpace then
        if (maxY < height) then -- Too big for the whole screen.
          y = 1
          displayCount = maxY
        else -- Enough space next to x and not too high.
          y = maxY - height
        end
      else -- Can't display it next to the selected point.
        y = y + 1
        displayCount = maxY - y + 1
      end
    else -- More space above y.
      if enoughXSpace then
        if (y < height) then -- Not enough space from top to y.
          if (maxY < height) then -- Too big for the whole screen.
            y = 1
            displayCount = maxY
          else -- Enough space next to x and not too high.
            y = 1
          end
        else -- Enough space from top to y.
          y = y - height + 1
        end
      else
        if (y < height) then -- Not enough space from top to y.
          if (maxY < height) then -- Too big for the whole screen.
            y = 1
            displayCount = maxY
          else -- Not enough space next to x but not too high.
            y = 1
            displayCount = y - 2
          end
        else -- Enough space from top to y.
          y = y - height
        end
      end
    end
  end
  
  out.setBackgroundColor(ObjectColors.background)
  
  local drawArrows = displayCount < height
  
  local start = 1
  local scroll = 0
  local right = x + width - 1
  local bottom = y + height - 1
  local finished = false
  local result
  
  if drawArrows then
    displayCount = displayCount - 2
    local middle = math.floor(width / 2)
    
    out.setCursorPos(x + middle, y)
    out.write("^")
    out.setCursorPos(x + middle, bottom)
    out.write("V")
    
    start = 2
  end
  
  while not finished do
    out.setTextColor(ObjectColors.Editor.selectorText)
    
    for row = start, displayCount do
      local color = (row % 2 == 0) and ObjectColors.Editor.selector1 or ObjectColors.Editor.selector2
      local text = items[row + scroll]
      
      out.setBackgroundColor(color)
      out.setCursorPos(x, y + row - 1)
      out.write(" " .. text .. string.rep(" ", width - #text - 1))
    end
    
    out.setBackgroundColor(ObjectColors.background)
    
    local touchX, touchY, mouseButton = getCursorInput()
    
    if (touchX < x or touchX > right or touchY < y or touchY > bottom) then
      selectedItem = nil
      result = false
      finished = true
    else -- User touched the selector.
      if showArrows then
        if (touchY == y) then -- up
          if (scroll > 0) then -- Check whether it is possible to scroll up.
            scroll = scroll - 1
          end
        elseif (touchY == bottom) then -- down
          if (displayCount < itemCount) then
            if (scroll < itemCount - displayCount) then
              scroll = scroll + 1
            end
          end
        end
      else
        selectedItem = items[touchY - y + scroll + 1]
        result = true
        finished = true
      end
    end
  end
  
  drawWindow()
  return result
end

-- >> API Functions

-- API function: Sets the value of all variables
-- with the given ID.
function setVariableValue(variableID, newVar)
  VariableValues[variableID] = newVar
end

-- API function: Sets the value of all progressBars
-- with the given ID.
function setProgressBarValue(objID, newVar)
  ProgressBarValues[objID] = newVar
end

-- >> User Input Functions

-- Gets any input of the user
-- (not from the environment)
function getAnyInput()
  local finished = false
  local event = {}
  
  while not finished do
    finished = true
    os.sleep(0)
    
    input = {os.pullEvent()}
    event.eventType = input[1]
    event.dragged = false
    
    if (event.eventType == "monitor_touch" and not outIsTerm) then
      event.eventType = "mouse"
      event.x = input[3]
      event.y = input[4]
      event.mouseButton = 1
    elseif (event.eventType == "mouse_click" and outIsTerm) then
      event.eventType = "mouse"
      event.x = input[3]
      event.y = input[4]
      event.mouseButton = input[2]
    elseif (event.eventType == "mouse_drag") then
      event.eventType = "mouse"
      event.x = input[3]
      event.y = input[4]
      event.mouseButton = input[2]
      event.dragged = true
    elseif (event.eventType == "key") then
      event.key = input[2]
    else
      finished = false
    end
  end
  
  return event
end

-- Returns where the user clicked and which button
-- he pressed (always 1 if it's a monitor).
function getCursorInput(includeDrag)
  local finished = false
  local dragged = false -- Determines whether the event is "mouse_click" or "mouse_drag"
  
  while not finished do
    event, param, x, y = os.pullEvent()
    
    if (event == "monitor_touch" and not outIsTerm) then
      mouseButton = 1
      finished = true
    elseif (event == "mouse_click" and outIsTerm) then
      mouseButton = param
      finished = true
    elseif (event == "mouse_drag" and includeDrag) then
      mouseButton = param
      dragged = true
      finished = true
    end
  end
  
  return x, y, mouseButton, dragged
end

-- Waits until any key gets pressed.
function getKeyInput()
  os.pullEvent("key")
end

function readUserInput(message, isPassword)
  if not outIsTerm then
    print(message)
  end
    
  if isPassword  then
    ret = read("*")
  else
    ret = read()
  end
  
  return ret
end

-- >> Display Functions

-- Has to be used instead of paintutils.drawpixel
function drawPixel(x, y, color)
  assert(x)
  assert(y)
  assert(color)
  
  out.setCursorPos(x, y)
  out.setBackgroundColor(color)
  out.write(" ")
end

function drawBox(x, y, width, height, color)
  out.setBackgroundColor(color)
  
  for row = 1, height do
    out.setCursorPos(x, y + row - 1)
    out.write(string.rep(" ", width))
    
    for col = x, width do
      if (WindowBuffer[col] and WindowBuffer[col][y + row - 1]) then
        WindowBuffer[col][y + row - 1].draw = true
      end
    end
  end
end

-- Displays the text with red background colour.
function drawSimpleButton(x, y, text, backgroundColor, textColor)
  assert(x)
  assert(y)
  assert(text)
  
  backgroundColor = backgroundColor or ObjectColors.Button.default
  textColor = textColor or ObjectColors.Button.text
  
  out.setCursorPos(x, y)
  out.setBackgroundColor(backgroundColor)
  out.setTextColor(textColor)
  out.write(text)
  
  out.setBackgroundColor(ObjectColors.background)
  out.setTextColor(ObjectColors.text)
end

-- Displays the default buttons.
function drawDefaultButtons()
  local window = getCurrentWindow()
  local button
  
  if (window.showRefreshButton) then
    button = DefaultButtons.refresh
    drawSimpleButton(button.left, button.top, button.text, ObjectColors.DefaultButtons.default, ObjectColors.DefaultButtons.text) -- Refresh
  end
  
  if (window.showBackButton) then
    button = DefaultButtons.back
    drawSimpleButton(button.left, button.top, button.text, ObjectColors.DefaultButtons.default, ObjectColors.DefaultButtons.text) -- Back
  end
  
  if (window.showQuitButton ~= false) then 
    button = DefaultButtons.quit
    drawSimpleButton(button.left, button.top, button.text, ObjectColors.DefaultButtons.Quit.default, ObjectColors.DefaultButtons.Quit.text) -- Quit
  end
  
  button = DefaultButtons.options
  if (button.required()) then
    drawSimpleButton(button.left, button.top, button.text, ObjectColors.DefaultButtons.default, ObjectColors.DefaultButtons.text) -- Options
  end
end

-- Displays all objects of the window with the
-- ID windowID on the screen and changes the
-- variable "currentWindow".
function drawWindow(windowID)
  local windowContainer = getWindowContainer()
  
  if windowID and windowContainer and windowContainer.Children[windowID] then
    currentWindow = windowID
  elseif currentWindow then
    windowID = currentWindow
  elseif not showCustomWindow then
    if Windows.startupWindow then
      currentWindow = Windows.startupWindow
    elseif (#Windows.Children ~= 0) then -- Automatically set a startup window.
      for windowName, window in pairs(Windows.Children) do
        Windows.startupWindow = windowName
        currentWindow = windowName
        break
      end
    else -- We have no windows, create the "Main" window.
      Objects.Container.Window.create("Main")
      Windows.Children.Main.isStartupWindow = true
      currentWindow = "Main"
    end
  else
    error("No current window for custom window container " .. showCustomWindow .. " found.", 1)
  end
  
  log("Drawing window \"" .. currentWindow .. "\" with custom window \"" .. tostring(showCustomWindow) .. "\".", "INFO")
  local windowObject = getCurrentWindow()
  
  if windowObject then
    WindowBuffer = Objects.Container.get(windowObject)
    WindowBuffer:draw()
    drawDefaultButtons()
  end
end

-- >> Input Processing

-- Works just like os.pullEvent but it only
-- returns custom Graffiti events.
-- Recommended for API usage.
function pullEvent(requestedEvent)
  if not eventTypeExists(requestedEvent) then
    clearScreen()
    print("Event type " .. tostring(requestedEvent) .. " is invalid!")
    print()
    print("Available event types:")
    
    for _, event in pairs(EventTypes) do
      print("  " .. event)
    end
    
    error()
  end
  
  local finished = false
  local event, params
  
  while not finished do
    event, params = getInput()
    
    if event then
      if (requestedEvent ~= nil) then
        if (requestedEvent == event or event == "quit") then
          finished = true
        end
      else
        finished = true
      end
    end
  end
  
  return event, unpack(params)
end

function getInput()
  log("getInput", "FUNC")
  
  local finished = false
  local event, params
  local x, y, mouseButton, dragged = getCursorInput(true)
  log("Received mouse input. X: " .. x .. ", Y: " .. y .. ", button: " .. mouseButton .. ", dragged: " .. tostring(dragged) .. ".", "INFO")
  
  if not dragged then
    if (defaultButtonPressed("quit", x, y)) then
      log("Quit pressed")
      quit = true
    elseif (defaultButtonPressed("refresh", x, y)) then
      log("Refresh pressed")
      drawWindow()
      finished = true
    elseif (defaultButtonPressed("back", x, y)) then
      log("Back pressed")
      
      local windowObject = getCurrentWindow()
      
      if (windowObject.parent ~= nil) then
        drawWindow(windowObject.parent)
        finished = true
      else
        finished = true
      end
    end
  end
  
  if finished then
    return nil
  elseif quit then
    return "quit", { "Graffiti" } -- Used for the API
  end
  
  local param
  local path = WindowBuffer.bufferTable[x][y].path
  
  if path and #path > 0 then
    local object = Path.getObject(path)
    local clickX, clickY = Path.getRelativePos(path, x, y)
    local modX, modY = Objects.getPosModifier(object)
    clickX, clickY = clickX + (modX * -1), clickY + (modY * -1)
    clickX, clickY = clickX - object.x + 1, clickY - object.y + 1
    
    if dragged then
      event, params = Objects.drag(object, clickX, clickY)
    else
      event, params = Objects.click(object, clickX, clickY)
    end
  end
  
  return event, params
end

-- Shows the message on the computer for debugging.
function debugMessage(message)
  if outIsTerm then
    error("Can't display a debug message on a computer!")
  end
  
  print(message)
end

function splitAt(self, delimiter)
  delimiterPos = string.find(self, delimiter)
  left = string.sub(self, 1, delimiterPos - 1)
  right = string.sub(self, delimiterPos + #delimiter)
  
  return left, right
end

-- >>> Custom Windows

CustomWindows.init = function()
  log("Initializing custom windows...", "INFO")
  
  for windowName, window in pairs(CustomWindows) do
    if (type(window) == "table" and window.init) then
      log("Initializing custom window \"" .. windowName .. "\".", "INFO")
      window.init()
    end
  end
  
  showCustomWindow = nil
  currentWindow = nil
end

CustomWindows.draw = function(containerName, windowName)
  assert(containerName)
  assert(windowName)
  
  log("Drawing custom window \"" .. windowName .. "\" from container \"" .. containerName .. "\".", "INFO")
  
  showCustomWindow = containerName
  drawWindow(windowName)
  local result = nil
  
  while result == nil do
    local event, params = getInput()
    
    if (event == "button_clicked") then
      local objID = params[1]
      
      if (objID == "apply") then
        result = true
      elseif (objID == "cancel") then
        result = false
      end
    elseif (event == "quit") then
      result = true
      quit = false
    end
  end
  
  clearScreen()
  showCustomWindow = nil
  
  return result
end

-- >> Editor Windows
CustomWindows.Editor = {}

CustomWindows.Editor.init = function()
  showCustomWindow = "Editor"
  CustomWindows.Editor.Children = {}
  
  -- Main window
  Objects.Container.Window.create("Main")
  currentWindow = "Main"
  
  Objects.createCustom("ScrollView", 2, 2, { objID="windowListContainer", width=30, height=maxY-2, scrollXEnabled=true, scrollYEnabled=true } )
  Objects.createCustom("List", 4, 4, { objID="WindowList", items={}, load=CustomFunctions.Editor.getWindowList, isMultiselect=false } )
  
  Objects.createCustom("Panel", 34, 2, { objID="newWindow", width=15, height=7 } )
  Objects.createCustom("Input", 36, 4, { objID="newWindow", message="Enter a name for the new window." } )
  Objects.createCustom("Button", 36, 6, { objID="newWindow", width=8, height=1, text="New", funcType="function" } )
  Objects.createCustom("Button", 36, 7, { objID="renameWindow", width=8, height=1, text="Rename", funcType="function" } )
  
  Objects.createCustom("Button", 34, 10, { objID="editWindow", width=17, height=1, text="Edit", funcType="function" } )
  Objects.createCustom("Button", 34, 12, { objID="deleteWindow", width=17, height=1, text="Delete", funcType="function" } )
  Objects.createCustom("Button", 34, 14, { objID="setParent", width=17, height=1, text="Set parent", funcType="function" } )
  Objects.createCustom("Button", 34, 16, { objID="setStartup", width=17, height=1, text="Startup window", funcType="function" } )
end

CustomFunctions.Editor = {}

CustomFunctions.Editor.getWindowList = function()
  local ret = {}
  
  for key, value in pairs(Windows.Children) do
    table.insert(ret, key)
  end
  
  table.sort(ret)
  
  return ret
end

CustomFunctions.Editor.getWindowListObject = function()
  return CustomWindows.Editor.Children.Main.Children[1].Children[1]
end

CustomFunctions.Editor.editLastWindow = function()
  
  if not lastWindow then
    if Windows.startupWindow then
      showCustomWindow = nil
      lastWindow = Windows.startupWindow
    else
      return
    end
  end
  
  changeButtonColor = false
  drawWindow(lastWindow)
end

-- Creates a new window. The user has to enter the window name in the computer.
CustomFunctions.Editor.newWindow = function()
  local windowName = ObjectData.Input["newWindow"]
  local list = CustomFunctions.Editor.getWindowListObject()
  
  if (windowName == nil or windowName == "") then
    return
  elseif (Windows.Children[windowName] == nil) then
    showCustomWindow = nil
    Objects.Container.Window.create(windowName)
    changeButtonColor = false
    showCustomWindow = "Editor"
  end
  
  ListEditorList = list.Items
  ObjectData.Input["newWindow"] = ""
  drawWindow()
end

CustomFunctions.Editor.renameWindow = function()
  local newWindowName = ObjectData.Input["newWindow"]
  local list = CustomFunctions.Editor.getWindowListObject()
  local key = Objects.List.getFirstSelectedValue(list)
  
  if (value and not table.contains(windowList, newWindowName)) then
    local oldWindowName = value
    
    Files.rename({ Files.Project.subDir, currentProject }, oldWindowName .. Files.Project.extension, newWindowName .. Files.Project.extension)
    Windows.Children[newWindowName] = Windows.Children[oldWindowName]
    Windows.Children[oldWindowName] = nil
  end
  
  drawWindow()
end

-- Edits the first selected window.
CustomFunctions.Editor.editWindow = function()
  local list = CustomFunctions.Editor.getWindowListObject()
  local key = Objects.List.getFirstSelectedKey(list)
  
  if not key then
    return
  end
  
  showCustomWindow = nil
  lastWindow = list.Items[key]
  changeButtonColor = false
  drawWindow(lastWindow)
end

-- Deletes the selected window(s).
CustomFunctions.Editor.deleteWindow = function()
  local list = CustomFunctions.Editor.getWindowListObject()
  
  for key, selected in pairs(ObjectData.List[list.objID]) do
    if (selected == true) then
      local windowName = list.Items[key]
      Files.remove(Files.Project.subDir, fs.combine(currentProject, windowName .. Files.Project.extension))
      Windows.Children[windowName] = nil
    end
  end
  
  drawWindow()
  ListEditorList = list.Items
end

-- Sets the first selected window as the one that
-- should be displayed on startup.
CustomFunctions.Editor.setStartup = function()
  local list = CustomFunctions.Editor.getWindowListObject()
  local key = Objects.List.getFirstSelectedKey(list)
  local selectedWindowName = list.Items[key]
  
  for windowName, window in pairs(Windows.Children) do
    window.isStartupWindow = (windowName == selectedWindowName)
  end
end

-- Let's the user define the parent-attribute of the current window.
CustomFunctions.Editor.setParent = function()
  local list = CustomFunctions.Editor.getWindowListObject()
  local selected = Objects.List.getFirstSelectedKey(list)
  local buffer = Objects.Line.get("vertical", list.height, ObjectColors.background, {1, 99})
  
  local x, y, mouseButton = getCursorInput()
  local modX, modY = Objects.getPosModifier(list)
  x, y = x + (modX * -1), y + (modY * -1)
  local selectedParent = y - list.absoluteY + 1
  
  if (selectedParent >= 1 and selectedParent <= list.height) then -- Clicked inside the list.
    if (selectedParent ~= selected) then -- Selected parentWindow is not selected window.
      Windows.Children[list.Items[selected]].parent = list.Items[selectedParent]
    end
  end
  
  for i = 1, list.height do
    drawPixel(1, i + list.absoluteY - 1, ObjectColors.background)
  end
end

-- >> List Editor Windows
CustomWindows.ListEditor = {}

CustomWindows.ListEditor.init = function()
  showCustomWindow = "ListEditor"
  CustomWindows.ListEditor.Children = {}
  
  Objects.Container.Window.create("Main")
  CustomWindows.ListEditor.Children["Main"].showQuitButton = false
  currentWindow = "Main"
  
  Objects.createCustom("ScrollView", 2, 2, { objID="listContainer", width=22, height=maxY - 3, scrollXEnabled=true, scrollYEnabled=true } )
  Objects.createCustom("List", 4, 4, { objID="itemList", isMultiselect=true, items={}, load=CustomFunctions.ListEditor.getListEditorItems } )
  
  Objects.createCustom("Panel", 26, 2, { objID="newEntryPanel", width=16, height=7 } )
  Objects.createCustom("Input", 28, 4, { objID="newEntry" } )
  Objects.createCustom("Button", 28, 6, { objID="newEntry", width=11, height=1, text="New", funcType="function" } )
  Objects.createCustom("Button", 28, 7, { objID="renameEntry", width=11, height=1, text="Rename", funcType="function" } )
  
  Objects.createCustom("Text", 26, 11, { objID="editEntryText",   text="Edit entries" } )
  Objects.createCustom("Panel", 26, 12, { objID="editEntryPanel", width=16, height=8 } )
  Objects.createCustom("Button", 28, 14, { objID="moveEntryUp",   width=11, height=1, text="Move up", funcType="function" } )
  Objects.createCustom("Button", 28, 15, { objID="moveEntryDown", width=11, height=1, text="Move down", funcType="function" } )
  Objects.createCustom("Button", 28, 17, { objID="removeEntry",   width=11, height=1, text="Remove", funcType="function" } )
  
  Objects.createCustom("Button", 43, 12, { objID="apply", width=8, height=3, text="OK", funcType="function" } )
  Objects.createCustom("Button", 43, 16, { objID="cancel", width=8, height=3, text="Cancel", funcType="function" } )
end

CustomFunctions.ListEditor = {}

CustomFunctions.ListEditor.getListEditorItems = function()
  local tempList = {}
  
  for _, value in ipairs(ListEditorList) do
    table.insert(tempList, value)
  end
  
  return tempList
end

CustomFunctions.ListEditor.newEntry = function()
  local input = ObjectData.Input["newEntry"]
  
  if (input == nil or input == "") then
    return
  end
  
  table.insert(ListEditorList, input)
  ObjectData.Input["newEntry"] = nil
  drawWindow()
end

CustomFunctions.ListEditor.renameEntry = function()
  local selectedItems = ObjectData.List["itemList"]
  local input = ObjectData.Input["newEntry"]
  
  if (input == nil or input == "") then
    return
  end
  
  for key, value in pairs(selectedItems) do
    if value then -- Item is selected
      ListEditorList[key] = input
    end
  end
  
  ObjectData.Input["newEntry"] = nil
  drawWindow()
end

CustomFunctions.ListEditor.moveEntryUp = function()
  if not ObjectData.List["itemList"] then
    return
  end
  
  local lastIndex = nil
  local selectedItems = ObjectData.List["itemList"]
  local lock = nil
  
  for key, value in pairs(ListEditorList) do
    local selected = selectedItems[key] == true
    
    if lastIndex then
      if selected then
        if (lock ~= lastIndex) then
          selectedItems[lastIndex], selectedItems[key] = 
              selectedItems[key], selectedItems[lastIndex]
          
          ListEditorList[lastIndex], ListEditorList[key] = 
              ListEditorList[key], ListEditorList[lastIndex]
        else
          lock = key
        end
      end
    elseif selected then
      lock = key
    end
    
    lastIndex = key
  end
  
  drawWindow()
end

CustomFunctions.ListEditor.moveEntryDown = function()
  if not ObjectData.List["itemList"] then
    return
  end
  
  local lastIndex = nil
  local selectedItems = ObjectData.List["itemList"]
  local lock = nil
  
  for key = #ListEditorList, 1, -1 do
    local selected = selectedItems[key] == true
    
    if lastIndex then
      if selected then
        if (lock ~= lastIndex) then
          selectedItems[lastIndex], selectedItems[key] = 
              selectedItems[key], selectedItems[lastIndex]
          
          ListEditorList[lastIndex], ListEditorList[key] = 
              ListEditorList[key], ListEditorList[lastIndex]
        else
          lock = key
        end
      end
    elseif selected then
      lock = key
    end
    
    lastIndex = key
  end
  
  drawWindow()
end

CustomFunctions.ListEditor.removeEntry = function()
  local selectedItems = ObjectData.List["itemList"]
  local ret = {}
  
  for key, value in pairs(ListEditorList) do
    local selected = (selectedItems[key] == true)
    
    if not selected then
      table.insert(ret, ListEditorList[key])
    end
  end
  
  ObjectData.List["itemList"] = {}
  ListEditorList = ret
  
  drawWindow()
end

-- >> Setup Windows
CustomWindows.Setup = {}

CustomWindows.Setup.init = function()
  showCustomWindow = "Setup"
  CustomWindows.Setup.Children = {}
  
  Objects.Container.Window.create("Main")
  currentWindow = "Main"
  
  Objects.createCustom("Text", 2, 2, { objID="welcomeText", text=Text.setupText1 } )
  Objects.createCustom("Text", 2, 3, { objID="welcomeText", text=Text.setupText2 } )
  Objects.createCustom("Text", 2, 5, { objID="welcomeText", text=Text.setupText3 } )
  Objects.createCustom("Text", 2, 6, { objID="welcomeText", text=Text.setupText4 } )
  Objects.createCustom("Text", 2, 7, { objID="welcomeText", text=Text.setupText5 } )
  
  Objects.createCustom("Button", 2, 9, { objID="nextWindow", text=Text.next, width=6, height=3, funcType="switch", window="Setup1" } )
  Objects.createCustom("Button", 2, 13, { objID="cancel", text=Text.skipSetup, width=36, height=3, funcType="function" } )
  
  Objects.Container.Window.create("Setup1")
  CustomWindows.Setup.Children["Setup1"].showBackButton = true
  CustomWindows.Setup.Children["Setup1"].parent = "Main"
  currentWindow = "Setup1"
  
  Objects.createCustom("Text", 2, 2, { objID="chooseSettings", text=Text.chooseSettings1 } )
  
  Objects.createCustom("Text", 2, 4, { objID="chooseLanguage", text=Text.language .. ":" } )
  Objects.createCustom("ScrollView", 2, 5, { objID="Language", width=14, height=maxY - 6, scrollXEnabled=true, scrollYEnabled=true } )
  CustomWindows.Setup.languageList = Objects.createCustom("List", 4, 7, { objID="languages", load=CustomFunctions.Setup.getLanguageList } )
  
  Objects.createCustom("Text", 17, 4, { objID="chooseColorTheme", text=Text.colorTheme .. ":" } )
  Objects.createCustom("ScrollView", 17, 5, { objID="colorTheme", width=14, height=maxY - 6, scrollXEnabled=true, scrollYEnabled=true } )
  CustomWindows.Setup.colorThemeList = Objects.createCustom("List", 19, 7, { objID="colorTheme", load=CustomFunctions.Setup.getColorThemeList } )
  
  Objects.createCustom("RadioButton", 34, 4, { objID="showDataFolder", text=Text.showDataFolder, defaultIsChecked=true } )
  Objects.createCustom("RadioButton", 34, 6, { objID="hideDataFolder", text=Text.hideDataFolder } )
  
  Objects.createCustom("Button", 34, 16, { objID="apply", text=Text.finished, width=15, height=3, funcType="function" } )
end

CustomFunctions.Setup = {}

CustomFunctions.Setup.getLanguageList = function()
  local ret = {}
  
  for key, value in pairs(Languages) do
    table.insert(ret, key)
  end
  
  table.sort(ret)
  
  return ret
end

CustomFunctions.Setup.getColorThemeList = function()
  local ret = {}
  
  for key, value in pairs(ColorThemes) do
    table.insert(ret, key)
  end
  
  table.sort(ret)
  
  return ret
end

-- Runs the setup.
function runSetup(useDefaultSettings)
  if not useDefaultSettings then
    initDefaultButtons()
    CustomWindows.Setup.init()
    CustomWindows.draw("Setup", "Main")
  end
  
  local languageListObject = CustomWindows.Setup.languageList
  local colorThemeListObject = CustomWindows.Setup.colorThemeList
  
  local selectedLanguage = Objects.List.getFirstSelectedValue(languageListObject)
  local selectedColorTheme = Objects.List.getFirstSelectedValue(colorThemeListObject)
  
  if selectedLanguage and Languages[selectedLanguage] then
    Settings.language = selectedLanguage
  end
  
  if (selectedColorTheme and ColorThemes[selectedColorTheme]) then
    Settings.colorTheme = selectedColorTheme
  end
  
  Settings.hideDataFolder = ObjectData.RadioButton["hideDataFolder"] == true
  
  dataFolderPath = fs.combine(root, (Settings.hideDataFolder and ".GraffitiData" or "GraffitiData"))
  
  if not fs.exists(dataFolderPath) then
    fs.makeDir(dataFolderPath)
  end
  
  Files.save()
end

-- Shows lines marking the top left part of an
-- object as well as well as pixels displaying
-- the alignment of an object.
function drawAlignmentLines(object, left, top, right, bottom)
  local color = ObjectColors.Editor.marker
  local moveX, moveY = Objects.getMovePos(object)
  
  -- Draw the lines.
  Objects.Line.draw(left - 1, moveY, "left", left - 2, color) -- left
  Objects.Line.draw(moveX, top -1, "up", top - 2, color) -- up
  Objects.Line.draw(right + 1, moveY, "right", maxX - (right + 1), color) -- right
  Objects.Line.draw(moveX, bottom + 1, "down", maxY - (bottom + 1), color) -- down
  
  -- Display the alignment-pixels.
  horizontalAlignment = object.horizontalAlignment
  verticalAlignment = object.verticalAlignment
  
  if (horizontalAlignment == "left" or horizontalAlignment == "stretch") then -- left
    drawPixel(1, moveY, ObjectColors["Editor"].alignmentTrue)
  else
    drawPixel(1, moveY, ObjectColors["Editor"].alignmentFalse)
  end
  
  if (horizontalAlignment == "right" or horizontalAlignment == "stretch") then -- right
    drawPixel(maxX, moveY, ObjectColors["Editor"].alignmentTrue)
  else
    drawPixel(maxX, moveY, ObjectColors["Editor"].alignmentFalse)
  end
  
  if (verticalAlignment == "top" or verticalAlignment == "stretch") then -- top
    drawPixel(moveX, 1, ObjectColors["Editor"].alignmentTrue)
  else
    drawPixel(moveX, 1, ObjectColors["Editor"].alignmentFalse)
  end
  
  if (verticalAlignment == "bottom" or verticalAlignment == "stretch") then -- bottom
    drawPixel(moveX, maxY, ObjectColors["Editor"].alignmentTrue)
  else
    drawPixel(moveX, maxY, ObjectColors["Editor"].alignmentFalse)
  end
  
  out.setBackgroundColor(ObjectColors.background)
end

-- Returns the values of horizontalAlignment and
-- verticalAlignment depending which sides are set
-- to true.
function getAlignment(left, top, right, bottom)
  local retHorizontal, retVertical = "left", "top"
  
  if right then
    if left then
      retHorizontal = "stretch"
    else
      retHorizontal = "right"
    end
  else
    retHorizontal = "left"
  end
  
  if bottom then
    if top then
      retVertical = "stretch"
    else
      retVertical = "bottom"
    end
  else
    retVertical = "top"
  end
  
  return retHorizontal, retVertical
end

function markSelectedObject()
  if not selectedObject then
    return
  end
  
  Objects.draw(selectedObject, nil, true) -- Draw the object with its markers.
  
  local moveX, moveY = Objects.getMovePos(selectedObject)
  drawPixel(moveX, moveY, (currentEditorAction == "Move" and not selectedObjectDragged) and ObjectColors.Editor.active or ObjectColors.Editor.move)
  
  if selectedObject.canScale then
    local scaleX, scaleY = Objects.getScalePos(selectedObject)
    drawPixel(scaleX, scaleY, (currentEditorAction == "Scale" and not selectedObjectDragged) and ObjectColors.Editor.active or ObjectColors.Editor.scale)
  end
  
  out.setBackgroundColor(ObjectColors.background)
end

-- Let's the user delete an object or change its attributes depending on the current edit-mode.
function editObject(object, x, y, dragged)
  assert(object)
  log("Editing " .. object.objType .. ", ID: " .. object.objID .. ", x: " .. x .. ", y: " .. y .. ", dragged: " .. tostring(dragged) .. ".")
  
  local relX, relY = Path.getRelativePos(object.path, x, y)
  local modX, modY = Objects.getPosModifier(object)
  local left, top, right, bottom = Objects.getDimensions(object)
  left, top, right, bottom = left + modX, top + modY, right + modX, bottom + modY
  
  local moveX, moveY = Objects.getMovePos(object)
  
  local scaleX, scaleY
  if object.canScale then
    scaleX, scaleY = Objects.getScalePos(object)
  end
  
  if currentEditorAction then
    if (currentEditorAction == "Move") then
      addX = x - moveX
      addY = y - moveY
      Objects.move(object, addX, addY)
    elseif (currentEditorAction == "Scale") then
      Objects.scale(object, relX + (modX * -1), relY + (modY * -1))
    else
      error("Unknown editor action \"" .. tostring(currentEditorAction) .. "\".", 1)
    end
    
    if dragged then
      selectedObjectDragged = true
    else
      currentEditorAction = nil
    end
  else
    if (x == moveX and y == moveY) then
      currentEditorAction = "Move"
    elseif (object.canScale and x == scaleX and y == scaleY) then
      currentEditorAction = "Scale"
    else
      relX, relY = relX - object.x + 1, relY - object.y + 1
      
      if not (Objects.editorClick(object, relX + modX, relY + modY)) then
        if (not outIsTerm and Objects.Selector.draw(x, y, RightClickActions)) then
          if (selectedItem == "Attributes") then
            Objects.editAttributes(object)
          elseif (selectedItem == "Delete") then
            Objects.remove(object, "Delete")
            drawWindow()
          end
        end
      end
    end
  end
  
  out.setBackgroundColor(ObjectColors.background)
  drawWindow()
end

function markVariables(container)
  assert(container)
  
  for _, object in pairs(container.Children) do
    if (object.isContainer) then
      markVariables(object)
    elseif (object.objType == "Variable") then
      local x, y = Objects.getAbsolutePos(object)
      drawPixel(x, y, ObjectColors.Editor.marker)
      out.setBackgroundColor(ObjectColors.background)
    end
  end
end

function markDefaultButtons()
  local window = getCurrentWindow()
  
  -- refresh button
  local refresh = DefaultButtons.refresh
  out.setCursorPos(refresh.left, refresh.top)
  if (window.showRefreshButton) then
    out.setBackgroundColor(ObjectColors.Button.default)
    out.write(refresh.text)
  else
    out.setBackgroundColor(ObjectColors.Editor.marker)
    out.write(string.rep(" ", #refresh.text))
  end
  
  -- back button
  local back = DefaultButtons.back
  out.setCursorPos(back.left, back.top)
  if (window.showBackButton) then
    out.setBackgroundColor(ObjectColors.Button.default)
    out.write(back.text)
  else
    out.setBackgroundColor(ObjectColors.Editor.marker)
    out.write(string.rep(" ", #back.text))
  end
  
  out.setBackgroundColor(ObjectColors.background)
end

function getEditorInput()
  log("getEditorInput", "FUNC")
  
  local event
  local x, y, mouseButton, dragged
  
  if showCustomWindow ~= "Editor" then
    drawWindow()
    markDefaultButtons()
    markSelectedObject()
    
    event = getAnyInput()
    
    if (event.eventType == "mouse") then
      x, y, mouseButton, dragged = event.x, event.y, event.mouseButton, event.dragged
      log("Received mouse input. X: " .. x .. ", Y: " .. y .. ", button: " .. mouseButton .. ".")
    end
  end
  
  if (showCustomWindow ~= "Editor" and event.eventType == "key") then
    callShortcut(event.key)
  elseif (showCustomWindow == "Editor" or defaultButtonPressed("options", x, y)) then
    selectedObject = nil
    showCustomWindow = "Editor"
    drawWindow("Main")
    
    while showCustomWindow == "Editor" and not quit do
      getInput()
    end
  elseif (not dragged and defaultButtonPressed("quit", x, y)) then
    quit = true
  elseif (not dragged and defaultButtonPressed("refresh", x, y)) then
    Windows.Children[currentWindow].showRefreshButton = not Windows.Children[currentWindow].showRefreshButton
  elseif (not dragged and defaultButtonPressed("back", x, y)) then
    Windows.Children[currentWindow].showBackButton = not Windows.Children[currentWindow].showBackButton
  else
    if dragged then
      if (selectedObject == nil) then
        return
      else
        editObject(selectedObject, x, y, dragged)
      end
    else
      if selectedObjectDragged then
        selectedObjectDragged = false
        currentEditorAction = nil
      end
      
      local container = getCurrentWindow()
      local path = WindowBuffer.bufferTable[x][y].path
      
      if (path == nil or #path == 0) then -- No object touched.
        if selectedObject then
          if currentEditorAction then
            editObject(selectedObject, x, y)
          end
          
          selectedObject = nil
        else
          drawPixel(x, y, ObjectColors.Editor.new)
          if (Objects.Selector.draw(x, y, ObjectTypes)) then -- Draw selector for new object.
            Objects.create(selectedItem, x, y)
          end
        end
      else
        local object = Path.getObject(path)
        
        if (mouseButton == 1) then
          if (selectedObject and Objects.isClicked(selectedObject, x, y)) then
            editObject(selectedObject, x, y, dragged)
          else
            selectedObject = object
          end
        else
          if selectedObject then
            selectedObject = nil
          elseif (Objects.Selector.draw(x, y, RightClickActions)) then
            if (selectedItem == "Attributes") then
              Objects.editAttributes(object)
            elseif (selectedItem == "Delete") then
              Objects.remove(object, "Delete")
            end
          end
        end
      end
    end
  end
end

-- Runs Graffiti in editMode.
function windowEditor()
  editMode = true
  
  showCustomWindow = "Editor"
  
  while not quit do
    getEditorInput()
  end
end

function round(number)
  assert(number)
  comma = number % 1
  if comma < 0.5 then
    ret = math.floor(number)
  else
    ret = math.ceil(number)
  end
  
  return ret
end

function printInfo()
  print()
  print(version)
  print("Author: Encreedem")
  print()
  print("Param(s):")
  print("info - Shows some info about the program... but I guess you know that already.")
  print("edit - Starts the program in edit-mode.")
  print()
  print("Visit the CC-forums or my YouTube channel (Encreedem CP) for news and help.")
end

-- Gets called when Graffiti gets the argument "test"
function testMethod()
  error("Nothing to test...", 2)
end

-- >>> initialization

-- Sets the "startupWindow" variable to the first
-- window with enabled "isStartupWindow" attribute.
function getStartupWindow()
  for windowName, window in pairs(Windows.Children) do
    if window.isStartupWindow then
      startupWindow = windowName
      return
    end
  end
end

-- Initializes the default buttons.
-- (Quit, Back, Refresh, Options)
function initDefaultButtons()
  DefaultButtons.quit = {
    text=Text.quit,
    left=maxX - string.len(Text.quit) + 1,
    top=1,
    right=maxX,
    bottom=1,
    required = function()
      return getCurrentWindow().showQuitButton ~= false
    end
  }
  
  DefaultButtons.back = {
    text = Text.back,
    left = 1,
    top = 1,
    right = string.len(Text.back),
    bottom = 1,
    required = function()
      return getCurrentWindow().showBackButton
    end
  }
  
  DefaultButtons.refresh = {
    text = Text.refresh,
    left = maxX - string.len(Text.refresh) + 1,
    top = maxY,
    right = maxX,
    bottom = maxY,
    required = function()
      return (getCurrentWindow().showRefreshButton or (editMode and not showEdtorOptions))
    end
  }
  
  DefaultButtons.options = {
    text = Text.options,
    left = 1,
    top = maxY,
    right = string.len(Text.options),
    bottom = maxY,
    required=function()
      return (editMode and showCustomWindow ~= "Editor")
    end
  }
end

-- Initializes all windows to allow Graffiti to
-- use them as if they were objects.
function initWindows()
  for _, window in pairs(Windows.Children) do
    window.width, window.height = maxX, maxY
  end
end

-- Tells the user that the monitor or computer
-- doesn't support colors.
function showColorWarning()
  out.clear()
  out.setCursorPos(2, 2)
  out.write("This computer/monitor does not support colors!")
  
  local state = 0
  local move = "I don't know this move!"
  local finished = false
  while not finished and not quit do
    out.setCursorPos(1, 4)
    out.clearLine()
    out.setCursorPos(2, 4)
    
    if (state == 0) then
      move = "<( \" <) <( \" <) <( \" <)"
    elseif (state == 1 or state == 3 or state == 5) then
      move = "  (^\"^)   (^\"^)   (^\"^)"
    elseif (state == 2) then
      move = "  (> \" )> (> \" )> (> \" )>"
    elseif (state == 4) then
      move = " (> \" )><( \" )><( \" <)"
    elseif (state == 6) then
      move = "<( \" <) (>\"<) (> \" )>"
    elseif (state == 7) then
      move = " (v''v) (v''v) (v''v)"
    else
      error("Unable to show you that you need an advanced computer/monitor in a fancy way!")
    end
    
    out.write(move)
    state = (state + 1) % 8
    os.sleep(0.25)
  end
end

-- Checks if the monitor on monitorSide exists and wraps it into "monitor".
function getOutput()
  if (monitor == nil and outIsTerm == false) then
    local monitorFound = false
    for _, side in pairs(Sides) do
      if (peripheral.getType(side) == "monitor") then
        monitor = peripheral.wrap(side)
        monitorFound = true
        out = monitor
        outIsTerm = false
      end
    end
    
    if not monitorFound then
      out = term
      outIsTerm = true
    end
  elseif outIsTerm then
    out = term
  else
    out = monitor
  end
end

-- Initializes Graffitis' variables.
function init()
  getOutput()
  
  maxX, maxY = out.getSize()
  if (maxX < 16 or maxY < 10) then -- smaller than 2x2
    print("Screen too small! You need at least 2x2 monitors!")
    return false
  elseif not out.isColor() then
    parallel.waitForAny(showColorWarning, getKeyInput)
    clearScreen()
    return false
  end
  
  isAPI = (shell == nil)
  
  initDone = true
  return true
end

function checkArgs()
  doCall = main
  arg = Args[1]
  
  if (arg ~= nil) then
    if (arg == "edit") then
      doCall = windowEditor
    elseif (arg == "info") then
      doCall = printInfo
    elseif (arg == "term") then
      outIsTerm = true
    elseif (arg == "test") then
      doCall = testMethod
    end
  end
  
  doCall()
end

-- Calls the "getInput" function until the user presses the quit-button.
function main()
  drawWindow(startupWindow)
  
  while not quit do
    getInput()
  end
end

if init() then
  Files.init()
  Files.clear(Files.Log.subDir, Files.Log.name)
  logFileLoaded = true
  log("Graffiti initialized.")
  
  getStartupWindow()
  initWindows()
  CustomWindows.init()
  initDefaultButtons()
  Objects.init()
  
  if not isAPI then
    checkArgs() -- Calls the "main" function. Everything below happens after closing Graffiti.
    
    -- Closing Program
    if editMode and saveAfterQuit then
      Files.save()
    end
    
    out.setBackgroundColor(colors.black)
    out.setTextColor(colors.white)
    out.clear()
    out.setCursorPos(1, 1)
  else
    log("Graffiti loaded as an API.")
  end
else
  error("Graffiti Initialization failed!")
end