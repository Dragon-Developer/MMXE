function ComponentSpriteRenderer() : ComponentBase() constructor {
	static collage = new Collage();
	self.add_tags("sprite renderer");
	self.character = "weapon";
	self.subdirectories = [""];
	
	self.serializer
		.addVariable("sprites")
		
	self.sprites = [];//holds every currently used sprite. 
	
	//adds a new sprite into the pool
	self.add_sprite = function(_animation = ""){
		//prepares a struct
		var _spr = {};
		
		//adds an animation controller and a known animation
		struct_set(_spr, "animationController",new AnimationController());
		struct_set(_spr, "animation", _animation);
		
		//adds the struct to the sprites array
		array_push(self.sprites, _spr);
		
		//verify the length of the array
		log(string(array_length(self.sprites)) + " sprite loaded");
	}
	
	//deletes unused sprites. 
	self.clear_sprite = function(_id = 0){
		array_delete(self.sprites, _id, 1);
	}
	
	self.init = function(){
	}
	
	self.load_sprites = function() {
		//log(working_directory + "sprites/" + self.character)
		SpriteLoader.reload_collage(self.collage,"sprites/" + self.character, self.subdirectories);
	}
	
	self.reload_animation_controller = function(_controller_index) {
		self.load_sprites();
		var _animation = JSON.load("sprites/" + self.character + "/animation.json");
		if(_animation == -1) return;
		var _current_animation = undefined;
		if (!is_undefined(self.animation)) {
			_current_animation = self.animation.__animation;
		}
		self.sprites[_controller_index].animationController
			.clear()
			.set_character(self.character)
			.use_collage(collage)
			.add_type("hitbox") 
			.add_type("hurtbox") 
			.parse_data(_animation.data.animations)
			.init();
		
		if (!is_undefined(_current_animation)) {
			self.sprites[_controller_index].animationController.play(_current_animation);	
		}
	}
	
	/*
	
	how am i going to handle this?
	
	I can probably make an array of AnimationControllers. might not be performant, but it would make it easier.
	Projectiles need the full functionality of the animation controller if I want it to be a clean
	transition, so it looks like the best plan of action
	
	*/
}