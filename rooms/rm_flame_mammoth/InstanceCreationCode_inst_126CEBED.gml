if !(global.character_ref[global.character_index] == XCharacter) instance_destroy(self); 


dialouge = [
	{   sentence : "Step into this capsule, " + string(PLAYER_SPRITE) + ". I... uhh... hold on a minute, son.",
		mugshot_left : "dr_light",
		mugshot_right : PLAYER_SPRITE,
		focus : "left"
	},
	{   sentence : "Is everything alright, father?",
		mugshot_left : "dr_light",
		mugshot_right : PLAYER_SPRITE,
		focus : "right"
	},
	{   sentence : "...maybe? It seems like I grabbed the wrong set of data! My local server says that I have ArmsGA, but I should have ArmsLI!",
		mugshot_left : "dr_light",
		mugshot_right : PLAYER_SPRITE,
		focus : "left"
	},
	{   sentence : "Now I'm sure ArmsGA will be safe to equip, as I made it after all, but you're gonna have to play around with it to see how it works. ",
		mugshot_left : "dr_light",
		mugshot_right : PLAYER_SPRITE,
		focus : "right"
	}
	
	
];