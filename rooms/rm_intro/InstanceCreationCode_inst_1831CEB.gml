on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).face_player = true;
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "This wall seems to be too tall to simply jump over!",
			mugshot_left : cainshot,
			mugshot_right : X_Mugshot1,
			focus : "left"
		},
		{   sentence : "Repeatedly jump while near the wall to scale it, and progress. Hold the direction towards the wall to stay near the wall.",
			mugshot_left : cainshot,
			mugshot_right : X_Mugshot1,
			focus : "left"
		},
		{   sentence : "You don't need to press the movement button and the jump button at the same time! You can hold the movement button!",
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