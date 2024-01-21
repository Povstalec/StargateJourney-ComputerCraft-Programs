--NOTE! SGJ and AdvPerph required!

--Danger's Dialler V2.0

-- Global variable declarations

-- Command line arguments

if term.isColour() == false then
    error("Advanced Computer or better required for program to initalise...", 0)
end

local arg = {...}
-- Expected values: --verbose, --forcePegasus, --forceMilky, --help, --kripMode
forceMilky = false
bypassAuto = false
forcePegasus = false
verbose = false
terribleMode = false

for _,v in pairs(arg) do
    if v == "--help" then
        print("Danger\'s Dialler Command-Line Arguments: (Argument / Function)")
        print("WARNING! ALL FLAGS ARE FOR TESTING ONLY AND MAY DESTABILISE THE PROGRAM\nUSE AT OWN RISK")
        print("--help / Prints this help menu")
        print("--verbose / Displays extremely detailed information about the program state")
        print("--forcePegasus / Forces the program to assume a Pegasus Stargate")
        print("--forceMilky / Forces the program to assume a Milky Way Stargate")
        return
    elseif v == "--verbose" then
        verbose = true
        print("Verbose mode on")
    elseif v == "--forceMilky" then
        forceMilky = true
        bypassAuto = true
        print("Forcing Milky Way Stargate")
    elseif v == "--forcePegasus" then
        forcePegasus = true
        bypassAuto = true
        print("Forcing Pegasus Stargate")
    elseif v == "--kripMode" then
        terribleMode = true
        print("Terrible mode activated!")
    elseif v then
        print(arg)
        error("Program failed to initalise, bad flags", 0)
    end
end

if forceMilky == true and forcePegasus == true then
    error("You cannot force Milky and Pegasus, please select one or the other", 0)
    return
end

function verboseInfo(text)
    if verbose == true then
        print(text)
    end
end

interface = peripheral.find("basic_interface") or peripheral.find("crystal_interface") or peripheral.find("advanced_crystal_interface")
verboseInfo("Interface initalised")
iris = peripheral.find("redstoneIntegrator")
verboseInfo("Iris initalised")


--term.write("Colour mode initalised")


print("Danger\'s Dialler V2.0 Penultimate Update before Rewrite")
print("Initalising... Please wait")
os.sleep(3)
term.clear()
term.setCursorPos(1, 1)

if interface then
    verboseInfo("Stargate found!")
    sleep(0)
else
    error("Stargate not found! Please connect a gate and ensure the interface is connected.", 0)
    return
end

if iris then
    verboseInfo("Iris found!")
    irisPresent = true
else
    verboseInfo("Iris not found, iris functionality will be disabled")
    irisPresent = false
end

if interface.engageSymbol ~= nil then
    verboseInfo("Pegasus / Universe Gate Detected")
    if bypassAuto == false then
        forcePegasus = true
        verboseInfo("No force arguments detected, automatically setting gate type")
    end
elseif interface.rotateClockwise ~= nil then
    verboseInfo("Milky Gate Detected")
    if bypassAuto == false then
        forceMilky = true
        verboseInfo("No force arguments detected, automatically setting gate type")
    end
end


--Stargate dialling function, this basically just lets you dial the gate whenever called

function dial(address)
    if verbose == true then
        print("Primary dialling function called with value: "..tostring(address))
    end
    if forceMilky == true then
        verboseInfo("Milky dial in progress...")
        local addressLength = #address
        local start = interface.getChevronsEngaged() + 1
    
        for chevron = start,addressLength,1
        do
            local symbol = address[chevron]
        
            if chevron % 2 == 0 then
                interface.rotateClockwise(symbol)
            else
                interface.rotateAntiClockwise(symbol)
            end

            while(not interface.isCurrentSymbol(symbol))
            do
                sleep(0)
            end
            sleep(0.5)

            interface.raiseChevron()
            sleep(0.5)
            interface.lowerChevron()
            sleep(0.5)
        end
    elseif forcePegasus == true then
        verboseInfo("Pegasus / Universe dial in progress...")
        local addressLength = #address
        local start = interface.getChevronsEngaged() + 1

        for chevron = start,addressLength,1
        do
            local symbol = address[chevron]
            
            interface.engageSymbol(symbol)
        end
    end
end

-- Gate reset function, attempts to unjam the gate should it become stuck during a dialling sequence

function resetGate()
    clearScreen()
    local x = 0
    print("Resetting gate...")
    if forceMilky == true then
        while x ~= 10 do
            x = x + 1
            interface.lowerChevron()
            os.sleep(0.1)
            interface.raiseChevron()
            os.sleep(0.1)
        end
        interface.lowerChevron()
        interface.rotateClockwise(0)
        interface.raiseChevron()
        interface.lowerChevron()
        interface.disconnectStargate()
        if interface.isStargateConnected() == true then
            print("Stargate successfully reset")
        else
            print("Was unable to reset gate")
        end 
    elseif forcePegasus == true then
        while x ~= 10 do
            x = x + 1
            interface.engageSymbol(0)
        end
        if interface.isStargateConnected() == false then
            print("Stargate successfully reset")
        else
            print("Was unable to reset gate")
        end
    end
