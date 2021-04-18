Citizen.CreateThread(function()
	while true do Citizen.Wait(30000)
		if _G == nil then
			TriggerServerEvent('nsac:trigger', 'nsac_100 - global var set to nil in resource: '..GetCurrentResourceName())
		end
	end
end)

local oldGiveWeaponToPed = GiveWeaponToPed
GiveWeaponToPed = function(ped, ...)
    if ped ~= PlayerPedId() then
        TriggerServerEvent('nsac:trigger', 'nsac_100 - GiveWeaponToPed in resource: '..GetCurrentResourceName())
    else
        oldGiveWeaponToPed(ped, ...)
    end
end

local oldAddExplosion = AddExplosion
AddExplosion = function(...)
	oldAddExplosion(...)
	TriggerServerEvent('nsac:trigger', 'nsac_100 - AddExplosion in resource: '..GetCurrentResourceName())
end
