function BaseBoss() : BaseEnemy() constructor{
	self.dialouge = [
		{   sentence : "boss error!",
			mugshot_left : "x",
			mugshot_right : "x",
			focus : "left"
		}
	];
	
	self.enter_init = function(){
		//do init related things here. this is varied enough to be placed here
	}

	self.enter_step = function(){
		var _inst = EnemyComponent.instance;
		var _ret = _inst.components.get(ComponentPhysics)//.check_place_meeting(_inst.x, _inst.y + 1, obj_square_16);
		if(_ret)
			EnemyComponent.fsm.change("pose")
	}
	
	self.intro_animation_name = "flame_stag_idle";
	self.pose_animation_name = "flame_stag_idle";
	
	self.image_folder = "boss";
	self.subdirectories = ["/blade"];
	
	self.add_states = function(_boss){
		_boss.add("idle", { });
	}
}