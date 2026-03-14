if !(global.character_ref[global.character_index] == XCharacter) instance_destroy(self); 


dialouge = [
	{   sentence : "Hmm... " + string(PLAYER_SPRITE) + ", this doesn't look like a jungle.",
		mugshot_left : "dr_light",
		mugshot_right : PLAYER_SPRITE,
		focus : "left"
	},
	{   sentence : "No, this is the training grounds for the Maverick Hunters.",
		mugshot_left : "dr_light",
		mugshot_right : PLAYER_SPRITE,
		focus : "right"
	},
	{   sentence : "Well that's odd. I picked this location before heading out! I must have swapped latitude and longitude in my head.",
		mugshot_left : "dr_light",
		mugshot_right : PLAYER_SPRITE,
		focus : "left"
	},
	{   sentence : "Regardless, this capsule contains the Gaea legs. With the legs, you can ignore hazardous surfaces at the cost of extreme weight.",
		mugshot_left : "dr_light",
		mugshot_right : PLAYER_SPRITE,
		focus : "left"
	},
	{   sentence : "Step into this misplaced capsule, " + string(PLAYER_SPRITE) + ", and recieve the Gaea legs.",
		mugshot_left : "dr_light",
		mugshot_right : PLAYER_SPRITE,
		focus : "left"
	},	
];

armor = XGaeaArmorBoot
global_armor_index = 3
armor_slot_to_replace = 3;