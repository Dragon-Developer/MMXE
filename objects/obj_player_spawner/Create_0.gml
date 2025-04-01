event_inherited();
entity_object = obj_player;
on_spawn = function(_player) {
	_player.components.get(EntityComponentAnimation).set_subdirectories(["/normal", "/armor/x2"]);
	_player.components.publish("character_set", "x");

	var _camera = ENTITIES.create_instance(obj_camera);
	_camera.components.publish("target_set", _player);
}