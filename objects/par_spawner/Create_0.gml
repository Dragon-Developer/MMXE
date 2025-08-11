entity_object = noone;
spawn_times = 1;
spawn = function() {
	var _inst = ENTITIES.create_instance(entity_object);
	_inst.x = x;
	_inst.y = y;
	on_spawn(_inst);
	on_creation_spawn(_inst);
}

on_spawn = function(_inst) {}

on_creation_spawn = function(_inst) {}