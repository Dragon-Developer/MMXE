function ComponentHealable() : ComponentBase() constructor{
	//deviating from my original plans a bit
	//im going to do all healing stuff in here
	//
	
	self.sub_tanks = []
	self.sub_tank_limit = 28;
	self.sub_tank_overflow = true;
	
	self.on_register = function() {
		self.subscribe("components_update", function() {
			self.physics = self.parent.find("physics") ?? new ComponentPhysicsBase();
			self.damageable = self.parent.get(ComponentDamageable);
		});
	}
	
	self.detect_pickup = function(){
		var _inst = self.get_instance();
		var _pickup = self.physics.check_place_meeting(_inst.x, _inst.y, par_pickup)
		
		if(!instance_exists(_pickup)) return;
		
		var _data = _pickup.components.get(ComponentPickup).data;
		
		_data.apply(self);
	}
	
	self.heal = function(_count, _pause){
		if(self.damageable.health + _count > self.damageable.health_max){
			self.add_to_sub_tank((self.damageable.health + _count - self.damageable.health_max));
		}
		self.damageable.heal(_count)
	}
	
	self.add_to_sub_tank = function(_count){
		array_foreach(self.sub_tanks, function(_tank, _count = _count){
			if(_tank < self.sub_tank_limit){
				while(_count > 0 && _tank < 28){
					_count--;
					_tank++;
				}
				
				if(_count <= 0)
					return;
			}
		})
	}
}