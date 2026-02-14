on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "In x6, the path changes depending on if you pick x or zero.",
			mugshot_left : "axlforte",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "This is stupid, therefore I just picked x's version of gate 2.",
			mugshot_left : "axlforte",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		}
	]
}