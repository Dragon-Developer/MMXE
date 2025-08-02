function ComponentInteractibleContact() : ComponentBase() constructor{
	self.interacted = false;
	
	self.Interacted_Script = function() {
		log("This Interactible has no interact script defined!")
	}
	
	self.on_register = function() {
		self.subscribe("components_update", function() {
			self.physics = self.parent.find("physics") ?? new ComponentPhysicsBase();
		});
	}
	
	self.step = function(){
		var _inst = self.get_instance();
		if(self.physics.check_place_meeting(_inst.x, _inst.y, obj_player) && !self.interacted){
			self.Interacted_Script();
			self.interacted = true;
		}
	}
	
	self.Interacted_Step = function(){
		
	}
}