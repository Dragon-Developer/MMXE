function ComponentParallax() : ComponentBase() constructor{
	
	self.camera_move_rate = [0.5];//the speed to move, relative to the camera. 1 is in sync and 0 is dont move at all
	self.xy_move_rate = [new Vec2(1,1)];//how much the x and y positions are affected by the move rate
	self.sprites = [spr_block];//the sprites to use for the background. this array
	//is used for the loop length of the for loops.
	self.sprite_offsets = [];//generated automatically. allows the center to be the actual center
	self.cam = noone;
	
	self.init = function(){
		self.reset_background();
	}
	
	self.reset_background = function(){
		var _length = array_length(self.sprites);
		var _move_rate = self.camera_move_rate;
		var _xy = self.xy_move_rate;
		var _inst = self.get_instance();
		
		for(var q = 0; q < _length; q++){
			self.sprite_offsets[q] = {
				x: _inst.x * _move_rate[q] * _xy[q].x,
				y: _inst.y * _move_rate[q] * _xy[q].y
			}
		}
	}
	
	self.draw = function(){
		var _length = array_length(self.sprites);
		var _move_rate = self.camera_move_rate;
		var _xy = self.xy_move_rate;
		with(self.get_instance()){
			other.cam = instance_nearest(x,y,obj_camera)
		}
		var _offset = self.sprite_offsets;
		
		for(var q = 0; q < _length; q++){
			draw_sprite(self.sprites[q], 0, self.get_instance().x, self.get_instance().y)
			//cam.x * _move_rate[q] * _xy[q].x + _offset[q].x
			//, cam.y * _move_rate[q] * _xy[q].y + _offset[q].y)
		}
		draw_sprite(X_Mugshot_Angy1, 0, self.get_instance().x, self.get_instance().y)
	}

}