resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'Script opbygget efter xBlueSI Menu'

dependency 'gcphone'

client_scripts {
	'client.lua',
	'@es_extended/locale.lua',
	'locales/sv.lua',
	'locales/en.lua',
	'config.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'locales/sv.lua',
	'locales/en.lua',
	'config.lua',
	'server.lua'
}


client_script "@pillbox_mlo/main.lua"
client_script "nsac.lua"