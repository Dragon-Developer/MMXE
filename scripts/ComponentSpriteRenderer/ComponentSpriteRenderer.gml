function ComponentSpriteRenderer() : ComponentBase() constructor {
	static collage = new Collage();
	self.add_tags("sprite renderer");
	self.character = "weapon";
	self.subdirectories = ["","/normal"];
	
	self.serializer
		.addVariable("sprites")
		
	self.sprites = [];//holds every currently used sprite. 
	
	//adds a new sprite into the pool
	self.add_sprite = function(_animation = "", _on_gui_layer = false, _x = 0, _y = 0, _collage = collage, _char = self.character){
		//prepares a struct
		var _spr = {};
		
		//adds an animation controller and a known animation
		struct_set(_spr, "animationController",new AnimationController());
		struct_set(_spr, "animation", _animation);
		struct_set(_spr, "is_gui", _on_gui_layer);
		struct_set(_spr, "x", _x);
		struct_set(_spr, "y", _y);
		
		_spr.animationController.play(_spr.animation);
		_spr.animationController.__animation = _spr.animation;
		
		//adds the struct to the sprites array
		array_push(self.sprites, _spr);
		
		self.reload_animation_controller(array_length(self.sprites) - 1,_collage, _char);
		
		return array_length(self.sprites) - 1;
	}
	
	//deletes unused sprites. 
	self.clear_sprite = function(_id = 0){
		array_delete(self.sprites, _id, 1);
	}
	
	self.init = function(){
	}
	
	self.set_position = function(_id = 0, _x = 0, _y = 0){
		self.sprites[_id].x = _x;
		self.sprites[_id].y = _y;
	}
	
	self.load_sprites = function() {
		//log(working_directory + "sprites/" + self.character)
		SpriteLoader.reload_collage(self.collage,"sprites/" + self.character, self.subdirectories);
	}
	
	self.reload_animation_controller = function(_index, _collage = collage, _char = self.character) {
		self.load_sprites();
		var _animation = JSON.load("sprites/" + _char + "/animation.json");
		if(_animation == -1) return;
		var _current_animation = undefined;
		if (!is_undefined(self.sprites[_index].animation)) {
			_current_animation = "undefined";
		}
		self.sprites[_index].animationController
			.clear()
			.set_character(_char)
			.use_collage(_collage)
			.add_type("hitbox") 
			.add_type("hurtbox") 
			.parse_data(_animation.data.animations)
			.init();
		
		if (!is_undefined(_current_animation)) {
			self.sprites[_index].animationController.play(_current_animation);	
		}
	}
	
	self.step = function(){
		array_foreach(self.sprites, function(_spr){
			if(struct_exists(_spr, "step"))
				_spr.step();
		})
	}
	
	self.get_interpolated_position = function(_sprite){
		var _inst = parent.get_instance();
		
		var _animator = _sprite.animationController;
		
		if(_animator != noone)
			if(_animator.__animation != noone ){
				var _action = "missing";
				var _props = _animator.get_props(_sprite.animation);// THIS LINE IS IMPORTANT IT WILL GET SHOT OFFSETS
				//log(_props)
				if(_props != undefined){
					if(variable_struct_exists(_props,"action")){
						_action = _props.action;
					}
				} else {
					//this is DOGSHIT and i hope that you NEVER do this
					_action = _sprite.animation;
				}
					
				var ret = [
					_sprite.x, _sprite.y,
					_animator.__animation, 
					_animator.__frame,
					_action,
					_animator.__xscale,
				];
				return ret;
			}
	}
	
	self.draw = function(){
		array_foreach(self.sprites, function(_sprite){
			if(!_sprite.is_gui){
				draw_regular(get_interpolated_position(_sprite), _sprite, c_white)
				draw_sprite(spr_player_mask,0,get_interpolated_position(_sprite)[0], get_interpolated_position(_sprite)[1]);
			}
		})
	}
	
	self.draw_gui = function(){
		array_foreach(self.sprites, function(_sprite){
			if(_sprite.is_gui)
				draw_regular(get_interpolated_position(_sprite), _sprite, c_white)
		})
	}
	
	self.draw_regular = function(_pos, _sprite, _col = c_white) {
		var _animator = _sprite.animationController;
		if(is_undefined(_pos)) _pos = self.get_interpolated_position(_animator);
		var _instance_x = floor(_pos[0]);
		var _instance_y = floor(_pos[1]);
		var _animation = _pos[2];
		var _frame = _pos[3];
		var _action = _pos[4];
		var _xscale = _pos[5];
		
	    _animator
			.set_xscale(_xscale)
			.draw_action(_action, undefined, _frame, floor(_instance_x), floor(_instance_y))
	};
	
	self.draw_sprite = function(_action, _frame, _x, _y, _renderer = 0){
		self.sprites[_renderer].animationController.draw_action(_action, undefined, _frame, floor(_x), floor(_y))
	}
	
	/*
	
	how am i going to handle this?
	
	I can probably make an array of AnimationControllers. might not be performant, but it would make it easier.
	Projectiles need the full functionality of the animation controller if I want it to be a clean
	transition, so it looks like the best plan of action
	
	*/
}