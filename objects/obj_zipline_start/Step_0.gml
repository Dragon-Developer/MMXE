if player == undefined {
	player = instance_nearest(0,0,obj_player);
}

var _incline = end_point.y / end_point.x;
var _vertical_offset = (player.x - self.x) * _incline

_top_point = (end_point.y <= 0 ? y : y + end_point.y) - grip_range
_bottom_point = (end_point.y > 0 ? y : y + end_point.y) + grip_range
_left_point = (end_point.x > 0 ? x : x + end_point.x) - grip_range
_right_point = (end_point.x <= 0 ? x : x + end_point.x) + grip_range


close_enough = (is_in_range(player.x, self.x - grip_range, self.x + end_point.x + grip_range) && 
	is_in_range(player.y - 16, self.y - grip_range, self.y + end_point.y + _vertical_offset + grip_range))

if end_point.x == 0 {
	_top_point = (end_point.y > 0 ? y : y + end_point.y) - grip_range
	_bottom_point = (end_point.y < 0 ? y : y + end_point.y) + grip_range
	_left_point = (x) - grip_range
	_right_point = (x) + grip_range
	
	if(player.y > _top_point + 16 && player.y < _bottom_point + 16
		&& player.x > _left_point && player.x < _right_point){
			close_enough = true;
		} else {
			close_enough = false;
		}
}



