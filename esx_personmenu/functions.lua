isHoodOpen = false
isTrunkOpen = false
isAllOpen = false
myPhoneNumber = ''

outHood = false
outTrunk = false
outFrontRight = false
outFrontLeft = false
outBackRight = false
outBackLeft = false

outFrontWindowRight = false
outFrontWindowLeft = false
outBackWindowRight = false
outBackWindowLeft = false

isDragging = false

local surrenderStatus = false

AddEventHandler('esx:onPlayerDeath', function(data)
    isDead = true
end)

AddEventHandler('playerSpawned', function(spawn)
    isDead = false
end)

RegisterNetEvent("gcPhone:myPhoneNumber")
AddEventHandler("gcPhone:myPhoneNumber", function(_myPhoneNumber)
    myPhoneNumber = _myPhoneNumber
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
    myPhoneNumber = phoneNumber
end)

RegisterNetEvent('esx_ziptie:status')
AddEventHandler('esx_ziptie:status', function(status)
    if status then
        Config.QuickCommands[4].label = '~r~Overgiv Dig'
    elseif not status then
        Config.QuickCommands[4].label = 'Overgiv Dig'
    end
    if mainMenu:Visible() then
        mainMenu:Visible(false)
        Settings()
        CleanUp()
        mainMenu:Visible(true)
    end
end)

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function VehicleMenuFunctions(value)
    currentPlayer = PlayerPedId()
    currentVehicle = GetVehiclePedIsIn(currentPlayer)
    openDistance = 3.0
    if value == 'open_hood' then
        if isHoodOpen == false then
            SetVehicleDoorOpen(currentVehicle, 4, 0, 0)
            isHoodOpen = true
        else
            SetVehicleDoorShut(currentVehicle, 4, 0)
            isHoodOpen = false
        end
    elseif value == 'open_trunk' then
        if isTrunkOpen == false then
            SetVehicleDoorOpen(currentVehicle, 5, 0, 0)
            isTrunkOpen = true
        else
            SetVehicleDoorShut(currentVehicle, 5, 0)
            isTrunkOpen = false
        end
    elseif value == 'open_all' then
        if isAllOpen == false then
            SetVehicleDoorOpen(currentVehicle, 0, 0, 0)
            SetVehicleDoorOpen(currentVehicle, 1, 0, 0)
            SetVehicleDoorOpen(currentVehicle, 2, 0, 0)
            SetVehicleDoorOpen(currentVehicle, 3, 0, 0)
            SetVehicleDoorOpen(currentVehicle, 4, 0, 0)
            SetVehicleDoorOpen(currentVehicle, 5, 0, 0)
            SetVehicleDoorOpen(currentVehicle, 6, 0, 0)
            SetVehicleDoorOpen(currentVehicle, 7, 0, 0)
            isAllOpen = true
        else
            SetVehicleDoorShut(currentVehicle, 0, 0)
            SetVehicleDoorShut(currentVehicle, 1, 0)
            SetVehicleDoorShut(currentVehicle, 2, 0)
            SetVehicleDoorShut(currentVehicle, 3, 0)
            SetVehicleDoorShut(currentVehicle, 4, 0)
            SetVehicleDoorShut(currentVehicle, 5, 0)
            SetVehicleDoorShut(currentVehicle, 6, 0)
            SetVehicleDoorShut(currentVehicle, 7, 0)
            isAllOpen = false
        end
    elseif value == 'neon_control' then
        isNeonOn = IsVehicleNeonLightEnabled(currentVehicle, 0)
        if isNeonOn == false then
            SetVehicleNeonLightEnabled(currentVehicle, 0, 1)
            SetVehicleNeonLightEnabled(currentVehicle, 1, 1)
            SetVehicleNeonLightEnabled(currentVehicle, 2, 1)
            SetVehicleNeonLightEnabled(currentVehicle, 3, 1)
        else
            SetVehicleNeonLightEnabled(currentVehicle, 0, 0)
            SetVehicleNeonLightEnabled(currentVehicle, 1, 0)
            SetVehicleNeonLightEnabled(currentVehicle, 2, 0)
            SetVehicleNeonLightEnabled(currentVehicle, 3, 0)
        end
    elseif value == 'engine_toggle' then
        toggleEngine()
    elseif value == 'open_hood_out' then
        local playerPos = GetEntityCoords(currentPlayer, 1)
        local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords(currentPlayer, 0.0, openDistance, 0.0)
        local vehicle = GetVehicleInDirection(playerPos, inFrontOfPlayer)
        if (DoesEntityExist(vehicle)) then
            if outHood == false then
                SetVehicleDoorOpen(vehicle, 4, 0, 0)
                outHood = true
            else
                SetVehicleDoorShut(vehicle, 4, 0)
                outHood = false
            end
        end
    elseif value == 'open_trunk_out' then
        local playerPos = GetEntityCoords(currentPlayer, 1)
        local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords(currentPlayer, 0.0, openDistance, 0.0)
        local vehicle = GetVehicleInDirection(playerPos, inFrontOfPlayer)
        if (DoesEntityExist(vehicle)) then
            if outTrunk == false then
                SetVehicleDoorOpen(vehicle, 5, 0, 0)
                SetVehicleDoorOpen(vehicle, 6, 0, 0)
                SetVehicleDoorOpen(vehicle, 7, 0, 0)
                outTrunk = true
            else
                SetVehicleDoorShut(vehicle, 5, 0)
                SetVehicleDoorShut(vehicle, 6, 0)
                SetVehicleDoorShut(vehicle, 7, 0)
                outTrunk = false
            end
        end
    elseif value == 'open_frontdoor_right' then
        local playerPos = GetEntityCoords(currentPlayer, 1)
        local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords(currentPlayer, 0.0, openDistance, 0.0)
        local vehicle = GetVehicleInDirection(playerPos, inFrontOfPlayer)
        if (DoesEntityExist(vehicle)) then
            if outFrontRight == false then
                SetVehicleDoorOpen(vehicle, 0, 0, 0)
                outFrontRight = true
            else
                SetVehicleDoorShut(vehicle, 0, 0)
                outFrontRight = false
            end
        end
    elseif value == 'open_frontdoor_left' then
        local playerPos = GetEntityCoords(currentPlayer, 1)
        local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords(currentPlayer, 0.0, openDistance, 0.0)
        local vehicle = GetVehicleInDirection(playerPos, inFrontOfPlayer)
        if (DoesEntityExist(vehicle)) then
            if outFrontLeft == false then
                SetVehicleDoorOpen(vehicle, 1, 0, 0)
                outFrontLeft = true
            else
                SetVehicleDoorShut(vehicle, 1, 0)
                outFrontLeft = false
            end
        end
    elseif value == 'open_backdoor_right' then
        local playerPos = GetEntityCoords(currentPlayer, 1)
        local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords(currentPlayer, 0.0, openDistance, 0.0)
        local vehicle = GetVehicleInDirection(playerPos, inFrontOfPlayer)
        if (DoesEntityExist(vehicle)) then
            if outBackRight == false then
                SetVehicleDoorOpen(vehicle, 3, 0, 0)
                outBackRight = true
            else
                SetVehicleDoorShut(vehicle, 3, 0)
                outBackRight = false
            end
        end
    elseif value == 'open_backdoor_left' then
        local playerPos = GetEntityCoords(currentPlayer, 1)
        local inFrontOfPlayer = GetOffsetFromEntityInWorldCoords(currentPlayer, 0.0, openDistance, 0.0)
        local vehicle = GetVehicleInDirection(playerPos, inFrontOfPlayer)
        if (DoesEntityExist(vehicle)) then
            if outBackLeft == false then
                SetVehicleDoorOpen(vehicle, 2, 0, 0)
                outBackLeft = true
            else
                SetVehicleDoorShut(vehicle, 2, 0)
                outBackLeft = false
            end
        end
    elseif value == 'open_frontwindow_right' then
        local vehicle = GetVehiclePedIsIn(currentPlayer)
        if (DoesEntityExist(vehicle)) then
            if outFrontWindowRight == false then
                RollDownWindow(vehicle, 1)
                outFrontWindowRight = true
            else
                RollUpWindow(vehicle, 1)
                outFrontWindowRight = false
            end
        end
    elseif value == 'open_frontwindow_left' then
        local vehicle = GetVehiclePedIsIn(currentPlayer)
        if (DoesEntityExist(vehicle)) then
            if outFrontWindowLeft == false then
                RollDownWindow(vehicle, 0)
                outFrontWindowLeft = true
            else
                RollUpWindow(vehicle, 0)
                outFrontWindowLeft = false
            end
        end
    elseif value == 'open_backwindow_right' then
        local vehicle = GetVehiclePedIsIn(currentPlayer)
        if (DoesEntityExist(vehicle)) then
            if outBackWindowRight == false then
                RollDownWindow(vehicle, 3)
                outBackWindowRight = true
            else
                RollUpWindow(vehicle, 3)
                outBackWindowRight = false
            end
        end
    elseif value == 'open_backwindow_left' then
        local vehicle = GetVehiclePedIsIn(currentPlayer)
        if (DoesEntityExist(vehicle)) then
            if outBackWindowLeft == false then
                RollDownWindow(vehicle, 2)
                outBackWindowLeft = true
            else
                RollUpWindow(vehicle, 2)
                outBackWindowLeft = false
            end
        end
    end
