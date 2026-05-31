on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "Welcome to the maverick hunter's headquarters!",
			mugshot_left : "x",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "Keep going straight to find the briefing room, and go downstairs for the hangar bay.",
			mugshot_left : "x",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "Going up leads to the sky deck, and leaving the building shows you our under-construction training facility!",
			mugshot_left : "x",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		}
	]
	_npc.components.get(ComponentAnimation).set_subdirectories(
	["/normal"]);
	_npc.components.publish("character_set", "x");
	_npc.components.publish("animation_play", { name: "idle" });
	_npc.depth += 32
}