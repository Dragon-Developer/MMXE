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
	
	self.pose_animation_name = "complete";
	
	self.add_states = function(_fsm){
		with(_fsm){
			fsm.add("idle", { 
					enter: function(){
						self.dir = self.dir * -1;
						self.publish("animation_xscale", self.dir);
						self.publish("animation_play", { name: "idle" });
					}
				})
			.add("dash", {
					enter: function(){
						self.publish("animation_play", { name: "dash" });
					}, 
					step: function(){
						self.get_instance().x += self.dir * 3.25;
					}
				})
			.add_transition("t_transition", "dash", "idle", function()
					{return self.get_instance().components.get(ComponentPhysics).check_place_meeting(self.get_instance().x + self.dir * 12, self.get_instance().y, obj_square_16)
				})
			.add_transition("t_transition", "idle", "dash", function(){return (CURRENT_FRAME mod 90) <= 1})
		}
	}
}