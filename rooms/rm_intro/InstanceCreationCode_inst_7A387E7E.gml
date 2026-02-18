on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).face_player = true;
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "I fell.",
			mugshot_left : undefined,
			mugshot_right : PLAYER_SPRITE,
			focus : "right"
		},
		{   sentence : "I can tell. You should probably get out of this hole.",
			mugshot_left : undefined,
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "How do i get out?",
			mugshot_left : undefined,
			mugshot_right : PLAYER_SPRITE,
			focus : "right"
		},
		{   sentence : "Well, you can't scale the wall to the right, so scale the left wall and try again.",
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