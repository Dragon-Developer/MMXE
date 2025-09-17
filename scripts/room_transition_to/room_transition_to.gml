function room_transition_to(_room, _type = "fade"){
	//dont ask why this is shit. i dont know why
	switch(_type){
		default:
		with(obj_gui){
			transition_fade(_room);
		}
		break;
		
		case "white to black":
		with(obj_gui){
			transition_white_to_black(_room);
		}
		break;
	}
}
//this is just here to make it easier to call transition_fade. 