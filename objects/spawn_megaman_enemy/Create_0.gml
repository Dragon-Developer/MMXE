event_inherited();
entity_object = obj_megaman_enemy;
on_spawn = function(_inst) {
	_inst.components.get(EntityComponentAnimation).set_subdirectories(["/normal"]);
	_inst.components.publish("character_set", "megaman");
}