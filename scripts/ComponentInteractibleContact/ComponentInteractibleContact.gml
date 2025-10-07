function ComponentInteractibleContact() : ComponentBase() constructor{
	self.interacted = false;
	self.dies_after_interacting = false;
	
	self.Interacted_Script = function(_player) {
		log("This Interactible has no interact script defined!")
	}
	
	self.on_register = function() {
		self.subscribe("components_update", function() {
			self.physics = self.parent.find("physics") ?? new ComponentPhysicsBase();
		});
	}
	
	self.step = function(){
		var _inst = self.get_instance();
		if(self.physics.check_place_meeting(_inst.x, _inst.y, obj_player)){
			if(!self.interacted){
				self.Interacted_Script(self.physics.get_place_meeting(_inst.x, _inst.y, obj_player));
				self.interacted = true;
				if(dies_after_interacting)
					die();
			}
			self.Interacted_Step();
		}
	}
	
	self.Interacted_Step = function(){
		
	}
	
	self.set_interacted_script = function(_script){
		self.Interacted_Script = _script;
	}
	
	self.die = function(){
		ENTITIES.destroy_instance(self.get_instance());
	}
}