entity_object = noone;
spawn_times = 1;
spawn = function() {
	var _inst = ENTITIES.create_instance(entity_object);
	_inst.x = x;
	_inst.y = y;
	
	var str = "";
	var array = variable_instance_get_names(id);
	show_debug_message("Variables for " + object_get_name(object_index) + string(id));
	for (var i = 0; i < array_length(array); i++;)
	{
	    str = array[i] + ":" + string(variable_instance_get(id, array[i]));
	    show_debug_message(str);
	}
	
	on_spawn(_inst);
}

on_spawn = function(_inst) {}