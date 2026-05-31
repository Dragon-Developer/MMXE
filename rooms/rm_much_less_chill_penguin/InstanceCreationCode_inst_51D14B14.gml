on_spawn = function(_npc){
	
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "Commander! There's a maverick bunkered into this mountain!",
			mugshot_left : "hunter_1",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "Alright, anything to watch out for as I go through?",
			mugshot_left : "hunter_1",
			mugshot_right : PLAYER_SPRITE,
			focus : "right"
		},
		{   sentence : "There's a lot of spikes around the place, so use the ziplines we set up!",
			mugshot_left : "hunter_1",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		}
	]
	
	_npc.components.get(ComponentAnimation).set_subdirectories(
	["/npc"]);
	_npc.components.publish("character_set", "stage");
	_npc.components.publish("animation_play", { name: "hunter_1" });
	_npc.components.publish("animation_xscale", -1);
	_npc.depth += 32
}