function ComponentRide() : ComponentPlayerMove() constructor{
	self.pilot = noone;
	self.ride_cooldown = 0;
	self.states = {
		walk: {
			speed: 1.5,	
		},
		dash: {
			speed: 3.5,	
			interval: 32
		},
		jump: {
			strength: 1363/256
		},
		wall_jump: {
			strength: 5
		}
	}
	
	self.step = function(){
		var _inst = self.get_instance();
		
		if(self.physics.check_place_meeting(_inst.x,_inst.y,all) && self.ride_cooldown <= 0){
			log("e?")
			self.pilot = self.physics.get_place_meeting(_inst.x,_inst.y,all);
			self.input = self.pilot.components.find("input");
			self.pilot.components.publish("enter_ride", self.get_instance());
		}
		
		if(self.pilot != noone){
			self.pilot.x = self.get_instance().x;
			self.pilot.y = self.get_instance().y - 21;
			if(self.input.get_input_pressed("jump") && self.input.get_input("up")){
				self.pilot.components.publish("exit_ride", true);
				self.input = new ComponentPlayerInput();
				self.pilot = noone;
				self.ride_cooldown = 15;
			}
		}
		self.default_step();
		
		self.ride_cooldown = max(self.ride_cooldown - 1, 0);
	}
}