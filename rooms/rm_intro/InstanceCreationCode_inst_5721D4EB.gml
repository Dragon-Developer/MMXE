on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).face_player = true;
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "Ohoho! I know you have quite extreme spike allergies, so I made these spikes much smaller than usual!",
			mugshot_left : cainshot,
			mugshot_right : X_Mugshot1,
			focus : "left"
		},
		{   sentence : "I don't have spike allergies! These spikes are just sharp enough to pierce my armor!",
			mugshot_left : cainshot,
			mugshot_right : X_Mugshot_Angy1,
			focus : "right"
		},
		{   sentence : "Whatever lets you sleep at night, my boy.",
			mugshot_left : cainshot,
			mugshot_right : X_Mugshot_Bored1,
			focus : "left"
		}
	]
	_npc.components.get(ComponentAnimation).set_subdirectories(
	["/npc"]);
	_npc.components.publish("character_set", "stage");
	_npc.components.publish("animation_play", { name: "dr_cain_ghost", frame: random_range(0,5) });
	_npc.depth += 32
}