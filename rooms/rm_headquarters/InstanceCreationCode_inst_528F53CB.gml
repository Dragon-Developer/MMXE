on_spawn = function(_npc){
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : "I made this little area as a joke.",
			mugshot_left : "axlforte",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "This was made before the developer lounge so I didnt have the hiding block. would have been neat if i had the time.",
			mugshot_left : "axlforte",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		}
	]
}