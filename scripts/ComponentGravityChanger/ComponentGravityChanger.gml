function ComponentGravityChanger() : ComponentBase() constructor{
	// we need physics to collide with the player entity
	// we need animation because ofc
	// we need to define a rotation amount
	
	self.rotation_angle = 90;
	self.colliding = false;
	
	self.on_register = function() {
		self.subscribe("components_update", function() {
			self.physics = self.parent.find("physics") ?? new ComponentPhysicsBase();
		});
	}
	
	self.init = function(){
		self.publish("animation_play", "idle");
	}
	
	self.step = function(){
		if(self.physics.check_place_meeting(self.get_instance().x, self.get_instance().y, obj_player)){
			if(!self.colliding){
				//self.publish("animation_play", "gravity_button_pressed");
				
				var _cam = instance_nearest(self.get_instance().x, self.get_instance().y,obj_camera);
				if(_cam == undefined) return;
				_cam.components.get(ComponentCamera).start_rotation(
					_cam.components.get(ComponentCamera).rotation_controller.current_angle - self.rotation_angle);	
				self.colliding = true;
			}
		} else {
			if(self.colliding == true){
				//self.publish("animation_play", "gravity_button_idle");
				self.colliding = false;
			}
		}
	}
}