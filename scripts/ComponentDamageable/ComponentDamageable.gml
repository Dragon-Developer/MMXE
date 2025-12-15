function ComponentDamageable() : ComponentBase() constructor{
	self.add_tags("damageable");
	//get the physics 
	self.health = 1;//the amount of health this entity has
	self.health_max = 1;
	self.combo_count = 0;//the amount of comboiness this entity has been hit with
	self.combo_offset = 0;//some enemies take more or less comboiness from projectiles
	self.damage_rate = 1;//the amount that damage gets multiplied by
	self.dead = false;
	
	self.invuln_offset = -1;//if its -1 the invuln timer is over
	self.invuln_time = 60;//the time offset in frames that invulnerability lasts for
	
	self.physics = noone;//physics is used to detect collisions with projectiles.
	
	self.projectile_tags = ["player"];// projectiles will have an associated tag to check
	// if they actually hurt the hurtable
	
	self.hit_by_list = [];
	
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
	
	self.init = function(){
		
	}
	
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
	
	self.step = function(){
		
		if(self.get_instance() == noone || self.get_instance() == undefined) return;
		
		//log(self.physics.check_place_meeting(self.get_instance().x, self.get_instance().y, obj_player))
		if(instance_exists(obj_player)){
			//log(self.get_instance().mask_index)
			if(self.get_instance().mask_index == -1){
				self.get_instance().mask_index = spr_player_mask;	
			}
		}
		self.get_instance().visible = true;
		
		//log(self.invuln_offset < CURRENT_FRAME)
		
		if(self.invuln_offset > CURRENT_FRAME) {
			if((self.invuln_offset - CURRENT_FRAME) % 2 == 0)
				self.get_instance().visible = false;
		} else if(self.invuln_offset == CURRENT_FRAME){
			self.hit_by_list = [];
		}
		
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
		
		self.health -= _damage
		//floor(_damage * self.damage_rate);
		
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
			var _test = get_projectile_collision(_projectiles[u]);
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
			self.publish("took_damage", self.health);//so other components dont need to hook into this to get info
			self.invuln_offset = CURRENT_FRAME + self.invuln_time;
			self.combo_count = _proj.code.comboiness;
			array_push(self.hit_by_list, _proj)
			return _proj.code.damage;
		}
		return 0;
	}

	self.check_for_enemies = function(){
		if(self.get_instance() == par_enemy) return;
		
		var _enemy = self.physics.get_place_meeting(self.get_instance().x,self.get_instance().y,self.physics.objects.enemy);
		
		if(!variable_instance_exists(_enemy, "components")){ 
			return 0;
		}
		
		if(!variable_instance_exists(_enemy.components, "get")){ 
			return 0;
		}
		
		if(self.invuln_offset > CURRENT_FRAME){
			return 0;
		}
		
		if(_enemy.components.get(ComponentEnemy).contact_damage > 0){
			self.invuln_offset = CURRENT_FRAME + self.invuln_time;
			self.publish("took_damage", self.health);//so other components dont need to hook into this to get info
			log("hit by enemy")
			log(_enemy.components.get(ComponentEnemy).contact_damage)
			log(object_get_name(_enemy.object_index))
			return _enemy.components.get(ComponentEnemy).contact_damage;
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
			self.publish("took_damage", self.health);//so other components dont need to hook into this to get info
			log("hit by enemy")
			log(_enemy.components.get(ComponentBoss).contact_damage)
			log(object_get_name(_enemy.object_index))
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
		
		//if(_zone.contact_damage > 0){
			self.invuln_offset = CURRENT_FRAME + self.invuln_time;
			self.publish("took_damage", self.health);//so other components dont need to hook into this to get info
			//log("hit by zone")
			return _zone.contact_damage;
		//}
		//return 0;
	}
}