// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function ECDamageable() : EntityComponentBase() constructor{
	self.hp = 1;
	self.damage_rate = 1;// any damage is multiplied by this. armors would set this to 0.5, for example
	
	self.take_damage = function(_source, _damage){//could probably make this into a single local variable
		self.hp -= _damage * self.damage_rate;
		self.hp = max(self.hp, 0);
		self.publish("damaged");
	}
	self.on_register = function() {
		self.subscribe("components_update", function() {
			self.physics = self.parent.find("physics") ?? new EntityComponentPhysicsBase();
		});
	}
	
	self.step = function(){
		//detect if there is a collision with another entity. 
		//should get physics to use it's collision detection
	}
}