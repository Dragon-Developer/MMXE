function ComponentHealable() : ComponentBase() constructor{
	//deviating from my original plans a bit
	//im going to do all healing stuff in here
	//
	
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
		
		_data.apply(self.damageable);
	}
}