interface = peripheral.find("basic_interface")

function dial(address)
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
            print("Feedback",interface.getRecentFeedback())
            sleep(0)
        end
        
        sleep(1)
        print("Code",interface.raiseChevron())
        sleep(1)
        print("Code",interface.lowerChevron())
        sleep(1)
    end 
end

abydosAddress = {26,6,14,31,11,29,0}
chulakAddress = {8,1,22,14,36,19,0}
lanteaAddress = {18,20,1,15,14,7,19,0}

print("Avaiting input:")
print("1 = Abydos")
print("2 = Chulak")
print("3 = Lantea")
input = tonumber(io.read())

if input == 1 then
    dial(abydosAddress)
elseif input == 2 then
    dial(chulakAddress)
elseif input == 3 then
    dial(lanteaAddress)
end
