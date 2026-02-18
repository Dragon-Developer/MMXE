function ComponentProjectileManager() : ComponentBase() constructor{
	self.projectiles = [];
	self.to_delete = [];
	
	self.draw_enabled = false;
	
	//self.serializer
		//.addCustom("projectiles")
		//.addCustom("to_delete")
	
	self.init = function(){
		//get(ComponentSpriteRenderer).character = "pause";
		get(ComponentSpriteRenderer).load_sprites();
		get_instance().depth = -16000;
	}
	
	self.create_projectile = function(_x, _y,_dir,  _code, _shooter, _tags){
		var _shot = {};
		
		//log(string(_tags) + " are the tags i got")
		
		if(!is_array(_tags))
			_tags = [];
		
		struct_set(_shot, "shooter", _shooter);
		struct_set(_shot, "position", new Vec2(_x,_y));
		struct_set(_shot, "code", {});
		
		with(_shot.code){script_execute(_code)}
		
		_shot.code.dir = _dir;
		_shot.dir = _dir;
		_shot.code.tag = array_concat(_shot.code.tag, _tags);
		_shot.code.create(_shot.position);
		
		//log(_shot.code.animation)
		
		struct_set(_shot, "sprite", get(ComponentSpriteRenderer).add_sprite(_shot.code.animation,false,  _x, _y, _dir));
		//log(_shot.sprite)
		struct_set(_shot, "hitbox", _shot.code.hitbox_scale);
		struct_set(_shot, "hitbox_offset", _shot.code.hitbox_offset);
		
		array_push(self.projectiles, _shot);
		
		return _shot;
	}
	
	self.create_melee_hitbox = function(_x, _y,_dir,  _code, _shooter, _tags, _animation, _length){
		var _shot = {};
		
		//log(string(_tags) + " are the tags i got")
		
		struct_set(_shot, "shooter", _shooter);
		struct_set(_shot, "position", new Vec2(_x,_y));
		struct_set(_shot, "code", {});
		
		with(_shot.code){script_execute(_code, _animation, _length)}
		
		_shot.code.dir = _dir;
		_shot.dir = _dir;
		_shot.code.tag = array_concat(_shot.code.tag, _tags);
		_shot.code.create(_shot.position);
		
		//log(_shot.code.animation)
		
		struct_set(_shot, "sprite", get(ComponentSpriteRenderer).add_sprite(_animation,false,  _x, _y, _dir, -35565));
		//log(_shot.sprite)
		struct_set(_shot, "hitbox", _shot.code.hitbox_scale);
		struct_set(_shot, "hitbox_offset", _shot.code.hitbox_offset);
		
		array_push(self.projectiles, _shot);
		
		return _shot;
	}
	
	self.destroy_projectile = function(_proj){
		for(var p = 0; p < array_length(self.projectiles); p++){
			if(self.projectiles[p].code == _proj){
				self.projectiles[p].code.destroy(self.projectiles[p].position);
				array_push(self.to_delete, self.projectiles[p])
			}
		}
	}
	
	self.step = function(){
		array_foreach(self.projectiles, function(_shot){
			_shot.code.step(_shot.position);
			get(ComponentSpriteRenderer).set_position(_shot.sprite, _shot.position.x, _shot.position.y);
				
			//get every player instance and see if they are within a screen's distance away from the projectile
			//if none return true, kill yourself NOW
			
			var _near_player = false;
			for(var p = 0; p < instance_number(obj_player); p++){
				var _plr = instance_find(obj_player, p);
				
				if(_plr.x - GAME_W < _shot.position.x &&
					_plr.x + GAME_W > _shot.position.x &&
					_plr.y - GAME_W < _shot.position.y &&
					_plr.y + GAME_W > _shot.position.y)
						_near_player = true
			}
			
			if(!_near_player)
				array_push(to_delete, _shot);
		})
		
		array_foreach(self.to_delete, function(_shot){
			for(var p = 0; p < array_length(self.projectiles); p++){
				if(self.projectiles[p] == _shot){
					if(variable_struct_exists(_shot.shooter, "projectile_count"))
						_shot.shooter.projectile_count--;
					
					get(ComponentSpriteRenderer).clear_sprite(_shot.sprite);
					array_delete(self.projectiles, p,1);
				}
			}
		})
		
		if (keyboard_check_pressed(ord("3"))) {draw_enabled = !draw_enabled;}
	}
	self.draw = function(){
		array_foreach(self.projectiles, function(_shot){
			get(ComponentSpriteRenderer).set_position(_shot.sprite, _shot.position.x, _shot.position.y)
			
			if draw_enabled
			draw_rectangle( (_shot.hitbox.x / 2) + _shot.position.x + _shot.hitbox_offset.x * _shot.dir,  
				(_shot.hitbox.y / 2) + _shot.position.y + _shot.hitbox_offset.y,
				(_shot.hitbox.x / -2) + _shot.position.x + _shot.hitbox_offset.x * _shot.dir,  
				(_shot.hitbox.y / -2) + _shot.position.y + _shot.hitbox_offset.y, false)
			
		})
	}
	
	self.draw_gui = function(){
	}
	
	self.get_collision = function(_object){
		//dep
		//the code didnt work the way i thought it did
		return false;
	}
}