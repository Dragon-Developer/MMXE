armor = XIcarusArmorArms;
armor_slot_to_replace = 1;
global_armor_index = 11;

if global.character_index != 0 instance_destroy(self);

dialouge = [
		{   sentence : "Hello, x.",
			mugshot_left : "dr_light",
			mugshot_right : "x",
			focus : "left"
		},
		{   sentence : "I have prepared an arm part that is capable of extreme destruction, if used effectively.",
			mugshot_left : "dr_light",
			mugshot_right : "x",
			focus : "left"
		},
		{   sentence : "Please, use extreme caustion when using this! You may be put in a bad situation if you fire randomly!",
			mugshot_left : "dr_light",
			mugshot_right : "x",
			focus : "left"
		},
		{   sentence : "Enter this capsule, x.",
			mugshot_left : "dr_light",
			mugshot_right : "x",
			focus : "left"
		}
	];