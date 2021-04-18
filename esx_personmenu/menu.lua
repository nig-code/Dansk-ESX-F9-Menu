PlayerData = {}
ESX = nil
bankAccount = nil
blackmoneyAccount = nil
gotBike = false
gotCar = false
gotTruck = false
currentSpeed = 1

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)ESX = obj end)
        Citizen.Wait(0)
    end
    
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    
    PlayerData = ESX.GetPlayerData()
    
    local accounts = PlayerData.accounts
    for k, v in pairs(accounts) do
        local account = v
        if account.name == "bank" then
            bankAccount = account.money
        elseif account.name == "black_money" then
            blackmoneyAccount = account.money
        end
    end
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
    if account.name == "bank" then
        bankAccount = account.money
    elseif account.name == "black_money" then
        blackmoneyAccount = account.money
    end
end)

function AddVehicleMenu(menu)
    disableMouse()
    currentPlayer = PlayerPedId()
    if IsPedInAnyVehicle(currentPlayer, false) then
        local submenu = _menuPool:AddSubMenu(menu, "~h~~o~Køretøj", "", 1320, 0)
        for i = 1, #Config.VehicleMenu, 1 do
            local Item = NativeUI.CreateItem(Config.VehicleMenu[i].label, "")
            Item.Activated = function(ParentMenu, SelectedItem)
                VehicleMenuFunctions(Config.VehicleMenu[i].value)
            end
            submenu:AddItem(Item)
        end

        local windows = {
            "Vindue Højre (Front)",
            "Vindue Venstre (Front)",
            "Vindue Højre (Bag)",
            "Vindue Venstre (Bag)",
        }

        local newitem = NativeUI.CreateListItem("Åben/Luk Vinduer", windows, 1)
        submenu:AddItem(newitem)

        submenu.OnListSelect = function(sender, item, index)
            if item == newitem then
                thisDoor = item:IndexToItem(index)
                if thisDoor == "Vindue Højre (Front)" then
                    VehicleMenuFunctions('open_frontwindow_right')
                elseif thisDoor == "Vindue Venstre (Front)" then
                    VehicleMenuFunctions('open_frontwindow_left')
                elseif thisDoor == "Vindue Højre (Bag)" then
                    VehicleMenuFunctions('open_backwindow_right')
                elseif thisDoor == "Vindue Venstre (Bag)" then
                    VehicleMenuFunctions('open_backwindow_left')
                end
                Citizen.Wait(100)
            end
        end

        local engineHealth = GetVehicleEngineHealth(GetVehiclePedIsIn(GetPlayerPed(-1), false))
        if engineHealth > 950 then
            AddLiveryMenu(submenu)
            AddVehiExtraMenu(submenu)
        end
    end
end

function AddCrimeMenu(menu)
    disableMouse()
    local submenu = _menuPool:AddSubMenu(menu, "~h~~o~Interaktion", "", 1320, 0)
    for i = 1, #Config.CrimeMenu, 1 do
        local Item = NativeUI.CreateItem(Config.CrimeMenu[i].label, "")
        Item.Activated = function(ParentMenu, SelectedItem)
            crimeFunctions(Config.CrimeMenu[i].value)
        end
        submenu:AddItem(Item)
    end
end

function AddQuickMenu(menu)
    disableMouse()
    for i = 1, #Config.QuickCommands, 1 do
        local Item = NativeUI.CreateItem(Config.QuickCommands[i].label, "")
        Item.Activated = function(ParentMenu, SelectedItem)
            commonFunctions(Config.QuickCommands[i].value)
        end
        menu:AddItem(Item)
    end
end

function AddPersonMenu(menu)
    disableMouse()
    local submenu = _menuPool:AddSubMenu(menu, "~h~~o~Funktioner", "", 1320, 0)
    for i = 1, #Config.PersonalCommands, 1 do
        local Item = NativeUI.CreateItem(Config.PersonalCommands[i].label, "")
        Item.Activated = function(ParentMenu, SelectedItem)
            commonFunctions(Config.PersonalCommands[i].value)
        end
        submenu:AddItem(Item)
    end
end

function AddVehiOutMenu(menu)
    disableMouse()
    currentPlayer = PlayerPedId()
    if not IsPedInAnyVehicle(currentPlayer, false) then
        local submenu = _menuPool:AddSubMenu(menu, "~h~~o~Køretøjsmenu", "", 1320, 0)
        local Item = NativeUI.CreateItem("Toggle Kølerhjelm", "")

        Item.Activated = function(ParentMenu, SelectedItem)
            VehicleMenuFunctions('open_hood_out')
        end

        submenu:AddItem(Item)
        local Item = NativeUI.CreateItem("Toggle Bagagerum", "")
        Item.Activated = function(ParentMenu, SelectedItem)
            VehicleMenuFunctions('open_trunk_out')
        end

        submenu:AddItem(Item)
        local doors = {
            "Fordør Højre",
            "Fordør Venstre",
            "Bagdør Højre",
            "Bagdør Venstre",
        }

        local newitem = NativeUI.CreateListItem("Toggle døre", doors, 1)
        submenu:AddItem(newitem)

        submenu.OnListSelect = function(sender, item, index)
            if item == newitem then
                thisDoor = item:IndexToItem(index)
                if thisDoor == "Fordør Højre" then
                    VehicleMenuFunctions('open_frontdoor_right')
                elseif thisDoor == "Fordør Venstre" then
                    VehicleMenuFunctions('open_frontdoor_left')
                elseif thisDoor == "Bagdør Højre" then
                    VehicleMenuFunctions('open_backdoor_right')
                elseif thisDoor == "Bagdør Venstre" then
                    VehicleMenuFunctions('open_backdoor_left')
                end
                Citizen.Wait(100)
            end
        end
    end
