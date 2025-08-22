if(transition_data.opacity > 0){
	transition_data.opacity += 1 / transition_data.visual_rate;
	draw_sprite_ext(transition_data.sprite, 0, 0, 0, 1, 1,0, c_white, transition_data.opacity);
	
	if(transition_data.opacity > 1){
		transition_data.visual_rate *= -1;
		room_goto(transition_data.room)
	}
} else if(transition_data.opacity < 0 && transition_data.transitioning){
	transition_data.transitioning = false;
}