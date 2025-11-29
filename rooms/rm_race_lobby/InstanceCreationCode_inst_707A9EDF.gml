on_spawn = function(_npc){
	with(_npc){
		rooms = [
			rm_horizontal_test	
		]
		
		chat = {   
			sentence : "What would you like to purchase? You have " + string(global.socket.player_money[global.local_player_index]),
			mugshot_left : "vent",
			mugshot_right : PLAYER_SPRITE,
			focus : "left",
				
			option_1: "Nothing",
			option_1_function: function(){
				//need a comment here or this will be removed from existance during compilation
			},
			option_2: "Light Boots! [120]",
			option_2_function: function(){
				global.socket.request_purchase(120, function(){
					//give the listed player an armor part
					with(obj_player){
						if(argument0 == components.get(ComponentPlayerInput).get_player_index()){
							components.get(ComponentPlayerMove).apply_armor_part(XFirstArmorBoot);
							array_push(global.player_armors[argument0], XFirstArmorBoot)
						}
					}
				}, global.local_player_index, [global.local_player_index])
			},
			option_3: "Giga Boots! [100]",
			option_3_function: function(){
				global.socket.request_purchase(100, function(){
					//give the listed player an armor part
					with(obj_player){
						if(argument0 == components.get(ComponentPlayerInput).get_player_index()){
							components.get(ComponentPlayerMove).apply_armor_part(XSecondArmorBoot);
							array_push(global.player_armors[argument0], XSecondArmorBoot)
						}
					}
				}, global.local_player_index, [global.local_player_index])
			},
			option_4: "Blade Boots! [200]",
			option_4_function: function(){
				global.socket.request_purchase(200, function(){
					//give the listed player an armor part
					with(obj_player){
						if(argument0 == components.get(ComponentPlayerInput).get_player_index()){
							components.get(ComponentPlayerMove).apply_armor_part(XBladeArmorBoot);
							array_push(global.player_armors[argument0], XBladeArmorBoot)
						}
					}
				}, global.local_player_index, [global.local_player_index])
			},
				
		}
	}
	
	_npc.components.get(ComponentNPC).dialouge = [_npc.chat]
		
	_npc.components.get(ComponentAnimation).animation.__xscale = -1;
	_npc.components.get(ComponentAnimation).set_subdirectories(
	["/normal"]);
	_npc.components.publish("character_set", "zero");
	_npc.components.publish("animation_play", { name: "idle" });
	_npc.depth += 302
}