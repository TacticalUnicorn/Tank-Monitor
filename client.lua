minitel = require("minitel")
component = require("component")
sides = require("sides")
event = require("event")
tc = component.tank_controller
run = true
-- function to dynamically determine amount of tank_controllers and tanks
--tank controller and sides
local tankTable = {}
local controllerTable = {}
local fluidLevel = {}
function updateTable()
for address, componentType in component.list("tank_controller") do
    tankTable[address] = {}
    table.insert(controllerTable, address)
    local i = 0
    while i < 6 do
        if component.invoke(address, "getTankCount", i) > 0 then
            table.insert(tankTable[address], i)
        end
        i  = i + 1
    end
end

print("tank controllers detected:")

for i, v in ipairs(controllerTable) do print(v) end
print("tanks detected:")
for k,v in pairs(tankTable) do 
    print(k .. ":")
    for i, v in ipairs(v) do print(v)
    end
end

--machines
machineTable = {}
for address, componentType in component.list("gt_machine") do
    table.insert(machineTable, address)
end
print("machine controllers detected:")
for i, v in ipairs(machineTable) do print(v) end
end
--[[
table initilization
updateTable()
for index, controller in ipairs(controllerTable) do
    local current = controller
    for index, side in pairs(tankTable[current]) do
        fluidLevel[current][side] = 0
        print("table initial" .. current .. "," .. side)
    end
end
]]--
updateTable()
--functions to monitor data and push event for update
while run do
--tanks

-- fluid amount
    for i,v in ipairs(controllerTable) do
        print(v)
-- save current address       
        local current = v
        print ("current address" .. current)
        -- Loop through tanks for given address
        for index, tank in ipairs(tankTable[current]) do
            print("tank " .. tank)
            -- Retrieve and save fluid level for current tank
            local currentLevel = component.invoke(tostring(current), "getTankLevel", tank)
            print(component.invoke(current, "getTankLevel", tank))
            -- Check if tank has been initilized yet
            fluidLevel[current].tank = fluidLevel[current].tank
            print(fluidlevel[current].tank)
            if fluidLevel[current].tank ~= currentLevel then
                -- tank is equal
                --pushes fluid update event
                event.push("fluidUpdate", current, tank, currentValue)
                -- current fluid level and saves it in the table
                print(currentLevel)
                fluidLevel[current].tank= currentLevel
            else
                -- no update, do nothing
            end
            update = {event.pull(0.1, "fluidUpdate")}
            if update then for i, v in ipairs(update) do print(v) end update = nil end
            print("exit")
        end
    end
os.sleep(1)
end
    
            
