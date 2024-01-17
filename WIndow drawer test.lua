-- If specified window size is 0, automatically set to the size of the terminal window.

-- Expected values: windowTitle (a string for the titlebar), windowContent (a string for the window contents), windowHeight (an integer for the height of the window), windowLength (an integer for the length of the window).
-- Window types: Master, Pop-up, Progress, Erorr, Info, Question, and more tbd.

-- TODO: Add buttons to dismiss popup and error windows. Have a way for the program to know the previously drawn window and redraw it.

function drawWindow(windowTitle, windowContent, type, windowHeight, windowLength, dialogueString, windowPriority)
term.setBackgroundColour(colours.black)
popupWindow = false
buttonColour = colours.white
    if type == nil then
        print("Window type not specified or unsupported, please choose a window type.")
    elseif type == "master" then
        -- Only clear the screen when drawing the main control window! Otherwise popups will be the only visible UI elements.
        term.clear()
        -- Window colours
        titlebarColour = colours.lightBlue
        windowColour = colours.white
        textColour = colours.black
        dropshadowColour = colours.grey
    elseif type == "popup" then
        -- Dont clear the screen
        -- Window colours
        titlebarColour = colours.lightBlue
        windowColour = colours.lightGrey
        textColour = colours.black
        dropshadowColour = colours.grey
        popupWindow = true
    elseif type == "error" then
        -- Dont clear the screen
        -- Window colours
        titlebarColour = colours.red
        windowColour = colours.lightGrey
        textColour = colours.black
        dropshadowColour = colours.grey
        popupWindow = true
    elseif type == "stargate" then
        -- Special window type, similar to master but does more crap
        term.clear()
        -- Window colours
        titlebarColour = colours.lightBlue
        windowColour = colours.white
        textColour = colours.black
        dropshadowColour = colours.grey
    end

    -- Initalisation of variables.
    posX = 0
    posY = 0
    termSizeX,termSizeY = term.getSize()


    -- Start drawing the window from the centre of the terminal window, minus half the window length to centre it.


    if windowHeight == nil or windowHeight == 0 or windowLength == nil or windowLength == 0 then
        windowHeight = termSizeY - 2
        windowLength = termSizeX - 2
    end
    windowSizeXstart = math.floor(termSizeX / 2) - math.floor(windowLength / 2)
    windowSizeYstart = math.floor(termSizeY / 2) - math.floor(windowHeight / 2)
    windowSizeX = math.floor(termSizeX / 2) + math.floor(windowLength / 2)
    windowSizeY = math.floor(termSizeY / 2) + math.floor(windowHeight / 2)

    titlebarPosX = windowSizeXstart + 3
    titlebarPosY = windowSizeYstart
    posX = windowSizeXstart
    posY = windowSizeYstart

    -- Draw dropshadow
    posY = windowSizeYstart + 1
    posX = windowSizeXstart + 1
    while posY < windowSizeY + 1 do
        term.setBackgroundColour(dropshadowColour)
        string = " "
        if posX < windowSizeX + 1 then
            posX = posX + 1
            term.setCursorPos(posX, posY)
            term.setTextColour(dropshadowColour)
            term.write(string)
        else
            posX = windowSizeXstart + 1
            posY = posY + 1
        end
    end
    -- Reset drawing positions.
    posX = windowSizeXstart
    posY = windowSizeYstart
    while posY < windowSizeY do
        if posY == windowSizeYstart then
            term.setBackgroundColour(titlebarColour)
        else
            term.setBackgroundColour(windowColour)
        end
        if posY == windowSizeYstart or posY == windowSizeY - 1 or posX == windowSizeXstart or posX == windowSizeX - 1 then
            string = " "
        else
            string = " "
        end
        if posX < windowSizeX then
            posX = posX + 1
            term.setCursorPos(posX, posY)
            term.setTextColour(textColour)
            term.write(string)
        else
            posX = windowSizeXstart
            posY = posY + 1
        end
    end

    -- Calculate inital titlebar lenght, if too long truncate the titlebar length if needed
    windowTitlebarLength = string.len(windowTitle)
    if windowTitlebarLength > windowLength then
        windowTitle = string.sub(windowTitle, 1, windowLength - 6)
        windowTitle = windowTitle .. "..."
    end
    windowContentLength = string.len(windowContent)
    if math.floor(windowContentLength + 2) > windowLength then
        windowContent = string.sub(windowContent, 1, windowLength - 6)
        windowContent = windowContent .. "..."
    end

    -- Calculate the centre of the window and recalculate the centre of the titlebar
    centreWindowLength = math.floor(windowLength / 2)
    windowTitlebarLength = string.len(windowTitle)
    centreWindowTitlebarLength = math.floor(windowTitlebarLength / 2)
    titlebarPosX = math.floor(centreWindowLength - centreWindowTitlebarLength) + windowSizeXstart + 1

    -- Draw the title bar and it's contents
    term.setCursorPos(titlebarPosX, titlebarPosY)
    term.setBackgroundColour(titlebarColour)
    term.setTextColour(textColour)
    term.write(windowTitle)
 
    

    -- Other testing (THIS WILL BE IN THE MAIN PROGRAM, JUST PUTTING IT HERE FOR TESTING PURPOSES)
