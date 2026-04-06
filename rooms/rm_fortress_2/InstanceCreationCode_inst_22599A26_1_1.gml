if !(global.character_ref[global.character_index] == XCharacter) instance_destroy(self); 

armor = XGaeaArmorArms
global_armor_index = 3;
armor_slot_to_replace = 1;
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
	{   sentence : "...maybe? My local server says that I have ArmsGA, but I should have ArmsLI!",
		mugshot_left : "dr_light",
		mugshot_right : PLAYER_SPRITE,
		focus : "left"
	},
	{   sentence : "Now I'm sure ArmsGA will be safe to equip, but you're gonna have to play around with it to see how it works. ",
		mugshot_left : "dr_light",
		mugshot_right : PLAYER_SPRITE,
		focus : "left"
	}
	
	
];