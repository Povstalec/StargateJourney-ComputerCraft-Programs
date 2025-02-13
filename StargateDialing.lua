--This code should work with the currently most recent version as of writing this (v0.6.17)
interface = peripheral.find("crystal_interface")
--This finds some interface connected to the
--computer network, but since that one is the only
--one connected, it will always be that one near the gate

function dial(address)
--Milky Way Stargate is a special case when it comes
--to dialing, so let's look at how you can dial
--other Stargates
    
    local addressLength = #address
    --You don't really need to have this variable,
    --I just like to use lots of variables with
    --names to make everything immediately clear
    
    local start = interface.getChevronsEngaged() + 1
    --This is a helpful variable we'll be using to
    --make resuming dialing easier.
    --Basically what this does is it makes the computer
    --check how many chevrons are engaged and start from
    --the next one (that's why there's a +1)
    
    for chevron = start,addressLength,1
    do
        --This is a loop that will go through all the
        --symbols in an address
        
        local symbol = address[chevron]
        
        interface.engageSymbol(symbol)
        --Yup, this is all you need for other Stargates!
        --We're simply getting the symbol from the address
        --corresponding to the chevron we want to engage
        
        --We won't be needing these:
        --if chevron % 2 == 0 then
        --    interface.rotateClockwise(symbol)
        --else
        --    interface.rotateAntiClockwise(symbol)
        --end
        --Here we're basically making sure the gate ring
        --rotates clockwise when the number of chevrons
        --engaged is even and counter-clockwise when odd
        
        --while(not interface.isCurrentSymbol(symbol))
        --do
        --    sleep(0)
        --end
        --This effectively ensures the program doesn't
        --do anything else and lets the dialing finish
        --rotating to the correct symbol
        
        --sleep(1)
        --We want to wait 1 second before we
        --engage the chevron
        --interface.raiseChevron() --This raises the chevron
        --sleep(1)
        --interface.lowerChevron() -- and this lowers it
        --sleep(1)
        
        --Note that from many of the functions here,
        --you can get Stargate Feedback
        
        --For example, the raiseChevron() function will output
        --a number corresponding to some feedback value which you'll
        --be able to find in the video description
        
    end 
end

--Now that we've got a function, this is how we'll run it

--But first we want some addresses

abydosAddress = {26,6,14,31,11,29,0}
--Do note that the Point of Origin (number 0)
--is considered a part of the address
--and if you forget it, the dialing sequence
--will not finish
chulakAddress = {8,1,22,14,36,19,0}

lanteaAddress = {18,20,1,15,14,7,19,0}

--Now let's write the actual part of the program
--that will start the dialing

print("Avaiting input:")

print("1 = Abydos")
print("2 = Chulak")
print("3 = Lantea")
--These only tell the computer to write these
--strings of words when we run this program

input = tonumber(io.read())
sleep(0)
--Here we're basically getting the number written
--by the player on the console

if input == 1 then
    dial(abydosAddress) --We're using the function we wrote earlier
elseif input == 2 then
    dial(chulakAddress)
elseif input == 3 then
    dial(lanteaAddress)
else
    print("Invalid input")
end

--If you want to add more addresses, just
--add them to other addresses and extend this block

--You can do a bunch of other stuff with all this,
--but let's test it out now
