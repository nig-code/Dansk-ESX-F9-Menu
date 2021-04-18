local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX             				 = nil

local cardOpen 					= false
local playerData 				= {}
local windowavg					= false
local windowavd					= false
local windowarg					= false
local windoward					= false
local window 					= false
local engineOn 					= true
local speedkm 					= 0
local persondata        = nil


-- Servern callback
RegisterNetEvent('jsfour-legitimation:open')
AddEventHandler('jsfour-legitimation:open', function(playerData)
	cardOpen = true
	SendNUIMessage({
		action = "open",
		array = playerData
	})
end)

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        ESX.UI.Menu.CloseAll()
        Citizen.Wait(0)
    end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

-- Giving ID Animation
function OpenGivingID()
  local pP = GetPlayerPed(-1)

  Citizen.CreateThread(function()

    local pP = GetPlayerPed(-1)
    TaskPlayAnim(pP, "mp_common", "givetake1_a", 3.5, -8, -1, 2, 0, 0, 0, 0, 0)
    Citizen.CreateThread(function()
      Citizen.Wait(10000)
      TriggerServerEvent('esx_personmeny:give_id')
      ClearPedTasksImmediately(pP)
      end)
    end)
end

-- No one Near Animation
function OpenNoOneNear()
  local pP = GetPlayerPed(-1)

  Citizen.CreateThread(function()

    local pP = GetPlayerPed(-1)
    TaskPlayAnim(pP, "anim@mp_player_intcelebrationmale@face_palm", "face_palm", 3.5, -8, -1, 2, 0, 0, 0, 0, 0)
    Citizen.CreateThread(function()
      Citizen.Wait(10000)
      TriggerServerEvent('esx_personmeny:idnoonenear')
      ClearPedTasksImmediately(pP)
      end)
    end)
end

function OpenTrashCan()
  local pP = GetPlayerPed(-1)

  Citizen.CreateThread(function()

    local pP = GetPlayerPed(-1)
    TaskPlayAnim(pP, "mp_common", "givetake2_a", 3.5, -8, -1, 2, 0, 0, 0, 0, 0)
    TaskStartScenarioInPlace(pP, "mp_common", 0, true)
    Citizen.CreateThread(function()
      Citizen.Wait(2000)
      ClearPedTasksImmediately(pP)
      end)
    end)
end

function OpenAttansCan()
  local pP = GetPlayerPed(-1)

  Citizen.CreateThread(function()

    local pP = GetPlayerPed(-1)
    TaskPlayAnim(pP, "gestures@m@standing@casual", "gesture_damn", 3.5, -8, -1, 2, 0, 0, 0, 0, 0)
    TaskStartScenarioInPlace(pP, "gestures@m@standing@casual", 0, true)
    FreezeEntityPosition(playerPed, true)
    Citizen.CreateThread(function()
      Citizen.Wait(2000)
      FreezeEntityPosition(playerPed, false)
      ClearPedTasksImmediately(pP)
      end)
    end)
end

function OpenShowGiveID()

ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'id_card_menu',
	{
		title    = _U('id_menu'),
		align    = 'top-left',
		elements = {
			{label = _U('se_dit_id'), value = 'se_dit_id'},
			{label = _U('vis_dit_id'), value = 'vis_dit_id'},	
			{label = _U('se_dit_driverslic'), value = 'se_dit_driverslic'},
			{label = _U('vis_dit_driverslic'), value = 'vis_dit_driverslic'},			
			--{label = _U('se_dine_licenser'), value = 'se_dine_licenser'},
		}
	},
	function(data2, menu2)
		if data2.current.value == 'se_dit_id' then
			TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
		elseif data2.current.value == 'vis_dit_id' then
			local player, distance = ESX.Game.GetClosestPlayer()

			if distance ~= -1 and distance <= 3.0 then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
			else
				ESX.ShowNotification(_U('nobody_near'))
			end
		--elseif data2.current.value == 'se_dine_licenser' then
			--SeYourLicensesMenu()
		elseif data2.current.value == 'se_dit_driverslic' then
			TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
		elseif data2.current.value == 'vis_dit_driverslic' then
			local player, distance = ESX.Game.GetClosestPlayer()

			if distance ~= -1 and distance <= 3.0 then
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player), 'driver')
			else
				ESX.ShowNotification(_U('nobody_near'))
			end
		end
	end,
	function(data2, menu2)
		menu2.close()
		OpenCivilianActionsMenu()
	end
)

end

