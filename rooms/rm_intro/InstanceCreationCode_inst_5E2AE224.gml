on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).face_player = true;
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "Some enemies have shields that reflect normal projectiles.",
			mugshot_left : cainshot,
			mugshot_right : X_Mugshot1,
			focus : "left"
		},
		{   sentence : "This enemy in particular has a small shield to defend himself with.",
			mugshot_left : cainshot,
			mugshot_right : X_Mugshot_Bored1,
			focus : "left"
		},
		{   sentence : "Jumping or crouching with the down input can give you a better angle to shoot at!",
			mugshot_left : cainshot,
			mugshot_right : X_Mugshot_Bored1,
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