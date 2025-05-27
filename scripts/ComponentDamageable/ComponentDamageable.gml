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
		var _hit = self.check_for_collision();
		
		if(self.invuln_offset < CURRENT_FRAME) return;
		
		if(_hit){
			self.invuln_offset = CURRENT_FRAME + self.invuln_time;
		}
	}
	
	self.check_for_collision = function(){//seperated because this will definitely be expanded later
		return self.physics.check_place_meeting(self.get_instance().x,self.get_instance().y,self.physics.objects.projectile);
	}
}