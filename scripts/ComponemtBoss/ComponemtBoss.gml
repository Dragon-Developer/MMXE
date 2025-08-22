function ComponentBoss() : ComponentEnemy() constructor{
	
	self.has_done_dialouge = false;
	self.boss_data = new FlameStagBoss();//for example purposes
	self.instance = self.get_instance();
	
	self.init = function(){
		//this has to be here. the game crashes otherwise
		self.publish("animation_play", { name: "idle" });
	}
	
	self.step = function() {
		if (self.fsm.event_exists("step"))
			self.fsm.step();
	}
	
	self.fsm = new SnowState("enter", true);
	self.fsm
		.add("enter", {
			enter: function() {
				boss_data.enter_init(self);
			},
			step: function() {
				log("steppn")
				boss_data.enter_step();
				log("steppd")
			}
		})
		.add("pose", {
			enter: function() {
				self.publish("animation_play", { name: boss_data.pose_animation_name });
			},
			step: function() {
				//if the pose animation is finished, then make the healthbar,
				// fill it, then move to idle and free the player
			},
			leave: function(){
				with(instance_nearest(self.get_instance().x, self.get_instance().y, obj_player)){
					components.get(ComponentPlayerInput).__locked = false;
				}
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
		self.subscribe("animation_end", function() {
			//do something. will probably add functionality later.	
		});
		self.subscribe("enemy_data_set", function(_dir){
			boss_data = _dir;
			log("step 1")
			EnemyEnum = new boss_data();
			log("step 2")
			EnemyEnum.setComponent(self);
			log("step 3")
			EnemyEnum.init(self.get_instance());
			log("step 4")
			
		});
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