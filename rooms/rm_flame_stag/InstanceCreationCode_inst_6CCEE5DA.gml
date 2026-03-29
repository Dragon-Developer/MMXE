if !(global.character_ref[global.character_index] == XCharacter) instance_destroy(self); 

global_armor_index = 3;
armor_slot_to_replace = 0;
dialouge = [
	{   sentence : string(PLAYER_SPRITE) + "! This capsule is running on low power mode and cannot make the jump to it's intended location!",
		mugshot_left : "dr_light",
		mugshot_right : PLAYER_SPRITE,
		focus : "left"
	},
	{   sentence : "Damn! Quick, give me your speech and I'll get some rookie hunters to power you back up!",
		mugshot_left : "dr_light",
		mugshot_right : PLAYER_SPRITE,
		focus : "right"
	},
	{   sentence : "R-Right! Uhh, Gaea Head, halved charge time, Step into capsule!",
		mugshot_left : "dr_light",
		mugshot_right : PLAYER_SPRITE,
		focus : "left"
	}
];

armor = XGaeaArmorHead;