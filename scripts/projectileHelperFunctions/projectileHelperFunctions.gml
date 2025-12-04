// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function get_projectile_collision(_proj){
	var _x = _proj.position.x;
	var _y = _proj.position.y;
	var _width = _proj.hitbox.x;
	var _height = _proj.hitbox.y;
			
	if(collision_rectangle(_x - _width / 2, _y - _height / 2, _x + _width / 2, _y + _height / 2, self.get_instance(), false, true))
		return _proj;
	return -1;
}

function projectile_collision_check(_x, _y, _width, _height, _object){
			
	if(collision_rectangle(_x - _width / 2, _y - _height / 2, _x + _width / 2, _y + _height / 2, _object, false, true))
		return true;
	return false;
}