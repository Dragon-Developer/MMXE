function PlayerSnowStateSetup(){
	self.fsm = new SnowState("intro");
	
	self.fsm.add("intro", {
		enter: function() {
			//
		},
		step: function() {
			self.hdir = self.input.get_input("right") - self.input.get_input("left");
			self.publish("animation_play", { name: "intro2" });
			if(self.fsm.get_time(false) > 28){
				self.fsm.change("idle");
			}
		},
		draw: function() {
			//
		}
	});
	
	self.fsm.add("idle", {
		enter: function() {
			//
		},
		step: function() {
			self.hdir = self.input.get_input("right") - self.input.get_input("left");
			self.publish("animation_play", { name: "idle" });
			
		},
		check: function() {
			if(self.hdir != 0){
				self.fsm.change("walk");
			}
			
			if(self.input.get_input("up")){
				self.fsm.change("jump");
			}
		},
		draw: function() {
			//
		}
	});
	
	self.fsm.add("jump", {
		enter: function() {
			//
		},
		step: function() {
			self.publish("animation_play", { name: "jump" });
		},
		draw: function() {
			//
		}
	});
	
	self.fsm.add("fall", {
		enter: function() {
			//
		},
		step: function() {
			//
		},
		draw: function() {
			//
		}
	});
	
	self.fsm.add("land", {
		enter: function() {
			//
		},
		step: function() {
			//
		},
		draw: function() {
			//
		}
	});
	
	self.fsm.add("walk", {
		enter: function() {
			//
		},
		step: function() {
			self.hdir = self.input.get_input("right") - self.input.get_input("left");
			
			self.publish("animation_play", { name: "walk" });
			var _inst = parent.get_instance();
			_inst.x += self.hdir * 1.5;
			
			if(self.hdir == 0){
				self.fsm.change("idle");
			} else {
				self.publish("animation_xscale", self.hdir);
			}
		},
		draw: function() {
			//
		}
	});
}