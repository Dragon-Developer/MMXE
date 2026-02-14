function ComponentPhysics() : ComponentPhysicsBase() constructor {
	self.velocity = new Vec2(0, 0); 
    self.grav = new Vec2(0, 0.25);
	self.up = new Vec2(0, -1);
	self.right = new Vec2(1, 0);
	self.grav_magnitude = self.grav.length(); 
	self.up_to_right_dir = -1;
	self.terminal_velocity = 6.25;
	self.terminal_velocity_default = 6.25;
	self.time_physics_multiplier = 1;
	self.objects = {
		block: obj_square_16,
		enemy: par_enemy
	};
	self.does_collisions = true;
	
	self.obey_moving_collision = true;//disableable for performance reasons
	self.last_collided_collision = noone;
	self.collision_last_known_position = new Vec2(0,0);
	
	self.serializer = new NET_Serializer(self);
	self.serializer
		.addClone("velocity")
		.addClone("grav")
		.addClone("up")
		.addClone("right")
		.addVariable("grav_magnitude")
		.addVariable("up_to_right_dir")
		.addVariable("terminal_velocity")
		.addVariable("does_collisions")
	/**
	 * Sets the velocity of the entity.
	 * @param {real} x - X velocity.
	 * @param {real} y - Y velocity.
	 */
	set_speed = function(_x, _y) {
		self.velocity.set(_x, _y);
	}
	/**
	 * Sets horizontal speed while maintaining rotation.
	 * @param {real} speed - Horizontal speed value.
	 */
	set_hspd = function(_speed) {
	    var _rotated_velocity = self.velocity.rotate(self.right.angle()); 
	    _rotated_velocity.x = _speed;
	    self.velocity = _rotated_velocity.rotate(-self.right.angle());
	}
	/**
     * Gets the horizontal speed of the entity.
     * @returns {real} The horizontal speed.
     */
	get_hspd = function() {
		var _rotated_velocity = self.velocity.rotate(self.up.angle()); 
		return _rotated_velocity.y;
	}
	/**
     * Sets vertical speed while maintaining rotation.
     * @param {real} speed - Vertical speed value.
     */
	set_vspd = function(_speed) {
	    var _rotated_velocity = self.velocity.rotate(self.up.angle()); 
	    _rotated_velocity.x = -_speed;
	    self.velocity = _rotated_velocity.rotate(-self.up.angle());
	}
	/**
	 * Gets the vertical speed of the entity.
	 * @returns {real} The vertical speed.
	 */
	get_vspd = function() {
		var _rotated_velocity = self.velocity.rotate(self.up.angle()); 
		return -_rotated_velocity.x;
	}
	/**
	 * Gets the current gravity vector.
	 * @returns {struct.Vec2} Gravity vector.
	 */
	get_grav = function() {
		return self.grav;
	}
	/**
	 * Sets the current gravity vector.
	 */
	set_grav = function(_grav) {
		self.grav = _grav;	
	}
	/**
	 * Updates entity physics, applies gravity, and handles movement.
	 */
	step = function() {
		if(self.timescale != 1){
			self.time_physics_multiplier = variable_clone(self.timescale);
			self.timescale = 1;
		}
		
		if(!self.does_collisions) return;
		
		self.move_step(self.velocity.multiply(self.time_physics_multiplier));
		self.velocity = self.velocity.add(self.grav.multiply(self.time_physics_multiplier));
		
		if (self.get_vspd() > self.terminal_velocity){
			self.set_vspd(self.terminal_velocity * (self.time_physics_multiplier));
		}
		
		if (self.is_on_floor(2)) self.set_vspd(0);
    }
	
	draw_gui = function(){
		var _inst = self.get_instance();
		draw_point_color(_inst.x,_inst.y,#ffffff);
	}
	/**
	 * Checks if the entity is colliding with an object at a given position.
	 * @param {real} x - X position.
	 * @param {real} y - Y position.
	 * @param {Object} obj - Object to check collision against.
	 * @returns {boolean} True if collision occurs.
	 */
	check_place_meeting = function(_x, _y, _obj) {
		with (self.get_instance()) {
			return place_meeting(_x, _y, _obj)	
		}
	}
	/**
	 * If the entity collides with an entity at a given position, return said entity
	 * @param {real} x - X position.
	 * @param {real} y - Y position.
	 * @param {Object} obj - Object to check collision against.
	 * @returns {boolean} True if collision occurs.
	 */
	get_place_meeting = function(_x, _y, _obj) {
		with (self.get_instance()) {
			return instance_place(_x, _y, _obj)	
		}
	}
	/**
	 * Checks if the entity is on the floor.
	 * @returns {bool} True if entity is on the floor.
	 */
	is_on_floor = function(_dist = 1) {
		var _inst = self.get_instance();
		var _previous_x = _inst.x;
		var _previous_y = _inst.y;
		self.move_step(self.up.multiply(_dist * -1));
		var _on_floor = 0;
		if(_dist == 1){
			_on_floor = (_previous_x == _inst.x && _previous_y == _inst.y)
		} else {
			_on_floor = (abs(_previous_x - _inst.x) < _dist - 1 && abs(_previous_y - _inst.y) < _dist - 1);
		}
		_inst.x = _previous_x;
		_inst.y = _previous_y;
		return _on_floor;
	}
	/**
	 * Checks if the entity has hit the ceiling.
	 * @returns {bool} True if entity is colliding with the ceiling.
	 */
	is_on_ceil = function(_dist = 3) {
		var _inst = self.get_instance();
		var _previous_x = _inst.x;
		var _previous_y = _inst.y;
		self.move_step(self.up.multiply(_dist));
		var _on_floor = (abs(_previous_x - _inst.x) < _dist && abs(_previous_y - _inst.y) < _dist);
		_inst.x = _previous_x;
		_inst.y = _previous_y;
		return _on_floor;
	}
	/**
	 * Checks if the entity is near a wall.
	 * @returns {bool} True if the entity would collide with a wall at this distance.
	 */
	check_wall = function(_dist, _coll) {
		var _inst = self.get_instance();
		var _previous_x = _inst.x;
		var _previous_y = _inst.y;
		self.move_step(self.right.multiply(_dist), _coll);
		var _on_wall = new Vec2(_inst.x, _inst.y).subtract(new Vec2(_previous_x, _previous_y)).length() < abs(_dist);
		_inst.x = _previous_x;
		_inst.y = _previous_y;
		return _on_wall;
	}
	/**
	 * Moves the entity step by step while handling collisions in 4 separate directions.
	 * @param {Vec2} v - Movement vector.
	 */
	move_step = function(_v,_block = self.objects.block) {
		var _inst = self.get_instance();
		var _orig_x = _inst.x;
	    if (_v.x > 0){ 
			var _res = self.move_right(_v.x, _block);
			if(_res != noone){
				_inst.x = _orig_x;
				_inst.y -= 1;
				_res = self.move_right(_v.x, _block);
				if(_res != noone){
					_inst.x = _orig_x;
					_inst.y += 2;
					self.move_right(_v.x, _block);
					_inst.y -= 1;
				}
			}
		} else if(_v.x < 0) { 
			var _res = self.move_left(_v.x, _block);
			if(_res != noone){
				_inst.x = _orig_x;
				_inst.y -= 1;
				_res = self.move_left(_v.x, _block);
				if(_res != noone){
					_inst.x = _orig_x;
					_inst.y += 2;
					self.move_left(_v.x, _block);
					_inst.y -= 1;
				}
			}
		}
		
		
		var _orig_y = _inst.y;
		if(self.move_down(2) == noone || _v.y < 0){
			_inst.y = _orig_y;
		}
		
	    if (_v.y >= 0) self.move_down(_v.y, _block);
	    if (_v.y < 0) self.move_up(_v.y, _block);
	};
	/**
	 * Gets the horizontal origin offset based on the entity's up direction.
	 * @returns {real} The x origin offset (16 if up is horizontal, else 8).
	 */
	get_x_origin = function() {
		
		var _sprite_width = 16;
		var _sprite_height = 32;
		
		try{
			_sprite_width = sprite_get_xoffset(self.get_instance().mask_index);
			_sprite_height = sprite_get_yoffset(self.get_instance().mask_index);
		} catch(_err){
			
		}
		
		return (abs(self.up.x) == 1) ? _sprite_height : _sprite_width;
	};
	/**
	 * Gets the vertical origin offset based on the entity's up direction.
	 * @returns {real} The y origin offset (16 if up is vertical, else 8).
	 */
	get_y_origin = function() {
		var _sprite_width = 16;
		var _sprite_height = 32;
		
		try{
			_sprite_width = sprite_get_xoffset(self.get_instance().mask_index);
			_sprite_height = sprite_get_yoffset(self.get_instance().mask_index);
		} catch(_err){
			
		}
		
		return (abs(self.up.y) == 1) ? _sprite_height : _sprite_width;
	};
	
	get_y_origin_reversed = function() {
		var _sprite_width = 16;
		var _sprite_height = 32;
		
		var _mask = self.get_instance().mask_index
		
		try{
			_sprite_width = sprite_get_xoffset(_mask);
			_sprite_height = sprite_get_height(_mask) - sprite_get_yoffset(_mask);
		} catch(_err){
			
		}
		
		return (abs(self.up.y) == 1) ? _sprite_height : _sprite_width;
	};
	/**
	 * Moves the entity to the right, stopping at the closest collision.
	 */
	move_right = function(_vx, _coll = self.objects.block) {
		var _inst = self.get_instance();
		var _target_x = _inst.x + _vx;
		var _origin = self.get_x_origin();
    
		var _nearest_block = noone;
		var _object = self.objects.block;
		with (_inst) {
			var _array = instance_place_array(_target_x, y, _object, false);
			for (var _i = 0, _len = array_length(_array); _i < _len; _i++) {
				var _block = _array[_i];
				if (_inst.bbox_right <= _block.bbox_left) {
					if (_nearest_block == noone || _block.bbox_left < _nearest_block.bbox_left) {
						_nearest_block = _block;
					}
				}
			}
		}

		_inst.x = (_nearest_block != noone) 
			? _nearest_block.bbox_left - _origin
			: _target_x;
			
		return _nearest_block;
	};
	/**
	 * Moves the entity to the left, stopping at the closest collision.
	 */
	move_left = function(_vx, _coll = self.objects.block) {
		var _inst = self.get_instance();
		var _target_x = _inst.x + _vx;
		var _origin = self.get_x_origin();

		var _nearest_block = noone;
		var _object = _coll;
		with (_inst) {
			var _array = instance_place_array(_target_x, y, _object, false);
			for (var _i = 0, _len = array_length(_array); _i < _len; _i++) {
				var _block = _array[_i];
				if (_inst.bbox_left >= _block.bbox_right + 1) {
					if (_nearest_block == noone || _block.bbox_right > _nearest_block.bbox_right) {
						_nearest_block = _block;
					}
				}
			}
		}

		_inst.x = (_nearest_block != noone) 
			? _nearest_block.bbox_right + _origin + 1
			: _target_x;
			
		return _nearest_block;
	};
	
	/*
	 * Moves the entity in whatever direction is supplied, positive or negative
	 * A simpler way to handle movement if needed
	 */
	move_horiz = function(_vspd){
		if(_vspd > 0)
			return move_right(_vspd);
		else 
			return move_left(_vspd * -1);
	}

	/**
	 * Moves the entity downward, stopping at the closest collision.
	 */
	move_down = function(_vy, _coll = self.objects.block) {
		var _inst = self.get_instance();
		var _target_y = _inst.y + _vy;
		var _origin = self.get_y_origin_reversed();

		var _nearest_block = noone;
		var _object = _coll;
		with (_inst) {
			var _array = instance_place_array(x, _target_y, _object, false);
			for (var _i = 0, _len = array_length(_array); _i < _len; _i++) {
				var _block = _array[_i];
				if (_inst.bbox_bottom <= _block.bbox_top) {
					if (_nearest_block == noone || _block.bbox_top < _nearest_block.bbox_top) {
						_nearest_block = _block;
					}
				}
			}
		}

		_inst.y = (_nearest_block != noone) 
			? _nearest_block.bbox_top - _origin
			: _target_y;
			
		return _nearest_block;
	};

	/**
	 * Moves the entity upward, stopping at the closest collision.
	 */
	move_up = function(_vy, _coll = self.objects.block) {
		var _inst = self.get_instance();
		var _target_y = _inst.y + _vy;
		var _origin = self.get_y_origin();

		var _nearest_block = noone;
		var _object = _coll
		with (_inst) {
			var _array = instance_place_array(x, floor(_target_y), _object, false);
			for (var _i = 0, _len = array_length(_array); _i < _len; _i++) {
				var _block = _array[_i];
				if (_inst.bbox_top > _block.bbox_bottom) {
					if (_nearest_block == noone || _block.bbox_bottom < _nearest_block.bbox_bottom) {
						_nearest_block = _block;
					}
				}
			}
		}

		_inst.y = (_nearest_block != noone) 
			? _nearest_block.bbox_bottom + _origin + 1
			: _target_y;
			
		return _nearest_block;
	};


	/**
     * Updates the gravity vector based on the current up vector.
     */
	update_gravity = function() {
        self.grav = new Vec2(-self.up.x, -self.up.y)
			.normalize()
			.multiply(self.grav_magnitude);
    }
	/**
     * Rotates the up vector and updates gravity accordingly.
     * @param {real} angle - Angle in degrees.
     */
	rotate_up = function(_angle) {
		self.up = self.up.rotate(_angle).round_vec();
		self.right = self.up.rotate(-90*self.up_to_right_dir).round_vec();;
		self.update_gravity();
	}
	/**
     * Flips the up vector and updates gravity accordingly.
     */
	flip_up = function() {
		self.up = self.up.multiply(-1);	
		self.up_to_right_dir *= -1;
		self.update_gravity();
	}
}