if(other.components.get(ComponentPlayerInput).get_input("up")){
	log("Player Input!");
	array_foreach(player_list, function(_player, _index){
		if(_player == other.components.get_instance()){
			players_accepted[_index] = true;
		}
	})
}

var _let_players_move = false;

with(obj_door){
	if(components.get(ComponentDoor).state_segment == -1){
		_let_players_move = true;
	}
}

if(_let_players_move){
	other.components.get(ComponentPlayerMove).locked = false;
	other.components.get(ComponentPlayerInput).__locked = false;
}