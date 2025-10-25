

JSON.save({
	settings: global.settings, 
	player_data: global.player_data
}, "%localappdata%/MMXE/" + "save.json")

LOG.close();
