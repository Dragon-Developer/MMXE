function ComponentSpriteDrawer() : ComponentBase() constructor{
	self.sprites = [];
	static collage = new Collage();
	self.directory = "stage/"
	self.subdirectories = ["/normal"]
	
	self.load_sprites = function() {
		SpriteLoader.reload_collage(self.collage, "sprites/" + self.directory, self.subdirectories);
	}
	
	self.add_sprite_to_storage = function(_name){
		var _len = array_length(self.subdirectories);
		var _directory_name = string_replace(self.directory,"/", "_");
		_directory_name = string_delete(_directory_name, string_length(_directory_name), 1)
		
		for (var _i = 0; _i < _len; _i++) {
			var _suffix = self.subdirectories[_i];
			var _array = [];
		    if (ANIMATION_SPRITE_PREFIX != "") {
		        array_push(_array, ANIMATION_SPRITE_PREFIX);
		    }
		    array_push(_array, _directory_name, _name);
			// [character, action, suffix]
			var _sprite_name = string_join_ext(ANIMATION_SPRITE_SEPARATOR, _array);
			log(_sprite_name)
			// if dark asks, i made this function something generic so other systems could use it
			// it does what it used to do, but i moved it to spriteloader so spriteloader 
			// could also load sprite assets
			var _sprite = SpriteLoader.load_sprite(self.collage, _sprite_name);
					
		}
		if(array_contains(self.sprites, _sprite)) return;
		array_push(self.sprites, {sprite: _sprite, name: _name});
	}
	
	self.add_sprites_to_storage = function(_sprites){
		for(var g = 0; g < array_length(_sprites); g++){
			self.add_sprite_to_storage(_sprites[g]);
		}
	}
	
	self.get_sprite = function(_sprite_name){
		for(var g = 0; g < array_length(self.sprites); g++){
			if(self.sprites[g].name = _sprite_name){
				//god i have no clue how to do this
			}
		}
		return undefined;
	}
}