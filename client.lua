ESX = exports['es_extended']:getSharedObject()

Citizen.CreateThread(function()

    local location2 = vector3(501.3866, -1337.31, 28.89431)
		local blip = AddBlipForCoord(location2)
		SetBlipSprite(blip, 225)
		SetBlipAsShortRange(blip, true)
        SetBlipScale(blip, 0.8)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.BlipName)
        EndTextCommandSetBlipName(blip)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local location = vector3(501.3866, -1337.31, 28.89431)
        local distance = GetDistanceBetweenCoords(coords, location, true)
        if distance < 50 then
            DrawMarker(36, location, 0, 0, 0, 0, 0, 0, 1.2, 1.2, 1.2, 0, 157, 150, 155, false, false, 2, false, false,
                false, false)
        end
        if distance < 5 then
            ESX.ShowHelpNotification("Press ~input_context~ to repair your car body")
        end
        if distance < 5 and IsPedOnFoot(playerPed) and IsControlJustReleased(0, 38) then
--            exports['okokNotify']:Alert('Information', 'Get in your car to do this',5000,'error')
            ESX.ShowNotification("Get in your car to do this")
        else
            if IsControlJustReleased(0, 38) then
                ESX.TriggerServerCallback('checkLS', function(lsRequired)
                    if not lsRequired then
                        if IsPedInAnyVehicle(playerPed) then
                            ESX.TriggerServerCallback('canAfford', function(canAfford)
                                if canAfford then
                                    if IsPedInAnyVehicle(playerPed) then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                        local engineHealth = GetVehicleEngineHealth(vehicle)
                                        if IsPedInAnyVehicle(playerPed) then
                                            FreezeEntityPosition(vehicle, true)
                                            FreezeEntityPosition(playerPed, true)
                                            DisableAllControlActions(0)
                                            Citizen.Wait(10000)
                                            SetVehicleFixed(vehicle)
                                            SetVehicleDeformationFixed(vehicle)
                                            SetVehicleEngineHealth(vehicle, engineHealth)
                                            FreezeEntityPosition(vehicle, false)
                                            FreezeEntityPosition(playerPed, false)
                                            EnableAllControlActions(0)
 --                                           exports['okokNotify']:Alert('Information','Your body has been repaired!',5000, 'success')
                                            ESX.ShowNotification("Your body has been repaired")
                                        else
 --                                           exports['okokNotify']:Alert('Information','Your body was made intact!', 5000,'error')
                                            ESX.ShowNotification("Your body was made intact")

                                        end
                                    else
 --                                       exports['okokNotify']:Alert('Information', 'Get in your car to do this!',5000,'error')
                                            ESX.ShowNotification("Get in your car to do this")
                                    end
                                else
 --                                   exports['okokNotify']:Alert('Information',"You don't have enough cash. You need" ..Config.Money..'to do this',5000,'error')
                                            ESX.ShowNotification("You don't have enough cash. You need" ..Config.Money..'to do this')
                                end
                            end, price)
                        end
                    else
 --                       exports['okokNotify']:Alert('Information','Es sind Mechaniker im Dienst, wende dich bitte an sie!',5000,'error')
                                            ESX.ShowNotification("There are mechanics on duty, please contact them'to do this")
                    end
                end)
            end
        end
    end
end)
