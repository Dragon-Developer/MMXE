actions = [
	cutscene_move_player(new Vec2(32, -112)),
	cutscene_do_inputs([
		"M",//m because m isnt used
		100,
		"R",
		140,
		"Maverick dead"
	], _cut),
	cutscene_add_dialouge([
		{   sentence : "...we've done it.",
			mugshot_left : "zero",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "Just another day saving the world!",
			mugshot_left : "axl",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "There's more to do, though. big holes in the ground arent exactly safe. ",
			mugshot_left : "zero",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "And we can clean it up! You know how many guys we have on hand?",
			mugshot_left : "axl",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "Tch, you make it sound so easy.",
			mugshot_left : "zero",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : PLAYER_SPRITE + ", go back to headquarters. Tell them that we'll be starting cleanup.",
			mugshot_left : "zero",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		}
	], _cut),
	cutscene_set_player_state("leave")
]