function OpenHandlinger()

ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'handlinger_menu',
	{
		title    = _U('handlinger_menu'),
		align    = 'top-left',
		elements = {
--			{label = _U('id_card'), value = 'id_card'},
			{label = _U('regninger'), value = 'regninger'},
			{label = _U('animationer'), value = 'animationer'},
		}
	},
	function(data2, menu2)
		if data2.current.value == 'id_card' then
			OpenShowGiveID()
		elseif data2.current.value == 'regninger' then
			openBillsMenu()
    elseif data2.current.value == 'animationer' then
      ESX.UI.Menu.CloseAll()
      exports['db_emotes-cmds']:OpenEmoteMenu() 
		end
	end,
	function(data2, menu2)
		menu2.close()
		OpenCivilianActionsMenu()
	end
)
end

function OpenPung()

ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'pung_menu',
	{
		title    = _U('pung_menu'),
		align    = 'top-left',
		elements = {
			{label = _U('show_money'), value = 'show_money'},
			{label = _U('giv_penge'), value = 'giv_penge'},
			{label = _U('giv_sort_penge'), value = 'giv_sort_penge'},
		}
	},
	function(data2, menu2)
		if data2.current.value == 'show_money' then
			OpenWallet()
		elseif data2.current.value == 'giv_penge' then
      GiveItemMoney()
		elseif data2.current.value == 'giv_sort_penge' then
			GiveBlackMoney()
		end
	end,
	function(data2, menu2)
		menu2.close()
		OpenCivilianActionsMenu()
	end
)
end

function OpenMobile()
	ESX.UI.Menu.CloseAll()
	TriggerEvent('gcPhone:forceOpenPhone')
end

function OpenWallet()
  print("ok")
  ESX.UI.Menu.CloseAll()
	TriggerEvent('allcity_wallet:open')
end

function OpenInventory()
	ESX.UI.Menu.CloseAll()
	TriggerEvent('esx:openInventory')
end

function OpenFunktioner()
	ESX.UI.Menu.CloseAll()
--  TriggerEvent('esx:openInventory') OpenSearchActionsMenu()
  exports['db_thiefmenu']:OpenSearchActionsMenu()
end

function OpenVehicleInventory()
	ESX.UI.Menu.CloseAll()
  TriggerEvent('esx_trunk_inventory:openmenuvehicle')
--  exports['esx_trunk']:openmenuvehicle()
end

function openBillsMenu()
	ESX.UI.Menu.CloseAll()
--  TriggerEvent('esx_billing:openBills')
  exports['esx_billing']:ShowBillsMenu()
end

function openAnimationMenu()
	ESX.UI.Menu.CloseAll()
	TriggerEvent('esx_animations:openAniMenu')
end

function OpenAccessoryMenu()
	ESX.UI.Menu.CloseAll()
	TriggerEvent('esx_accessories:OpenAccessoryMenu')
end

function OpenActionMenuInteraction()
	ESX.UI.Menu.CloseAll()
	TriggerEvent('esx_barbie_lyftupp:OpenActionMenuInteraction')
end

