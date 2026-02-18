on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).face_player = true;
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "When approaching a boss door, there is usually an invisible checkpoint.",
			mugshot_left : undefined,
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "It will still flash and make a noise, but you will not be able to see it after that.",
			mugshot_left : undefined,
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "Don't worry about it's functionality! It still works as the visible variation!",
			mugshot_left : undefined,
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		}
	]
	_npc.components.get(ComponentAnimation).set_subdirectories(
	["/npc"]);
	_npc.components.publish("character_set", "stage");
	_npc.components.publish("animation_play", { name: "dr_cain_ghost", frame: random_range(0,5) });
	_npc.components.publish("animation_xscale", -1);
	_npc.depth += 32
}