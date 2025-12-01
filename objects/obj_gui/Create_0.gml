

if(!file_exists(game_save_id + "save.json")){
	JSON.save(JSON.load(working_directory + "save.json"), game_save_id + "save.json", true)
}

var _save = JSON.load(game_save_id + "save.json");

if(_save == undefined || _save == -1){
	if(!directory_exists("%localappdata%/MMXE"))
		directory_create("%localappdata%/MMXE")
	
	_save = JSON.load(working_directory + "save.json");
	
}

if(!file_exists(game_save_id + "server.json")){
	JSON.save(JSON.load(working_directory + "server.json"), game_save_id + "server.json", true)
}

var _server = JSON.load(game_save_id + "server.json");

if(_server == undefined)
	_server = JSON.load(working_directory + "server.json");

//show_debug_message(_save)
global.player_data = _save.player_data;
global.settings = _save.settings;
global.server_settings = _server;

global.gui = new GuiRoot();
last_input = 0;

transition_fade = function(_room, _rate = 60){
	if(transition_data.transitioning) return;
	transition_data.type = "fade";
	transition_data.transitioning = true;
	transition_data.room = _room;
	transition_data.visual_rate = _rate;
	transition_data.opacity += 0.001;
}

transition_white_to_black = function(_room, _rate = 60, _rate_2 = 60){
	transition_data.type = "white to black";
	transition_data.transitioning = true;
	transition_data.room = _room;
	transition_data.visual_rate = _rate;
	transition_data.visual_rate_2 = _rate_2;
	transition_data.opacity += 0.001;
}

transition_data = {
	type: "fade",
	opacity: 0,
	opacity_2: 0,
	sprite: spr_fade,
	transitioning: false,
	visual_rate: 1,
	visual_rate_2: 1,
	room: -1
}