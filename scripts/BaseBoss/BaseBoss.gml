function BaseBoss() : BaseEnemy() constructor{
	self.dialouge = [
		{   sentence : "boss error!",
			mugshot_left : X_Mugshot_Happy1,
			mugshot_right : X_Mugshot1,
			focus : "left"
		}
	];
	
	self.enter_init = function(){
		//do init related things here. this is varied enough to be placed here
	}

	self.enter_step = function(){
		
	}
	
	self.pose_animation_name = "idle";
	
	
}