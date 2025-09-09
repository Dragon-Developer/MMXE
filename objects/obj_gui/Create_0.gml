global.gui = new GuiRoot();
last_input = 0;

var _save = JSON.load(working_directory + "save.json");
if(_save == -1) return;
show_debug_message(_save)
global.player_data = _save.player_data;
global.settings = _save.settings;



transition_fade = function(_room){
	if(transition_data.transitioning) return;
	transition_data.transitioning = true;
	transition_data.room = _room;
	transition_data.visual_rate = 90;
	transition_data.opacity += 0.001;
}

transition_data = {
	opacity: 0,
	sprite: spr_fade,
	transitioning: false,
	visual_rate: 1,
	room: -1
}