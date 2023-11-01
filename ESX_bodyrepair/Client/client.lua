ESX = exports['es_extended']:getSharedObject()

local repairInProgress = false
local mechanicPed = nil

Citizen.CreateThread(function()

    local location2 = Config.BlipLoaction
    local blip = AddBlipForCoord(location2)
    SetBlipSprite(blip, 225)
    SetBlipAsShortRange(blip, true)
    SetBlipScale(blip, 0.8)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.BlipName)
    EndTextCommandSetBlipName(blip)
end)

function pedmodel(playerPed, vehicle)
    local pedModel = GetHashKey(Config.pedModel)
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Citizen.Wait(1)
    end

    mechanicPed = CreatePed(1, pedModel, Config.PedSpawn.x, Config.PedSpawn.y, Config.PedSpawn.z, Config.PedSpawn.h, false, true) 
    SetBlockingOfNonTemporaryEvents(mechanicPed, true)

    local vehicleCoords = GetEntityCoords(vehicle)
    local passengerDoor = GetOffsetFromEntityInWorldCoords(vehicle, 1)

    TaskGoToCoordAnyMeans(mechanicPed, passengerDoor.x, passengerDoor.y, passengerDoor.z, 1.0, 0, 0, 786603, 0xbf800000)
    Citizen.Wait(Config.WalkTime)

    if DoesEntityExist(mechanicPed) then
        ClearPedTasksImmediately(mechanicPed)
        TaskStartScenarioInPlace(mechanicPed, Config.Animation, 0, true)
        Citizen.Wait(Config.PedAnimationTime)
        ClearPedTasks(mechanicPed)
        TaskGoToCoordAnyMeans(mechanicPed, Config.PedDespawn.x, Config.PedDespawn.y, Config.PedDespawn.z, 1.0, 0, 0, 786603, 0xbf800000)
        Citizen.Wait(Config.WalkTime)
        ESX.ShowAdvancedNotification(Config.PedName, Config.PedSubject, Config.PedMessage, Config.PedPicture)
        DeleteEntity(mechanicPed)
    end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local location = vector3(501.3866, -1337.31, 28.89431)
        local distance = GetDistanceBetweenCoords(coords, location, true)
        if distance < 35 then
            DrawMarker(36, location, 0, 0, 0, 0, 0, 0, 1.2, 1.2, 1.2, 0, 157, 150, 155, false, false, 2, false, false,
                false, false)
        end
        if distance < 2 then
            ESX.ShowHelpNotification(Strings.HelpNotification)
        end
        if distance < 2 and IsPedOnFoot(playerPed) and IsControlJustReleased(0, 38) then
            ESX.ShowNotification(Strings.OnFoot)
        else
            if distance < 2 and IsControlJustReleased(0, 38) then
                if not repairInProgress then
                    repairInProgress = true
                    ESX.TriggerServerCallback('checkLS', function(lsRequired)
                        if not lsRequired then
                            if IsPedInAnyVehicle(playerPed) then
                                ESX.TriggerServerCallback('canAfford', function(canAfford)
                                    if canAfford then
                                        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                                        local engineHealth = GetVehicleEngineHealth(vehicle)
                                        if IsPedInAnyVehicle(playerPed) then
                                            FreezeEntityPosition(vehicle, true)
                                            FreezeEntityPosition(playerPed, true)
                                            DisableAllControlActions(0)
                                            DisableControlAction(0, 38, true)
                                            pedmodel(playerPed, vehicle)
                                            Citizen.Wait(1000)
                                            SetVehicleFixed(vehicle)
                                            SetVehicleDeformationFixed(vehicle)
                                            SetVehicleEngineHealth(vehicle, engineHealth)
                                            FreezeEntityPosition(vehicle, false)
                                            FreezeEntityPosition(playerPed, false)
                                            EnableAllControlActions(0)
                                        else
                                            ESX.ShowNotification(Strings.OnFoot)
                                        end
                                    else
                                        ESX.ShowNotification(Strings.NoMoney)
                                    end
                                    repairInProgress = false
                                end, price)
                            else
                                ESX.ShowNotification(Strings.OnFoot)
                                repairInProgress = false
                            end
                        else
                            ESX.ShowNotification(Strings.MechanicsonDuty)
                            repairInProgress = false
                        end
                    end)
                end
            end
        end
    end
end)

function ShowAdvancedNotification(icon, sender, title, text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    SetNotificationMessage(icon, icon, true, 4, sender, title, text)
    DrawNotification(false, true)
end
