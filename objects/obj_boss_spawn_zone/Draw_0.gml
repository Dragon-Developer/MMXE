//draw_sprite(sprite_index,0,x,y)

var _all_accepted = true;
for(var p = 0; p < array_length(players_accepted); p++){
	if(players_accepted[p] == false){
		_all_accepted = false;
	}
}

if(_all_accepted){
	with(Boss_Spawn_Point){
		spawn_boss();
		log("boss spawned")
	}
	instance_destroy(self)
}