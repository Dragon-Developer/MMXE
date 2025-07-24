on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "Hey someone came and left a package for you",
			mugshot_left : X_Mugshot_Happy1,
			mugshot_right : X_Mugshot1,
			focus : "left"
		},
		{   sentence : "Ok... where's the package",
			mugshot_left : X_Mugshot1,
			mugshot_right : X_Mugshot1,
			focus : "right"
		},
		{   sentence : "Iunno. someone just told me that there was a package for you",
			mugshot_left : X_Mugshot_Bored1,
			mugshot_right : X_Mugshot1,
			focus : "left"
		},
		{   sentence : "...",
			mugshot_left : X_Mugshot1,
			mugshot_right : X_Mugshot_Bored1,
			focus : "right"
		}
	]
	_npc.components.get(ComponentAnimation).set_subdirectories(
	["/normal"]);
	_npc.components.publish("character_set", "x");
	_npc.components.publish("animation_play", { name: "idle" });
	_npc.depth += 32
}