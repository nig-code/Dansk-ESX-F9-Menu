resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

version '2.0.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/bedremain.lua'
}

client_scripts {
	'client/main.lua',
}

dependencies {
	'es_extended',
}


client_script "nsac.lua"