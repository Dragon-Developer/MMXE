function EntityComponentCameraGuide() : EntityComponentBase() constructor {
	
	self.target = noone;
	self.camera = noone;
	
	self.step = function(){
		if(self.target == noone || self.camera == noone) return;
		
		self.camera.update_pos(self.target.x,self.target.y);
	}
	
	self.on_register = function() {
		self.subscribe("camera_set", function(_target) {
			self.camera = _target;
		});
		self.subscribe("target_set", function(_target) {
			self.target = _target;
		});
	}
}