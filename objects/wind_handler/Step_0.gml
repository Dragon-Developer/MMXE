with(obj_player){
	switch(other.dir){
		case(-1):
			components.get(ComponentPhysics).move_left(-1)
		break;
		default:
			components.get(ComponentPhysics).move_right(1)
		break;
	}
}

if start_time - CURRENT_FRAME < 0 instance_destroy(self)