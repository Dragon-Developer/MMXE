// Main weapon constructor (no changes needed here)
function x2Wheel() : ProjectileWeapon() constructor{
	self.data = [x2WheelData];
	self.charge_limit = 0;
	
}

//projectile data constructor
function x2WheelData() : ProjectileData() constructor{
	// The wheel
	self.comboiness = 0;
	self.hspd = 0;
	self.vspd = 0;
	self.grav = 0.25; 
	self.acceleration_delay = 20;
	self.grav_delay = 10;
	self.max_hspd = 5;
	// A new state variable to control behavior
	self.state = "moving"; // Can be "moving" or "climbing"
	
	// The create function runs once at the beginning.
	self.create = function(_inst){
		_inst.components.publish("animation_play", { name: "wheel" });
		_inst.mask_index = spr_lemon_mask;
		_inst.depth = -1;
	}
	
	// The step function runs every single frame.
	self.step = function(_inst){
			
		// Apply Gravity after 10 frames
		if (CURRENT_FRAME >= self.init_time + self.grav_delay) {
			self.vspd += self.grav;
		}
			
		// Delay the horizontal acceleration until 12 frames have passed since creation
		if (CURRENT_FRAME >= self.init_time + self.acceleration_delay) {
			// Horizontal acceleration
			self.hspd = min(self.hspd +0.2, self.max_hspd);
		}
			
		// Apply horizontal and vertical movement
		if(!is_undefined(_inst)) {
			// First, try to move horizontally
			var _next_x = _inst.x + self.hspd * self.dir;
			// Check for a wall collision before moving
			if (_inst.components.get(ComponentPhysics).check_place_meeting(_next_x, _inst.y, obj_square_16)) {
				// We hit a wall, so bounce off of it
				self.dir *= -1				
				_next_x *= -1 ;
			} else {
				// No wall, so move as planned
				_inst.x = _next_x;
			}
			
			// Then, apply vertical movement
			var _next_y = _inst.y + self.vspd;
			// Check for a ground collision before moving
			if  (_inst.components.get(ComponentPhysics).check_place_meeting(_inst.x, _next_y, obj_square_16)) {
				// We hit the ground, stop vertical movement
				self.vspd = 0;
			} else {
				// No ground, so move as planned
				_inst.y = _next_y;
			}
		}
		
		
		
		
	}
}