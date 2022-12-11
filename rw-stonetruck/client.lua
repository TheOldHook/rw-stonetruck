local QBCore = exports['qb-core']:GetCoreObject()
local truckjob = false
local truckjobBlip = nil


-- Path: client.lua
RegisterNetEvent('rw-truckjob:client:StartJob')
AddEventHandler('rw-truckjob:client:StartJob', function()
    truckjob = true
    exports['okokNotify']:Alert('Kjør ruta!', 'Du har starta med steinkjøring!', 5000, 'success')
    --QBCore.Functions.Notify("Du starta med steinkjøring!", "success")
end)


-- Path: client.lua
RegisterNetEvent('rw-truckjob:client:EndJob')
AddEventHandler('rw-truckjob:client:EndJob', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local invehicle = GetVehiclePedIsIn(ped, false)
    local pedintruck = IsPedInVehicle(ped, vehicle, false)
    local vehicle = GetHashKey("rubble")
    RequestModel(vehicle)
    if vehicle then
        QBCore.Functions.Progressbar("truckjob", "Tipper...", 30, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() --
            ClearPedTasks(ped)
            truckjob = false
            exports['okokNotify']:Alert('Jobb utført!', 'Du har fullført jobben! kjør inn til gruva for mer arbeid.', 2500, 'success')
            Citizen.Wait(2500)
            TriggerServerEvent('rw-truckjob:server:Reward')
            RemoveBlip(truckjobBlip)
            DeleteEntity(dirt)
            DeleteEntity(dirt2)
            DeleteEntity(dirt3)
            DeleteEntity(dirt4)
            DeleteEntity(dirt5)
            DeleteEntity(dirt6)
            DeleteEntity(dirt7)
            DeleteEntity(dirt8)
            DeleteEntity(dirt9)

            --QBCore.Functions.Notify("Du er ferdig med gruskjøring!", "success")
        end, function()
            --QBCore.Functions.Notify("Avbrutt..", "error")
            exports['okokNotify']:Alert('Avbrutt', 'Du har avbrutt!', 2500, 'error')
            ClearPedTasks(ped)
        end)
    end
end)
            



-- Citizen.CreateThread(function() -- Testing
--     while true do
--         print(truckjob)
--         Citizen.Wait(1000)
--     end
-- end)

