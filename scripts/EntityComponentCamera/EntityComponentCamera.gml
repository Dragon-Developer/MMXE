function EntityComponentCamera() : EntityComponentBase() constructor {
    self.x = 0;
    self.y = 0;
    self.width = 320;
    self.height = 240;
	self.angle = 0;
	self.rotation_controller = new RotationController(); 
	self.camera = -1;
	self.flipped_y = false;
	self.target = noone;
	
	self.on_register = function() {
		self.subscribe("target_set", function(_target) {
			self.target = _target;
		});
	}
	
	self.start_rotation = function(_angle) {
		ENTITIES.pause(["actor"], true);
		self.rotation_controller
			.set_rotation(self.rotation_controller.current_angle, _angle)
			.activate();
    }

	self.flip_y = function() {
		if (!self.flipped_y) {
			camera_set_view_size(self.camera, self.width, -self.height);
			camera_set_view_pos(self.camera, 0, self.height);			
		} else {
			camera_set_view_size(self.camera, self.width, self.height);
			camera_set_view_pos(self.camera, 0, 0);
		}
		self.flipped_y = !self.flipped_y;
		WORLD.components.get(EntityComponentWorld).flip_up();
	}

    self.step = function() {
        self.rotation_controller.step();
		self.angle = self.rotation_controller.current_angle;
		camera_set_view_angle(self.camera, self.angle);
		/* this keyboard check doesn't work well in multiplayer
		if (keyboard_check_pressed(ord("1"))) {
			self.flip_y();	
		}
		if (keyboard_check_pressed(ord("2"))) {
			if (!self.rotation_controller.enabled)
				self.start_rotation(self.rotation_controller.current_angle - 90);	
		}*/
		if(self.target == noone) return;
		
		self.update_pos(self.target.x,self.target.y);
    }
	
	self.update_pos = function(_x, _y) {
		var _cam_x = floor(_x - self.width / 2);
		var _cam_y = floor(_y - self.height / 2);
		if (self.flipped_y) {
			camera_set_view_pos(self.camera, _cam_x, _cam_y + self.height);
		} else {
			camera_set_view_pos(self.camera, _cam_x, _cam_y);
		}
	}
	
	self.init = function() {
		self.camera = view_get_camera(0);	
		surface_resize(application_surface, width, height);
	}
	
	self.rotation_controller.on_end = function() {
		ENTITIES.pause(["actor"], false);
		var _instances = ENTITIES.find_all(["actor"]);
		WORLD.components.get(EntityComponentWorld).rotate_up(-90);
	}
}

/*

function EntityComponentCamera() : EntityComponentBase() constructor {
    self.x = 0;
    self.y = 0;
    self.width = 320;
    self.height = 240;
	self.angle = 0;
	self.rotation_controller = new RotationController(); 
	self.camera = -1;
	self.flipped_y = false;
	self.target = noone;
	
	self.on_register = function() {
		self.subscribe("target_set", function(_target) {
			self.target = _target;
		});
	}
	
	self.start_rotation = function(_angle) {
		ENTITIES.pause(["actor"], true);
		self.rotation_controller
			.set_rotation(self.rotation_controller.current_angle, _angle)
			.activate();
    }

	self.flip_y = function() {
		if (!self.flipped_y) {
			camera_set_view_size(self.camera, self.width, -self.height);
			camera_set_view_pos(self.camera, 0, self.height);			
		} else {
			camera_set_view_size(self.camera, self.width, self.height);
			camera_set_view_pos(self.camera, 0, 0);
		}
		self.flipped_y = !self.flipped_y;
		WORLD.components.get(EntityComponentWorld).flip_up();
	}

    self.step = function() {
        self.rotation_controller.step();
		self.angle = self.rotation_controller.current_angle;
		camera_set_view_angle(self.camera, self.angle);
		if (keyboard_check_pressed(ord("1"))) {
			self.flip_y();	
		}
		if (keyboard_check_pressed(ord("2"))) {
			if (!self.rotation_controller.enabled)
				self.start_rotation(self.rotation_controller.current_angle - 90);	
		}
		if(self.target == noone) return;
		
		self.update_pos(self.target.x,self.target.y);
    }
	
	self.update_pos = function(_x,_y){
		camera_set_view_pos(self.camera,floor(_x - self.width / 2),floor(_y - self.height / 2));
	}
	
	self.init = function() {
		self.camera = view_get_camera(0);	
		surface_resize(application_surface, width, height);
	}
	
	self.rotation_controller.on_end = function() {
		ENTITIES.pause(["actor"], false);
		var _instances = ENTITIES.find_all(["actor"]);
		WORLD.components.get(EntityComponentWorld).rotate_up(-90);
	}
}
*/
