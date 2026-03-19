if !(global.character_ref[global.character_index] == XCharacter) instance_destroy(self); 

armor = XGaeaArmorBody
global_armor_index = 3;
armor_slot_to_replace = 2;
dialouge = [
	{   sentence : "Eugh. I've always hated Wily's castles. So tacky!",
		mugshot_left : "dr_light",
		mugshot_right : PLAYER_SPRITE,
		focus : "left"
	},
	{   sentence : "Sorry, son. 'ahem'",
		mugshot_left : "dr_light",
		mugshot_right : PLAYER_SPRITE + "_bored",
		focus : "left"
	},
	{   sentence : "Step into this capsule, " + PLAYER_SPRITE + ", and recieve the Gaea Chestplate.",
		mugshot_left : "dr_light",
		mugshot_right : PLAYER_SPRITE,
		focus : "left"
	},
	{   sentence : "The Gaea Chestplate reduces damage down to a third, and uses that damage to charge the Genki Dama.",
		mugshot_left : "dr_light",
		mugshot_right : PLAYER_SPRITE,
		focus : "left"
	},
	{   sentence : "Use the Gaea Chestplate for saving the world, and preferably NOT on this dolt's park!",
		mugshot_left : "dr_light",
		mugshot_right : PLAYER_SPRITE,
		focus : "left"
	}
	
];