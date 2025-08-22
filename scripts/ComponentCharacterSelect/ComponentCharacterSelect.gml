function ComponentCharacterSelect() : ComponentBase() constructor{
	self.characters = [
		new ZeroCharacter(),
		new XCharacter()
	]
	self.character_index = 0;
	
	self.character_art = noone;
	self.background = noone;
	self.backup_lines = noone
	
	self.init = function(){
		var _inst = self.get_instance();
		_inst.x = 0;
		_inst.y = 0;
		
		self.character_art = ENTITIES.create_instance(obj_generic_animated_object, 0, 0)
		self.background = ENTITIES.create_instance(obj_generic_animated_object, 0, 0)
		self.backup_lines = ENTITIES.create_instance(obj_generic_animated_object, 0, 0)
		
		with(self.character_art){
			components.find("animation").set_subdirectories(["/normal"]);
			components.publish("character_set", "char_select");
			components.publish("animation_play", {name: other.characters[other.character_index].image_folder});
			depth -= 2;
		}
		
		with(self.background){
			components.find("animation").set_subdirectories(["/normal"]);
			components.publish("character_set", "char_select");
			components.publish("animation_play",{name:"bg"});
			depth -= 1;
		}
		
		with(self.backup_lines){
			components.find("animation").set_subdirectories(["/normal"]);
			components.publish("character_set", "char_select");
			components.publish("animation_play",{name:"lines"});
			depth += 12;
		}
		
		//self.get_instance().components.find("animation").do_drawing = false;
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
			self.character_index = (self.character_index - 1) mod array_length(self.characters)
			character_art.components.publish("animation_play", {name: self.characters[self.character_index].image_folder});
		}
		
		if(self.input.get_input_pressed("right")){
			self.character_index = (self.character_index + 1) mod array_length(self.characters)
			character_art.components.publish("animation_play", {name: self.characters[self.character_index].image_folder});
		}
		
		if(self.input.get_input_pressed("down")){
			global.player_character = self.characters[self.character_index];
			transition_fade(rm_stage_select);
		}
		
		_inst = self.backup_lines;
		
		_inst.x += GAME_W + 1;
		_inst.x = _inst.x mod GAME_W;
		_inst.x -= GAME_W;
	}
}