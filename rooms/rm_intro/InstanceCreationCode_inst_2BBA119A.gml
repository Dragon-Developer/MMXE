on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).face_player = true;
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "When going through stages, you might come accross some of these tucked in a corner.",
			mugshot_left : "tut_bot",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "These are metals, and are the currency officially recognized by the maverick hunters.",
			mugshot_left : "tut_bot",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "They come in different colors; yellow is 1 metal, blue is 5 metals, and red is 25 metals.",
			mugshot_left : "tut_bot",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "If you're lucky, you may find a green metal worth 100 metals, or a purple metal worth 500 metals!",
			mugshot_left : "tut_bot",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		}
	]
	_npc.components.get(ComponentAnimation).set_subdirectories(
	["/npc"]);
	_npc.components.publish("character_set", "stage");
	_npc.components.publish("animation_play", { name: "dr_cain_ghost", frame: random_range(0,5) });
	_npc.depth += 32
}