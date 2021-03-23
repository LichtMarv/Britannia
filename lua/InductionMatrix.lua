-- Power Monitor for induction matrix
--
-- Written and copyrighted 2016+
-- by Sven Marc 'cybrox' Gehring
-- Licensed under MIT license




-- Printing right aligned text on a line
-- This is used for printing our dynamic
-- values to the screen properly
--
-- @param line The line to print on
-- @param text The text to print there
-- @param color The color to print in
-- @return void
function putValue (line, text, color)
    local align = 30 - string.len(text)
    term.setCursorPos(align, line)
    term.setTextColor(color)
    print(text)
  end
  
  
  -- Get a number in a human readable format
  -- This is used to display numbers on screen
  --
  -- @param number The number to format
  -- @return The formatted number
  function putNumber (number)
    local round = 0
    local texts = ""
  
    if number >= 1000000000000000000 then
      round = (number / 1000000000000000000)
      texts = string.sub(round, 0, 5) .. " ERF"
    else
      if number >= 1000000000000000 then
        round = (number / 1000000000000000)
        texts = string.sub(round, 0, 5) .. " PRF"
      else
        if number >= 1000000000000 then
          round = (number / 1000000000000)
          texts = string.sub(round, 0, 5) .. " TRF"
        else
          if number >= 1000000000 then
            round = (number / 1000000000)
            texts = string.sub(round, 0, 5) .. " GRF"
          else
            if number >= 1000000 then
              round = (number / 1000000)
              texts = string.sub(round, 0, 5) .. " MRF"
            else
              if number >= 1000 then
                round = (number / 1000)
                texts = string.sub(round, 0, 5) .. " kRF"
              else
                texts = string.sub(number, 0, 5) .. "  RF"
              end
            end
          end
        end
      end
    end
  
    return texts
  end
  
  
  
  
  -- Initialize our interface!
  -- Find all of our peripherals
  monitor = peripheral.wrap("back")
  battery = peripheral.wrap("mekanism:induction_port_0")
  
  -- Check and bind monitor
  if monitor == nil then
    error("ER: No screen found to display!")
  else
    monitor.clear()
    term.redirect(monitor)
    term.setCursorPos(1, 1)
    term.setBackgroundColor(colors.black)
  end
  
  -- Check if we have a battery
  if battery == nil then
    error("ER: No battery connected to computer")
  end
  
  -- Draw our static fill volume box
  term.setTextColor(colors.white)
  term.setCursorPos(2, 2)
  print("+------+")
  term.setCursorPos(2, 11)
  print("+------+")
  for i = 3, 10 do
    term.setCursorPos(2, i)
    print("|")
    term.setCursorPos(9, i)
    print("|")
  end
  
  -- Draw our static interface text
  term.setCursorPos(11, 2);
  print("Max RF:")
  term.setCursorPos(11, 3);
  print("Max Thru:")
  
  term.setCursorPos(11, 5);
  print("Cur In:")
  term.setCursorPos(11, 6);
  print("Cur Out:")
  term.setCursorPos(11, 7);
  print("Cur Bal:")
  
  term.setCursorPos(11, 9);
  print("Stored:")
  term.setCursorPos(11, 10);
  print("Filled:")
  term.setCursorPos(11, 11);
  print("Critical:")


  print(battery.getEngery())
  print(battery.getEngeryCapacity())
  print(battery.list())
  print(battery.size())
  print(battery.tanks())
  
  -- Entering our infinite loop of checking the battery
  -- This will refresh all information every 2 seconds
  alarmIsRinging = false
  alarmIsActive = falselu
  alarmCounter = 0
  
  while true do
  
    -- Get our fixed battery values
    batteryMaxCharge = battery.getEngeryCapacity()
    batteryMaxInOuts = battery.getTransferCap()
    putValue(2, putNumber(batteryMaxCharge), colors.lightBlue)
    putValue(3, putNumber(batteryMaxInOuts), colors.lightBlue)
  
    -- Get our input/output/balance battery values
    batteryCurrentIn = battery.getLastInput()
    batteryCurrentOut = battery.getLastOutput()
    putValue(5, putNumber(batteryCurrentIn), colors.lightBlue)
    putValue(6, putNumber(batteryCurrentOut), colors.lightBlue)
  
    batteryCurrentBalance = batteryCurrentIn - batteryCurrentOut
    batteryCurrentColor = (batteryCurrentBalance >= 0) and colors.green or colors.red
    batteryCurrentSign = (batteryCurrentBalance >= 0) and "+" or ""
    putValue(7, batteryCurrentSign .. putNumber(batteryCurrentBalance), batteryCurrentColor)
  
    -- Get our statistical values
    batteryCurrentCharge = battery.getStored()
    putValue(9, putNumber(batteryCurrentCharge), colors.lightBlue)
  
    batteryCurrentColor = colors.red
    batteryCurrentPercentage = ((batteryCurrentCharge / batteryMaxCharge) * 100)
    if batteryCurrentPercentage > 30 then batteryCurrentColor = colors.orange end
    if batteryCurrentPercentage > 60 then batteryCurrentColor = colors.green end
    putValue(10, string.sub(putNumber(batteryCurrentPercentage), 0, 4) .. "%", batteryCurrentColor)
  
    batteryCurrentCritical = "Yes"
    batteryCurrentColor = colors.red
    if batteryCurrentPercentage > 15 then
      batteryCurrentCritical = "No"
      batteryCurrentColor = colors.green
    end
    putValue(11, batteryCurrentCritical, batteryCurrentColor)
  
    -- Draw the current charge graph
    batteryCurrentColor = colors.red
    if batteryCurrentPercentage > 30 then term.setTextColor(colors.orange) end
    if batteryCurrentPercentage > 60 then term.setTextColor(colors.green) end
    if batteryCurrentPercentage >= 100 then term.setTextColor(colors.lightBlue) end
  
    for i = 3, 10 do
      term.setCursorPos(3, i)
      print("      ")
    end
  
    iterator = 0
    for i = 3, 10 do
      local compare = (12.5 * iterator)
      if (batteryCurrentPercentage >= compare) then
        term.setCursorPos(3, (13 - i))
        local filler = ""
        for i = 1, 6 do
          local inhere = (compare + (i*2))
          if batteryCurrentPercentage >= inhere then
            filler = filler .. "#"
          else
            if batteryCurrentPercentage >= (inhere - 1) then
              filler = filler .. "="
            else
              filler = filler .. "_"
            end
          end
        end
        print(filler)
      end
  
      iterator = iterator + 1
    end
  
    -- Hey, ring the alarm!
    if batteryCurrentPercentage > 10 then
      alarmIsRinging = false
      alarmIsActive = false
    end
  
    if batteryCurrentPercentage < 10 and alarmIsActive == false then
      alarmIsRinging = true
      alarmIsActive = true
      alarmCounter = 0
      redstone.setOutput("left", true)
    end
  
    if alarmIsRinging == true then
      alarmCounter = alarmCounter + 1
      if alarmCounter >= 10 then
        redstone.setOutput("left", false)
        alarmIsRinging = false
      end
    end
  
    -- Wait 2s until next iteration
    os.sleep(2)
  
  end