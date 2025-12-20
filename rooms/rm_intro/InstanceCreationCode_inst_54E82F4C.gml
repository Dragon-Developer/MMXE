on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).face_player = true;
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "This gap is quite large! And there is a lip that prevents simply scaling the wall!",
			mugshot_left : undefined,
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "By pressing the dash button, you can increase your speed for a short amount of time.",
			mugshot_left : undefined,
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "You can prevent losing your speed by jumping out of a dash. This technique is called 'dash jumping'.",
			mugshot_left : undefined,
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "'Dash jumping' allows you to clear larger gaps than usual. It can also be used while wall jumping.",
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