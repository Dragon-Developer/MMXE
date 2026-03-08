on_spawn = function(_npc){
	
	if(global.character_ref[global.character_index] == RockCharacter){
		_npc.components.get(ComponentNPC).dialouge = [
			{   sentence : "...",
				mugshot_left : "zero",
				mugshot_right : PLAYER_SPRITE,
				focus : "left"
			},
			{   sentence : "The field trip crew left a few hours ago, little guy.",
				mugshot_left : "zero",
				mugshot_right : PLAYER_SPRITE,
				focus : "left"
			}
		]
	} else {
		_npc.components.get(ComponentNPC).dialouge = [
			{   sentence : "...",
				mugshot_left : "zero",
				mugshot_right : PLAYER_SPRITE,
				focus : "left"
			},
			{   sentence : "Get a move on!",
				mugshot_left : "zero_angry",
				mugshot_right : PLAYER_SPRITE,
				focus : "left"
			}
		]
	}
	_npc.components.get(ComponentAnimation).set_subdirectories(
	["/normal"]);
	_npc.components.publish("character_set", "zero");
	_npc.components.publish("animation_play", { name: "chill" });
	_npc.components.publish("animation_xscale", -1);
	_npc.depth += 32
}