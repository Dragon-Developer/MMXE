event_inherited();
entity_object = obj_player;
on_spawn = function(_player) {
	_player.components.get(EntityComponentAnimation).set_subdirectories([
	"/normal", "/armor/x2/arms", "/armor/x2/body", "/armor/x3/legs"
	]);
	_player.components.publish("character_set", "x");
	_player.components.publish("armor_set", ["x2_arms", "x2_body", "x3_legs"]);

	var _camera = ENTITIES.create_instance(obj_camera);
	_camera.components.publish("target_set", _player);
}