function OpenCivilianActionsMenu()

  ESX.UI.Menu.CloseAll()
  local menuItems = {
--  {label = _U('taske'), value = 'taske'},
  {label = _U('id_card'), value = 'id_card'},
  {label = _U('pung'), value = 'pung'},
  {label = _U('funktioner'), value = 'funktioner'},
--  {label = _U('mobil'), value = 'mobil'},
  {label = _U('handlinger'), value = 'handlinger'},
  {label = _U('vehicle_menu'), value = 'vehiclemenu'}}
  local elements = {}
  for k,v in pairs(menuItems) do
    table.insert(elements,v)
  end
  if PlayerData.job.name == "police" then
    table.insert(elements,{label = "Politimenu" ,value = 'police'})
  end
  ESX.UI.Menu.Open(
  'default', GetCurrentResourceName(), 'civilian_actions',
  {
    title    = _U('citizen_interactions'),
    align    = 'top-left',
    elements = elements
  },
    
    function(data, menu)
	  
	  if data.current.value == 'taske' then
		OpenInventory()
    end
    
    if data.current.value == 'funktioner' then
    OpenFunktioner()
    end
	  
	  if data.current.value == 'pung' then
		OpenPung()
    end

    if data.current.value == 'id_card' then
      OpenShowGiveID()
    end
    
	  if data.current.value == 'mobil' then
		OpenMobile()
	  end

    if data.current.value == 'handlinger' then
      OpenHandlinger()
    end
    if data.current.value == 'police' then
      TriggerEvent('esx_policejob:openPoliceMenu')
    end
	  
	  if data.current.value == 'vehiclemenu' then
		OpenVehicleMenu()
	  end

      --[[if data.current.value == 'vehiclemenu' then
        local playerPed = GetPlayerPed(-1)
        if IsPedSittingInAnyVehicle(playerPed) then
            local playerVeh = GetVehiclePedIsIn(playerPed, false)
            local drivingPed = GetPedInVehicleSeat(playerVeh, -1)
            if drivingPed == playerPed then
                OpenVehicleMenu()
            end
		else
			ESX.ShowNotification("Intet køretøj i nærheden")
        end
      end]]--

      --[[if data.current.value == 'check' then
            TriggerServerEvent('jsfour-legitimation:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
      elseif data.current.value == 'show' then
           local player, distance = ESX.Game.GetClosestPlayer()

      if distance ~= -1 and distance <= 3.0 then
        TriggerServerEvent('jsfour-legitimation:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(player))
      else
        ESX.ShowAdvancedNotification('Individåtgärder', '', _U('nobody_near'), 'CHAR_DEFAULT', 8)
      end
    end]]--
    end,
    function(data, menu)
      menu.close()
    end
  )
end

function OpenVehicleMenu()

  ESX.UI.Menu.CloseAll()

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'vehicle_actions',
    {
      title    = _U('vehicle_menu'),
      align    = 'top-left',
      elements = {
        {label = _U('vehtrunk'),           	value = 'vehtrunk'},
        {label = _U('engine'),           	value = 'engine'},
        {label = _U('doors'),        		value = 'door'},
        {label = _U('window'),      		value = 'window'},
        --{label = _U('cruise_control'),      value = 'cruise_control'},
        --{label = _U('shuff'),      			value = 'changeseat'},
      }
    },
    function(data, menu)
      if data.current.value == 'vehtrunk' then
        OpenVehicleInventory()
      end
	  
      if data.current.value == 'engine' then
        local playerPed = GetPlayerPed(-1)
          local playerVeh = GetVehiclePedIsIn(playerPed, false)
        if engineOn == true then
                SetVehicleUndriveable(playerVeh, true)
            SetVehicleEngineOn(playerVeh, false, false, false)
            engineOn = false
        else
          SetVehicleUndriveable(playerVeh, false)
            SetVehicleEngineOn(playerVeh, true, false, false)       
                engineOn = true
        end
      end

      if data.current.value == 'changeseat' then
        TriggerEvent("SeatShuffle")
      end

      if data.current.value == 'door' then
        ESX.UI.Menu.CloseAll()

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'door_actions',
          {
            title    = _U('doors'),
            align    = 'top-left',
            elements = {
              {label = _U('hood'),        value = 'hood'},
              {label = _U('trunk'),           value = 'trunk'},
              {label = _U('front_left_door'),   value = 'dooravg'},
              {label = _U('front_right_door'),     value = 'dooravd'},
              {label = _U('back_left_door'),      value = 'doorarg'},
              {label = _U('back_right_door'),      value = 'doorard'}
            }
          },
          function(data, menu)
            if data.current.value == 'hood' then
              local playerPed = GetPlayerPed(-1)
                local playerVeh = GetVehiclePedIsIn(playerPed, false)
                if (IsPedSittingInAnyVehicle(playerPed)) then
                  if GetVehicleDoorAngleRatio(playerVeh, 4) > 0.0 then 
                      SetVehicleDoorShut(playerVeh, 4, false)
                   else
                      SetVehicleDoorOpen(playerVeh, 4, false)
                      frontleft = true
                    end
                end
            end
            if data.current.value == 'trunk' then
              local playerPed = GetPlayerPed(-1)
                local playerVeh = GetVehiclePedIsIn(playerPed, false)
                if ( IsPedSittingInAnyVehicle( playerPed ) ) then
                   if GetVehicleDoorAngleRatio(playerVeh, 5) > 0.0 then 
                      SetVehicleDoorShut(playerVeh, 5, false)
                    else
                      SetVehicleDoorOpen(playerVeh, 5, false)
                      frontleft = true  
                   end
                end
            end
            if data.current.value == 'dooravg' then
              local playerPed = GetPlayerPed(-1)
                local playerVeh = GetVehiclePedIsIn(playerPed, false)
                if ( IsPedSittingInAnyVehicle( playerPed ) ) then
                   if GetVehicleDoorAngleRatio(playerVeh, 0) > 0.0 then 
                      SetVehicleDoorShut(playerVeh, 0, false)
                    else
                      SetVehicleDoorOpen(playerVeh, 0, false)
                      frontleft = true
                   end
                end
            end
            if data.current.value == 'dooravd' then
              local playerPed = GetPlayerPed(-1)
                local playerVeh = GetVehiclePedIsIn(playerPed, false)
                if ( IsPedSittingInAnyVehicle( playerPed ) ) then
                   if GetVehicleDoorAngleRatio(playerVeh, 1) > 0.0 then 
                      SetVehicleDoorShut(playerVeh, 1, false)
                    else
                      SetVehicleDoorOpen(playerVeh, 1, false)
                      frontleft = true  
                   end
                end
            end
            if data.current.value == 'doorarg' then
              local playerPed = GetPlayerPed(-1)
                local playerVeh = GetVehiclePedIsIn(playerPed, false)
                if ( IsPedSittingInAnyVehicle( playerPed ) ) then
                   if GetVehicleDoorAngleRatio(playerVeh, 2) > 0.0 then 
                      SetVehicleDoorShut(playerVeh, 2, false)
                    else
                      SetVehicleDoorOpen(playerVeh, 2, false)
                      frontleft = true  
                   end
                end
            end
            if data.current.value == 'doorard' then
              local playerPed = GetPlayerPed(-1)
                local playerVeh = GetVehiclePedIsIn(playerPed, false)
                if ( IsPedSittingInAnyVehicle( playerPed ) ) then
                   if GetVehicleDoorAngleRatio(playerVeh, 3) > 0.0 then 
                      SetVehicleDoorShut(playerVeh, 3, false)
                    else
                      SetVehicleDoorOpen(playerVeh, 3, false)
                      frontleft = true
                   end
                end
            end
          end,
        function(data, menu)
          menu.close()
          OpenVehicleMenu()
        end
        )
      end
      if data.current.value == 'window' then
        ESX.UI.Menu.CloseAll()

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'window_actions',
          {
            title    = _U('window_menu'),
            align    = 'top-left',
            elements = {
              {label = _U('front_left_window'),   value = 'windowavga'},
              {label = _U('front_right_window'),   value = 'windowavdr'},
              {label = _U('back_left_window'),   value = 'windowarga'},
              {label = _U('back_right_window'),   value = 'windowardr'}
            }
          },
          function(data, menu)
            if data.current.value == 'windowavga' then
              local playerPed = GetPlayerPed(-1)
                local playerVeh = GetVehiclePedIsIn(playerPed, false)
                if windowavg == false then
                      RollDownWindow(playerVeh, 0)
                      windowavg = true
                      TriggerEvent("pNotify:SendNotification", {text = _U('opened_window'), type = "error", queue = "vehiclemenu", timeout = 1000, layout = "bottomLeft"})
                else
                  RollUpWindow(playerVeh, 0)
                      windowavg = false
                  TriggerEvent("pNotify:SendNotification", {text = _U('closed_wondow'), type = "success", queue = "vehiclemenu", timeout = 1000, layout = "bottomLeft"})
                end
            end
            if data.current.value == 'windowavdr' then
              local playerPed = GetPlayerPed(-1)
                local playerVeh = GetVehiclePedIsIn(playerPed, false)
                if windowavd == false then
                      RollDownWindow(playerVeh, 1)
                      windowavd = true
                  TriggerEvent("pNotify:SendNotification", {text = _U('opened_window'), type = "error", queue = "vehiclemenu", timeout = 1000, layout = "bottomLeft"})
                else
                  RollUpWindow(playerVeh, 1)
                      windowavd = false
                  TriggerEvent("pNotify:SendNotification", {text = _U('closed_wondow'), type = "success", queue = "vehiclemenu", timeout = 1000, layout = "bottomLeft"})
                end
            end
            if data.current.value == 'windowarga' then
              local playerPed = GetPlayerPed(-1)
                local playerVeh = GetVehiclePedIsIn(playerPed, false)
                if windowarg == false then
                      RollDownWindow(playerVeh, 2)
                      windowarg = true
                  TriggerEvent("pNotify:SendNotification", {text = _U('opened_window'), type = "error", queue = "vehiclemenu", timeout = 1000, layout = "bottomLeft"})
                else
                  RollUpWindow(playerVeh, 2)
                      windowarg = false
                  TriggerEvent("pNotify:SendNotification", {text = _U('closed_wondow'), type = "success", queue = "vehiclemenu", timeout = 1000, layout = "bottomLeft"})
                end
            end
            if data.current.value == 'windowardr' then
              local playerPed = GetPlayerPed(-1)
                local playerVeh = GetVehiclePedIsIn(playerPed, false)
                if windoward == false then
                      RollDownWindow(playerVeh, 3)
                      windoward = true
                  TriggerEvent("pNotify:SendNotification", {text = _U('opened_window'), type = "error", queue = "vehiclemenu", timeout = 1000, layout = "bottomLeft"})
                else
                  RollUpWindow(playerVeh, 3)
                      windoward = false
                  TriggerEvent("pNotify:SendNotification", {text = _U('closed_wondow'), type = "success", queue = "vehiclemenu", timeout = 1000, layout = "bottomLeft"})
                end
            end
          end,
        function(data, menu)
          menu.close()
          OpenVehicleMenu()
        end
        )
      end
      if data.current.value == 'cruise_control' then
        ESX.UI.Menu.CloseAll()

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'cruise_control_actions',
          {
            title    = _U('cruise_control'),
            align    = 'top-left',
            elements = {
              {label = _U('disabled'),   value = 'none'},
              {label = '40Km/h',    value = '40'},
              {label = '80Km/h',    value = '80'},
              {label = '130Km/h',   value = '130'},
            }
          },
          function(data, menu)
            if data.current.value == 'none' then
              local playerPed = GetPlayerPed(-1)
                local playerVeh = GetVehiclePedIsIn(playerPed, false)
                local modelVeh  = GetEntityModel(playerVeh)
                local maxSpeed  = GetVehicleMaxSpeed(modelVeh)
                SetEntityMaxSpeed(playerVeh, maxSpeed)
                TriggerEvent("pNotify:SendNotification", {text = _U('disabled_cruise_control'), type = "error", queue = "vehiclemenu", timeout = 1000, layout = "bottomLeft"})
            end
            if data.current.value == '40' then
              local speedkm   = 40
              local speed   = speedkm/3.6
              local playerPed = GetPlayerPed(-1)
                local playerVeh = GetVehiclePedIsIn(playerPed, false)
                SetEntityMaxSpeed(playerVeh, speed)
                TriggerEvent("pNotify:SendNotification", {text = "Du satte farthållaren på 40Km/h", type = "info", queue = "vehiclemenu", timeout = 1000, layout = "bottomLeft"})
            end
            if data.current.value == '80' then
              local speedkm   = 80
              local speed   = speedkm/3.6
              local playerPed = GetPlayerPed(-1)
                local playerVeh = GetVehiclePedIsIn(playerPed, false)
                SetEntityMaxSpeed(playerVeh, speed)
                TriggerEvent("pNotify:SendNotification", {text = "Du satte farthållaren på 80Km/h", type = "info", queue = "vehiclemenu", timeout = 1000, layout = "bottomLeft"})
            end
            if data.current.value == '130' then
              local speedkm   = 130
              local speed   = speedkm/3.6
              local playerPed = GetPlayerPed(-1)
                local playerVeh = GetVehiclePedIsIn(playerPed, false)
                SetEntityMaxSpeed(playerVeh, speed)
                TriggerEvent("pNotify:SendNotification", {text = "Du satte farthållaren på 130Km/h", type = "info", queue = "vehiclemenu", timeout = 1000, layout = "bottomLeft"})
            end
          end,
        function(data, menu)
          menu.close()
          OpenVehicleMenu()
        end
        )
      end
    end,
  function(data, menu)
    menu.close()
    OpenCivilianActionsMenu()
  end
  )
