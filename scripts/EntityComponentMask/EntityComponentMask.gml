function EntityComponentMask() : EntityComponentBase() constructor {
	self.xscale = 1;
	self.yscale = 1;
	self.angle = 0;
	self.alpha = 0.5;
	self.color = c_yellow;
	self.set_rotation = function(_rotation) {
		var _inst = parent.get_instance();
		_inst.image_angle = _rotation;
	}
	self.flip_up = function() {
		
	}
	self.rotate_up = function(_angle) {
		self.angle += _angle;
	}
	self.step = function() {
		var _inst = parent.get_instance();
		_inst.image_angle = self.angle;
		_inst.image_xscale = self.xscale;
		_inst.image_yscale = self.yscale;
	}
	self.draw = function() {
		var _inst = parent.get_instance();
		draw_sprite_ext(
			_inst.mask_index, _inst.image_index, 
			_inst.x, _inst.y, 
			self.xscale, self.yscale,
			self.angle, self.color, self.alpha);
	}
}