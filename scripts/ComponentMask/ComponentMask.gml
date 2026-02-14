function ComponentMask() : ComponentBase() constructor {
	self.xscale = 1;
	self.yscale = 1;
	self.angle = 0;
	self.alpha = 0.8;
	self.color = c_white;
	self.draw_enabled = false;
	self.serializer = new NET_Serializer();
	self.serializer
		.addVariable("xscale")
		.addVariable("yscale")
		.addVariable("angle")
		.addVariable("alpha")
		.addVariable("color")
	self.set_rotation = function(_rotation) {
		var _inst = parent.get_instance();
		_inst.image_angle = _rotation;
	}
	self.flip_up = function() {}
	self.rotate_up = function(_angle) {
		self.angle += _angle;
	}
	self.step = function() {
		var _inst = self.get_instance();
		_inst.image_angle  = self.angle;
		_inst.image_xscale = self.xscale;
		_inst.image_yscale = self.yscale;
		// Needs better ways to trigger draw debug mode
		
		if (keyboard_check_pressed(ord("3"))) {draw_enabled = !draw_enabled;}
		
		with (obj_block_parent) {
			visible = other.draw_enabled;	
		}
		with (obj_ladder) {
			visible = other.draw_enabled;	
		}
		with (obj_camera_changer) {
			visible = other.draw_enabled;	
		}
	}
	self.draw = function() {
		var _inst = parent.get_instance();
		draw_sprite_ext(
			_inst.mask_index, _inst.image_index, 
			floor(_inst.x), floor(_inst.y), 
			self.xscale, self.yscale,
			self.angle, self.color, self.alpha);
	}
}