end

-- Close the ID card
-- Key events
Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsControlPressed(0, 322) or IsControlPressed(0, 177) and cardOpen then
			SendNUIMessage({
				action = "close"
			})
			cardOpen = false
		end
	end
end)

Citizen.CreateThread(function()
  while true do
    Wait(0)
    if IsControlPressed(0, 56) then
      OpenCivilianActionsMenu()
    end
  end
end)

-- Bälte


local speedBuffer  = {}
local velBuffer    = {}
local beltOn       = false
local wasInCar     = false

IsCar = function(veh)
        local vc = GetVehicleClass(veh)
        return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
        end 

Fwv = function (entity)
        local hr = GetEntityHeading(entity) + 90.0
        if hr < 0.0 then hr = 360.0 + hr end
        hr = hr * 0.0174533
        return { x = math.cos(hr) * 2.0, y = math.sin(hr) * 2.0 }
      end



local disableShuffle = true
function disableSeatShuffle(flag)
  disableShuffle = flag
end

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    if IsPedInAnyVehicle(GetPlayerPed(-1), false) and disableShuffle then
      if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) == GetPlayerPed(-1) then
        if GetIsTaskActive(GetPlayerPed(-1), 165) then
          SetPedIntoVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
        end
      end
    end
  end
end)

RegisterNetEvent("SeatShuffle")
AddEventHandler("SeatShuffle", function()
  if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
    disableSeatShuffle(false)
    Citizen.Wait(5000)
    disableSeatShuffle(true)
  else
    CancelEvent()
  end
end)