end

-- Address Database (Will be a file in the future)
--Do note, if you're adding an address yourself, YOU MUST APPEND IT WITH A 0 AS THE PoO!

abydosAddress = {26,6,14,31,11,29,0}
chulakAddress = {8,1,22,14,36,19,0}
lanteaAddress = {18,20,1,15,14,7,19,0}
midwayAddress = {8,29,19,11,7,4,23,31,0}
netherAddress = {27,23,4,34,12,28,0}
newAthosAddress = {18,21,14,24,1,26,28,0}

--TODO: Update the follow addresses to remove the long-distance dialling
--NOTE: Ad Astra Addresses

moonAddress = {34,2,17,1,18,3,24,4,0}
marsAddress = {9,12,25,34,20,29,8,27,0}
venusAddress = {32,9,17,16,8,6,21,22,0}
glacioAddress = {14,33,1,7,15,32,31,2,0}

-- CUSTOM ADDRESS DATABASE BELOW!

spawnAddress = {16,26,29,14,25,17,21,35,0}
miningDimAddress = {25,2,15,34,35,11,9,28,0}
endAddress = {13,24,2,19,3,30,0}


-- SEPERATOR

verboseInfo("Address database initalised")
-- Iris sanity check on boot (Useful is the iris was left on and the program reboots, makes sure to set the correct values in memory)
if iris then
    if iris.getOutput("back") == true then
        irisToggle = 0
        verboseInfo("Iris sanity check performed, iris state set to 0")
    elseif iris.getOutput("back") == false then
        irisToggle = 1
        verboseInfo("Iris sanity check performed, iris state set to 1")
    end
end
-- Draw the main page whenever a command is issued

function mainPage()
    verboseInfo("mainPage function called")
    print("TEMPORARY: Stargate Control Interface, please select and input a command below")
    print("To reset the stargate should it become stuck, type \"reset\"")
    print("To toggle the iris, type \"iris\" or press 1")
    print("To terminate the wormhole, type \"shutdown\" or press 2")
    print("To enter a custom address, type \"custom\"")
    print("\nType \'page\' followed by a number to print a list of addresses to dial, or type the destination name")
    print("E.G \'page 1\' for the first page")
    print("(Please note, additional addresses are on page 3)")
end

function addressList(page)
    verboseInfo("addressList function called with value: not implemented")
    page = tonumber(page)
    if page == 69 then
        clearScreen()
        print("Nice")
    elseif page == 1 then
        clearScreen()
        print("Dial Abydos (3)")
        print("Dial Chulak (4)")
        print("Dial Lantea (5)")
        print("Dial The End (6)")
        print("Dial Nether (7)")
    elseif page == 2 then
        clearScreen()
        print("Ad Astra and other non-functioning Addresses\n")
        print("Dial New Athos (8)")
        print("Dial The Moon (9)")
        print("Dial Mars (10)")
        print("Dial Venus (11)")
        print("Dial Glacio (12)")
    elseif page == 3 then
        clearScreen()
        print("Custom addresses:\n")
        print("Dial Spawn (13)")
        print("Dial Mining Dimension (14)")
        print("For more entries, bug Danger")
    else
        clearScreen()
        print("No other entries exist!")
    end
end

--Refresh screen

function clearScreen()
    term.clear()
    term.setCursorPos(1, 1)
    mainPage()
    verboseInfo("clearScreen function called")
end

-- Gate dialling subroutine, prints relevant information to the console and dials the gate

function startDial(address, name, isIntergalactic, isDirect)
    if verbose == true then
        print("Secondary dialling subroutine called with the following values: "..tostring(address)..", "..name..", "..tostring(isIntergalactic)..", "..tostring(isDirect))
    end
    interface.disconnectStargate()
    os.sleep(1)
    if interface.isStargateConnected() == true then
        verboseInfo("Stargate connection check passed")
        clearScreen()
        print("Cannot dial out, wormhole will not close! (Is the call incoming?)")
    else
        term.clear()
        term.setCursorPos(1, 1)
        if address == customAddress then
            print("Dialling custom address: "..tostring(customAddress))
            dial(address)
            sleep(0.5)
        else
            if isIntergalactic == true then
                print("Warning! Intergalactic dialling in progress!")
            end
            if isDirect == false then
                print("Dialling "..name.."...")
                dial(address)
                sleep(0.5)
            elseif isDirect == true then
                print("Direct dialling "..name.."...")
                dial(address)
                sleep(0.5)
            end
        end

        if forcePegasus == true then
            local counter = 0
            print("Waiting for dialling to complete...")
            if counter <= 30 then
                while interface.getChevronsEngaged() < 7 do
                    os.sleep(1)
                    counter = counter + 1
                end
            elseif counter == 30 then
                clearScreen()
                print("Gate failed to respond during timeout period. Dial aborted.")
            end
            if interface.getChevronsEngaged() >= 7 then
                verboseInfo("Greater than or equal to 7 chevrons engaged, starting timer...")
                os.sleep(10)
            end
            if interface.isStargateConnected() == false then
                clearScreen()
                print("Dialling failed! Destination may be buried, incorrectly entered, or insufficient power to complete dialling procedure.")
            elseif interface.isStargateConnected() == true then
                clearScreen()
                print(name.." dialled!")
            end
        else
            if interface.isStargateConnected() == false then
                clearScreen()
                print("Dialling failed! Destination may be buried, incorrectly entered, or insufficient power to complete dialling procedure.")
            elseif interface.isStargateConnected() == true then
                clearScreen()
                print(name.." dialled!")
            end
        end
    end
