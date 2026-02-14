on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "This boss was made with reused x graphics if you could tell.",
			mugshot_left : "axlforte",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "It's invincible the entire time it charges its desperation. This has proved to be annoying!",
			mugshot_left : "axlforte",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		}
	]
}