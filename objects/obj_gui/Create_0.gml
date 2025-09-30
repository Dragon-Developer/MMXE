global.gui = new GuiRoot();
last_input = 0;

var _save = JSON.load(working_directory + "save.json");
if(_save == -1){
	_save = {
		"player_data":{
			"weapons":[],
			"max_health":12.0,
			"health":12.0,
			"last_played_character":"x",
			"x_armors":["x1","x2","x3"],
			"equipped_weapons":[]
			},
			"settings":{
			"Has_done_intro_stage": true,
			"Input_Buffer":3.0,
			"Sound_Effect_Volume":0.5,
			"Dash_On_Land":0.0,
			"PSX_Style_Dash_Jumping":1.0,
		    "Music_Volume":0.25,
		    "write_inputs": true,
		    "Game_Scale":3.0
		}
	}
}
show_debug_message(_save)
global.player_data = _save.player_data;
global.settings = _save.settings;



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