// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function get_struct_based_object_position(_proj){
	var _x = _proj.position.x + (_proj.hitbox_offset.x * _proj.dir);
	var _y = _proj.position.y + _proj.hitbox_offset.y;
	var _width = _proj.hitbox.x;
	var _height = _proj.hitbox.y;
			
	if(collision_rectangle(_x - _width / 2, _y - _height / 2, _x + _width / 2, _y + _height / 2, self.get_instance(), false, true))
		return _proj;
	return -1;
}

function get_struct_to_struct_collision(_struct_1 ,_struct_2){
	var _x1 = _struct_1.position.x + (_struct_1.hitbox_offset.x * _struct_1.dir);
	var _y1 = _struct_1.position.y + _struct_1.hitbox_offset.y;
	var _width1 = _struct_1.hitbox.x;
	var _height1 = _struct_1.hitbox.y;
	
	var _x2 = _struct_2.position.x + (_struct_2.hitbox_offset.x * _struct_2.dir);
	var _y2 = _struct_2.position.y + _struct_2.hitbox_offset.y;
	var _width2 = _struct_2.hitbox.x;
	var _height2 = _struct_2.hitbox.y;
	//
	if (_x1 + _width1 / 2 > _x2 - _width2 / 2 && _x1 - _width1 / 2 < _x2 + _width2 / 2) && (_y1 + _height1 / 2 > _y2 - _height2 / 2 && _y1 - _height1 / 2 < _y2 + _height2 / 2) 
		return true;
	return false;
}

/*
snagged this from the google ai thingy. 

(A.right > B.left && A.left < B.right) && // X-axis overlap
(A.bottom > B.top && A.top < B.bottom)   // Y-axis overlap
*/

function projectile_collision_check(_x, _y, _width, _height, _object){
			
	if(collision_rectangle(_x - _width / 2, _y - _height / 2, _x + _width / 2, _y + _height / 2, _object, false, true))
		return true;
	return false;
}