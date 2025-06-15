if(!activated){
	
	if(!multidirectional){
		if(image_xscale > 0){
			if(other.x > x)
				return;
		} else {
			if(other.x < x)
				return;
		}
	}
	
	
	
	activated = true;
	state_segment = 1;
	time_offset = CURRENT_FRAME + time_delay;
	
	//freeze player fsm
	//freeze player animations (set speed to zero)
	curr_player = other;
	curr_player.components.get(ComponentPlayerMove).locked = true;
	curr_player.components.get(ComponentPhysics).velocity = new Vec2(0, 0); 
	curr_player.components.get(ComponentPhysics).grav = new Vec2(0, 0); 
	curr_player.components.get(ComponentAnimation).animation.__speed = 0;
	with(obj_camera){
		components.get(ComponentCamera).target = noone;
		other.curr_cam = components.get(ComponentCamera);
	}
	camera_total_movement = GAME_W;
}