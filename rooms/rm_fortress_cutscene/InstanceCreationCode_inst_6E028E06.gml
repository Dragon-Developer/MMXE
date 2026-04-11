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
		{   sentence : "Hey, " + PLAYER_SPRITE + ". Here's where we got that weird reading from.",
			mugshot_left : "zero",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "The surrounding area is covered in a purple fog, and there's a large energy reading down there.",
			mugshot_left : "zero",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "Time for some maverick hunting?",
			mugshot_left : "zero",
			mugshot_right : PLAYER_SPRITE,
			focus : "right"
		},
		{   sentence : "Yeah, but you go back to base until I find a closer spot to enter from.",
			mugshot_left : "zero",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		}
	], _cut),
	cutscene_set_player_state("leave")
]