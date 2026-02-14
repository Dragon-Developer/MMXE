function global_init() {
	ENTITIES = new EntityManager();
	//soundmanager?
	SOUND = new SoundManager();
	VBUTTON = new VirtualButtonManager();
	//LOG = new LogConsole();
	//if (GM_build_type == "exe") {
		LOG = new LogFile();	
	//}
	
	//log(working_directory);
	
	global.local_player_index = 0;
	global.server = undefined;
	global.client = undefined;
	global.socket = undefined;
	global.online = false;
	
	global.stage_Data = {
		room: rm_explose_horneck, 
		x: 19, 
		y: 18, 
		beat: false, 
		icon: "gate", 
		music: "HQ"
	}
	
	global.availible_characters = [
		new XCharacter(),
		new ZeroCharacter(),
		//new AxlCharacter(),
		new CustomCharacter()
	]
	global.character_index = global.player_data.last_used_character;
	
	global.player_character = [global.availible_characters[global.character_index]];
	global.armors = [[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]
	global.checkpoint_id = undefined;
	
	global.debug = false;
	global.stacktracking = false;
	global.last_run_type_of_component = "none"
	
	input_source_set(INPUT_KEYBOARD, 0);
	global_prepare_application();
	
}

function global_prepare_application(){	
	window_set_fullscreen(global.settings.Game_Scale > floor(display_get_height() / GAME_H))
	
	window_set_size(global.settings.Game_Scale*GAME_W, global.settings.Game_Scale*GAME_H);
	window_center();
}