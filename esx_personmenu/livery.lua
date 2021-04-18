local Items = {['Vehicle'] = {['Native'] = {}, ['Mod'] = {}}, ['Trailer'] = {['Native'] = {}, ['Mod'] = {}}}
local Vehicle = 0; GotTrailer = false; TrailerHandle = 0;

function AddLiveryMenu(menu)
    Items = {['Vehicle'] = {['Native'] = {}, ['Mod'] = {}}, ['Trailer'] = {['Native'] = {}, ['Mod'] = {}}}
    local submenu = _menuPool:AddSubMenu(menu, "~r~Bil Livery", "", 1320, 0)
    local Got, Handle = GetVehicleTrailerVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
    local Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    GotTrailer = Got
    TrailerHandle = Handle
    
    SetVehicleModKit(Vehicle, 0)
    
    -- Vehicle Liveries
    for LiveryID = 0, GetVehicleLiveryCount(Vehicle) - 1 do
        local Item = UIMenuItem.New(GetLabelText(GetLiveryName(Vehicle, LiveryID)), GetLabelText('collision_wcy30') .. ' ' .. GetLabelText(GetLiveryName(Vehicle, LiveryID)))
        submenu:AddItem(Item)
        Items.Vehicle.Native[LiveryID] = Item
    end
    
    for LiveryID = 0, GetNumVehicleMods(Vehicle, 48) - 1 do
        if LiveryID == 0 then
            local Item = UIMenuItem.New(GetLabelText('NONE'), GetLabelText('collision_wcy30') .. ' ' .. GetLabelText('NONE'))
            submenu:AddItem(Item)
            Items.Vehicle.Mod[-1] = Item
        end
        local Item = UIMenuItem.New(GetLabelText(GetModTextLabel(Vehicle, 48, LiveryID)), GetLabelText('collision_wcy30') .. ' ' .. GetLabelText(GetModTextLabel(Vehicle, 48, LiveryID)))
        submenu:AddItem(Item)
        Items.Vehicle.Mod[LiveryID] = Item
    end
    
    submenu.OnItemSelect = function(Sender, Item, Index)
        for Key, Value in pairs(Items.Vehicle.Native) do
            if Item == Value then
                SetVehicleLivery(Vehicle, Key)
            end
        end
        for Key, Value in pairs(Items.Vehicle.Mod) do
            if Item == Value then
                SetVehicleMod(Vehicle, 48, Key, false)
            end
        end
    end
    
    -- Trailer Liveries
    if GotTrailer then
        SetVehicleModKit(TrailerHandle, 0)
        
        for LiveryID = 0, GetVehicleLiveryCount(TrailerHandle) - 1 do
            if not TrailerMenu then
                TrailerMenu = _menuPool:AddSubMenu(submenu, GetLabelText('TRAILER'), '~b~' .. GetLabelText('collision_3esfcr') .. ' - ' .. GetLabelText('TRAILER'))
            end
            
            local Item = UIMenuItem.New(GetLabelText(GetLiveryName(TrailerHandle, LiveryID)), GetLabelText('collision_wcy30') .. ' ' .. GetLabelText(GetLiveryName(TrailerHandle, LiveryID)))
            TrailerMenu:AddItem(Item)
            Items.Trailer.Native[LiveryID] = Item
        end
        
        for LiveryID = 0, GetNumVehicleMods(TrailerHandle, 48) - 1 do
            if not TrailerMenu then
                TrailerMenu = _menuPool:AddSubMenu(submenu, GetLabelText('TRAILER'), '~b~' .. GetLabelText('collision_3esfcr') .. ' - ' .. GetLabelText('TRAILER'))
            end
            
            if LiveryID == 0 then
                local Item = UIMenuItem.New(GetLabelText('NONE'), GetLabelText('collision_wcy30') .. ' ' .. GetLabelText('NONE'))
                TrailerMenu:AddItem(Item)
                Items.Trailer.Mod[-1] = Item
            end
            
            local Item = UIMenuItem.New(GetLabelText(GetModTextLabel(TrailerHandle, 48, LiveryID)), GetLabelText('collision_wcy30') .. ' ' .. GetLabelText(GetModTextLabel(TrailerHandle, 48, LiveryID)))
            TrailerMenu:AddItem(Item)
            Items.Trailer.Mod[LiveryID] = Item
        end
        
        if TrailerMenu then
            TrailerMenu.OnItemSelect = function(Sender, Item, Index)
                if GetVehicleLiveryCount(TrailerHandle) > 0 then
                    for Key, Value in pairs(Items.Trailer.Native) do
                        if Item == Value then
                            SetVehicleMod(TrailerHandle, 48, Key, false)
                        end
                    end
                end
                if GetNumVehicleMods(TrailerHandle, 48) > 0 then
                    for Key, Value in pairs(Items.Trailer.Mod) do
                        if Item == Value then
                            SetVehicleMod(TrailerHandle, 48, Key, false)
                        end
                    end
                end
            end
        end
    end
    
    if GetVehicleLiveryCount(Vehicle) > 0 or GetNumVehicleMods(Vehicle, 48) > 0 or GetVehicleLiveryCount(TrailerHandle) > 0 or GetNumVehicleMods(TrailerHandle, 48) > 0 then
        _menuPool:RefreshIndex()
    end
end
