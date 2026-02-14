on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "Damn! The ladder's broken!",
			mugshot_left : "x_angry",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "...",
			mugshot_left : "x",
			mugshot_right : PLAYER_SPRITE,
			focus : "right"
		},
		{   sentence : "Just jump up and grab a higher part of the ladder, dude.",
			mugshot_left : "x",
			mugshot_right : PLAYER_SPRITE,
			focus : "right"
		},
		{   sentence : "Are you crazy? You'll hurt yourself!",
			mugshot_left : "x_angry",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "DO. NOT. CLIMB. THIS. LADDER.",
			mugshot_left : "x_angry",
			mugshot_right : PLAYER_SPRITE + "_suprise",
			focus : "left"
		}
	]
	_npc.components.get(ComponentAnimation).set_subdirectories(
	["/normal"]);
	_npc.components.publish("character_set", "x");
	_npc.components.publish("animation_play", { name: "idle" });
	_npc.depth += 32
}