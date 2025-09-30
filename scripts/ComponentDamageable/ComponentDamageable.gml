function ComponentDamageable() : ComponentBase() constructor{
	self.add_tags("damageable");
	//get the physics 
	self.health = 1;//the amount of health this entity has
	self.health_max = 1;
	self.combo_count = 0;//the amount of comboiness this entity has been hit with
	self.combo_offset = 0;//some enemies take more or less comboiness from projectiles
	self.damage_rate = 1;//the amount that damage gets multiplied by
	
	self.invuln_offset = -1;//if its -1 the invuln timer is over
	self.invuln_time = 60;//the time offset in frames that invulnerability lasts for
	
	self.physics = noone;//physics is used to detect collisions with projectiles.
	
	self.projectile_tags = ["player"];// projectiles will have an associated tag to check
	// if they actually hurt the hurtable
	
	self.serializer = new NET_Serializer();
	self.serializer
		.addVariable("health")
		.addVariable("health_max")
		.addVariable("combo_count")
		.addVariable("invuln_offset")
	
	self.on_register = function() {
		self.subscribe("components_update", function() {
			self.physics = self.parent.find("physics") ?? new ComponentPhysicsBase();
		});
	}
	
	self.init = function(){
		
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
		}
		
		self.check_for_collision();
	}
	
	self.check_for_collision = function(){
		self.check_for_projectiles();
		self.check_for_enemies();
		self.check_for_bosses();
		self.check_for_damage_zones();
		
		if(self.health <= 0)
		{
			self.death_function();
		}
	}
	
	self.death_function = function(){
		ENTITIES.destroy_instance(self.get_instance());
	}
	
	self.check_for_projectiles = function(){//seperated because this will definitely be expanded later
		//place_meeting takes all masks into account, so I only need the one
		var _proj = PROJECTILES.get_collision(self.get_instance())
		if(_proj == false) return;
		log(_proj)
		
		var _hits = false;
		for(var g = 0; g < array_length(self.projectile_tags); g++){
			if(_proj.code.hurtable_tag == self.projectile_tags[g])
				_hits = true;
		}
		
		if !_hits return;
		
		if(self.invuln_offset > CURRENT_FRAME && _proj.code.comboiness <= self.combo_count){
			//if the comboiness is too high and the projectile is not comboy enough
			return;
		}
		
		if(_proj.code.damage > 0){
			self.health -= _proj.code.damage;
			self.publish("took_damage", self.health);//so other components dont need to hook into this to get info
			self.invuln_offset = CURRENT_FRAME + self.invuln_time;
			self.combo_count = _proj.code.comboiness;
			log("hit by projectile")
		}
		
	}

	self.check_for_enemies = function(){
		if(self.get_instance() == par_enemy) return;
		
		var _enemy = self.physics.get_place_meeting(self.get_instance().x,self.get_instance().y,self.physics.objects.enemy);
		
		if(!variable_instance_exists(_enemy, "components")){ 
			return;
		}
		
		if(self.invuln_offset > CURRENT_FRAME){
			return;
		}
		
		if(_enemy.components.get(ComponentEnemy).contact_damage > 0){
			self.health -= _enemy.components.get(ComponentEnemy).contact_damage;
			self.invuln_offset = CURRENT_FRAME + self.invuln_time;
			self.publish("took_damage", self.health);//so other components dont need to hook into this to get info
			log("hit by enemy")
			log(_enemy.components.get(ComponentEnemy).contact_damage)
			log(object_get_name(_enemy.object_index))
		}
	}
	
	self.check_for_bosses = function(){
		if(self.get_instance() == par_boss) return;
		
		var _enemy = self.physics.get_place_meeting(self.get_instance().x,self.get_instance().y,par_boss);
		
		if(!variable_instance_exists(_enemy, "components")){ 
			return;
		}
		
		if(self.invuln_offset > CURRENT_FRAME){
			return;
		}
		
		if(_enemy.components.get(ComponentBoss).contact_damage > 0){
			self.health -= _enemy.components.get(ComponentBoss).contact_damage;
			self.invuln_offset = CURRENT_FRAME + self.invuln_time;
			self.publish("took_damage", self.health);//so other components dont need to hook into this to get info
			log("hit by enemy")
			log(_enemy.components.get(ComponentBoss).contact_damage)
			log(object_get_name(_enemy.object_index))
		}
	}
	
	self.check_for_damage_zones = function(){
		var _zone = self.physics.get_place_meeting(self.get_instance().x,self.get_instance().y,obj_hurt_zone);
		
		if(!variable_instance_exists(_zone, "contact_damage")){ 
			return;
		}
		
		if(self.invuln_offset > CURRENT_FRAME){
			return;
		}
		
		if(_zone.contact_damage > 0){
			self.health -= _zone.contact_damage;
			self.invuln_offset = CURRENT_FRAME + self.invuln_time;
			self.publish("took_damage", self.health);//so other components dont need to hook into this to get info
			log("hit by zone")
		}
	}
}