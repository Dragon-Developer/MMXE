if(countdowning){
	if(timer_delay > 0){
		timer_delay--;
	
	} else {
		timer_delay = timer_delay_default
		timer_count--;
		if timer_count == 0{
			WORLD.play_sound("race_start")
			countdowning = false;
			start_time = CURRENT_FRAME;
			return;
		} else {
			WORLD.play_sound("rolling_shield_dink")
		}
	}
	if(timer_count != 0)
		draw_sprite_ext(spr_text_font_normal, 15 + timer_count, GAME_W / 2, GAME_H / 2, 
			timer_delay / timer_delay_default * 5 + 10, timer_delay / timer_delay_default * 5.5 + 12, 
			0, c_white, 1 - abs(timer_delay - timer_delay_default / 2) / timer_delay_default / 2)
		
} else if(laps_left >= 0){
	if(timer_paused){
		start_time += (CURRENT_FRAME - prev_frame);
	}
	
	prev_frame = CURRENT_FRAME;
	
	var _mins = (CURRENT_FRAME - start_time) / (60 * 60);
	var _secs = ((CURRENT_FRAME - start_time) / 60) mod 60;
	var _frames = (CURRENT_FRAME - start_time) mod 60;
	
	if(_mins < 10)
		_mins = "0" + string(floor(_mins));
	else
		_mins = string(floor(_mins));
	
	if(_secs < 10)
		_secs = "0" + string(floor(_secs));
	else
		_secs = string(floor(_secs));
		
	if(_frames < 10)
		_frames = "0" + string(_frames)
	else
		_frames = string(_frames)
	
	draw_string(_mins + ":" + _secs + "." + _frames, 2,2)
	final_time = CURRENT_FRAME - start_time;
} else {
	
	var _mins =   (final_time) / (60 * 60);
	var _secs =  ((final_time) / 60) mod 60;
	var _frames = (final_time) mod 60;
	
	if(_mins < 10)
		_mins = "0" + string(floor(_mins));
	else
		_mins = string(floor(_mins));
	
	if(_secs < 10)
		_secs = "0" + string(floor(_secs));
	else
		_secs = string(floor(_secs));
		
	if(_frames < 10)
		_frames = "0" + string(_frames)
	else
		_frames = string(_frames)
	
	draw_string(_mins + ":" + _secs + "." + _frames, 2,2, "pause_menu")
	draw_string(_mins + ":" + _secs + "." + _frames, 2,2, "orange")
	
	if(CURRENT_FRAME >= start_time + final_time + 120){
		room_transition_to(rm_race_lobby, "st", 30)
		instance_destroy(self);
	}
}