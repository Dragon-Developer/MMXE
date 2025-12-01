function ZeroSkinForShop(){
	//give the listed player an armor part
	with(obj_player){
		if(argument0 == components.get(ComponentPlayerInput).get_player_index()){
			components.find("animation").change_character("zero");
			global.player_character[argument0].image_folder = "zero"
			global.player_character[argument0].states.intro.animation = "intro"
							
			//everything from here on regarding the zero skin is just for
			//fixing palette issues or forte was fucking around
			global.player_character[argument0].default_palette = [
				#602000,//Blue Armor Bits
				#a02000,
				#e02000,
				#606060,//Under Armor Teal Bits
				#a0a0a0,
				#e0e0c0,
				#181818,//black
				#804020,//Face
				#b86048,
				#f8b080,
				#989898,//glove
				#e0e0e0,
				#f0f0f0,//eye white
				#f04010//red
			];
			var _animation = components.find("animation");
			for(var i = 0; i < array_length(global.player_character[argument0].default_palette); i++){
				_animation.set_base_color(i, global.player_character[argument0].default_palette[i]);
			}
			global.player_character[argument0].default_palette = [
				#602000,//Blue Armor Bits
				#a02000,
				#e02000,
				#484860,//Under Armor Teal Bits
				#9898a0,
				#e0e0e0,
				#181818,//black
				#804020,//Face
				#b86048,
				#f8b080,
				#989898,//glove
				#e0e0e0,
				#f0f0f0,//eye white
				#f04010//red
			];
		}
	}
}

function ShopArmorPart(){
	//give the listed player an armor part
	with(obj_player){
		if(argument0 == components.get(ComponentPlayerInput).get_player_index()){
			components.get(ComponentPlayerMove).apply_armor_part(argument1);
			array_push(global.armors[argument0], argument1)
		}
	}
}

function RockSkinForShop(){
	//give the listed player an armor part
	with(obj_player){
		if(argument0 == components.get(ComponentPlayerInput).get_player_index()){
			components.find("animation").change_character("megaman");
			global.player_character[argument0].image_folder = "megaman"
			global.player_character[argument0].states.intro.animation = "intro"
		}
	}
}

//will go unused for the moment
function AxlSkinForShop(){
	//give the listed player an armor part
	with(obj_player){
		if(argument0 == components.get(ComponentPlayerInput).get_player_index()){
			components.find("animation").change_character("axl");
			global.player_character[argument0].image_folder = "axl"
			global.player_character[argument0].states.intro.animation = "intro"
		}
	}
}