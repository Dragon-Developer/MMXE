event_inherited();
entity_object = obj_editor_panel;
on_spawn = function(_player) {
	var _camera = ENTITIES.create_instance(obj_camera);
	_camera.components.publish("target_set", _player);
}