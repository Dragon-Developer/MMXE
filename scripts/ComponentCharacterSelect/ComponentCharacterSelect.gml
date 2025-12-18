function ComponentCharacterSelect() : ComponentBase() constructor{
	self.characters = [
		new XCharacter(),
		new ZeroCharacter(),
		new AxlCharacter()
	]
	self.character_index = 0;
	
	self.character_art = noone;
	self.background = noone;
	self.backup_lines = noone;
	
	self.renderer = noone;
	
	self.init = function(){
		var _inst = self.get_instance();
		_inst.x = 0;
		_inst.y = 0;
		
		self.renderer = get(ComponentSpriteRenderer);
		get(ComponentSpriteRenderer).character = "char_select";
		get(ComponentSpriteRenderer).load_sprites();
		
		self.backup_lines = get(ComponentSpriteRenderer).add_sprite("lines", true)
		self.background = get(ComponentSpriteRenderer).add_sprite("bg", true)
		self.character_art = get(ComponentSpriteRenderer).add_sprite("x", true)
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
			self.character_index = (self.character_index - 1 + array_length(self.characters)) mod array_length(self.characters)
			renderer.change_sprite(self.character_art, self.characters[self.character_index].image_folder)
			global.armors[0] = [noone,noone,noone,noone,noone]
		}
		
		if(self.input.get_input_pressed("right")){
			self.character_index = (self.character_index + 1 + array_length(self.characters)) mod array_length(self.characters)
			renderer.change_sprite(self.character_art, self.characters[self.character_index].image_folder)
			global.armors[0] = [noone,noone,noone,noone,noone]
		}
		
		if(self.input.get_input_pressed("jump") || self.input.get_input_pressed("down") || self.input.get_input_pressed("pause")){
			global.player_character[global.local_player_index] = variable_clone(self.characters[self.character_index]);
			room_transition_to(rm_stage_select,"default",20);
			
			struct_set(global.player_data, "last_used_character", global.player_character[0]);
		}
		
		if(self.input.get_input_pressed("up")){
			global.player_character[global.local_player_index] = variable_clone(self.characters[self.character_index]);
			room_transition_to(rm_armor_select,"default",25);
			//ENTITIES.destroy_instance(self.get_instance());
		}
	}
	
	self.draw_gui = function(){
		draw_string(string_upper(self.characters[self.character_index].image_folder), 238, 16)
	}
}