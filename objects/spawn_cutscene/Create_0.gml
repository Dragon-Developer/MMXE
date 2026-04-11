_cut = instance_create_depth(0,0,0,obj_cutscene)
actions = [
	cutscene_move_player(new Vec2(880, 896)),
	cutscene_do_inputs([
		"R",
		40,
		"L",
		40,
		"RF",
		2,
		"LJ",
		2,
		"R",
		2,
		"L",
		2,
		"R",
		2,
		"L",
		2,
		"R",
		2,
		"L",
		2,
		"Maverick dead"
	], _cut),
	cutscene_add_dialouge([
		{   sentence : "You forgot to set the cutscene up properly!",
			mugshot_left : "x",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		}
	], _cut),
	cutscene_set_player_state("hurt")
]

alarm[0] = 3