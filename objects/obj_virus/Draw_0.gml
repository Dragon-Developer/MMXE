var _col = undefined;

var _red = random_range(0,255)
var _green = random_range(0,255)
var _blue = random_range(0,255)


_col = make_color_rgb(_red / 2, _green / 2, _blue / 2);
draw_set_color(_col);

var _radius = random_range(8,14);
draw_circle(x, y, _radius, false)

_col = make_color_rgb(_red, _green, _blue);
draw_set_color(_col);

draw_circle(x, y, _radius - 4, false)