function BladeManBoss() : BaseBoss() constructor{
	self.dialouge = [
		{   sentence : "Youre a mean one Mr. Grinch",
			mugshot_left : "x",
			mugshot_right : "x",
			focus : "left"
		}
	];
	
	
	self.image_folder = "boss";
	self.subdirectories = ["/normal","/blade"];
	
	self.pose_animation_name = "blade_fall";
	self.intro_animation_name = "blade_fall";
	
	self.add_states = function(_player){
		
		with(_player){
			self.get(ComponentPhysics).set_grav(new Vec2(0,0.25));
			self.pose_animation_name = "blade_fall";
			self.intro_animation_name = "blade_fall";
			self.timer = -1;
			fsm.add("idle", { 
					enter: function(){
						self.face_player();
						self.publish("animation_xscale", self.dir);
						self.publish("animation_play", { name: "blade_pose" });
						//log(find("animation").subdirectories)
					}
				})
		}
	}
}