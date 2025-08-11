on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).face_player = true;
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "Dr. Cain! I knew that you were digitized a while ago, but I would have thought you would change your appearance.",
			mugshot_left : cainshot,
			mugshot_right : X_Mugshot1,
			focus : "Right"
		},
		{   sentence : "Well... it's not from a lack of trying, that's for sure!",
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