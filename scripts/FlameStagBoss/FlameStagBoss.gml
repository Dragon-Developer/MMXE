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
}