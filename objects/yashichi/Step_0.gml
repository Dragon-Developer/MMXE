var _dist = distance_to_object(instance_nearest(x,y,obj_player))
log(_dist)
if(_dist < 0){
	with(obj_gui){
		transition_fade(rm_stage_select);
	}
	WORLD.stop_music();
}