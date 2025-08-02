LOG.close();

JSON.save({
	settings: global.settings, 
	player_data: global.player_data
}, working_directory + "save.json")
