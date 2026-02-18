on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).face_player = true;
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "Heh! I know you have quite extreme spike allergies, so I made these spikes much smaller than usual!",
			mugshot_left : undefined,
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "I don't have spike allergies! These spikes are just sharp enough to pierce my armor!",
			mugshot_left : undefined,
			mugshot_right : PLAYER_SPRITE + "_angry",
			focus : "right"
		},
		{   sentence : "Whatever lets you sleep at night.",
			mugshot_left : undefined,
			mugshot_right : PLAYER_SPRITE + "_angry",
			focus : "left"
		}
	]
	_npc.components.get(ComponentAnimation).set_subdirectories(
	["/npc"]);
	_npc.components.publish("character_set", "stage");
	_npc.components.publish("animation_play", { name: "dr_cain_ghost", frame: random_range(0,5) });
	_npc.depth += 32
}