var _plr = instance_nearest(x,y,obj_player);

if !instance_exists(_plr) return;

move_towards_point(_plr.x, _plr.y, 32 / distance_to_object(_plr))