on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "We used to have a race course to the left of Headquarters.",
			mugshot_left : "none",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "Unfortunately, having a race course by a military facility was not a good idea.",
			mugshot_left : "none",
			mugshot_right : PLAYER_SPRITE,
			focus : "right"
		},
		{   sentence : "Could always bring it back though.",
			mugshot_left : "none",
			mugshot_right : PLAYER_SPRITE,
			focus : "right"
		}
	]
}