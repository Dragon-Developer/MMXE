on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "Hey someone came and left a package for you",
			mugshot_left : "x_happy",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "Ok... where's the package",
			mugshot_left : "x",
			mugshot_right : PLAYER_SPRITE + "_happy",
			focus : "right"
		},
		{   sentence : "Iunno. someone just told me that there was a package for you",
			mugshot_left : "x",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "...",
			mugshot_left : "x",
			mugshot_right : PLAYER_SPRITE,
			focus : "right"
		}
	]
	_npc.components.get(ComponentAnimation).set_subdirectories(
	["/normal"]);
	_npc.components.publish("character_set", "x");
	_npc.components.publish("animation_play", { name: "idle" });
	_npc.depth += 32
}