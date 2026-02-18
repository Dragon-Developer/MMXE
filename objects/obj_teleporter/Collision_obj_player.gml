/// @description Insert description here
// You can write your code in this editor
randomize();
_random = random_range(0,array_length(vector2));
other.x = vector2[_random].x;
other.y = vector2[_random].y;
with(obj_camera)
{
	x = other.vector2[other._random].x;
	y = other.vector2[other._random].y;
}
