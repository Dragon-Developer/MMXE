function global_init() {
	ENTITIES = new EntityManager();
	//soundmanager?
	SOUND = new SoundManager();
	VBUTTON = new VirtualButtonManager();
	//LOG = new LogConsole();
	//if (GM_build_type == "exe") {
		LOG = new LogFile();	
	//}
	
	log(working_directory);
	
	global.local_player_index = 0;
	global.server = undefined;
	global.client = undefined;
	global.socket = undefined;
	
	global.debug = false;
	
	input_source_set(INPUT_KEYBOARD, 0);
	window_set_size(3*GAME_W, 3*GAME_H);
	window_center();
}

//this is unused at the moment.
function global_player_init(){
	global.player_character = "x";
	global.player_armor = ["none","none", "x2","x3","none"];//head, chest, arms, boots, full
	global.player_weapon = [xBuster];//the player's availible weapon set. changes depending on character
	global.lives = 2;//if you die with zero lives, you game over.
}