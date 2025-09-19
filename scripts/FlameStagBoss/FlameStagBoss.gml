function FlameStagBoss() : BaseBoss() constructor{
	self.dialouge = [
		{   sentence : "Youre a mean one Mr. Grinch",
			mugshot_left : X_Mugshot_Happy1,
			mugshot_right : X_Mugshot1,
			focus : "left"
		}
	];
	self.enter_init = function(_par){
		_par.publish("animation_play", { name: "idle" });
	}
	
	self.add_states = function(_fsm){
		
		with(_fsm){
			self.pose_animation_name = "mach_hold";
			self.attack_states = ["dash", "jump", "walkdown"]
			fsm.add("idle", { 
					enter: function(){
						self.face_player();
						self.publish("animation_xscale", self.dir);
						self.publish("animation_play", { name: "idle" });
						
						var _rand = random_range(0,array_length(self.attack_states));
						self.fsm.change(self.attack_states[_rand]);
					}
				})
			.add("dash", {
				enter: function(){
					self.publish("animation_play", { name: "dash" });
					self.get(ComponentPhysics).set_hspd(3.25 * self.dir)
				}, 
				step: function(){
					//self.get_instance().x += self.dir * 3.25;
				},
				leave: function(){
					self.get(ComponentPhysics).set_hspd(0)
				}
			})
			.add("jump",{
				enter: function(){
					self.publish("animation_play", { name: "jump" });
					
					self.get(ComponentPhysics).set_vspd(-6);
					//self.get(ComponentPhysics).set_grav(0.5)
				},
				step: function(){
					self.get(ComponentPhysics).set_vspd(self.get(ComponentPhysics).get_vspd() + 0.25);
				},
				leave: function(){
					self.get(ComponentPhysics).set_vspd(0);
				}
			})
			.add("fall",{
				enter: function(){
					self.publish("animation_play", { name: "fall" });
				}
			})
			.add("walkdown", {
				enter: function(){
					self.publish("animation_play", { name: "walk" });
						self.get(ComponentPhysics).set_hspd(2 * self.dir)
				}, 
				leave: function(){
					self.get(ComponentPhysics).set_hspd(0)
				}
			})
			.add_transition("t_transition", ["dash", "walkdown"], "idle", function()
				{return self.get_instance().components.get(ComponentPhysics).check_place_meeting(self.get_instance().x + self.dir * 12, self.get_instance().y, obj_square_16)
			})
			.add_transition("t_transition", "fall", "idle", function()
				{return self.get_instance().components.get(ComponentPhysics).is_on_floor()
			})
			.add_transition("t_transition", "jump", "fall", function()
				{return self.get(ComponentPhysics).get_vspd >= 0
			})
		}
	}
}