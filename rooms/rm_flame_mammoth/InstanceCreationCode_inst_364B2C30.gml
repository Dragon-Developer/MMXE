if (global.character_ref[global.character_index] == XCharacter) instance_destroy(self); 

self.set_global_armor = false;

dialouge = [
	{   sentence : "Step into this capsule, " + string(PLAYER_SPRITE) + ". I have prepared something from the past to help you protect the future.",
		mugshot_left : "dr_light",
		mugshot_right : PLAYER_SPRITE,
		focus : "left"
	}
];

//fucky wucky method of doing character specific dialouge but im only changing the one line

if(global.character_ref[global.character_index] == RockCharacter) {
	array_push(dialouge, {   
		sentence : "...Is it the double gear system?",
		mugshot_left : "dr_light",
		mugshot_right : PLAYER_SPRITE,
		focus : "right"
	})
} else if(global.character_ref[global.character_index] == BassCharacter) {
	array_push(dialouge, {   
		sentence : "Tch. What is it this time, old man?",
		mugshot_left : "dr_light",
		mugshot_right : PLAYER_SPRITE,
		focus : "right"
	})
} else {
	array_push(dialouge, {   
		sentence : "Lost power?",
		mugshot_left : "dr_light",
		mugshot_right : PLAYER_SPRITE,
		focus : "right"
	})	
}

array_push(dialouge, {   
	sentence : "It is the double gear system. The double gear system will allow you to temporarially become stronger and react faster.",
	mugshot_left : "dr_light",
	mugshot_right : PLAYER_SPRITE,
	focus : "left"
})

array_push(dialouge, {   
	sentence : "Hopefully, the double gear system can help stop all of this fighting, once and for all.",
	mugshot_left : "dr_light",
	mugshot_right : PLAYER_SPRITE,
	focus : "left"
})