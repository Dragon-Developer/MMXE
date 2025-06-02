function ComponentDamageable() : ComponentBase() constructor{
	//get the physics 
	self.health = 1;//the amount of health this entity has
	self.combo_count = 0;//the amount of comboiness this entity has been hit with
	self.combo_offset = 0;//some enemies take more or less comboiness from projectiles
	
	self.invuln_offset = -1;//if its -1 the invuln timer is over
	self.invuln_time = 60;//the time offset in frames that invulnerability lasts for
	
	self.physics = noone;//physics is used to detect collisions with projectiles.
	
	self.on_register = function() {
		self.subscribe("components_update", function() {
			self.physics = self.parent.find("physics") ?? new ComponentPhysicsBase();
		});
	}
	
	self.init = function(){
		
	}
	
	self.step = function(){
		
		//log(self.physics.check_place_meeting(self.get_instance().x, self.get_instance().y, obj_player))
		if(instance_exists(obj_player)){
			//log(self.get_instance().mask_index)
			if(self.get_instance().mask_index == -1){
				self.get_instance().mask_index = spr_player_mask;	
			}
		}
		
		//log(self.invuln_offset < CURRENT_FRAME)
		
		if(self.invuln_offset > CURRENT_FRAME) return;
		
		self.check_for_collision();
		
		//log("im here")
		if(1 == 0){
			self.invuln_offset = CURRENT_FRAME + self.invuln_time;
		}
	}
	
	self.check_for_collision = function(){//seperated because this will definitely be expanded later
		//place_meeting takes all masks into account, so I only need the one
		var _proj = self.physics.get_place_meeting(self.get_instance().x,self.get_instance().y,self.physics.objects.projectile);
		
		//log(_proj)
		
		if(!variable_instance_exists(_proj, "components")) return;
		//log("hit")
		if(_proj.components.get(ComponentProjectile).weaponCreate.damage > 0){
			self.health -= _proj.components.get(ComponentProjectile).weaponCreate.damage;
			self.publish("took damage", self.health);//so other components dont need to hook into this to get info
		}
		if(self.health < 0)
		{
			ENTITIES.destroy_instance(self.get_instance());
		}
		if(_proj!=noone || _proj != undefined)
		{
			log("ded");
		}
		else
		{
			log("unded");
		}
	}
}