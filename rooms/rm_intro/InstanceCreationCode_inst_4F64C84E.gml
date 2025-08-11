on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).face_player = true;
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "Sometimes, it's quite difficult to see your surroundings!",
			mugshot_left : cainshot,
			mugshot_right : X_Mugshot1,
			focus : "left"
		},
		{   sentence : "Going forward may provide a risk if done quickly, so use your abilities to your advantage!",
			mugshot_left : cainshot,
			mugshot_right : X_Mugshot1,
			focus : "left"
		},
		{   sentence : "Holding left or right to move towards a wall lets you fall much slower, and can help you see things coming up.",
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