-- In main progrma, set it so that the iris states also set the irisStatus variable for it to be read here.

-- Gate status will show if the gate is idle, active, or shutting down. 
-- Destination will show the last dialled address according to the dial function.
-- Iris status will show if the iris is open, closed, or unavailable.

    if iris then
        sleep(0)
    else
        irisStatus = "Unavailable"
    end

--    if type == "stargate" then
--        -- The variables in here will be declared earlier on in the main program itself, this is just a test.
--        term.setCursorPos(windowContentX, windowContentY + 1)
--        term.write("Gate status: "..gateStatus)
--        term.setCursorPos(windowContentX, windowContentY + 2)
--        term.write("Destination: "..address)
--        term.setCursorPos(windowContentX, windowContentY + 3)
--        -- Do something like this but better.
--        term.write("Iris status: ")
--        if irisStatus == "Unavailable" then
--            textColour = colours.red
--            term.write(irisStatus)
--        elseif irisStatus == "Open" then
--            textColour = colours.green
--            term.write(irisStatus)
--        elseif irisStatus == "Closed" then
--           textColour = colours.red
--            term.write(irisStatus)
--        end
--   end

    -- Draw window contents

    -- WHY ISNT IT DRAWING THE CONTENTS NOW
    windowContentX = windowSizeXstart + 3
    windowContentY = windowSizeYstart + 2
    term.setCursorPos(windowContentX, windowContentY)
    term.setBackgroundColour(windowColour)
    term.setTextColour(textColour)
    term.write(windowContent)
    -- Add an OK button to the bottom centre of the popup window
    -- Add button functionality to the OK button, when enter is hit, close the window and redraw the master window.
    if popupWindow == true then
        popupOKstring = " "..dialogueString.." "
        popupStringLength = string.len(popupOKstring)
        centrePopupStringLength = math.floor(popupStringLength / 2)
        popupOKPosX = math.floor(centreWindowLength - centrePopupStringLength) + windowSizeXstart + 1
        popupOKPosY = windowSizeY - 2
        term.setBackgroundColour(buttonColour)
        term.setCursorPos(popupOKPosX, popupOKPosY)
        term.write(popupOKstring)
        while keyPressed ~= 28 do
            event, keyPressed = os.pullEvent("key")
            if keyPressed == 28 then
                -- Need to adjust this to redraw the window below it, it's not always the master window
                drawWindow("Stargate Status", "Stargate Information System:", "stargate", 0, 0)
            end
        end
    end
    
    term.setCursorPos(termSizeX, termSizeY)
--    if type == "stargate" then
--        drawWindow("Warning!", "Gate overloading!", "error", 5, 18)
--    end
end
drawWindow("Stargate Status", "Stargate Information System:", "stargate", 0, 0)
drawWindow("Test", "Error!", "error", 7, 18, "OK")