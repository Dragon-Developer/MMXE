function global_init() {
	ENTITIES = new EntityManager();
	VBUTTON = new VirtualButtonManager();
	LOG = new LogConsole();
	if (GM_build_type == "exe") {
		LOG = new LogFile();	
	}
	
	global.local_player_index = 0;
	global.server = undefined;
	global.client = undefined;
	global.socket = undefined;
	
	global.debug = false;
	
	//make it work, make it good, make it fast
	global.weapon_data = noone;
	
	input_source_set(INPUT_KEYBOARD, 0);
	window_set_size(2*GAME_W, 2*GAME_H);
	window_center();
}