RegisterCommand("shuff", function(source, args, raw) --change command here
    TriggerEvent("SeatShuffle")
end, false)

Citizen.CreateThread(function() 
	while true do
		Citizen.Wait(1000)
		TriggerServerEvent('allcity_wallet:getMoneys')
	end
	
end)

function GiveItemMoney()
  local player = GetPlayerPed(-1)
  local players = GetPlayers()
  local closestCoord = -1
  local pc = GetEntityCoords(player)
  local closePlayer = nil
  for key,value in pairs(players) do
    local coord = GetEntityCoords(GetPlayerPed(value))
    local dist = GetDistanceBetweenCoords(coord.x,coord.y,coord.z,pc.x,pc.y,pc.z)
    if dist ~= 0.0 then
      if (dist < closestCoord and dist ~= 0) or closestCoord == -1 then
        closestCoord = dist
        closePlayer = value
      end
    end
  end
  if closePlayer ~= nil then
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'inventory_item_count_remove', {
      title = "Beløb"
      }, function(data2, menu2)
      local quantity = tonumber(data2.value)
      if quantity == nil then
        ESX.ShowNotification("Ugyldigt Beløb")
      else
        TriggerServerEvent('esx_personmeny:giveMoney',  quantity, GetPlayerServerId(closePlayer))
        menu2.close()
      end
    end, function(data2, menu2)
      menu2.close()
    end)
  else
    ESX.ShowNotification("~r~Der er ikke nogen i nærheden~s~")
  end
  
