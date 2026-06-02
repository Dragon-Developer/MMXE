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
		
		log(string(is_in_range(2,1,3)) + " RANGE TEST");
	}
	
	self.locate_enemy = function(_reference){
		for(var p = 0; p < array_length(enemies); p++){
			if enemies[p].code == _reference
				return enemies[p]
		}
		
		return undefined
	}
	
	self.find_nearest_enemy = function(_x, _y){
		var _ret = enemies[0]
		for(var p = 0; p < array_length(enemies); p++){
			var _rxoff = abs(_ret.position.x - _x);
			var _ryoff = abs(_ret.position.y - _y);
		
			var _exoff = abs(enemies[p].position.x - _x);
			var _eyoff = abs(enemies[p].position.y - _y);
			if ((_rxoff + _ryoff) < (_exoff + _eyoff))
				_ret = enemies[p]
		}
		
		return _ret
	}
	
	self.get_animation_frame = function(_reference){
		for(var p = 0; p < array_length(enemies); p++){
			if enemies[p].code == _reference
				return get(ComponentSpriteRenderer).sprites[enemies[p].sprite].animationController.__frame
		}
		
		return undefined
	}
	
	self.change_enemy_animation = function(_enemy, _animation){
		for(var p = 0; p < array_length(enemies); p++){
			if enemies[p].code == _enemy{
				get(ComponentSpriteRenderer).change_sprite(enemies[p].sprite, _animation)
				return true
			}
		}
		
		return false
	}
	
	self.create_enemy = function(_x, _y,_dir,  _code){
		var _enemy = {};
		
		struct_set(_enemy, "position", new Vec2(_x,_y));
		struct_set(_enemy, "initial_position", new Vec2(_x,_y));
		struct_set(_enemy, "code", {});
		struct_set(_enemy, "struct", _code);
		struct_set(_enemy, "hit_by_list", []);
		struct_set(_enemy.code, "start_time", CURRENT_FRAME);
		
		with(_enemy.code){script_execute(_code)}
		
		_enemy.code.dir = _dir;
		_enemy.dir = _dir;
		_enemy.flash = false;
		
		if(variable_struct_exists(_enemy.code, "create"))
			_enemy.code.create(_enemy.position);
		
		struct_set(_enemy, "sprite", get(ComponentSpriteRenderer).add_sprite(_enemy.code.sprite,false,  _x, _y, _dir));
		//log(_enemy.sprite)
		struct_set(_enemy, "hitbox", _enemy.code.hitbox_scale);
		struct_set(_enemy, "hitbox_offset", _enemy.code.hitbox_offset);
		
		array_push(self.enemies, _enemy);
		
		_enemy.code.init(_enemy.position);
		
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
			if(_enemy.flash == 1) {
				get(ComponentSpriteRenderer).swap_sprite(_enemy.sprite, c_white, 1, _enemy.dir, 1, shader_palette_light);
				_enemy.flash = 2;
			} else if(_enemy.flash == 2) {
				_enemy.flash = 3;
			} else if(_enemy.flash == 3) {
				get(ComponentSpriteRenderer).swap_sprite(_enemy.sprite, c_white, 1, _enemy.dir, 1, undefined);
				_enemy.flash = 0;
			} 
			
			_enemy.code.step(_enemy.position);
			self.get_collision(_enemy);
		})
		
		for(var p = 0; p < array_length(self.enemies); p++){
			for(var k = 0; k < array_length(self.to_delete); k++){
				if(enemies[p] == to_delete[k]){
					//reset the enemy
					
					if(!onscreen(enemies[p]))
						respawn_enemy(enemies[p])
				}
			}
		}
		
		if (keyboard_check_pressed(ord("3"))) {draw_enabled = !draw_enabled;}
	}
	
	self.respawn_enemy = function(_enemy){
		_enemy.position = _enemy.initial_position;
		with(_enemy.code){script_execute(_enemy.struct)}
	}
	
	self.onscreen = function(_enemy){
		
		var _near_player = false;
		for(var p = 0; p < instance_number(obj_player); p++){
			var _plr = instance_find(obj_player, p);
				
			if(_plr.x - GAME_W < _enemy.position.x &&
				_plr.x + GAME_W > _enemy.position.x &&
				_plr.y - GAME_W < _enemy.position.y &&
				_plr.y + GAME_W > _enemy.position.y)
					_near_player = true
		}
		
		return _near_player;
	}
	
	self.draw = function(){
		array_foreach(self.enemies, function(_enemy){
			get(ComponentSpriteRenderer).set_position(_enemy.sprite, _enemy.position.x, _enemy.position.y)
			get(ComponentSpriteRenderer).swap_sprite(_enemy.sprite, c_white, 1, _enemy.dir)
			
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
			
			//detect projectiles within the enemy
			if(is_in_range(floor(_enemy_left_point), _projectile_left_point, _projectile_right_point) || is_in_range(floor(_enemy_right_point), _projectile_left_point, _projectile_right_point)){
				if(is_in_range(floor(_enemy_top_point), _projectile_top_point, _projectile_bottom_point) || is_in_range(floor(_enemy_bottom_point), _projectile_top_point, _projectile_bottom_point)){
					cause_projectile_collision(_enemy, _projectiles[u])
				}
			}
			
			//detect enemies within the projectile
			if(is_in_range(floor(_projectile_left_point), _enemy_left_point, _enemy_right_point) || is_in_range(floor(_projectile_right_point), _enemy_left_point, _enemy_right_point)){

				if(is_in_range(floor(_projectile_top_point), _enemy_bottom_point, _enemy_top_point) || is_in_range(floor(_projectile_bottom_point), _enemy_bottom_point, _enemy_top_point)){
					cause_projectile_collision(_enemy, _projectiles[u])
				}
			}
		}
		
		if(_proj != noone){
			
		}
		
		if(_enemy.code.health <= 0 && !_enemy.code.dead){
			_enemy.code.dead = true;
			_enemy.code.destroy();
			WORLD.play_sound("Explosion");
			WORLD.spawn_particle(new ExplosionParticle(_enemy.position.x, _enemy.position.y - 16, 1));
			_enemy.position = new Vec2(-128, -128);
			get(ComponentSpriteRenderer).set_position(_enemy.sprite, _enemy.position.x, _enemy.position.y)
		}
	}
	
	self.cause_projectile_collision = function(_enemy, _proj){
		if(!array_contains(_enemy.hit_by_list, _proj) && !array_contains(_proj.code.tag, "enemy")){
				if(!_proj.code.super_piercing)
					array_push(_enemy.hit_by_list, _proj)
					
				if(array_length(_enemy.code.weaknesses) > 0){
					var _hits = false;
					for(var e = 0; e < array_length(_enemy.code.weaknesses); e++){
						if(_proj.constructor ==_enemy.code.weaknesses[e].projectile){
							_enemy.code.health -= _proj.code.damage * _enemy.code.weaknesses[e].rate;
							log("hit by weakness")
							_hits = true;
						} else {
							log("not a weakness!")
							log(_proj.constructor)
							log(_enemy.code.weaknesses[e].projectile)
						}
					}
					
					if !_hits
						_enemy.code.health -= _proj.code.damage;
				} else {
					_enemy.code.health -= _proj.code.damage;
				}
				
				_enemy.flash = 1;
				WORLD.play_sound("small_damage");
				
				if(global.settings.hit_numbers){
					var _num = instance_create_depth(_enemy.position.x, _enemy.position.y - _enemy.hitbox.y / 2 + _enemy.hitbox_offset.y, -15000, obj_damage_number);
					_num.number = _proj.code.damage
				}
				
				if((!_proj.code.piercing || _enemy.code.health > 0) && !_proj.code.super_piercing)
					PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(_proj.code)
			}
	}
}