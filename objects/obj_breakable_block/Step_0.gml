var _plr = instance_place(x, y + 8, obj_player)
visible = true;

if(shaking){
	with(obj_entity){
		if(variable_struct_exists(components, "__components"))
			array_foreach(components.__components, function(_comp){
				_comp.step_enabled = true;
			})
	}
	y -= 128000;
	//instance_destroy(self);
}

if(_plr){
	if(global.armors[0][0] != 1) return;
	
	with(obj_entity){
		if(variable_struct_exists(components, "__components"))
			array_foreach(components.__components, function(_comp){
				_comp.step_enabled = false;
			})
	}
	
	camera_set_view_pos(view_get_camera(0), camera_get_view_x(view_get_camera(0)) - irandom_range(-1, 1), camera_get_view_y(view_get_camera(0)) - irandom_range(-1, 1));
	
	WORLD.play_sound("rock_break")
	WORLD.spawn_particle(new RockBreakParticle(x, y, 584))
	WORLD.spawn_particle(new RockBreakParticle(x, y, 214))
	WORLD.spawn_particle(new RockBreakParticle(x, y))
	WORLD.spawn_particle(new RockBreakParticle(x, y, 784))
	WORLD.spawn_particle(new RockBreakParticle(x, y, 312))
	WORLD.spawn_particle(new RockBreakParticle(x, y, 634))
	shaking = true;
}
