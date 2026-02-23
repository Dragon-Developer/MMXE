timer--;

if(timer <= 0){
	timer = increase_wait;
	if(func_repeat > 0){
		script_execute(func, damageable);
		WORLD.play_sound("heal_pickup");
	}
	func_repeat--;
	if(func_repeat <= -1){
		with(obj_entity){
			if(variable_struct_exists(components, "__components"))
				array_foreach(components.__components, function(_comp){
					_comp.step_enabled = true;
				})
		}
		
		instance_destroy(self);
	}
}