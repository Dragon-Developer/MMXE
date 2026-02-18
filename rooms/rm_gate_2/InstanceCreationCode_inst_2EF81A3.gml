on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "This is my shoddy attempt at making this stage better.",
			mugshot_left : "axlforte",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "Did it work?",
			mugshot_left : "axlforte",
			mugshot_right : PLAYER_SPRITE,
			focus : "right"
		},
		{   sentence : "Pfft, no!",
			mugshot_left : "axlforte",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		}
	]
}