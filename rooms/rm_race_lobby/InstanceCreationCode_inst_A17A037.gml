on_spawn = function(_npc){
	with(_npc){
		rooms = [
			rm_horizontal_test	
		]
		
		chat = {   sentence : "Which stage would you like to sign up for?",
				mugshot_left : "vent",
				mugshot_right : PLAYER_SPRITE,
				focus : "left",
				
				option_1: "I'm not ready yet...",
				option_1_function: function(){
					if IS_ONLINE	
						global.socket.check_into_race(-1)
				},
			
				option_2: room_get_name(rm_horizontal_test) + "!",
				option_2_function: function(){
					if IS_ONLINE	
						global.socket.check_into_race(rm_horizontal_test)
					else{
						instance_create_depth(0,0,-1235,obj_race_handler);
						room_goto(rm_horizontal_test)
					}
				},
				option_3: "Gate's Lab!",
				option_3_function: function(){
					global.race_laps = 1;
					if IS_ONLINE	
						global.socket.check_into_race(rm_gate_race)
					else{
						instance_create_depth(0,0,-1235,obj_race_handler);
						room_goto(rm_gate_race)
					}
				},
				option_4: "Vertal Test!",
				option_4_function: function(){
					global.race_laps = 3;
					if IS_ONLINE	
						global.socket.check_into_race(rm_minimum_requirements)
					else{
						instance_create_depth(0,0,-1235,obj_race_handler);
						room_goto(rm_minimum_requirements)
					}
				},
				option_5: "Flame Stag's Stage!",
				option_5_function: function(){
					global.race_laps = 2;
					if IS_ONLINE	
						global.socket.check_into_race(rm_flame_stag_race)
					else{
						instance_create_depth(0,0,-1235,obj_race_handler);
						room_goto(rm_flame_stag_race)
					}
				},
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
	_npc.depth += 302
}