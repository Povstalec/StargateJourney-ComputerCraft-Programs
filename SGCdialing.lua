--This code should work with the currently most recent version as of writing this (v0.6.17)
interface = peripheral.find("crystal_interface")

function dial(address)
    local addressLength = #address
    
    if addressLength == 8 then
        interface.setChevronConfiguration({0, 1, 2, 3, 4, 6, 7, 8, 5})
    elseif addressLength == 9 then
        interface.setChevronConfiguration({0, 1, 2, 3, 4, 5, 6, 7, 8})
    end
   
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
		
        interface.endRotation();
        
        sleep(1)
        interface.openChevron()
		        
        sleep(0.5)
        if chevron < addressLength then
            interface.encodeChevron()
        end
		
        sleep(0.5)
        interface.closeChevron()
        sleep(1)
    end 
end

abydosAddress = {26, 6, 14, 31, 11, 29, 0}
chulakAddress = {8, 1, 22, 14, 36, 19, 0}
lanteaAddress = {18, 20, 1, 15, 14, 7, 19, 0}
netherAddress = {27,23,4, 34, 12, 28, 0}
cavumTenebraeAddress = {18, 7, 3, 36, 25, 15, 0}
endAddress = {13, 24, 2, 19, 3, 30, 0}

print("Avaiting input:")
print("1 = Abydos")
print("2 = Chulak")
print("3 = Lantea")
print("4 = Nether")
print("5 = Cavum Tenebrae")
print("6 = End")
input = tonumber(io.read())
sleep(0)
if input == 1 then
    dial(abydosAddress)
elseif input == 2 then
    dial(chulakAddress)
elseif input == 3 then
    dial(lanteaAddress)
elseif input == 4 then
    dial(netherAddress)
elseif input == 5 then
    dial(cavumTenebraeAddress)
elseif input == 6 then
    dial(endAddress)
elseif input == 7 then
    dial(destinyAddress)
end

