function ComponentEnemyManager() : ComponentBase() constructor{
	self.enemies = [];
	self.to_delete = [];
	self.subdirectories = ["", "/normal"]
	
	self.draw_enabled = false;
	
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
		array_foreach(self.enemies, function(_enemy){
			_enemy.code.step(_enemy.position);
			get(ComponentSpriteRenderer).set_position(_enemy.sprite, _enemy.position.x, _enemy.position.y);
				
			//get every player instance and see if they are within a screen's distance away from the projectile
			//if none return true, kill yourself NOW
			
			var _near_player = false;
			for(var p = 0; p < instance_number(obj_player); p++){
				var _plr = instance_find(obj_player, p);
				
				if(_plr.x - GAME_W < _enemy.position.x &&
					_plr.x + GAME_W > _enemy.position.x &&
					_plr.y - GAME_W < _enemy.position.y &&
					_plr.y + GAME_W > _enemy.position.y)
						_near_player = true
			}
			
			if(!_near_player)
				array_push(to_delete, _enemy);
		})
		
		array_foreach(self.to_delete, function(_enemy){
			for(var p = 0; p < array_length(self.enemies); p++){
				if(self.enemies[p] == _enemy){
					_enemy.shooter.projectile_count--;
					
					get(ComponentSpriteRenderer).clear_sprite(_enemy.sprite);
					array_delete(self.enemies, p,1);
				}
			}
		})
		
		if (keyboard_check_pressed(ord("3"))) {draw_enabled = !draw_enabled;}
	}
	self.draw = function(){
		array_foreach(self.enemies, function(_enemy){
			get(ComponentSpriteRenderer).set_position(_enemy.sprite, _enemy.position.x, _enemy.position.y)
			
			if draw_enabled
			draw_rectangle( (_enemy.hitbox.x / 2) + _enemy.position.x + _enemy.hitbox_offset.x * _enemy.dir,  
				(_enemy.hitbox.y / 2) + _enemy.position.y + _enemy.hitbox_offset.y,
				(_enemy.hitbox.x / -2) + _enemy.position.x + _enemy.hitbox_offset.x * _enemy.dir,  
				(_enemy.hitbox.y / -2) + _enemy.position.y + _enemy.hitbox_offset.y, false)
			
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