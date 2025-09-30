function ComponentProjectileManager() : ComponentBase() constructor{
	self.projectiles = [];
	
	self.init = function(){
		get(ComponentSpriteRenderer).character = "weapon";
		get(ComponentSpriteRenderer).load_sprites();
	}
	
	self.create_projectile = function(_x, _y, _code){
		var _shot = {};
		
		struct_set(_shot, "position", new Vec2(_x,_y));
		struct_set(_shot, "code", {});
		
		with(_shot.code){script_execute(_code)}
		
		_shot.code.create(_shot.position);
		
		struct_set(_shot, "sprite", get(ComponentSpriteRenderer).add_sprite(_shot.code.animation, _x, _y));
		struct_set(_shot, "hitbox", _shot.code.hitbox_scale);
		
		array_push(self.projectiles, _shot);
	}
	
	self.step = function(){
		array_foreach(self.projectiles, function(_shot){
			_shot.code.step(_shot.position);
			log(_shot.position)
			get(ComponentSpriteRenderer).set_position(_shot.sprite, _shot.position.x, _shot.position.y);
		})
	}
	self.draw = function(){
		array_foreach(self.projectiles, function(_shot){
			draw_circle(_shot.position.x, _shot.position.y, 4, false);
		})
	}
	
	self.get_collision = function(_object){
		array_foreach(self.projectiles, function(_shot, _obj = _object){
			if(instance_position(_shot.position.x, _shot.position.y, _obj))
				return _shot;
				
			if (collision_rectangle(_shot.position.x - _shot.hitbox.x / 2,
				_shot.position.y - _shot.hitbox.y / 2,
				_shot.position.x + _shot.hitbox.x / 2,
				_shot.position.y + _shot.hitbox.y / 2,
				_obj, false, true)) {
					return _shot;
			}
		});
		return false;
	}
}