on_spawn = function(_npc){
	with(_npc){
		rooms = [
			rm_horizontal_test	
		]
		
		chat = {   sentence : "Which stage would you like to sign up for?",
				mugshot_left : "vent",
				mugshot_right : PLAYER_SPRITE,
				focus : "left",
				
				option_1: room_get_name(rm_horizontal_test) + "!",
				option_1_function: function(){
					if IS_ONLINE
						global.server.check_into_race(rm_horizontal_test)
					else{
						instance_create_depth(0,0,-1235,obj_race_handler);
						room_goto(rm_horizontal_test)
					}
				},
				option_2: "I'm not ready yet...",
				option_2_function: function(){if variable_global_exists("server") global.server.check_into_race(-1)}
			}
	}
	
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "Hello, and welcome to the Megaman X Engine Race Lobby!",
			mugshot_left : "vent",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		_npc.chat
		
	]
	_npc.components.get(ComponentAnimation).set_subdirectories(
	["/normal"]);
	_npc.components.publish("character_set", "vent");
	_npc.components.publish("animation_play", { name: "relaxed" });
	//_npc.depth += 32
}