end

function GiveBlackMoney()
  local player = GetPlayerPed(-1)
  local players = GetPlayers()
  local closestCoord = -1
  local pc = GetEntityCoords(player)
  local closePlayer = nil
  for key,value in pairs(players) do
    local coord = GetEntityCoords(GetPlayerPed(value))
    local dist = GetDistanceBetweenCoords(coord.x,coord.y,coord.z,pc.x,pc.y,pc.z)
    if dist ~= 0 then
      if dist < closestCoord or closestCoord == -1 then
        closestCoord = dist
        closePlayer = value
      end
    end
  end
  if closePlayer ~= nil then
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'inventory_item_count_remove', {
      title = "Beløb"
      }, function(data2, menu2)
      local quantity = tonumber(data2.value)
      if quantity == nil then
        ESX.ShowNotification("Ugyldig Beløb")
      else
        TriggerServerEvent('esx_personmeny:giveBlackMoney',  quantity, GetPlayerServerId(closePlayer))
        menu2.close()
      end
    end, function(data2, menu2)
      menu2.close()
    end)
  else
    ESX.ShowNotification("~r~Der er ikke nogen i nærheden~s~")
  end

end

function GetPlayers()
  local players = {}

  for i = 0, 31 do
      if NetworkIsPlayerActive(i) then
          table.insert(players, i)
      end
  end

  return players
end

function StripsMenuBetter()
  ESX.UI.Menu.CloseAll()
  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'stripsmenu',
    {
      title    = 'STRIPS',
      align    = 'top-left',
      elements = elements
    }, function(data2, menu2)
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if closestPlayer ~= -1 and closestDistance <= 3.0 then
  
        if data2.current.value == 'strips' then
            TriggerServerEvent('esx2_policejob:handcuff', GetPlayerServerId(closestPlayer))
				end
				if data2.current.value == 'eskorter' then
          TriggerServerEvent('esx_policejob:drag', GetPlayerServerId(closestPlayer))
				end
				if data2.current.value == 'putinvehicle' then
					TriggerServerEvent('esx_policejob:putInVehicle', GetPlayerServerId(closestPlayer))
				end
				if data2.current.value == 'outthevehicle' then
					TriggerServerEvent('esx_policejob:OutVehicle', GetPlayerServerId(closestPlayer))
				end
      else
        ESX.ShowNotification('~r~Der er ingen spillere i nærheden.')
      end
    end,
      function(data2, menu2)
        menu2.close()
      end
    )
end

