ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("esx_personmeny:giveMoney")
AddEventHandler("esx_personmeny:giveMoney", function(amount, givePed)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local oPlayer = ESX.GetPlayerFromId(givePed)
    if xPlayer.getMoney() < amount then
        TriggerClientEvent('esx:showNotification', _source, 'Du har ikke nok kontanter')
    else
        TriggerClientEvent('esx:showNotification', _source, 'Du gav ~g~'.. amount .. ' DKK~s~ til '.. oPlayer.getName())
        xPlayer.removeMoney(amount)
        TriggerClientEvent('esx:showNotification', givePed, 'Du modtog ~g~'.. amount .. ' DKK~s~ fra ' .. xPlayer.getName())
        oPlayer.addMoney(amount)
    end
end)

RegisterServerEvent("esx_personmeny:giveBlackMoney")
AddEventHandler("esx_personmeny:giveBlackMoney", function(amount, givePed)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local oPlayer = ESX.GetPlayerFromId(givePed)
    if xPlayer.getAccount('black_money').money < amount then
        TriggerClientEvent('esx:showNotification', _source, 'Du har ikke nok Sorte penge')
    else
        TriggerClientEvent('esx:showNotification', _source, 'Du gav ~r~'.. amount .. ' Sorte Penge~s~ til  '.. oPlayer.getName())
        xPlayer.removeAccountMoney('black_money',amount)
        TriggerClientEvent('esx:showNotification', givePed, 'Du modtog ~r~'.. amount .. ' Sorte Penge~s~ fra ' .. xPlayer.getName())
        oPlayer.addAccountMoney('black_money',amount)
    end
end)