on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).face_player = true;
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "Press the jump or dash buttons to continue through text.",
			mugshot_left : cainshot,
			mugshot_right : X_Mugshot1,
			focus : "left"
		},
		{   sentence : "Welcome to the Maverick Hunter Standard Performance Measurement Test!",
			mugshot_left : cainshot,
			mugshot_right : X_Mugshot1,
			focus : "left"
		},
		{   sentence : "While you may be a high-ranking maverick hunter, it is still important to check on tbe basics.",
			mugshot_left : cainshot,
			mugshot_right : X_Mugshot1,
			focus : "left"
		},
		{   sentence : "Use the left and right inputs to move left and right",
			mugshot_left : cainshot,
			mugshot_right : X_Mugshot1,
			focus : "left"
		},
	]
	_npc.components.get(ComponentAnimation).set_subdirectories(
	["/npc"]);
	_npc.components.publish("character_set", "stage");
	_npc.components.publish("animation_play", { name: "dr_cain_ghost", frame: random_range(0,5) });
	_npc.components.publish("animation_xscale", -1);
	_npc.depth += 32
}