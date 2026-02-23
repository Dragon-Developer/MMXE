event_inherited();

pickup_data = new HeartTankPickup();

if(variable_struct_exists(global.player_data, "heart_tanks")){
	if(variable_struct_exists(global.player_data.heart_tanks, room_get_name(room))){
		instance_destroy(self);
	}
}