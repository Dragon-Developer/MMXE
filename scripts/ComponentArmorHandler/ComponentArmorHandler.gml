// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function ComponentArmorHandler() : ComponentBase() constructor{
	self.armor_parts = variable_clone(global.armors[global.character_index],256);
	self.armor_structs = variable_clone(global.armors[global.character_index],256);
	self.reset = false;
	self.set_bonuses = [];
	self._purchases = [];
	
	self.init = function(){
		
		array_foreach(armor_parts, function(_arm, _index){
			try{
				_arm = global.availible_characters[global.character_index].possible_armors[clamp(_index, 0, array_length( global.availible_characters[global.character_index].possible_armors))][clamp(_arm, 0, array_length( global.availible_characters[global.character_index].possible_armors[_index]))]
				armor_parts[_index] = _arm;
			} catch(_exception){
				log(_exception)
				return;
			}
		})
		
		if(get(ComponentPlayerMove)){
			_purchases = [];
			
			array_foreach(global.settings.shop_items, function(_item, _index){
				array_push(_purchases, global.shop_items[_item])
			})
			
			armor_parts = array_concat(armor_parts, _purchases)
		}
		
		apply_full_armor_set(armor_parts);
	}
	self.reapply = function(){
		apply_full_armor_set(armor_parts);
	}
	
	self.apply_full_armor_set = function(_armors, _state = "init", _reset = true){
		
		get(ComponentPlayerMove).reset_state_variables(_state);
		self.armor_parts = [[],[],["/normal"]];
		self.reset = _reset;
		self.set_bonuses = [];
		array_foreach(_armors, function(_arm, _index){
			try{
				if(reset){
					self.armor_structs[_index] = _arm;
				}
			} catch(_exception){
				log(_exception)
				return;
			}
			
			if(typeof(_arm) == "ref"){
				var _temp = {};
			
				with(_temp){
					script_execute(_arm)
				}
				
			
				_arm = _temp;
			} 
			//run any code and load it's directory
			if(typeof(_arm) == "struct"){
				var _can_cont = true;
				for(var g = 0; g < array_length(self.armor_parts[0]); g++){
					if(_arm.armor_name == self.armor_parts[0][g].armor_name)
						_can_cont = false;
				}
				
				if(_can_cont){
					//add the currently listed armor to the armor array
					array_push(self.armor_parts[0], _arm)
					if(_arm.set_bonus != undefined){
						array_push(self.set_bonuses, _arm.set_bonus)
						log(_arm.set_bonus)
					} else 
						log(array_length(self.set_bonuses))
					
					if(array_length(self.set_bonuses) > 3){
						if(self.set_bonuses[0] == self.set_bonuses[1] && self.set_bonuses[2] == self.set_bonuses[1] && self.set_bonuses[2] == self.set_bonuses[3]){
							if script_exists(self.set_bonuses[0])
								script_execute(self.set_bonuses[0], get(ComponentPlayerMove))
						}
					}
					
					if(variable_struct_exists(_arm, "sprite_name")){
						var _armor_name = string(_arm.sprite_name);
						_armor_name = string_delete(_armor_name, 0, 1);
						_armor_name = string_replace(_armor_name, "/", "_");
						var _directory_name = "/armor" + string(_arm.sprite_name)
						_directory_name = string_replace(_directory_name, "_", "/")
						find("animation").add_subdirectories([_directory_name]);
						array_push(self.armor_parts[2], _directory_name);
						array_push(self.armor_parts[1], _armor_name);
					} else {
						array_push(self.armor_parts[2], "");
						array_push(self.armor_parts[1], "");	
					}
					
					if(variable_struct_exists(_arm, "apply_armor_effects"))
						_arm.apply_armor_effects(get(ComponentPlayerMove));
					
					if(variable_struct_exists(_arm, "damage_rate"))
						get(ComponentDamageable).damage_rate = _arm.damage_rate;
					
					if(variable_struct_exists(_arm, "buster_weapon")){
						global.availible_characters[global.character_index].weapons[0] = _arm.buster_weapon;
						get(ComponentWeaponUse).set_weapons(global.availible_characters[global.character_index].weapons);
					}
				
					
					
				}
			}
			
		});
		//publish the armor set
		self.publish("armor_set",self.armor_parts[1]);
		self.get_instance().components.get(ComponentAnimationShadered).set_subdirectories(self.armor_parts[2]);
		self.get_instance().components.get(ComponentAnimationShadered).reload_animations();
		//fix the armor_parts array. it does not need to store an array of strings
		self.armor_parts = self.armor_parts[0];
	}
	
	self.step = function(){
		array_foreach(self.armor_parts, function(_part) {
			if(typeof(_part) == "struct")
				if(_part.step_armor_effects != undefined)
					_part.step_armor_effects(get(ComponentPlayerMove));
					
		})
	}
}