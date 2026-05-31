
if(__input_string_contains(player.components.get(ComponentPlayerMove).fsm.get_current_state(), "zipline") && close_enough){
	var _offsets = JSON.load(working_directory + "sprites/" + global.availible_characters[global.character_index].image_folder + "/offset.json")
				
	var _offset = new Vec2(-20,-11);
				
	for(var e = 0; e < array_length(_offsets); e++){
		if(_offsets[e].name == player.components.get(ComponentPlayerMove).find("animation").animation.__animation && variable_struct_exists(_offsets[e],"zipline"))	{
			var _frame = clamp(player.components.get(ComponentPlayerMove).find("animation").animation.__frame, 0, array_length(_offsets[e].zipline) - 1)
				_offset = new Vec2(_offsets[e].zipline[_frame].x, _offsets[e].zipline[_frame].y)
		}
	}
	
	var _offx = 8
	var _offy = 11
	
	_offy += player.y + _offset.y - 16
	var _dir = player.components.get(ComponentPlayerMove).dir;
	_offx += floor(player.x) + (_dir * _offset.x) + _dir * _offx - _offx
	var _rot = end_point.angle();
	
	pal.apply()
	
	draw_sprite_ext(za_handlebar,0, _offx, _offy, _dir, 1, _rot, c_white, 1)
	
	pal.reset()
	
	var _pal = variable_clone(global.availible_characters[global.character_index].zipline_palette);
	draw_set_color(c_black)
}