local function updateBlip()
    coords2 = Config.Locations[math.random(#Config.Locations)]
    truckjobBlip = AddBlipForCoord(coords2.x, coords2.y, coords2.z)
    SetNewWaypoint(coords2)
end

local function removeBlip()
    RemoveBlip(truckjobBlip)
end



Citizen.CreateThread(function()
    while true do
        if truckjob then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local inRange = false


            
            dist = #(pos - coords2)

            if dist < 15 then
                inRange = true
                if dist < 5 then
                    local vehicle = GetEntityModel(GetVehiclePedIsIn(ped))
                    RequestModel(vehicle)
                    if vehicle == GetHashKey("rubble") then
                        DrawText3Ds(coords2.x, coords2.y, coords2.z, "~g~E~w~ - Lever stein")
                        if IsControlJustReleased(0, 38) then
                            TriggerEvent('rw-truckjob:client:EndJob')
                            removeBlip()
                        end
                    else
                        DrawText3Ds(coords2.x, coords2.y, coords2.z, 'Feil kjøretøy eller ikke i kjøretøyet')
                        if IsControlJustReleased(0, 38) then
                            exports['okokNotify']:Alert('Feil kjøretøy', 'Du må ha steinkjøretøy for å fullføre jobben!', 2500, 'error')
                            --QBCore.Functions.Notify("Du må ha en steinkjøretøy for å fullføre jobben!", "error")
                        end
                    end
                end
            end

            if not inRange then
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(1000)
        end
        Citizen.Wait(3)
    end
end)

RegisterCommand('stopstein', function()
    removeBlip()
    exports['okokNotify']:Alert('Jobb avbrutt', 'Du har avbrutt jobben! Du kan ta ny jobb om 10 minutter', 2500, 'error')
    Wait(600000) -- 10 minutter
    truckjob = false
    exports['okokNotify']:Alert('Ingen ventetid', 'Du kan ta ny stein jobb', 2500, 'error')
    --QBCore.Functions.Notify("Du har avbrutt jobben!", "error")
end)


Citizen.CreateThread(function()
    while true do
        if truckjob == false then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local inRange = false

            for k, v in pairs(Config.Pickuplocation) do
                local dist = #(pos - v)

                if dist < 5.0 then

                    inRange = true
                    local vehicle = GetEntityModel(GetVehiclePedIsIn(ped))
                    local plate = QBCore.Functions.GetPlate(vehicle)
                    RequestModel(vehicle)

                    if vehicle == GetHashKey('rubble') then
                        DrawText3Ds(v.x, v.y, v.z, "~g~E~w~ - Start jobb")

                        if IsControlJustReleased(0, 38) then
                            TriggerEvent('rw-truckjob:client:truckjob')
                            updateBlip()
                        end
                    else
                        DrawText3Ds(v.x, v.y, v.z, 'Du må ha steinkjøretøy for å starte jobben')
                    end
                end
            end

            if not inRange then
                Citizen.Wait(1000)
            end
        else
            Citizen.Wait(1000)
        end
        Citizen.Wait(3)
    end
end)

     
  




 


local function attachproptovehicle()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    local pedintruck = IsPedInVehicle(ped, vehicle, false)
    local coordA = GetEntityCoords(ped)
    
    if truckjob then
        RequestModel("prop_rock_4_cl_1")
        while not HasModelLoaded("prop_rock_4_cl_1") do
            Citizen.Wait(0)
        end
        dirt = CreateObject(GetHashKey("prop_rock_4_cl_1"), coordA, true, true, true)
        dirt2 = CreateObject(GetHashKey("prop_rock_4_cl_1"), coordA, true, true, true)
        dirt3 = CreateObject(GetHashKey("prop_rock_4_c_2"), coordA, true, true, true)
        dirt4 = CreateObject(GetHashKey("prop_rock_4_c_2"), coordA, true, true, true)
        dirt5 = CreateObject(GetHashKey("prop_rock_4_c_2"), coordA, true, true, true)
        dirt6 = CreateObject(GetHashKey("prop_rock_4_c_2"), coordA, true, true, true)
        dirt7 = CreateObject(GetHashKey("prop_rock_4_c_2"), coordA, true, true, true)
        dirt8 = CreateObject(GetHashKey("prop_rock_4_c_2"), coordA, true, true, true)
        dirt9 = CreateObject(GetHashKey("prop_rock_4_c_2"), coordA, true, true, true)
        AttachEntityToEntity(dirt, vehicle, GetEntityBoneIndexByName(vehicle, "boot"), -0.2, -2.5 + -1.50, 0.0 + 0.45, 0, 0, 0, 1, 1, 0, 1, 0, 1)
        AttachEntityToEntity(dirt2, vehicle, GetEntityBoneIndexByName(vehicle, "boot"), -0.2, -1.5 + -1.50, 0.0 + 0.45, 0, 0, 0, 1, 1, 0, 1, 0, 1)
        AttachEntityToEntity(dirt3, vehicle, GetEntityBoneIndexByName(vehicle, "boot"), 0.0, -3.5 + -2.50, 0.0 + 0.45, 0, 0, 0, 1, 1, 0, 1, 0, 1)
        AttachEntityToEntity(dirt4, vehicle, GetEntityBoneIndexByName(vehicle, "boot"), 0.0, -2.5 + -2.50, 0.3 + 0.45, 0, 0, 0, 1, 1, 0, 1, 0, 1)
        AttachEntityToEntity(dirt5, vehicle, GetEntityBoneIndexByName(vehicle, "boot"), 0.0, -1.5 + -2.50, 0.3 + 0.45, 0, 0, 0, 1, 1, 0, 1, 0, 1)
        AttachEntityToEntity(dirt6, vehicle, GetEntityBoneIndexByName(vehicle, "boot"), 0.0, -1.5 + -0.50, 0.6 + 0.45, 0, 0, 0, 1, 1, 0, 1, 0, 1)
        AttachEntityToEntity(dirt7, vehicle, GetEntityBoneIndexByName(vehicle, "boot"), 0.0, -1.5 + -1.90, 0.7 + 0.45, 0, 0, 0, 1, 1, 0, 1, 0, 1)
        AttachEntityToEntity(dirt8, vehicle, GetEntityBoneIndexByName(vehicle, "boot"), 0.0, -1.5 + -2.90, 0.8 + 0.45, 0, 0, 0, 1, 1, 0, 1, 0, 1)
        AttachEntityToEntity(dirt9, vehicle, GetEntityBoneIndexByName(vehicle, "boot"), 0.0, -1.5 + -3.90, 0.5 + 0.45, 0, 0, 0, 1, 1, 0, 1, 0, 1)

        -- Wait(8000)
        -- DeleteEntity(dirt)
        -- DeleteEntity(dirt2)
        -- DeleteEntity(dirt3)
        -- DeleteEntity(dirt4)
        -- DeleteEntity(dirt5)
        -- DeleteEntity(dirt6)
        -- DeleteEntity(dirt7)
        -- DeleteEntity(dirt8)
        -- DeleteEntity(dirt9)
    end
end








RegisterNetEvent('rw-truckjob:client:truckjob')
AddEventHandler('rw-truckjob:client:truckjob', function()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local invehicle = IsPedInAnyVehicle(ped, false)
    local pedintruck = IsPedInVehicle(ped, vehicle, false)
    local vehicle = GetHashKey("rubble")

    RequestModel(vehicle)
    if invehicle then
        QBCore.Functions.Progressbar("truckjob", "Laster på...", 30, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() -- Done
            TriggerEvent('rw-truckjob:client:StartJob')
            attachproptovehicle()
        end, function()
            QBCore.Functions.Notify("Avbrutt..", "error")
        end)
    end
end)


function DrawText3Ds(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
    local scale = 0.35

    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)

        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 100)
    end
end
