var _surf = surface_create(width, height);
surface_set_target(_surf);
draw_clear(color);

if(instance_exists(obj_player)){
	gpu_set_blendequation(bm_eq_subtract)
	var _plr = instance_nearest(x,y,obj_player)
	draw_circle(_plr.x - x, _plr.y - y, radius, false);
	gpu_set_blendequation(bm_eq_add)
}
surface_reset_target();

draw_surface(_surf, x, y)

surface_free(_surf);
