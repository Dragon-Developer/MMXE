on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "No, developer commentary is not needed to make a stage work.",
			mugshot_left : "axlforte",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "This stage is just a super basic level to build other levels from. I used a similar one in the old engine.",
			mugshot_left : "axlforte",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		}
	]
}