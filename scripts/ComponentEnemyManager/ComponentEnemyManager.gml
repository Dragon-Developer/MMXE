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
		array_foreach(self.enemies, function(_enemy){
			_enemy.code.step(_enemy.position);
		})
		
		for(var u = 0; u < array_length(enemies); u++){
			self.get_collision(enemies[u]);
			log("checkin")
		}
		
		if (keyboard_check_pressed(ord("3"))) {draw_enabled = !draw_enabled;}
	}
	self.draw = function(){
		array_foreach(self.enemies, function(_enemy){
			if(!_enemy.code.dead)
			get(ComponentSpriteRenderer).set_position(_enemy.sprite, _enemy.position.x, _enemy.position.y)
			
			draw_string(_enemy.code.health, _enemy.position.x, _enemy.position.y - 32)
			
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
		//check every hitbox 
		var _inst = self.get_instance();
		_inst.x = _object.position.x + _object.hitbox_offset.x;
		_inst.y = _object.position.y + _object.hitbox_offset.y;
		
		_inst.image_xscale = _object.hitbox_scale.x
		_inst.image_yscale = _object.hitbox_scale.y
		
		var _proj = false;
		var _projectiles = PROJECTILES.components.get(ComponentProjectileManager).projectiles;
		
		for(var u = 0; u < array_length(_projectiles); u++){
			var _test = get_struct_based_object_position(_projectiles[u]);
			if(_test != -1){
				_proj = _test
			}
		}
		
		if(_proj){
			log("e")
			_object.code.health -= _proj.code.damage;
		}
		
		if(_object.code.health <= 0){
			_object.position.add(new Vec2(0, -100000))
		}
	}
}