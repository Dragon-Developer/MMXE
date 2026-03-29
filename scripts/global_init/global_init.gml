global.game_w = 320//320
global.game_h = 240
global.menu_w = 320
global.menu_h = 240

function global_init() {
	ENTITIES = new EntityManager();
	//soundmanager?
	SOUND = new SoundManager();
	VBUTTON = new VirtualButtonManager();
	//LOG = new LogConsole();
	//if (GM_build_type == "exe") {
		LOG = new LogFile();	
	//}
	
	
	global.local_player_index = 0;
	global.server = undefined;
	global.client = undefined;
	global.socket = undefined;
	global.online = false;
	global.dynamo_race = false;
	
	global.stage_Data = {
		room: rm_explose_horneck, 
		x: 19, 
		y: 18, 
		beat: false, 
		icon: "gate", 
		music: "HQ"
	}
	
	global.character_ref = [
		XCharacter,
		ZeroCharacter,
		AxlCharacter,
		RockCharacter,
		BassCharacter,
		CustomCharacter
	]
	
	global.availible_characters = []//this is set by character_ref
	global.armors = [];
	
	array_foreach(global.character_ref, function(_item, _index){
		var _setup = {};
		
		with(_setup){
			script_execute(_item)
		}
		
		array_push(global.availible_characters, _setup)
		array_push(global.armors, [0,0,0,0,0])
		if(array_length(global.player_data.last_used_armor) < _index + 1)
			array_push(global.player_data.last_used_armor, [0,0,0,0,0])
	})
	
	global.character_index = global.player_data.last_used_character;
	
	global.player_character = [global.availible_characters[global.character_index]];
	
	global.checkpoint_id = undefined;
	global.stage_time = -1;
	global.beat_time = -1;
	global.hit_count = 0;
	
	global.debug = false;
	//global.stacktracking = true;
	global.last_run_type_of_component = "none"
	
	input_source_set(INPUT_KEYBOARD, 0);
	global_prepare_application();
	
}

function global_prepare_application(_width = GAME_W, _height = GAME_H){		

	
	window_set_fullscreen(global.settings.Game_Scale > floor(display_get_height() / GAME_H))
	
	window_set_size(global.settings.Game_Scale*GAME_W, global.settings.Game_Scale*GAME_H);
	window_center();
	view_wport[view_current] = _width * global.settings.Game_Scale
	view_hport[view_current] = _height * global.settings.Game_Scale
	camera_set_view_size(view_camera[view_current], _width, _height);
surface_resize(application_surface, _width, _height);
}