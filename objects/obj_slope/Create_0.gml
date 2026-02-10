event_inherited();

for(var p = 0; p < 16 * image_xscale; p++){
	instance_create_depth(x + p - 1, y + 16 * image_yscale - p / image_xscale * image_yscale, depth - 1 - p, obj_square_16);
}

var _zone = instance_create_depth(x - 2,y - 2,depth - 2 - p, obj_slope_zone)

_zone.image_xscale = image_xscale * 16 + 4
_zone.image_yscale = image_yscale * 16 + 4