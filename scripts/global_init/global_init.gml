function global_init() {
	ENTITIES = new EntityManager();
	VBUTTON = new VirtualButtonManager();
	
	global.local_player_index = 0;
	global.server = undefined;
	global.client = undefined;
	global.socket = undefined;
	
	input_source_set(INPUT_KEYBOARD, 0);
	window_set_size(3*GAME_W, 3*GAME_H);
	window_center();
}