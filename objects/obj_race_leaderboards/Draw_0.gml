draw_rectangle(x,y - 1, x + 128, y + array_length(player_times) * 20 + 6, false)

for(var g = 0; g < array_length(player_times);g++){
	
	var _time = max(player_times[g], 0)
	
	var _mins = _time / (60 * 60);
	var _secs = (_time / 60) mod 60;
	var _frames = _time mod 60;
	
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
	
	draw_string_condensed((_mins + ":" + _secs + "." + _frames) + ", ~" + string(player_money[g]), x,y + g * 20);
	draw_string_condensed(string(player_names[g]), x,y + g * 20 + 10);
}