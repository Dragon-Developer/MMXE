function EntityComponentPhysicsBase() : EntityComponentBase() constructor {
	self.add_tags("physics");
	self.set_speed = function(_x, _y) {}
	self.get_hspd = function() { return 0; }
	self.set_hspd = function(_hspd) {}
	self.get_vspd = function() { return 0; }
	self.set_vspd = function(_vspd) {}
	self.set_grav = function(_grav) {}
	self.get_grav = function() { return 0; }
	self.is_on_floor = function() { return false; }
	self.get_speed_magnitude = function() { return 0; }
}