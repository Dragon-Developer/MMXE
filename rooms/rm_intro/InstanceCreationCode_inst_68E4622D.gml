on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).face_player = true;
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "Some enemies can be placed in very hard-to-reach spots!",
			mugshot_left : undefined,
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "Staying safe is key! Use larger projectiles to deal damage safely.",
			mugshot_left : undefined,
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "You can also shoot while sliding down the opposite wall to stay even safer!",
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