local QBCore = exports['qb-core']:GetCoreObject()


RegisterNetEvent('rw-truckjob:server:Reward', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local price = math.random(4500, 10000)

    TriggerClientEvent('okokNotify:Alert', source, 'Du tjente kr '..price, 'Dyktige arbeidskarer pisser på flaske!', 2000, 'success')
    Player.Functions.AddMoney("cash", price, "truckjob-reward")
end)



QBCore.Functions.CreateCallback("qb-garage:server:GetSharedVehicles", function(source, cb, garage)
    local src = source
    local pData = QBCore.Functions.GetPlayer(src)
    MySQL.Async.fetchAll('SELECT * FROM player_vehicles WHERE garage = ?', {garage}, function(result)
        if result[1] then
            cb(result)
        else
            cb(nil)
        end
    end)
end)