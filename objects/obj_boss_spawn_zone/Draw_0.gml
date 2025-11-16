//draw_sprite(sprite_index,0,x,y)

draw_string(string(players_accepted),x,y - 8,"pause menu")
draw_string(string(players_accepted),x + 1,y - 8, "orange")

var _all_accepted = true;
for(var p = 0; p < array_length(players_accepted); p++){
	if(players_accepted[p] == false){
		_all_accepted = false;
	}
}

if(_all_accepted){
	with(par_boss){
		components.get(ComponentBoss).fsm.change("enter")
	}
	
	with(obj_door){
		components.get(ComponentDoor).curr_player = undefined;
	}
	
	instance_destroy(self)
}