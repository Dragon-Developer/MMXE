on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).face_player = true;
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "Welcome to the hellhole, chump!",
			mugshot_left :  "dynamo",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
			
		},
		{   sentence : "Which stage would you like to die in?",
			mugshot_left :  "dynamo",
			mugshot_right : PLAYER_SPRITE,
			focus : "left",
			
			option_1: "Gate 2",
			option_1_function: function(){
				global.dynamo_race = true;
				room_transition_to(rm_gate_2, 0, 24);
			},
			option_2: "Horizontal Test",
			option_2_function: function(){
				global.dynamo_race = true;
				room_transition_to(rm_horizontal_test, 0, 24);
			},
			option_3: "Desert Bus",
			option_3_function: function(){
				global.dynamo_race = true;
				room_transition_to(rm_desert_bus, 0, 24);
			},
			option_4: "Old Flame Stag",
			option_4_function: function(){
				global.dynamo_race = true;
				room_transition_to(rm_old_flame_stag, 0, 24);
			},
			option_5: "Old Storm Eagle",
			option_5_function: function(){
				global.dynamo_race = true;
				room_transition_to(rm_old_storm_eagle, 0, 24);
			},
			option_6: "Old Chill Penguin",
			option_6_function: function(){
				global.dynamo_race = true;
				room_transition_to(rm_chill_penguin, 0, 24);
			},
			option_7: "Nah",
			option_7_function: function(){
				//nah
			},
		}
	]
	_npc.components.get(ComponentAnimation).set_subdirectories(
	["/npc"]);
	_npc.components.publish("character_set", "stage");
	_npc.components.publish("animation_play", { name: "dynamo"});
	_npc.components.publish("animation_xscale", -1);
	_npc.depth += 32
}

