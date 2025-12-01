on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "Hey. I'm your new navigator.",
			mugshot_left : "x_happy",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "MY EYES ARE UP HERE, JACKASS!",
			mugshot_left : "x",
			mugshot_right : PLAYER_SPRITE + "_suprise",
			focus : "left"
		}
	]
	_npc.components.get(ComponentAnimation).set_subdirectories(
	["/normal"]);
	_npc.components.publish("character_set", "vent");
	_npc.components.publish("animation_play", { name: "null" });
	_npc.depth += 32
}