end

function AddCCMenu(menu)
    disableMouse()
    currentPlayer = PlayerPedId()
    if IsPedInAnyVehicle(currentPlayer, false) then
        local speedlimit = {
            "Clear",
            "50",
            "80",
            "130",
        }

        local newitem = NativeUI.CreateListItem("Fartgrænse", speedlimit, currentSpeed)
        menu:AddItem(newitem)
        
        menu.OnListSelect = function(sender, item, index)
            if item == newitem then
                thisSpeedLimit = item:IndexToItem(index)
                if thisSpeedLimit == "Clear" then
                    currentSpeed = "1"
                    TriggerEvent('drp-speedlimit:set', "clear")
                elseif thisSpeedLimit == "50" then
                    currentSpeed = "2"
                    TriggerEvent('drp-speedlimit:set', 50)
                elseif thisSpeedLimit == "80" then
                    currentSpeed = "3"
                    TriggerEvent('drp-speedlimit:set', 80)
                elseif thisSpeedLimit == "130" then
                    currentSpeed = "4"
                    TriggerEvent('drp-speedlimit:set', 130)
                end
                Citizen.Wait(100)
            end
        end
    end
end

function AddPersonInfoMenu(menu)
    disableMouse()
    local submenu = _menuPool:AddSubMenu(menu, "~h~~o~Information", "", 1320, 0)
    PlayerData = ESX.GetPlayerData()

    if PlayerData.job.grade_name ~= nil and PlayerData.job.name ~= nil then
        local Item = NativeUI.CreateItem("Job: " .. PlayerData.job.label .. " - " .. PlayerData.job.grade_label, "")
        submenu:AddItem(Item)
    elseif PlayerData.job.grade_name == nil then
        local Item = NativeUI.CreateItem("Job: " .. PlayerData.job.label .. "~s~ DKK", "")
        submenu:AddItem(Item)
    elseif PlayerData.job.name == nil then
        local Item = NativeUI.CreateItem("Job: " .. PlayerData.job.grade_label .. "~s~ DKK", "")
        submenu:AddItem(Item)
    end
    
    local Item = NativeUI.CreateItem("Cash: ~g~" .. PlayerData.money .. "~s~ DKK", "")
    submenu:AddItem(Item)
    local Item = NativeUI.CreateItem("Bank: ~g~" .. bankAccount .. "~s~ DKK", "")
    submenu:AddItem(Item)
    local Item = NativeUI.CreateItem("Dirty Penge: ~g~" .. blackmoneyAccount .. "~s~ DKK", "")
    submenu:AddItem(Item)
end

function AddAnimationsMenu(menu)
    disableMouse()

    local submenu = _menuPool:AddSubMenu(menu, "~h~~o~Animations", "", 1320, 0)
    currentPlayer = PlayerPedId()
    if IsPedInAnyVehicle(currentPlayer, false) then
        for i = 1, #Config.CarAnimations, 1 do
            local submenuanim = _menuPool:AddSubMenu(submenu, Config.CarAnimations[i].label, "", 1320, 0)
            for j = 1, #Config.CarAnimations[i].items, 1 do
                local Item = NativeUI.CreateItem(Config.CarAnimations[i].items[j].label, "")
                Item.Activated = function(ParentMenu, SelectedItem)
                    local Name = Config.Animations[i].items[j].name
                    TriggerEvent('drp_animation:OnEmotePlay', Type, Name)
                    Citizen.Wait(100)
                end
                submenuanim:AddItem(Item)
            end
        end
    else
        for i = 1, #Config.Animations, 1 do
            local submenuanim = _menuPool:AddSubMenu(submenu, Config.Animations[i].label, "", 1320, 0)

            local Type = "Emotes"
            if Config.Animations[i].label == "Gangart" then
                Type = "Walks"
            end

            local command = "/emote "
            if Type == "Walks" then
                command = "/walk "
            end

            for j = 1, #Config.Animations[i].items, 1 do
                local Item = NativeUI.CreateItem(Config.Animations[i].items[j].label, command .. Config.Animations[i].items[j].name)
                Item.Activated = function(ParentMenu, SelectedItem)
                    local Name = Config.Animations[i].items[j].name
                    TriggerEvent('drp_animation:OnEmotePlay', Type, Name)
                    Citizen.Wait(100)
                end
                submenuanim:AddItem(Item)
            end
        end
    end
end
