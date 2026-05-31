on_spawn = function(_npc){
	
	_npc.components.get(ComponentNPC).dialouge = [
		{   sentence : PLAYER_SPRITE + "! I found the maverick, but I'm too badly damaged to pursue him!",
			mugshot_left : "hunter_1_tired",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		},
		{   sentence : "Don't worry! Stay near this save station and a medic will pick you up once this maverick is caught!",
			mugshot_left : "hunter_1_tired",
			mugshot_right : PLAYER_SPRITE,
			focus : "right"
		},
		{   sentence : "Thank you, commander! I'll let other hunters know what's up.",
			mugshot_left : "hunter_1_tired",
			mugshot_right : PLAYER_SPRITE,
			focus : "left"
		}
	]
	
	if global.availible_characters[global.character_index].image_folder == "bass" {
		_npc.components.get(ComponentNPC).dialouge[1].sentence = "Kill youself."
		_npc.components.get(ComponentNPC).dialouge[2].sentence = "T..Thank you, commander? I'll, uhh... let other hunters know what's up."
	}
	
	_npc.components.get(ComponentAnimation).set_subdirectories(
	["/npc"]);
	_npc.components.publish("character_set", "stage");
	_npc.components.publish("animation_play", { name: "hunter_1_tired" });
	//_npc.components.publish("animation_xscale", -1);
	_npc.depth += 32
}