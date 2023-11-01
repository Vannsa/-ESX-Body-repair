ESX = exports['es_extended']:getSharedObject()

ESX.RegisterServerCallback('canAfford', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if Config.SharedAccount then
		if xPlayer.getMoney() >= Config.Money then
			xPlayer.removeMoney(Config.Money)
            TriggerEvent("esx_addonaccount:getSharedAccount", Config.Society , function(account)
                if account ~= nil then
                    account.addMoney(Config.Money)
        end
    end)
			cb(true)

		else
			cb(false)
		end
	else
		cb(true)
	end
end)


ESX.RegisterServerCallback('checkLS', function(source, cb, LSRequired)
    if Config.UsingESXLegacy then
        local xPlayers = ESX.GetExtendedPlayers('job', Config.LSJobName)
        if #xPlayers >= Config.LSRequired then
            cb(true)
        else
            cb(false)
        end
    else
        local LSConnected = 0
        local xPlayers = ESX.GetPlayers()
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayer.job.name == Config.LSJobName then
                LSConnected = LSConnected + 1
            end
        end
        
        if LSConnected >= Config.LSRequired then
            cb(true)
        else
            cb(false)
        end
    end
end)