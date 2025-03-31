function EntityComponentPhysics() : EntityComponentPhysicsBase() constructor {
	self.velocity = new Vec2(0, 0);
    self.grav = new Vec2(0, 0.25);
	self.up = new Vec2(0, -1);
	self.right = new Vec2(1, 0);
	self.grav_magnitude = self.grav.length(); 
	self.up_to_right_dir = -1;
	self.objects = {
		block: obj_square_16,
	};
	
	self.set_speed = function(_x, _y) {
		self.velocity.set(_x, _y);
	}
	
	self.set_hspd = function(_speed) {
	    var _rotated_velocity = self.velocity.rotate(self.right.angle()); 
	    _rotated_velocity.x = _speed;
	    self.velocity = _rotated_velocity.rotate(-self.right.angle());
	}
	
	self.get_hspd = function() {
		var _rotated_velocity = self.velocity.rotate(self.up.angle()); 
		return _rotated_velocity.y;
	}
	
	self.set_vspd = function(_speed) {
	    var _rotated_velocity = self.velocity.rotate(self.up.angle()); 
	    _rotated_velocity.x = -_speed;
	    self.velocity = _rotated_velocity.rotate(-self.up.angle());
	}
	
	self.get_vspd = function() {
		var _rotated_velocity = self.velocity.rotate(self.up.angle()); 
		return -_rotated_velocity.x;
	}
	
	self.get_grav = function() {
		return self.grav;
	}
	
	self.set_grav = function(_grav) {
		self.grav = _grav;	
	}

	self.step = function() {
		self.velocity = self.velocity.add(self.grav);
        self.move_step(self.velocity);
		if (self.is_on_floor()) self.velocity.setY(0);
    }
	self.check_place_meeting = function(_x, _y, _obj) {
		with (self.get_instance()) {
			return place_meeting(_x, _y, _obj)	
		}
	}
	self.is_on_floor = function() {
		var _inst = self.get_instance();
		return self.check_place_meeting(_inst.x - self.up.x, _inst.y - self.up.y, self.objects.block);	
	}
	self.move_step = function(_v) {
		var _inst = self.get_instance();
	    var _remaining_x = _v.x;
	    var _remaining_y = _v.y;
	    if (_remaining_x != 0) {
			var _step_size = 1;
	        var _direction_x = _remaining_x > 0 ? 1 : -1;
	        while (abs(_remaining_x) > _step_size) {
	            if (self.check_place_meeting(_inst.x + _direction_x, _inst.y, self.objects.block)) {
	                break;
	            }
				_step_size = abs(_remaining_x) > 1 ? _step_size : abs(_remaining_x);
	            _inst.x += _direction_x * _step_size;
	            _remaining_x -= _direction_x * _step_size;
	        }
	    }

	    if (_remaining_y != 0) {
			var _step_size = 1;
	        var _direction_y = _remaining_y > 0 ? 1 : -1;
	        while (abs(_remaining_y) > _step_size) {
	            if (self.check_place_meeting(_inst.x, _inst.y + _direction_y, self.objects.block)) {
	                break;
	            }
				_step_size = abs(_remaining_y) > 1 ? _step_size : abs(_remaining_y);
	            _inst.y += _direction_y * _step_size;
	            _remaining_y -= _direction_y * _step_size;
	        }
	    }
	}
	self.update_gravity = function() {
        self.grav = new Vec2(-self.up.x, -self.up.y).normalize().multiply(self.grav_magnitude);
    }
	self.rotate_up = function(_angle) {
		self.up = self.up.rotate(_angle);
		self.right = self.up.rotate(-90*self.up_to_right_dir);
		self.update_gravity();
	}
	self.flip_up = function() {
		self.up = self.up.multiply(-1);	
		self.up_to_right_dir *= -1;
		self.update_gravity();
	}
}