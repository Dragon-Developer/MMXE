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
		var _inst = self.get_instance();
		_inst.x = 0;
		_inst.y = 0;
		
		self.renderer = get(ComponentSpriteRenderer);
		get(ComponentSpriteRenderer).character = "char_select";
		get(ComponentSpriteRenderer).load_sprites();
		
		self.backup_lines = get(ComponentSpriteRenderer).add_sprite("lines", true)
		self.background = get(ComponentSpriteRenderer).add_sprite("bg", true)
		self.character_art = get(ComponentSpriteRenderer).add_sprite(self.characters[self.character_index].image_folder, true)
		
		self.draw_armors();
	}
	
	self.draw_armors = function(){
		self.character_armors = [];
	
		for(var p = 0; p < array_length(self.characters[self.character_index].possible_armors); p++){
			var _armor = {};
			
			var _ind_2 = clamp(p, 0, array_length(global.armors[self.character_index]));
			var _ind = clamp(global.armors[self.character_index][_ind_2], 0, array_length(self.characters[self.character_index].possible_armors[p]) - 1);
			
			var _code = self.characters[self.character_index].possible_armors[p][_ind]
			//if the armor exists, get the sprite of it
			if(_code != noone){
				with(_armor){
					script_execute(_code)
				}
			
				var _sprite_name = _armor.sprite_name;
				_sprite_name = string_delete(_sprite_name, 0, 1);
				_sprite_name = string_replace(_sprite_name, "/", "_");
				
				_sprite_name = global.player_character[0].image_folder + "_" + _sprite_name;
				array_push(self.character_armors, get(ComponentSpriteRenderer).add_sprite(_sprite_name, true));
			}
		}
	}
	
	self.on_register = function() {
		self.subscribe("components_update", function() {
			self.input = self.parent.find("input") ?? new ComponentPlayerInput();
		});
	}
	
	self.step = function(){
		var _inst = self.get_instance();
		
		_inst.x += 1;
		_inst.x = _inst.x mod GAME_W;
		
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
		renderer.change_sprite(self.character_art, self.characters[self.character_index].image_folder)
		
		array_foreach(self.character_armors, function(_armor, _index){
			get(ComponentSpriteRenderer).change_sprite(_armor, "nothing")
		})
		
		draw_armors();
	}
	
	self.draw_gui = function(){
		draw_string(string_upper(self.characters[self.character_index].image_folder), 238, 16)
	}
}