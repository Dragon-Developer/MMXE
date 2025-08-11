on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).face_player = true;
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "When you fall down into the next area, you will encounter some enemies.",
			mugshot_left : cainshot,
			mugshot_right : X_Mugshot1,
			focus : "left"
		},
		{   sentence : "To deal with enemies, press the shoot or alternative shoot buttons.",
			mugshot_left : cainshot,
			mugshot_right : X_Mugshot1,
			focus : "left"
		},
		{   sentence : "Holding down the button charges the attack, which increases the size and damage of the shots.",
			mugshot_left : cainshot,
			mugshot_right : X_Mugshot1,
			focus : "left"
		}
	]
	_npc.components.get(ComponentAnimation).set_subdirectories(
	["/npc"]);
	_npc.components.publish("character_set", "stage");
	_npc.components.publish("animation_play", { name: "dr_cain_ghost", frame: random_range(0,5) });
	_npc.depth += 32
}