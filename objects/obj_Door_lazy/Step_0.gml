//back to basics ig

if(activated){
	switch(state_segment){
		case(1):
		//open the door. graphics can wait.
		if(time_offset < CURRENT_FRAME){//this will trigger when animation end is called
			state_segment++;  
			curr_player.components.get(ComponentAnimation).animation.__speed = 1;
			coll.y -= 1025;
		} else {
			curr_cam.x += image_xscale * 0.5;
			camera_total_movement -= image_xscale * 0.5;
		}
		
		break;
		case(2):
		
		with(instance_nearest(x,y,obj_player)){
			if(instance_place(x,y,obj_Door_lazy)){
				x += other.image_xscale * 0.5;
				other.curr_cam.x += other.image_xscale * 2;
				other.camera_total_movement -= other.image_xscale * 2;
			} else {
				other.state_segment++;
				other.time_offset = CURRENT_FRAME + other.time_delay;
				components.get(ComponentPlayerMove).fsm.change("idle");
				components.get(ComponentPhysics).grav = new Vec2(0, 0.25); 
			}
		}
		
		break;
		case(3):
		if(camera_total_movement <= 0){
			coll.y = y;
			curr_cam.x  -= camera_total_movement;
			state_segment = -1;
			activated = false;
			curr_player.components.get(ComponentPlayerMove).locked = false;
			with(obj_camera){
				components.get(ComponentCamera).target = other.curr_player;
			}
		} else {
			curr_cam.x += image_xscale * 3;
			camera_total_movement -= image_xscale * 3;
		}
		break;
	}
}