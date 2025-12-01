//if(!is_undefined(global.client))
	//global.client.rpc.sendNotification("request_funds_array", {socket: global.client.socket},undefined);

on_spawn = function(_npc){
	with(_npc){
		rooms = [
			rm_horizontal_test	
		]
		
		chat = {   
			sentence : "What would you like to purchase? You have " + string(global.socket.player_money[global.local_player_index]) + " cash",
			mugshot_left : "zero",
			mugshot_right : PLAYER_SPRITE,
			focus : "left",
				
			option_1: "Nothing",
			option_1_function: function(){
				//need a comment here or this will be removed from existance during compilation
			},
			option_2: "Light Boots! [60]",//60
			option_2_function: function(){
				global.socket.request_purchase(60, ShopArmorPart, global.local_player_index, [global.local_player_index, XFirstArmorBoot])
			},
			option_3: "Light Arms! [40]",
			option_3_function: function(){
				global.socket.request_purchase(40, ShopArmorPart, global.local_player_index, [global.local_player_index, XFirstArmorArms])
			},
			option_4: "Giga Boots! [50]",
			option_4_function: function(){
				global.socket.request_purchase(50, ShopArmorPart, global.local_player_index, [global.local_player_index, XSecondArmorBoot])
			},
			option_5: "Blade Boots! [100]",
			option_5_function: function(){
				global.socket.request_purchase(100, ShopArmorPart, global.local_player_index, [global.local_player_index, XBladeArmorBoot])
			},
			option_6: "Zero Skin! [0]",
			option_6_function: function(){
				global.socket.request_purchase(0, ZeroSkinForShop, global.local_player_index, [global.local_player_index])
			},
			option_7: "Mega Man Skin! [0]",
			option_7_function: function(){
				global.socket.request_purchase(0, RockSkinForShop, global.local_player_index, [global.local_player_index])
			},
			option_8: "Speedster! [25]",
			option_8_function: function(){
				global.socket.request_purchase(25, ShopArmorPart, global.local_player_index, [global.local_player_index, ChipSpeedster])
			},
			option_9: "Hyper Dash! [40]",
			option_9_function: function(){
				global.socket.request_purchase(40, ShopArmorPart, global.local_player_index, [global.local_player_index, ChipHyperDash])
			},
			option_10: "Long Dash! [30]",
			option_10_function: function(){
				global.socket.request_purchase(30, ShopArmorPart, global.local_player_index, [global.local_player_index, ChipDashLengthIncrease])
			},
			option_11: "Jumper! [25]",
			option_11_function: function(){
				global.socket.request_purchase(25, ShopArmorPart, global.local_player_index, [global.local_player_index, ChipJumper])
			},
			option_12: "Diagonal Mach Dash! [40]",
			option_12_function: function(){
				global.socket.request_purchase(40, ShopArmorPart, global.local_player_index, [global.local_player_index, ChipDiagonalMachDash])
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

