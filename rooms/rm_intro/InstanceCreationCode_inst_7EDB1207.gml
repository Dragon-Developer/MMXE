on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).face_player = true;
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "This machine here is a checkpoint.",
			mugshot_left : undefined,
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "They are usually placed right before a boss, and can be invisible if needed.",
			mugshot_left : undefined,
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "Whenever you see one, jump on it! You will return here instead of the start of the mission.",
			mugshot_left : undefined,
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "Go ahead, try it!",
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