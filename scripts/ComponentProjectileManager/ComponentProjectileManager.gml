function ComponentProjectileManager() : ComponentBase() constructor{
	self.projectiles = [];
	self.to_delete = [];
	
	self.serializer
		.addCustom("projectiles")
		.addCustom("to_delete")
	
	self.init = function(){
		get(ComponentSpriteRenderer).character = "weapon";
		get(ComponentSpriteRenderer).load_sprites();
	}
	
	self.create_projectile = function(_x, _y,_dir,  _code){
		var _shot = {};
		
		struct_set(_shot, "position", new Vec2(_x,_y));
		struct_set(_shot, "code", {});
		
		with(_shot.code){script_execute(_code)}
		
		_shot.code.dir = _dir;
		_shot.code.create(_shot.position);
		
		struct_set(_shot, "sprite", get(ComponentSpriteRenderer).add_sprite(_shot.code.animation, _x, _y));
		struct_set(_shot, "hitbox", _shot.code.hitbox_scale);
		
		array_push(self.projectiles, _shot);
	}
	
	self.step = function(){
		array_foreach(self.projectiles, function(_shot){
			_shot.code.step(_shot.position);
			get(ComponentSpriteRenderer).set_position(_shot.sprite, _shot.position.x, _shot.position.y);
			
			if(_shot.position.x > room_width || _shot.position.x < 0 || _shot.position.y > room_height || _shot.position.y < 0)
				array_push(to_delete, _shot);
		})
		
		array_foreach(self.to_delete, function(_shot){
			for(var p = 0; p < array_length(self.projectiles); p++){
				if(self.projectiles[p] == _shot){
					array_delete(self.projectiles, p,1)
				}
			}
		})
	}
	self.draw = function(){
		array_foreach(self.projectiles, function(_shot){
			draw_circle(_shot.position.x, _shot.position.y, 4, false);
		})
	}
	
	self.get_collision = function(_object){
		//dep
		//the code didnt work the way i thought it did
		return false;
	}
}