end

--Iris control subroutine

function irisControl()
    verboseInfo("irisControl subroutine called")
    if iris then
        term.clear()
        term.setCursorPos(1, 1)
        if irisToggle == 1 then
            iris.setOutput("back", true)
            irisToggle = 0
            clearScreen()
            verboseInfo("Iris state presently 1, setting 0 and enabling iris")
            print("Shield raised!")
        elseif irisToggle == 0 then
            iris.setOutput("back", false)
            irisToggle = 1
            clearScreen()
            verboseInfo("Iris state presently 0, setting 1 and disabling iris")
            print("Shield dropped!")
        end
    else
        clearScreen()
        print("Iris not found!")
    end
end

--Wormhole termination subroutine

function closeWormhole()
    verboseInfo("closeWormhole function called")
    if interface.isStargateConnected() == true then
        interface.disconnectStargate()
        os.sleep(1)
        if interface.isStargateConnected() == true then
            resetGate()
            if interface.isStargateConnected() == true then
                clearScreen()
                print("Failed to close wormhole!") 
            end
        else
            clearScreen()
            print("Wormhole closed!")
        end
    else
        clearScreen()
        print("Wormhole is not engaged!")
    end
end

while terribleMode == true do
    resetGate()
    print("FIRE IN THE HOLE!")
end

-- Main subroutine to draw the address database (Will be converted into a function of its own)
mainPage()
while true do
    os.queueEvent("randomEvent")
    os.pullEvent("randomEvent")

    local msg = read()

    local _, _, pageNumber = string.find(msg, "page%s*(%d+)")

--Format is as follows for the startDial subroutine, Destination first as "xAddress", followed by the display name you wish to show, followed by being whether or not it is a intergalactic dial, then if it a direct dial to a gate
    if msg == "" then
        clearScreen()
    elseif pageNumber then
        addressList(pageNumber)
    elseif msg == "reset" then
        resetGate()
    elseif msg == "custom" then
        customAddress = {}
        term.clear()
        term.setCursorPos(1, 1)
        print("Custom destination selection:")
        print("To dial a custom destination, please type your address in the following format\nBe sure not to include spaces or any other text")
        print("\n\nExample address, \"1,2,3,4,5,6,0\", where 0 is the Point of Origin")
        print("\nCustom Address: ")
        local custom = read()
        for value in custom:gmatch("[^,]+") do
            table.insert(customAddress, tonumber(value))
        end
        startDial(customAddress, "Custom Address", false, false)
        --CUSTOM ADDRESS DIALLING HERE
    elseif msg == "1" or msg == "iris" then
        irisControl()
    elseif msg == "2" or msg == "shutdown" then
        closeWormhole()
    elseif msg == "3" or msg == "abydos" then
        startDial(abydosAddress, "Abydos", false, false)
    elseif msg == "4" or msg == "chulak" then
        startDial(chulakAddress, "Chulak", false, false)
    elseif msg == "5" or msg == "lantea" then
        startDial(lanteaAddress, "Lantea", true, false)
    elseif msg == "6" or msg == "midway" or msg == "end" or msg == "the end" then
        startDial(endAddress, "The End", false, false)
    elseif msg == "7" or msg == "nether" then
        startDial(netherAddress, "the Nether", false, true)
    elseif msg == "8" or msg == "athos" or msg == "newathos" or msg == "new athos" then
        startDial(newAthosAddress, "New Athos", true, false)
    elseif msg == "9" or msg == "moon" or msg == "the moon" or msg =="themoon" then
        startDial(moonAddress, "The Moon", false, true)
    elseif msg == "10" or msg == "mars" then
        startDial(marsAddress, "Mars", false, true)
    elseif msg == "11" or msg == "venus" then
        startDial(venusAddress, "Venus", false, true)
    elseif msg == "12" or msg == "glacio" then
        startDial(glacioAddress, "Glacio", true, true)
    elseif msg == "13" or msg == "spawn" then
        startDial(spawnAddress, "Spawn", false, true)
    elseif msg == "14" or msg == "mining dim" or msg == "mining" or msg =="miningdim" or msg == "mine" then
        startDial(miningDimAddress, "Mining Dimension", false, true)
    else
        clearScreen()
        print("Invalid command! Please check your input or bug Danger about his bad code")
    end
end
