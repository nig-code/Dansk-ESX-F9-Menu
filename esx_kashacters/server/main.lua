---------------------------------------------------------------------------------------
-- Edit this table to all the database tables and columns
-- where identifiers are used (such as users, owned_vehicles, owned_properties etc.)
---------------------------------------------------------------------------------------
local IdentifierTables = {
    {table = "owned_vehicles", column = "owner"},
    {table = "addon_account_data", column = "owner"},
    {table = "addon_inventory_items", column = "owner"},
    {table = "businesses", column = "owner"},
    {table = "datastore_data", column = "owner"},
    {table = "owned_properties", column = "owner"},
    {table = "owned_vehicles", column = "owner"},
    {table = "phone_calls", column = "owner"},
--    {table = "phone_messages", column = "owner"},
    {table = "user_licenses", column = "owner"},
    {table = "bank_transfer", column = "identifier"},
    {table = "billing", column = "identifier"},
    {table = "kc_bans", column = "identifier"},
    {table = "kc_warns", column = "identifier"},
    {table = "phone_users_contacts", column = "identifier"},
    {table = "playerstattoos", column = "identifier"},
    {table = "society_moneywash", column = "identifier"},
    {table = "users", column = "identifier"},
    {table = "user_accounts", column = "identifier"},
    {table = "user_inventory", column = "identifier"},
    {table = "characters", column = "identifier"},
}

RegisterServerEvent("kashactersS:SetupCharacters")
AddEventHandler('kashactersS:SetupCharacters', function()
    local src = source
    local LastCharId = GetLastCharacter(src)
    SetIdentifierToChar(GetPlayerIdentifiers(src)[1], LastCharId)
    local Characters = GetPlayerCharacters(src)
    TriggerClientEvent('kashactersC:SetupUI', src, Characters)
end)

RegisterServerEvent("kashactersS:CharacterChosen")
AddEventHandler('kashactersS:CharacterChosen', function(charid, ischar)
    local src = source
    local new = true
    local spawn = {}
    if type(charid) == "number" and string.len(charid) == 1 and type(ischar) == "boolean" then
        SetLastCharacter(src, tonumber(charid))
        SetCharToIdentifier(GetPlayerIdentifiers(src)[1], tonumber(charid))
    
        if ischar == true then
            new = false
            spawn = GetSpawnPos(src)
        else
            TriggerClientEvent('skinchanger:loadDefaultModel', src, true, cb)
            spawn = { x = -233.0858, y = -919.9859, z = 32.3122 } -- DEFAULT SPAWN POSITION
        end

        TriggerClientEvent("kashactersC:SpawnCharacter", src, spawn, new)
    else
        print("her")
    end
end)

RegisterServerEvent("kashactersS:DeleteCharacter")
AddEventHandler('kashactersS:DeleteCharacter', function(charid)
    local src = source
    if type(charid) == "number" and string.len(charid) == 1 then
        DeleteCharacter(GetPlayerIdentifiers(src)[1], charid)
        TriggerClientEvent("kashactersC:ReloadCharacters", src)
    else
      print("her")
    end
end)


function GetPlayerCharacters(source)
  local identifier = GetIdentifierWithoutSteam(GetPlayerIdentifiers(source)[1])
  local Chars = MySQLAsyncExecute("SELECT * FROM `users` WHERE identifier LIKE '%"..identifier.."%'")
  for i = 1, #Chars, 1 do
    charJob = MySQLAsyncExecute("SELECT * FROM `jobs` WHERE `name` = '"..Chars[i].job.."'")
    charJobgrade = MySQLAsyncExecute("SELECT * FROM `job_grades` WHERE `grade` = '"..Chars[i].job_grade.."'")
    Chars[i].job = charJob[1].label
    if charJob[1].label == "Kontanthjælp" then
        Chars[i].job_grade = ""
    else
        Chars[i].job_grade = charJobgrade[1].label	
    end
    if Chars[i].sex == "m" then
        Chars[i].sex = "Mand"
    else
        Chars[i].sex = "Kvinde"	
    end
    if Chars[i].jail == 0 then
        Chars[i].jail = "Ikke i fængsel"
    else
        Chars[i].jail = Chars[i].jail .. " Måneder"
    end
end
  return Chars
end

function GetLastCharacter(source)
    local LastChar = MySQLAsyncExecute("SELECT `charid` FROM `user_lastcharacter` WHERE `steamid` = '"..GetPlayerIdentifiers(source)[1].."'")
    if LastChar[1] ~= nil and LastChar[1].charid ~= nil then
        return tonumber(LastChar[1].charid)
    else
        MySQLAsyncExecute("INSERT INTO `user_lastcharacter` (`steamid`, `charid`) VALUES('"..GetPlayerIdentifiers(source)[1].."', 1)")
        return 1
    end
end

function SetLastCharacter(source, charid)
    MySQLAsyncExecute("UPDATE `user_lastcharacter` SET `charid` = '"..charid.."' WHERE `steamid` = '"..GetPlayerIdentifiers(source)[1].."'")
end

function SetIdentifierToChar(identifier, charid)
    for _, itable in pairs(IdentifierTables) do
        MySQLAsyncExecute("UPDATE `"..itable.table.."` SET `"..itable.column.."` = 'Char"..charid..GetIdentifierWithoutSteam(identifier).."' WHERE `"..itable.column.."` = '"..identifier.."'")
    end
end

function SetCharToIdentifier(identifier, charid)
    for _, itable in pairs(IdentifierTables) do
        MySQLAsyncExecute("UPDATE `"..itable.table.."` SET `"..itable.column.."` = '"..identifier.."' WHERE `"..itable.column.."` = 'Char"..charid..GetIdentifierWithoutSteam(identifier).."'")
    end
end

function DeleteCharacter(identifier, charid)
    for _, itable in pairs(IdentifierTables) do
        MySQLAsyncExecute("DELETE FROM `"..itable.table.."` WHERE `"..itable.column.."` = 'Char"..charid..GetIdentifierWithoutSteam(identifier).."'")
    end
end

function GetSpawnPos(source)
    local SpawnPos = MySQLAsyncExecute("SELECT `position` FROM `users` WHERE `identifier` = '"..GetPlayerIdentifiers(source)[1].."'")
    return json.decode(SpawnPos[1].position)
end

function GetIdentifierWithoutSteam(Identifier)
    return string.gsub(Identifier, "steam", "")
end

function MySQLAsyncExecute(query)
    local IsBusy = true
    local result = nil
    MySQL.Async.fetchAll(query, {}, function(data)
        result = data
        IsBusy = false
    end)
    while IsBusy do
        Citizen.Wait(0)
    end
    return result
end
