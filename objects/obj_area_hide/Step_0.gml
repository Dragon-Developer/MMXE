if(!instance_exists(obj_player)) return;

var _plr = instance_nearest(x,y,obj_player)
var _expand = false;

if(is_in_range(_plr.x, x, x + width)){
	if(is_in_range(_plr.y, y, y + height)){
		_expand = true;
	}
} 

if(_expand){
	radius = clamp(radius + radius_change_rate, 0, radius_max);
} else {
	radius = clamp(radius - radius_change_rate, 0, radius_max);
}