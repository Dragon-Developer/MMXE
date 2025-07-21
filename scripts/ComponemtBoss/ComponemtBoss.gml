function ComponemtBoss() : ComponentBase() constructor{
	
	self.has_done_dialouge = false;
	self.boss_data = new FlameStagBoss();//for example purposes
	
	self.init = function(){
		//this has to be here. the game crashes otherwise
		self.publish("animation_play", { name: "idle" });
		
	}
	
	self.step = function() {
		//we do not need transitions because 
		if (self.fsm.event_exists("step"))
			self.fsm.step();
	}
	
	self.fsm = new SnowState("enter", false);
	self.fsm
		.add("enter", {
			enter: function() {
				boss_data.enter_init();
			},
			step: function() {
				boss_data.enter_step();
			}
		})
		.add("pose", {
			enter: function() {
				self.publish("animation_play", { name: boss_data.pose_animation_name });
			},
			step: function() {
				//if the pose animation is finished, then make the healthbar,
				// fill it, then move to idle and free the player
			}
		})
		.add("idle", { })
		.add("die", {
			enter: function() {
				//die is the only function that is the exact same accross bosses
			},
			step: function() {
				//therefore it may be more effective to have a boss_death_type instead
			}
		})
	
	self.on_register = function() {
		//animation_end is fairly important. 
	}
	
	/*
		how to handle death/intro/dialouge
		
		have a FSM that has four states:
			- enter [handles the animation of entering the boss arena and the idle that follows]
			- pose [handles the pose the boss strikes and adding the associated healthbar]
			- fight [whatever the boss actually does against the player. 
					very simple, just reference the associated boss struct]
			- die [handles the boss death, associated screen fade and handling 
					the player's associated reactions]
	*/
}