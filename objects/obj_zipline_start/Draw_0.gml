//the line
draw_set_color(#ac3232)
draw_line_width(x, y, x + end_point.x, y + end_point.y, 3);
draw_set_color(#d95763)
draw_line_width(x, y, x + end_point.x, y + end_point.y, 1);

//the box at the ends of lines
draw_set_color(#323c39)
draw_rectangle(x - 4, y - 2, x + 4, y + 2, false)
draw_rectangle(x - 4 + end_point.x, y - 2 + end_point.y, x + 4 + end_point.x, y + 2 + end_point.y, false)
draw_set_color(#696a6a)
draw_rectangle(x - 4, y - 1, x + 4, y + 1, false)
draw_rectangle(x - 4 + end_point.x, y - 1 + end_point.y, x + 4 + end_point.x, y + 1 + end_point.y, false)
draw_rectangle(x - 3, y - 2, x + 3, y + 2, false)
draw_rectangle(x - 3 + end_point.x, y - 2 + end_point.y, x + 3 + end_point.x, y + 2 + end_point.y, false)
draw_set_color(#9badb7)
draw_rectangle(x - 3, y - 1, x + 3, y + 1, false)
draw_rectangle(x - 3 + end_point.x, y - 1 + end_point.y, x + 3 + end_point.x, y + 1 + end_point.y, false)

//the little light when youre able to hook on
if close_enough {
var _incline = end_point.y / end_point.x;
var _vertical_offset = (player.x - self.x) * _incline
var _range = player.y - (self.y - player.y) * _vertical_offset
log(_range)
	draw_set_color(#ff0008)
	draw_rectangle(x - 2, y , x + 2, y , false)
	draw_rectangle(x - 2 + end_point.x, y + end_point.y, x + 2 + end_point.x, y + end_point.y, false)
	draw_set_color(#ff9988)
	draw_rectangle(x - 1, y , x + 1, y , false)
	draw_rectangle(x - 1 + end_point.x, y + end_point.y, x + 1 + end_point.x, y + end_point.y, false)
	draw_set_color(c_white)
	draw_point(x, y)
	draw_point(x + end_point.x, y + end_point.y)
}

//reset the color
draw_set_color(c_black)