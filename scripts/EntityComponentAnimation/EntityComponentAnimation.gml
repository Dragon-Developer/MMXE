function EntityComponentAnimation() : EntityComponentBase() constructor {
	static collage = new Collage();
	self.add_tags("animation");
	self.rotation_point = { x: 0, y: 0 };
	self.rotation_angle = 0;
	self.rotation_debug = false;
	self.animation = new AnimationController();
	
	self.on_register = function() {
		self.subscribe("character_set", function(_character) {
			self.character = _character;
			self.reload_animations();
		});
		self.subscribe("animation_play", function(_animation) {
			_animation[$ "reset"] ??= false;
			_animation[$ "keep_index"] ??= false;
			var _index = self.animation.get_index();
			self.animation.play(_animation.name, _animation.reset);
			if (_animation.keep_index) {
				self.animation.set_index(_index);	
			}
		});
		self.subscribe("animation_xscale", function(_xscale) {
			self.animation.set_xscale(_xscale)
		});
		self.subscribe("animation_visible", function(_visible) {
			self.animation.set_visible(_visible)
		});
	}
	
	self.reload_animations = function() {
		var _array = SpriteLoader.reload_collage(collage, "sprites/" + self.character);
		var _animation = JSON.load("sprites/" + self.character + "/animation.json");
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
			
		if (!is_undefined(_current_animation)) {
			self.animation.play(_current_animation);	
		}
	}

	self.step = function() {
		self.animation.step();
		if (self.animation.on_end()) {
			self.publish("animation_end");	
		}
		var _mouse = mouse_wheel_down() - mouse_wheel_up();
		if (_mouse != 0) self.rotation_angle += _mouse * 45;
		
		if (mouse_check_button_pressed(mb_right)) {
		    var _instance_x = floor(parent.get_instance().x);
		    var _instance_y = floor(parent.get_instance().y);
			self.rotation_point.x = mouse_x - _instance_x;
			self.rotation_point.y = mouse_y - _instance_y;
		}
	}
	
	self.draw = function() {
	    var _instance_x = floor(parent.get_instance().x);
	    var _instance_y = floor(parent.get_instance().y);
    
	    var _ox = self.rotation_point.x;
	    var _oy = self.rotation_point.y;

		var _angle = degtorad(self.rotation_angle);

	    var _rotated_x = _ox * cos(_angle) - _oy * sin(_angle);
	    var _rotated_y = _ox * sin(_angle) + _oy * cos(_angle);

	    var _x = _instance_x + (_ox - _rotated_x);
	    var _y = _instance_y + (_oy - _rotated_y);

	    self.animation
			.set_angle(-self.rotation_angle)
			.draw(undefined, _x, _y)

		if (self.rotation_debug) {
		    draw_set_color(c_red);
		    draw_circle(_instance_x, _instance_y, 2, false);

		    draw_set_color(c_white);
		    draw_circle(_instance_x + _ox, _instance_y + _oy, 2, false);
		}
	};
}