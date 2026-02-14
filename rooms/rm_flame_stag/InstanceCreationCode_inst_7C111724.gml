on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "The top of the mountain was made when I wanted to do multiplayer.",
			mugshot_left : "axlforte",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "Unfortunately, rollback kept deleting very important stuff, and other alternatives sucked.",
			mugshot_left : "axlforte",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		}
	]
}