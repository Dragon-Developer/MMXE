function ComponentSpriteRenderer() : ComponentBase() constructor {
	static collage = new Collage();
	self.add_tags("sprite renderer");
	self.character = "weapon";
	self.subdirectories = [ "/normal"];
	
	self.serializer
		.addVariable("sprites")
		
	self.sprites = [];//holds every currently used sprite. 
	
	//adds a new sprite into the pool
	self.add_sprite = function(_animation = "idle", _on_gui_layer = false, _x = 0, _y = 0, _dir = 1, _char = self.character){
		//prepares a struct
		var _spr = {};
		
		//adds an animation controller and a known animation
		struct_set(_spr, "animationController",new AnimationController());
		struct_set(_spr, "animation", _animation);
		struct_set(_spr, "is_gui", _on_gui_layer);
		struct_set(_spr, "x", _x);
		struct_set(_spr, "y", _y);
		struct_set(_spr, "dir", _dir);
		
		_spr.animationController.play(_spr.animation);
		_spr.animationController.__animation = _spr.animation;
		
		//adds the struct to the sprites array
		var _index = -1;
		
		for(var p = 0; p < array_length(self.sprites); p++){
			if(self.sprites[p] == undefined){
				_index = p;
				break;
			}
		}
		
		if(1 == 1){
			array_push(self.sprites, _spr);
			_index = array_length(self.sprites) - 1
		} else {
			array_set(self.sprites, _spr, _index)
		}
		
		self.reload_animation_controller(_index,collage, _char);
		
		//log("Sprite made")
		
		return _index
	}
	
	self.change_sprite = function(_id, _sprite, _char = self.character){
		self.sprites[_id].animation = _sprite;
		
		self.reload_animation_controller(_id,collage, _char);
	}
	
	//deletes unused sprites. 
	self.clear_sprite = function(_id = 0){
		if(_id == 0) return;//the first sprite can be used for drawing so it needs to exist
		
		self.sprites[_id] = undefined;
	}
	
	self.init = function(){
		//character = "x";
		load_sprites();
		add_sprite("shot", true, -32, -32);
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
		//self.load_sprites();
		var _animation = JSON.load("sprites/" + _char + "/animation.json");
		if(_animation == -1) return;
		var _current_animation = undefined;
		if (!is_undefined(self.sprites[_index].animation)) {
			_current_animation = self.sprites[_index].animation;
			//log("what in the goddamn fuck did you do")
		}
		self.sprites[_index].animationController
			.clear()
			.set_character(_char)
			.use_collage(_collage)
			.parse_data(_animation.data.animations)
			.init();
		
		if (!is_undefined(_current_animation)) {
			self.sprites[_index].animationController.play(_current_animation);	
		}
	}
	
	self.step = function(){
		array_foreach(self.sprites, function(_spr){
			if(_spr != undefined){
				if(struct_exists(_spr, "step"))
					_spr.step();
				_spr.animationController.step();
			}
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
				
				var _animation = _sprite.animation;
				
				//if _animation == "undefined"
					
				var ret = [
					_sprite.x, _sprite.y,
					_animation, 
					_animator.__frame,
					_action,
					_animator.__xscale,
				];
				//log(ret)
				return ret;
			}
		//log("shitted my pants")
	}
	
	self.draw = function(){
		array_foreach(self.sprites, function(_sprite){
			if(_sprite != undefined){
				if(!_sprite.is_gui){
					draw_regular(get_interpolated_position(_sprite), _sprite, c_white, false)
				}
			}
		})
	}
	
	self.draw_gui = function(){
		array_foreach(self.sprites, function(_sprite){
			if(_sprite != undefined){
				if(_sprite.is_gui)
					draw_regular(get_interpolated_position(_sprite), _sprite, c_white, true)
			}
		})
	}
	
	self.draw_regular = function(_pos, _sprite, _col = c_white, _on_gui = false) {
		var _animator = _sprite.animationController;
		if(is_undefined(_pos)) _pos = self.get_interpolated_position(_animator);
		var _instance_x = floor(_pos[0]);
		var _instance_y = floor(_pos[1]);
		var _animation = _pos[2];
		var _frame = _pos[3];
		var _action = _pos[4];
		var _xscale = _pos[5];
		
	    _animator.set_xscale(_sprite.dir);
		_animator.draw_action(_action, undefined, _frame, floor(_instance_x), floor(_instance_y))
		//log("sprite's on screen")
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