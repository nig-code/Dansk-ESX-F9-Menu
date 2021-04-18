isDead = false

_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Personlig Menu")
_menuPool:Add(mainMenu)

function Settings()
    _menuPool:Remove()
    _menuPool = NativeUI.CreatePool()
    screenWidth, screenHeight = GetResolution()
    verticalSubtractValue = screenHeight * (20/100)
    print(screenHeight)
    mainMenu = NativeUI.CreateMenu("Personlig Menu", "", 0, verticalSubtractValue)
    _menuPool:Add(mainMenu)
    _menuPool:SetBannerRectangle(NativeUI.CreateRectangle(1320, 0, 100, 50, 217, 39, 39, 255))
    disableMouse()
    AddCCMenu(mainMenu)
    AddAnimationsMenu(mainMenu)
    AddVehicleMenu(mainMenu)
    AddVehiOutMenu(mainMenu)
    AddPersonMenu(mainMenu)
    AddPersonInfoMenu(mainMenu)
    AddCrimeMenu(mainMenu)
    AddQuickMenu(mainMenu)
    _menuPool:RefreshIndex()
end

function ClearMenu()
    _menuPool:Remove()
    _menuPool = NativeUI.CreatePool()
    mainMenu = NativeUI.CreateMenu("Personlig Menu")
    _menuPool:Add(mainMenu)
    _menuPool:SetBannerRectangle(NativeUI.CreateRectangle(1320, 0, 100, 50, 217, 39, 39, 255))
    _menuPool:RefreshIndex()
end

function CleanUp()
    Citizen.CreateThread(function()
        while _menuPool:IsAnyMenuOpen() do
            Citizen.Wait(500)
            if not _menuPool:IsAnyMenuOpen() then
                ClearMenu()
            end
            collectgarbage()
        end
    end)
end

Citizen.CreateThread(function()
    local timeHeld = 0
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
        if IsControlPressed(1, 48) and timeHeld > 45 and not _menuPool:IsAnyMenuOpen() then
            if mainMenu:Visible() then
                mainMenu:Visible(false)
            else
                Settings()
                CleanUp()
                mainMenu:Visible(true)
            end
        end
        
        if IsControlPressed(1, 48) then
            timeHeld = timeHeld + 1
        else
            if timeHeld ~= 0 then
                if timeHeld < 44 then
                    TriggerEvent('drp_animations:cleanup')
                end
                timeHeld = 0
            end
        end
    end
end)

function disableMouse()
    _menuPool:ControlDisablingEnabled(false)
    _menuPool:MouseControlsEnabled(false)
    _menuPool:MouseEdgeEnabled(false)
end
