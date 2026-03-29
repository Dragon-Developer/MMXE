function ComponentScoreShowcase() : ComponentBase() constructor{
	self.death_time = -1;
	
	self.init = function(){
		get(ComponentAnimation).set_subdirectories([ "/normal"]);
		publish("character_set", global.availible_characters[global.character_index].image_folder);
		publish("animation_play", { name: "walk" });
		self.input = get(ComponentPlayerInput);
		
		log(global.stage_time)
		log(variable_struct_get(global.player_data.beaten_stages, room_get_name(global.stage_Data.room)))
	}
	
	self.draw = function(){
		draw_sprite_ext(spr_npc_mask, 0, get_instance().x, get_instance().y, 1.5, 2, 0, c_white, 0.7)
	}
	
	self.draw_gui = function(){
		if(death_time >= 0){
			death_time++;
			if(death_time >= 24) {visible = false; return;} else get_instance().x += 14;
		}
		
		
		string_foreach("STAGE BEATEN", function(_chr, _ind){
			draw_string(_chr, 74 + _ind * 8, 40 + sin(CURRENT_FRAME / 20 + _ind) * 3, "big")
		})
		
		draw_string(room_get_name(global.stage_Data.room), 80, 80, "big")
		
		var _time = global.stage_time;
		
		var _minutes = floor(_time / 3600);
		var _seconds = floor(_time / 60) % 60;
		var _frames = _time % 60;
		
		if(_minutes < 10) _minutes = "0" + string(_minutes);
		if(_seconds < 10) _seconds = "0" + string(_seconds);
		if(_frames < 10) _frames = "0" + string(_frames);
		
		var _best_time = variable_struct_get(global.player_data.beaten_stages, room_get_name(global.stage_Data.room))
		
		var _best_minutes = floor(_best_time / 3600);
		var _best_seconds = floor(_best_time / 60) % 60;
		var _best_frames = _best_time % 60;
		
		if(_best_minutes < 10) _best_minutes = "0" + string(_best_minutes);
		if(_best_seconds < 10) _best_seconds = "0" + string(_best_seconds);
		if(_best_frames < 10) _best_frames = "0" + string(_best_frames);
		
		draw_string_condensed("Time: ", 88, 96)
		if(_best_time == _time)
			draw_string_condensed(string(_minutes) + ":" + string(_seconds) + "." + string(_frames), 92, 104, "orange")
		else
			draw_string_condensed(string(_minutes) + ":" + string(_seconds) + "." + string(_frames), 92, 104)
		
		
		draw_string_condensed("Best Time: ", 96, 112)
		if(_best_time == _time)
			draw_string_condensed(string(_best_minutes) + ":" + string(_best_seconds) + "." + string(_best_frames), 100, 120, "orange")
		else
			draw_string_condensed(string(_best_minutes) + ":" + string(_best_seconds) + "." + string(_best_frames), 100, 120)
		
		draw_string_condensed("Times Hit: ", 104, 128)
		draw_string_condensed(string(global.hit_count), 108, 136)
		
		draw_string_condensed("Character Used: ", 96, 144)
		draw_string_condensed(global.availible_characters[global.character_index].image_folder, 100, 152)
		
		draw_string_condensed("Total Score: ", 200, 120)
		draw_string_condensed(calculate_score(_time, global.hit_count), 200, 128)
		
		var _verification = string(global.character_index) + string(_time) + string(global.stage_Data.room) + "." + string(GM_build_date);
		
		draw_string_condensed(_verification, 1, 234);
		draw_string_condensed(_verification, 0, 233);
		
		if(self.input.get_input_pressed_raw("shoot") || self.input.get_input_pressed_raw("jump")){
			if(global.dynamo_race)
				room_transition_to(rm_dynamos_hellhole, 0, 24);
			else
				room_transition_to(rm_stage_select, 0, 24);
					
			death_time++;
		}
	}
	
	self.calculate_score = function(_time, _amounts_hit){
		var _score = global.availible_characters[global.character_index].default_score;//1000 is the best score you can get
		
		_score -= sqrt(_time);
		
		_score /= clamp(_amounts_hit / 5, 1, 1000);
		
		return floor(_score);
	}
}