end

function commonFunctions(value)
    if value == 'show_phonenumber' then
        if myPhoneNumber == '' then
            ESX.TriggerServerCallback('drp:requestNumber', function(thisNumber)
                myPhoneNumber = thisNumber
                TriggerServerEvent('3dme:shareDisplay', "* Telefonnummer: " .. myPhoneNumber .. ' *')
            end)
        else
            TriggerServerEvent('3dme:shareDisplay', "* Telefonnummer: " .. myPhoneNumber .. ' *')
        end
    elseif value == 'show_id' then
        local player, distance = ESX.Game.GetClosestPlayer()
        TriggerServerEvent('drp-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
        
        if distance ~= -1 and distance <= 3.0 then
            TriggerServerEvent('drp-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'driver')
        end
    elseif value == 'blindfold_toggle' then
        local player, distance = ESX.Game.GetClosestPlayer()
        if distance ~= -1 and distance <= 3.0 then
            if IsPedInAnyVehicle(GetPlayerPed(player)) then
                exports['mythic_notify']:SendAlert('error', 'Du kan ikke give personer i et køretøj blindfold på.', 5000)
            else
                ESX.TriggerServerCallback('jsfour-blindfold:itemCheck', function(hasItem)
                    TriggerServerEvent('jsfour-blindfold', GetPlayerServerId(player), hasItem)
                end)
            end
        else
            exports['mythic_notify']:SendAlert('error', 'Ingen personer i nærheden', 5000)
        end
    elseif value == 'surrender_now' then
        TriggerEvent('drp_animation:OnEmotePlay', 'Emotes', 'surrender')
    elseif value == 'hat_toggle' then
        TriggerEvent('drp_animation:hat-toggle')
    elseif value == 'glasses_toggle' then
        TriggerEvent('drp_animation:glasses-toggle')
    elseif value == 'mask_toggle' then
        TriggerEvent('drp_animation:mask-toggle')
    elseif value == 'bag_toggle' then
        TriggerEvent('drp_animation:bag-toggle')
    elseif value == 'shirt_toggle' then
        TriggerEvent('drp_animation:shirt-toggle')
    elseif value == 'pants_toggle' then
        TriggerEvent('drp_animation:pants-toggle')
    elseif value == 'shoes_toggle' then
        TriggerEvent('drp_animation:shoes-toggle')
    elseif value == 'watch_toggle' then
        TriggerEvent('drp_animation:watch-toggle')
    elseif value == 'chain_toggle' then
        TriggerEvent('drp_animation:chain-toggle')
    elseif value == 'vest_toggle' then
        TriggerEvent('drp_animation:vest-toggle')
    elseif value == 'decals_toggle' then
        TriggerEvent('drp_animation:decals-toggle')
    end
end

function crimeFunctions(value)
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        if value == 'ziptie_on' then
            if not IsPedInAnyVehicle(GetPlayerPed(GetPlayerServerId(closestPlayer)), false) then
                TriggerServerEvent('drp_ziptie:ziptie', GetPlayerServerId(closestPlayer))
                --TriggerEvent('RunCheck', '')
            else
                exports['mythic_notify']:SendAlert('error', 'Du kan ikke give strips på en der sider i en bil', 5000)
            end
        elseif value == 'ziptie_off' then
            if not IsPedInAnyVehicle(GetPlayerPed(GetPlayerServerId(closestPlayer)), false) then
                TriggerServerEvent('drp_ziptie:RemoveZiptie', GetPlayerServerId(closestPlayer))
                --TriggerEvent('RunCheck', '')
            else
                exports['mythic_notify']:SendAlert('error', 'Du kan ikke tage strips af en der sider i en bil', 5000)
            end
        elseif value == 'put_vehicle' then
            TriggerServerEvent('drp_ziptie:putInVehicle', GetPlayerServerId(closestPlayer))
            --TriggerEvent('RunCheck', '')
        elseif value == 'takeout_vehicle' then
            TriggerServerEvent('drp_ziptie:OutVehicle', GetPlayerServerId(closestPlayer))
            --TriggerEvent('RunCheck', '')
        elseif value == 'drag_person' then
            TriggerServerEvent('drp_ziptie:drag', GetPlayerServerId(closestPlayer))

            --TriggerEvent('RunCheck', 'drag')
        elseif value == 'check_pockets' then
            TriggerEvent('drp_ziptie:checkPocket')
            _menuPool:CloseAllMenus()
        end
    else
        exports['mythic_notify']:SendAlert('error', 'Ingen personer i nærheden', 5000)
        --ESX.ShowNotification("Ingen personer i nærheden")
    end
end

RegisterNetEvent("RunCheck")
AddEventHandler("RunCheck", function(type)
    --local type = type

    --if isDragging then
    --    isDragging = false
    --elseif type == 'drag' and not isDragging then
    --    isDragging = true
    --    TriggerEvent('disableRun')
    --end
end)

RegisterNetEvent("disableRun")
AddEventHandler("disableRun", function()
    while isDragging do
        Wait(0)
        --SetPedMoveRateOverride(GetPlayerPed(-1), 0.6)
        DisableControlAction(0, 21, true)
        DisableControlAction(0, 22, true)
        DisableControlAction(0, 24, true)-- Attack
        DisableControlAction(0, 257, true)-- Attack 2
        DisableControlAction(0, 25, true)-- Aim
        DisableControlAction(0, 263, true)-- Melee Attack 1
    end
end)

function toggleEngine()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
        SetVehicleEngineOn(vehicle, (not GetIsVehicleEngineRunning(vehicle)), false, true)
    end
end

function startScenario(anim)
    TaskStartScenarioInPlace(PlayerPedId(), anim, 0, false)
end

function changeAimStyle(lib)
    local player = PlayerPedId()
    SetWeaponAnimationOverride(player, GetHashKey(lib))
end

function GetVehicleInDirection(coordFrom, coordTo)
    local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, GetPlayerPed(-1), 0)
    local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end
