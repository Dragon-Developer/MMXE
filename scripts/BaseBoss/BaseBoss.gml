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
		var _inst = EnemyComponent.instance;
		log(_inst)
		var _ret = _inst.components.get(ComponentPhysics)//.check_place_meeting(_inst.x, _inst.y + 1, obj_square_16);
		log(_ret)
		if(_ret)
			EnemyComponent.fsm.change("pose")
	}
	
	self.pose_animation_name = "flame_stag_idle";
	
	self.add_states = function(_boss){
		_boss.add("idle", { });
	}
}