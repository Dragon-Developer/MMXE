function XEConsole_call(_command){
	
	var _cmd = string_lower(_command)
	
	var _data = string_split(_cmd, " ")
	
	switch(_data[0]){
		case("tp"):
			if(array_length(_data) <= 2)
				break;
		
			with(obj_player){
				if(components.get(ComponentPlayerInput).__player_index == _data[1]){
					x = _data[2];
					y = _data[3];
				}
			}
		break;
		
		default:
			log("Invalid Command!")
		break;
	}
}