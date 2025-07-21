function ComponentCamera() : ComponentBase() constructor {
    self.x = 0;
    self.y = 0;
    self.width = GAME_W;
    self.height = GAME_H;
	self.angle = 0;
	self.rotation_controller = new RotationController(); 
	self.camera = -1;
	self.flipped_y = false;
	self.target = noone;
	self.bounds = noone;//if bounds are noone, just lock onto player pos. otherwise, abide by bounds
	self.physics = noone;
	
	self.movement_limit_x = 5;//the camera cant move faster than this
	self.movement_limit_y = 7;
	
	self.bounds_top_left_x = 4;
	self.bounds_top_left_y = 0;
	self.bounds_bottom_right_x = 356;
	self.bounds_bottom_right_y = 0;
	
	self.on_register = function() {
		self.subscribe("target_set", function(_target) {
			self.target = _target;
			_target.components.publish("camera_set", self);
		});
		self.subscribe("components_update", function() {
			//so I can get if the player collides with a camera trigger
			self.physics = self.parent.find("physics") ?? new ComponentPhysicsBase();
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
		WORLD.components.get(ComponentWorld).flip_up();
	}

    self.step = function() {
        self.rotation_controller.step();
		self.angle = self.rotation_controller.current_angle;
		camera_set_view_angle(self.camera, self.angle);
		/* this keyboard check doesn't work well in multiplayer
		
		forte: this would be great if it was based on collisions
		
		if (keyboard_check_pressed(ord("1"))) {
			self.flip_y();	
		}
		if (keyboard_check_pressed(ord("2"))) {
			if (!self.rotation_controller.enabled)
				self.start_rotation(self.rotation_controller.current_angle - 90);	
		}*/
		if(self.target == noone) {
			if (self.flipped_y) {
				camera_set_view_pos(self.camera, x, y + self.height);
			} else {
				camera_set_view_pos(self.camera, x, y);
			}
			return;
		}
		//ill only respect bounds if you have a target
		//this way, cutscenes can manually move the camera 
		//regardless of camera bounds
		with(self.get_instance()){
			if(place_meeting(other.target.x,other.target.y,obj_camera_changer)){
				//log("chamera chamger")
				other.bounds = instance_place(other.target.x,other.target.y,obj_camera_changer);
			}
		}
		
		if(self.bounds != noone){
			with(obj_camera_zone){
				if(camera_id = other.bounds.camera_id){
					var _width  = image_xscale * 16;
					var _height = image_yscale * 16;
					other.bounds_bottom_right_x = x + _width - GAME_W;
					other.bounds_bottom_right_y = y + _height - GAME_H;
					other.bounds_top_left_x = x;
					other.bounds_top_left_y = y;
				}
			}
		}
		
		self.update_pos(self.target.x,self.target.y);
		var _inst = self.get_instance();
		
		_inst.x = self.x;
		_inst.y = self.y;
    }
	
	self.update_pos = function(_x, _y) {
		
		var _cam_x = floor(_x - self.width / 2);
		var _cam_y = floor(_y - self.height / 2);
		
		_cam_x = clamp(_cam_x, self.bounds_top_left_x, self.bounds_bottom_right_x);
		_cam_y = clamp(_cam_y, self.bounds_top_left_y, self.bounds_bottom_right_y);
		
		if(abs(x - _cam_x) > self.movement_limit_x){
			if(x > _cam_x){
				_cam_x = x - self.movement_limit_x;
			} else {
				_cam_x = x + self.movement_limit_x;
			}
		}
		
		if(abs(y - _cam_y) > self.movement_limit_y){
			if(y > _cam_y){
				_cam_y = y - self.movement_limit_y;
			} else {
				_cam_y = y + self.movement_limit_y;
			}
		}
		
		
		if (self.flipped_y) {
			camera_set_view_pos(self.camera, _cam_x, _cam_y + self.height);
		} else {
			camera_set_view_pos(self.camera, _cam_x, _cam_y);
		}
		self.x = _cam_x;
		self.y = _cam_y;
	}
	
	self.set_target = function(_target){
		self.target = _target;
	}
	
	self.init = function() {
		self.camera = view_get_camera(0);	
		surface_resize(application_surface, self.width, self.height);
		room_set_viewport(room, 0, true, 0, 0, GAME_W / 2, GAME_H);
		self.x = self.get_instance().x;
		self.y = self.get_instance().y;
		camera_set_view_pos(self.camera, self.get_instance().x, self.get_instance().y);
	}
	
	self.rotation_controller.on_end = function() {
		ENTITIES.pause(["actor"], false);
			//log(WORLD)
		var _instances = ENTITIES.find_all(["actor"]);
		if(WORLD != undefined)
			WORLD.components.get(ComponentWorld).rotate_up(-90);
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
