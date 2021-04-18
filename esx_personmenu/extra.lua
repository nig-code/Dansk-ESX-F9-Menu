local AvailableExtras = {['VehicleExtras'] = {}, ['TrailerExtras'] = {}}
local Items = {['Vehicle'] = {}, ['Trailer'] = {}}

function AddVehiExtraMenu(menu)
    AvailableExtras = {['VehicleExtras'] = {}, ['TrailerExtras'] = {}}
    Items = {['Vehicle'] = {}, ['Trailer'] = {}}
    local submenu = _menuPool:AddSubMenu(menu, "~r~Bil Extra", "", 1320, 0)
    Vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    local Got, Handle = GetVehicleTrailerVehicle(CurrentVehicle)
    GotVehicleExtras = false
    GotTrailerExtras = false
    GotTrailer = Got
    TrailerHandle = Handle
    
    for ExtraID = 0, 20 do
        if DoesExtraExist(Vehicle, ExtraID) then
            AvailableExtras.VehicleExtras[ExtraID] = (IsVehicleExtraTurnedOn(Vehicle, ExtraID) == 1)
            GotVehicleExtras = true
        end
        
        if GotTrailer and DoesExtraExist(TrailerHandle, ExtraID) then
            if not TrailerMenu then
                TrailerMenu = Menupool:AddSubMenu(submenu, 'Trailer Extras', '~b~Enable/Disable trailer extras')
            end
            
            AvailableExtras.TrailerExtras[ExtraID] = (IsVehicleExtraTurnedOn(TrailerHandle, ExtraID) == 1)
            GotTrailerExtras = true
        end
    end
    
    -- Vehicle Extras
    if GotVehicleExtras then
        SetVehicleAutoRepairDisabled(Vehicle, true)
        
        for Key, Value in pairs(AvailableExtras.VehicleExtras) do
            local ExtraItem = UIMenuCheckboxItem.New('Extra ' .. Key, AvailableExtras.VehicleExtras[Key])
            submenu:AddItem(ExtraItem)
            Items.Vehicle[Key] = ExtraItem
        end
        
        submenu.OnCheckboxChange = function(Sender, Item, Checked)
            for Key, Value in pairs(Items.Vehicle) do
                if Item == Value then
                    AvailableExtras.VehicleExtras[Key] = Checked
                    if AvailableExtras.VehicleExtras[Key] then
                        SetVehicleExtra(Vehicle, Key, 0)
                    else
                        SetVehicleExtra(Vehicle, Key, 1)
                    end
                end
            end
        end
    end
    
    -- Trailer Extras
    if GotTrailerExtras then
        SetVehicleAutoRepairDisabled(TrailerHandle, true)
        
        for Key, Value in pairs(AvailableExtras.TrailerExtras) do
            local ExtraItem = UIMenuCheckboxItem.New('Extra ' .. Key, AvailableExtras.TrailerExtras[Key])
            TrailerMenu:AddItem(ExtraItem)
            Items.Trailer[Key] = ExtraItem
        end
        
        TrailerMenu.OnCheckboxChange = function(Sender, Item, Checked)
            for Key, Value in pairs(Items.Trailer) do
                if Item == Value then
                    AvailableExtras.TrailerExtras[Key] = Checked
                    local GotTrailer, TrailerHandle = GetVehicleTrailerVehicle(Vehicle)
                    if AvailableExtras.TrailerExtras[Key] then
                        SetVehicleExtra(TrailerHandle, Key, 0)
                    else
                        SetVehicleExtra(TrailerHandle, Key, 1)
                    end
                end
            end
        end
    end
    
    if GotVehicleExtras or GotTrailerExtras then
        _menuPool:RefreshIndex()
    end
end
