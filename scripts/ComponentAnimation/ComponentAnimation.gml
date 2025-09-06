function ComponentAnimation() : ComponentBase() constructor {
	static collage = new Collage();
	self.add_tags("animation");
	self.rotation_point = { x: 0, y: 0 };
	self.rotation_angle = 0;
	self.rotation_debug = false;
	self.subdirectories = [""];
	self.armors = [""];//which format was this?
	self.animation = new AnimationController();
	self.position_queue = []; 
	self.max_queue_size = 5;
	self.last_game_frame = 0;
	self.do_drawing = true;
	
	self.serializer
		.addVariable("armors")
		.addCustom("animation");
	
	self.on_register = function() {
		self.subscribe("character_set", function(_character) {
			self.character = _character;
			self.reload_animations();
		});
		self.subscribe("armor_set", function(_armors){
			self.armors = _armors;
		});
		self.subscribe("animation_play", function(_animation) {
			//log(_animation.name);
			_animation[$ "reset"] ??= false;
			_animation[$ "keep_index"] ??= false;
			_animation[$ "frame"] ??= 0;
			var _index = self.animation.get_index();
			self.animation.play(_animation.name, _animation.reset, _animation.frame);
			if (_animation.keep_index) {
				self.animation.set_index(_index);	
			}
			self.animation.__frame = _animation.frame;
		});
		self.subscribe("animation_xscale", function(_xscale) {
			self.animation.set_xscale(_xscale)
		});
		self.subscribe("animation_yscale", function(_yscale) {
			self.animation.set_yscale(_yscale)
		});
		self.subscribe("animation_angle", function(_angle) {
			self.rotation_angle = _angle;
		});
		self.subscribe("animation_visible", function(_visible) {
			self.animation.set_visible(_visible)
		});
	}
	
	self.set_subdirectories = function(_subdirs) {
		self.subdirectories = _subdirs;	
	}
	
	self.add_subdirectories = function(_subdirs) {
		array_foreach(_subdirs, function(_dir){
			array_push(self.subdirectories, _dir);	
		})
	}
	
	self.load_sprites = function() {
		//log(working_directory + "sprites/" + self.character)
		SpriteLoader.reload_collage(self.collage,"sprites/" + self.character, self.subdirectories);
	}
	
	self.reload_animations = function() {
		self.load_sprites();
		var _animation = JSON.load("sprites/" + self.character + "/animation.json");
		if(_animation == -1) return;
		var _current_animation = undefined;
		if (!is_undefined(self.animation)) {
			_current_animation = self.animation.__animation;
		}
		self.animation
			.clear()
			.set_character(self.character)
			.use_collage(collage)
			.add_type("hitbox") 
			.add_type("hurtbox") 
			.parse_data(_animation.data.animations)
			.init();
		
		//log(self.animation.parse_data(_animation.data.animations), false);
		
		if (!is_undefined(_current_animation)) {
			self.animation.play(_current_animation);	
		}
	}

	self.step = function() {
		self.animation.step();
		if (self.animation.on_end()) {
			self.publish("animation_end");	
		}
		//rotates thing with scroll wheel
		//var _mouse = mouse_wheel_down() - mouse_wheel_up();
		//if (_mouse != 0) self.rotation_angle += _mouse * 15;
		
		if (GAME.on_normal()) {
			if (GAME.__current_frame <= self.last_game_frame) return;
			if (animation.get_props() == undefined) {
				return;
			}
			if (self.max_queue_size == 0) return;
			self.last_game_frame++;
			var _inst = parent.get_instance();
			array_push(self.position_queue, [ 
				_inst.x, _inst.y, 
				animation.__animation, 
				animation.__frame,
				animation.get_props().action,
				animation.__xscale
			]);
		}
	}
	
	self.flip_up = function() {
		self.animation.set_yscale(-self.animation.get_yscale());	
	}
	
	self.rotate_up = function(_angle) {
		self.rotation_angle += _angle;
//		self.animation.set_angle(self.animation.__angle + _angle);	
	}
	
	self.get_interpolated_position = function() {
		var _length = array_length(self.position_queue);

		if (_length > 1) {
			array_delete(self.position_queue, 0, 1);
		}

		if (array_length(self.position_queue) == 0) {
			var _inst = parent.get_instance();
			if(self.animation != noone)
				if(self.animation.__animation != noone){
					var _action = "missing";
					var _props = self.animation.get_props();// THIS LINE IS IMPORTANT IT WILL GET SHOT OFFSETS
					//log(_props)
					if(_props != undefined){
						if(variable_struct_exists(_props,"action")){
							_action = _props.action;
						}
					}
					
					var ret = [
						_inst.x, _inst.y,
						self.animation.__animation, 
						self.animation.__frame,
						_action,
						self.animation.__xscale,
					];
					return ret;
				}
		}

		var _first = self.position_queue[0];
		return _first;
	};

	self.draw = function(){
		if(!self.do_drawing) return;
		self.draw_regular(self.get_interpolated_position());
	}

	
	self.draw_regular = function(_pos, _col = c_white) {
		if(is_undefined(_pos)) _pos = self.get_interpolated_position();
		var _instance_x = floor(_pos[0]);
		var _instance_y = floor(_pos[1]);
		var _animation = _pos[2];
		var _frame = _pos[3];
		var _action = _pos[4];
		var _xscale = _pos[5];
    
	    var _ox = self.rotation_point.x;
	    var _oy = self.rotation_point.y;

		var _angle = degtorad(self.rotation_angle);

	    var _rotated_x = _ox * cos(_angle) - _oy * sin(_angle);
	    var _rotated_y = _ox * sin(_angle) + _oy * cos(_angle);

	    var _x = _instance_x + (_ox - _rotated_x);
	    var _y = _instance_y + (_oy - _rotated_y);
		
		var _previous_xscale = self.animation.get_xscale();
		
	    self.animation
			.set_xscale(_xscale)
			.set_angle(-self.rotation_angle)
			.draw_action(_action, undefined, _frame, floor(_x), floor(_y))
		var _modifier = self.animation.__types[$ self.animation.__type][0];
		if(_modifier != "") _modifier += "_"
		for (var _q = 0; _q < array_length(self.armors); _q++){
			self.animation.draw_action(_action,_modifier + self.armors[_q], _frame, floor(_x), floor(_y));
		}
		self.animation.set_xscale(_previous_xscale);

		if (self.rotation_debug) {
		    draw_set_color(c_red);
		    draw_circle(_instance_x, _instance_y, 2, false);

		    draw_set_color(c_white);
		    draw_circle(_instance_x + _ox, _instance_y + _oy, 2, false);
		}
	};
}