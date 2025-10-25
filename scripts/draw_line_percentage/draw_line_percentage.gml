/// @param {real} x1
/// @param {real} y1
/// @param {real} x2
/// @param {real} y2
/// @param {real} w
/// @param {real} p
function draw_line_percentage(_x1,_y1,_x2,_y2,_w,_p){

	//get the distance between the two points

	var _xd = _x2 - _x1;
	var _yd = _y2 - _y1;
	
	//divide these distances by the percentage variable
	
	_xd /= _p;
	_yd /= _p;
	
	//then draw the line as desired
	
	draw_line_width(_x1,_y1,_x2 + _xd, _y2 + _yd,_w)
}