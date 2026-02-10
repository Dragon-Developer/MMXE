function ComponentEnemyManager() : ComponentBase() constructor{
	self.enemies = [];
	self.to_delete = [];
	self.subdirectories = ["", "/normal"]
	
	self.draw_enabled = false;
	self.proj = noone;//needed so i can access it from a slightly further up scope
	
	//self.serializer
		//.addCustom("enemies")
		//.addCustom("to_delete")
	
	self.init = function(){
		get(ComponentSpriteRenderer).character = "enemy";
		get(ComponentSpriteRenderer).subdirectories = subdirectories;
		get(ComponentSpriteRenderer).load_sprites();
		get_instance().depth = -16000;
	}
	
	self.create_enemy = function(_x, _y,_dir,  _code){
		var _enemy = {};
		
		struct_set(_enemy, "position", new Vec2(_x,_y));
		struct_set(_enemy, "code", {});
		struct_set(_enemy, "hit_by_list", []);
		
		with(_enemy.code){script_execute(_code)}
		
		_enemy.code.dir = _dir;
		_enemy.dir = _dir;
		
		struct_set(_enemy, "sprite", get(ComponentSpriteRenderer).add_sprite(_enemy.code.sprite,false,  _x, _y, _dir));
		//log(_enemy.sprite)
		struct_set(_enemy, "hitbox", _enemy.code.hitbox_scale);
		struct_set(_enemy, "hitbox_offset", _enemy.code.hitbox_offset);
		
		array_push(self.enemies, _enemy);
		
		return _enemy;
	}
	
	self.destroy_enemy = function(_proj){
		for(var p = 0; p < array_length(self.enemies); p++){
			if(self.enemies[p].code == _proj)
				array_push(self.to_delete, self.enemies[p])
		}
	}
	
	self.step = function(){
		array_foreach(self.enemies, function(_enemy, _index){
			_enemy.code.step(_enemy.position);
			self.get_collision(_enemy);
		})
		
		if (keyboard_check_pressed(ord("3"))) {draw_enabled = !draw_enabled;}
	}
	self.draw = function(){
		array_foreach(self.enemies, function(_enemy){
			//log("pp")
			if(!_enemy.code.dead)
				get(ComponentSpriteRenderer).set_position(_enemy.sprite, _enemy.position.x, _enemy.position.y)
			
			draw_string(_enemy.code.health, _enemy.position.x, _enemy.position.y - 32)
			
			if (draw_enabled){
				draw_rectangle( (_enemy.hitbox.x / 2) + _enemy.position.x + _enemy.hitbox_offset.x * _enemy.dir,  
					(_enemy.hitbox.y / 2) + _enemy.position.y + _enemy.hitbox_offset.y,
					(_enemy.hitbox.x / -2) + _enemy.position.x + _enemy.hitbox_offset.x * _enemy.dir,  
					(_enemy.hitbox.y / -2) + _enemy.position.y + _enemy.hitbox_offset.y, false)
			}
			
		})
	}
	
	self.draw_gui = function(){
	}
	
	self.get_collision = function(_enemy){
		
		var _proj = noone;
		var _projectiles = PROJECTILES.components.get(ComponentProjectileManager).projectiles;
		
		for(var u = 0; u < array_length(_projectiles); u++){
			
			var _x = _projectiles[u].position.x + (_projectiles[u].hitbox_offset.x * _projectiles[u].dir);
			var _y = _projectiles[u].position.y + _projectiles[u].hitbox_offset.y;
			var _width = _projectiles[u].hitbox.x;
			var _height = _projectiles[u].hitbox.y;	
			
			var _projectile_left_point =   _x - _width / 2;
			var _projectile_right_point =  _x + _width / 2;
			var _projectile_top_point =    _y - _height / 2;
			var _projectile_bottom_point = _y + _height / 2;
			
			var _enemy_left_point =   (_enemy.hitbox.x / -2) + _enemy.position.x + _enemy.hitbox_offset.x * _enemy.dir;
			var _enemy_right_point =  (_enemy.hitbox.x / 2) + _enemy.position.x + _enemy.hitbox_offset.x * _enemy.dir;
			var _enemy_top_point =    (_enemy.hitbox.y / 2) + _enemy.position.y + _enemy.hitbox_offset.y;
			var _enemy_bottom_point = (_enemy.hitbox.y / -2) + _enemy.position.y + _enemy.hitbox_offset.y;
			
			if(_enemy_left_point < _projectile_left_point && _enemy_right_point > _projectile_left_point){
				if(_enemy_top_point > _projectile_top_point && _enemy_bottom_point < _projectile_top_point){
					_proj = _projectiles[u];
				}
			}
			
			if(_enemy_left_point < _projectile_right_point && _enemy_right_point > _projectile_right_point){
				if(_enemy_top_point > _projectile_top_point && _enemy_bottom_point < _projectile_top_point){
					_proj = _projectiles[u];
				}
			}
			
			if(_enemy_left_point < _projectile_left_point && _enemy_right_point > _projectile_left_point){
				if(_enemy_top_point > _projectile_bottom_point && _enemy_bottom_point < _projectile_bottom_point){
					_proj = _projectiles[u];
				}
			}
			
			if(_enemy_left_point < _projectile_right_point && _enemy_right_point > _projectile_right_point){
				if(_enemy_top_point > _projectile_bottom_point && _enemy_bottom_point < _projectile_bottom_point){
					_proj = _projectiles[u];
				}
			}
			
			if(_projectile_left_point < _enemy_left_point && _projectile_right_point > _enemy_left_point){
				if(_projectile_top_point > _enemy_top_point && _projectile_bottom_point < _enemy_top_point){
					_proj = _projectiles[u];
				}
			}
			
			if(_projectile_left_point < _enemy_right_point && _projectile_right_point > _enemy_right_point){
				if(_projectile_top_point > _enemy_top_point && _projectile_bottom_point < _enemy_top_point){
					_proj = _projectiles[u];
				}
			}
			
			if(_projectile_left_point < _enemy_left_point && _projectile_right_point > _enemy_left_point){
				if(_projectile_top_point > _enemy_bottom_point && _projectile_bottom_point < _enemy_bottom_point){
					_proj = _projectiles[u];
				}
			}
			
			if(_projectile_left_point < _enemy_right_point && _projectile_right_point > _enemy_right_point){
				if(_projectile_top_point > _enemy_bottom_point && _projectile_bottom_point < _enemy_bottom_point){
					_proj = _projectiles[u];
				}
			}
		}
		
		if(_proj != noone && !array_contains(_enemy.hit_by_list, _proj)){
			array_push(_enemy.hit_by_list, _proj)
			_enemy.code.health -= _proj.code.damage;
		}
		
		if(_enemy.code.health <= 0 && !_enemy.code.dead){
			_enemy.code.dead = true;
			WORLD.play_sound("Explosion");
			//PARTICLES.add_particle(_enemy.position.x, _enemy.position.y, 1,ExplosionParticle(_enemy.position.x, _enemy.position.y, 1));
			_enemy.position = new Vec2(-128, -128);
			get(ComponentSpriteRenderer).set_position(_enemy.sprite, _enemy.position.x, _enemy.position.y)
		}
	}
}