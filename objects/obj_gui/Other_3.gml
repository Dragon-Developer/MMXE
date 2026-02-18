JSON.save({
	settings: global.settings, 
	player_data: global.player_data
},game_save_id + "save.json", true)
LOG.close();
