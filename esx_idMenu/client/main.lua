ESX = nil
local lookMenu = false
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function GetPlayers()
	local players = {}
	for i = 0,255 do
		if NetworkIsPlayerActive(i) then
			table.insert(players, GetPlayerServerId(i))
		end
	end
	return players
end

function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
	local scale = (1/dist)*20
	local fov = (1/GetGameplayCamFov())*100
	local scale = scale*fov   
	SetTextScale(scaleX*scale, scaleY*scale)
	SetTextFont(fontId)
	SetTextProportional(1)
	SetTextColour(250, 250, 250, 255)		-- You can change the text color here
	SetTextDropshadow(1, 1, 1, 1, 255)
	SetTextEdge(2, 0, 0, 0, 150)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(textInput)
	SetDrawOrigin(x,y,z+2, 0)
	DrawText(0.0, 0.0)
	ClearDrawOrigin()
end

RegisterNetEvent("esx_idMenu:showMenu")
AddEventHandler("esx_idMenu:showMenu", function(list)
	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'vis_steam_info',
		{
			title    = "ID Menu",
			align    = 'top-right',
			elements = list
		},
		function(data, menu)
			ESX.ShowNotification("Steamnavn: " .. data.current.name .."\nSteamHexID: " .. data.current.identifier)
		end,
		function(data, menu)
			menu.close()
			local ped = GetPlayerPed(-1)
			lookMenu = false
		end)
end)





Citizen.CreateThread(function()
	Citizen.Wait(1000)
	while true do
		Citizen.Wait(1)
		if IsControlJustPressed(1,11) and not lookMenu then
			local ped = PlayerPedId()
			local players = GetPlayers()
			lookMenu = true
			TriggerServerEvent("esx_idMenu:showMenu",players)
		elseif IsControlJustPressed(1,11) and lookMenu then
			lookMenu = false
		end
		if lookMenu then
			for k,v in pairs(ESX.Game.GetPlayers()) do
				local pos = GetEntityCoords(GetPlayerPed(v))
				Draw3DText(pos.x,pos.y,pos.z-1,GetPlayerServerId(v),0,0.07,0.07)
			end
		end
	end
end)


AddEventHandler('esx:onPlayerDeath', function(data)
	lookMenu = false
end)
