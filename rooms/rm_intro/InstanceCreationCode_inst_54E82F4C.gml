on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).face_player = true;
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "This gap is quite large! And there is a lip that prevents simply scaling the wall!",
			mugshot_left : cainshot,
			mugshot_right : X_Mugshot1,
			focus : "left"
		},
		{   sentence : "By pressing the dash button, you can increase your speed for a short amount of time.",
			mugshot_left : cainshot,
			mugshot_right : X_Mugshot1,
			focus : "left"
		},
		{   sentence : "This increased speed can be carried in the air, which allows you to cross gaps that are wider than you can jump accross.",
			mugshot_left : cainshot,
			mugshot_right : X_Mugshot1,
			focus : "left"
		},
		{   sentence : "You can also hold the dash button while wall jumping to increase speed while wall jumping.",
			mugshot_left : cainshot,
			mugshot_right : X_Mugshot1,
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