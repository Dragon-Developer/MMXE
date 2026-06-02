function ComponentDamageable() : ComponentBase() constructor{
	self.add_tags("damageable");
	//get the physics 
	self.health = 1;//the amount of health this entity has
	self.health_max = 1;
	self.combo_count = 0;//the amount of comboiness this entity has been hit with
	self.combo_offset = 0;//some enemies take more or less comboiness from projectiles
	self.damage_rate = 1;//the amount that damage gets multiplied by
	self.damage_offset = 0;//taken damage is subtracted from this number
	self.dead = false;
	self.hit_amount = 0;//the amount of times this thing got hit
	
	self.invuln_offset = -1;//if its -1 the invuln timer is over
	self.invuln_time = 150//150;//the time offset in frames that invulnerability lasts for
	self.red_health_active = false;
	self.red_health_nuggets = 0;
	self.red_hp_is_additive = false;
	self.red_health_percentage = 0.6;
	self.red_health_timer = -1;
	self.red_health_interval = 180;
	
	self.physics = noone;//physics is used to detect collisions with projectiles.
	self.plays_sound_on_hit = false;//so players dont activate the on hit 
	self.bright = false;
	self.take_boss_damage = false;
	self.immune_to_damage_zones = false;
	self.super_armor = false;
	self.invulnerable = false;
	
	self.projectile_tags = ["player"];// projectiles will have an associated tag to check
	// if they actually hurt the hurtable
	self.weaknesses = []
	
	self.hit_by_list = [];
	
	self.invincibility_type = "damage"
	
	self.serializer = new NET_Serializer();
	/*self.serializer
		.addVariable("health")
		.addVariable("health_max")
		.addVariable("combo_count")
		.addVariable("invuln_offset")
		.addVariable("invuln_time")*/
	
	self.on_register = function() {
		self.subscribe("components_update", function() {
			self.physics = self.parent.find("physics") ?? new ComponentPhysicsBase();
		});
	}
	
	self.init = function(){ }
	
	self.heal = function(_count){
		if(_count + self.health > self.health_max){
			_count = self.health_max - self.health;
		}
		self.health += _count;
	}
	
	self.add_max_health = function(_add){
		self.health_max += _add;
		self.health += _add;
	}
	
	self.set_health = function(_health, _maxHealth = self.health_max){
		self.health = _health;
		self.health_max = _maxHealth;
	}
	
	self.set_damage_rate = function(_rate){
		self.damage_rate = _rate;
	}
	
	self.step = function(){
		
		if(self.get_instance() == noone || self.get_instance() == undefined) return;
		
		if(instance_exists(obj_player)){
			if(self.get_instance().mask_index == -1){
				self.get_instance().mask_index = spr_player_mask;	
			}
		}
		
		if(red_health_timer > 0 && CURRENT_FRAME > red_health_timer && red_health_nuggets > 0){
			red_health_nuggets -= 1;
			self.health += 1;
			red_health_timer += red_health_interval
		}
		
		if(self.invuln_offset > CURRENT_FRAME) {
			switch(self.invincibility_type){
				case("sting"):
				
				break;
				
				default:
					if(CURRENT_FRAME % 2 == 0 && bright)
						array_push(find("animation").shaders,"flash")
					else if(CURRENT_FRAME % 2 == 0)
						array_push(find("animation").shaders,"gone")
					else if(array_length(find("animation").shaders) > 1)
						array_pop(find("animation").shaders)
				break;
			}
		} else if(self.invuln_offset == CURRENT_FRAME){
			while(array_length(find("animation").shaders) > 1){
				array_pop(find("animation").shaders)
			}
			self.hit_by_list = [];
			self.invincibility_type = "damage"
		}
		if !invulnerable
		self.check_for_collision();
	}
	
	self.check_for_collision = function(){
		if(self.damage_rate == undefined || !variable_struct_exists(self, "damage_rate")) self.damage_rate = 1;
		
		if(damage_rate <= 0 || dead) return;//cant take damage if your damage rate is below or at zero.
		//anything times zero is zero
		
		var _damage = 0;
		_damage += self.check_for_projectiles();
		_damage += self.check_for_enemies();
		_damage += self.check_for_bosses();
		_damage += self.check_for_damage_zones();
		
		_damage -= damage_offset;
		
		if(get(ComponentPlayerMove)){
			_damage *= (global.settings.difficulty + 1) / 2;
			
			if(_damage > self.health_max && DIFF == 0)//ohko protection for easy mode
				_damage = self.health_max - 1;
		}
		
		self.health -= _damage <= 0 ? 0 : max(ceil(_damage * damage_rate), 1)
		
		if(_damage > 0){
			if(plays_sound_on_hit)
				WORLD.play_sound("big_damage");
			hit_amount++;
			self.publish("took_damage", _damage);//so other components dont need to hook into this to get info
			
			if(red_health_active){
				if red_hp_is_additive{
					red_health_nuggets = floor(red_health_nuggets / 2)
					red_health_nuggets += floor(_damage * red_health_percentage * damage_rate);
				} else
					red_health_nuggets = floor(_damage * red_health_percentage * damage_rate);
				red_health_timer = CURRENT_FRAME + red_health_interval
			}
				
			if(global.settings.hit_numbers){//no damage number setting
				var _inst = self.get_instance()
				var _num = instance_create_depth(_inst.x, _inst.y - 32, -15000, obj_damage_number);
				_num.number = ceil(_damage * damage_rate);
			}
		}
		
		if(self.health <= 0)
		{
			dead = true;
			self.death_function();
		}
	}
	
	self.take_damage = function(_damage){
		if(self.damage_rate == undefined || !variable_struct_exists(self, "damage_rate")) self.damage_rate = 1;
		
		if(damage_rate <= 0 || dead) return;//cant take damage if your damage rate is below or at zero.
		
		if(self.invuln_offset > CURRENT_FRAME){
			return 0;
		}
		
		if(get(ComponentPlayerMove)){
			_damage *= (global.settings.difficulty + 1) / 2;
			
			if(_damage > self.health_max && DIFF == 0)//ohko protection for easy mode
				_damage = self.health_max - 1;
		}
		
		self.health -= _damage == 0 ? 0 : max(ceil(_damage * damage_rate), 1)
		self.invuln_offset = CURRENT_FRAME + self.invuln_time;
		
		if(_damage != 0){
			if(plays_sound_on_hit)
				WORLD.play_sound("big_damage");
			hit_amount++;
			self.publish("took_damage", _damage);//so other components dont need to hook into this to get info
				
			if(global.settings.hit_numbers){//no damage number setting
				var _inst = self.get_instance()
				var _num = instance_create_depth(_inst.x, _inst.y - 32, -15000, obj_damage_number);
				_num.number = ceil(_damage * damage_rate);
			}
		}
		
		if(self.health <= 0)
		{
			dead = true;
			self.death_function();
		}
	}
	
	self.death_function = function(){
		ENTITIES.destroy_instance(self.get_instance());
	}
	
	self.check_for_projectiles = function(){//seperated because this will definitely be expanded later
		//place_meeting takes all masks into account, so I only need the one
		var _proj = false;
		
		var _projectiles = PROJECTILES.components.get(ComponentProjectileManager).projectiles;
		
		for(var u = 0; u < array_length(_projectiles); u++){
			var _test = get_struct_based_object_position(_projectiles[u]);
			if(_test != -1){
				_proj = _test
			}
		}
		
		if(_proj == false) return 0;
		
		var _hits = false;
		for(var g = 0; g < array_length(self.projectile_tags); g++){
			for(var h = 0; h < array_length(_proj.code.tag); h++){
				if(_proj.code.tag[h] == self.projectile_tags[g])
					_hits = true;
			}
		}
		
		if !_hits return 0;
		
		if(self.invuln_offset > CURRENT_FRAME && _proj.code.comboiness >= 0 && _proj.code.comboiness <= self.combo_count) || array_contains(self.hit_by_list, _proj){
			//if the comboiness is too high and the projectile is not comboy enough
			return 0;
		}
		
		if(_proj.code.damage > 0){
			if(array_length(weaknesses) > 0 && variable_struct_exists(_proj, "constructor")){
				var _hits = false;
				for(var e = 0; e < array_length(weaknesses); e++){
					if(_proj.constructor == weaknesses[e].projectile){
						_proj.code.damage *= weaknesses[e].rate
						self.publish("hit_by_weakness",)
					} else {
					}
				}
			}
			
			if(variable_struct_exists(_proj.code, "invuln_rate"))
				self.invuln_offset = CURRENT_FRAME + (self.invuln_time * _proj.code.invuln_rate);
			else
				self.invuln_offset = CURRENT_FRAME + self.invuln_time;
			self.combo_count = _proj.code.comboiness;
			if(!_proj.code.super_piercing)
				array_push(self.hit_by_list, _proj)
			if((!_proj.code.piercing || self.health > 0) && !_proj.code.super_piercing)
				PROJECTILES.components.get(ComponentProjectileManager).destroy_projectile(_proj.code)
				
			if(take_boss_damage)
				return _proj.code.boss_damage;
			else 
				return _proj.code.damage;
		}
		return 0;
	}

	self.check_for_enemies = function(){
		//place_meeting takes all masks into account, so I only need the one
		var _enemy = false;
		
		var _enemies = ENEMIES.components.get(ComponentEnemyManager).enemies;
		
		for(var u = 0; u < array_length(_enemies); u++){
			var _test = get_struct_based_object_position(_enemies[u]);
			if(_test != -1){
				_enemy = _test
			}
		}
		
		if(_enemy == false) return 0;
		
		if(self.invuln_offset > CURRENT_FRAME) || array_contains(self.hit_by_list, _enemy){
			//if the comboiness is too high and the projectile is not comboy enough 
			return 0;
		}
		
		if(_enemy.code.contact_damage > 0){
			self.invuln_offset = CURRENT_FRAME + self.invuln_time;
			array_push(self.hit_by_list, _enemy)
			return _enemy.code.contact_damage;
		}
		return 0;
	}
	
	self.check_for_bosses = function(){
		if(self.get_instance() == par_boss) return;
		
		var _enemy = self.physics.get_place_meeting(self.get_instance().x,self.get_instance().y,par_boss);
		
		if(!variable_instance_exists(_enemy, "components")){ 
			return 0;
		}
		
		if(self.invuln_offset > CURRENT_FRAME){
			return 0;
		}
		
		if(_enemy.components.get(ComponentBoss).contact_damage > 0){
			self.invuln_offset = CURRENT_FRAME + self.invuln_time;
			return _enemy.components.get(ComponentBoss).contact_damage;
		}
		return 0;
	}
	
	self.check_for_damage_zones = function(){
		var _zone = self.physics.get_place_meeting(self.get_instance().x,self.get_instance().y,obj_hurt_zone);
		
		if(!variable_instance_exists(_zone, "contact_damage")){ 
			return 0;
		}
		
		if(self.invuln_offset > CURRENT_FRAME){
			return 0;
		}
		
		if(immune_to_damage_zones && !_zone.ignores_defense) return 0;
		
		if _zone.ignores_defense {
			self.health -= 1;
			return _zone.contact_damage / self.damage_rate - 1;
		}
		
		self.invuln_offset = CURRENT_FRAME + self.invuln_time;
		return _zone.contact_damage;
	}
}