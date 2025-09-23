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
	
	global.stage_Data = {
		room: rm_explose_horneck, 
		x: 19, 
		y: 18, 
		beat: false, 
		icon: X_Mugshot_Angy1, 
		music: "HQ"
	}
	
	global.player_character = new XCharacter();
	
	global.debug = false;
	global.last_run_type_of_component = "none"
	
	input_source_set(INPUT_KEYBOARD, 0);
	global_prepare_application();
	
}

function global_prepare_application(){	
	window_set_size(global.settings.Game_Scale*GAME_W, global.settings.Game_Scale*GAME_H);
	window_center();
}