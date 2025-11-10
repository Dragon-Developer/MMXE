if(other.components.get(ComponentPlayerInput).get_input_pressed("up")){
	log("Player Input!");
	array_foreach(player_list, function(_player, _index){
		if(_player == other.components.get_instance()){
			players_accepted[_index] = true;
			log("done fucked up BOY")
		} else {
			log(_player)
			log(other.components.get_instance())
		}
	})
}
