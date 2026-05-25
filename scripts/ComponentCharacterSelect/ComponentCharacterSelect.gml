function ComponentCharacterSelect() : ComponentBase() constructor{
	self.characters = global.availible_characters;
	self.character_index = global.character_index;
	
	self.character_art = noone;
	self.character_armors = [];
	self.background = noone;
	self.backup_lines = noone;
	
	self.renderer = noone;
	self.possible = false;
	
	self.init = function(){
		draw_armors();
	}
	
	self.on_register = function() {
		self.subscribe("components_update", function() {
			self.input = self.parent.find("input") ?? new ComponentPlayerInput();
		});
	}
	
	self.step = function(){
		var _inst = self.get_instance();
		
		if(self.input.get_input_pressed("left")){
			self.change_character(-1);
		}
		
		if(self.input.get_input_pressed("right")){
			self.change_character(1);
		}
		
		if(self.input.get_input_pressed("jump") || self.input.get_input_pressed("down") || self.input.get_input_pressed("pause")){
			global.player_character[global.local_player_index] = variable_clone(self.characters[self.character_index]);
			global.character_index = self.character_index;
			struct_set(global.player_data, "last_used_character", self.character_index);
			
			JSON.save({
				settings: global.settings, 
				player_data: global.player_data
			},game_save_id + "save.json", true)
			
			room_transition_to(rm_stage_select,"default",20);
		}
		
		if(self.input.get_input_pressed("up")){
			global.player_character[global.local_player_index] = variable_clone(self.characters[self.character_index]);
			global.character_index = self.character_index;
			room_transition_to(rm_armor_select,"default",20);
			struct_set(global.player_data, "last_used_character", self.character_index);
		}
	}
	
	self.change_character = function(_change){
		self.character_index = (self.character_index + _change + array_length(self.characters)) mod array_length(self.characters)
		
		publish("character_set", self.characters[self.character_index].image_folder)
		
		draw_armors();
	}
	
	self.draw_armors = function(){
		var _armors = characters[self.character_index].possible_armors
		
		if !variable_struct_exists(find("animation"), "character")
			self.publish("character_set", self.characters[self.character_index].image_folder)
		
		var character_armors = [];
	
		for(var p = 0; p < array_length(_armors); p++){
			var _armor = {};
			
			var _ind_2 = clamp(p, 0, array_length(global.armors[self.character_index]));
			var _ind = clamp(global.armors[self.character_index][_ind_2], 0, array_length(_armors[p]) - 1);
			
			var _code = _armors[p][_ind]
			//if the armor exists, get the sprite of it
			if(_code != noone){
				with(_armor){
					script_execute(_code)
				}
			
				var _sprite_name = string_replace_all(string_delete(_armor.sprite_name, 0, 1), "/", "_");
				array_push(character_armors, _sprite_name)
			}
		}
		
		//log(character_armors)
		self.publish("armor_set", variable_clone(character_armors));
		
		array_foreach(character_armors, function(_arm, _index){
			_arm = "/armor/" + _arm;
			_arm = string_replace_all(_arm, "_", "/")
			character_armors[_index] = _arm;
		})
		
		//var _set = []
		var _set = ["/normal"]
		
		//log(character_armors)
		
		for(var o = 0; o < array_length(character_armors); o++){
			array_push(_set, "/armor/" + string_replace_all(character_armors[o], "_", "/"))
		}
		
		//log(_set)
		
		find("animation").set_subdirectories(_set);
		find("animation").reload_animations();
	}
	
	self.draw_gui = function(){
		draw_string(string_upper(self.characters[self.character_index].image_folder), 238, 16)
		
		
		draw_string_condensed(find("animation").subdirectories, 0, 200)
		draw_string_condensed(find("animation").armors, 0, 210)
	}
}